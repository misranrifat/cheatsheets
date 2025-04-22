# Comprehensive Vim Cheatsheet

## Table of Contents
- [Basic Navigation](#basic-navigation)
- [Inserting Text](#inserting-text)
- [Exiting](#exiting)
- [Editing Text](#editing-text)
- [Cut, Copy, and Paste](#cut-copy-and-paste)
- [Visual Mode](#visual-mode)
- [Search and Replace](#search-and-replace)
- [Working with Multiple Files](#working-with-multiple-files)
- [Working with Windows](#working-with-windows)
- [Tabs](#tabs)
- [Marks](#marks)
- [Folding](#folding)
- [Macros](#macros)
- [Text Objects](#text-objects)
- [Indentation](#indentation)
- [External Commands](#external-commands)
- [Vim Configuration](#vim-configuration)
- [Help](#help)

## Basic Navigation

### Character Movement
- `h` - Move cursor left
- `j` - Move cursor down
- `k` - Move cursor up
- `l` - Move cursor right

### Word Movement
- `w` - Move to beginning of next word
- `e` - Move to end of current/next word
- `b` - Move to beginning of current/previous word
- `W`, `E`, `B` - Same as above but for WORDS (space-separated)

### Line Movement
- `0` - Move to beginning of line
- `^` - Move to first non-blank character of line
- `$` - Move to end of line
- `+` or `Enter` - Move to first character of next line
- `-` - Move to first character of previous line

### Page Movement
- `gg` - Move to first line of document
- `G` - Move to last line of document
- `:{number}` - Move to line {number}
- `{number}G` - Move to line {number}
- `Ctrl+f` - Move forward one full screen
- `Ctrl+b` - Move back one full screen
- `Ctrl+d` - Move forward half a screen
- `Ctrl+u` - Move back half a screen
- `Ctrl+e` - Scroll down one line
- `Ctrl+y` - Scroll up one line
- `zz` - Center current line on screen
- `zt` - Move current line to top of screen
- `zb` - Move current line to bottom of screen

### Character/Pattern Search
- `f{char}` - Move to next occurrence of {char} on current line
- `F{char}` - Move to previous occurrence of {char} on current line
- `t{char}` - Move to before next occurrence of {char} on current line
- `T{char}` - Move to after previous occurrence of {char} on current line
- `;` - Repeat last f, F, t, or T movement
- `,` - Repeat last f, F, t, or T movement, but in opposite direction
- `%` - Move to matching parenthesis, bracket, or brace

## Inserting Text

### Insert Mode
- `i` - Insert before cursor
- `I` - Insert at beginning of line
- `a` - Append after cursor
- `A` - Append at end of line
- `o` - Open new line below cursor
- `O` - Open new line above cursor
- `ea` - Append at end of word
- `Esc` or `Ctrl+[` - Exit insert mode

### Replace Mode
- `r` - Replace single character
- `R` - Enter replace mode
- `gR` - Enter virtual replace mode

## Exiting
- `:w` - Write/save file
- `:w {filename}` - Write to {filename}
- `:wq` or `:x` or `ZZ` - Write and quit
- `:q` - Quit (fails if unsaved changes)
- `:q!` or `ZQ` - Quit without saving (discard changes)
- `:wqa` - Write all files and quit
- `:qa` - Quit all files
- `:qa!` - Force quit all files

## Editing Text

### Delete and Change
- `x` - Delete character under cursor
- `X` - Delete character before cursor
- `dd` - Delete current line
- `D` - Delete from cursor to end of line
- `dw` - Delete word from cursor position
- `diw` - Delete inner word (entire word under cursor)
- `daw` - Delete a word (word under cursor plus spaces)
- `d$` or `D` - Delete from cursor to end of line
- `d0` - Delete from cursor to beginning of line
- `cc` - Change entire line
- `C` - Change from cursor to end of line
- `cw` - Change word from cursor position
- `ciw` - Change inner word
- `caw` - Change a word
- `c$` or `C` - Change from cursor to end of line
- `c0` - Change from cursor to beginning of line
- `s` - Delete character under cursor and enter insert mode
- `S` - Delete line and enter insert mode (same as cc)
- `~` - Toggle case of character under cursor
- `g~{motion}` - Toggle case of {motion}
- `gu{motion}` - Make {motion} lowercase
- `gU{motion}` - Make {motion} uppercase
- `.` - Repeat last command

### Text Manipulation
- `J` - Join current line with next line
- `gJ` - Join lines without space
- `gwip` - Reformat paragraph
- `gq{motion}` - Format text to textwidth
- `<<` - Shift line left
- `>>` - Shift line right
- `={motion}` - Auto-format code

### Undo/Redo
- `u` - Undo last change
- `Ctrl+r` - Redo last undone change
- `U` - Restore last changed line
- `:earlier {time}` - Go to earlier text state ({time} can be 10s, 1m, etc.)
- `:later {time}` - Go to later text state

## Cut, Copy, and Paste

### Registers
- `"{register}` - Use {register} for next delete, yank, or put
- `:reg` - Show register contents
- `:reg {register}` - Show content of specific register
- `"+` - System clipboard register (if available)
- `"*` - Selection clipboard register (if available)
- `"0` - Yank register (only modified by y)
- `"_` - Black hole register (discard text)

### Yank (Copy) and Put (Paste)
- `y{motion}` - Yank (copy) {motion} text
- `yy` or `Y` - Yank current line
- `y$` - Yank to end of line
- `p` - Put after cursor
- `P` - Put before cursor
- `gp` - Put after cursor and move cursor after text
- `gP` - Put before cursor and move cursor after text
- `]p` - Put and adjust indentation
- `[p` - Same as ]p but put before cursor

## Visual Mode

### Entering Visual Mode
- `v` - Enter character-wise visual mode
- `V` - Enter line-wise visual mode
- `Ctrl+v` - Enter block-wise visual mode
- `gv` - Re-select last visual selection
- `o` - Move to other end of selection

### Visual Mode Operations
- `d` - Delete selected text
- `c` - Change selected text
- `y` - Yank (copy) selected text
- `>` - Shift right
- `<` - Shift left
- `~` - Toggle case
- `u` - Make lowercase
- `U` - Make uppercase
- `J` - Join lines
- `:` - Start a command for selected lines

## Search and Replace

### Search
- `/pattern` - Search forward for pattern
- `?pattern` - Search backward for pattern
- `n` - Repeat search in same direction
- `N` - Repeat search in opposite direction
- `*` - Search forward for word under cursor
- `#` - Search backward for word under cursor
- `g*` - Search forward for partial word under cursor
- `g#` - Search backward for partial word under cursor
- `gd` - Go to local definition
- `gD` - Go to global definition
- `:noh` - Clear search highlighting

### Search and Replace
- `:%s/pattern/replacement/g` - Replace all occurrences in file
- `:%s/pattern/replacement/gc` - Replace all occurrences in file with confirmation
- `:s/pattern/replacement/g` - Replace all occurrences in current line
- `:start,ends/pattern/replacement/g` - Replace all occurrences between line numbers
- `:%s/pattern/replacement/gi` - Replace all occurrences in file (case insensitive)

## Working with Multiple Files

### Buffers
- `:ls` or `:buffers` - List all buffers
- `:bn` or `:bnext` - Go to next buffer
- `:bp` or `:bprev` - Go to previous buffer
- `:b {number}` - Go to buffer {number}
- `:b {filename}` - Go to buffer with {filename}
- `:bd` or `:bdelete` - Delete current buffer
- `:bd {number}` - Delete buffer {number}
- `:bw` or `:bwipeout` - Wipe out current buffer
- `:ball` - Open all buffers in windows
- `:badd {filename}` - Add {filename} to buffer list

### Arguments
- `:args` - List arguments
- `:next` or `:n` - Edit next file in argument list
- `:prev` or `:N` - Edit previous file in argument list
- `:first` - Edit first file in argument list
- `:last` - Edit last file in argument list
- `:argadd {filename}` - Add {filename} to argument list
- `:argdelete {filename}` - Remove {filename} from argument list

## Working with Windows

### Window Management
- `:split` or `:sp` - Split window horizontally
- `:vsplit` or `:vs` - Split window vertically
- `:new` - Create new window horizontally
- `:vnew` - Create new window vertically
- `Ctrl+w s` - Split window horizontally
- `Ctrl+w v` - Split window vertically
- `Ctrl+w q` or `:q` - Close current window
- `Ctrl+w o` or `:only` - Close all windows except current
- `Ctrl+w r` - Rotate windows
- `Ctrl+w x` - Exchange current window with next one
- `Ctrl+w =` - Make all windows equal size
- `:resize {height}` - Set window height
- `:vertical resize {width}` - Set window width

### Window Navigation
- `Ctrl+w h` - Move to window on left
- `Ctrl+w j` - Move to window below
- `Ctrl+w k` - Move to window above
- `Ctrl+w l` - Move to window on right
- `Ctrl+w w` - Move to next window
- `Ctrl+w p` - Move to previous window
- `Ctrl+w t` - Move to top-left window
- `Ctrl+w b` - Move to bottom-right window

## Tabs

### Tab Management
- `:tabnew` or `:tabe` - Open new tab
- `:tabnew {filename}` - Open {filename} in new tab
- `:tabclose` or `:tabc` - Close current tab
- `:tabonly` or `:tabo` - Close all other tabs
- `:tabs` - List all tabs
- `gt` or `:tabnext` - Go to next tab
- `gT` or `:tabprevious` - Go to previous tab
- `{number}gt` - Go to tab {number}
- `:tabfirst` - Go to first tab
- `:tablast` - Go to last tab
- `:tabmove {position}` - Move tab to position {position} (0-indexed)

## Marks

### Setting and Using Marks
- `m{a-zA-Z}` - Set mark {a-zA-Z} at cursor position
- `'{a-z}` - Jump to line of mark {a-z}
- ``{a-z}` - Jump to position of mark {a-z}
- `:marks` - List all marks
- `:delmarks {marks}` - Delete specified marks
- `:delmarks!` - Delete all lowercase marks
- `'[` - Jump to beginning of last changed or yanked text
- `']` - Jump to end of last changed or yanked text
- `'.` - Jump to position of last change
- `''` - Jump back to last jump position
- `'"` - Jump to position where last exited current buffer

## Folding

### Fold Commands
- `zf{motion}` - Create fold for {motion}
- `:{range}fo[ld]` - Create fold for range
- `zd` - Delete fold at cursor
- `zD` - Delete all folds at cursor
- `zE` - Eliminate all folds in window
- `zo` - Open fold at cursor
- `zO` - Open all folds at cursor
- `zc` - Close fold at cursor
- `zC` - Close all folds at cursor
- `za` - Toggle fold at cursor
- `zA` - Toggle all folds at cursor
- `zm` - Fold more (reduce `foldlevel`)
- `zM` - Close all folds
- `zr` - Fold less (increase `foldlevel`)
- `zR` - Open all folds
- `zn` - Disable folding
- `zN` - Re-enable folding
- `zi` - Toggle folding

## Macros

### Recording and Using Macros
- `q{a-z}` - Record macro into register {a-z}
- `q` - Stop recording
- `@{a-z}` - Execute macro in register {a-z}
- `@@` - Execute last executed macro
- `{count}@{a-z}` - Execute macro {a-z} {count} times
- `:reg {a-z}` - Show contents of macro register {a-z}

## Text Objects

### Text Object Selection
Used after an operator (d, c, y) or in visual mode (v, V, Ctrl+v)
- `aw` - A word (includes surrounding whitespace)
- `iw` - Inner word (excludes surrounding whitespace)
- `aW` - A WORD (space-separated)
- `iW` - Inner WORD
- `as` - A sentence
- `is` - Inner sentence
- `ap` - A paragraph
- `ip` - Inner paragraph
- `a[` or `a]` - A [] block
- `i[` or `i]` - Inner [] block
- `a(` or `a)` or `ab` - A () block
- `i(` or `i)` or `ib` - Inner () block
- `a<` or `a>` - A <> block
- `i<` or `i>` - Inner <> block
- `a{` or `a}` or `aB` - A {} block
- `i{` or `i}` or `iB` - Inner {} block
- `at` - A tag block
- `it` - Inner tag block
- `a"` - A double quoted string
- `i"` - Inner double quoted string
- `a'` - A single quoted string
- `i'` - Inner single quoted string
- `a`` - A backtick quoted string
- `i`` - Inner backtick quoted string

## Indentation

### Manual Indentation
- `>>` - Indent current line
- `<<` - Unindent current line
- `>{motion}` - Indent {motion}
- `<{motion}` - Unindent {motion}
- `>%` - Indent a block with () or {} (cursor on bracket)
- `<%` - Unindent a block with () or {} (cursor on bracket)
- `>ib` - Indent inner block
- `<ib` - Unindent inner block
- `=i{` - Auto-indent inner block
- `={motion}` - Auto-indent {motion}
- `gg=G` - Auto-indent entire file

### Auto Indentation
- `=i{` - Auto-indent inner braces
- `=a{` - Auto-indent a braced block
- `=%` - Auto-indent a block (cursor on bracket)
- `gg=G` - Auto-indent entire file
- `]p` - Paste and adjust indentation to current line
- `[p` - Same as ]p but paste before cursor

## External Commands

### Shell Commands
- `:!{command}` - Execute external {command}
- `:r !{command}` - Read output of {command} into buffer
- `:w !{command}` - Send current buffer as input to {command}
- `:!{command} %` - Execute {command} on current file
- `:shell` or `:sh` - Open a shell
- `Ctrl+z` - Suspend Vim (return with `fg` in shell)
- `:{range}!{command}` - Filter {range} lines through {command}

## Vim Configuration

### Vim Settings
- `:set {option}` - Set an option
- `:set no{option}` - Unset an option
- `:set {option}?` - Check option value
- `:set {option}={value}` - Set option to value
- `:set {option}+=value` - Add value to option
- `:set {option}-=value` - Remove value from option
- `:set all` - List all options
- `:let {var}={value}` - Set a variable
- `:echo {var}` - Echo a variable value

### Common Options
- `:set number` or `:set nu` - Show line numbers
- `:set nonumber` or `:set nonu` - Hide line numbers
- `:set relativenumber` or `:set rnu` - Show relative line numbers
- `:set syntax=on` - Enable syntax highlighting
- `:set tabstop=4` or `:set ts=4` - Set tab width to 4
- `:set shiftwidth=4` or `:set sw=4` - Set shift width to 4
- `:set expandtab` or `:set et` - Use spaces instead of tabs
- `:set noexpandtab` or `:set noet` - Use tabs instead of spaces
- `:set autoindent` or `:set ai` - Enable auto-indentation
- `:set smartindent` or `:set si` - Enable smart indentation
- `:set hlsearch` or `:set hls` - Highlight search results
- `:set nohlsearch` or `:set nohls` - Disable highlight search
- `:set incsearch` or `:set is` - Show matches as you type
- `:set ignorecase` or `:set ic` - Case insensitive search
- `:set smartcase` or `:set scs` - Override ignorecase if search contains uppercase
- `:set wrap` - Wrap lines
- `:set nowrap` - Don't wrap lines
- `:set list` - Show invisible characters
- `:set nolist` - Hide invisible characters
- `:set cursorline` or `:set cul` - Highlight current line
- `:set nocursorline` or `:set nocul` - Don't highlight current line
- `:set colorscheme {scheme}` or `:colo {scheme}` - Set color scheme

### Vimrc File
- `~/.vimrc` - User vimrc file (Unix/Linux)
- `~/_vimrc` - User vimrc file (Windows)
- `$VIM/vimrc` - System vimrc file

## Help

### Help Commands
- `:help` or `:h` - Open help
- `:help {topic}` or `:h {topic}` - Open help for {topic}
- `:helpgrep {pattern}` - Search help for {pattern}
- `:helpclose` - Close help window
- `Ctrl+]` - Follow tag under cursor
- `Ctrl+t` - Jump back from tag
- `:h quickref` - Quick reference guide
- `:h index` - List of all commands
- `:h user-manual` - User manual

### Specific Help Topics
- `:h options` - List of all options
- `:h i_` - List all insert mode commands
- `:h v_` - List all visual mode commands
- `:h c_` - List all command-line commands
- `:h function-list` - List of functions
- `:h pattern` - Regular expression patterns
- `:h registers` - Register usage
- `:h syntax` - Syntax highlighting
- `:h vim-script` - Vim script language

## Additional Tricks

### Recording and Combining Commands
- `10@a` - Execute macro 'a' 10 times
- `:g/pattern/normal @a` - Execute macro 'a' on lines matching pattern
- `:g/pattern/d` - Delete all lines matching pattern
- `:v/pattern/d` - Delete all lines NOT matching pattern

### Power Commands
- `:%!sort` - Sort entire file
- `:%!uniq` - Remove duplicate lines from file
- `:%!fmt` - Format text
- `:%!{command}` - Filter entire file through command
- `:{range}!{command}` - Filter range through command
- `:%s/\s\+$//` - Remove trailing whitespace
- `:%s/\r//g` - Remove Windows line endings (^M)
- `:%s/\n\{3,}/\r\r/g` - Compress multiple blank lines into two
