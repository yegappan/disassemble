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

" Path to the objdump utility
let s:objdump = 'objdump'

func s:ErrorMsg(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunc

" Display the disassembled code for a specified file
func disassemble#Disassemble(arg)
  " Make sure objdump is present in the path
  if !executable(s:objdump)
    call s:ErrorMsg(s:objdump . ' utility is not present')
    return
  endif

  if a:arg != ''
    " use the user supplied file name
    let fname = a:arg
  else
    " default is to use the current file name
    let fname = expand('%')
    if fname == ''
      " No current file (empty buffer)
      return
    endif
  endif

  " Make sure the file is present
  let f = findfile(fname, '**')
  if f == '' || !filereadable(f)
    call s:ErrorMsg("File '" . fname . "' is not found")
    return
  endif
  let fname = f

  " Find the object file for the specified file
  let objname = fnamemodify(fname, ':r')
  " First recursively search for an executable with this name
  let f = findfile(objname, '**')
  if f == ''
    " If not present, then recursively search for an object file by adding
    " an .o extension
    let objname = objname . '.o'
    let f = findfile(objname, '**')
    if f == ''
      call s:ErrorMsg("File '" . objname . "' is not found")
      return
    endif
    let objname = f
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
  exe "silent 0r !" . s:objdump . " -l -S -d " . objname
  setlocal nomodified nomodifiable filetype=asm buftype=nofile bufhidden=wipe

  " create folds
  setlocal foldenable foldcolumn=1
  g/^\x\+/.+1,/\%(^\x\+\|\%$\)/-1fold
  normal zR
  normal! gg
endfunc

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: shiftwidth=2 sts=2 expandtab
