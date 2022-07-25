if status is-interactive
    set fish_greeting
    fzf_key_bindings
    # theme_gruvbox dark medium

    # abbreviations
    abbr .    "$EDITOR \$(fzf --preview 'nvim {}')"
    abbr e    $EDITOR
    abbr e.   $EDITOR .
    abbr dot  $EDITOR $HOME/dot
    abbr note $EDITOR $HOME/note
    abbr enw  $EDITOR $HOME/note/en/words.md
end
