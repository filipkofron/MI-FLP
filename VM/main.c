#include <stdio.h>
#include "token.h"
#include "eval.h"

int main(void)
{
    token_t tok;
    int error;
    int num = 0;
    if(scanf("%d\n", &num) != 1)
    {
        fprintf(stderr, "Invalid input for number of attempts.\n");
        return 1;
    }
    while(num--)
    {
        eval_init();
        error = 0;
        do
        {
            tok = read_token(stdin);
            //printf("token: %s\n", TOKENS[tok.any.type]);
            if(tok.any.type == TOK_INVALID)
            {
                error = 1;
                break;
            }
            eval_step(tok);
        } while(tok.any.type != TOK_EOF);
        if(eval_is_ok() && !error)
        {
            printf("%i\n", eval_get_res());
        }
        else
        {
            printf("ERROR\n");
        }
        eval_finish();
    }
    return 0;
}

