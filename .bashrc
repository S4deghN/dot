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
    Root=$(git rev-parse --show-toplevel 2>/dev/null)
    Root=${Root##*/}

    # every sequence of color code (e.g `\e[31m`) must be wraped inside `\[ \]`
    # so to be treaded as non-printing character. Otherwise the positoning of
    # the cursor becomes faulty. In Readline's config file, `.inputrc`, this
    # method doesn't work and we use `\1 \2` instead according to its manual.
    errP='\[\e[1;31m\]$ExitCode\[\e[m\]'
    [[ -n $Branch ]] && branchP='\[\e[0;31m\] $Branch\[\e[m\]' || branchP=""
    [[ -n $Root ]] && rootP='\[\e[0;35m\] $Root\[\e[m\]' || rootP=""

    userP='\[\e[0;33m\]\u\[\e[m\]'
    hostP='\[\e[0;29m\]\h\[\e[m\]'
    suffixP='\[\e[0;32m\]$\[\e[m\]'
    dircP='\[\e[0;32m\]\w\[\e[m\]'

    PS1="$userP@$hostP $dircP$branchP $errP\n$suffixP "
}

PROMPT_COMMAND="__ps1"
#---------------------------------------------------
# exports
#---------------------------------------------------
# export TERM=xterm-256color

#---------------------------------------------------
# options
#---------------------------------------------------
set -o vi
shopt -s autocd
# expands '**' to recursive subdirectories
shopt -s globstar
# ignoreboth is shorthand for ignorespace and ignoredups
export HISTCONTROL=ignoreboth:erasedups
# If  set,  the  history list is appended to the file named by the value of the
# HISTFILE variable when the shell exits, rather than overwriting the file. (in
# order to prevent the issue of lossig bash session history when multiple
# instances are running)
shopt -s histappend
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
alias gitl="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all"


#Pacman Shortcuts
alias pac-rm-cache="sudo pacman -Scc"
alias pac-rm-orphan="pacman -Qtdq | sudo pacman -Rns -"
alias pac-unlock="sudo rm /var/lib/pacman/db.lck"
alias pac-size="pacman -Qq | pacman -Qi - | egrep '(Size|Name[^s])' | sed -E 's/ ([KM])iB/\1/' | sed -z 's/\nInstalled/ /g' | perl -pe 's/(Name|Size) *: //g' | column -t | sort -hk2 -r | cat -n | tac"
alias pac-view="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"

#---------------------------------------------------
# env
#---------------------------------------------------
[[ -f "/usr/share/fzf/key-bindings.bash" ]] && . "/usr/share/fzf/key-bindings.bash"

# -----------------------------------------------
# --- functions ---
# -----------------------------------------------
# READLINE variable are only populated if the function is called by `bind -x`
# TODO: what? why? how can I use if I don't wanna use bind -x?
vi-dot() {
    query=$(find ~/dot -not -path "*/\.git/*" -type f 2>/dev/null)
    [[ -z $query ]] && exit 1

    local expr=$(printf "%s\n" $query | fzf -1 --preview 'highlight -O ansi -l {}')

    if [[ -n $expr ]]; then
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$EDITOR $expr${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#EDITOR} + 1 + ${#expr} ))
    fi
}

vi-note() {
    query=$(find ~/note -not -path "*/\.git/*" -type f 2>/dev/null)
    [[ -z $query ]] && exit 1

    local expr=$(printf "%s\n" $query | fzf -1 --preview 'highlight -O ansi -l {}')

    if [[ -n $expr ]]; then
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$EDITOR $expr${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#EDITOR} + 1 + ${#expr} ))
    fi
}

vi-find() {
    query=$(find . -not -path "*/\.*" -type f 2>/dev/null)
    [[ -z $query ]] && exit 1

    local expr=$(printf "%s\n" $query | fzf -1 --preview 'highlight -O ansi -l {}')

    if [[ -n $expr ]]; then
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$EDITOR $expr${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#EDITOR} + 1 + ${#expr} ))
    fi
}

vi-find-all() {
    query=$(find . -not -path "*/\.git/*" -type f 2>/dev/null)
    [[ -z $query ]] && exit 1

    local expr=$(printf "%s\n" $query | fzf -1 --preview 'highlight -O ansi -l {}')

    if [[ -n $expr ]]; then
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$EDITOR $expr${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#EDITOR} + 1 + ${#expr} ))
    fi
}

fzf-rl() {
    builtin eval "
        builtin bind ' \
            \"\e@\": $(
                builtin bind -l | command fzf +m
            ) \
        '
    "
}

#---------------------------------------------------
# binds
#---------------------------------------------------
bind '"\M-al": accept-line'

bind -x '"\e@vi-dot": vi-dot'
bind -x '"\e@vi-note": vi-note'
bind -x '"\e@vi-find": vi-find'
bind -x '"\e@vi-find-all": vi-find-all'
bind -x '"\e@fzf-rl": fzf-rl';

bind -m vi-insert '"\C-e": "\e@vi-dot\M-al"'
bind -m vi-insert '"\C-n": "\e@vi-note\M-al"'
bind -m vi-insert '"\C-f": "\e@vi-find\M-al"'
bind -m vi-insert '"\ef":  "\e@vi-find-all\M-al"'
bind -m vi-insert '"\C-l": "\e@fzf-rl\e@"'

#---------------------------------------------------
# completions
#---------------------------------------------------
complete -C vic vic

