""
" Command to expand template.
"
" Both of the following n, m are positive integers.
" The `[fname]` is `expand('%:p')` by default. See |%:p|.
"
" 1. Replace the lines from n-th to m-th by a template:
" >
"     :n,mTemplate [fname]
" 2. Insert the template after n-th line:
" >
"     :nTemplate [fname]
" 3. Insert the template before n-th line:
" >
"     :nTemplate! [fname]
" 4. Insert the template after current line:
" >
"     :Template [fname]
" 5. Insert the template before current line:
" >
"     :Template! [fname]
" By default, |BufNewFile| will call `:1,1Template` by |autocmd|, which will
" replace the buffer by the template (A new buffer only have one line).
" You can use the following code to disable this |autocmd|. See |augroup|.
" >
"     augroup template
"       autocmd!
"     augroup END
command -nargs=? -bang -range -complete=custom,template#complete#expand Template call template#expand('<range>', '<line1>', '<line2>', '<bang>', '<args>')

if !exists('#template')
  augroup template
    autocmd!
    autocmd BufNewFile * 1,1Template
  augroup END
endif
