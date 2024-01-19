#!/bin/bash
echo " ** CopyPubNotes.sh out-of-date **";exit 1
echo " ** CopyPubNotes.sh out-of-date **";exit 1
# CopyPubNotes.sh - Copy PUB_NOTES_xxx.html to TerrData/Terrxxx.
#	10/5/22.	wmk.
#
# Usage.    bash CopyPubNotes.sh  <terrid>
#
#	<terrid> = territory ID to copy PUB_NOTES_<terrid>.html from
#
# Exit.    if RU/Terr<terrid>/PUB_NOTES_<terrid>.html exists it is
#		copied to TerrData/Terr<terrid> folder
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 10/5/22.	wmk.	comments tidied; notify-send deleted.
# Legacy mods.
# 1/31/22.	wmk.	original code.
# 4/24/22. 	wmk.	*pathbase* env var added; preserve PUB_NOTES date.
P1=$1
TID=$P1
TN="Terr"
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  CopyPubNotes $TID - initiated from Make"
else
  ~/sysprocs/LOGMSG "  CopyPubNotes $TID - initiated from Terminal"
  echo "  CopyPubNotes - initiated from Terminal"
fi 
TEMP_PATH="$folderbase/temp"
srcpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$TID
targpath=$pathbase/TerrData/Terr$TID
if test -f $srcpath/PUB_NOTES_$TID.html;then
 cp -p $srcpath/PUB_NOTES_$TID.html $targpath
fi
echo "  CopyPubNotes complete."
~/sysprocs/LOGMSG "  CopyPubNotes complete."
#end proc
