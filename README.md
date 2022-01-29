# Tod

A simple pomodoro task manager in shell scripts.

A [pomodoro](https://en.wikipedia.org/wiki/Pomodoro_Technique) is a 25 minute chunk of uninterrupted time. If this is uninterrupted, it will add a pomodoro to the task. If interrupted, it will *not* add a pomodoro to the task.

*This is a rewrite and devolution more or less of my Python task manager, [Tod](https://github.com/milofultz/tod).*

## What it does

* Manages tasks to do
* Tracks how many pomodoros you have done using asterisks after the task name

## Installation

Copy the `tod.sh` file somewhere that it can be referenced by your shell. In your shell's `rc` file, add an alias of `tod=./path/to/tod.sh` so you can use it wherever.

## Usage

Flag | Arguments | Description
--- | --- | ---
N/A / `ls` | | List all uncompleted tasks
`a "task"` | `task`: New task | Add new task
`c n` | `n`: Task number | Mark task as complete/incomplete
`d n` | `n`: Task number | Delete task
`k` | | Kill timers
`la` | | List all tasks
`lc` / `c` | | List all completed tasks
`t` | | See elapsed time for timer

