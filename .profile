# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export VISUAL="nvim"
export EDITOR="nvim"
export TERMINAL=st

export GITLAB_HOME=/srv/gitlab

# Disable accessibility processes of gtk dependend application and DE.
export NO_AT_BRIDGE=1
export GTK_THEME=Adwaita:dark

export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_SCALE_FACTOR=1
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# Highlighting for 'less'
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33m\033[40m'
export LESS_TERMCAP_us=$'\e[1;1;31m'
export LESS_TERMCAP_ue=$'\e[0m'

# This makes symlinks work on windows with git-bash if developer mode is
# enabled or the process is run as admin.
export MSYS=winsymlinks:nativestrict

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.local/wine_bin" ] ; then
    PATH="$HOME/.local/wine_bin:$PATH"
fi

if [ -d "$HOME/.cargo/env" ] ; then
    PATH="$HOME/.cargo/env:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi

# if [[ "$(tty)" = "/dev/tty1" ]]; then
#     pgrep Xorg || startx
# fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
