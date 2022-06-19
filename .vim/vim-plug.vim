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

Plug 'Shougo/ddc-matcher_head'  " matcher_head
Plug 'matsui54/ddc-buffer'      " buffer
Plug 'Shougo/ddc-sorter_rank'   " sorter_rank
Plug 'tani/ddc-fuzzy'
Plug 'Shougo/pum.vim'
inoremap <Tab>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>
"Plug 'Shougo/ddc-nextword'
Plug 'LumaKernel/ddc-file'
"Plug 'mattn/vim-lsp-settings'
"Plug 'prabirshrestha/vim-lsp'

"Plug 'Shougo/ddc-converter_remove_overlap'
"Plug 'Shougo/ddc-nvim-lsp'
"Plug 'hrsh7th/vim-vsnip' " ['vim-vsnip-integ', 'friendly-snippets']
"Plug 'hrsh7th/vim-vsnip-integ'
"Plug 'rafamadriz/friendly-snippets'
""     \ 'vim-lsp': {
""     \   'mark': 'LSP', 
"" \   'matchers': ['matcher_head'],
"" \   'forceCompletionPattern': '\.|:|->|"\w+/*'
"" \ },


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

call ddc#custom#patch_filetype(['ps1', 'dosbatch', 'autohotkey', 'registry'], {
    \ 'sourceOptions': {
        \ 'file': {
            \ 'forceCompletionPattern': '\S\\\S*',
        \ },
    \ },
    \ 'sourceParams': {
        \ 'file': {
            \ 'mode': 'win32',
        \ },
    \ },
\ })

call ddc#custom#patch_global('completionMenu', 'pum.vim')

call ddc#custom#patch_global('filterParams', {
    \ 'matcher_fuzzy': {
        \ 'splitMode': 'word',
    \ },
    \ 'converter_fuzzy': {
        \ 'hlGroup': 'SpellBad',
    \ },
\ })

call ddc#custom#patch_global('sources', [
    \ 'buffer',
    \ 'file',
\ ])

call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
        \ 'ignoreCase': v:true,
        \ 'matchers': [
            \ 'matcher_head',
            \ 'matcher_fuzzy',
        \ ],
        \ 'sorters': [
            \ 'sorter_rank',
            \ 'sorter_fuzzy',
        \ ],
        \ 'converters': [
            \ 'converter_fuzzy',
        \ ],
    \ },
    \ 'buffer': {
        \ 'mark': '[ddc-buffer]',
    \ },
    \ 'file': {
        \ 'mark': '[file]',
        \ 'isVolatile': v:true,
        \ 'forceCompletionPattern': '\S/\S*',
    \ },
\ })

call ddc#custom#patch_global('sourceParams', {
    \ 'buffer': {
        \ 'bufNameStyle': 'basename',
        \ 'forceCollect': v:false,
        \ 'fromAltBuf': v:true,
        \ 'limitBytes': 5000000,
        \ 'requireSameFiletype': v:false,
    \ },
\ })

" ddc#enable() does not work if !has('patch-8.2.0662')
" see: ~/.cache/vim/vim-plug/ddc.vim/autoload/ddc.vim
call ddc#enable()

" ddc#custom }}}

