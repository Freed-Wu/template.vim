""
" @section Configuration, config

function! s:Flag(name, default) abort
  let l:scope = get(split(a:name, ':'), 0, 'g:')
  let l:name = get(split(a:name, ':'), -1)
  let {l:scope}:{l:name} = get({l:scope}:, l:name, a:default)
endfunction

let g:template#utils#plugin = {'Flag': funcref('s:Flag')}

if exists('*stdpath')
  let s:dirs = [
        \ stdpath('config') . '/templates',
        \ ]
else
  let s:dirs = [
        \ expand('~/.vim/templates'),
        \ ]
endif
""
" Configure the directories which store templates.
" "%"s of template name will be substituted to "*" for glob matching.
" The default value is:
"
" 1. neovim
" >
"     let g:template#utils#directories += [
"          \ stdpath('config') . '/templates',
"          \ ]
" 2. vim
" >
"     let g:template#utils#directories += [
"          \ expand('~/.vim/templates'),
"          \ ]
call g:template#utils#plugin.Flag('g:template#utils#directories', s:dirs)

""
" Init template syntax.
"
" Use |b:current_syntax|'s language server.
" Source |b:current_syntax|'s syntax, then source vim_template's syntax.
function! template#utils#init(...) abort
  if a:0 == 1
    let b:current_syntax = a:1
  else
    filetype detect
    " 'syntax' may be incorrect "ON" when modeline change filetype.
    " So we use 'filetype'.
    if ! exists('b:current_syntax')
      let b:current_syntax = empty(&filetype) ? expand('%:e') : &filetype
    endif
  endif
  execute 'set filetype=' . b:current_syntax . '.vim_template'
endfunction
