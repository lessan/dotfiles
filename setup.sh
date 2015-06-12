#!/bin/bash

flag="$@"

function relink() {
  ln -s -v $flag $2 $1
}

DOTFILES=$(pwd)

cd

relink .bash_aliases $DOTFILES/bash_aliases
relink .gemrc        $DOTFILES/gemrc
relink .gitconfig    $DOTFILES/gitconfig
relink .vimrc        $DOTFILES/vimrc
