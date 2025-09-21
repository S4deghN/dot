function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
    set -l normal (set_color normal)
    set -q fish_color_status
    set -g fish_prompt_pwd_dir_length 1 # disable shortening
    or set -g fish_color_status --background=red white

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix '>'
    if functions -q fish_is_root_user; and fish_is_root_user
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix '#'
    end

    # Write pipestatus
    # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
    set -l bold_flag --bold
    set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
    if test $__fish_prompt_status_generation = $status_generation
        set bold_flag
    end
    set __fish_prompt_status_generation $status_generation
    set -l status_color (set_color $fish_color_status)
    set -l statusb_color (set_color $bold_flag $fish_color_status)
    set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

    set -g __fish_git_prompt_show_informative_status
    set -g __fish_git_prompt_showuntrackedfiles

    set -g __fish_git_prompt_color_branch red
    set -g __fish_git_prompt_showupstream "informative"
    set -g __fish_git_prompt_char_upstream_ahead "↑"
    set -g __fish_git_prompt_char_upstream_behind "↓"

    set -g __fish_git_prompt_char_stagedstate "s"
    set -g __fish_git_prompt_char_dirtystate "c"
    set -g __fish_git_prompt_char_untrackedfiles "u"
    set -g __fish_git_prompt_char_conflictedstate "𐄂"
    set -g __fish_git_prompt_char_cleanstate "✓"

    set -g __fish_git_prompt_color_dirtystate blue
    set -g __fish_git_prompt_color_stagedstate yellow
    set -g __fish_git_prompt_color_invalidstate red
    set -g __fish_git_prompt_color_untrackedfiles green
    set -g __fish_git_prompt_color_cleanstate green

    echo -n -s (prompt_login) " " (set_color $color_cwd) (prompt_pwd) $normal (fish_git_prompt) " " $prompt_status \n $suffix " "
end
