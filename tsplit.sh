#!/bin/bash

# tsplit split your current tmux in n lines by m columns
#   $1 : number of line
#   $2 : number of column
tsplit() {
    line=$1
    (( line-- ))
    col=$2
    (( col-- ))
    for i in `seq 1 $line`;
    do
        tmux splitw -h
    done
    tmux select-layout even-horizontal
    (( line++ ))
    for k in `seq 1 $line`;
    do
        percent=$(echo "100-100/$((col + 1))" | bc)
        for j in `seq 1 $col`;
        do
            tmux splitw -v -p $percent
            percent=$(echo "100-100/($col - $j + 1)" | bc)
        done
        tmux select-pane -L
    done
    tmux select-pane -t 0
}

#t4panes split your current tmux in 4 by 4
t4panes() {
    tsplit 2 2  
}

# tnwin create n 4 by 4 windows in your current tmux
#   $1 number of windows
tnwin() {
    t4panes
    for k in `seq 2 $1`;
    do
        tmux new-window
        t4panes
    done
    tmux select-window -t 0
}
