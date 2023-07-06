" will let b:current_syntax
runtime! syntax/jinja2.vim
let b:current_syntax = split(&filetype, '\.')[0] . '.vim_template'
