#!/bin/bash
TOTLE=3
INPUT[0]="1.zip"
INPUT[1]="2.zip"
INPUT[2]="3.zip"
FILESIZE=$(stat -f%z "${INPUT[0]}")

stamp[1]=`expr 1 \* 3600 + 0 \* 60 + 5`
stamp[2]=`expr 1 \* 3600 + 2 \* 60 + 5`
duration=7200

TIME_STAMP=($stamp1 $stamp2)


# position1 = stamp1/7200*FILESIZE 1024取整

POSITION[0]=0

i=1
while [ $i -lt $TOTLE ] ; do
    TMP=`expr ${stamp[$i]} \* $FILESIZE / $duration`
    POSITION[$i]=`expr $TMP / 1024 \* 1024`
    echo ${POSITION[$i]}
    i=`expr $i + 1`
done

POSITION[$TOTLE]=`expr \( $FILESIZE / 1024 - 100 \) \* 1024`

echo ${POSITION[$TOTLE]}

POSITION[`expr $TOTLE + 1`]=$FILESIZE
echo ${POSITION[4]}


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



echo "totle pieces number is $TOTLE"
echo "file size is $FILESIZE"
echo "first stamp is ${TIME_STAMP[0]}"



