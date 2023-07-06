#!/usr/bin/env -S make -f
README.md: scripts/generate-README.md.pl test/init.vim test/templates/%.c test/expected/test.c
	$< $@
