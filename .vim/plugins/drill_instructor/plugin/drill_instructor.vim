" The Enter, Esc and Tab key can't be distinguished on a vim on a terminal.

function! drill_instructor#alert_insert(name, alias)
    echohl ErrorMsg
    echo "Don't use " . a:name . " key! Press " . a:alias . " instead!"
    echohl None
    if (&showmode)
        sleep 100m
    endif
endfunction

function! <SID>alert_insert(name, alias)
    call drill_instructor#alert_insert(a:name, a:alias)
endfunction

inoremap <Backspace> <C-o>:call <SID>alert_insert("Backspace", "\<C-h\> ")<CR>
inoremap <Left>      <C-o>:call <SID>alert_insert("Left     ", "\<Esc\>h")<CR>
inoremap <Down>      <C-o>:call <SID>alert_insert("Down     ", "\<Esc\>j")<CR>
inoremap <Up>        <C-o>:call <SID>alert_insert("Up       ", "\<Esc\>k")<CR>
inoremap <Right>     <C-o>:call <SID>alert_insert("Right    ", "\<Esc\>l")<CR>

noremap <Backspace> :echoerr "Don't use Backspace key! Use \<C-h\> instead."<CR>
noremap <Left>      :echoerr "Don't use Left      key! Use h       instead."<CR>
noremap <Down>      :echoerr "Don't use Down      key! Use j       instead."<CR>
noremap <Up>        :echoerr "Don't use Up        key! Use k       instead."<CR>
noremap <Right>     :echoerr "Don't use Right     key! Use l       instead."<CR>

