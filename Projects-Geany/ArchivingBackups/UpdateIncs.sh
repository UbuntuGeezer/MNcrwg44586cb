#!/bin/bash
# UpdateIncs.sh - Update IncDump* files where .sh and (no extension) differ.
#	5/2/22.	wmk.
#
# Modification History.
# ---------------------
# 4/23/22.	wmk.	original code.
# 4/25/22.	wmk.	's removed from file=;UpdateIncs added to list.
# 5/2/22.	wmk.	WARNING message added.
echo "** WARNING - this only updates IncDump* files; Use UpdateShells for all .sh files **"
ls IncDump*.sh > IncDumps.txt
file=IncDumps.txt
while read -e;do
 fn=$REPLY
 len=${#REPLY}
 len1=$((len-3))
 fn2=${REPLY:0:len1}
 diff -s $fn $fn2 > $TEMP_PATH/scratchfile
 if [ $? -ne 0 ];then
  cp -pv $fn $fn2
 fi
done < $file
diff -s FlashBacks.sh FlashBacks > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
  cp -pv FlashBacks.sh  FlashBacks
fi
diff -s UpdateIncs.sh UpdateIncs > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
  cp -pv FlashBacks.sh  FlashBacks
fi
#end UpdateIncs
