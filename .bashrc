#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#---------------------------------------------------
# prompt
#---------------------------------------------------
userP='\e[0;35m\u\e[m'
hostP='\e[0;34m\h\e[m'
headP='\e[0;32m➜ \e[m'

PS1="$userP@$hostP \w $headP "

#---------------------------------------------------
# aliases
#---------------------------------------------------
alias ls='ls --color=auto'
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

#. "$HOME/.cargo/env"
