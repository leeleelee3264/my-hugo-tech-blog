+++
title = "(en) Make Forked repo to Standalone repo"
date = "2020-09-19"
description = "Make Forked repo to Standalone repo"
tags = ["General"]
+++


<br>
<br> 

> Make Forked repo to Standalone repo. 

<br> 

**Index**
1. Contribution not showing up on forked repo! 
2. Make forked repo to standalone repo
3. Reference

<br> 


# Contribution not showing up on forked repo!
### This started with one day one commit 
It's been a graceful four days since starting one day one commit project. But something weird happen with yesterday commit data. I certainly updated a repo for github.io. I could see the record of it in the repo. 

However, the commit wasn't recording in the contribution table in overview page. This contribution table is everything about one day one commit, so I have to dig in to see what's going wrong.

<br> 

### Answer from Github: How to Contribute forked repo
[[github support -Why are my contributions not showing up on my profile?]](https://docs.github.com/en/github/setting-up-and-managing-your-github-profile/why-are-my-contributions-not-showing-up-on-my-profile)

It doesn't matter how to make contribution for active repository. Forking, coding, adding, committing and pulling with request... The master owner will check on that later. Or you can write issue or asking the owner join you as a collaborator. 

#### But I'm not going to contribute origin repo! 
But these are for actual solution of team repo. (or open source) I'm in different situation. _I just copied this beautiful theme repo to use as my github.io template._ _I'm not going to make real contribution for the repo_. It's read-only archived.

<br> 

# Make your forked repo to standalone repo

_AKA make the forked repo to your own repository._ 

This is the easiest way to fix contribution not showing problem. Thinking this as swap operation between repos!

<br> 

> Step-by-Step 
- `Clone` the repo you want to use as github.io theme. (**Do not fork**)
- `Create` new repo in Github
- `Set remote url` in your local repo (you can skip this if the url already indicate your own github.io repo) to the new repo.
- Git push
- Now you have standalone repo! 

<br> 

My problem was forking the repo at the very first time. Keep in mind cloning github.io repo to use! And normal purpose of repo is okay to fork for sure.

<br> 

# Reference

- [[GitHub: make fork an “own project”]](https://stackoverflow.com/questions/18390249/github-make-fork-an-own-project)
- [[github support]](https://docs.github.com/en/github/setting-up-and-managing-your-github-profile/why-are-my-contributions-not-showing-up-on-my-profile)

