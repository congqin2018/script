#!/bin/bash
TOTLE=3
INPUT[0]="1.mp4"
INPUT[1]="2.mp4"
INPUT[2]="3.mp4"
OUTPUT="new.mp4"
FILESIZE=$(stat -f%z "${INPUT[0]}")

stamp[1]=`expr 0 \* 3600 + 50 \* 60 + 0`
stamp[2]=`expr 1 \* 3600 + 44 \* 60 + 45`
duration=7028

POSITION[0]=0

i=1
while [ $i -lt $TOTLE ] ; do
    TMP=`expr ${stamp[$i]} \* $FILESIZE / $duration`
    POSITION[$i]=`expr $TMP / 1024 \* 1024`
    i=`expr $i + 1`
done

POSITION[$TOTLE]=`expr \( $FILESIZE / 1024 - 100 \) \* 1024`
POSITION[`expr $TOTLE + 1`]=$FILESIZE


i=0
while [ $i -le $TOTLE ] ; do
    if [ $i -eq $TOTLE ] ; then
        skip=`expr ${POSITION[$i]} / 1`
        j=`expr $i + 1`
        k=`expr $i - 1`
        count=`expr \( ${POSITION[$j]} - ${POSITION[$i]} \) / 1`
        dd if=${INPUT[$k]} of=$i bs=1 count=$count skip=$skip
        i=`expr $i + 1`
    else
        skip=`expr ${POSITION[$i]} / 1024`
        j=`expr $i + 1`
        count=`expr \( ${POSITION[$j]} - ${POSITION[$i]} \) / 1024`
        dd if=${INPUT[$i]} of=$i bs=1024 count=$count skip=$skip
        i=`expr $i + 1`
    fi  
done

i=0
while [ $i -le $TOTLE ] ; do
    if [ $i -eq $TOTLE ] ; then
        seek=`expr ${POSITION[$i]} / 1`
        j=`expr $i + 1`
        count=`expr \( ${POSITION[$j]} - ${POSITION[$i]} \) / 1`
        dd if=$i of=new bs=1 count=$count seek=$seek
        i=`expr $i + 1`
    else
        seek=`expr ${POSITION[$i]} / 1024`
        j=`expr $i + 1`
        count=`expr \( ${POSITION[$j]} - ${POSITION[$i]} \) / 1024`
        dd if=$i of=new bs=1024 count=$count seek=$seek
        i=`expr $i + 1`
    fi  
done

mv new $OUTPUT

echo ">>> complete >>>"
