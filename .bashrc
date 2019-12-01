# bind {
    if [[ -t 1 ]];then
        bind 'set match-hidden-files off'
        #bind '"\e[1;5D" backward-word'
        #bind '"\e[1;5C" forward-word'
        stty stop undef
        stty werase undef #delete <C-w> binding
        bind '"\C-w": unix-filename-rubout'
    fi
# bind }

# ps1 {
    _ps1(){
        local EXIT_STATUS=$?

        # octal sequence description:
        # \001: begin non-printed-sequence
        # \002: end   non-printed-sequence
        # \033: esc
        local C_D="\001\033[m\002"     # default
        local C_K="\001\033[1;30m\002" # black
        local C_R="\001\033[1;31m\002" # red
        local C_G="\001\033[1;32m\002" # green
        local C_Y="\001\033[1;33m\002" # yellow
        local C_B="\001\033[1;34m\002" # blue
        local C_M="\001\033[1;35m\002" # magenta
        local C_C="\001\033[1;36m\002" # cyan
        local C_W="\001\033[1;37m\002" # white

        local U=$USER
        local H=${HOSTNAME%%.*}
        local W=${PWD/$HOME/\~}
        local S=${WINDOW:+[$WINDOW] }

        local WTB="\001\033]0;\002" # window title begin
        local WTE="\001\007\002"    # window title end

        #_main(){ printf "$1$H:$2$W$3\n";}
        #_main "\001\033]0;\002" '' "\001\007\002" # window_title begin,,end
        #_main "$C_C$S$U@" $C_G ''

        [[ ! $(tty) =~ tty ]]  && printf "$WTB$H:$W$WTE"
        printf "\n$C_C$S$U@$H:$C_G$W\n"
        [[ $EXIT_STATUS = 0 ]] && printf $C_W || printf $C_R # color of prompt
        [[ $EUID        = 0 ]] && printf '# ' || printf '$ ' # prompt
        printf $C_D
    }

    export PS1='$(_ps1)'

    export PROMPT_COMMAND='echo -ne "\e[2 q"'
# ps1 }

# ls {
    alias   ls='ls -Fh --color=auto --time-style=+%Y-%m-%dT%H:%M:%S%:z'
    alias    l='ls'
    alias    s='ls'
    alias   sl='ls'
    alias  lls='ls'
    alias  lsl='ls'
    alias  sls='ls'
    alias   l1='ls -1'
    alias  ls1='ls -1'
    alias   la='ls -a'
    alias  lsa='ls -a'
    alias  lal='ls -al'
    alias  lla='ll -al'
    alias   lt='ls -lt'
    alias  lst='ls -lt'
    alias  alt='ls -alt'
    alias  lat='ls -alt'
    alias  lta='ls -alt'
    alias llta='ls -alt'
    alias lsta='ls -alt'
    alias   ll='ls -l'
    alias  lll='ls -l'
    alias   tl='ls -lt'
    alias  llt='ls -lt'
    alias  ltl='ls -lt'
    alias  laz='ls -Za'
    alias  lza='ls -Za'
    alias   lz='ls -Z'
    alias  llz='ls -Z'
    alias  ltz='ls -Zt'
    alias latz='ls -Zat'
# ls }

