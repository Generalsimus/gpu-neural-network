#include <iostream>
#include <stdio.h>
// #include <structs.cu>
#include "channel.cu"

#include <stdio.h>
#include <stdarg.h>

typedef struct Model
{
    Inputs *inputs;
    Connects *connects;
    int count;
} Model;

int main()
{
    float sizes[] = {3, 5, 2};
    Inputs st = {
        sizes,
        3,
    };
    // printf("sizes: %d\n", sizes);

    Channel chan = {};

    AddOutputInput(&chan, 3);
    AddOutputInput(&chan, 4);

    printf("chan: %d\n", chan.inputsCount);

    ForWards(&chan, st);
    return 0;
}