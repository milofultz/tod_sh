#!/bin/bash

# Constants
TOD_FILE="$HOME/.tod"
POMODORO_MARK="*"
POMODORO_SECONDS=$(( 60 * 25 ))
TEMP="tempfile.txt"
RUNNING_TASK="/tmp/tod_task"
PIDS="/tmp/tod_timer.pid"

C_YELLOW=$(tput setaf 3)
C_GREEN=$(tput setaf 2)
C_RESET=$(tput sgr0)

# "Return" variables
LINE=""
TASK=""


init() {
    if [[ -e $TOD_FILE ]]
    then
        touch $TOD_FILE
    fi
}

get_line() {
    line_number=$1
    LINE="$(sed -n "${line_number}p" $TOD_FILE)"
}

get_task() {
    task_number=$1
    get_line $task_number
    TASK="$(echo $LINE | perl -ne 'print "$1" for /([^*]+)/;')"
}

kill_timers() {
    # Stop all background Tod processes. Surpress errors because
    #   if an old process is finished, there is nothing to stop
    kill -9 $(cat "$PIDS") 2> /dev/null
}

time_left() {
    running_pid=$(cat "$PIDS")
    # Show elapsed time and suppress the header
    elapsed=$(ps -p $running_pid -o "etime=")
    task_name=$(cat "$RUNNING_TASK")
    if [[ $elapsed != "" ]]
    then
        echo ""
        echo "${C_YELLOW}Current Task:${C_RESET} $task_name"
        echo "${C_GREEN}Time Elapsed:${C_RESET} $elapsed"
        echo ""
    fi
}

do_pomodoro() {
    task_number=$1
    get_task $task_number

    kill_timers

    # Run pomodoro on current task
    echo -e "\nStarting timer for $TASK...\n"
    i=0
    max=5
    sleep $POMODORO_SECONDS \
        && echo -e "\n\nPOMODORO COMPLETE: $TASK\n" \
        && while [[ $i -lt $max  ]]
        do
            while [[ $j -lt $max ]]
            do
                echo -ne "\a"
                sleep 0.15
                (( j = j + 1 ))
            done \

            j=0
            sleep 1.5
            (( i = i + 1 ))
        done \
        && perl -i -pe "s/($TASK)/\$1$POMODORO_MARK/" $TOD_FILE &

    echo $! > $PIDS
    echo $TASK > $RUNNING_TASK
}

list_tasks() {
    file=$1
    all_tasks=$(awk 'NF' $file)

    indent='   '
    completed='x .*'

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

    all_tasks=$(echo -e "$all_tasks" \
        | sed "/.*/=" \
        | sed 'N;s/\n/  /' \
        | sed -n "/$pattern/${modifier}p" \
        | sed "s/\($completed\)/${C_GREEN}\1${C_RESET}/")

    echo -e "\n${C_YELLOW}${indent}TASKS${C_RESET}\n"
    if [[ -z "$all_tasks" ]]
    then
        echo "${indent}No tasks."
    else
        echo "$all_tasks"
    fi
    echo -e ""
}

mark_complete() {
    task_number=$1
    get_line $task_number

    if [[ $LINE =~ ^x[[:space:]] ]]
    then
        incomplete_line=${LINE:2}
        perl -i -pe "s/\Q$LINE\E/$incomplete_line/" $TOD_FILE
    else
        perl -i -pe "s/(\Q$LINE\E)/x \$1/" $TOD_FILE
    fi
}

main() {
    init

    ACTION="$1"
    list_option=''

    shift

    if [[ $ACTION =~ ^[0-9]+$ ]]
    then
        task_number=$ACTION
        do_pomodoro $task_number
        exit 0
    else
        case $ACTION in
        add | a)
            new_task=$1
            echo $new_task >> $TOD_FILE
            ;;
        complete | c)
            task_number=$1
            if [[ -z $task_number ]]
            then
                # Equivalent to `lc`
                list_option=completed
            else
                mark_complete $task_number
            fi
            ;;
        delete | d)
            task_number=$1
            sed -l "${task_number}d" $TOD_FILE | \
                while read log; do echo $log >> $TEMP; done
            rm $TOD_FILE
            mv $TEMP $TOD_FILE
            ;;
        kill | k)
            kill_timers
            exit 0
            ;;
        list-all | la)
            list_option=all
            ;;
        list-completed | lc)
            list_option=completed
            ;;
        time | t)
            time_left
            exit 0
            ;;
        list | ls | *)
            list_option=''
            ;;
        esac
    fi

    clear
    list_tasks $TOD_FILE $list_option

    exit 0;
}

main $@

