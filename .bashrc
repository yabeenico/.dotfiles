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
        EXIS_STATUS=$?

        C_W='\e[37m' # WHITE
        C_C='\e[36m' # CYAN
        C_M='\e[35m' # MAGENTA
        C_B='\e[34m' # BLUE
        C_Y='\e[33m' # YELLOW
        C_G='\e[32m' # GREEN
        C_R='\e[31m' # RED
        C_K='\e[30m' # BLACK

        _main(){
            T=$(tty|tr -cd [0-9])
            S=$WINDOW
            U=$USER
            H=$(hostname -s)
            W=$(pwd|sed "s,^$HOME,~,")
            echo -e $1[$T:$S] $U@$H:$2$W$3
        }
        _main '\e]0;' '' '\a' # window_title_begin,,window_title_end
        _main $C_C $C_G ''     # cyan,green,none

        [[ $EXIS_STATUS = 0 ]] && echo -en $C_W || echo -en $C_R
        [[ $EUID        = 0 ]] && echo -en '# ' || echo -en '$ '
    }

    export PS1='$(_ps1)\[\e[m\]'
# ps1 }

# ls {
    alias   ls='ls -Fh --color=auto'
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
        git log --oneline --graph --branches --decorate=full $width
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
alias vi='vim'
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

