
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
    let s:dein_dir = expand('~/.cache/vim/dein')
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
        call dein#load_toml(expand('~/.vim/dein.toml'), {'lazy': 0})
        call dein#end()
        call dein#save_state()
    endif
    if dein#check_install()
        call dein#install()
    endif
" dein }

" GetCChar {
    function! GetCChar()
        return strcharpart(line('.')[col('.') - 1:], 0, 1)
    endfunction
" GetCChar }

" highlight {
    syntax on
    " v must be located after 'syntax on'
    set background=dark
    " v must be located after 'set background', premitives (h group-name)
    highlight Comment     term=bold      cterm=none      ctermfg=6 ctermbg=none
    highlight Constant    term=underline cterm=none      ctermfg=1 ctermbg=none
    highlight Identifier  term=underline cterm=none      ctermfg=2 ctermbg=none
    highlight Statement   term=bold      cterm=none      ctermfg=3 ctermbg=none
    highlight PreProc     term=underline cterm=none      ctermfg=5 ctermbg=none
    highlight Type        term=underline cterm=none      ctermfg=2 ctermbg=none
    highlight Special     term=bold      cterm=none      ctermfg=5 ctermbg=none
    highlight Underlined  term=underline cterm=underline ctermfg=5 ctermbg=none
    highlight Ignore      term=none      cterm=bold      ctermfg=7 ctermbg=none
    highlight Error       term=reverse   cterm=bold      ctermfg=7 ctermbg=1
    highlight Todo        term=standout  cterm=none      ctermfg=0 ctermbg=3
    " v must be located after 'set background', optionals
    highlight ColorColumn term=bold cterm=bold ctermfg=7 ctermbg=4
    highlight markdownError ctermbg=none
    highlight Search term=bold cterm=bold ctermfg=7 ctermbg=4
    highlight Visual term=reverse cterm=reverse

" HighlightInfo {
    function! s:get_hi(synname)
        redir => hi
        execute 'silent highlight ' . a:synname
        redir END
        return hi . (hi =~ "links to"? s:get_hi(split(hi)[-1]): "")
    endfunction

    function! s:highlight_info()
        let synid = synID(line('.'), col('.'), 1)
        let synname = synIDattr(synid, 'name')
        echo s:get_hi(synname)
    endfunction

    command! HighlightInfo call s:highlight_info()
" HighlightInfo }

" J {
    command! -range J
        \ '<+1,'>s/^ \+//e|
        \ '<,'>j!|
        \ call histdel("/",-1)|
        \ let @/=histget("/",-1)
" J }

" nrformats {
    if v:version >= 800
        set nrformats=alpha,bin,hex
    else
        set nrformats=alpha,hex
    endif
" nrformats }

" remember_cursor_position {
    augroup cursorPosition
        autocmd BufRead *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \     execute "normal g`\"" |
            \ endif
    augroup END
" remember_cursor_position }

" vip {
    function! s:linep(direction)
        let l:mark = a:direction < 0? "'{": "'}"
        let l:l = line(l:mark)
        return line(l:l) == ""? l:l - a:direction: l:l
    endfunction

    function! s:movep(direction)
        let l:n = abs(line(".") - <SID>linep(a:direction))
        if !l:n | return "" | endif
        let l:jk = a:direction < 0? "k": "j"
        call feedkeys(virtcol(".") . "|" . l:n . l:jk . "oo")
        return ""
    endfunction

    function! s:moveip()
        let l:view = winsaveview()
        call s:movep(1)
        call feedkeys("o")
        call s:movep(-1)
        call winrestview(l:view)
        return ""
    endfunction

    vnoremap <expr> { (mode() ==# "\<C-v>"? <SID>movep(-1): "{")
    vnoremap <expr> } (mode() ==# "\<C-v>"? <SID>movep(+1): "}")
    vnoremap <expr> p (mode() ==# "\<C-v>"? <SID>moveip():  "p")
    vmap ip p
" vip }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map {
    let mapleader = "\<Space>"

    cnoremap <C-K> <C-\>e strpart(getcmdline(), 0, getcmdpos()-1)<CR>
    cnoremap <C-\> \<\><Left><Left>
    cnoremap <C-a> <C-b>
    cnoremap <C-b> <Left>
    cnoremap <C-d> <Delete>
    cnoremap <C-f> <Right>
    cnoremap <C-n> <Down>
    cnoremap <C-p> <Up>
    command! MK w | silent make | redraw!
    command! R redraw!
    inoremap <C-g> <Esc>
    noremap 0 ^
    noremap <C-K> <Nop>
    noremap <C-e> 2<C-e>
    noremap <C-h> 2zl
    noremap <C-j> 2<C-y>
    noremap <C-k> 2<C-e>
    noremap <C-l> 2zh
    noremap <C-y> 2<C-y>
    noremap <Leader><Esc> <Esc>
    noremap <Leader>s :source %<CR>
    noremap <Leader>t :Template 
    noremap <Leader>p :let &paste = !&paste \| set paste?<CR>
    noremap K kJ
    noremap ^ 0
    noremap gj j
    noremap gk k
    noremap j gj
    noremap k gk
    vnoremap <Leader>s y:@"<CR>
    vnoremap G  10000000j
    vnoremap gg 10000000k
    vnoremap gj 10000000j
    vnoremap gk 10000000k

    " } (for inoremap)
" map }

" anydir {
    let s:anydir = expand('~/.cache/vim/anydir')
    call system('mkdir -p ' . s:anydir)
    let &backupdir=s:anydir
    let &directory=s:anydir
    let &undodir=s:anydir
" anydir }

" set {

    set backspace=eol,indent,start
    set backup
    set cindent
    set cinkeys-=0#
    set cinkeys-=0{
    set colorcolumn=81
    set completeopt=menuone,longest,preview
    set conceallevel=0
    set cursorline
    set expandtab tabstop=4 shiftwidth=0 softtabstop=-1
    set fileignorecase
    set hlsearch
    set ignorecase
    set incsearch
    set indentkeys-=0#
    set iskeyword=@,48-57,_,192-255,#,-
    set laststatus=2
    set lazyredraw
    set list
    set listchars=tab:>>,trail:~,
    set modeline
    set mouse=
    set notimeout
    set nowildignorecase
    set nowildmenu
    set nowrap
    set nowrapscan
    set number
    set ruler
    set runtimepath+=$HOME/.vim/plugins/vim-systemverilog
    set showcmd
    set smartcase
    set spellfile=~/.vim/spell/en.utf-8.add
    set spelllang=en,cjk
    set swapfile
    set ttimeout
    set ttimeoutlen=100
    set ttyfast
    set undofile
    set viminfo='20,s10
    set virtualedit=block
    set visualbell t_vb=
    set wildignore=*.dvi,*.pdf,*.aux,*.cpc
    set wildmode=list:longest,full

    " } (for cinkeys)
" set }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
    " for map {{{
    "map <Leader>t gg/test_D<CR>/1<CR>j:noh<CR> dV}}kko{jjj s:undo<CR>
    " for map }}
" D }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" filetype {
    filetype plugin on
" filetype }

" vimrc_local {
    if filereadable(glob("~/.vimrc_local"))
        source ~/.vimrc_local
    endif
" vimrc_local }
