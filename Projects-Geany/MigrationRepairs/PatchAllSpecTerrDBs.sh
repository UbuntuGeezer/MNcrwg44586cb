#!/bin/bash
# PatchAllSpecTerrDBs.sh.sh - Fix all MakeSpecials files on *rawbase*.
#	5/11/23.	wmk.
#
# Usage.  bash PatchAllSpecTerrDBs.sh.sh <rawbase> [<limit>]
#
#	<rawbase> = base path of Terryyy files 
#				(e.g. *pathbase*/*scpath)
#	<limit> = (optional) max count of db,s to process
#				default=100
#
# Entry. <path>/Special/SCSpecTerrsSorted.txt = sorted list of SC /Special terrs
#
# Modification History.
# ---------------------
# 5/11/23.	wmk.	original shell.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# Legacy mods.
# 6/3/22.	wmk.	original code; adapted from RebuildAllFixSCs.
# 9/21/22.	wmk.	modified for Chromebook.
#
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "PatchAllSpecTerrDBs.sh <rawbase> [<limit>] missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 P2=100
fi
if ! test -d $P1;then
 echo "PatchAllSpecTerrDBs.sh path '$P1' does not exist - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
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
  ~/sysprocs/LOGMSG "  PatchAllSpecTerrDBs.sh - initiated from Make"
  echo "  PatchAllSpecTerrDBs.sh - initiated from Make"
else
  ~/sysprocs/LOGMSG "  PatchAllSpecTerrDBs.sh - initiated from Terminal"
  echo "  PatchAllSpecTerrDBs.sh - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# procbodyhere.
# get file list...
projpath=$codebase/Projects-Geany/MigrationRepairs
cd $P1/Special
cp -pv SCSpecTerrsSorted.txt $projpath/SpecList.txt
awk  '{print $1}' $projpath/SpecList.txt > $projpath/BatchList.txt
# loop on BatchList.txt...
cd $projpath
file=$projpath/BatchList.txt
flimit=$P2
fcount=0
while read -e;do
 len=${#REPLY}
 fn=${REPLY:0:len}
 TID=${REPLY:4:3}
  echo "processing  $TID/databases ..."
  $projpath/DoSed.sh $TID
  make -f $projpath/MakePatchSpecTerrDBs 
  fcount=$((fcount+1))
  if [ $fcount -ge $flimit ];then break;fi
done < $file
#endprocbody.
echo "  $fcount files processed."
~/sysprocs/LOGMSG "  PatchAllSpecTerrDBs.sh $P1 $P2 complete."
echo "  PatchAllSpecTerrDBs.sh $P1 $P2 complete."
# end PatchAllSpecTerrDBs.sh.
