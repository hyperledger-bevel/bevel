# Contributing

Thank you for your interest to contribute to Hyperledger Bevel!

We welcome contributions to Hyperledger Bevel in many forms, and
there's always plenty to do!

First things first, please review the [Hyperledger Code of Conduct](https://wiki.hyperledger.org/display/HYP/Hyperledger+Code+of+Conduct) before participating and please follow it in all your interactions with the project.

You can contibute to Hyperledger Bevel, as a user or/and as a developer.

##### As a user:

[Making Feature/Enhancement Proposals](https://github.com/hyperledger/bevel/issues/new?assignees=&labels=enhancement&template=feature_request.md&title=)   
[Reporting bugs](https://github.com/hyperledger/bevel/issues/new?assignees=&labels=bug&template=bug_report.md&title=)

##### As a developer:

Consider picking up a [“help-wanted”](https://github.com/hyperledger/bevel/issues?q=is%3Aopen+is%3Aissue+label%3A%22help+wanted%22) or ["good-first-issue"](https://github.com/hyperledger/bevel/issues?q=is%3Aopen+is%3Aissue+label%3A%22good+first+issue%22) task  

If you can commit to full-time/part-time development, then please contact us on our [Discord server](https://chat.hyperledger.org) to work through logistics!

Please visit the
[Developer Pre-requisites](https://hyperledger-bevel.readthedocs.io/en/latest/tutorials/dev-prereq/) followed by [How to Contribute](https://hyperledger-bevel.readthedocs.io/en/latest/contributing/how-to-contribute/) in the docs to learn how to make contributions to this exciting project.

 #### Pull Request Process :

For source code integrity, Hyperledger Bevel GitHub pull requests are accepted from forked repositories only. There are also quality standards identified and documented here that will be enhanced over time.

1. Fork Hyperledger Bevel via Github UI.
2. Clone the fork to your local machine.
3. Complete the desired changes and where possible test locally:
     - Go to `platforms/shared/configuration` directory
     - Go to your changed platform directory like `platforms/r3-corda/configuration` (use respective platform directories)
4. Commit your changes         
     - Make sure you sign your commit using git commit -s for more information see [here](https://gist.github.com/tkuhrt/10211ae0a26a91a8c030d00344f7d11b).
     - Squash all commits to a single commit.
     - Make sure your commit message follows [Conventional Commits syntax](https://www.conventionalcommits.org/en/v1.0.0-beta.4/#specification) and contains the platform changed:
          - `[corda]` for Corda Opensource changes
          - `[corda-ent]` for Corda Enterprise changes
          - `[fabric]` for Hyperledger Fabric changes
          - `[besu]` for Hyperledger Besu changes
          - `[indy]` for Hyperledger Indy changes
          - `[quorum]` for Quorum changes
          - `[shared]` for all common and other changes
5. Push your changes to your feature branch.
6. Initiate a pull request from your fork to the base repository ( `develop` branch, unless it is a critical bug, in that case initiate to the `main` branch)
7. Await DCO & linting quality checks and GitActions to complete, as well as any feedback from reviewers.
8. Work on the feedbacks to revise the PR if there are any comments
9. If not, the PR gets approved, delete feature branch post the merge

## Create local branch

> Whenever you begin work on a new feature or bugfix, it's important that you create a new branch.
1. Clone your fork to your local machine

2. Setup your local fork to keep up-to-date (optional)
   ```
   # Add 'upstream' repo to list of remotes
   git remote add upstream https://github.com/hyperledger/bevel.git
   # Verify the new remote named 'upstream'
   git remote -v
   # Checkout your main branch and rebase to upstream.
   # Run those commands whenever you want to synchronize with main branch
   git fetch upstream
   git checkout main
   git rebase upstream/main
   ```
3. Create your branch.
   ```
   # Checkout the main branch - you want your new branch to come from main
   git checkout main
   # Create a new branch named `<feat-issue_number>` (give simple informative name)
   git branch <feat-issue_number>
   ```
4. Checkout your branch and add/modify files.
   ```
   git checkout <feat-issue_number>
   git rebase main
   # Happy coding !
   ```
5. Commit changes to your branch.
   ```
   # Commit and push your changes to your fork
   git add -A
   git commit -s
   ```
   
   In this way, we can create PR and commit titles accordingly in the future. For example:
   If the issue is a feature for fabric,
   The branch can be feat-000
   And then the PR title can be [fabric] feat: added support for sample_feature
   And then the commit description can be wrriten as following:
   
   ```
   feat(fabric): added support for sample_feature  
   Updated ....  
   Fixed .....  
   Fixes #000
   ```

   ```
   git push origin <feat-issue_number>
   ```
6. Once you've committed and pushed all of your changes to GitHub, go to the page for your fork on GitHub, select your development branch, and click the pull request button.

7. Repeat step 3 to 6 when you need to prepare posting new pull request.

NOTE: Once you submitted pull request to Bevel repository, step 6 is not necessary when you made further changes with `git commit --amend` since your amends will be sent automatically.

NOTE: You can refer original tutorial ['GitHub Standard Fork & Pull Request Workflow'](https://gist.github.com/Chaser324/ce0505fbed06b947d962)

### Directory structure

Whenever you begin to use your codes on Hyperledger Bevel, you should follow the directory strecture on Hyperledger Bevel.
The current directory structure is described as the following:


> - automation/ : This folder contains the Jenkinsfile to deploy DLT Platforms supported by Hyperledger Bevel on a demo environment.
>   - hyperledger-fabric/ : ontains network.yaml file and fabric Jenkinsfile
>   - r3-corda/ : Contains network.yaml file and Jenkinsfile for doorman,networkmap and entire network deployment file.
>   - initcontainer.Jenkinsfile : This file is used to initialize a container with basic configuration. This will be used on both hyperledger and r3-corda platforms.
> - docs/
>    - source/
>         - index.rst : This is the main document. Main function of this document is to serve as a welcome page, and to contain the root of the “table of contents tree” (or toctree).This is one of the main things that Sphinx adds to reStructuredText, a way to connect multiple files to a single hierarchy of documents
>         - conf.py : The configuration directory must contain a file named conf.py. This file (containing Python code) is called the “build configuration file” and contains (almost) all configuration needed to customize Sphinx input and output behavior.
>         - *.md : Create all the markdown file which are referenced in the document tree with the appropriate content.
>    - Makefile
>    - pip-requirements.txt
>    - README.md     
> - platforms/
>     - hyperledger-besu/
>     - hyperledger-fabric/ 
>     - hyperledger-indy/ 
>     - quorum/ 
>     - r3-corda-ent/
>     - r3-corda/ 
>     - shared/ : This folder contains the main playbook (site.yaml), along with some pre-requisite roles, playbooks and other shared roles which are commonly used by all the platforms


---
**NOTE:** If you are a regular contributor, please make sure to take the latest pull from the develop branch everytime before making any pull request, main branch in case of a critical defect / bug.

---

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
