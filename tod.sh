#!/bin/bash

FILE=test.txt

re='^[0-9]+$'
if [[ $1 =~ $re ]]
then
    line=$1
    task=$(sed -n "${1}p" $FILE)
    ./timer $task
fi

function list_all() {
    sed '/.*/=' $1 | sed 'N;s/\n/ /'
}

ACTION="$1"

shift

case $ACTION in
"add" | "a")
    echo $1 >> $FILE
    ;;
"delete" | "d")
    line=$1
    temp="tempfile.txt"
    sed -l "${line}d" $FILE | \
        while read log; do echo $log >> $temp; done
    rm $FILE
    mv $temp $FILE
    ;;
"ls")
    list_all $FILE
    ;;
esac

