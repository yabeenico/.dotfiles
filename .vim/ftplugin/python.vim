setlocal autoindent
setlocal cinwords=class,def,elif,else,except,finally
setlocal cinwords^=for,if,try,while,with
noremap <Leader>p oprint();exit()<Esc>hF)i
