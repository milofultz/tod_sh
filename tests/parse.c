#include <stdlib.h>
#include <string.h>
#include <ncurses.h>

#include "ansi_color_codes.h"

#define TRUE 1
#define FALSE 0

int main (void)
{
    /* Declare all variables */
    int task_number;
    int line_index;

    int is_complete;
    char task_color[63]; // default color for task

    char line[255];
    char segment[255];
    char todfile[255];
    FILE* fp;

    /* Open task file */
    strcat(todfile, getenv("HOME"));
    strcat(todfile, "/.tod2");
    fp = fopen(todfile, "r");

    /* Initialize globals */
    task_number = 0;

    /* Parse task file */
    while(fgets(line, 256, fp) != NULL)
    {
        // if line is empty, skip it
        if (line[0] == '\n')
        {
            continue;
        }

        line_index = 0;
        task_number++;
        strcpy(task_color, reset);
        is_complete = FALSE;
        segment[0] = '\0';

        while (1)
        {
            // If task is marked completed
            if (line_index == 0 && line[line_index] == 'x')
            {
                is_complete = TRUE;
                // Set the default task color to green
                strcpy(task_color, GRN);
                // Go to the character after the x
                line_index++;
            }
            // If task has pomodoros
            else if (!is_complete && line[line_index] == '(')
            {
                // Write following text in yellow
                strcat(segment, CYN);

                // Add formatted project string to segment
                while (line[line_index] != ' ')
                {
                    strncat(segment, &line[line_index], 1);
                    line_index++;
                }

                // Add a space to separate project from task
                strcat(segment, " ");
            }
            // If task belongs to a project
            else if (!is_complete && line[line_index] == '+')
            {
                // Write following text in yellow
                strcat(segment, YEL);

                // Add formatted project string to segment
                while (line[line_index] != ' ')
                {
                    strncat(segment, &line[line_index], 1);
                    line_index++;
                }

                // Add a space to separate project from task
                strcat(segment, " ");
            }
            else
            {
                // Print formatted task
                strcat(segment, task_color);
                strcat(segment, &line[line_index]);

                printf("%s%d. %s", task_color, task_number, segment);
                // Line is complete, break out of loop
                break;
            }
            while (line[line_index] == ' ')
            {
                line_index++;
            }
        }
    }

    fclose(fp);
    return 0;
}

