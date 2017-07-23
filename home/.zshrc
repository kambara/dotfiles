######################################
# TMUX
######################################

if which tmux 2>&1 >/dev/null; then
    #if not inside a tmux session, and if no session is started, start a new session
    test -z "$TMUX" && (tmux attach || tmux new-session)
fi

######################################
# Zsh Settings
######################################

## Coloring
autoload -U colors
colors

## Git branch
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr " !!"
zstyle ':vcs_info:git:*' unstagedstr " M"
zstyle ':vcs_info:*' formats " %b%c%u%f "
zstyle ':vcs_info:*' actionformats ' %b|%a '
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+=" ??"
    fi
}
precmd () { vcs_info }
#RPROMPT='${vcs_info_msg_0_}'$RPROMPT

## Prompt
setopt prompt_subst
setopt transient_rprompt
#PROMPT='%{$fg[white]$bg[blue]%} %n@%m %{$fg[green]$bg[white]%}${vcs_info_msg_0_}%{$fg[black]$bg[blue]%} %~ %{$reset_color%}
PROMPT='%{$fg[black]$bg[blue]%} %n@%m %{$fg[black]$bg[cyan]%}${vcs_info_msg_0_}%{$fg[black]$bg[white]%} %~ %{$reset_color%}
%(!.#.$) '
#RPROMPT='[%~]'

## Auto Completion
autoload -U compinit
compinit

## Allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## Completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*:default' menu select=1

## Case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

## History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups hist_savenodups

## Never ever beep ever
setopt NO_BEEP

## Automatically decide when to page a list of completions
LISTMAX=0

## Disable mail checking
MAILCHECK=0

######################################
## Aliases and Custom Commands
######################################

## aliases
alias ls='ls -G'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias lah='ls -lah'
alias v='/usr/share/vim/vim73/macros/less.sh'
alias vi='vim'
alias -g LV='| lv'
alias -g G='| grep'
alias w3m='w3m -no-mouse'
alias rgrep="grep -r --exclude='*.svn-*' --exclude='entries'"
alias bukko='wget --continue --recursive --convert-links --no-parent --no-host-directories --force-directories --wait 1 -e robots=off'

case ${OSTYPE} in
    darwin*)
        alias emacs=/Applications/Emacs.app/Contents/MacOS/Emacs
        ;;
    linux*)
        alias emacs='XMODIFIERS=@im=none emacs'
        ;;
esac

## find by filename
function findname() {
    find ./ -name "*${@}*" | grep -v '.svn\/'
}

## ls after ch
function cd() {
    builtin cd $@ && ls;
}

## move to .trash when rm
function rm() {
    local TRASH=~/.trash
    if ! [ -d $TRASH ]; then
        mkdir $TRASH
    fi
    if [ -d $TRASH ]; then
        local DATE=`date "+%Y-%m-%d_%H:%M:%S"`
        mkdir $TRASH/$DATE
        for i in $@; do
           if [ -e $i ]; then
               mv $i $TRASH/$DATE/
           else 
               echo "$i : not found"
           fi
        done
        echo "trash: $TRASH/$DATE"
    else
        /bin/rm -I $@
    fi
}

######################################
## PATH
######################################

export PATH=/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

ANDROID_SDK=/Applications/android-sdk-macosx
export PATH=$ANDROID_SDK/tools:$PATH
export PATH=$ANDROID_SDK/platform-tools:$PATH
export ANDROID_HOME=$ANDROID_SDK

######################################
# Application Settings
######################################

## Pager Coloring
export LESS='-R'
export LV='-c'

## grep highlight 
export GREP_COLOR="01;34"
export GREP_OPTIONS=--color=auto

## keychain
keychain ~/.ssh/id_rsa
source ~/.keychain/`hostname`-sh

## rbenv
case ${OSTYPE} in
    linux*)
        export PATH=$HOME/.rbenv/bin:$PATH
        ;;
esac
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

## Google Cloud SDK
if [ -f /Users/kambara/google-cloud-sdk/path.zsh.inc ]; then
  source '/Users/kambara/google-cloud-sdk/path.zsh.inc'
fi
if [ -f /Users/kambara/google-cloud-sdk/completion.zsh.inc ]; then
  source '/Users/kambara/google-cloud-sdk/completion.zsh.inc'
fi
