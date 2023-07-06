""
" Complete |:Template|.
function! template#complete#expand(arglead, cmdline, cursorpos) abort
  let l:results = template#complete#find_all()
  return join(l:results, "\n")
endfunction

""
" Find all template paths which matches {fname} in {dir}.
" If {fname} is '', return all template paths in {dir}.
function! template#complete#find_all(...) abort
  let l:fname = get(a:000, 0, '')
  let l:dirs = get(a:000, 1, g:template#utils#directories)
  let l:results = []
  for l:dir in l:dirs
    for l:path in template#complete#get_files(l:dir)
      if l:fname ==# '' || template#match(
            \ l:fname, substitute(l:path, '^' . l:dir . '/', '', '')
            \ )
        let l:results += [l:path]
      endif
    endfor
  endfor
  return l:results
endfunction

""
" Find all files in {dir}.
function! template#complete#get_files(dir) abort
  return flatten(map(readdir(a:dir), {_, x -> isdirectory(a:dir . '/' . x) ? template#complete#get_files(a:dir . '/' . x) : a:dir . '/' . x}))
endfunction
