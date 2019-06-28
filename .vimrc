" root {
    if $USER == 'root'
        set nobackup
        set noswapfile
        set noundofile
    else
        set backup
        set backupdir=$HOME/.vim/anydir
        set swapfile
        set undodir=$HOME/.vim/anydir
        set undofile
    endif
" }

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

" ip {
    function! s:ip()
        return "\<C-v>0" . (getpos('.')[2] - 1) . 'l'
                \ . 'o0' . (getpos('.')[2] - 1) . 'l'
    endfunction

    vnoremap <expr> ip 'ip' . (mode() !=# "\<C-v>"? '': <SID>ip())
" ip }

" map {
    let mapleader = "\<Space>"

    cnoremap <C-K> <C-\>e strpart(getcmdline(), 0, getcmdpos()-1)<CR>
    cnoremap <C-\> \<\><Left><Left>
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
    set ttyfast
    set viminfo='20,s10
    set virtualedit=block
    set visualbell t_vb=
    set wildignore=*.dvi,*.pdf,*.aux,*.cpc
    set wildmode=list:longest,full

    " } (for cinkeys)
" set }

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

" D {
    function! <SID>test_D()
        let a = ''
        " sort by 35th column (cursor position)
        "                         v

        let b0='dummmmy'|let  a3= 1 | let a.=a3
        let b2='dummmy'|let   a0= 3 | let a.=a0
        let b3='dummy'|let    a1= 0 | let a.=a1
        let b1='dummmmmy'|let a2= 2 | let a.=a2

        echo (a == '0123'? 'ok ': 'failed ') . a . ' 0123'
        echo ' '
        unlet a a0 a1 a2 a3 b0 b1 b2 b3
    endfunction

    function! <SID>func_D()
        execute "'{;'}-sort /\\%" . getcurpos()[2] . "v/"
    endfunction

    noremap <Leader>d :call <SID>func_D()<CR>
    "map <Leader>t gg/test_D<CR>/1<CR>j:noh<CR> dV}}kko{jjj s:undo<CR>
" D }

" filetype {
    filetype plugin on
" filetype }

" vimrc_local {
    if filereadable(glob("~/.vimrc_local"))
        source ~/.vimrc_local
    endif
" vimrc_local }

