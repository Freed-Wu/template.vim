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
