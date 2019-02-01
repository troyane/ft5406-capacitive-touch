#!/bin/bash
#
# Author: Nazar Gerasymchuk,
# URL: trola.org
# Repo: https://github.com/troyane/ft5406-capacitive-touch
# 2019

usage () {

    cat <<HELP_USAGE

    $0 CTPSIZE X Y "EVENT"
    
    This will display point with given coordinates

    CTPSIZE int number of points in CTP module. We assume this module
                is sqare (CTPSIZE x CTPSIZE).
    X           coordinate
    Y           coordinate
    "EVENT"     Possible values are "CLICK", "DRAG", "EMPTY" that represent
                respective touch event. In case of "EMPTY" ignores X and Y, 
                you'll see empty screen. Use quotes for this argument.
                
    Example of usage:
        $ ./cursor_emulation.sh 240 20 100 "CLICK"
    
HELP_USAGE

}

check_input() {
    SHOW_USAGE=0
    re='^[0-9]+$'
    
	if [ "$#" -eq 4 ];
	then
        if ! [[ "$1" =~ $re ]];  
        then
            echo "CTPSIZE should be valid int number."
            SHOW_USAGE=1
        fi
        if ! [[ "$2" =~ $re ]]; 
        then 
            echo "X should be valid int number." 
            SHOW_USAGE=1
        fi
        if ! [[ "$3" =~ $re ]]; 
        then 
            echo "Y should be valid int number."
            SHOW_USAGE=1
        fi
	else
        SHOW_USAGE=1
	fi
	
	if [ $SHOW_USAGE -eq 1 ];
	then 
        usage
        exit 1
    fi
}

verify_dependencies() {
    which bc > /dev/null || {
        cat <<DEPS
            ERROR: You need to have bc installed (to do some math in bash)
            Install it by running:
                sudo apt install bc
DEPS
    
    exit 2
    }
}

main() {
    WIDTH=`tput cols`
    HEIGHT=`tput lines`
    # Get min
    SIZE=$(($WIDTH < $HEIGHT ? $WIDTH : $HEIGHT))
    if [ $SIZE -eq 0 ]; then
        echo "SIZE = 0"
        exit 0
    fi
    CTPSIZE=$1
    K=`echo "$CTPSIZE/$SIZE" | bc`
    if [ $K -eq 0 ]; then
        echo "K = 0"
        exit 0
    fi
    X=`echo "$2/$K" | bc`
    Y=`echo "$3/$K" | bc`
    
    if [ "$4" = "CLICK" ]; then
        SYMBOL="*"
    elif [ "$4" = "DRAG" ]; then
        SYMBOL="-"
    elif [ "$4" = "EMPTY" ]; then
        SYMBOL=" "
    else
        usage
        exit 3
    fi
    
    clear

    for i in `seq 1 $SIZE`;
    do
        NEED_LINE=0
        if [ $i -eq 1 -o $i -eq $SIZE ];
        then
            NEED_LINE=1
            echo -n "+"
        else
            echo -n "|"
        fi
        
        # -2 because first and last symbol are '|'
        for j in `seq 1 $(($SIZE-2))`;
        do
            if [ $NEED_LINE -eq 1 ];
            then
                echo -n "-"
            else
                echo -n " "
            fi
        done
        
        if [ $NEED_LINE -eq 1 ];
        then
            echo "+"
        else
            echo "|"
        fi
    done

    if [ "$SYMBOL" = " " ]; then
        exit 0
    fi
    
    # Save current cursor 
    tput sc
    
    # Draw point
    tput cup $X $Y 
    echo -n "$SYMBOL"
    
    # Restore cursor
    tput rc
}

verify_dependencies
check_input "$@"
main "$@"
