#include "eval.h"
#include <stdlib.h>

static size_t curr_size;
static token_t *stack;
static size_t pos;

void eval_init()
{
    curr_size = 16;
    stack = (token_t *) malloc(sizeof(*stack) * curr_size);
    pos = 0;
}

void eval_finish()
{
    free(stack);
    stack = NULL;
}

void push(token_t tok)
{
    if(pos >= curr_size)
    {
        curr_size *= 2;
        stack = (token_t *) realloc(stack, sizeof(*stack) * curr_size);
    }
    stack[pos++] = tok;
}

token_t top()
{
    return stack[pos - 1];
}

token_t pop()
{
    return stack[--pos];
}

int reduce_top(int finish)
{
    token_t l, c, r;
    int fail = 1;
    if(pos > 2)
    {
        r = pop();
        c = pop();
        l = pop();

        switch(c.any.type)
        {
            case TOK_INT_VAL:
                if(l.any.type == TOK_PAR_OPEN && r.any.type == TOK_PAR_CLOSE)
                {
                    push(c);
                    fail = 0;
                }
                break;
            case TOK_ADD_OP:
                if(l.any.type == TOK_INT_VAL && r.any.type == TOK_INT_VAL && finish)
                {
                    c = make_token(TOK_INT_VAL);
                    c.int_val.val = l.int_val.val + r.int_val.val;
                    push(c);
                    fail = 0;
                }
                break;
            case TOK_MUL_OP:
                if(l.any.type == TOK_INT_VAL && r.any.type == TOK_INT_VAL)
                {
                    c = make_token(TOK_INT_VAL);
                    c.int_val.val = l.int_val.val * r.int_val.val;
                    push(c);
                    fail = 0;
                }
                break;
        }

        if(fail)
        {
            push(l);
            push(c);
            push(r);
        }
    }

    return !fail;
}

void eval_step(token_t token)
{
    switch(token.any.type)
    {
        case TOK_INT_VAL:
            push(token);
            reduce_top(0);
            break;
        case TOK_PAR_OPEN:
            push(token);
            break;
        case TOK_PAR_CLOSE:
            while(reduce_top(1));
            push(token);
            while(reduce_top(0));
            break;
        case TOK_ADD_OP:
            push(token);
            break;
        case TOK_MUL_OP:
            push(token);
            break;
        case TOK_EOF:
            while(reduce_top(1));
            break;
    }
}

int eval_get_res()
{
    return pop().int_val.val;
}

int eval_is_ok()
{
    return pos == 1 && top().any.type == TOK_INT_VAL;
}
