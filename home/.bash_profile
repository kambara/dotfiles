if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
_byobu_sourced=1 . /usr/local/Cellar/byobu/5.125/bin/byobu-launch 2>/dev/null || true
