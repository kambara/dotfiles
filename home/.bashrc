export LANG='en_US.UTF-8'
export PS1="\[\e[30m\e[47m\] \u \[\e[30m\e[46m\] \w \[\e[0m\]\n\\$ "

## bash-completion
if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi
