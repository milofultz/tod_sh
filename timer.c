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
    start_color();
    curs_set(0);

    attron(A_BOLD);
    move(1, 2);
    printw("%s", task);
    attroff(A_BOLD);
    move(5, 2);
    attron(A_BOLD);
    init_pair(1, COLOR_BLACK, COLOR_BLACK);
    attron(COLOR_PAIR(1));
    addstr("Use Ctrl + C to exit early");
    attroff(COLOR_PAIR(1) | A_BOLD);
    refresh();

    while (val > 0)
    {
        move(3, 2);
        printw("%02d : %02d", minutes, seconds);
        refresh();
        sleep(1);
        val--;
        minutes = val / 60;
        seconds = val % 60;
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

