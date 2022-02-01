# Tod

A simple pomodoro task manager in shell scripts.

A [pomodoro](https://en.wikipedia.org/wiki/Pomodoro_Technique) is a 25 minute chunk of uninterrupted time, followed by a 5 minute break. If this is uninterrupted, it will add a pomodoro to the task. If interrupted, it will *not* add a pomodoro to the task.

*This is a rewrite and devolution more or less of my Python task manager, [Tod](https://github.com/milofultz/tod).*

## What it does

* Manages tasks to do
* Tracks how many pomodoros you have done using asterisks after the task name

## Installation

Clone the repo somewhere that it can be referenced by your shell. In your shell's `rc` file, add an alias of `tod=./path/to/tod.sh` so you can use it wherever.

### Dependencies

This uses [SoX](https://github.com/chirlu/sox) for the alarm, which can be installed using [Homebrew](https://formulae.brew.sh/formula/sox) on Mac.

## Usage

Tod is used in the command line via whatever alias you created. For instance, if you set an alias to `tod`, then you would add a task with `tod a "New task"`, start a pomodoro timer with `tod 1`, list all tasks with `tod la`, etc.

Flag | Arguments | Description
--- | --- | ---
`n[ m]` | `n`: Task number<br>`m`: Minutes (25 by default) | Start pomodoro timer
N/A / `ls` | | List all uncompleted tasks
`a "task"[ "another task" ...]` | `task`: New task | Add new task
`b` | | Start break timer
`c n` | `n`: Task number | Mark task as complete/incomplete
`d n[ n ...]` | `n`: Task number | Delete task (NOTE: Multiple numbers need to be put in descending order, e.g. "tod d 6 3 1")
`k` | | Kill timers
`la` | | List all tasks
`lc` / `c` | | List all completed tasks
`t` | | See elapsed time for timer

