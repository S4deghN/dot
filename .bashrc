#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#--------------------------------------------------
# prompt
#---------------------------------------------------
__ps1() {
    ExitCode=$(Ex=$?; [[ $Ex -ne 0 ]] && echo [$Ex])
    Branch=$(git branch --show-current 2>/dev/null)

    errP='\[\e[1;31m\]$ExitCode\[\e[m\]'
    gitP='\[\e[0;31m\]$Branch\[\e[m\]'

    userP='\[\e[0;33m\]\u\[\e[m\]' # this method of wrapping is importatn
    hostP='\[\e[0;29m\]\h\[\e[m\]' # so the terminal knows where to put the
    suffixP='\[\e[0;32m\]$\[\e[m\]' # curesur and doesn't overwrite your prompt
    dircP='\[\e[0;32m\]\w\[\e[m\]'
    topcorP='\[\e[2;29m\]┌─\[\e[m\]'
    botcorP='\[\e[2;29m\]└\[\e[m\]'

    PS1="$userP@$hostP $dircP $gitP\n$errP$suffixP "
}

PROMPT_COMMAND="__ps1"
#---------------------------------------------------
# exports
#---------------------------------------------------
# export TERM=xterm-256color

#---------------------------------------------------
# env
#---------------------------------------------------
# . "$HOME/.cargo/env"

#---------------------------------------------------
# options
#---------------------------------------------------
set -o vi
shopt -s autocd
shopt -s globstar # expands '**' to recursive subdirectories
source ~/.bash_bind
export HISTCONTROL=ignoreboth # ignoreboth is shorthand for ignorespace and ignoredups
export HISTSIZE=50000

#---------------------------------------------------
# aliases
#---------------------------------------------------
alias ls='ls --color=auto --classify'
alias la="ls -al"
alias grep="grep --color=auto"
alias e="$EDITOR"
alias e.="$EDITOR ."
alias vi="$EDITOR"
alias dot="$HOME/dot"
alias note="$HOME/note"
alias enw="$EDITOR $HOME/note/en/words.md"

alias gits="git status"
alias gitd="git diff"
alias gita="git add"
alias gitc="git commit"
alias gitb="git branch"

#Pacman Shortcuts
alias pac-clr-cache="sudo pacman -Scc"
alias pac-unlock="sudo rm /var/lib/pacman/db.lck"
alias pac-size="pacman -Qq | pacman -Qi - | egrep '(Size|Name[^s])' | sed -E 's/ ([KM])iB/\1/' | sed -z 's/\nInstalled/ /g' | perl -pe 's/(Name|Size) *: //g' | column -t | sort -hk2 -r | cat -n | tac"
alias pac-view="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"

#---------------------------------------------------
# completions
#---------------------------------------------------

complete -C vic vic
