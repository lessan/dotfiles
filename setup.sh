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
relink .vim          $DOTFILES/vim
relink .vimrc        $DOTFILES/vimrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
