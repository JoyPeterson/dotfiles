Dotfiles
========

After cloning this repo, run `install` to automatically set up the development
environment. Note that the install script is idempotent - running it multiple
times has no effect.

Dotfiles uses [Dotbot][dotbot] for installation.

In general, you should be using symbolic links for everything, and using git
submodules whenever possible.

To keep submodules at their proper versions, you could include something like
`git submodule update --init --recursive` in your `install.conf.json`.

To upgrade your submodules to their latest versions, you could periodically run
`git submodule update --init --remote`.


[dotbot]: https://github.com/anishathalye/dotbot

