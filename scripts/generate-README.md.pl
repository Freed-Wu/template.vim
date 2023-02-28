#!/usr/bin/env -S perl -0777 -pi
BEGIN {
    open my $in, '<test/templates/%5C.c%24';
    push @jinja2, $_ while (<$in>);
    open my $in, '<test/expected/test.c';
    push @c, $_ while (<$in>);
    open my $in, '<test/init.vim';
    push @vim, $_ while (<$in>);
}
s/(```jinja2\n).*?(```)/$1@jinja2$2/s;
s/(```c\n).*?(```)/$1@c$2/s;
s/(```vim\n).*?(```)/$1@vim$2/s;
