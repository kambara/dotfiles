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

## powerline-shell
function _update_ps1() {
  PS1=$(powerline-shell $?)
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
