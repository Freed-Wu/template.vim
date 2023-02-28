function! template#complete#create(arglead, cmdline, cursorpos) abort
  let l:tokens =  split(a:cmdline . 'x')
  if l:tokens[0] !=# 'TemplateCreate'
    call remove(l:tokens, 0)
  endif
  if len(l:tokens) < 3
    let l:results = getcompletion(a:arglead, 'command')
    return join(l:results, "\n")
  else
    return template#complete#expand(a:arglead, a:cmdline, a:cursorpos)
  endif
endfunction

function! template#complete#expand(arglead, cmdline, cursorpos) abort
  let l:results = []
  for l:dir in g:template#directories
    for l:re in readdir(l:dir)
      if isdirectory(l:dir . '/' . l:re)
        continue
      endif
      let l:fname = g:template#URI.decode(l:re)
      let l:results += [l:fname]
    endfor
  endfor
  return join(l:results, "\n")
endfunction
