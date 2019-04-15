# Contributing

Want to hack on MARKET Protocol? Awesome!

MARKET Protocol is an Open Source project and we welcome contributions of all sorts.
There are many ways to help, from reporting issues, contributing code, to helping us improve our community.

Please start by reading about our:

- [Development process](#development-process)
- [Community guidelines](#community-guidelines)
- [Coding style](https://docs.marketprotocol.io/#coding-style)

## Development Process

We follow the [GitFlow](http://nvie.com/posts/a-successful-git-branching-model/) branching model for development.
The latest merged code generally lives in the `develop` branch of each repository. Your development flow should look like:

1. Find an interesting issue and communicate! Please let the `#engineering` Discord channel know what you want to work on
1. Add a comment to the issue so we don't have multiple contributors unintentionally working on the same task.
1. Please include your intended solution and a time frame for completion in the issue.
1. Start with the `develop` branch and create a new feature branch
1. Follow the appropriate [coding style](#coding-style) and write some awesome code
1. See [here](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) for some notes on good commit messages
1. Open a pull request to the `develop` branch, not `master`

## Gitcoin and Bounties

We are very proud users of [Gitcoin](https://gitcoin.co/).  It allows us an easy way to reward our community members
for their hard work contributing to MARKET Protocol.  Additionally, it allows us to gain traction on issues that are a
priority for us to address.  We won't always stake every issue, but if you need a bounty to encourage your participation
on an issue, and there isn't one yet, please reach out on [Discord](https://marketprotocol.io/discord).

There are a few guidelines when using Gitcoin that are worth mentioning

1. Please only `start work` on an issue when you are actually planning on working on it. Don't call dibs before you can allocate time to the issue
1. Please make sure to comment in the issue immediately after starting work so we know your plans for implementation and a timeline.
1. We politely ask that users only have open work on a single bounty at a time, if you have an open bounty that has a PR submitted and would like to tackle another issue, please ask in [Discord](https://marketprotocol.io/discord) before proceeding
1. We will do our best to scope out the issue, but please anticipate some revision requested after you have submitted a PR, we are happy to tip you if these end up well beyond the initial scope
1. Once you have created a PR, please `submit work` on Gitcoin so we are able to pay you out once we have accepted the work

## Coding Style

We use a variety of programming languages in our repositories. When contributing, please follow the existing coding conventions
according to the `CONTRIBUTING.md` file of each repository.   

Project | Link
--------- |  -----------
MARKETProtocol | [MARKETProtocol](https://github.com/MARKETProtocol/MARKETProtocol/blob/develop/.github/CONTRIBUTING.md) 

## Git Flow

We are implementing [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) for our branching model.

[![Git Branching](images/git-branching-model.png)](https://nvie.com/posts/a-successful-git-branching-model/)

### Branching

```
$ git checkout -b feature/my-feature develop
and hotfix branches (prefixed with hotfix/ by convention) off of master:

# hotfix the latest version of master
$ git checkout -b hotfix/hotfix-version-number master

# or hotfix from a specific version
$ git checkout -b hotfix/hotfix-version-number <starting-tag-name>
```

The main trunks which are persistent are `develop` and `master`; `Master` holds the latest release and `develop` 
holds the latest stable development copy.

Contributors create feature branches (prefixed with `feature/` by convention) off of `develop`. 

These new branches are disposable, meaning they have a short lifespan before they are merged back to the main trunks. 
They are meant to encapsulate small pieces of functionality.

### Finishing Branches
 
 ```
 $ git checkout develop
 $ git merge --no-ff feature/my-feature
 $ git branch -d feature/my-feature
 ```
 When a contributor is done with a feature branch, they merge it back into develop, or create a pull request in order
 to have MARKET Protocol core team do so.

 For a hotfix branch, it is merged back into both master and develop so the hotfix carries forward
 
 ```
 $ git checkout master
 $ git merge --no-ff hotfix/hotfix-version-number
 $ git checkout develop
 $ git merge --no-ff hotfix/hotfix-version-number
 $ git branch -d hotfix/hotfix-version-number
 ```
 
### Releases

A `release` branch is created from the stable `develop` branch with a tag.

Using a separate `release` branch allows us to continue developing new features on develop while we fix bugs and add 
finishing touches to a `release` branch.

When we are ready to finish the release, we merge the `release` branch into both `master` and `develop` 
(just like a hotfix) so that all changes carry forward. The `master` branch is tagged at this point as well to mark
the released code.

### Merging

```
$ git merge --no-ff <branch-name>
```

Git flow encourages merging of branches with `--no-ff`

The `--no-ff` option allows you to maintain all of your branch history without leaving a bunch of branches lying around in the current commit of the repository.

```
$ git pull --rebase
```

Similarly, best practice is to pull with `--rebase` to avoid lots of useless merge commits.

You can configure git to do both of these things by default in your .gitconfig 

### git-flow extension

Using the [git-flow extension](http://danielkummer.github.io/git-flow-cheatsheet/) can greatly simplify your life and is recommended 

## Community Guidelines

We want to keep the MARKET Protocol community awesome, growing and collaborative.
We need your help to keep it that way. To help with this we've come up with some general guidelines for the community as a whole:

- Be nice: Be courteous, respectful and polite to fellow community members: no regional, racial, gender, or other abuse
will be tolerated. We like nice people way better than mean ones!

- Encourage diversity and participation: Make everyone in our community feel welcome, regardless of their background
and the extent of their contributions, and do everything possible to encourage participation in our community.

- Keep it legal: Basically, don't get anybody in trouble. Share only content that you own, do not share private
or sensitive information, and don't break laws.

- Stay on topic: Make sure that you are posting to the correct channel and avoid off-topic discussions.
Remember when you update an issue or respond to an email you are potentially sending to a large number of people.
Please consider this before you update. Also remember that nobody likes spam.

Full code of conduct is posted available [here](https://github.com/MARKETProtocol/community/blob/master/guidelines/code-of-conduct.md).

## Community Improvement

MARKET Protocol is just as much about community as it is about our technology.

We need constant help in improving our documentation, building new tools to interface with our platform,
spreading the word to new users, helping new users getting setup and much more.

Please get in touch if you would like to help out. Our `#general` channel on [Discord](https://marketprotocol.io/discord) is a great place to
share ideas and volunteer to help.

## Full Time Positions

MARKET Protocol occasionally hires developers for part time or full time positions.

We have a strong preference for hiring people who have already started contributing to the project.
If you want a full time position on our team, your best shot is to engage with our team and start contributing code.
It is very unlikely that we would offer you a full time position on our engineering
team unless you've had at least a few pull requests merged.
