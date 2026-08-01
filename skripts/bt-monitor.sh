while true; do
  if ping -c1 -W2 192.168.200.1 > /dev/null 2>&1; then
    echo "$(date): OK"
  else
    echo "$(date): LOST"
    journalctl -u bluetooth -n5 --no-pager
    journalctl -u NetworkManager -n5 --no-pager
  fi
  sleep 5
done
