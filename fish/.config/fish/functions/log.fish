function log --description "Append an entry to today's log"
    set -l dir ~/notes/logs
    set -l file $dir/(date +%F).md
    mkdir -p $dir
    test -e $file; or printf '# %s\n\n' (date +%F) > $file
    printf -- '- %s %s\n' (date +%H:%M) "$argv" >> $file
end
