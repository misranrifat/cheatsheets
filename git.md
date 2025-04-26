# Git Cheat Sheet

## Setup and Configuration

### Installation
```bash
# Linux (Debian/Ubuntu)
sudo apt-get install git

# macOS
brew install git

# Windows
# Download from https://git-scm.com/download/win
```

### Configuration
```bash
# Set username and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default editor
git config --global core.editor "vim"

# List all configurations
git config --list

# Set configuration for a specific repository
git config --local user.name "Project Name"
```

## Repository Basics

### Create Repositories
```bash
# Initialize a new Git repository
git init

# Clone an existing repository
git clone https://github.com/username/repository.git

# Clone a specific branch
git clone -b branch-name https://github.com/username/repository.git

# Create a bare repository (for servers)
git init --bare
```

### Working with Remotes
```bash
# List remote repositories
git remote -v

# Add a remote repository
git remote add origin https://github.com/username/repository.git

# Change remote URL
git remote set-url origin https://github.com/username/new-repository.git

# Remove a remote
git remote remove origin

# Rename a remote
git remote rename old-name new-name
```

## Basic Workflow

### File Status Lifecycle
```bash
# Check status of files
git status

# Add files to staging area
git add filename
git add .                      # Add all files
git add *.js                   # Add all JavaScript files
git add directory/             # Add all files in directory

# Remove files from staging area
git reset filename
git restore --staged filename  # Git 2.23+

# Commit changes
git commit -m "Commit message"
git commit                     # Opens editor for commit message
git commit -a -m "message"     # Add and commit in one step
```

### Viewing Changes
```bash
# View changes between working directory and staging area
git diff

# View changes between staging area and last commit
git diff --staged
git diff --cached  # Synonym for --staged

# View changes between two commits
git diff commit1..commit2

# View changes in specific file
git diff -- path/to/file

# Show commit details
git show commit-hash
git show HEAD                  # Show latest commit
git show HEAD~1                # Show commit before HEAD
```

## Branching and Merging

### Branch Management
```bash
# List branches
git branch                     # Local branches
git branch -r                  # Remote branches
git branch -a                  # All branches (local and remote)

# Create a new branch
git branch branch-name

# Create and switch to a new branch
git checkout -b branch-name
git switch -c branch-name      # Git 2.23+

# Switch branches
git checkout branch-name
git switch branch-name         # Git 2.23+

# Rename current branch
git branch -m new-name

# Delete branch
git branch -d branch-name      # Safe delete
git branch -D branch-name      # Force delete
```

### Merging
```bash
# Merge a branch into current branch 
git merge branch-name

# Merge with no fast-forward
git merge --no-ff branch-name

# Abort a merge with conflicts
git merge --abort

# Continue merge after resolving conflicts
git merge --continue
```

### Rebasing
```bash
# Rebase current branch onto another
git rebase branch-name

# Interactive rebase
git rebase -i HEAD~3           # Modify the last 3 commits

# Continue rebase after resolving conflicts
git rebase --continue

# Abort rebase
git rebase --abort
```

## History and Logs

### Viewing History
```bash
# View commit history
git log

# Show compact log (one line per commit)
git log --oneline

# Show graph of branches
git log --graph --oneline --decorate

# Show commits by author
git log --author="username"

# Show commits between dates
git log --since="2023-01-01" --until="2023-12-31"

# Show changes in each commit
git log -p

# Show statistics of changes
git log --stat
```

### Inspecting Repository
```bash
# Show commit that last modified a line
git blame filename

# Search for string in all files
git grep "search string"

# List all commits that affected a file
git log -- filename

# Show who changed what and when in a file
git blame filename
```

## Undoing Changes

### Reverting Changes
```bash
# Discard changes in working directory
git checkout -- filename
git restore filename           # Git 2.23+

# Undo last commit but keep changes staged
git reset --soft HEAD^

# Undo last commit and unstage changes
git reset HEAD^

# Undo last commit and discard changes
git reset --hard HEAD^

# Create a new commit that undoes a previous commit
git revert commit-hash
```

