function log --description "Append an entry to today's log"
    set -l dir ~/notes/logs
    set -l file $dir/(date +%F).md
    mkdir -p $dir
    test -e $file; or echo "# "(date +%F) > $file
    echo "- "(date +%H:%M)" $argv" >> $file
end
