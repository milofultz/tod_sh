* A timer in C
  * [x] Handling passing of time
    * https://www.poftut.com/what-is-sleep-function-and-how-to-use-it-in-c-program/
    * https://stackoverflow.com/questions/14818084/what-is-the-proper-include-for-the-function-sleep
  * [x] Handle a CLI param for number of seconds
    * https://www.tutorialspoint.com/cprogramming/c_command_line_arguments.htm
    * https://stackoverflow.com/questions/9748393/how-can-i-get-argv-as-int
    * https://linux.die.net/man/3/strtol
    * https://flaviocopes.com/c-null/
  * [x] Exiting with ctrl+c?
    * seems like this is implicit unless you are using something like curses, so I'll get to that
  * [x] Show countdown clock on timer
    * https://stackoverflow.com/questions/16870059/printf-not-printing-to-screen
    * https://stackoverflow.com/questions/39180642/why-does-printf-not-produce-any-output
    * https://www.man7.org/linux/man-pages/man3/fflush.3.html
    * Eventually will do this in curses but this works for now
  * [x] Make curses print the timer loop instead of basic printf
    * Getting a lot of use out of that NCurses book! I think I can implement this now.
    * https://stackoverflow.com/questions/153890/printing-leading-0s-in-c
    * https://stackoverflow.com/questions/907220/set-string-variable-in-c-from-argv
    * This was ridiculously easy!
* Reading and writing to a file
  * [x] Read a file and display it's contents in the terminal
    * https://www.programmingsimplified.com/c-program-read-file
  * [x] Write text to a new file
    * https://www.tutorialspoint.com/cprogramming/c_file_io.htm
    * https://stackoverflow.com/questions/11573974/write-to-txt-file
  * [x] Write text from the command line to a new file
    * using fprintf so that the string can be added to
  * [x] Write loop of entries into file
    * fgets operates same as scanf and isn't bas I guess?
    * scanf is weird because of how it parses input. fgets doesn't have this issue
    * https://stackoverflow.com/questions/22065675/get-text-from-user-input-using-c
    * instead of a do while or a while with a real conditional, while(1) and an enclosed if/else works well
  * [ ] Write to file in home dir (~/.tod2)
    * [x] figure out how to get home dir
      * https://www.tutorialspoint.com/c_standard_library/c_function_getenv.htm
      * https://www.techonthenet.com/c_language/standard_library_functions/stdlib_h/getenv.php
      * https://www.tutorialspoint.com/c_standard_library/c_function_getenv.htm
    * [x] figure out how to combine directories/filenames
      * https://www.geeksforgeeks.org/storage-for-strings-in-c/
      * https://stackoverflow.com/questions/8465006/how-do-i-concatenate-two-strings-in-c
      * https://stackoverflow.com/questions/1575278/function-to-split-a-filepath-into-path-and-file
    * [x] Write something to ~/.tod2
      * https://stackoverflow.com/questions/14680232/how-to-detect-a-file-is-opened-or-not-in-c
      * used a lot of strcat. I think strings are still a mystery to me in C. should look it up better.
* Use todo.txt styling/file formatting
* [x] Make a timer app that asks for current task at start
  * [x] Make seconds to minutes and seconds converter
    * https://www.man7.org/linux/man-pages/man3/strtol.3.html
  * [x] Make cli that takes in string and then does pomodoro
    * https://stackoverflow.com/questions/7174216/how-can-i-concatenate-arguments-in-to-a-string-in-c
    * okay can print everything from the comand line now, which is sick
    * https://www.thegeekstuff.com/2013/01/c-argc-argv/
    * https://stackoverflow.com/questions/56028459/passing-punctuaton-marks-through-command-line-in-c
* [x] Settle on a format of tasks
  * x if completed
  * (0) for pomodoros
  * +project for project associated with task
  * example:
    * (0) +stuff a new task for stuff
    * x (9) +stuff a completed task for stuff
* [x] Make a function that will list all tasks in tod file (tod2 for now)
  * single task per line
  * [x] Figure out how to read a file line by line and print to screen
    * https://linux.die.net/man/3/fopen
    * https://stackoverflow.com/questions/41902471/how-to-use-fgets-to-read-a-file-line-by-line
    * https://linux.die.net/man/3/fgets
    * https://linux.die.net/man/3/getenv
  * [x] Style tasks based on their elements, a la todo.txt but easy
    * [x] create sample tasks in .tod2
    * [x] figure out how to conditionally parse strings in C
      * https://stackoverflow.com/questions/3683602/single-quotes-vs-double-quotes-in-c-or-c
    * [x] make a way to parse strings by basic rules
      * https://gist.github.com/RabaDabaDoba/145049536f815903c79944599c6f952a
    * [x] number each task in the list
* [x] figure out how to do basic regex in C
  * https://en.wikipedia.org/wiki/Regular_expression#POSIX_basic_and_extended
  * http://web.archive.org/web/20160308115653/http://peope.net/old/regex.html
  * https://www.lemoda.net/c/unix-regex/
  * https://stackoverflow.com/questions/7899119/what-does-s-mean-in-printf
  * [x] use it in task parser for each part
* [ ] Play any audio
  * https://www.libsdl.org/release/SDL-1.2.15/docs/html/guideaudioexamples.html
  * https://stackoverflow.com/questions/10110905/simple-sound-wave-generator-with-sdl-in-c
  * https://stackoverflow.com/a/36550306/14857724 `<-` This one actually works!
  * https://codereview.stackexchange.com/questions/41086/play-some-sine-waves-with-sdl2

---

## Plan the actual app

### What it should do

* [x] Add/remove tasks from file
* [x] Modify entries in file
* [x] Show given task on screen for one pomodoro and add 1 to pomodoro count if completed
* [x] Should alert user when pomodoro is complete
  * https://www.parallelrealities.co.uk/tutorials/shooter/shooter10.php
* [X] Mark tasks as complete
* [X] List all tasks
* [X] List uncompleted tasks
* [X] List completed tasks