### Stashing Changes
```bash
# Temporarily store modified files
git stash

# Save stash with message
git stash save "stash message"

# List stashes
git stash list

# Apply most recent stash
git stash apply

# Apply specific stash
git stash apply stash@{2}

# Apply and remove most recent stash
git stash pop

# Remove most recent stash
git stash drop

# Remove all stashes
git stash clear
```

## Synchronizing

### Fetching and Pulling
```bash
# Fetch updates from remote
git fetch origin

# Fetch all remotes
git fetch --all

# Pull updates from remote (fetch + merge)
git pull origin branch-name

# Pull with rebase instead of merge
git pull --rebase origin branch-name
```

### Pushing
```bash
# Push to remote
git push origin branch-name

# Push to remote and set upstream
git push -u origin branch-name

# Force push (use with caution!)
git push --force origin branch-name

# Push all branches
git push --all origin

# Push tags
git push --tags origin
```

## Tags

### Working with Tags
```bash
# List tags
git tag

# Create lightweight tag
git tag tag-name

# Create annotated tag
git tag -a tag-name -m "Tag message"

# Create tag for specific commit
git tag -a tag-name commit-hash

# Delete tag
git tag -d tag-name

# Push specific tag to remote
git push origin tag-name

# Push all tags
git push origin --tags
```

## Advanced Features

### Submodules
```bash
# Add submodule
git submodule add https://github.com/username/repo.git path/to/submodule

# Initialize submodules
git submodule init

# Update submodules
git submodule update

# Update all submodules
git submodule update --init --recursive

# Remove submodule
git submodule deinit path/to/submodule
git rm path/to/submodule
```

### Worktrees
```bash
# Create a new worktree
git worktree add ../path/to/directory branch-name

# List worktrees
git worktree list

# Remove a worktree
git worktree remove ../path/to/directory
```

### Cherry-picking
```bash
# Apply changes from a specific commit
git cherry-pick commit-hash

# Cherry-pick multiple commits
git cherry-pick commit1 commit2

# Cherry-pick without committing
git cherry-pick -n commit-hash
```

### Bisect
```bash
# Start bisect session
git bisect start

# Mark current version as bad
git bisect bad

# Mark a known good commit
git bisect good commit-hash

# End bisect session
git bisect reset
```

## Git Hooks

### Common Hooks
```bash
# Client-side hooks
.git/hooks/pre-commit
.git/hooks/prepare-commit-msg
.git/hooks/commit-msg
.git/hooks/post-commit
.git/hooks/pre-push

# Server-side hooks
.git/hooks/pre-receive
.git/hooks/update
.git/hooks/post-receive
```

## Git Aliases

### Creating Aliases
```bash
# Create shorthand for commands
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

# Create complex alias
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

## Git Large File Storage (LFS)

### LFS Commands
```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.psd"

# List tracked patterns
git lfs track

# List tracked files
git lfs ls-files
```

## Troubleshooting

### Common Issues
```bash
# Verify integrity of repository
git fsck

# Clean untracked files and directories
git clean -fd

# Recover lost commits
git reflog

# Find when something was introduced
git bisect start
git bisect bad
git bisect good older-commit

# Find out what's taking disk space
git gc
git count-objects -v
```

## Git Flow

### Git Flow Commands
```bash
# Initialize git flow
git flow init

# Start a new feature
git flow feature start feature_name

# Finish a feature
git flow feature finish feature_name

# Start a release
git flow release start release_name

# Finish a release
git flow release finish release_name

# Start a hotfix
git flow hotfix start hotfix_name

# Finish a hotfix
git flow hotfix finish hotfix_name
```

## Global Flags and Options

### Useful Options
```bash
-v, --verbose          # Show more detailed output
-q, --quiet            # Suppress most output
--dry-run              # Show what would happen without doing it
-f, --force            # Force an operation
--help                 # Show help for a Git command
```