## Export

export BYOBU_PREFIX=/usr/local
export PYTHONPATH=/usr/local/lib/python2.7/site-packages/

## Byobu launch

_byobu_sourced=1 . /usr/local/bin/byobu-launch 2>/dev/null || true

## Bash-it

export BASH_IT="/Users/kambara/.bash_it"
export BASH_IT_THEME='powerline-plain'
export SCM_CHECK=true
unset MAILCHECK
source "$BASH_IT"/bash_it.sh

