######################################
# Zsh Settings
######################################

## Prompt
setopt prompt_subst
setopt transient_rprompt
PROMPT=$'%{$fg[black]$bg[green]%}[@%m]%{${reset_color}%} %(!.#.$) '
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
alias less='/usr/share/vim/vimcurrent/macros/less.sh'
alias vi='vim'
alias v='vim -R'
#alias rm='rm -I'
alias sf='socksify'
alias -g LV='| lv'
alias -g G='| grep'
alias w3m='w3m -no-mouse'
alias rgrep="grep -r --exclude='*.svn-*' --exclude='entries'"
alias firefox-default="firefox -P default --no-remote"
alias firefox-dev="firefox -P dev --no-remote"

## find by filename
function findname() {
    find ./ -name "*${@}*" | grep -v '.svn\/'
}

## ls after ch
function cd() {
    builtin cd $@ && ls;
}

## trash
function rm() {
    if [ -d ~/.trash ]; then
        local DATE=`date "+%y%m%d-%H%M%S"`
        mkdir ~/.trash/$DATE
        for i in $@; do
           if [ -e $i ]; then
               mv $i ~/.trash/$DATE/
           else 
               echo "$i : not found"
           fi
        done
    else
        /bin/rm -I $@
    fi
}

######################################
## PATH
######################################

PATH=$PATH:/sbin:/var/lib/gems/1.8/bin
APPS=~/work/misc/apps
PATH=$PATH:$APPS/bin:~/work/misc/chalow:$APPS/appengine-java-sdk-1.2.5/bin:$APPS/google_appengine
export PATH

######################################
# Application Settings
######################################

## Pager Coloring
export LESS='-R'
export LV='-c'

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

## screen
function ssh_screen(){
    eval server=\${$#}
    screen -t $server ssh "$@"
}
if [ x$TERM = xscreen ]; then
	alias ssh=ssh_screen
fi

function socksify_ssh_screen(){
    eval server=\${$#}
    screen -t $server socksify ssh "$@"
}

if [ x$TERM = xscreen ]; then
	alias sssh=socksify_ssh_screen
fi

if [ "$TERM" = "screen" ]; then
        chpwd () { echo -n "_`dirs`\\" }
        preexec() {
                # see [zsh-workers:13180]
                # http://www.zsh.org/mla/workers/2000/msg03993.html
                emulate -L zsh
                local -a cmd; cmd=(${(z)2})
                case $cmd[1] in
                        fg)
                                if (( $#cmd == 1 )); then
                                        cmd=(builtin jobs -l %+)
                                else
                                        cmd=(builtin jobs -l $cmd[2])
                                fi
                                ;;
                        %*) 
                                cmd=(builtin jobs -l $cmd[1])
                                ;;
                        cd)
                                if (( $#cmd == 2)); then
                                        cmd[1]=$cmd[2]
                                fi
                                ;&
                        *)
                                echo -n "k$cmd[1]:t\\"
                                return
                                ;;
                esac

                local -A jt; jt=(${(kv)jobtexts})

                $cmd >>(read num rest
                        cmd=(${(z)${(e):-\$jt$num}})
                        echo -n "k$cmd[1]:t\\") 2>/dev/null
        }
        chpwd
fi

screen -xRR
