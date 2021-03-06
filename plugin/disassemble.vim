" File: disassemble.vim
" Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 1.0
" Last Modified: May 13, 2020
"
" Script to display the disassembled code using objdump.
" Assumes the objdump utility is present in $PATH
"

" Needs Vim version 8.0 and higher
if v:version < 800
  finish
endif

" Command to display the disassembled code
command! -nargs=* -complete=file Disassemble call disassemble#Disassemble(<q-mods>, <q-args>)
