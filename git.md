Git Cheatsheet
This comprehensive Git cheatsheet provides a reference for essential commands and workflows for version control using Git. It is organized by common tasks and includes brief explanations where necessary.
Table of Contents

Setup and Configuration
Initializing and Cloning Repositories
Basic Workflow
Branching and Merging
Stashing
Remote Repositories
Inspecting and Comparing
Undoing Changes
Tagging
Submodules
Git Ignore
Advanced Commands


Setup and Configuration
Configure user information and settings for Git.

Set user namegit config --global user.name "Your Name"Sets the name associated with your commits.

Set user emailgit config --global user.email "your.email@example.com"Sets the email associated with your commits.

View configurationgit config --listDisplays all Git configuration settings.

Set default editorgit config --global core.editor "nano"Configures the default text editor (e.g., nano, vim, vscode).

Enable color outputgit config --global color.ui autoEnables colored output for better readability.

Set default branch namegit config --global init.defaultBranch mainSets the default branch name for new repositories (e.g., main).



Initializing and Cloning Repositories
Start a new repository or clone an existing one.

Initialize a new repositorygit initCreates a new Git repository in the current directory.

Clone a repositorygit clone <repository-url>Downloads a repository and its history to your local machine.

Clone with specific branchgit clone --branch <branch-name> <repository-url>Clones a specific branch of a repository.

Clone with submodulesgit clone --recurse-submodules <repository-url>Clones a repository and its submodules.



Basic Workflow
Core commands for tracking and committing changes.

Check repository statusgit statusShows the current state of the working directory and staging area.

Add files to staginggit add <file>Stages a specific file for the next commit.

Add all changesgit add .Stages all modified and new files in the current directory.

Commit changesgit commit -m "Commit message"Commits staged changes with a descriptive message.

Commit all changesgit commit -a -m "Commit message"Automatically stages and commits all modified tracked files.

Amend last commitgit commit --amendModifies the most recent commit (e.g., to change the message or add files).



Branching and Merging
Manage branches for parallel development.

List branchesgit branchDisplays all local branches; the current branch is marked with *.

Create a new branchgit branch <branch-name>Creates a new branch but does not switch to it.

Switch to a branchgit checkout <branch-name>Switches to the specified branch.

Create and switch to a branchgit checkout -b <branch-name>Creates a new branch and switches to it.

Delete a branchgit branch -d <branch-name>Deletes a branch (only if merged).

Force delete a branchgit branch -D <branch-name>Deletes a branch regardless of merge status.

Merge a branchgit merge <branch-name>Merges the specified branch into the current branch.

Resolve merge conflictsManually edit conflicting files, then:git add <file>git commit

List remote branchesgit branch -rShows all remote branches.



Stashing
Temporarily store changes without committing.

Stash changesgit stashSaves modified and staged changes to a stack.

List stashesgit stash listDisplays all stashed changes.

Apply latest stashgit stash applyReapplies the most recent stash without removing it.

Apply specific stashgit stash apply stash@{n}Reapplies a specific stash (replace n with stash index).

Drop a stashgit stash drop stash@{n}Removes a specific stash.

Pop latest stashgit stash popApplies the latest stash and removes it from the stack.

Stash with messagegit stash push -m "Stash message"Saves changes with a descriptive message.



Remote Repositories
Work with remote repositories (e.g., GitHub, GitLab).

Add a remotegit remote add <name> <url>Links a remote repository (e.g., git remote add origin <url>).

List remotesgit remote -vShows all remote repositories and their URLs.

Push changesgit push <remote> <branch>Pushes local commits to the specified remote branch (e.g., git push origin main).

Push all branchesgit push --all <remote>Pushes all local branches to the remote.

Force pushgit push --forceOverwrites the remote branch (use with caution).

Pull changesgit pull <remote> <branch>Fetches and merges changes from the remote branch.

Fetch changesgit fetch <remote>Downloads changes from the remote without merging.

Remove a remotegit remote rm <name>Deletes a remote from the repository.

Set upstream for branchgit push --set-upstream <remote> <branch>Sets the default remote branch for future pushes (e.g., git push --set-upstream origin main).



Inspecting and Comparing
View history and differences.

View commit historygit logShows the commit history for the current branch.

View concise loggit log --onelineDisplays a compact commit history.

View log with graphgit log --graph --oneline --allShows a visual representation of branch history.

Show commit detailsgit show <commit-hash>Displays details of a specific commit.

Compare changesgit diffShows differences between the working directory and the staging area.

Compare staged changesgit diff --stagedShows differences between the staging area and the last commit.

Compare branchesgit diff <branch1> <branch2>Shows differences between two branches.

Blame a filegit blame <file>Shows who last modified each line of a file.



Undoing Changes
Revert or reset changes.

Discard changes in working directorygit restore <file>Discards changes to a file since the last commit.

Unstage changesgit restore --staged <file>Removes a file from the staging area.

Reset to previous commitgit reset <commit-hash>Moves the branch pointer to the specified commit, keeping changes in the working directory.

Hard resetgit reset --hard <commit-hash>Resets the branch and discards all changes since the specified commit.

Revert a commitgit revert <commit-hash>Creates a new commit that undoes the changes of the specified commit.

Clean untracked filesgit clean -fRemoves untracked files from the working directory.

Clean and resetgit reset --hard && git clean -fdResets the repository to a clean state, removing all changes and untracked files.



Tagging
Mark specific commits (e.g., for releases).

Create a lightweight taggit tag <tag-name>Creates a tag pointing to the current commit.

Create an annotated taggit tag -a <tag-name> -m "Tag message"Creates a tag with a message.

List tagsgit tagDisplays all tags.

Push a taggit push <remote> <tag-name>Pushes a specific tag to the remote.

Push all tagsgit push --tagsPushes all tags to the remote.

Delete a taggit tag -d <tag-name>Deletes a local tag.

Delete a remote taggit push <remote> --delete <tag-name>Deletes a tag from the remote repository.



Submodules
Manage submodules within a repository.

Add a submodulegit submodule add <repository-url>Adds a submodule to the repository.

Update submodulesgit submodule update --init --recursiveInitializes and updates all submodules.

Pull submodule changesgit submodule update --remoteFetches and merges the latest changes for submodules.

Remove a submodule  

git submodule deinit <submodule-path>  
git rm <submodule-path>  
Remove the submodule directory and commit.




Git Ignore
Exclude files from version control.

Create a .gitignore file  
# Example .gitignore
*.log
node_modules/
.env
/dist

Specifies patterns for files and directories to ignore.

Apply .gitignore to existing filesgit rm -r --cached <file-or-directory>Removes previously tracked files from the index so .gitignore can take effect.



Advanced Commands
Less common but powerful commands.

Cherry-pick a commitgit cherry-pick <commit-hash>Applies the changes from a specific commit to the current branch.

Rebase a branchgit rebase <branch>Reapplies commits from the current branch onto another branch.

Interactive rebasegit rebase -i <commit-hash>Allows editing, squashing, or reordering commits.

Bisect to find bugsgit bisect startgit bisect badgit bisect good <commit-hash>Uses binary search to find the commit that introduced a bug.

Stop bisectinggit bisect resetEnds the bisect session.

Create an archivegit archive -o <filename>.zip HEADExports the current repository state as a ZIP file.

Show repository sizegit count-objects -vDisplays the size of the repository.

Garbage collectiongit gcOptimizes the repository by cleaning up unnecessary files.



This cheatsheet covers the most commonly used Git commands and workflows. Save this markdown file for quick reference during development.
