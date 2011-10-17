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
alias ls='ls --color=always'
alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias lah='ls -lah'
alias v='/usr/share/vim/vimcurrent/macros/less.sh'
alias vi='vim'
#alias rm='rm -I'
alias sudo="sudo env PATH=$PATH"
alias sf='socksify'
alias -g LV='| lv'
alias -g G='| grep'
alias w3m='w3m -no-mouse'
alias rgrep="grep -r --exclude='*.svn-*' --exclude='entries'"
alias firefox-default="firefox -P default --no-remote"
alias firefox-dev="firefox -P dev --no-remote"
alias bukko='wget --continue --recursive --convert-links --no-parent --no-host-directories --force-directories --wait 1 -e robots=off'
alias emacs='XMODIFIERS=@im=none emacs'

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

PATH=$PATH:/sbin:/var/lib/gems/1.8/bin
PATH=$PATH:~/work/var/chalow
PATH=$PATH:~/work/var/bin
APPS=~/work/var/apps
PATH=$PATH:$APPS/appengine-java-sdk-1.2.5/bin
PATH=$PATH:$APPS/google_appengine
PATH=$PATH:$APPS/android-sdk-linux_x86/tools
export PATH

######################################
# Application Settings
######################################

## Pager Coloring
export LESS='-R'
export LV='-c'

## Ruby
export RUBYOPT=-Ku

## RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

## Node.js (nave)
NAVESH=$HOME/.nave/nave.sh
if [ -f $NAVE ]; then
#    $HOME/.nave/nave.sh use latest
fi

## JMF
export JMFHOME=/home/kambara/app/lib/JMF-2.1.1e
export CLASSPATH=.:$JMFHOME/lib/jmf.jar:${CLASSPATH}
export LD_LIBRARY_PATH=$JMFHOME/lib:${LD_LIBRARY_PATH}

## JOGL
export JOGL_HOME=/home/kambara/app/lib/jogl-1.1.1-linux-i586
export CLASSPATH=$JOGL_HOME/lib/jogl.jar:$JOGL_HOME/lib/gluegen-rt.jar:${CLASSPATH}
export LD_LIBRARY_PATH=$JOGL_HOME/lib:${LD_LIBRARY_PATH}

## Java3D
export J3D_HOME=/home/kambara/app/lib/j3d-1_5_2
export CLASSPATH=$J3D_HOME/lib/ext/j3dcore.jar:$J3D_HOME/lib/ext/j3dutils.jar:$J3D_HOME/lib/ext/vecmath.jar:${CLASSPATH}
export LD_LIBRARY_PATH=$J3D_HOME/lib/i386:${LD_LIBRARY_PATH}

## OpenCV
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

## AdobeReader9 Japanese Font Bug
## - https://forums.ubuntulinux.jp/viewtopic.php?id=5509&p=1
export ACRO_DISABLE_FONT_CONFIG=1

## grep highlight 
export GREP_COLOR="01;34"
export GREP_OPTIONS=--color=auto

## xmodmap
if [ -e ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

## keychain
/usr/bin/keychain ~/.ssh/id_dsa
source ~/.keychain/`hostname`-sh
