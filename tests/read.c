#include <stdio.h>
#include <stdlib.h>

int main()
{
    char ch;
    FILE *fp;
    fp = fopen("test.txt", "r"); // read mode

    while((ch = fgetc(fp)) != EOF)
    {
        printf("%c", ch);
    }

   fclose(fp);
   return 0;
}
