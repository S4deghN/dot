if status is-interactive
    set fish_greeting
    if fzf_key_bindings
    end
    # theme_gruvbox dark medium

    # abbreviations
    abbr .    "fzf --preview 'nvim {}' | xargs -r $EDITOR"
    abbr e    $EDITOR
    abbr e.   $EDITOR .
    abbr vi   $EDITOR
    abbr vim  $EDITOR
    abbr dot  $EDITOR $HOME/dot
    abbr note $EDITOR $HOME/note
    abbr enw  $EDITOR $HOME/note/en/words.md

    abbr rm 'rm -i'
    abbr mv 'mv -i'
    abbr la 'la -al'
end
