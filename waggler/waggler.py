from argparse import ArgumentParser
import os
import sys

from github3 import login
from github3.exceptions import GitHubError

from waggle import waggle

# This is the commit SHA of the very first commit in the Comb repository.
# If you compare against this commit, you'll get
INITIAL_REPO_SHA = '0baa06e1d6133e499fc5332df4288edb0d9c45d6'


def dependency(namespace, base_dir, dirname):
    """Extract the dependency of the task described in a given directory"""
    with open(os.path.abspath(os.path.join(base_dir, dirname, 'Dockerfile'))) as dfile:
        from_lines = [
            line[5:].strip()
            for line in dfile
            if line.startswith('FROM ')
        ]
        if len(from_lines) == 1:
            if from_lines[0].startswith(namespace + '/'):
                return from_lines[0]

        return None


def register(
            base_dir,
            github_username, github_access_token,
            repository, from_sha, to_sha,
            namespace, tag,
            region, aws_access_key_id, aws_secret_access_key
        ):
    try:
        github = login(github_username, password=github_access_token)
    except GitHubError as ghe:
        print(
            '\n'
            'Unable to log into GitHub: %s' % ghe,
            file=sys.stderr
        )
        sys.exit(10)

    try:
        print('Loading repository %s...' % repository)
        owner, repo_name = repository.split('/')
        repository = github.repository(owner, repo_name)
    except GitHubError as ghe:
        print(
            '\n'
            'Unable to load repository %s: %s' % (repository, ghe),
            file=sys.stderr
        )
        sys.exit(11)

    if from_sha is None:
        from_sha = '0baa06e1d6133e499fc5332df4288edb0d9c45d6'

    comparison = repository.compare_commits(from_sha, to_sha)
    if comparison is None:
        print(
            '\n'
            'Unable to compare %s to %s' % (from_sha, to_sha)
        )
        sys.exit(12)

    # Find all the files in the diff that:
    # * are in the `tasks` subdirectory
    # * are in a directory that contains a Dockerfile
    dirnames = set([
        os.path.dirname(details['filename'])
        for details in comparison.files
        if details['filename'].startswith('tasks/')
        and os.path.isfile(os.path.join(base_dir, os.path.dirname(details['filename']), 'Dockerfile'))
    ])

    dependencies = [
        (dirname, dependency(namespace, base_dir, dirname))
        for dirname in dirnames
    ]
    tasks = set('%s/%s' % (namespace, os.path.basename(d)) for d in dirnames)

    # Now sort the tasks to ensure that dependencies are met. This
    # is done by repeatedly iterating over the input list of tasks.
    # If the dependency of a given task is on the final list,
    # that task is promoted to the end of the final list. This process
    # continues until the input list is empty, or we do a full iteration
    # over the input models without promoting a model to the final list.
    # If we do a full iteration without a promotion, that means there are
    # circular dependencies in the list.
    ordered = []
    resolved = set()
    while dependencies:
        skipped = []
        changed = False
        while dependencies:
            dirname, dep = dependencies.pop()
            task = '%s/%s' % (namespace, os.path.basename(dirname))

            # If the dependency is already on the final model list, or
            # not on the original serialization list, then we've found
            # another model with a satisfied dependency.
            if dep not in tasks or dep in resolved:
                resolved.add(task)
                ordered.append(dirname)
                changed = True
            else:
                skipped.append((dirname, dep))
        if not changed:
            print(
                '\n'
                "Can't resolve dependencies for %s in tasks." %
                ', '.join(
                    '%s/%s' % (namespace, os.path.basename(dirname))
                    for dirname, dep in sorted(skipped)
                )
            )
            sys.exit(13)
        dependencies = skipped

    print("Waggling %s..." % ', '.join(ordered))

    waggle.register(
        namespace,
        tag,
        region,
        aws_access_key_id,
        aws_secret_access_key,
        *ordered
    )


def main():
    "Perform pre-merge checks for a project"
    parser = ArgumentParser()

    parser.add_argument(
        '--username', '-u', dest='github_username', required=True,
        help='The GitHub username to use when updating the project.'),
    parser.add_argument(
        '--repository', '-r', dest='github_repository', required=True,
        help='The name of the repository that contains the pull request.'),
    parser.add_argument(
        '--commit', '-c', dest='to_sha', required=True,
        help='The hash of the commit to be checked.'),
    parser.add_argument(
        '--previous', '-p', dest='from_sha', default=INITIAL_REPO_SHA,
        help='The hash of the previous known-good commit.'),
    parser.add_argument(
        '--tag', '-t', default='latest', dest='tag',
        help='Specify the version tag to use.',
    )
    parser.add_argument(
        '--namespace', default='beekeeper', dest='namespace',
        help='Specify the namespace to use for AWS services.',
    )
    parser.add_argument('directory', metavar='directory',
        help='Path to directory containing code to check.')
    options = parser.parse_args()

    # Load sensitive environment variables from a .env file
    try:
        with open('.env') as envfile:
            for line in envfile:
                if line.strip() and not line.startswith('#'):
                    key, value = line.strip().split('=', 1)
                    os.environ.setdefault(key.strip(), value.strip())
    except FileNotFoundError:
        pass

    try:
        register(
            options.directory,
            options.github_username, os.environ['GITHUB_ACCESS_TOKEN'],
            options.github_repository, options.from_sha, options.to_sha,
            options.namespace, options.tag,
            os.environ['AWS_REGION'],
            os.environ['AWS_ACCESS_KEY_ID'],
            os.environ['AWS_SECRET_ACCESS_KEY'],
        )
    except KeyError as e:
        print("Environment variable %s not found" % e)
        sys.exit(1)


if __name__ == '__main__':
    main()
