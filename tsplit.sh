#!/bin/bash

# tsplit split your terminal n by m
#   $1 : session name
#   $2 : number of line
#   $3 : number of column
tsplit() {
    tmux new-session -d -s $1
    line=$2
    (( line-- ))
    col=$3
    (( col-- ))
    for i in `seq 1 $line`;
    do
        tmux splitw -h
    done
    tmux select-layout even-horizontal
    (( line++ ))
    echo $percent
    for k in `seq 1 $line`;
    do
        percent=$(echo "100-100/$((col + 1))" | bc)
        for j in `seq 1 $col`;
        do
            tmux splitw -v -p $percent
            percent=$(echo "100-100/($col - $j + 1)" | bc)
            echo $percent
        done
        tmux select-pane -L
    done
    tmux attach -t $1
}
