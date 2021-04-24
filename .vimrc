""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" GetCChar {
    function! GetCChar()
        return strcharpart(getline('.')[col('.') - 1:], 0, 1)
    endfunction
" GetCChar }

" highlight {
    syntax on
    " v must be located after 'syntax on'
    set background=dark
    " v must be located after 'set background' premitive
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
    highlight Search      term=bold      cterm=bold      ctermfg=7 ctermbg=4
    " v must be located after 'set background' optional
    highlight ColorColumn term=bold      cterm=bold      ctermfg=7 ctermbg=5
" highlight }

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

" IncrementAbs {
    "function! IncrementAbs(...)
    "    let l:sign = (a:0 >= 1 && a:1 == '-')? '-': '+'
    "    let l:is_invert = 0

    "    if !exists('*strcharpart')
    "        execute 'normal!' . (l:sign == '+'? '': '')
    "        echohl WarningMsg
    "        echo 'warning: IncrementAbs: strcharpart is not supported'
    "        echohl None
    "        return
    "    endif

    "    if GetCChar() == '-'
    "        normal! l
    "    endif

    "    if !(expand('<cword>') =~ '0x[0-9a-fA-F]\+') && GetCChar() =~ '[0-9]'
    "        let l:is_nan_found = search('\%' . line('.') . 'l[^0-9]', 'Wb')
    "        let l:is_invert = GetCChar() == '-'
    "        execute 'normal!' . (l:is_nan_found? 'l': '0')
    "        let l:pos_b = col('.')
    "        call search('[0-9]\+', 'ce')
    "        let l:pos_e = col('.')
    "        let l:length_num = l:pos_e - l:pos_b + 1
    "        let l:num = strcharpart(getline('.')[l:pos_b - 1:], 0, l:length_num)
    "        if l:sign == '-' && l:num <= 1
    "            normal! r0
    "            return
    "        endif
    "    endif

    "    if l:is_invert
    "        execute 'normal!' . (l:sign == '+'? '': '')
    "    else
    "        execute 'normal!' . (l:sign == '+'? '': '')
    "    endif
    "endfunction

    "noremap <C-a> :call IncrementAbs('+')<CR>
    "noremap <C-x> :call IncrementAbs('-')<CR>
" IncrementAbs }

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
    function! s:ip()
        return "\<C-v>0" . (getpos('.')[2] - 1) . 'l'
                \ . 'o0' . (getpos('.')[2] - 1) . 'l'
    endfunction

    vnoremap <expr> ip 'ip' . (mode() !=# "\<C-v>"? '': <SID>ip())
" vip }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
    command! R redraw!
    inoremap <C-g> <Esc>
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
    call system('mkdir ~/.vim/anydir')

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
    set timeout
    set timeoutlen=100
    set ttimeout
    set ttimeoutlen=100
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

