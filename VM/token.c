#include "token.h"

const char *TOKENS[7] =
{
    "TOK_INVALID",
    "TOK_EOF",
    "TOK_INT_VAL",
    "TOK_PAR_OPEN",
    "TOK_PAR_CLOSE",
    "TOK_ADD_OP",
    "TOK_MUL_OP",
};

inline token_t make_token(type_e type)
{
    token_t token;
    memset(&token, 0, sizeof(token));
    token.any.type = type;
    return token;
}

int peek_val = EOF;

int peek(FILE *file)
{
    if(peek_val == EOF)
    {
        peek_val = fgetc(file);
    }
    return peek_val;
}

int read(FILE *file)
{
    int val = peek(file);
    peek_val = EOF;
    peek(file);
    return val;
}

token_t read_num(FILE *file)
{
    token_t token = make_token(TOK_INT_VAL);
    token.int_val.val = 0;
    while(peek(file) >= '0' && peek(file) <= '9')
    {
        token.int_val.val *= 10;
        token.int_val.val += read(file) - '0';
    }
    return token;
}

token_t read_token(FILE *file)
{
    if(feof(file))
    {
        return make_token(TOK_EOF);
    }
    switch(peek(file))
    {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            return read_num(file);
        case '(':
            read(file);
            return make_token(TOK_PAR_OPEN);
        case ')':
            read(file);
            return make_token(TOK_PAR_CLOSE);
        case '+':
            read(file);
            return make_token(TOK_ADD_OP);
        case '*':
            read(file);
            return make_token(TOK_MUL_OP);
        case '\n':
            read(file);
            return make_token(TOK_EOF);
    }
    read(file);
    return make_token(TOK_INVALID);
}
