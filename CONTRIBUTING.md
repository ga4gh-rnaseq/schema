How to contribute to the RNAget GA4GH Specification
======================================

Thank you for your interest in contributing!

The GA4GH RNAget schema defines an API for sharing RNAseq data.

There are two ways to contribute to the effort - via issues, which are
used for discussion, and pull requests, which are concrete proposals of
change.

Issues
======

The project's [Issues
Page](https://github.com/ga4gh-rnaseq/schema/issues) is a forum to
discuss both major and minor issues related to developing the standards,
formats, and APIs. It also serves as the means for collaborating with
the group and discussing contributions that will ultimately lead to
changes to the formats and APIs. See the [Issue](#issue_resolution)
section below for specifics on how issues are resolved by the community.
Examples of the type of issues that can be submitted are:

-   Identify use cases that will shape the standards and APIs
-   How to add or delete objects and/or object attributes
-   How a particular attribute should be defined
-   Report bugs you encounter when using the reference implementations

Pull Requests
=============

The way to contribute development effort and code to the project is via
GitHub pull requests. GitHub provides a nice [overview on how to create
a pull
request](https://help.github.com/articles/creating-a-pull-request).
Contributions typically require pull requests to each of the schemas,
server and compliance repositories, although pull requests to the server
may merely improve the code without affecting the API, and therefore
changing the schemas or compliance tests. A set of branches across the
repositories each with the same name is a branch set, e.g. the master
branch in each repository forms the master branch set.

Some general rules to follow:
-   Create an issue in Github to track your work and start a conversation. Make a note of the number, you'll
    need it when naming your feature branch below.
-   We follow [HubFlow](https://datasift.github.io/gitflow/) which means we use
    a feature branch strategy with pull requests always going to `develop`
    and releases happening from `develop` and merging into `master`. **Please read the HubFlow guide linked above, it's a quick read and will give you a really good idea of how our branches work. Do not make pull requests to `master`!**
-   Create a "feature" branch for each update that you're working on (either in the main repo or your fork depending
    on the previous step). These branches should start with "feature/issue-[number]-[some-description]". For example
    "feature/issue-123-improving-the-docs".  Most devs will use the HubFlow command line tools to do this however, if you
    make a feature branch in GitHub's UI, then please make sure you follow this naming convention.
-   If you are creating a feature branch in the main repo and you follow this
    convention nice things will happen e.g. TravisCI will check your branch and the documentation and swagger will be built
    for you, see the [README.md](README.md) for how to construct a URL to view these for your feature branch.
-   When you're happy with your feature branch, make a [Pull Request](https://help.github.com/articles/about-pull-requests/)
    in GitHub from your feature branch (or fork with a feature branch) to develop.  Pick at least one other person to review
    and write up a good message that links back to the issue you started this whole process with.
-   If you have multiple related pull requests, coordinate pull requests across the branch set by making them as
    simultaneously as possible, and [cross referencing
    them](http://stackoverflow.com/questions/23019608/github-commit-syntax-to-link-a-pull-request-issue).
-   Keep your pull requests as small as possible. Large pull requests
    are hard to review. Try to break up your changes into self-contained
    and incremental pull requests.
-   The first line of commit messages should be a short (&lt;80
    character) summary, followed by an empty line and then any details
    that you want to share about the commit.
-   Please try to follow the [existing syntax style](#syntax_style)

When you submit or change your pull request, the Travis build system
will automatically run tests to ensure valid schema syntax. If your pull
request fails to pass tests, review the test log, make changes and then
push them to your feature branch to be tested again.

Builds with Travis-CI
=====================

We use Travis for CI testing.  If you create a fork and feature branch
this will not automatically be built from our Travis.  However, if you
are a developer and have created a feature branch following the naming
convention above, you should see automated builds.

Check https://travis-ci.org/ga4gh/data-repository-service-schemas/builds to see the status of the builds.

Pull Request Decision Process
===========================

1) We always have an issue created before a PR, this is where a description and initial conversation takes place.

2) Someone is assigned the issue. They construct one or more pull requests, either by themselves or by asking for help. Multiple pull requests could be used if there are different approaches that need to be explored.

3) PRs are reviewed and voted upon at the RNAget working group calls. We strive to reach consensus, especially with drivers. We ask those voting to reject a proposal give us details why. 

4) We merge or discard the PR depending on the vote results.

Documentation
=============

We use the [gh-openapi-docs](https://github.com/ga4gh/gh-openapi-docs) documentation build system to render HTML doc pages from the source files upon pushes to the repo (triggers a build on Travis CI). Built documentation, even for proposed feature branches, is hosted on the `gh-pages` branch of this repo and is thus available at:

```
https://ga4gh-rnaseq.github.io/schema/preview/{branch}/docs/
```

where `{branch}` is the name of the Github branch.

Releases
========

From time to time the group will make a release, this is done with the HubFlow
release process which generally involves creating a branch
"release-foo", where foo is the release name.  And following the HubFlow
tooling for pushing this to master/develop and tagging in GitHub.
Only bug fixes are allowed to the release branch and the release branch is removed after a successful HubFlow release.
