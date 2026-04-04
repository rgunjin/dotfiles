#!/usr/bin/env fish

set languages c cpp python rust golang
set core_utils grep sed awk find xargs curl make git strace

set options $languages $core_utils

set selected (printf "%s\n" $options | fzf)

if test -z "$selected"
    exit 0
end

read -P "GIMMIE YOUR QUERY: " query
set query (string trim $query)
set query (string replace -a " " "+" $query)

if contains -- $selected $languages
    tmux neww "curl cht.sh/$selected/$query | less"
else
    tmux neww "curl cht.sh/$selected~$query | less"
end
