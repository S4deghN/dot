if status is-interactive
    # set to none
    set fish_greeting

    # acts like autocompletion of vim
    bind -M insert \cn end-of-line

    if test -e (locate fzf_key_bindings)
        fzf_key_bindings
    end

    # abbreviations
    abbr e    $EDITOR
    abbr vi   $EDITOR
    abbr dot  $HOME/dot
    abbr note $HOME/note
    abbr enw  $EDITOR $HOME/note/en/words.md
end
