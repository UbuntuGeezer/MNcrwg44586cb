#!/bin/bash
echo " ** ListMissIDs.sh out-of-date **";exit 1
echo " ** ListMissIDs.sh out-of-date **";exit 1
# ListMissiDs.sh - List missing IDs by territory.
#	3/29/23.	wmk.
#
# Usage. bash  ListMissiDs.sh [<tidlist>]
#
#	<tidlist> = (optional) file with list of territories to process.
#				TIDList.txt default
#
# Entry. TIDList.txt = list of territories to list counts for.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 3/29/23.	wmk.	original shell.
#
# Notes. 
#
P1=$1
if [ -z "$P1" ];then
 P1=TIDList.txt
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
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
  ~/sysprocs/LOGMSG "  ListMissIDs - initiated from Make"
  echo "  ListMissiDs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ListMissiDs - initiated from Terminal"
  echo "  ListMissIDs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/UpdateRUDwnld
cd $projpath
./AllMissIDs.sh $P1 > $TEMP_PATH/idlist
gawk -f awksortmiss.txt $TEMP_PATH/idlist
#endprocbody
echo "  ListMissiDs complete."
~/sysprocs/LOGMSG "  ListMissiDs complete."
# end ListMissiDs.sh
