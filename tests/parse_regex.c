#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ansi_color_codes.h"

#define TRUE 1
#define FALSE 0

void get_matches (char *);

int main (void) {
    /* Declare all variables */
    char line[255];

    char todfile[255];
    FILE* fp;

    /* Open task file */
    strcat(todfile, getenv("HOME"));
    strcat(todfile, "/.tod2");
    fp = fopen(todfile, "r");

    /* Parse task file */
    while(fgets(line, 256, fp) != NULL) {
        // if line is empty, skip it
        if (line[0] == '\n') {
            continue;
        }

        line[strlen(line) - 1] = '\0';
        printf("Trying to find pomodoro, project, and task in '%s'\n", line);

        get_matches(line);
    }

    fclose(fp);
    return 0;
}

void get_matches (char * str) {
    regex_t regex_pomo;
    regex_t regex_project;
    regex_t regex_task;
    regmatch_t match_pomo[1];
    regmatch_t match_project[1];
    regmatch_t match_task[1];
    char * pomo_ptr;
    char * project_ptr;
    char * task_ptr;
    int no_match;
    int start;
    int end;

    regcomp(&regex_pomo, "\\([[:digit:]]+\\)", REG_EXTENDED);
    no_match = regexec(&regex_pomo, str, 1, match_pomo, 0);

    if (no_match) {
        printf("  Pomodoro not found.\n");
    } else {
        start = match_pomo[0].rm_so;
        end = match_pomo[0].rm_eo;
        pomo_ptr = str + start;

        printf("  Pomodoro found: %d-%d, %.*s\n", start, end, end - start, pomo_ptr);
    }

    regcomp(&regex_project, "\\+[^ ]+", REG_EXTENDED);
    no_match = regexec(&regex_project, str, 1, match_project, 0);

    if (no_match) {
        printf("  Project not found.\n");
    } else {
        start = match_project[0].rm_so;
        end = match_project[0].rm_eo;
        project_ptr = str + start;

        printf("  Project found: %d-%d, %.*s\n", start, end, end - start, project_ptr);
    }

    regcomp(&regex_task, "[[:blank:]]+[^+(].+$", REG_EXTENDED);
    no_match = regexec(&regex_task, str, 1, match_task, 0);

    if (no_match) {
        printf("  Task not found.\n");
    } else {
        start = match_task[0].rm_so + 1; // account for space in regex pattern
        end = match_task[0].rm_eo;
        task_ptr = str + start;

        printf("  Task found: %d-%d, %.*s\n", start, end, end - start, task_ptr);
    }

    regfree(&regex_pomo);
    regfree(&regex_project);
    regfree(&regex_task);
}

