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
# export TERM=xterm-256color

#---------------------------------------------------
# env
#---------------------------------------------------
#. "$HOME/.cargo/env"

#---------------------------------------------------
# aliases
#---------------------------------------------------
alias ls='ls --color=auto'
alias la="ls -al"
alias grep="grep --color=auto"
alias e="$EDITOR"
alias e.="$EDITOR ."
alias dot="$EDITOR $HOME/dot"
alias note="$EDITOR $HOME/note"
alias enw="$EDITOR $HOME/note/en/words.md"

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
alias pac-size="pacman -Qq | pacman -Qi - | egrep '(Size|Name[^s])' |
    sed -E 's/ ([KM])iB/\1/' | sed -z 's/\nInstalled/ /g' |
    perl -pe 's/(Name|Size) *: //g' | column -t | sort -hk2 -r | cat -n | tac"
