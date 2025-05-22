#!/usr/bin/env fish

# Задаём список языков и утилит
set languages (string split " " "c cpp python rust golang")
set core_utils (string split " " "cat read grep echo tr find xargs sed awk")

# Объединяем два списка
set options $languages $core_utils

# Выбираем через fzf
set selected (printf "%s\n" $options | fzf)

# Просим ввести запрос
read -P "GIMMIE YOUR QUERY: " query

set query (string trim $query)
set query (string replace " " "+" $query)

# Определяем что выбранно, вызывем соответсвующий cht.sh
if test -n $selected
    if contains $selected $languages
        tmux neww "curl cht.sh/$selected/$query | less"
    else
        tmux neww "curl cht.sh/$selected~$query | less"
    end
else
    exit 0
end
