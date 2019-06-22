" encoding {
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=iso-2022-jp,euc-jp,utf-8,sjis,cp932

    augroup fileencodings
        autocmd!
        autocmd BufReadPost *
            \ if &modifiable&&search('[^\x00-\x7f]', 'nw')==0|
            \     set fileencoding= |
            \ endif
    augroup END
" encoding }

" dein {
    let s:dein_dir = expand('~/.vim/dein')
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
    if &runtimepath !~# '/dein.vim'
        if !isdirectory(s:dein_repo_dir)
            let s:dein_get = '!git clone https://github.com/Shougo/dein.vim'
            execute s:dein_get s:dein_repo_dir
        endif
        execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
    endif
    if dein#load_state(s:dein_dir)
        call dein#begin(s:dein_dir)
        let g:rc_dir    = s:dein_dir . '/rc'
        let s:toml      = g:rc_dir . '/dein.toml'
        let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
        call dein#load_toml(s:toml,      {'lazy': 0})
        call dein#load_toml(s:lazy_toml, {'lazy': 1})
        call dein#end()
        call dein#save_state()
    endif
    if dein#check_install()
        call dein#install()
    endif
" dein }

" HighlightInfo {
    function! s:get_syn_id(transparent)
        let synid = synID(line('.'), col('.'), 1)
        return a:transparent ? synIDtrans(synid) : synid
    endfunction
        function! s:get_syn_name(synid)
        return synIDattr(a:synid, 'name')
    endfunction
    function! s:show_highlight_info()
        execute "highlight " . s:get_syn_name(s:get_syn_id(0))
        execute "highlight " . s:get_syn_name(s:get_syn_id(1))
    endfunction
    command! HighlightInfo call s:show_highlight_info()
" HighlightInfo }

" J {
    command! -range J
        \ '<+1,'>s/^ \+//e|
        \ '<,'>j!|
        \ call histdel("/",-1)|
        \ let @/=histget("/",-1)
" J }

" remember_cursor_position {
    augroup cursorPosition
        autocmd BufRead *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \     execute "normal g`\"" |
            \ endif
    augroup END
" remember_cursor_position }

" nrformats {
    if v:version >= 800
        set nrformats=alpha,bin,hex
    else
        set nrformats=alpha,hex
    endif
" nrformats }

" map {
    let mapleader = "\<Space>"

    cnoremap <C-K> <C-\>e strpart(getcmdline(), 0, getcmdpos()-1)<CR>
    cnoremap <C-a> <C-b>
    cnoremap <C-b> <Left>
    cnoremap <C-f> <Right>
    cnoremap <C-n> <Down>
    cnoremap <C-p> <Up>
    command! MK w | silent make | redraw!
    inoremap {<CR> {}<Left><CR><Esc><S-o>
    noremap 0 ^
    noremap <C-K> <Nop>
    noremap <C-e> 2<C-e>
    noremap <C-h> 2zl
    noremap <C-j> 2<C-y>
    noremap <C-k> 2<C-e>
    noremap <C-l> 2zh
    noremap <C-y> 2<C-y>
    noremap <Leader>s :source %<CR>
    noremap K kJ
    noremap ^ 0
    noremap gj j
    noremap gk k
    noremap j gj
    noremap k gk
    vnoremap <Leader>s y:@"<CR>

    " } (for inoremap)
" map }

" set {

    set background=dark
    set backspace=eol,indent,start
    set backup
    set backupdir=$HOME/.vim/anydir
    set cindent
    set cinkeys-=0#
    set cinkeys-=0{
    set colorcolumn=81
    set completeopt=menuone,longest,preview
    set conceallevel=0
    set cursorline
    set directory=$HOME/.vim/anydir
    set expandtab tabstop=4 shiftwidth=0 softtabstop=-1
    set hlsearch
    set ignorecase
    set incsearch
    set indentkeys-=0#
    set iskeyword=@,48-57,_,192-255,#
    set laststatus=2
    set lazyredraw
    set list
    set listchars=tab:>>,trail:~,
    set mouse=nv
    set nofileignorecase
    set notimeout
    set nottimeout
    set nowildignorecase
    set nowildmenu
    set nowrap
    set nowrapscan
    set number
    set ruler
    set runtimepath+=$HOME/.vim/plugins/vim-systemverilog
    set showcmd
    set smartcase
    set smartindent
    set spellfile=~/.vim/spell/en.utf-8.add
    set spelllang=en,cjk
    set swapfile
    set ttyfast
    set undodir=$HOME/.vim/anydir
    set undofile
    set viminfo='20,s10
    set virtualedit=block
    set visualbell t_vb=
    set wildignore=*.dvi,*.pdf,*.aux,*.cpc
    set wildmode=list:longest,full

    " } (for cinkeys)
" set }

" A {
    function! <SID>test_A()
        let a = '05230000' | echo a == '05300000' a '05300000'
        let a = '05240000' | echo a == '05310000' a '05310000'
        let a = '05250000' | echo a == '06010000' a '06010000'
        let a = '02200000' | echo a == '02270000' a '02270000'
        let a = '02210000' | echo a == '02280000' a '02280000'
        let a = '02220000' | echo a == '03010000' a '03010000'
        unlet a
    endfunction

    function! <SID>define_A()
        let l:date = expand('<cword>')
        let l:last_day = system('
            \ ncal -bhm ' . l:date[0:1] . ' |
            \ tr " " "\n" |
            \ grep -v ^$ |
            \ tail -n 1 |
            \ tr -d "\n" |
            \ cat
        \')
        let l:date_dst = (substitute(l:date, '^0', '', '') + 70000)
        let l:is_over = l:date_dst / 10000 % 100 > l:last_day
        let l:increment = l:is_over? 770000 - (l:last_day - 30) * 10000: 70000

        execute 'command! A normal ' . l:increment . ''
    endfunction

    noremap <Leader>a :call <SID>define_A()<CR>:A<CR>j
    "map <Leader>t gg/test_A<CR>j a.j a a.j aVkkkkkk s:undo<CR>
" A }


" miscellaneous {
    " source $VIMRUNTIME/macros/matchit.vim
" miscellaneous }

" highlight {
    " Must be located after 'syntax on'.
    syntax on
    highlight DiffDelete ctermfg=6 cterm=bold
    highlight Directory ctermfg=6 cterm=bold
    highlight NonText ctermfg=6 cterm=bold
    highlight PreProc ctermfg=6 cterm=bold
    highlight SpecialKey ctermfg=6 cterm=bold
    highlight Underlined ctermfg=6 cterm=bold
" highlight }

" filetype {
    filetype plugin on
" filetype }

" vimrc_local {
    if filereadable(glob("~/.vimrc_local"))
        source ~/.vimrc_local
    endif
" vimrc_local }

