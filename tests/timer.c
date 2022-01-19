#include <stdlib.h>
#include <ncurses.h>
#include <unistd.h>

int main( int argc, char *argv[] )
{
    int val = strtol(argv[1], NULL, 10);

    initscr();
    printw("Timer for %d second.\n\n", val);
    refresh();

    while (val > 0)
    {
        move(2, 0);
        printw("%d seconds left\n", val);
        refresh();
        sleep(1);
        val--;
        move(2, 0);
    }

    endwin();
    return 0;
}

