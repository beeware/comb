from argparse import ArgumentParser
import os
import sys

from github3 import login
from github3.exceptions import GitHubError

from waggle import waggle


def register(
            directory,
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
        from_sha = '0000000000000000000000000000000000000000'

    comparison = repository.compare_commits(from_sha, to_sha)
    if comparison is None:
        print(
            '\n'
            'Unable to compare %s to %s' % (from_sha, to_sha)
        )
        sys.exit(12)

    dirnames = set([
        os.path.dirname(details['filename'])
        for details in comparison.files
        if details['filename'].startswith('tasks/')
        and os.path.isdir(os.path.join(directory, os.path.dirname(details['filename'])))
    ])
    print("Waggling %s..." % ', '.join(sorted(dirnames)))

    # waggle.register(
    #     namespace,
    #     'latest',
    #     region,
    #     aws_access_key_id,
    #     aws_secret_access_key,
    #     dirnames
    # )


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
        '--previous', '-p', dest='from_sha',
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
