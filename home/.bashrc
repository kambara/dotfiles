## Bash
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

## Python
export PYTHONPATH=/usr/local/lib/python2.7/site-packages/

## bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

## Bash-it
#export BASH_IT="/Users/kambara/.bash_it"
#export BASH_IT_THEME='powerline-multiline'
#export SCM_CHECK=true
#unset MAILCHECK
#source "$BASH_IT"/bash_it.sh

## powerline-status
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi
