#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (void)
{
    char line[255];
    char todfile[255];
    FILE* fp;
    strcat(todfile, getenv("HOME"));
    strcat(todfile, "/.tod2");
    fp = fopen(todfile, "r");

    while(fgets(line, 256, fp) != NULL)
    {
        printf("%s", line);
    }

    fclose(fp);
    return 0;
}

