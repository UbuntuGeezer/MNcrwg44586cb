#!/bin/bash/
echo " ** addPHONY.sh out-of-date **";exit 1
echo " ** addPHONY.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
 sed -i -f $projpath/addPHONY.txt $P1/$P2
 mawk '/.PHONY/,/zzzzzz/{print}' $P1/$P2  > $TEMP_PATH/scratch3.txt

