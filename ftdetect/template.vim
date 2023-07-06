augroup ftdetect_template
  autocmd!
  for s:dir in g:template#utils#directories
    execute 'autocmd BufNewFile,BufRead' s:dir . '/* call template#utils#init()'
  endfor
augroup END
