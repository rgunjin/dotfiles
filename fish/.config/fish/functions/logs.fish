function logs --description "Show today's log"
    set -l file ~/notes/logs/(date +%F).md
    test -e $file; and cat $file; or echo "no entries today"
end
