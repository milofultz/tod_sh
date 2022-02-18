#!/bin/bash

# Constants
TOD_FILE="$HOME/.tod"
POMODORO_MARK="*"
SECONDS_IN_A_MINUTE=60
POMODORO_MINUTES=25
POMODORO_SECONDS=$(( $POMODORO_MINUTES * $SECONDS_IN_A_MINUTE ))
BREAK_MINUTES=5
BREAK_SECONDS=$(( $BREAK_MINUTES * $SECONDS_IN_A_MINUTE ))
RUNNING_TASK="/tmp/tod_task"
PIDS="/tmp/tod_timer.pid"

C_YELLOW=$(tput setaf 3)
C_GREEN=$(tput setaf 2)
C_RESET=$(tput sgr0)

# "Return" variables
LINE=""
TASK=""
EXISTING_PID=""


init() {
    touch $TOD_FILE
    touch $RUNNING_TASK
    touch $PIDS
}

get_line() {
    line_number=$1
    LINE="$(sed -n "${line_number}p" $TOD_FILE)"
    LINE="$(echo "$LINE" | perl -pe 's@\/@\\\/@g')"
}

get_task() {
    task_number=$1
    get_line $task_number
    TASK="$(echo -e "$LINE" | perl -ne 'print "$1" for /([^*]+)/;')"
}

get_existing_pid_if_exists() {
    EXISTING_PID=$(cat "$PIDS")

    if [[ -z $EXISTING_PID ]]
    then
        return 0
    fi
}

kill_timers() {
    get_existing_pid_if_exists

    is_running=$(ps -p $EXISTING_PID | tail -n +2)

    if [[ $is_running ]]
    then
        running_task=$(cat "$RUNNING_TASK")
        # Stop all background Tod processes. Surpress errors because
        #   if an old process is finished, there is nothing to stop
        echo "Ending existing timer for \"${running_task}\"."
        kill -9 $EXISTING_PID 2> /dev/null
        # Starting a timer from a shell script creates the pid for
        #   the script as well as the timer itself.
        kill $(pgrep sleep $POMODORO_SECONDS) 2> /dev/null
    fi
}

time_left() {
    get_existing_pid_if_exists

    # Show elapsed time and suppress the header
    elapsed=$(ps -p $EXISTING_PID -o "etime=")
    task_name=$(cat "$RUNNING_TASK")
    if [[ $elapsed != "" ]]
    then
        echo "${C_YELLOW}Current Task:${C_RESET} $task_name"
        echo "${C_GREEN}Time Elapsed:${C_RESET} $elapsed"
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
    get_task "$task_number"

    kill_timers

    # Run pomodoro on current task
    echo -e "Starting timer of $POMODORO_MINUTES minutes for \"$TASK\"."
    sleep $POMODORO_SECONDS \
        && perl -i -pe "s/(\Q${TASK}\E)/\$1$POMODORO_MARK/" $TOD_FILE \
        && echo -e "\n\nTIMER COMPLETE: $TASK\n" \
        && ring_alarm &

    echo $! > $PIDS
    echo $TASK > $RUNNING_TASK
}

take_break() {
    echo -e "Starting timer of $BREAK_MINUTES minutes."
    sleep $BREAK_SECONDS \
        && echo -e "\n\nBreak over!\n" \
        && ring_alarm &

    echo $! > $PIDS
    echo 'Break' > $RUNNING_TASK
}

list_tasks() {
    all_tasks=$(awk 'NF' "$TOD_FILE")

    indent='   '
    all='.*'
    completed='x .*'
    priority='\([[:alpha:]]\) .*'
    project=".*[[:space:]][[:space:]]*\+${PROJECT}"

    show_completed=true

    which_tasks=$1
    case $which_tasks in
        all)
            pattern=$all
            ;;
        completed)
            pattern=$completed
            ;;
        priority)
            pattern=$priority
            ;;
        project)
            pattern=$project
            show_completed=false
            ;;
        normal | *) # Don't show completed tasks
            pattern=$all
            show_completed=false
            ;;
    esac

    all_tasks=$(echo -e "$all_tasks" \
        | sed "/.*/=" \
        | sed 'N;s/\n/  /' \
        | awk  "/^[[:digit:]][[:digit:]]*[[:space:]][[:space:]]*$pattern/ {print}" - \
        | if [[ $show_completed != "true" ]]
            then
                awk "!/^[[:digit:]][[:digit:]]*[[:space:]][[:space:]]*$completed/ {print}" -
            else
                cat
            fi \
        | sed -e "s/\([[:digit:]][[:digit:]]*[[:space:]][[:space:]]*\)\($completed\)/\1${C_GREEN}\2${C_RESET}/")

    priority_tasks=$(echo -e "$all_tasks" \
        | awk "/^[[:digit:]][[:digit:]]*[[:space:]][[:space:]]* $priority/ {print}" \
        | sort -k2)

    other_tasks=$(echo -e "$all_tasks" \
        | awk "!/^[[:digit:]][[:digit:]]*[[:space:]][[:space:]]* $priority/ {print}")

    if [[ "$which_tasks" == "priority" ]] || [[ -z "$other_tasks" ]]
    then
        tasks=$priority_tasks
    elif [[ ! -z "$priority_tasks" && ! -z "$priority_tasks" ]]
    then
        tasks="${priority_tasks}\n\n${other_tasks}"
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
    shift # Remove command from args

    task_numbers="$@"

    for task_number in $task_numbers
    do
        get_line $task_number

        if [[ "$LINE" =~ '^x[[:space:]]' ]]
        then
            incomplete_line=${LINE:2}

            perl -i -pe "s/\Q${LINE}\E/${incomplete_line}/" "$TOD_FILE"
        else
            perl -i -pe "s/(\Q${LINE}\E)/x \$1/" "$TOD_FILE"
        fi
    done
}

delete_tasks() {
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
    number_of_tasks=$(sed -n "$=" "$TOD_FILE")
    if [[ $ACTION -gt $number_of_tasks ]]
    then
        echo "There is no task ${ACTION}."
        exit 1
    fi

    do_pomodoro $task_number
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
            mark_complete "$@"
        fi
        ;;
    delete | d)
        delete_tasks "$@"
        ;;
    edit | e)
        vi "$TOD_FILE"
        ;;
    help | h)
        show_help
        exit 0
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
    priority | lp)
        list_option=priority
        ;;
    project | p)
        shift

        list_option=project
        PROJECT="$1"

        if [[ -z "$PROJECT" ]]
        then
            echo -e "No project specified."
            exit 1
        fi
        ;;
    time | t)
        time_left
        exit 0
        ;;
    list | ls | *)
        list_option=normal
        ;;
    esac
fi

clear
list_tasks $list_option

exit 0;

