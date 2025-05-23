if status is-interactive
    if test -z "$DISPLAY" -a -z "$WAYLAND_DISPLAY"
        exec sway
    end
end

function fish_greeting
    # remove greeting
end

set -gx PATH $HOME/.local/bin $PATH
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx LESS "-RFX"

eval (starship init fish)

bind ctrl-ц backward-kill-word
bind ctrl-в 'test (commandline) = ""; and exit'
bind ctrl-g tmux-sessionizer
alias projector='mpv --profile=projector --title=projector'
