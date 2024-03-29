# VKR (Vim Kitty Runner)

---

**NOTE** I am no longer working on the vimscript version of VKR. I have been working on a NeoVim (Lua) fork of [kitty-runner.nvim](https://github.com/LkeMitchll/kitty-runner.nvim)

---

A simple, vimscript only, command runner for sending commands from vim to the [kitty][] terminal emulator.
Inspired heavily by Chris Toomey's [vim-tmux-runner][].

[vim-tmux-runner]: https://github.com/christoomey/vim-tmux-runner

## Usage

VKR provides a handful of commands for managing and interacting with [kitty][], the terminal emulator. An example of the main command is:

``` vim
:KittyRunCommand
```

You can find full docs for the plugin after installation, by running:

``` vim
:help vim-kitty-runner
```

## Installation

If you don't have a preferred installation method, I recommend using
[vim-plug][]:

``` vim
Plug 'lkemitchll/vim-kitty-runner'
```

[vim-tmux-runner]: https://github.com/christoomey/vim-tmux-runner
[kitty]: https://github.com/kovidgoyal/kitty
[vim-plug]: https://github.com/junegunn/vim-plug
