# Git Cheatsheet

This comprehensive Git cheatsheet provides a reference for essential commands and workflows for version control using Git. It is organized by common tasks and includes brief explanations where necessary.

## Table of Contents

 1. Setup and Configuration
 2. Initializing and Cloning Repositories
 3. Basic Workflow
 4. Branching and Merging
 5. Stashing
 6. Remote Repositories
 7. Inspecting and Comparing
 8. Undoing Changes
 9. Tagging
10. Submodules
11. Git Ignore
12. Advanced Commands

---

## Setup and Configuration

Configure user information and settings for Git.

- **Set user name**\
  `git config --global user.name "Your Name"`\
  Sets the name associated with your commits.

- **Set user email**\
  `git config --global user.email "your.email@example.com"`\
  Sets the email associated with your commits.

- **View configuration**\
  `git config --list`\
  Displays all Git configuration settings.

- **Set default editor**\
  `git config --global core.editor "nano"`\
  Configures the default text editor (e.g., nano, vim, vscode).

- **Enable color output**\
  `git config --global color.ui auto`\
  Enables colored output for better readability.

- **Set default branch name**\
  `git config --global init.defaultBranch main`\
  Sets the default branch name for new repositories (e.g., `main`).

---

## Initializing and Cloning Repositories

Start a new repository or clone an existing one.

- **Initialize a new repository**\
  `git init`\
  Creates a new Git repository in the current directory.

- **Clone a repository**\
  `git clone <repository-url>`\
  Downloads a repository and its history to your local machine.

- **Clone with specific branch**\
  `git clone --branch <branch-name> <repository-url>`\
  Clones a specific branch of a repository.

- **Clone with submodules**\
  `git clone --recurse-submodules <repository-url>`\
  Clones a repository and its submodules.

---

## Basic Workflow

Core commands for tracking and committing changes.

- **Check repository status**\
  `git status`\
  Shows the current state of the working directory and staging area.

- **Add files to staging**\
  `git add <file>`\
  Stages a specific file for the next commit.

- **Add all changes**\
  `git add .`\
  Stages all modified and new files in the current directory.

- **Commit changes**\
  `git commit -m "Commit message"`\
  Commits staged changes with a descriptive message.

- **Commit all changes**\
  `git commit -a -m "Commit message"`\
  Automatically stages and commits all modified tracked files.

- **Amend last commit**\
  `git commit --amend`\
  Modifies the most recent commit (e.g., to change the message or add files).

---

## Branching and Merging

Manage branches for parallel development.

- **List branches**\
  `git branch`\
  Displays all local branches; the current branch is marked with `*`.

- **Create a new branch**\
  `git branch <branch-name>`\
  Creates a new branch but does not switch to it.

- **Switch to a branch**\
  `git checkout <branch-name>`\
  Switches to the specified branch.

- **Create and switch to a branch**\
  `git checkout -b <branch-name>`\
  Creates a new branch and switches to it.

- **Delete a branch**\
  `git branch -d <branch-name>`\
  Deletes a branch (only if merged).

- **Force delete a branch**\
  `git branch -D <branch-name>`\
  Deletes a branch regardless of merge status.

- **Merge a branch**\
  `git merge <branch-name>`\
  Merges the specified branch into the current branch.

- **Resolve merge conflicts**\
  Manually edit conflicting files, then:\
  `git add <file>`\
  `git commit`

- **List remote branches**\
  `git branch -r`\
  Shows all remote branches.

---

## Stashing

Temporarily store changes without committing.

- **Stash changes**\
  `git stash`\
  Saves modified and staged changes to a stack.

- **List stashes**\
  `git stash list`\
  Displays all stashed changes.

- **Apply latest stash**\
  `git stash apply`\
  Reapplies the most recent stash without removing it.

- **Apply specific stash**\
  `git stash apply stash@{n}`\
  Reapplies a specific stash (replace `n` with stash index).

- **Drop a stash**\
  `git stash drop stash@{n}`\
  Removes a specific stash.

- **Pop latest stash**\
  `git stash pop`\
  Applies the latest stash and removes it from the stack.

- **Stash with message**\
  `git stash push -m "Stash message"`\
  Saves changes with a descriptive message.

---

## Remote Repositories

Work with remote repositories (e.g., GitHub, GitLab).

- **Add a remote**\
  `git remote add <name> <url>`\
  Links a remote repository (e.g., `git remote add origin <url>`).

- **List remotes**\
  `git remote -v`\
  Shows all remote repositories and their URLs.

- **Push changes**\
  `git push <remote> <branch>`\
  Pushes local commits to the specified remote branch (e.g., `git push origin main`).

- **Push all branches**\
  `git push --all <remote>`\
  Pushes all local branches to the remote.

- **Force push**\
  `git push --force`\
  Overwrites the remote branch (use with caution).

- **Pull changes**\
  `git pull <remote> <branch>`\
  Fetches and merges changes from the remote branch.

