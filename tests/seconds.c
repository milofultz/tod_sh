#include <stdlib.h>
#include <ncurses.h>

int main (void)
{
    char input[9];
    int convertedInput;
    char *endPtr;
    int minutes;
    int seconds;

    initscr();
    addstr("How many seconds? ");
    refresh();
    getnstr(input, 8);

    convertedInput = strtol(input, &endPtr, 10);
    minutes = convertedInput / 60;
    seconds = convertedInput % 60;

    printw("%d minutes and %d seconds", minutes, seconds);
    getch();

    endwin();
    return 0;
}

