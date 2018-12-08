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
    PS1=''
    PS1=$PS1'$(echo $? > /tmp/$USER.ps1)'           # save exit status
    PS1=$PS1'\[\e]0;'                               # begin window title
    PS1=$PS1'['                                     #  [
    PS1=$PS1'$(tty|sed "s,/dev/pts/,,")'            #  (pts_number)
    PS1=$PS1':'                                     #  :
    PS1=$PS1'${WINDOW:+$WINDOW}'                    #  (screen_number)
    PS1=$PS1'] '                                    #  ] 
    PS1=$PS1'\u@\h'                                 #  (user)@(host)
    PS1=$PS1': \w'                                  #  : (path)
    PS1=$PS1'\a\]'                                  # end window title
    PS1=$PS1'\n'                                    #  \n
    PS1=$PS1'\[\e[36m\]'                            # begin color cyan
    PS1=$PS1'['                                     #  [
    PS1=$PS1'$(tty|cut -b10-)'                      #  (pts_number)
    PS1=$PS1':'                                     #  :
    PS1=$PS1'${WINDOW:+$WINDOW}'                    #  (screen_number)
    PS1=$PS1'] '                                    #  ] 
    PS1=$PS1'\u@\h: '                               #  (user)@(host)
    PS1=$PS1'\[\e[32m\]'                            # begin color green
    PS1=$PS1'\w\n'                                  #  : (path)\n
    PS1=$PS1'$(if [[ $(cat /tmp/$USER.ps1) = 0 ]];' # if exit status is 0
    PS1=$PS1'then echo "\[\e[37m\]\$";'             #  $ begin color white
    PS1=$PS1'else echo "\[\e[31m\]\$";'             #  $ begin color red
    PS1=$PS1'fi)'                                   # end if
    PS1=$PS1'\[\e[m\] '                             # begin color default
    export PS1
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
eval `dircolors ~/.colorrc`
export EDITOR=/usr/bin/vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS='-iSR'
export TF_CPP_MIN_LOG_LEVEL=2
shopt -s extglob

if [[ -f ~/.bashrc_local ]]; then
    source ~/.bashrc_local
fi

export PATH=$(echo $PATH|awk 'BEGIN{RS=ORS=":"}!a[$1]++'|head -1)

