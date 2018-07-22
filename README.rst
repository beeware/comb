Comb
====

A repository of BeeKeeper task configurations used by the BeeWare project.

Getting started
---------------

Create a file named `.env` in your current working directory that contains
the following content::

    AWS_REGION=<Your AWS region (e.g., us-west-2)>
    AWS_ACCESS_KEY_ID=<Your AWS access key>
    AWS_SECRET_ACCESS_KEY=<Your AWS secret access key>

Then, install waggle, and waggle the tasks directory::

    $ pip install waggle
    $ waggle tasks

Or, if you only want *some* of the tasks, you can run::

    $ waggle <path to task>

Advanced usage
--------------

This repository contains a generic set of tasks for Python (including web)
development. If you have specific testing needs, you should fork this
repository, add task definitions that meet your own needs, and waggle those
tasks. You will then be able to reference those task definitions in your
BeeKeeper configurations.

Community
---------

Comb is part of the `BeeWare suite`_. You can talk to the community through:

* `@pybeeware on Twitter`_

* The `pybee/general`_ channel on Gitter.

We foster a welcoming and respectful community as described in our
`BeeWare Community Code of Conduct`_.

Contributing
------------

If you experience problems with Comb, `log them on GitHub`_. If you
want to contribute code, please `fork the code`_ and `submit a pull request`_.

.. _BeeWare suite: http://pybee.org
.. _@pybeeware on Twitter: https://twitter.com/pybeeware
.. _pybee/general: https://gitter.im/pybee/general
.. _BeeWare Community Code of Conduct: http://pybee.org/community/behavior/
.. _log them on Github: https://github.com/pybee/comb/issues
.. _fork the code: https://github.com/pybee/comb
.. _submit a pull request: https://github.com/pybee/comb/pulls
