set autoindent
setlocal cinwords+=begin
let b:verilog_indent_modules=&tabstop
runtime! indent/verilog.vim
