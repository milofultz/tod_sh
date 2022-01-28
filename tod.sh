#!/bin/bash

# Constants
TOD_FILE="$HOME/.tod"
POMODORO_MARK="*"
TEMP="tempfile.txt"

# "Return" variables
LINE=""
TASK=""

get_line() {
    line_number=$1
    LINE="$(sed -n "${line_number}p" $TOD_FILE)"
}

get_task() {
    task_number=$1
    get_line $task_number
    TASK="$(echo $LINE | perl -ne 'print "$1" for /([^*]+)/;')"
}

do_pomodoro() {
    task_number=$1
    get_task $task_number

    # Run pomodoro on current task
    ./timer "$TASK"

    # Return exit code of timer
    error=$?
    if ! [[ $error ]] # Pomodoro was completed
    then
        perl -i -pe "s/($TASK)/\$1$POMODORO_MARK/" $TOD_FILE
    fi
}

list_tasks() {
    file=$1
    all_tasks=$(awk 'NF' $file)

    completed='x .*'
    yellow=$(tput setaf 3)
    green=$(tput setaf 2)
    reset=$(tput sgr0)

    modifier=''
    pattern=''

    which_tasks=$2
    case $which_tasks in
        all)
            pattern='.*'
            ;;
        completed)
            pattern=$completed
            ;;
        *)
            modifier='!'
            pattern=$completed
            ;;
    esac
    echo -e "\n${yellow}   TASKS${reset}\n"
    echo -e "$all_tasks" \
        | sed "/.*/=" \
        | sed 'N;s/\n/  /' \
        | sed -n "/$pattern/${modifier}p" \
        | sed "s/\($completed\)/${green}\1${reset}/"
    echo -e ""
}

mark_complete() {
    line=$1
    if [[ $line =~ ^x[[:space:]] ]]
    then
        incomplete_line=${line:2}
        perl -i -pe "s/\Q$line\E/$incomplete_line/" $TOD_FILE
    else
        perl -i -pe "s/(\Q$line\E)/x \$1/" $TOD_FILE
    fi
}

ACTION="$1"

shift

if [[ $ACTION =~ ^[0-9]+$ ]]
then
    task_number=$ACTION
    do_pomodoro $task_number
else
    case $ACTION in
    add | a)
        new_task=$1
        echo $new_task >> $TOD_FILE
        ;;
    complete | c)
        task_number=$1
        get_line $task_number
        mark_complete "$LINE"
        ;;
    delete | d)
        task_number=$1
        sed -l "${task_number}d" $TOD_FILE | \
            while read log; do echo $log >> $TEMP; done
        rm $TOD_FILE
        mv $TEMP $TOD_FILE
        ;;
    list-all | la)
        list_tasks $TOD_FILE all
        ;;
    list-completed | lc)
        list_tasks $TOD_FILE completed
        ;;
    list | ls | *)
        list_tasks $TOD_FILE
        ;;
    esac
fi

exit 0;

