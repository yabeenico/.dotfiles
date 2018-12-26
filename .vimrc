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

" J {
command! -range J 
    \'<+1,'>s/^ \+//e|
    \'<,'>j!|
    \call histdel("/",-1)|
    \let @/=histget("/",-1)
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
noremap <S-k> <Up>
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
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
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
set runtimepath+=$HOME/.vim/plugins/verilog_systemverilog
set showcmd
set smartcase 
set smartindent
set spellfile=~/.vim/spell/en.utf-8.add
set spelllang=en,cjk
set swapfile
set timeoutlen=0
set ttimeoutlen=0
set ttyfast
set undodir=$HOME/.vim/anydir
set undofile
set viminfo='20,s10
set virtualedit=block
set visualbell t_vb=
set wildignore=*.dvi,*.pdf,*.aux,*.cpc
set wildmode=list:longest,full
syntax on

" highlight {
" Must be located after 'syntax on'.
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

