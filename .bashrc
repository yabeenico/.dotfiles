#!/bin/bash

# bashrc_local_begin {
    if [[ -f ~/.bashrc_local_begin ]]; then
        source ~/.bashrc_local_begin
    fi
# bashrc_local_begin }

# bind {
    if [[ -t 1 ]]; then
        stty stop undef
        stty werase undef #delete <C-w> binding
    fi
# bind }

# complete_filter {
    cf_tex='aux|bbl|blg|dvi|lof|lot|pdf|toc'
    cf_media='aac|ac3|avi|flac|flv|iso|m4a|m4v|mkv|mov|mp3|mp4|wav|webm'
    cf_img='bmp|gif|jpg|png|tiff|svg'

    complete_filter="*.@(pdf|$cf_tex|$cf_media|$cf_img)"
    complete_filter_media="*.@($cf_media)"
    complete -F _longopt -X "$complete_filter" tail
    complete -fX "$complete_filter" vi vim
    complete -fX "!$complete_filter_media" mpc
# complete_filter }

# dircolors {
    [[ -f ~/.colorrc ]] && eval `dircolors -b ~/.colorrc`
# dircolors }

# docker }
    if which jq &>/dev/null; then
        mkdir -p ~/.docker/
        (
            cat ~/.docker/config.json 2>/dev/null
            cat ~/.dotfiles/docker-config.json
        ) |
        jq -s add |
        tee ~/.docker/config.json >/dev/null
    else
        jq
    fi
# docker }

# git {
    _gdl(){
        svn checkout $(
            echo $1|
            sed 's,\(github.com/[^/]\+/[^/]\+\)/[^/]\+/[^/]\+,\1/trunk,'
        )
    }

    glogf(){
        FORMAT='%C(yellow)%h%Creset %cd %C(cyan)%an%Creset %s %Cgreen%d%Creset'
        git log \
            --oneline \
            --date=format:'%Y-%m-%dT%H:%M:%S%z' \
            --date-order \
            --pretty=format:"$FORMAT"\
            "$@"
            #--graph \
            #--branches \
            #--tags \
            #--remotes \
            #--decorate=full \
    }

    glog(){
        HEIGHT_PROMPT=$(bash -ic "echo \"$PS1\";$PROMPT_COMMAND" | wc -l)
        HEIGHT_WINDOW=$(stty size|cut -f1 -d" ")
        HEIGHT=$((HEIGHT_WINDOW - HEIGHT_PROMPT * 2))
        if [[ $* =~ --graph ]]; then
            glogf "$@" --color=always -$HEIGHT | head -n $HEIGHT
        else
            glogf "$@" --color=auto   -$HEIGHT
        fi
    }
    alias glogo='glog origin/master'
    alias glogg='glog --graph'

    gpull(){
        (
            echo gpull: $1
            cd -P $1
            local GIS=$(git status -s)
            if [[ $GIS = '' ]]; then
                git pull
            else
                echo "$GIS"
            fi
        )
    }

    gic(){
        git commit -m "$*"
    }

    alias gis='git status --short'
# git }

# kubernetes {
    if [[ ! -d ~/git/kubectx ]]; then
        which git &>/dev/null &&
        git clone https://github.com/ahmetb/kubectx ~/git/kubectx
    fi
    if [[ -d ~/git/kubectx ]]; then
        source ~/git/kubectx/completion/kubectx.bash
        source ~/git/kubectx/completion/kubens.bash
    fi
    alias kctx=kubectx
    alias kns=kubens
# kubernetes }

# ls {
    alias   ls='ls -Fh --color=auto --time-style=+%Y-%m-%dT%H:%M:%S%:z'
    alias    l='ls'
    alias    s='ls'
    alias   sl='ls'
    alias  lls='ls'
    alias  lsd='ls'
    alias  lsl='ls'
    alias  sls='ls'
    alias   l1='ls -1'
    alias  ls1='ls -1'
    alias   la='ls -a'
    alias  lsa='ls -a'
    alias  lal='ls -al'
    alias  lla='ll -al'
    alias   lt='ls -lt'
    alias  lst='ls -t'
    alias lstr='ls -t'
    alias  alt='ls -alt'
    alias  lat='ls -alt'
    alias  lta='ls -alt'
    alias llta='ls -alt'
    alias lsta='ls -alt'
    alias   ll='ls -l'
    alias  lll='ls -l'
    alias   tl='ls -lt'
    alias  llt='ls -lt'
    alias lltr='ls -ltr'
    alias llrt='ls -ltr'
    alias  ltl='ls -lt'
    alias  ltr='ls -ltr'
    alias  lrt='ls -ltr'
    alias  laz='ls -Za'
    alias  lza='ls -Za'
    alias   lz='ls -Z'
    alias  llz='ls -Z'
    alias  ltz='ls -Zt'
    alias latz='ls -Zat'
    alias  llr='ls -lr'
    alias lsrt='ls -rt'
# ls }

