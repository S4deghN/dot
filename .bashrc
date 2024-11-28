#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#--------------------------------------------------
# prompt
#---------------------------------------------------
__ps1() {
    ExitCode=$(Ex=$?; [[ $Ex -ne 0 ]] && echo "[$Ex]")
    Branch=$(git branch --show-current 2>/dev/null)
    Root=$(git rev-parse --show-toplevel 2>/dev/null)
    Root=${Root##*/}

    # every sequence of color code (e.g `\e[31m`) must be wraped inside `\[ \]`
    # so to be treaded as non-printing character. Otherwise the positoning of
    # the cursor becomes faulty. In Readline's config file, `.inputrc`, this
    # method doesn't work and we use `\1 \2` instead according to its manual.
    errP='\[\e[1;31m\]$ExitCode\[\e[m\]'
    [[ -n $Branch ]] && branchP='\[\e[0;31m\] $Branch\[\e[m\]' || branchP=""
    [[ -n $Root ]] && rootP='\[\e[0;35m\]($Root)\[\e[m\]' || rootP=""

    userP='\[\e[0;33m\]\u\[\e[m\]'
    hostP='\[\e[0;29m\]\h\[\e[m\]'
    suffixP='\[\e[0;32m\]\[\e[m\]'
    dircP='\[\e[0;32m\]\w\[\e[m\]'

#   ╭─────╮
#   │ box │
#   ╰─────╯
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
# shopt -s histappend
export HISTSIZE=-1

# Stupid!!!!
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if [ "$DISPLAY" ]; then
        activ_win_id=$(xprop -root _NET_ACTIVE_WINDOW)
        activ_win_id=$(echo "$activ_win_id" | awk '{ activ_win_id=substr($0,41,9); print activ_win_id; }' )
        [ "$activ_win_id" != "0x0" ] &&
            xprop -id "$activ_win_id" -remove WM_NORMAL_HINTS
    fi
fi

#---------------------------------------------------
# aliases
#---------------------------------------------------
#if [[ "$OSTYPE" == "msys" ]]; then
#fi

alias ta="~/Downloads/textadept/textadept-gtk"

alias ls='ls --color=auto --classify'
alias la="ls -alh"
alias grep="grep --color=auto"
alias e="$EDITOR"
alias e.="$EDITOR ."
alias vi="$EDITOR"
alias dot="$HOME/dot"
alias note="$HOME/note"
alias enw="$EDITOR $HOME/note/en/words.md"
alias t="tmux a || tmux"
alias o="octave"
alias r="ranger"

alias gits="git status"
alias gitd="git diff"
alias gitds="git diff --staged"
alias gita="git add"
alias gitc="git commit"
alias gitb="git branch"
# alias gitll="git log --graph --format=format:'%C(yellow)%h%C(reset) - %C(green)%ar%C(reset) %C(blue)%an%C(reset)%C(bold red)%d%C(reset) - %s'"
alias gitll="git log --pretty=format:'%C(red)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(bold blue) <%an>' --decorate --numstat --abbrev-commit"
# alias gitl="git log --graph --oneline"
alias gitl="git log --color --graph --pretty=format:'%C(auto)%h%d %s %C(black)%C(bold)%an, %ar' --abbrev-commit --decorate"
alias giti="git describe --abbrev=4 --dirty --always --tags"

#Pacman Shortcuts
alias pac-rm-cache="sudo pacman -Scc"
alias pac-rm-orphan="pacman -Qtdq | sudo pacman -Rns -"
alias pac-unlock="sudo rm /var/lib/pacman/db.lck"
alias pac-size="pacman -Qq | pacman -Qi - | egrep '(Size|Name[^s])' | sed -E 's/ ([KM])iB/\1/' | sed -z 's/\nInstalled/ /g' | perl -pe 's/(Name|Size) *: //g' | column -t | sort -hk2 -r | cat -n | tac"
alias pac-view="pacman -Slq | fzf --preview 'pacman -Si {}' --layout=reverse"
alias pac-file-of="pacman -Qo"
alias pac-check-integ="pacman -Qikk"

alias bf="WINEPREFIX=~/Games/skylords-reborn/ wine /home/s4/Games/skylords-reborn/drive_c/Program\ Files/BattleForge/BattleForge.exe"

#---------------------------------------------------
# env
#---------------------------------------------------
# Arch
[[ -f "/usr/share/fzf/key-bindings.bash" ]] && . "/usr/share/fzf/key-bindings.bash"
# Debian
[[ -f "/usr/share/doc/fzf/examples/key-bindings.bash" ]] && . "/usr/share/doc/fzf/examples/key-bindings.bash"
# Manual
[[ -f "$HOME/.local/share/key-bindings.bash" ]] && . "$HOME/.local/share/key-bindings.bash"

#---------------------------------------------------
# completions
#---------------------------------------------------
complete -C vic vic
[[ -x $(command -v pomo) ]] && complete -C pomo pomo

# -----------------------------------------------
# --- functions ---
# -----------------------------------------------
split() {
    # Disable globbing.
    # This ensures that the word-splitting is safe.
    set -f

    # Store the current value of 'IFS' so we
    # can restore it later.
    old_ifs=$IFS

    # Change the field separator to what we're
    # splitting on.
    IFS=$2

    # Create an argument list splitting at each
    # occurance of '$2'.
    #
    # This is safe to disable as it just warns against
    # word-splitting which is the behavior we expect.
    # shellcheck disable=2086
    set -- $1

    # Print each list value on its own line.
    printf '%s\n' "$@"

    # Restore the value of 'IFS'.
    IFS=$old_ifs

    # Re-enable globbing.
    set +f
}

# READLINE variable are only populated if the function is called by `bind -x`. The
# advantage of using READLINE stuff over normal functions is command history population
# and easy input usage.
vi-find() {
    selection=$(find "${1:-.}" -name "*${READLINE_LINE:-*}*" \
        -not -path "*/${2:-.}*/*" -type f 2>/dev/null |
        fzf --preview 'highlight -O ansi -l {}')

    if [[ -n $selection ]]; then
        READLINE_LINE="$EDITOR $selection${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( ${#EDITOR} + 1 + ${#selection} ))

        builtin bind '"\e@": accept-line'
    else
        builtin bind '"\e@": abort'
    fi
}

vi-grep() {
    # selection=$(grep --color=always -rni ${READLINE_LINE:-} 2>/dev/null |
    #     fzf --ansi |
    #     awk -F : '{print $1 " +" $2}')
    selection=$(Rg | awk -F : '{print $1 " +" $2}')

    if [[ -n $selection ]]; then
        READLINE_LINE="$EDITOR $selection${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( ${#EDITOR} + 1 + ${#selection} ))

        builtin bind '"\e@": accept-line'
    else
        builtin bind '"\e@": abort'
    fi
}

fzf-rl() {
    builtin eval "
        builtin bind ' \
            \"\e#\": $(
                builtin bind -l | command fzf +m
            ) \
        '
    "
}
bind -x '"\exx":  fzf-rl'
bind -m vi-insert '"\C-l": "\exx\e#"'

#---------------------------------------------------
# binds
#---------------------------------------------------
bind '"\M-al": accept-line'

bind '"\e@": end-of-line'

bind -x '"\ex1": vi-find'
bind -x '"\ex2": vi-find ""     .git'
bind -x '"\ex3": vi-find ~/dot  .git'
bind -x '"\ex4": vi-find ~/note .git'
bind -x '"\ex5": vi-grep'

bind -m vi-insert '"\C-f": "\ex1\e@"'
bind -m vi-insert '"\ef":  "\ex2\e@"'
bind -m vi-insert '"\C-e": "\ex3\e@"'
bind -m vi-insert '"\C-n": "\ex4\e@"'
bind -m vi-insert '"\C-g": "\ex5\e@"'
