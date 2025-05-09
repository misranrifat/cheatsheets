# Nano Text Editor Cheatsheet

## Basic Commands

| Command | Description |
|---------|-------------|
| `nano [filename]` | Open/create a file in nano |
| `nano -w [filename]` | Open file without wrapping long lines |
| `nano +[line number] [filename]` | Open file at specific line number |
| `nano -B [filename]` | Create automatic backup files |
| `nano -m [filename]` | Enable mouse support |
| `nano -i [filename]` | Auto-indent new lines |
| `nano -l [filename]` | Enable line numbers display |

## Navigation

| Command | Description |
|---------|-------------|
| `^A` / `Home` | Move to beginning of line |
| `^E` / `End` | Move to end of line |
| `^Y` / `Page Up` | Scroll up one page |
| `^V` / `Page Down` | Scroll down one page |
| `^_` | Go to specific line number |
| `^C` | Show current cursor position |
| `^Space` | Move forward one word |
| `M-Space` | Move backward one word |
| `^P` / `Up Arrow` | Move up one line |
| `^N` / `Down Arrow` | Move down one line |
| `^F` / `Right Arrow` | Move forward one character |
| `^B` / `Left Arrow` | Move backward one character |

## Editing

| Command | Description |
|---------|-------------|
| `^D` | Delete character under cursor |
| `^H` / `Backspace` | Delete character before cursor |
| `M-Backspace` | Delete word to left |
| `^K` | Cut current line into cutbuffer |
| `M-6` | Copy current line into cutbuffer |
| `^U` | Paste cutbuffer contents |
| `^J` | Justify current paragraph |
| `^T` | Spell check |
| `M-]` | Complete current word |
| `M-Del` | Delete word to right |
| `M-U` | Undo last operation |
| `M-E` | Redo last undone operation |
| `^W` | Search for text |
| `^G` | Cancel current function/exit help |
| `^\\` | Replace text |
| `M-R` | Replace text (regular expression) |
| `M-^` | Mark text at cursor position |
| `M-W` | Repeat last search |
| `^O` | Save current file |
| `^X` | Exit nano |

## Cut and Paste

| Command | Description |
|---------|-------------|
| `^K` | Cut current line into cutbuffer |
| `^U` | Paste cutbuffer contents |
| `M-A` | Mark text starting from cursor |
| `M-6` | Copy marked text to cutbuffer |
| `^6` | Mark text starting from cursor position |
| `M-}` | Indent marked text |
| `M-{` | Unindent marked text |

## File Operations

| Command | Description |
|---------|-------------|
| `^R` | Read file into current buffer |
| `^O` | Write current buffer to file |
| `^X` | Close buffer, exit nano |
| `M-<` | Switch to previous buffer |
| `M->` | Switch to next buffer |
| `M-F` | Write file in different format |

## Display Options

| Command | Description |
|---------|-------------|
| `M-X` | Toggle help text |
| `M-C` | Toggle cursor position display |
| `M-O` | Toggle syntax highlighting |
| `M-#` | Toggle line numbers |
| `M-P` | Toggle whitespace display |
| `M-Y` | Toggle color syntax highlighting |
| `M-$` | Toggle soft line wrapping |

## Special Functions

| Command | Description |
|---------|-------------|
| `^J` | Justify current paragraph |
| `^T` | Invoke spell checker |
| `M-J` | Justify entire buffer |
| `M-D` | Count words, lines, and characters |
| `M-V` | Insert next keystroke verbatim |
| `^L` | Refresh the screen |
| `^Z` | Suspend nano (return to shell) |

## Notes and Tips

- `^` represents the Ctrl key
- `M-` represents the Alt key (Meta key)
- Configuration settings can be set in `~/.nanorc` file
- Use `nano --help` for command line options
- Create a system-wide configuration in `/etc/nanorc`
- Sample configuration file entries:
  ```
  set linenumbers
  set constantshow
  set mouse
  set autoindent
  ```

## Advanced Features

### Syntax Highlighting
- Nano supports syntax highlighting for many programming languages
- Enable it with `nano -Y [language] [filename]` or use `M-Y` to toggle
- Configure in `.nanorc` with `include "/usr/share/nano/*.nanorc"`

### Multiple Buffers
- Open multiple files with `nano file1 file2 file3`
- Use `M-<` and `M->` to switch between buffers
- File list can be shown with `M-F`

### Macros
- Record a macro with `^Q`
- Play a macro with `^]`

### Regular Expressions
- Use `M-R` for regex search and replace
- Basic regex syntax supported (similar to POSIX extended)

### Suspending
- Use `^Z` to suspend nano and return to command line
- Resume with `fg` command

## Additional Command Line Options

| Option | Description |
|--------|-------------|
| `-A` | Enable smart home key |
| `-E` | Convert tabs to spaces |
| `-c` | Constantly show cursor position |
| `-d` | Enable line numbers by default |
| `-k` | Toggle cut from cursor to end of line |
| `-S` | Backup files into `~/.nano/backups/` |
| `-p` | Preserve XON and XOFF keys (^S/^Q) |
| `-x` | Disable status bar |
