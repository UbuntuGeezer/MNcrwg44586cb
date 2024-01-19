#!/bin/bash
echo " ** DoAllRedos.sh out-of-date **";exit 1
echo " ** DoAllRedos.sh out-of-date **";exit 1
# DoAllRedos.sh - Run Redo..sh and FixMakeSpecials, FixMakeSpecials1 in territory xxx.
#	12/18/22.	wmk.
#
# Usage. bash DoAllRedos.sh <fixpath> [<terrid>]
#
#   <fixpath> = path to either <terrid> or if <terrid> omitted, to
#				Make.. to modify (e.g. *codebase/Projects-Geany/SpecialRUdb)
#	<terrid> = (optional) territory ID for which to run all Redo shells.
#
# Modification History.
# ---------------------
# 12/18/22.	wmk.	original code.
P1=$1
P2=$2
if [ -z "$P1" ];then
 echo "DoAllRedos <fixpath> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 echo "DoAllRedos assuming not a <terrid> subfolder..."
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
  ~/sysprocs/LOGMSG "  RedoMakeRegen $P2 - initiated from Make"
  echo "  RedoMakeRegen $P2 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RedoMakeRegen - initiated from Terminal"
  echo "  RedoMakeRegen - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# procbodyhere.
./RedoRegenSpecDB.sh $P1 $P2
./RedoSetSpec.sh     $P1 $P2
./RedoSyncTerr.sh    $P1 $P2
./FixMakeSpecials.sh $P1 $P2
./FixMakeSpecials1.sh $P1 $P2
# endprocbody.
echo "  DoAllRedos $P2 complete."
~/sysprocs/LOGMSG "  DoAllRedos $P2 complete."
# end DoAllRedos.sh

