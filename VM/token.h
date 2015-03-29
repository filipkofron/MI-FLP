#ifndef TOKEN_H
#define TOKEN_H

#include <stdio.h>
#include <string.h>

typedef enum
{
    TOK_INVALID,
    TOK_EOF,
    TOK_INT_VAL,
    TOK_PAR_OPEN,
    TOK_PAR_CLOSE,
    TOK_ADD_OP,
    TOK_MUL_OP,
} type_e;

extern const char *TOKENS[7];

struct any_s
{
    type_e type;
};

struct int_val_s
{
    type_e type;
    int val;
};

typedef struct
{
    union
    {
        struct any_s any;
        struct int_val_s int_val;
    };
} token_t;

inline token_t make_token(type_e type);

token_t read_token(FILE *file);

#endif
