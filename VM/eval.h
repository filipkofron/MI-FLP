#ifndef EVAL_H
#define EVAL_H

#include "token.h"

void eval_init();
void eval_finish();
void eval_step(token_t token);
int eval_get_res();
int eval_is_ok();

#endif
