#!/bin/bash

WIDTH=`tput cols`
HEIGHT=`tput lines`
# Get min
SIZE=$(($WIDTH < $HEIGHT ? $WIDTH : $HEIGHT))

CTPSIZE=240

K=`echo "$CTPSIZE/$SIZE" | bc`


X=`echo "$1/$K" | bc`
Y=`echo "$2/$K" | bc`

echo "WIDTH=$WIDTH HEIGHT=$HEIGHT SIZE=$SIZE K=$K X=$X Y=$Y"

for i in `seq 1 $SIZE`;
do
    echo -n "|"
    NEED_LINE=0
    if [ $i -eq 1 -o $i -eq $SIZE ];
    then
        NEED_LINE=1
    fi
    
    for j in `seq 1 $(($SIZE-2))`;
    do
        if [ $NEED_LINE -eq 1 ];
        then
            echo -n "-"
        else
            echo -n "."
        fi
    done
    
    echo "|"
done

tput cup $X $Y 
echo -n "*"
