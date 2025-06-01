if status is-interactive
    # Устанавливаем переменные окружения до запуска Sway
    set -gx XDG_SESSION_TYPE wayland
    set -gx XDG_CURRENT_DESKTOP sway
    set -gx XDG_SESSION_DESKTOP sway
    set -gx GDK_BACKEND wayland
    set -gx QT_QPA_PLATFORM wayland
    set -gx MOZ_ENABLE_WAYLAND 1
    set -gx SDL_VIDEODRIVER wayland

    # Обновляем окружение для systemd user session
    dbus-update-activation-environment --systemd --all

    if test -z "$DISPLAY" -a -z "$WAYLAND_DISPLAY"
        exec sway
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