# ps1 {
    # \001: begin non-printed-sequence
    # \002: end   non-printed-sequence
    # \033: esc
    export C_D="\001\033[m\002"     # default
    export C_K="\001\033[1;30m\002" # black
    export C_R="\001\033[1;31m\002" # red
    export C_G="\001\033[1;32m\002" # green
    export C_Y="\001\033[1;33m\002" # yellow
    export C_B="\001\033[1;34m\002" # blue
    export C_M="\001\033[1;35m\002" # magenta
    export C_C="\001\033[1;36m\002" # cyan
    export C_W="\001\033[1;37m\002" # white

    _ps1_date(){
        echo -en "[$C_C"
        TZ=UTC date -Is | tr -d '\n'
        echo -en "$C_D] "
    }

    _ps1_screen(){
        if [[ -z $WINDOW ]]; then
            return 1
        else
            printf "[$C_C$WINDOW$C_D] "
            return 0
        fi
    }

    alias iskubeon='which kubectl &>/dev/null && [[ -f ~/.kube/ps1 ]]'
    alias kubeon='touch ~/.kube/ps1'
    alias kubeoff='rm -f ~/.kube/ps1'
    _ps1_kube(){
        iskubeon || return 1
        echo -en "[${C_C}k8s:${C_G}"
            kubectl config get-contexts --no-headers |
            grep '\*' |
            awk '{printf($3"/"$5)}' |
            cat
        echo -en "$C_D] "
    }

    alias isingit='git remote &>/dev/null'
    _ps1_git(){
        GRP=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) &&
        echo -ne "[${C_C}git:${C_G}${GRP}${C_D}] "
    }

    _ps1_uhw(){
        local U=$USER
        local H=${HOSTNAME%%.*}
        local W=${PWD/$HOME/\~}

        local WTB="\001\033]0;\002" # window title begin
        local WTE="\001\007\002"    # window title end

        [[ ! $(tty) =~ tty ]]  && printf "$WTB$H:$W$WTE"    # window title
        printf "\033[?7711h"                                # mintty marker
        printf "$C_C$U@$H:$C_G$W"                           # user@host:path
        printf $C_D
    }

    _ps1_dollar(){
        [[ $EXIT_STATUS = 0 ]] && printf $C_W || printf $C_R # color
        [[ $EUID        = 0 ]] && printf '# ' || printf '$ ' # $
        printf $C_D
    }

    _ps1(){
        set +x

        temp_kube=$(  mktemp); _ps1_kube   >$temp_kube   & # real    0m0.069s
        temp_git=$(   mktemp); _ps1_git    >$temp_git    & # real    0m0.020s
        temp_date=$(  mktemp); _ps1_date   >$temp_date   & # real    0m0.021s
        temp_uhw=$(   mktemp); _ps1_uhw    >$temp_uhw    & # real    0m0.014s
        temp_dollar=$(mktemp); _ps1_dollar >$temp_dollar & # real    0m0.000s
        temp_screen=$(mktemp); _ps1_screen >$temp_screen & # real    0m0.000s
        wait; wait; wait; wait; wait; wait;
        echo "$(cat $temp_{date,screen,kube,git})"
        echo "$(cat $temp_uhw)"
        echo "$(cat $temp_dollar)"
        rm -f $temp_{kube,git,date,uhw,dollar,screen} &

    }

    export PS1='$(_ps1)'

    export PROMPT_COMMAND='EXIT_STATUS=$?; (set +x;echo)'
# ps1 }

# recycle: rotate {
    recycle(){
        if [[ $1 = --gc ]]; then
            cd ~/recycle/
            while du -bd0 . | awk '{exit $1<100*1000**3}'; do # while . > 100G
                rm -rf ./"$(ls -tr | head -n1)"
            done
            return
        fi

        for i in "$@"; do
            rotate ~/recycle/"$(basename $i)" 2>/dev/null
            mv "$i" ~/recycle/
        done
    }

    alias re=recycle
# recycle }

# rotate {
    rotate(){
        usage(){
            echo USAGE:
            echo '   rotate file'
        }

        FILE="$1"

        if [[ "$*" = '' ]]; then
            echo error: specify a file >&2
            echo >&2
            usage >&2
            return 1
        elif [[ "$*" =~ '--help' ]]; then
            usage
            return
        elif [[ ! -e "$FILE" ]]; then
            echo "error: '$FILE' not found" >&2
            return 1
        fi

        LAST=$(
            ls |
            egrep "^$FILE\.[1-9][0-9]*$" |
            awk -v FS=. '{print $NF}' |
            sort -n |
            awk 'BEGIN{last = 0} $0 == NR{last = $0} END{print last}' |
            cat
        )
        #echo "$LAST";return

        CMD=$(
            for i in $(seq 1 $LAST); do
                printf 'mv -n %q.%d %q.%d\n' "$FILE" $i "$FILE" $((i + 1))
            done |
            tac
            printf 'mv -n %q %q.1\n' "$FILE" "$FILE"
        )
        #echo "$CMD";return

        echo "$CMD" |
        bash
    }
# rotate }

