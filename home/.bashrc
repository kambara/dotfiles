## Bash
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export PS1="\[\e[30m\e[47m\] \u \[\e[30m\e[46m\] \w \[\e[0m\]\n\\$ "

## bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

## Python
#export PYTHONPATH=/usr/local/lib/python2.7/site-packages/
