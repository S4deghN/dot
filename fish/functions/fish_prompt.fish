function fish_prompt --description 'Write out the prompt'
    set -l last_status $status
    set -g fish_prompt_pwd_dir_length 0 # disable shortening

    set_color grey
    echo -n '┌─ '
    set_color normal

    prompt_login

    # PWD
    # set_color $fish_color_cwd
    set_color grey
    echo -n " $(prompt_pwd)"
    set_color normal

    __terlar_git_prompt
    fish_hg_prompt
    echo

    if not test $last_status -eq 0
        set_color $fish_color_error
    end

    set_color grey
    echo -n '└ '
    set_color normal

    set_color green
    echo -n '$ '
    set_color normal
end