# complete_filter {
    _complete_filter() {
        grep -v '^ *$'|
        awk '{printf("%s|",$1)}'
    }
    cf_tex=$(cat<<<"
        aux
        bbl
        blg
        dvi
        lof
        lot
        pdf
        toc
    "|_complete_filter)

    cf_media=$(cat<<<"
        aac
        ac3
        avi
        flac
        flv
        iso
        m4a
        m4v
        mkv
        mov
        mp3
        mp4
        wav
        webm
    "|_complete_filter)

    cf_img=$(cat<<<"
        bmp
        gif
        jpg
        png
        tiff
    "|_complete_filter)

    complete_filter='*.@(''pdf|'$cf_tex$cf_media$cf_img'_)'
    complete_filter_media='*.@('$cf_media'_)'

    type _filedir_xspec &>/dev/null
    if [[ $? = 0 ]]; then
        complete -F _filedir_xspec -X "$complete_filter" vim
        complete -F _filedir_xspec -X "!$complete_filter_media" -o plusdirs mpc
    fi

    type _longopt &>/dev/null
    if [[ $? = 0 ]]; then
        complete -F _longopt -X "$complete_filter" tail
    fi
# complete_filter }

# gdl {
    _gdl(){
        svn checkout $(
            echo $1|
            sed 's,\(github.com/[^/]\+/[^/]\+\)/[^/]\+/[^/]\+,\1/trunk,'
        )
    }

    _glog(){
        if [[ -t 1 ]]; then
            COLOR=always
        else
            COLOR=auto
        fi

        HEIGHT=$(($(stty size|cut -f1 -d" ")-8))

        git -c color.ui=$COLOR \
            log --date-order --oneline --graph --branches --decorate=full $* |
        head -n $HEIGHT
    }

    _gpull(){
        (
            echo _gpull: $1
            cd -P $1
            local GIS=$(git status -s)
            if [[ $GIS = '' ]]; then
                git pull
            else
                echo "$GIS"
            fi
        )
    }
# git }

# u {
    function u(){
        if [[ "$SHELL" =~ termux ]]; then
            apt-get update &&
            apt-get dist-upgrade -y &&
            apt-get autoremove -y
        elif [[ -f /etc/debian_version ]]; then
            sudo apt-fast update &&
            sudo apt-fast dist-upgrade -y &&
            sudo apt-fast autoremove -y
        elif [[ -f /etc/centos-release ]]; then
            sudo yum update -y
        fi &&
        echo && _gpull ~/.dotfiles &&
        echo && _gpull ~/.ssh
    }
# u }

# dircolors {
    [[ -f ~/.colorrc ]] && eval `dircolors ~/.colorrc`
# dircolors }

# touchx {
    touchx(){
        touch "$1" &&
        chmod +x "$1"
    }
# touchx }

# datei {
    datei(){
        if [[ "$@" = '' ]]; then
            date '+%Y-%m-%d%H:%M:%S%z%a' |
            perl -pe '$_ = lc; s/(.{10})(.{11})(.{2})(.{2})./$1T$2:$3 ($4)/' |
            cat
        else
            date "$@"
        fi
    }
# datei }

alias ..='cd ..'
alias :q='exit'
alias a='axel -an 20'
alias apt=apt-fast
alias em='emacs'
alias ema='emacs'
alias ffmpeg='2>&1 ffmpeg'
alias ffprobe='2>&1 ffprobe'
alias gdl=_gdl
alias gis='git status --short'
alias glog=_glog
alias glogo='glog origin/master'
alias grep='grep -s --color=auto'
alias mp4box=MP4Box
alias q='exit'
alias sb='source ~/.bashrc'
alias sc=screen
alias sort='LC_ALL=en_UK.UTF-8 sort'
alias sudo='sudo '
alias vb='vim ~/.bashrc'
alias vbl='vim ~/.bashrc_local'
alias vc='vim ~/Dropbox/note/contents.txt'
alias vi='vi -u NONE'
alias vl='vim ~/Dropbox/opt/animesuite/list.txt'
alias vn='vim ~/n/music/syn/0new/0new.m3u8'
alias vs='vim ~/Dropbox/note/song.txt'
alias vsa='vim ~/Dropbox/note/song.txt.arcive'
alias vt='vim ~/Dropbox/note/todo.txt'
alias x='exit'
complete -A hostname ping
complete -A user write
complete -f -X '!*.pdf' -o plusdirs evince
export EDITOR=/usr/bin/vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS='-iqRS'
export TF_CPP_MIN_LOG_LEVEL=2
shopt -s extglob

if [[ -f ~/.bashrc_local ]]; then
    source ~/.bashrc_local
fi

export PATH=$(echo $PATH | awk 'BEGIN{RS = ORS = ":"} !a[$1]++' | head -1)

