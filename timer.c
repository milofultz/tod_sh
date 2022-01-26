#include <stdlib.h>
#include <ncurses.h>
#include <unistd.h>

int main( int argc, char *argv[] )
{
    char *task = argv[1];
    int val = 25 * 60;
    int minutes = val / 60;
    int seconds = val % 60;

    initscr();
    attron(A_BOLD);
    printw("%s\n\n", task);
    attroff(A_BOLD);
    refresh();

    while (val > 0)
    {
        move(2, 0);
        printw("%02d:%02d", minutes, seconds);
        refresh();
        sleep(1);
        val--;
        minutes = val / 60;
        seconds = val % 60;
        move(2, 0);
    }

    val = 5;

    while (val) {
        for (int i = 0; i < 5; i++) {
            beep();
            usleep(120000);
        }

        val--;
        if (val) {
            flash();
            usleep(1500000);
        }
    }

    endwin();
    return 0;
}

