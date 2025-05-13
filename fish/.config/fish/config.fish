if status is-interactive
    if test -z "$DISPLAY" -a -z "$WAYLAND_DISPLAY"
        exec sway
    end
end

function fish_greeting
    # remove greeting
end

eval (starship init fish)

bind ctrl-ц backward-kill-word
bind ctrl-в 'test (commandline) = ""; and exit'
