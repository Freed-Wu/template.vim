# template.vim

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/Freed-Wu/template.vim/main.svg)](https://results.pre-commit.ci/latest/github/Freed-Wu/template.vim/main)
[![github/workflow](https://github.com/Freed-Wu/template.vim/actions/workflows/main.yml/badge.svg)](https://github.com/Freed-Wu/template.vim/actions)

[![github/downloads](https://shields.io/github/downloads/Freed-Wu/template.vim/total)](https://github.com/Freed-Wu/template.vim/releases)
[![github/downloads/latest](https://shields.io/github/downloads/Freed-Wu/template.vim/latest/total)](https://github.com/Freed-Wu/template.vim/releases/latest)
[![github/issues](https://shields.io/github/issues/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/issues)
[![github/issues-closed](https://shields.io/github/issues-closed/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/issues?q=is%3Aissue+is%3Aclosed)
[![github/issues-pr](https://shields.io/github/issues-pr/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/pulls)
[![github/issues-pr-closed](https://shields.io/github/issues-pr-closed/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/pulls?q=is%3Apr+is%3Aclosed)
[![github/discussions](https://shields.io/github/discussions/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/discussions)
[![github/milestones](https://shields.io/github/milestones/all/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/milestones)
[![github/forks](https://shields.io/github/forks/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/network/members)
[![github/stars](https://shields.io/github/stars/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/stargazers)
[![github/watchers](https://shields.io/github/watchers/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/watchers)
[![github/contributors](https://shields.io/github/contributors/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/graphs/contributors)
[![github/commit-activity](https://shields.io/github/commit-activity/w/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/graphs/commit-activity)
[![github/last-commit](https://shields.io/github/last-commit/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/commits)
[![github/release-date](https://shields.io/github/release-date/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/releases/latest)

[![github/license](https://shields.io/github/license/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim/blob/main/LICENSE)
[![github/languages](https://shields.io/github/languages/count/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim)
[![github/languages/top](https://shields.io/github/languages/top/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim)
[![github/directory-file-count](https://shields.io/github/directory-file-count/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim)
[![github/code-size](https://shields.io/github/languages/code-size/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim)
[![github/repo-size](https://shields.io/github/repo-size/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim)
[![github/v](https://shields.io/github/v/release/Freed-Wu/template.vim)](https://github.com/Freed-Wu/template.vim)

Powerful template engine/plugin for vim.

Template `%5C.c%24` (URL encode of `\.c$`), which syntax looks like a subset of
[jinja2](https://github.com/pallets/jinja/).

```jinja2
/*
 * {{ expand('%:t') }}
 * Copyright (C) {{ strftime('%Y') }} {{ g:snips_author }} <{{ g:snips_email }}>
 *
 * Distributed under terms of the GPL3 license.
 */
{# comment #}
#if {{ len([]) }}
#include "{{ expand('%:t:r') }}.h"{% here %}
#endif
#include <stdio.h>
  {#-comment, strip left whitespaces #}int
  {#-comment, strip around whitespaces-#}  main(int argc, char *argv[])
{
  printf("'\{\{ string \}\}' is %s", "not variable");
  printf("'\{\# string \#\}' is %s", "not comment");
  printf("'\{\%% string %\%\}' is %s", "not directive");
  {# comment, strip right whitespaces-#}  return {{ 1 - 1 }};
}
```

```bash
# Use vim to create a file `test.c` (match the regular expression `\.c$`)
vi test.vim
```

You got

```c
/*
 * test.c
 * Copyright (C) 2023 Freed <Freed@mail.com>
 *
 * Distributed under terms of the GPL3 license.
 */

#if 0
#include "test.h"
#endif
#include <stdio.h>
int
main(int argc, char *argv[])
{
  printf("'{{ string }}' is %s", "not variable");
  printf("'{# string #}' is %s", "not comment");
  printf("'{%% string %%}' is %s", "not directive");
  return 0;
}
```

Your cursor stays in `{% here %}`.

Your `.vimrc`. The variable names come from
[vim-snippets](https://github.com/honza/vim-snippets/blob/master/plugin/vimsnippets.vim).

```vim
let g:snips_author = 'Freed'
let g:snips_email = 'Freed@mail.com'
```

## Similar projects

### Vim Template Plugins

- [aperezdc/vim-template](https://github.com/aperezdc/vim-template) converts
  `%USER%`, `%MAIL`, `%FILE%`, `%YEAR%`, ...
- [tibabit/vim-templates](https://github.com/tibabit/vim-templates) converts
  `{{NAME}}`, `{{EMAIL}}`, `{{FILE}}`, `{{YEAR}}`, ...

This plugin doesn't provide any mark. You should use your vim script knowledge
to get what you want:

<!-- markdownlint-disable MD013 -->

1. define some global variables in your `.vimrc` to store those invariable
   data. Such as your name, email, ...
2. use `expand('%:XXX')` to get any thing about file path. You can make it
   enough complex. Such as you can get perl module name `Foo::Bar::Baz` in
   [`foo-bar-baz/Makefile.PL`](https://metacpan.org/pod/ExtUtils::MakeMaker) by
   `{{ substitute(substitute(expand('%:p:h:t'), '\%(-\|^\)\(.\)', '::\u\1', 'g'), '^::', '', 'g') }}`
   If you think it is too long, you can define a global function in your
   `.vimrc`, then simply call it.
3. use `strftime()` to get any thing about date and time.
4. use `system()` to get any thing about your OS. Such as, when you report bug
   to a vim plugin, you should provide the basic information of your platforms:
   Your OS version, your vim version. If this plugin is written in python,
   ruby, perl, js or any other languages except vim script, you should provide
   your python version or any other language's version, too. A `test.vim` for
   this propose looks like:

```vim
#!/usr/bin/env -S vi -u
" $ uname -r
" {{ trim(system('uname -r')) }} {#-OS version #}
" $ vi --version | head -n1
" {{ join(split(execute('version'))[0:1]) }}
{#-vim version can be gotten form `:version` which is faster than `system()`-#}
" $ python --version
" {{ trim(system('python --version')) }}
" $ cat test.vim
set runtimepath=$VIMRUNTIME
set runtimepath+=~/.local/share/nvim/repos/github.com/{% here %}
" rest configuration in vim
" $ chmod +x test.vim
" $ ./test.vim
" press some keys or input some commands
" Expected behaviour: work normally
" Actual behaviour: broken, the error information is:
" segmentation fault
```

BTW, if you change from other vim template plugins, you can do the following
works to convert your template formats to let this plugin support them:

```sh
# change marks
perl -pi -e"s/%DATE%/{{ strftime('%F') }}/g" *
# change filenames like `=template=.c` to URL encode of `\.c$`
perl-rename 's/^=template=\./%5C./' *
perl-rename 's/$/%24/' *
```

## Usage

[`:help template`](doc/template.txt)

## Install

### From Package Manager

See `:help 'your package manager'`.

### From Source

Download and extract it to `&runtimepath` (See `:help 'runtimepath'`).

## Other Resources

### Tools

- [kana/vim-smartinput](https://github.com/kana/vim-smartinput/): input `{`
  will get `{|}`, `|` is cursor, then input `%` will get `{%|%}` or input `#`
  will get `{#|#}`. Input `<Space>` will get `{% | %}`, `{# | #}`, ... See
  [my configuration of this
  plugin](https://github.com/Freed-Wu/my-dotfiles/blob/main/.config/nvim/autoload/init/smartinput.vim).
- [sheerun/vim-polyglot](https://github.com/sheerun/vim-polyglot) contains jinja2
  syntax highlight.
- [My templates for this plugin](https://github.com/Freed-Wu/my-dotfiles/tree/main/.config/nvim/templates)

### Develop

This plugin use the following tools to develop (you don't need to install
them if you only want to use this plugin):

- [google/vimdoc](https://github.com/google/vimdoc) A tool to generate vim
  document from comment.
- [vim-jp/vital.vim](https://github.com/vim-jp/vital.vim) A library of vim
  script.
- [thinca/vim-themis](https://github.com/thinca/vim-themis) Unit test framework
  for vim script.
- [Other many tools](https://github.com/Freed-Wu/template.vim/tree/master/.pre-commit-config.yaml)
