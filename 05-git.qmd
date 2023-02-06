---
title: "Version Control with `Git`"
format: 
  revealjs:
    theme: _extensions/metropolis-theme/metropolis.scss
    chalkboard: true
    logo: /images/ScPo-logo.png
    footer: ScPo Intro To Programming 2023
    incremental: false
    code-line-numbers: false
    highlight-style: github
author: Florian Oswald and The Software Carpentry
---



::::: {.callout-note}
# Question

* What is Version Control and Why Should I Care?
:::::

::::: {.callout-tip}
# Objectives
- Understand the benefits of an automated version control system.
- Understand the basics of how automated version control systems work.
::::::

---

## Final.doc  

!["Piled Higher and Deeper" by Jorge Cham, http://www.phdcomics.com](/images/phd101212s.png)

---

## Undo

* "track changes" in MS word
* if you accepted the propsed changes of a collaborator, can you go back (if you change your mind?)
* What about Dropbox?


---

## Versions

* PRA prices case study
* something is different today than yesterday but i don't know why
* how to figure out?
* git diff across version/branches
* 




---


## installation and invocation

* setup with user name etc

---

## create repo

---

## workflow definitions

* add, commit, checkout, reset

---

## clone

* make changes
* view in diff

---

## add stuff and view

* diff
* add to staging area but then reset
* add to staging area and then commit
* git diff
* git diff across commits
* git log
* collaborating on github
* define github
* everybody get a user account on github
* everybody create a new repo
* create local text file, commit
* add remote
* push
* look on github
* introduce vscode 
* 



---

## create repo


::::: {.callout-note}
# Question

* Where does Git store information?

:::::

::::: {.callout-tip}
# Objectives
- Create a local repository
- Describe purpose of `.git` directory
::::::


---

## Gas Prices Project

```bash
$ cd    # going to home dir 
$ mkdir gasprices  # create directory
$ cd gasprices 
$ git init
```

* Now the directory `~/gasprices` is endowed with `git` version control. 
* What does that look like?


---

## Where is Git?

* Remember *hidden files* and folders?

```bash
$ ls -a 
./    ../   .git/
```

* Git for this repository resides in `.git`

::: {.callout-warning}

# Danger Zone

* If you _delete_ that folder, the entire version control is GONE. 

:::


---





---

# Tracking Changes with Git



::::: {.callout-note}
# Question

* How do I record changes in Git?
* How do I check the status of my version control repository?
* How do I record notes about what changes I made and why?
:::::

::::: {.callout-tip}
# Objectives
- Understand the benefits of an automated version control system.
- Understand the basics of how automated version control systems work.
::::::




---

## Adding Code and Text

* Notice: Code **is** text.
* Let's add a shell script where we add our pipeline from last week.

1. run to get the raw data again:
```bash
wget https://www.data.gouv.fr/fr/datasets/r/64e02cff-9e53-4cb2-adfd-5fcc88b2dc09 -O ~/gasprices/carburants.csv`
```

2. create a script

```bash
nano maketable.sh  # open nano
# typd this
cd ~/gasprices   # make sure we are in the right place
cut -d ';' -f 5 carburants.csv | tr [:lower:] [:upper:] | sort | uniq -c | sort
# save and exit 
```

3. Does it work?
```bash
ls .
./maketable.sh 
```






---

## Viewing Changes

* Let's 