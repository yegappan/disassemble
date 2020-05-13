" File: disassemble.vim
" Author: Yegappan Lakshmanan (yegappan AT yahoo DOT com)
" Version: 1.0
" Last Modified: May 13, 2020
"
" Script to display the disassembled code using objdump.
" Assumes the objdump utility is present in $PATH
"
if exists('loaded_disassemble')
  finish
endif
let loaded_disassemble=1

let s:cpo_save = &cpo
set cpo&vim

func s:ErrorMsg(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunc

func disassemble#Disassemble(arg)
  if a:arg != ''
    let fname = a:arg
  else
    let fname = expand('%')
  endif
  if !filereadable(fname)
    call s:ErrorMsg( 'File ' . fname . ' is not found')
    return
  endif
  let objname = fnamemodify(fname, ':p:r')
  if !filereadable(objname)
    let objname = objname . '.o'
    if !filereadable(objname)
      call s:ErrorMsg( 'File ' . objname . ' is not found')
      return
    endif
  endif

  let bname = '\[Disassembly - ' . fname . '\]'
  let winnr = bufwinnr(bname)
  if winnr != -1
    " Buffer is already present in a window. Use that window
    exe winnr . 'wincmd w'
  else
    " Create a new window
    exe 'new ' . bname
  endif
  setlocal modifiable
  silent! %d _
  exe "silent 0r !objdump -l -f -S -d " . objname
  normal! gg
  setlocal nomodified nomodifiable filetype=asm
endfunc

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save
