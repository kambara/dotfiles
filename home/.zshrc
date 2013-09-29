######################################
# TMUX
######################################

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

if which tmux 2>&1 >/dev/null; then
    #if not inside a tmux session, and if no session is started, start a new session
    test -z "$TMUX" && (tmux attach || tmux new-session)
fi

######################################
# Zsh Settings
######################################

## Prompt
setopt prompt_subst
setopt transient_rprompt
PROMPT=$'%{$fg[black]$bg[green]%}%n@%m%{${reset_color}%} %(!.#.$) '
RPROMPT='[%~]'

## Coloring
autoload -U colors
colors

## Auto Completion
autoload -U compinit
compinit

## Allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## completion
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
#alias emacs='XMODIFIERS=@im=none emacs'
alias emacs=/Applications/Emacs.app/Contents/MacOS/Emacs
alias android-connect='mtpfs -o allow_other /media/104SH'
alias android-disconnect='fusermount -u /media/104SH'

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

PATH=$PATH:/sbin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/local/sbin

## ~/work
PATH=$PATH:~/work/var/chalow
PATH=$PATH:~/work/var/bin
APPS=~/work/var/apps
PATH=$PATH:$APPS/appengine-java-sdk/bin
PATH=$PATH:$APPS/google_appengine
PATH=$PATH:$APPS/android-sdk-linux/tools
PATH=$PATH:$APPS/android-sdk-linux/platform-tools

## RVM
# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

export PATH

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
/usr/local/bin/keychain ~/.ssh/id_dsa
source ~/.keychain/`hostname`-sh

## RVM
# source $HOME/.rvm/scripts/rvm

## rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi


