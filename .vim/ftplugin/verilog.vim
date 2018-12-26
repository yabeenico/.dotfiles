set autoindent
set nosmartindent
setlocal cinwords+=begin
let b:verilog_indent_modules=&shiftwidth
runtime! indent/verilog.vim
