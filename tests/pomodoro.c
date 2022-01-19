#include <string.h>
#include <ncurses.h>
#include <unistd.h>

#define POMODORO_MINUTES 25

void timer (void);

int main (int argc, char *argv[])
{
    char task[255];

    initscr();

    if (argc == 1)
    {
        addstr("Not enough arguments provided.");
        getch();

        endwin();
        return 0;
    }
    
    strcpy(task, argv[1]);
    for (int i = 2; i < argc; i++)
    {
      strcat(task, " ");
      strcat(task, argv[i]);
    }
    printw("%s\n\n", task);

    timer();

    endwin();
    return 0;
}

void timer (void) 
{
    int total_seconds;

    total_seconds = POMODORO_MINUTES * 60;

    while (total_seconds > 0)
    {
        move(2, 0);
        clrtoeol();
        printw("%d minutes and %d seconds left...", total_seconds / 60, total_seconds % 60);
        refresh();
        sleep(1);
        total_seconds--;
    }
}

