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
        local C_D="\001\033[m\002"     # DEFAULT
        local C_K="\001\033[1;30m\002" # BLACK
        local C_R="\001\033[1;31m\002" # RED
        local C_G="\001\033[1;32m\002" # GREEN
        local C_Y="\001\033[1;33m\002" # YELLOW
        local C_B="\001\033[1;34m\002" # BLUE
        local C_M="\001\033[1;35m\002" # MAGENTA
        local C_C="\001\033[1;36m\002" # CYAN
        local C_W="\001\033[1;37m\002" # WHITE

        local U=$USER
        local H=${HOSTNAME%%.*}
        local W=${PWD/$HOME/\~}
        local S=${WINDOW:+[$WINDOW] }

        _main(){ printf "$1$H:$2$W$3\n";}
        _main "\001\033]0;\002" '' "\001\007\002" # window_title begin,,end
        _main "$C_C$S$U@" $C_G ''

        [[ $EXIT_STATUS = 0 ]] && printf $C_W || printf $C_R # color of prompt
        [[ $EUID        = 0 ]] && printf '# ' || printf '$ ' # prompt
        printf $C_D
    }

    export PS1='$(_ps1)'
# ps1 }

# ls {
    alias   ls='ls -FhU --color=auto'
    alias    l=ls
    alias    s=ls
    alias   sl=ls
    alias  lls=ls
    alias  lsl=ls
    alias  sls=ls
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
    alias   tl='ls -lt'
    alias  llt='ls -lt'
    alias  ltl='ls -lt'
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
    complete_filter='*.@('$cf_tex$cf_media'_)'
    complete_filter_media='*.@('$cf_media'_)'
# complete_filter }

# gdl {
    _gdl(){
        svn checkout $(
            echo $1|
            sed 's,\(github.com/[^/]\+/[^/]\+\)/[^/]\+/[^/]\+,\1/trunk,'
        )
    }
# gdl }

# glog {
    _glog(){
        width=-$(($(stty size|cut -f1 -d" ")-8))
        git log --oneline --graph --branches --decorate=full $width $*
    }
# glog }

# dircolors {
    [[ -f ~/.colorrc ]] && eval `dircolors ~/.colorrc`
# dircolors }

alias ..='cd ..'
alias :q='exit'
alias gdl=_gdl
alias gis='git status --short'
alias glog=_glog
alias glogo='glog origin/master'
alias em='emacs'
alias ema='emacs'
alias q='exit'
alias sb='source ~/.bashrc'
alias sc=screen
alias vi='vi -u NONE'
alias x='exit'
complete -A hostname ping
complete -A user write
complete -f -X "$complete_filter" vim
complete -f -X "!$complete_filter_media" -o plusdirs mpc
export EDITOR=/usr/bin/vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS='-iqRS'
export TF_CPP_MIN_LOG_LEVEL=2
shopt -s extglob

if [[ -f ~/.bashrc_local ]]; then
    source ~/.bashrc_local
fi

export PATH=$(echo $PATH|awk 'BEGIN{RS=ORS=":"}!a[$1]++'|head -1)

