"begin dein
let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
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
"end dein

cnoremap <C-K> <C-\>e strpart(getcmdline(), 0, getcmdpos()-1)<CR>
cnoremap <C-a> <C-b>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
command! MK w | silent make | redraw!
highlight Directory ctermfg=6
inoremap <expr> / pumvisible()?"<C-x><C-f>":"/<C-x><C-f>"
inoremap <expr> <CR> pumvisible()?"<ESC>":"<CR>"
inoremap {<CR> {}<Left><CR><Esc><S-o>
noremap 0 ^
noremap <C-e> 2<C-e>
noremap <C-o> $
noremap <C-y> 2<C-y>
noremap ^ 0
noremap gj j
noremap gk k
noremap j gj
noremap k gk
set background=dark
set backup
set backupdir=$HOME/.vim/backupdir
set cindent
set colorcolumn=81
set completeopt=menuone,longest,preview
set cursorline
set directory=$HOME/.vim/directory
set expandtab
set hlsearch
set ignorecase
set incsearch
set iskeyword=@,48-57,_,192-255,#
set laststatus=2
set mouse=a
set nofileignorecase
set nowildignorecase
set nowildmenu
set nowrap
set nrformats=alpha,hex
set number
set shiftwidth=4
set showcmd
set smartcase 
set smartindent
set softtabstop=4
set swapfile
set tabstop=4
set undodir=$HOME/.vim/undodir
set undofile
set viminfo='20,s10
set visualbell t_vb=
set wildignore=*.dvi,*.pdf,*.aux,*.cpc
set wildmode=list:longest,full
syntax on

augroup vimrc
	autocmd!
	autocmd BufRead,BufNewFile *.html filetype plugin indent on
	autocmd BufRead,BufNewFile *.html setl filetype=html
	autocmd BufRead,BufNewFile *.md setl filetype=markdown
	autocmd FileType vim syn keyword vimOption contained nofileignorecase
        \ nowildignorecase
augroup end
