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

### Tasks

A task is a line of text with possible modifiers. The following are all allowed:

* `A normal task`
* `x Completed task`
* `(A) High priority task!`
* `Project task +projectname`
* `x (C) A completed high priority project task +ford-prefect`

#### Prefixes

* `x Completed task` - An `x` represents completion.
* `(A) High priority task!` - A set of parentheses with a single letter inside represents priority, A to Z representing highest to lowest.

#### Suffixes

* `Project task +projectname` - A `+` followed by a name with no spaces.

### Flags

Flag | Arguments | Description
--- | --- | ---
`n` | `n`: Task number | Start pomodoro timer
N/A / `ls` | | List all uncompleted tasks
`a "task"[ "another task" ...]` | `task`: New task | Add new task
`b` | | Start break timer
`c n` | `n`: Task number | Mark task as complete/incomplete
`d n[ n ...]` | `n`: Task number | Delete task
`e` | | Open `.tod` file for editing
`k` | | Kill timers
`la` | | List all tasks
`lc` / `c` | | List all completed tasks
`lp` | | List all priority tasks
`p[ "project"]` | `project`: Project name | List all tasks belonging to project
`t` | | See elapsed time for timer

