# VKR (Vim Kitty Runner)

### Note: This plugin is in a _very_ ALPHA state

A simple, vimscript only, command runner for sending commands from vim to the [kitty][] terminal emulator.
Inspired heavily by [vim-tmux-runner][].

[vim-tmux-runner]: https://github.com/christoomey/vim-tmux-runner

## Usage

VKR provides a handful of commands for managing and interacting with [kitty][],
the terminal multiplexer. An example of the main command is:

``` vim
:KittyRunCommand make
```

**Docs coming soon (sorry)**

[kitty]: https://github.com/kovidgoyal/kitty

## Installation

If you don't have a preferred installation method, I recommend using
[vim-plug][]:

``` vim
Plug 'lkemitchll/vim-kitty-runner'
```

[vim-plug]: https://github.com/junegunn/vim-plug
