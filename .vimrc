" dein {
let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
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

" remember_cursor_position {
augroup cursorPosition
    autocmd BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
            \ exe "normal g`\"" | endif
augroup END
" remember_cursor_position }

" nrformats {
if v:version >= 800
    set nrformats=alpha,bin,hex
else
    set nrformats=alpha,hex
endif
" nrformats }

noremap <Left> <Nop>
noremap <Right> <Nop>
cnoremap <C-K> <C-\>e strpart(getcmdline(), 0, getcmdpos()-1)<CR>
cnoremap <C-a> <C-b>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
command! MK w | silent make | redraw!
inoremap {<CR> {}<Left><CR><Esc><S-o>
noremap 0 ^
noremap <C-e> 2<C-e>
noremap <C-j> gj
noremap <C-k> gk
noremap <C-l> <Space>
noremap <C-y> 2<C-y>
noremap ^ 0
noremap gj j
noremap gk k
noremap j gj
noremap k gk
noremap <C-S-k> <Nop>
noremap <C-k> <Nop>
noremap <S-k> <Nop>
set background=dark
set backspace=eol,indent,start
set backup
set backupdir=$HOME/.vim/backupdir
set cindent
set colorcolumn=81
set completeopt=menuone,longest,preview
set cursorline
set directory=$HOME/.vim/directory
set expandtab
set fileencodings=utf-8,iso-2022-jp,euc-jp
set hlsearch
set ignorecase
set incsearch
set iskeyword=@,48-57,_,192-255,#
set laststatus=2
set lazyredraw
set mouse=nv
set nofileignorecase
set nowildignorecase
set nowildmenu
set nowrap
set nowrapscan
set number
set ruler
set shiftwidth=4
set showcmd
set smartcase 
set smartindent
set softtabstop=4
set spellfile=~/.vim/spell/en.utf-8.add
set spelllang=en,cjk
set swapfile
set tabstop=4
set timeoutlen=0
set ttimeoutlen=0
set ttyfast
set undodir=$HOME/.vim/undodir
set undofile
set viminfo='20,s10
set visualbell t_vb=
set wildignore=*.dvi,*.pdf,*.aux,*.cpc
set wildmode=list:longest,full
syntax on

" augroup {
augroup vimrc
    autocmd!
    autocmd BufRead,BufNewFile *.html filetype plugin indent on
    autocmd BufRead,BufNewFile *.html setl filetype=html
    autocmd BufRead,BufNewFile *.md setl filetype=markdown
    autocmd BufRead,BufNewFile *.tex setl shiftwidth=1
    autocmd BufRead,BufNewFile *.tex setl softtabstop=1
    autocmd BufRead,BufNewFile *.tex setl tabstop=1
    autocmd FileType make setl noexpandtab
    autocmd FileType python setl autoindent
    autocmd FileType python setl cinwords=class,def,elif,else,except,finally
    autocmd FileType python setl cinwords^=for,if,try,while,with
    autocmd FileType python setl nocindent
    autocmd FileType python setl smartindent 
    autocmd FileType verilog setl cinwords+=begin
    autocmd FileType verilog setl cinwords+=
    autocmd FileType vim syn keyword vimOption contained nofileignorecase
    autocmd FileType vim syn keyword vimOption contained nowildignorecase
augroup end
" augroup }

" highlight {
highlight DiffDelete ctermfg=6 cterm=bold 
highlight Directory ctermfg=6 cterm=bold 
highlight NonText ctermfg=6 cterm=bold 
highlight PreProc ctermfg=6 cterm=bold 
highlight SpecialKey ctermfg=6 cterm=bold 
highlight Underlined ctermfg=6 cterm=bold 
" highlight }

if filereadable('~/.vimrc_local')
    source ~/.vimrc_local
endif

