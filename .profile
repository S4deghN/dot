# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export VISUAL=vim
export EDITOR=vim
export TERMINAL=st

export GITLAB_HOME=/srv/gitlab

# Disable accessibility processes of gtk dependend application and DE.
export NO_AT_BRIDGE=1
# export GTK_THEME=Adwaita:dark

export QT_QPA_PLATFORMTHEME="qt5ct"
# export QT_SCALE_FACTOR=1
export QT_AUTO_SCREEN_SCALE_FACTOR=1

export GOPATH="$HOME/.local/go"

# Highlighting for 'less'
export MANROFFOPT="-c"
export LESS_TERMCAP_mb=$'\e[0;33m'
export LESS_TERMCAP_md=$'\e[0;33m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[0;1;38m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_so=$'\e[0;7;35m'
export LESS_TERMCAP_se=$'\e[0m'

# This makes symlinks work on windows with git-bash if developer mode is
# enabled or the process is run as admin.
export MSYS=winsymlinks:nativestrict

export HISTSIZE=-1
export HISTFILESIZE=-1

export FZF_DEFAULT_COMMAND="find . -type f -not -path '*/\.git/*' -not -path '*/\.cargo/*' -not -path '*/\.ccls-cache/*' -not -path '*/\.cache/*' ! -path '*/build/*'"
export FZF_COLORS="fg:-1,fg+:-1,hl:yellow,hl+:yellow:reverse,border:gray,spinner:-1,header:blue,info:green,pointer:white,marker:blue,prompt:white:regular,gutter:-1"
export FZF_DEFAULT_OPTS="\
    --prompt  '󱞵 ' \
    --pointer '' \
    --height 50% \
    --reverse \
    --info inline-right \
    --no-separator \
    --color=$FZF_COLORS \
    --bind alt-a:select-all \
    --bind ctrl-s:select \
    --bind ctrl-l:toggle-preview \
    --bind ctrl-u:page-up \
    --bind ctrl-d:page-down \
    --preview-window hidden \
    "

if [ -d "/sbin" ] ; then
    PATH="/sbin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/.local/go/bin" ] ; then
    PATH="$HOME/.local/go/bin:$PATH"
fi

if [ -d "$HOME/.local/wine_bin" ] ; then
    PATH="$HOME/.local/wine_bin:$PATH"
fi

for bin in $HOME/.local/bin/*/bin; do
    PATH="$bin:$PATH"
done

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "/opt/dmd/usr/bin" ] ; then
    PATH="/opt/dmd/usr/bin:$PATH"
fi

export GEM_HOME=$HOME/.local/share/gem/ruby/3.4.0
if [ -d "$HOME/.local/share/gem/ruby/3.4.0/bin" ] ; then
    PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
fi

# if [[ "$(tty)" = "/dev/tty1" ]]; then
#     pgrep Xorg || startx
# fi
