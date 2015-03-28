#include <stdio.h>
#include "token.h"

int main(void)
{
    token_t tok;
    do
    {
        tok = read_token(stdin);
        if(tok.any.type == TOK_EOF)
        {
            printf("FINISH\n");
            break;
        }
        if(tok.any.type == TOK_INVALID)
        {
            printf("ERROR\n");
            break;
        }
        printf("read token: %i\n", tok.any.type);
    } while(tok.any.type != TOK_EOF);
    return 0;
}

