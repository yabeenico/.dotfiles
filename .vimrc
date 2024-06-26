" vim-plug {{{
    source ~/.vim/vim-plug.vim
" vim-plug }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" after_vim_plug_vimrc after=vim-plug {{{
    augroup after_vim_plug_vimrc
        autocmd!
        autocmd FileType yaml,yaml.ansible setlocal indentkeys=o,O
        autocmd FileType vim setlocal indentkeys-==}
        autocmd FileType vim setlocal indentkeys-=0\\
    augroup END
" after_vim_plug_vimrc after=vim-plug }}}

" anydir {{{
    let s:anydir = expand('~/.cache/vim/anydir')
    call system('mkdir -p ' . s:anydir)
    let &backupdir=s:anydir
    let &directory=s:anydir
    let &undodir=s:anydir
" anydir }}}

" encoding {{{
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=iso-2022-jp,euc-jp,utf-8,sjis,cp932

    augroup fileencodings
        autocmd!
        autocmd BufReadPost *
            \ if &modifiable&&search('[^\x00-\x7f]', 'nw')==0|
            \     set fileencoding= |
            \ endif
    augroup end
" encoding }}}

" GetCChar {{{
    function! GetCChar()
        return strcharpart(line('.')[col('.') - 1:], 0, 1)
    endfunction
" GetCChar }}}

" highlight {{{
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
    highlight SpellBad ctermbg=1 ctermfg=0
    highlight Visual term=reverse cterm=reverse
" highlight }}}

" HighlightInfo {{{
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
" HighlightInfo }}}

" J {{{
    command! -range J
        \ '<+1,'>s/^ \+//e|
        \ '<,'>j!|
        \ call histdel("/",-1)|
        \ let @/=histget("/",-1)
" J }}}

" Leader {{{
    let mapleader = "\<Space>"
    noremap <Leader><Esc> <Esc>
    noremap <Leader>s :source %<CR>
    noremap <Leader>t :Template 
    noremap <Leader>p :let &paste = !&paste \| set paste?<CR>
    vnoremap <Leader>s y:@"<CR>
" Leader }}}

" Leader _ delete underbar {{{
    nnoremap <silent><Leader>_ yyp:s/_//g<CR>A <Esc>0elDkJ:noh<CR>
" Leader _ delete underbar }}}

" Leader c CopipeTerm copy {{{
    nnoremap <silent><Leader>c :<C-u>call <SID>CopipeTerm()<CR>
    " https://saihoooooooo.hatenablog.com/entry/2013/07/09/112527
    function! s:CopipeTerm()
        if !exists('b:copipe_term_save')
            let b:copipe_term_save = {
            \     'number': &l:number,
            \     'relativenumber': &relativenumber,
            \     'foldcolumn': &foldcolumn,
            \     'wrap': &wrap,
            \     'list': &list,
            \     'showbreak': &showbreak
            \ }
            setlocal foldcolumn=0
            setlocal nonumber
            setlocal norelativenumber
            setlocal wrap
            setlocal nolist
            set showbreak=
            IndentLinesDisable
            if get(g:, 'ale_sign_column_always', "notdefined") != "notdefined"
                let b:copipe_term_save['g:ale_sign_column_always'] = g:ale_sign_column_always
                let b:copipe_term_save['g:ale_enabled'] = g:ale_enabled
                let g:ale_sign_column_always = 0
                ALEDisable
            endif
        else
            let &l:foldcolumn = b:copipe_term_save['foldcolumn']
            let &l:number = b:copipe_term_save['number']
            let &l:relativenumber = b:copipe_term_save['relativenumber']
            let &l:wrap = b:copipe_term_save['wrap']
            let &l:list = b:copipe_term_save['list']
            let &showbreak = b:copipe_term_save['showbreak']
            IndentLinesEnable
            if get(g:, 'ale_sign_column_always', "notdefined") != "notdefined"
                let g:ale_sign_column_always =
                    \ b:copipe_term_save['g:ale_sign_column_always']
                ALEDisable
                if b:copipe_term_save['g:ale_enabled']
                    ALEEnable
                endif
            endif
            unlet b:copipe_term_save
        endif
    endfunction
" Leader c CopipeTerm copy }}}

" Leader d {{{
    noremap <Leader>d :call <SID>func_D()<CR>
    " {{ (for syntax)
    "map <Leader>t gg/test_D<CR>/1<CR>j:noh<CR> dV}}kko{jjj s:undo<CR>
    " } (for syntax)

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
" Leader d }}}

" map {{{

    cnoremap <C-K> <C-\>e strpart(getcmdline(), 0, getcmdpos()-1)<CR>
    cnoremap <C-\> <Home>\<<END>\><Left>
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
    noremap K kJ
    noremap ^ 0
    noremap gj j
    noremap gk k
    noremap j gj
    noremap k gk
    vnoremap G  10000000j
    vnoremap gg 10000000k
    vnoremap gj 10000000j
    vnoremap gk 10000000k

" map }}}

" nrformats {{{
    if v:version >= 800
        set nrformats=alpha,bin,hex
    else
        set nrformats=alpha,hex
    endif
" nrformats }}}

" remember_cursor_position {{{
    augroup cursorPosition
        autocmd BufRead *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \     execute "normal g`\"" |
            \ endif
    augroup END
" remember_cursor_position }}}

" set {{{

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
    set foldcolumn=3
    set foldlevel=99
    set foldmethod=marker
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
    set showcmd
    set smartcase
    set spellfile=~/.vim/spell/en.utf-8.add
    set spelllang=en,cjk
    set swapfile
    set tags+=~/.local/lib/tags
    set ttimeout
    set ttimeoutlen=100
    set ttyfast
    set undofile
    set viminfo='20,s10
    set virtualedit=block
    set visualbell t_vb=
    set wildignore=*.dvi,*.pdf,*.aux,*.cpc
    set wildmode=list:longest,full

    " } (for syntax)
" set }}}

" vip {{{
    function! s:linep(direction) " retval range: [0, $+1]
        let l:line = line(a:direction < 0? "'{": "'}")
        if l:line ==       1   | let l:line  = getline( 1 ) != ""? 0: 1 | endif
        if l:line == line('$') | let l:line += getline('$') != ""? 1: 0 | endif
        return l:line
    endfunction

    function! s:movep(direction)
        let l:n = abs(line(".") - <SID>linep(a:direction) + a:direction)
        if l:n == 0 | return "" | endif
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
" vip }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" filetype {{{
    filetype plugin on
" filetype }}}

" vimrc_local {{{
    if filereadable(glob("~/.vimrc_local"))
        source ~/.vimrc_local
    endif
" vimrc_local }}}

