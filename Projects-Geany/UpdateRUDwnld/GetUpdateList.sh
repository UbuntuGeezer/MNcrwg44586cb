# GetUpdateList.sh - Get list of out-of-date RU territories.
echo " ** GetUpdateList.sh out-of-date **";exit 1
echo " ** GetUpdateList.sh out-of-date **";exit 1
#	2/2/23.	wmk.
#!/bin/bash
# GenUpdateList.sh - <description>.
# 2/2/23.	wmk.
#
# Usage. bash  GenUpdateList.sh
#
# Entry. 
#
# Dependencies.
#
# Exit. TIDListOOD.txt = list of RU out-of-date territories.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. Generates TIDListOOD.txt of territories where 
# RefUSA-Downloads/Terrxxx/Terrxxx_RU.db
# OR
# RefUSA-Downloads/Terrxxx/Specxxx_RU.db
# is newer than
# TerrData/Terrxxx/Working-Files/QTerrxxx.csv.
# When this comparison is met, it means that BridgesToTerr
# needs to be run to update the publisher territory. 
# The resultant TIDListOOD.txt may then be copied to BridgesToTerr
# TIDList.txt for a batch run of BrigdesToTerr to update out-of-date
# publisher territories.
#
# set parameters P1..Pn here..
#
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
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$rupath" ];then
 export rupath=RawData/RefUSA/RefUSA-Downloads
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  UpdatePubTerrs - initiated from Make"
  echo "  UpdatePubTerrs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  UpdatePubTerrs - initiated from Terminal"
  echo "  UpdatePubTerrs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
thisproj=$codebase/Projects-Geany/UpdateRUDwnld
# compare dates of all 
# TerrData/Terrxxx/Working-Files/QTerrxxx.csv
# with all 
# RefUSA-Downloads/Terrxxx/Terrxxx_RU.ods
# and note which .ods files are newer.
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$rupath
ls -d Terr* > $TEMP_PATH/terrfolders.txt
popd  > $TEMP_PATH/scratchfile
file=$TEMP_PATH/terrfolders.txt
dbsuffx=_RU.db
rm $thisproj/TIDListOOD.txt
oodcount=0
while read -e;do
 echo "  Scanning $REPLY..."
 TID=${REPLY:4:3}
 skip=0
 if test -f $pathbase/$rupath/Terr$TID/OBSOLETE;then
  skip=1
  echo " ** Territory $TID OBSOLETE - GetUpdateList skipping...**"
 fi
 if [ $skip -eq 0 ];then
  if [ $pathbase/$rupath/$REPLY/$REPLY$dbsuffx \
   -nt $pathbase/TerrData/WorkingFiles/QTerr$TID.csv ];then
   echo "$TID" >> $thisproj/TIDListOOD.txt
   oodcount=$((oodcount+1))
  fi
 fi
done < $file
#endprocbody
echo " $oodcount RU territories out-of-date."
echo "  GenUpdateList complete."
~/sysprocs/LOGMSG "  GenUpdateList complete."
# end GenUpdateList.sh