- **Fetch changes**\
  `git fetch <remote>`\
  Downloads changes from the remote without merging.

- **Remove a remote**\
  `git remote rm <name>`\
  Deletes a remote from the repository.

- **Set upstream for branch**\
  `git push --set-upstream <remote> <branch>`\
  Sets the default remote branch for future pushes (e.g., `git push --set-upstream origin main`).

---

## Inspecting and Comparing

View history and differences.

- **View commit history**\
  `git log`\
  Shows the commit history for the current branch.

- **View concise log**\
  `git log --oneline`\
  Displays a compact commit history.

- **View log with graph**\
  `git log --graph --oneline --all`\
  Shows a visual representation of branch history.

- **Show commit details**\
  `git show <commit-hash>`\
  Displays details of a specific commit.

- **Compare changes**\
  `git diff`\
  Shows differences between the working directory and the staging area.

- **Compare staged changes**\
  `git diff --staged`\
  Shows differences between the staging area and the last commit.

- **Compare branches**\
  `git diff <branch1> <branch2>`\
  Shows differences between two branches.

- **Blame a file**\
  `git blame <file>`\
  Shows who last modified each line of a file.

---

## Undoing Changes

Revert or reset changes.

- **Discard changes in working directory**\
  `git restore <file>`\
  Discards changes to a file since the last commit.

- **Unstage changes**\
  `git restore --staged <file>`\
  Removes a file from the staging area.

- **Reset to previous commit**\
  `git reset <commit-hash>`\
  Moves the branch pointer to the specified commit, keeping changes in the working directory.

- **Hard reset**\
  `git reset --hard <commit-hash>`\
  Resets the branch and discards all changes since the specified commit.

- **Revert a commit**\
  `git revert <commit-hash>`\
  Creates a new commit that undoes the changes of the specified commit.

- **Clean untracked files**\
  `git clean -f`\
  Removes untracked files from the working directory.

- **Clean and reset**\
  `git reset --hard && git clean -fd`\
  Resets the repository to a clean state, removing all changes and untracked files.

---

## Tagging

Mark specific commits (e.g., for releases).

- **Create a lightweight tag**\
  `git tag <tag-name>`\
  Creates a tag pointing to the current commit.

- **Create an annotated tag**\
  `git tag -a <tag-name> -m "Tag message"`\
  Creates a tag with a message.

- **List tags**\
  `git tag`\
  Displays all tags.

- **Push a tag**\
  `git push <remote> <tag-name>`\
  Pushes a specific tag to the remote.

- **Push all tags**\
  `git push --tags`\
  Pushes all tags to the remote.

- **Delete a tag**\
  `git tag -d <tag-name>`\
  Deletes a local tag.

- **Delete a remote tag**\
  `git push <remote> --delete <tag-name>`\
  Deletes a tag from the remote repository.

---

## Submodules

Manage submodules within a repository.

- **Add a submodule**\
  `git submodule add <repository-url>`\
  Adds a submodule to the repository.

- **Update submodules**\
  `git submodule update --init --recursive`\
  Initializes and updates all submodules.

- **Pull submodule changes**\
  `git submodule update --remote`\
  Fetches and merges the latest changes for submodules.

- **Remove a submodule**

  1. `git submodule deinit <submodule-path>`
  2. `git rm <submodule-path>`
  3. Remove the submodule directory and commit.

---

## Git Ignore

Exclude files from version control.

- **Create a** `.gitignore` **file**

  ```
  # Example .gitignore
  *.log
  node_modules/
  .env
  /dist
  ```

  Specifies patterns for files and directories to ignore.

- **Apply** `.gitignore` **to existing files**\
  `git rm -r --cached <file-or-directory>`\
  Removes previously tracked files from the index so `.gitignore` can take effect.

---

## Advanced Commands

Less common but powerful commands.

- **Cherry-pick a commit**\
  `git cherry-pick <commit-hash>`\
  Applies the changes from a specific commit to the current branch.

- **Rebase a branch**\
  `git rebase <branch>`\
  Reapplies commits from the current branch onto another branch.

- **Interactive rebase**\
  `git rebase -i <commit-hash>`\
  Allows editing, squashing, or reordering commits.

- **Bisect to find bugs**\
  `git bisect start`\
  `git bisect bad`\
  `git bisect good <commit-hash>`\
  Uses binary search to find the commit that introduced a bug.

- **Stop bisecting**\
  `git bisect reset`\
  Ends the bisect session.

- **Create an archive**\
  `git archive -o <filename>.zip HEAD`\
  Exports the current repository state as a ZIP file.

- **Show repository size**\
  `git count-objects -v`\
  Displays the size of the repository.

- **Garbage collection**\
  `git gc`\
  Optimizes the repository by cleaning up unnecessary files.

---

This cheatsheet covers the most commonly used Git commands and workflows. Save this markdown file for quick reference during development.
