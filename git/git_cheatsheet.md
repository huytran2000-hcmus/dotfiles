# Note

**refs** are references to some specific commit.  
Each branch have a "ref" file to store its latest commit. This file located at `refs/heads/<branch name>`.  
**HEAD** is the commit that you currently on.  
**HEAD** file is a symbolic reference to the branch that you currently on or contains a commit's SHA-1(in detached HEAD state).

# Initialize

git init  
git clone \<repo url\>  
git clone \<repo url\> \<new directory name\>  
git clone --branch \<branch\> \<repo url\>  
git clone --branch \<branch\> --single-branch \<repo url\> _(not tracking other remote branch)_  
git clone --depth=\<depth of commit\> \<repo url\>

### Get specific folders

mkdir \<dir\>  
cd \<dir\>  
git init  
git remote add origin \<repo url\>  
git config core.sparsecheckout true  
echo \<dir1\>/ \>\> .git/info/sparse-checkout  
echo \<dir2\>/ \>\> .git/info/sparse-checkout  
git pull origin \<remote branch\>

# Config

git config --global user.name \<username\>  
git config --global user.email \<user email\>  
git config --global core.editor \<editor name\>  
git config --global alias.\<alias\> \<command\>

# Branch

git branch  
git branch -a  
git branch -vv  
git branch -M \<new name\>  
git branch -u \<remote branch\> \<local branch\>

# Branching

git switch \<branch\>  
git switch -c \<new branch\>  
git switch -c \<new branch\> \<remote branch\>  
git checkout -b \<new branch\> _(not recommended)_

# Inspect state

git status  
git diff  
git diff --cached  
git diff \<old commit\> \<new commit\>  
git diff \<file path\>  
git diff \<old commit\> \<new commit\> \<file path\>  
git diff \<branch 1\>..\<branch2\>  
git diff \<branch 1\>...\<branch2> _(diff between branch 2 with common ancestor of two branches)_  
git log  
git log --oneline  
git log --oneline --graph

# Staged change

git add \<file name\>  
git add .  
git rm --cached \<file name\>  
git commit  
git commit -a -m "\<message\>"  
git commit --amend  
git commit --amend --not-edit

# Integrate changes from remote

git fetch  
git merge \<branch\>  
git rebase \<_(base commit | branch)_\>  
git rebase \<old commit\> \<branch\>  
git merge-base \<feature\> \<main\> _(find original base of two branches)_  
git rebase -i \<base\>  
git rebase --onto \<new base\> \<old base\> \<branch\>  
git pull  
git pull \<origin\> \<remote branch\>:\<local branch\>  
git pull --rebase

# Push change to remote

git push \<origin\> \<branch\>  
git push \<origin\> \<local branch\>:\<remote branch\>  
git push -u  
git push --force  
git push \<origin\> :\<remote branch\> _(remove remote branch)_

# Stash

git stash _(stash staged and unstaged changes)_  
git stash -u _(stash untracked files too)_  
git stash -a _(stash all files)_  
git stash -p _(stash interactively)_  
git stash save "\<message\>"  
git stash pop  
git stash apply _(apply stash but not remove it)_  
git stash pop stash@{\<n\>}  
git stash show stash@{\<n\>}  
git stash branch \<branch\> stash@{\<n\>} _(create a branch from n-th stash)_  
git stash list

# Tag

git tag -a \<version\> \<commit\>  
git tag -l \<pattern\>

# Reflog

git reflog | git reflog HEAD | git reflog show HEAD  
git reflog \<branch\>  
git reflog \<stash\>  
git reflog \<tags\>  
git reflog \<ref\>@{time} _(1.hour.ago, 1day.ago, yesterday, yyyy-MM-dd.hh:mm:ss)_  
git reflog -all
