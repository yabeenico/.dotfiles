alias gis='git status --short'
alias glog='git log --oneline --graph --color=auto'
alias ls='ls -F --color=auto'
alias vi='vim'
alias x='exit'
complete -A hostname ping
complete -A hostname -A user ssh
complete -A user write
complete -d cd
eval `dircolors ~/.colorrc`
export LANG=en_US.UTF-8
export PS1='\[\e]0;'                        # begin window title
export PS1=$PS1'\u@\h: \w'                 #window title
export PS1=$PS1'\a\]'                       # end window title
export PS1=$PS1'\n'                         #\n
export PS1=$PS1'\[\e[36m\]'                 # begin color cyan
export PS1=$PS1'\u@\h: '                   #user@host
export PS1=$PS1'\[\e[32m\]'                 # begin color green
export PS1=$PS1'\w\n'                       #path\n
export PS1=$PS1'$(if [ $? != 0 ];'          #if previous command failed
export PS1=$PS1'then echo "\[\e[31m\]\$ ";' # begin color red
export PS1=$PS1'else echo "\[\e[m\]\$ ";'   # begin color default
export PS1=$PS1'fi)'                        #end if
export PS1=$PS1'\[\e[m\]'                   # begin color default
export TF_CPP_MIN_LOG_LEVEL=2

if [[ -t 1 ]];then
    bind 'set match-hidden-files off'
fi

source ~/.bashrc_local
