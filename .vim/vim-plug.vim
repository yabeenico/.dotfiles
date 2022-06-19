let g:denops_server_addr = '127.0.0.1:32123'


let data_dir = '~/.cache/' . (has('nvim')? 'n': '') . 'vim/vim-plug'
let &runtimepath .= ',' . data_dir . '/vim-plug'
if empty(glob(data_dir . '/vim-plug/autoload/plug.vim'))
    let url = 'https://raw.githubusercontent.com' .
        \ '/junegunn/vim-plug/master/plug.vim'
    silent execute '!curl -sfLo ' .
        \ data_dir . '/vim-plug/autoload/plug.vim --create-dirs ' . url
endif


" Plug {{{
call plug#begin('~/.cache/vim/vim-plug')

" ddc
Plug 'vim-denops/denops.vim'
Plug 'vim-denops/denops-helloworld.vim'
let g:denops_disable_version_check = 1
Plug 'Shougo/ddc.vim'

"Plug 'Shougo/ddc-around'
Plug 'Shougo/ddc-matcher_head'
Plug 'matsui54/ddc-buffer'
Plug 'Shougo/ddc-sorter_rank'
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/pum.vim'
"Plug 'Shougo/ddc-nextword'
"Plug 'LumaKernel/ddc-file'
"Plug 'mattn/vim-lsp-settings'
"Plug 'prabirshrestha/vim-lsp'

"Plug 'Shougo/ddc-around'
"Plug 'Shougo/ddc-matcher_head'
"Plug 'Shougo/ddc-sorter_rank'
"Plug 'Shougo/ddc-converter_remove_overlap'
"Plug 'Shougo/ddc-nvim-lsp'
"Plug 'hrsh7th/vim-vsnip' " ['vim-vsnip-integ', 'friendly-snippets']
"Plug 'hrsh7th/vim-vsnip-integ'
"Plug 'rafamadriz/friendly-snippets'

" markdown
Plug 'skanehira/preview-markdown.vim'
let g:preview_markdown_parser='glow'
let g:preview_markdown_auto_update=1
Plug 'rcmdnk/vim-markdown'
let g:vim_markdown_conceal=0

" vim-json
Plug 'elzr/vim-json'
let g:indentLine_setColors = 1
let g:indentLine_color_term = 4
let g:indentLine_bgcolor_term = 0

" other
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/vim-easy-align'
Plug 'Yggdroot/indentLine'
Plug 'jeetsukumaran/vim-indentwise'

" install
let list_install   = keys(g:plugs) + ['vim-plug']
let list_installed = split(system('ls ' . data_dir), '\n')
if join(sort(list_install)) != join(sort(list_installed))
    PlugClean!
    PlugInstall --sync
endif

call plug#end()
" Plug }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ddc#custom {{{

""     \ 'vim-lsp': {
""     \   'mark': 'LSP', 
"" \   'matchers': ['matcher_head'],
"" \   'forceCompletionPattern': '\.|:|->|"\w+/*'
"" \ },

" Plug 'Shougo/ddc.vim'
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
        \ 'ignoreCase': v:true
    \ }
\ })

" Plug 'Shougo/ddc-matcher_head'
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
        \ 'matchers': ['matcher_head'],
    \ }
\})

" Plug 'Shougo/ddc-sorter_rank'
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
        \ 'sorters': ['sorter_rank']
    \ },
\ })

" Plug 'matsui54/ddc-buffer'
call ddc#custom#patch_global('sources', ['buffer'])
call ddc#custom#patch_global('sourceOptions', {
    \ 'buffer': {
        \ 'mark': '[ddc-buffer]'
    \ },
\ })
call ddc#custom#patch_global('sourceParams', {
    \ 'buffer': {
        \ 'requireSameFiletype': v:false,
        \ 'limitBytes': 5000000,
        \ 'fromAltBuf': v:true,
        \ 'forceCollect': v:false,
        \ 'showBufName': v:true,
        \ 'bufNameStyle': v:true,
    \ },
\ })

" Plug 'Shougo/pum.vim'
call ddc#custom#patch_global('completionMenu', 'pum.vim')

" Plug 'tani/ddc-fuzzy' " pum.vim
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
        \ 'matchers': ['matcher_fuzzy'],
        \ 'sorters': ['sorter_fuzzy'],
        \ 'converters': ['converter_fuzzy'],
    \ }
\ })
call ddc#custom#patch_global('filterParams', {
    \ 'matcher_fuzzy': {
        \ 'splitMode': 'word',
    \ }
\ })
call ddc#custom#patch_global('filterParams', {
    \ 'converter_fuzzy': {
        \ 'hlGroup': 'SpellBad',
    \ }
\ })

" ddc#enable() does not work if !has('patch-8.2.0662')
" see: ~/.cache/vim/vim-plug/ddc.vim/autoload/ddc.vim
call ddc#enable()

" ddc#custom }}}
