# Fuzzy Stash

A small plugin to add the ability to stash file changes in git. This plugin is inspired by [fzf.vim](https://github.com/junegunn/fzf.vim), using [fzf](https://github.com/junegunn/fzf) for its UI to make stash management simple.

This plugin doesn't aim to do much more than stash, but if you're using [vim-fugitive](https://github.com/tpope/vim-fugitive) like I am, it's one of the few commands you'll be missing.

### Features

* Adds a useful interface for managing your stashes, including popping, dropping, and previewing those stashes with meaningless names
* Adds a command to stash all current changes, with the optional ability to name the stash
* Matches both vim-fugitive and fzf.vim in design so that it will feel familiar to anyone who already uses them

### Dependencies

This plugin depends on fzf for it's UI. Other than that, almost any version of vim (or neovim) and git should work with this plugin.
You must also have [vim-fugitive](https://github.com/tpope/vim-fugitive) installed.

### Installation

Using [vim-plug](https://github.com/junegunn/vim-plug), it's as simple as:

`Plug 'aacunningham/vim-fuzzy-stash'`

### Usage

This plugin exposes two commands for you to use or bind as you see fit:
* `GStash [stash-name]` -- Mimics `git stash push`, stashing all changes (does not stash files that are not being tracked). Accepts an optional positional argument for the name of the stash.
* `GStashList` -- Opens an fzf window with a list of all stashes. This list gives the users a couple of options to manage their stashes
  * `ctrl-d` -- Drops the marked stash. This can be applied to multiple stashes using the `tab` key to mark each stash
  * `ctrl-a` -- Pops the marked stash. If multiple stashes are marked with the `tab` key, only the first stash will be `pop`ped.
  * `ctrl-p` -- Applies the marked stash. If multiple stashes are marked with the `tab` key, only the first stash will be applied.

My personal recommondation is mapping GStash as `:GStash<Space>`, giving you the option of typing in a name after your keystroke, or immediately stashing by typing enter.

### Configuration

The plugin allows configuring the actions and keybindings that are available in the stash list (opened with `GStashList`):
```
" The default configuration
let g:fuzzy_stash_actions = {
  \ 'ctrl-d': 'drop',
  \ 'ctrl-a': 'pop',
  \ 'ctrl-p': 'apply' }
```

The values to the actions are limited to `'drop'`, `'pop'`, and `'apply'`. If requested, this could probably be updated to allow any `git stash` subcommand.

Due to the initial implementation of the plugin and the fact the the maintainer uses an odd keyboard layout, `pop` has a default binding to `ctrl-a` and `apply` has a default binding to `ctrl-p`. If this seems backwards to you, this configuration should maybe be a bit more straightforward:
```
" A more sane configuration
let g:fuzzy_stash_actions = {
  \ 'ctrl-d': 'drop',
  \ 'ctrl-p': 'pop',
  \ 'ctrl-a': 'apply' }
```

