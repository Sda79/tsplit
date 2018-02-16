#------------------------------------------------------------------------------#
# tsplit permet de split une fenetre tmux avec n par m panneaux 
#   $1 : nombre de colones
#   $2 : numbre de ligne
#   $3 : Fenetre tmux 
#            <session-ID>:<window-ID>
#------------------------------------------------------------------------------#
tsplit() {
    col=$(echo "$1-1" | bc)
    line=$(echo "$2-1" | bc)
    for i in `seq 1 $col`;
    do
        $TMUX splitw -h -t $3
    done
    $TMUX select-layout -t $3 even-horizontal 
    for k in `seq 1 $1`;
    do
        percent=$(echo "100-100/$2" | bc)
        for j in `seq 1 $line`;
        do
            $TMUX splitw -v -p $percent -t $3
            percent=$(echo "100-100/($line - $j + 1)" | bc)
        done
        $TMUX select-pane -L
    done
    $TMUX select-pane -t $3.0
}

#------------------------------------------------------------------------------#
# t4panes permet de split votre fenetre tmux en 4 panneaux
#   $1 : Fenetre tmux
#        <session-ID>:<window-ID>
#------------------------------------------------------------------------------#
t4panes() {
    tsplit 2 2 $1
}

#------------------------------------------------------------------------------#
# tnwin creer n fenetres sur une session tmux elles mêmes
#	composées de 4 panneaux
#   $1 : number of windows
#   $2 : Session Tmux 
#           <session-ID>
#------------------------------------------------------------------------------#
tnwin() {
    if [ $1 -gt 0 ]; then
        t4panes "$2:0"
        for k in `seq 2 $1`;
        do
            $TMUX new-window -t "$2:$(echo $k-1 | bc)"
            t4panes "$2:$(echo $k-1 | bc)"
        done
        $TMUX select-window -t "$2:0"
    fi
}

#------------------------------------------------------------------------------#
# tkpanes creer k panneaux sur une session tmux. 
#   $1 : nb_panes
#   $2 : Session tmux 
#        <session-ID>
#------------------------------------------------------------------------------#
tkpanes() {
    if [ $1 -eq 4 ]; then
        t4panes "$2:0"
    elif [ $1 -lt 4 ]; then
        tsplit 1 $1 "$2:0"
    else
        NB_WINDOWS=$(echo "$1/4" | bc)
        tnwin $NB_WINDOWS $2
        if [ $(echo "$1%4" | bc) -ne 0 ]; then
            $TMUX new-window -t "$2:$NB_WINOWS"
            tsplit 1 $(echo "$1%4" | bc) "$2:$NB_WINDOWS"
        fi
    fi
}
