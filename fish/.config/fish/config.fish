if status is-interactive
    if test -z "$DISPLAY" -a -z "$WAYLAND_DISPLAY"
        exex dbus-run-session sway
    end

    eval (starship init fish)
end

function fish_greeting
    # remove greeting
end

set -gx PATH $HOME/.local/bin $PATH
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx LESS "-RFX"


bind ctrl-ц backward-kill-word
bind ctrl-в 'test (commandline) = ""; and exit'
bind ctrl-g tmux-sessionizer
bind ctrl-f 'firefox &'

alias projector='mpv --profile=projector --title=projector'
