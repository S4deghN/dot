#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '

COLOR_COMMAND='\e[0;28m'
COLOR_OUTPUT='\e[0m'
COLOR_ERROR='\e[1;30;41m'
COLOR_OK='\e[0;30;42m'

if [ $UID = 0 ]
then
  COLOR_ACCENT='\e[0;31m' # Red for root
  COLOR_PATH='\e[0;31m'
  COLOR_USER=$COLOR_PATH
else
  COLOR_PATH='\e[0;29m' # Yellow for sudoers
  COLOR_ACCENT='\e[0;33m'
  COLOR_USER='\e[1;29m'
fi

trap "echo -ne '$COLOR_OUTPUT'" DEBUG
PS1='$(RETURN=$?; if [ $RETURN != 0 ]; then echo -ne "err \[\e[1;38m\]$RETURN\n"; fi; echo -ne "\[\e[0m\]\[$COLOR_USER\]\u\[\[\e[1;38m\]@\[\e[1;36m\]\h \[$COLOR_PATH\]\w \[$COLOR_ACCENT\]\$ \[$COLOR_COMMAND\]")'
PS2='> '
PS3='> '
PS4='+ '

alias la="ls -al"

#Pacman Shortcuts
alias sync="sudo pacman -Syyy"
alias install="sudo pacman -S"
alias update="sudo pacman -Syyu"
alias search="sudo pacman -Ss"
alias search-local="sudo pacman -Qs"
alias pkg-info="sudo pacman -Qi"
alias local-install="sudo pacman -U"
alias clr-cache="sudo pacman -Scc"
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias remove="sudo pacman -R"
alias autoremove="sudo pacman -Rns"

. "$HOME/.cargo/env"
