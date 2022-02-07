#!/bin/bash

# Constants
TOD_FILE="$HOME/.tod"
POMODORO_MARK="*"
MINUTE=60
POMODORO_SECONDS=$(( $MINUTE * 25 ))
BREAK_SECONDS=$(( $MINUTE * 5 ))
RUNNING_TASK="/tmp/tod_task"
PIDS="/tmp/tod_timer.pid"

C_YELLOW=$(tput setaf 3)
C_GREEN=$(tput setaf 2)
C_RESET=$(tput sgr0)

# "Return" variables
LINE=""
TASK=""


init() {
    touch $TOD_FILE
    touch $RUNNING_TASK
    touch $PIDS
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
    # Starting a timer from a shell script creates the pid for
    #   the script as well as the timer itself.
    kill $(pgrep sleep $POMODORO_SECONDS) 2> /dev/null
}

time_left() {
    running_pid=$(cat "$PIDS")
    if [[ -z $running_pid ]]
    then
        exit 0
    fi
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

ring_alarm() {
    echo "Use command \`tod k\` to stop the alarm."

    i=0
    j=0
    max=5
    while [[ $i -lt $max  ]]
    do
        #while [[ $j -lt 3 ]]
        #do
            #play ding.mp3 2> /dev/null
            #(( j = j + 1 ))
        #done
        tput flash
        play -n synth 3 sin 960 fade l 0 3 2.8 trim 0 1 repeat 2 2> /dev/null

        j=0
        sleep 1.5
        (( i = i + 1 ))
    done
}

do_pomodoro() {
    task_number="$1"
    seconds="$2"
    minutes=$(( time / 60 ))
    get_task "$task_number"

    kill_timers

    # Run pomodoro on current task
    echo -e "Starting timer of $minutes minutes for \"$TASK\"."
    sleep $seconds \
        && if [[ $seconds -ge $POMODORO_SECONDS ]]
           then
               tasks=$(perl -i -pe "s/($TASK)/\$1$POMODORO_MARK/" $TOD_FILE)
           else
               tasks=$(cat $TOD_FILE)
           fi \
        && echo -e "\n\nTIMER COMPLETE: $TASK\n" \
        && ring_alarm &

    echo $! > $PIDS
    echo $TASK > $RUNNING_TASK
}

take_break() {
    i=5
    while [[ $i -gt 0 ]]
    do
        echo "$i minutes left..."
        sleep $MINUTE
        i=$(($i - 1))
    done \
        && echo -e "\n\nBreak over!\n" \
        && ring_alarm &

    echo $! > $PIDS
    echo 'BREAK' > $RUNNING_TASK
}

list_tasks() {
    file=$1
    all_tasks=$(awk 'NF' $file)

    indent='   '
    completed='x .*'
    priority='\([[:alpha:]]\) .*'

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
        priority)
            pattern=$priority
            ;;
        *) # Don't show completed tasks
            modifier='!'
            pattern=$completed
            ;;
    esac

    all_tasks=$(echo -e "$all_tasks" \
        | sed "/.*/=" \
        | sed 'N;s/\n/  /' \
        | awk  "$modifier/^[[:digit:]][[:digit:]]*[[:space:]][[:space:]]*$pattern/ {print}" - \
        | sed -e "s/\([[:digit:]][[:digit:]]*[[:space:]][[:space:]]*\)\($completed\)/\1${C_GREEN}\2${C_RESET}/")

    priority_tasks=$(echo -e "$all_tasks" \
        | awk "/^[[:digit:]][[:digit:]]*[[:space:]][[:space:]]* $priority/ {print}" \
        | sort -k2)

    other_tasks=$(echo -e "$all_tasks" \
        | awk "!/^[[:digit:]][[:digit:]]*[[:space:]][[:space:]]* $priority/ {print}")

    if [[ "$which_tasks" == "priority" ]]
    then
        tasks=$priority_tasks
    elif [[ ! -z "$priority_tasks" ]]
    then
        tasks="${priority_tasks}\n${other_tasks}"
    else
        tasks=$other_tasks
    fi

    echo -e "\n${C_YELLOW}${indent}TASKS${C_RESET}\n"

    if [[ -z "$tasks" ]]
    then
        echo "${indent}No tasks."
    else
        echo -e "$tasks"
    fi
    echo -e ""
}

add_tasks() {
    shift # Get rid of the add call

    if [[ -z "$1" ]]
    then
        echo "No task entered. Type \`tod h\` for help."
        exit 1
    fi

    for task in "$@"
    do
        if [[ ! -z "$task" ]]
        then
            echo $task >> $TOD_FILE
        fi
    done
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

show_help() {
    cat README.md
}

init

ACTION="$1"
TARGET="$2"
list_option=''

if [[ "$ACTION" =~ ^[0-9]+$ ]]
then
    task_number=$ACTION
    # If $TARGET is not null and $TARGET is a number
    if [[ -n "$TARGET" && "$TARGET" =~ ^[0-9]+$ ]]
    then
        time=$(( $TARGET * 60 ))
    else
        time=$POMODORO_SECONDS
    fi
    do_pomodoro $task_number $time
    exit 0
else
    case $ACTION in
    add | a)
        add_tasks "$@"
        ;;
    break | b)
        take_break
        exit 0
        ;;
    complete | c)
        if [[ -z $TARGET ]]
        then
            # Equivalent to `lc`
            list_option=completed
        else
            mark_complete $TARGET
        fi
        ;;
    delete | d)
        shift # Remove command from arguments list
        new_tod=$(cat $TOD_FILE)
        # Sort in reverse order for correct deletion
        task_numbers=$(echo -e "$@" | perl -pe "s/ /\n/g" | sort -gr)

        for num in $task_numbers
        do
            new_tod=$(echo -e "$new_tod" | \
                sed -l "${num}d" | \
                while read log; do echo $log; done)
        done

        echo -e "$new_tod" > $TOD_FILE
        list_option=all
        ;;
    edit | e)
        vi "$TOD_FILE"
        ;;
    help | h)
        clear
        show_help
        exit 0
        ;;
    kill | k)
        kill_timers
        echo "All timers stopped."
        exit 0
        ;;
    list-all | la)
        list_option=all
        ;;
    list-completed | lc)
        list_option=completed
        ;;
    priority | lp | p)
        list_option=priority
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

