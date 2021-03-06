#! /usr/bin/bash
ln -sfv $PWD/.profile      $HOME/
ln -sfv $PWD/.bashrc       $HOME/
ln -sfv $PWD/.tmux.conf    $HOME/
ln -sfv $PWD/.clang-format $HOME/
ln -sfv $PWD/fish          $HOME/.config/
ln -sfv $PWD/nvim          $HOME/.config/
ln -sfv $PWD/alacritty     $HOME/.config/

# create directory if it doesn't exist.
# link every existing file individualy instead of the whole folder so existing files are kept.
mkdir -p   $HOME/.config/autostart/
ln    -sfv $PWD/autostart/*    $HOME/.config/autostart/

mkdir -p   $HOME/.local/share/applications/
ln    -sfv $PWD/applications/* $HOME/.local/share/applications/