# scraping {
    htt(){ ([[ -z $* ]] && cat || echo "$1") | sed -E 's,^h?t?t?p?,http,'; }
    a(){ [[ ! -z $2 ]] && { n=$1; shift;}; axel -an ${n:-5} $(htt "$1"); }
    w(){ wget $(htt "$1"); }
# scraping }

# screen {
    scs(){
        v=$1
        screen bash -c '
            screen -S $STY -X eval \
            "split '$v'" \
            "stuff " \
            "focus next" \
            "screen" \
            "focus next" \
            "layout save default" \
            ;bash
        '
    }
    alias scv='scs -v'
    chmod 600 ~/.c &>/dev/null
# screen }

# u {
    u(){
        if [[ $SHELL =~ termux ]]; then
            apt-get update &&
            apt-get dist-upgrade -y &&
            apt-get autoremove -y
        elif [[ -f /etc/debian_version ]]; then
            sudo apt-fast autoremove -y &&
            sudo apt-fast update &&
            sudo apt-fast dist-upgrade -y &&
            sudo apt-fast autoremove -y
        elif [[ -f /etc/centos-release ]]; then
            sudo yum update -y
        fi &&
        echo && gpull ~/.dotfiles &&
        echo && gpull ~/.ssh
    }
# u }

# vimmv {
    vimmv(){
        vim <(ls | xargs -d\\n -n1 -II printf "mv -n %q/%s\n" I I | column -ts/)
    }
# vimmv }

HISTFILESIZE=10000
HISTSIZE=10000
alias ..='cd ..'
alias :q='exit'
alias apt=apt-fast
alias cutc='cut -c-$COLUMNS'
alias em='emacs'
alias ema='emacs'
alias ffmpeg='2>&1 ffmpeg'
alias ffprobe='2>&1 ffprobe'
alias gdl=_gdl
alias grep='grep -s --color=auto'
alias k=kubectl
alias mp4box=MP4Box
alias posh='powershell.exe -nologo'
alias q='exit'
alias sb='source ~/.bashrc'
alias sc=screen
alias sort='LC_ALL=en_UK.UTF-8 sort'
alias sudo='sudo '
alias tm=tmux
alias vb='vim ~/.bashrc'
alias vbl='vim ~/.bashrc_local'
alias vc='vim ~/Dropbox/note/contents.txt'
alias vi='vi -u NONE'
alias vl='vim ~/Dropbox/opt/animesuite/list.txt'
alias vn='vim ~/n/music/syn/0new/0new.m3u8'
alias vs='vim ~/Dropbox/note/song.txt'
alias vsa='vim ~/Dropbox/note/song.txt.arcive'
alias vt='vim ~/Dropbox/note/todo.txt'
alias watch='watch '
alias x='exit'
complete -A hostname ping
complete -A user write
complete -fX '!*.pdf' -o plusdirs evince
complete -fX '!*.svg' -o plusdirs inkscape
complete -fX '!*.svg' -o plusdirs svg2pdf
export EDITOR=/usr/bin/vim
export HISTCONTROL=ignoreboth
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT='%F %T '
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS='-iqQRSX'
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
export PATH=/mnt/c/ProgramData/chocolatey:$PATH
export PATH=~/.local/bin:$PATH
export PATH=~/.opt/bin:$PATH
export PATH=~/Dropbox/opt/bin:$PATH
export PATH=~/Dropbox/opt/music:$PATH
export TF_CPP_MIN_LOG_LEVEL=2
function datei(){ date '+%FT%T%:z (%a' | perl -pe '$_=lc;s/.$/)/'; }
function touchx(){ touch "$1" && chmod +x "$1"; }
set bell-style none
shopt -s cdspell
shopt -s checkjobs
shopt -s checkwinsize
shopt -s cmdhist
shopt -s complete_fullquote
shopt -s expand_aliases
shopt -s extglob
shopt -s extquote
shopt -s force_fignore
shopt -s histreedit
shopt -s histverify
shopt -s interactive_comments
shopt -s mailwarn
shopt -s progcomp
shopt -s promptvars
shopt -s sourcepath
shopt -u autocd
shopt -u cdable_vars
shopt -u checkhash
shopt -u compat31
shopt -u compat32
shopt -u compat40
shopt -u compat41
shopt -u compat42
shopt -u compat43
shopt -u direxpand
shopt -u dirspell
shopt -u dotglob
shopt -u execfail
shopt -u extdebug
shopt -u failglob
shopt -u globasciiranges
shopt -u globstar
shopt -u gnu_errfmt
shopt -u histappend
shopt -u hostcomplete
shopt -u huponexit
shopt -u inherit_errexit
shopt -u lastpipe
shopt -u lithist
shopt -u login_shell # may not be changed
shopt -u no_empty_cmd_completion
shopt -u nocaseglob
shopt -u nocasematch
shopt -u nullglob
shopt -u restricted_shell # may not be changed
shopt -u shift_verbose
shopt -u xpg_echo

# bashrc_local {
    if [[ -f ~/.bashrc_local ]]; then
        source ~/.bashrc_local
    fi
# bashrc_local }

export PATH=$(echo $PATH | awk 'BEGIN{RS = ORS = ":"} !a[$1]++' | head -1)
