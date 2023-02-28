augroup ftdetect_template
  autocmd!
  for s:dir in g:template#directories
    execute 'autocmd BufNewFile,BufRead' s:dir . '/* setfiletype jinja2'
  endfor
augroup END
