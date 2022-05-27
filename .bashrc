#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#--------------------------------------------------
# prompt
#---------------------------------------------------
userP='\[\e[0;33m\]\u\[\e[m\]' # this method of wrapping is importatn
hostP='\[\e[0;35m\]\h\[\e[m\]' # so the terminal knows where to put the
headP='\[\e[0;32m\]$\[\e[m\]' # curesur and doesn't overwrite your prompt
dircP='\[\e[2;29m\]\w\[\e[m\]'
topcorP='\[\e[2;29m\]┌─\[\e[m\]'
botcorP='\[\e[2;29m\]└\[\e[m\]'

PS1="$topcorP $dircP \n$botcorP $userP@$hostP$headP "

#---------------------------------------------------
# exports
#---------------------------------------------------
export TERM=xterm-256color

#---------------------------------------------------
# aliases
#---------------------------------------------------
alias ls='ls --color=auto'
alias la="ls -al"
alias dot="$EDITOR $HOME/dot"
alias note="$EDITOR $HOME/note"
alias cf="clang-format -style='{BasedOnStyle: llvm, IndentWidth: 8}'"

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
