#!/bin/bash
# UpdateShells.sh - Update IncDump* files where .sh and (no extension) differ.
#	10/13/22.	wmk.
#
# Modification History.
# ---------------------
# 9/20/22.	wmk.	modified for Chromebooks.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 9/24/22.	wmk.	DumpTerr, LoadBasic, LoadGeany, LoadProcs, ReloadTerr added.
# 10/13/22.	wmk.	TarFileDate added.
# Legacy mods.
# 4/23/22.	wmk.	original code.
# 4/25/22.	wmk.	's removed from file=;UpdateIncs added to list.
# 5/2/22.	wmk.	Find*.sh, Reload*.sh, UpdateShells added to list.
# 5/5 22.	wmk.	missing shells all added to list; ListArchive added.
TEMP_PATH=$HOME/temp
ls IncDump*.sh > AllShells.txt
ls Find*.sh >> AllShells.txt
ls Reload*.sh >> AllShells.txt
ls FlashBacks*.sh >> AllShells.txt
ls UpdateIncs*.sh >> AllShells.txt
ls UpdateShells.sh >> AllShells.txt
ls ListArchive.sh >> AllShells.txt
ls DumpBasic.sh >> AllShells.txt
ls DumpGeany.sh >> AllShells.txt
ls DumpProcs.sh >> AllShells.txt
ls DumpTerr.sh >> AllShells.txt
ls LoadBasic.sh >> AllShells.txt
ls LoadGeany.sh >> AllShells.txt
ls LoadProcs.sh >> AllShells.txt
ls ReloadTerr.sh >> AllShells.txt
ls TarFileDate.sh >> AllShells.txt
file=AllShells.txt
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
  cp -pv UpdateIncs.sh  UpdateIncs
fi
diff -s UpdateShells.sh UpdateShells > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
  cp -pv UpdateShells.sh  UpdateShells
fi
diff -s ListArchive.sh ListArchive > $TEMP_PATH/scratchfile
if [ $? -ne 0 ];then
  cp -pv ListArchive.sh  ListArchive
fi
#end UpdateShells
