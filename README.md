dotfiles
=================================

a list of files I sometimes resort to when I forget how things were setup in e.g. bash!

Installation
------------

```shell
git clone git://github.com/lennart/dotfiles ~/.dotfiles
```

then symlink all the files as you like.


Branches
--------

currently you are looking at the `emacs` branch. also available is the `rails-vim` branch from the time I did that.
branches might change.

Contents
--------

### inputrc

- configures `readline` to allow history completion von `<UP>` and `<DOWN>` (the single most useful thing in bash)
- uses case insensitive tab-completion
- lists all results when ambiguous on first tab-completion
- allows word-movement by `<ALT><LEFT>` and `<ALT><RIGHT>`


### gitconfig

- aliases like, `c` for `commit -m` and `ap` for `add --patch` as well as shorthands like `di` and `dc` for `diff --word-diff` and `diff --cached --word-diff` respectively
- pushes the current branch to the configure remote's branch with the same name
- sets up name/email
- configures editor and git ui


