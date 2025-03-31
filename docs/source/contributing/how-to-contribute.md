# How to Contribute

## Ways to Contribute

Contributions from the development community help improve the capabilities of Hyperledger Bevel. These contributions are the most effective way to
make a positive impact on the project.

Ways you can contribute:

* Bugs or issues: Report problems or defects found when working with the project (see [Reporting a Bug](./reporting-a-bug.md))
* Core features and enhancements: Provide expanded capabilities or optimizations
* Documentation: Improve existing documentation or create new information
* Tests: Add functional, performance, or scalability tests

Issues can be found in GitHub. Any unassigned items are probably still open. When in doubt, ask on Discord about a specific issue (see [Asking a Question](./asking-a-question.md)). We also use the #good-first-issue tag to represent issues that might be good for first timers.

## The Commit Process

Hyperledger Bevel is Apache 2.0 licensed and accepts contributions via GitHub pull requests. When contributing code, please follow these guidelines:

* Fork the repository and make your changes in a feature branch
* Include unit and integration tests for any new features and updates to existing tests
* Ensure that the unit and integration tests run successfully prior to submitting the pull request.

### Pull Request Guidelines

A pull request can contain a single commit or multiple commits. The most
important guideline is that a single commit should map to a single fix or
enhancement. Here are some example scenarios:

* If a pull request adds a feature but also fixes two bugs, the pull request should have three commits: one commit for the feature change and two commits for the bug fixes.
* If a PR is opened with five commits that contain changes to fix a single issue, the PR should be rebased to a single commit.
* If a PR is opened with several commits, where the first commit fixes one issue and the rest fix a separate issue, the PR should be rebased to two commits (one for each issue).

!!! important

    Your pull request should be rebased against the current main branch. Do not merge the current main branch in with your topic branch. Do not use the Update Branch button provided by GitHub on the pull request page.

### Commit Messages

Commit messages should follow common Git conventions, such as using the imperative mood, separate subject lines, and a line length of 72 characters.  These rules are well documented in [Chris Beam's blog post](https://chris.beams.io/posts/git-commit/#seven-rules).

### Signed-off-by

Each commit must include a "Signed-off-by" line in the commit message (`git commit -s`). This sign-off indicates that you agree the commit satisfies the [Developer Certificate of Origin (DCO)](http://developercertificate.org/).

### Commit Email Address

Your commit email address must match your GitHub email address. For more information, see https://help.github.com/articles/setting-your-commit-email-address-in-git/

### Maintainers
Being a maintainer of a Hyperledger project means taking on a leadership role in overseeing and managing the development, maintenance, and governance of the project. The responsibilities include:

1. Code Review and Merging: Reviewing contributions (pull requests) from the community and deciding which ones should be merged into the project’s codebase.

2. Releasing Updates: Ensuring that the project is updated regularly with bug fixes, new features, and security patches, and managing the release process.

3. Community Engagement: Actively engaging with the project’s community, including addressing issues, participating in discussions, mentoring contributors, and encouraging new participants to get involved.

4. Maintaining Documentation: Keeping the project's documentation accurate, up-to-date, and comprehensive for both developers and users.

5. Project Roadmap and Strategy: Helping to define the vision, roadmap, and direction of the project, ensuring alignment with the overall goals of the LF Decentralized Trust ecosystem.

6. Ensuring Quality and Security: Ensuring that the codebase is secure, high-quality, and adheres to industry best practices.

Being a maintainer requires strong technical expertise, leadership, and a commitment to the project's success and the broader open-source community.

###  Becoming a maintainer
The project's maintainers will, from time-to-time, consider adding a maintainer, based on the following criteria:

- Demonstrated track record of PR reviews (both quality and quantity of reviews)
- Demonstrated thought leadership in the project
- Contributions to the community, such as blog posts, webinars, or demos about the tool, are a plus
- Demonstrated shepherding of project work and contributors
- Demonstrated influential contributions that have notably enhanced the source code.
- Demonstrated through contributions that you have outstanding knowledge and skills in Blockchain technology and the different DLTs under the LF Decentralized Trust ecosystem, automation, and cloud environments to be a maintainer of Bevel.
- An existing maintainer can submit a pull request to the maintainers file. A nominated Contributor may become a Maintainer by a majority approval of the proposal by the existing Maintainers. Once approved, the change set is then merged and the individual is added to the maintainers group.

Maintainers may be removed by explicit resignation, for prolonged inactivity (e.g. 3 or more months with no review comments), or for some infraction of the code of conduct or by consistently demonstrating poor judgement. A proposed removal also requires a majority approval. A maintainer removed for inactivity should be restored following a sustained resumption of contributions and reviews (a month or more) demonstrating a renewed commitment to the project.

### Important GitHub Requirements

A pull request cannot merged until it has passed these status checks:

* The build must pass all checks
* The PR must be approved by at least two reviewers without any
  outstanding requests for changes

## Inclusive Language

- Consider that users who will read the source code and documentation are from different background and cultures and that they have different preferences.
- Avoid potential offensive terms and, for instance, prefer "allow list and deny list" to "white list and black list".
- We believe that we all have a role to play to improve our world, and even if writing inclusive code and documentation might not look like a huge improvement, it's a first step in the right direction.
- We suggest to refer to [Microsoft bias free writing guidelines](https://learn.microsoft.com/en-us/style-guide/bias-free-communication) and [Google inclusive doc writing guide](https://developers.google.com/style/inclusive-documentation) as starting points.

## Credits
This document is based on [Hyperledger Sawtooth's Contributing documentation](https://github.com/hyperledger/sawtooth-docs/blob/main/community/contributing.md).
