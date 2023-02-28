#!/usr/bin/env -S make -f
README.md: scripts/generate-README.md.pl test/init.vim test/templates/%5C.c%24 test/expected/test.c
	$< $@
