#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main( int argc, char *argv[] ) 
{
    FILE *fp;
    char entry[127];
    char todfile[255];
    strcat(todfile, getenv("HOME"));
    strcat(todfile, "/.tod2");
    printf("%s\n\n", todfile);

    fp = fopen(todfile, "a+");

    if (fp == NULL)
    {
        perror("Failed: ");
        return 1;
    }

    while (1)
    {
        // Get user input
        fgets(entry, 127, stdin);
        // If user wrote nothing, end
        if (entry[0] == '\n')
        {
            break;
        }
        // Else, write text to file
        else
        {
            fprintf(fp, "%s", entry);
        }
    }

    fclose(fp);
}

