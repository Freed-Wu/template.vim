""
" @section Introduction, intro
" @library
" <doc/@plugin(name).txt> is generated by <https://github.com/google/vimdoc>.
" See <README.md> for more information about installation and screenshots.
"
" Currently, @plugin(name) supports the following syntaxes:
"
" 1. `{# comment #}`: the comment will be ignored.
" 2. `{{ expression }}` the vimscript expression will be evaled by vim.
" 3. `{% here %}` the cursor will jump to here.
" 4. `{{-comment-}}` the white spaces in the side of `-` will be removed.
"    Similar for other marks.
" 5. `\{\{text\}\}` will be converted to `{{text}}`. Similar for other marks.
"
" The syntax highlight can be provided by vim's jinja2 plugin.

""
" Configure the directories which store templates. The default value is:
" 1. neovim
" >
"     let g:template#directories += [
"          \ stdpath('config') . '/templates/before',
"          \ stdpath('config') . '/templates',
"          \ stdpath('config') . '/templates/after',
"          \ ]
" 2. vim
" >
"     let g:template#directories += [
"          \ expand('~/.vim/templates/before'),
"          \ expand('~/.vim/templates'),
"          \ expand('~/.vim/templates/after'),
"          \ ]
" You can put:
" 1. the templates which match full names and prefix names in
"    `templates/before`. E.g.,
" >
"     /autoload/.*\.vim$  " vim autoload script
"     /plugin/[^/]*\.vim$  " vim plugin script
"     syntax_test-[^/]*$  " test file for sublime-syntax yaml file
" 2. the templates which match long suffix names in `templates`. E.g.,
" >
"     .*-test\.py$  " pytest file
"     .*-output\.yaml$  " config file to markdown preview enhanced about
"                       " converting markdown to other formats
" 3. the templates which match short suffix names in `templates` in order to
"    avoid overriding long suffix names. E.g.,
" >
"     \.py$  " python file
"     \.yaml$  " yaml file
if exists('*stdpath')
  let s:dirs = [
        \ stdpath('config') . '/templates/before',
        \ stdpath('config') . '/templates',
        \ stdpath('config') . '/templates/after',
        \ ]
else
  let s:dirs = [
        \ expand('~/.vim/templates/before'),
        \ expand('~/.vim/templates'),
        \ expand('~/.vim/templates/after'),
        \ ]
endif
call g:template#utils#plugin.Flag('g:template#directories', s:dirs)

let g:template#URI = vital#template#import('Web.URI')

""
" Create a template. use {cmd} to open the templates.
" First, search this template in `l:dirs`, if so, open it.
" if not, create it in the `l:dirs[0]` and open it.
function! template#create(mod, cmd, ...) abort
  let l:dirs = filter(g:template#directories, {_, v -> isdirectory(v)})
  if l:dirs == []
    echohl WarningMsg
    echomsg 'None of' join(g:template#directories, ', ') 'are directories!'
    echohl None
    return
  endif
  if len(a:000) > 0
    let l:exprs = a:000
  else
    if get(b:, 'template') == 0
      let l:exprs = [b:template]
    else
      echohl WarningMsg
      echomsg 'No input regular expression or b:template!'
      echohl None
      return
    endif
  endif
  for l:expr in l:exprs
    let l:file = ''
    for l:dir in l:dirs
      let l:fname = l:dir . '/' . g:template#URI.encode(l:expr)
      if filereadable(l:fname)
        let l:file = fnameescape(l:fname)
        break
      endif
    endfor
    if l:file ==# ''
      echomsg "Don't find" l:expr 'in' join(g:template#directories, ', ') ', create it!'
      let l:fname = l:dirs[0] . '/' . g:template#URI.encode(l:expr)
      let l:file = fnameescape(l:fname)
    endif
    execute a:mod a:cmd l:file
  endfor
endfunction

""
" Expand a template. See |:Template| to know its usage.
function! template#expand(range, line1, line2, bang, fname) abort
  let l:dirs = filter(g:template#directories, {_, v -> isdirectory(v)})
  if l:dirs == []
    return
  endif
  if a:fname ==# ''
    let l:fname = expand('%:p')
  else
    " expand '~'
    let l:fname = expand(a:fname)
    " make sure it is a full path.
    if l:fname[0] !=# '/'
      let l:fname = getcwd() . '/' . l:fname
    endif
  endif
  for l:dir in l:dirs
    let l:found = template#find(l:fname, l:dir)
    if l:found !=# ''
      break
    endif
  endfor
  let l:result = l:dir . '/' . l:found
  if !filereadable(l:result)
    return
  endif
  " For :TemplateCreate
  let b:template = g:template#URI.decode(l:found)
  if a:range != 2 && a:bang ==# '!'
    let l:line = a:line2 - 1
  else
    let l:line = a:line2
  endif
  silent execute 'keepalt' l:line . 'r' fnameescape(l:result)
  echomsg 'Load template' g:template#URI.decode(split(l:result, '/')[-1])
  if a:range == 2
    execute a:line1 . ',' . a:line2 . 'delete'
  endif
  silent call template#expand_comment()
  silent call template#expand_variable()
  silent call template#expand_directive()
endfunction

""
" Find regular expression which matches {fname} in {dir}.
" If not found, return ''.
function! template#find(fname, dir) abort
  for l:re in readdir(a:dir)
    if a:fname =~# '\m' . g:template#URI.decode(l:re)
      return l:re
    endif
  endfor
  return ''
endfunction

" vint: -ProhibitCommandRelyOnUser -ProhibitCommandWithUnintendedSideEffect

""
" Expand inline comments.
function! template#expand_comment() abort
  %s/\m{# .\{-} #}//ge
  %s/\m\s*{#-.\{-} #}//ge
  %s/\m{# .\{-}-#}\s*//ge
  %s/\m\s*{#-.\{-}-#}\s*//ge
  " restore {#.\{-}#}
  %s/\m\\{\\#\(.\{-}\)\\#\\}/{#\1#}/ge
endfunction

""
" Expand variables.
function! template#expand_variable() abort
  %s/\m{{ \(.\{-}\) }}/\=eval(submatch(1))/ge
  %s/\m\s*{{-\(.\{-}\) }}/\=eval(submatch(1))/ge
  %s/\m{{ \(.\{-}\)-}}\s*/\=eval(submatch(1))/ge
  %s/\m\s*{{-\(.\{-}\)-}}\s*/\=eval(submatch(1))/ge
  " restore {{.\{-}}}
  %s/\m\\{\\{\(.\{-}\)\\}\\}/{{\1}}/ge
endfunction

""
" Expand directives.
function! template#expand_directive() abort
  0  " Go to first line before searching
  let l:column = 0
  let l:lineno = 0
  if search('{%[- ]here[- ]%}', 'W')
    let l:column = col('.')
    let l:lineno = line('.')
    %s/\m{% here %}//ge
    %s/\m\s*{%-here %}//ge
    %s/\m{% here-%}\s*//ge
    %s/\m\s*{%-here-%}\s*//ge
  endif
  " will break test check {% here %}
  " restore {%.\{-}%}
  %s/\m\\{\\%\(.\{-}\)\\%\\}/{%\1%}/ge
  call cursor(l:lineno, l:column)
endfunction