setlocal autoindent
setlocal cinwords=class,def,elif,else,except,finally
setlocal cinwords^=for,if,try,while,with
noremap <Leader>p oprint();exit()<Esc>hF)i

let s:indent_dir = $VIM . '/vim' . v:version / 100 . v:version % 10 . '/indent'
let s:indent_file = s:indent_dir . '/python.vim'
if filereadable(s:indent_file)
    execute 'source ' . s:indent_file
endif

