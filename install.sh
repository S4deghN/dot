#!/bin/bash

pushd ~/dot/ || return

ln -sfv "$PWD"/.gitconfig    "$HOME"/
ln -sfv "$PWD"/.inputrc      "$HOME"/
ln -sfv "$PWD"/.profile      "$HOME"/
ln -sfv "$PWD"/.bashrc       "$HOME"/
ln -sfv "$PWD"/.clang-format "$HOME"/
ln -sfv "$PWD"/.clang-tidy   "$HOME"/
ln -sfv "$PWD"/vim           "$HOME"/.vim
ln -sfv "$PWD"/bin           "$HOME"/.local/
ln -sfv "$PWD"/tmux          "$HOME"/.config/
ln -sfv "$PWD"/gdb           "$HOME"/.config/
ln -sfv "$PWD"/nvim          "$HOME"/.config/
ln -sfv "$PWD"/fish          "$HOME"/.config/
ln -sfv "$PWD"/ranger        "$HOME"/.config/

if [[ $1 = "-d" ]]; then
    # create directory if it doesn't exist.
    # link every existing file individualy instead of the whole folder so existing files are kept.
    mkdir -p   "$HOME"/.config/autostart/
    ln    -sfv "$PWD"/autostart/*    "$HOME"/.config/autostart/

    mkdir -p   "$HOME"/.local/share/applications/
    ln    -sfv "$PWD"/applications/* "$HOME"/.local/share/applications/

    ln -sfv "$PWD"/.Xmodmap      "$HOME"/
    ln -sfv "$PWD"/.Xresources   "$HOME"/
    ln -sfv "$PWD"/.xprofile     "$HOME"/
    ln -sfv "$PWD"/.xinitrc      "$HOME"/
    ln -sfv "$PWD"/.emacs.d      "$HOME"/
    ln -sfv "$PWD"/rofi          "$HOME"/.config/
    ln -sfv "$PWD"/i3            "$HOME"/.config/
    ln -sfv "$PWD"/i3status      "$HOME"/.config/
    ln -sfv "$PWD"/picom         "$HOME"/.config/
    ln -sfv "$PWD"/polybar       "$HOME"/.config/
    ln -sfv "$PWD"/dunst         "$HOME"/.config/
    ln -sfv "$PWD"/alacritty     "$HOME"/.config/
    ln -sfv "$PWD"/tridactyl     "$HOME"/.config/
    ln -sfv "$PWD"/qutebrowser   "$HOME"/.config/
    ln -sfv "$PWD"/yt-dlp        "$HOME"/.config/
    ln -sfv "$PWD"/share         "$HOME"/.local/share/dot
    # ln -sfv "$PWD"/fontconfig    "$HOME"/.config/
fi

popd || return
