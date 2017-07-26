#!/bin/bash

flag="$@"

function relink() {
  ln -s -v $flag $2 $1
}

DOTFILES=$(pwd)

cd

relink .bash_profile     $DOTFILES/bash_profile
relink .gemrc            $DOTFILES/gemrc
relink .gitconfig        $DOTFILES/gitconfig
relink .vimrc            $DOTFILES/vimrc
relink .gemrc            $DOTFILES/gemrc
relink .tmux.conf        $DOTFILES/tmux.conf
relink .gitignore_global $DOTFILES/gitignore_global
