## Bash
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export PS1="\[\e[30m\e[47m\] \u \[\e[30m\e[46m\] \w \[\e[0m\]\n\\$ "

## bash-completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

## Python
export PYTHONPATH=/usr/local/lib/python2.7/site-packages/

## powerline-shell
#function _update_ps1() {
#    PS1=$(powerline-shell $?)
#}
#
#if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
#    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
#fi

## powerline-status
#if [ -f `which powerline-daemon` ]; then
#  powerline-daemon -q
#  POWERLINE_BASH_CONTINUATION=1
#  POWERLINE_BASH_SELECT=1
#  . /usr/local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
#fi
