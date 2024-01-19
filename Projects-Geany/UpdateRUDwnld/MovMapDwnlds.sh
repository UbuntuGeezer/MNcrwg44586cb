#!/bin/bash
echo " ** MovMapDwnlds.sh out-of-date **";exit 1
echo " ** MovMapDwnlds.sh out-of-date **";exit 1
# MovMapDwnlds.sh - Move all Mapxxx_RU.csv downloads to territories.
# 6/15/23.	wmk.
#
# Usage. bash  MovMapDwnlds.sh
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/6/23.	wmk.	original shell.
# 6/15/23.	wmk.	*DWNLD_PATH environment var used; *folderbase exported;	
# Notes. MovMapDwnlds obtains the ls -lh listing of all Mapxxx_RU.csv files
# currently in the ~/Downloads folder. The file dates are compared against the
# file dates in the territories. If the ~/Downloads file is newer, it is copied
# to the RefUSA-Downloads/Terrxxx folder; if not it is skipped. 
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  MovMapDwnlds - initiated from Make"
  echo "  MovMapDwnlds - initiated from Make"
else
  ~/sysprocs/LOGMSG "  MovMapDwnlds - initiated from Terminal"
  echo "  MovMapDwnlds - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
cd $DWNLD_PATH
ls -lh Map*_RU.csv > $TEMP_PATH/MapCSVs.lst
mawk '{print $8}' $TEMP_PATH/MapCSVs.lst > $TEMP_PATH/MapCSVs.txt
cat $TEMP_PATH/MapCSVs.txt
# now loop on file list checking dates and moving.
file=$TEMP_PATH/MapCSVs.txt
fcount=0
while read -e;do
 nxtfile=$REPLY
 fcount=$((fcount + 1))
 TID=${nxtfile:3:3}
 skip=0
 if test -f $pathbase/$rupath/Terr$TID/OBSOLETE;then
  echo " ** Territory $TID OBSOLETE - MovMapDwnlds skipping...**"
  skip=1
 fi
 if [ $skip -eq 0 ];then
  if [ "$HOME/Downloads/$nxtfile" -nt "$pathbase/$rupath/Terr$TID/$nxtfile" ];then
   cp -pv "$HOME/Downloads/$nxtfile" "$pathbase/$rupath/Terr$TID/$nxtfile"
  else
   diff -s "$HOME/Downloads/$nxtfile" "$pathbase/$rupath/Terr$TID/$nxtfile"
   echo "  Terr$TID/$nxtfile as new or newer than '$HOME/Documents/$nxtfile' - skipping.."
  fi # 	end -nt test
 fi	#end skip=0
 #if [ $fcount -gt 2 ];then break;fi
done < $file
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  MovMapDwnlds complete."
~/sysprocs/LOGMSG "  MovMapDwnlds complete."
# end MovMapDwnlds.sh
