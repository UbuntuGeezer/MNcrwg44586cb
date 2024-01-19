#!/bin/bash
echo " ** UpdateSpecTerrIDs.sh out-of-date **";exit 1
echo " ** UpdateSpecTerrIDs.sh out-of-date **";exit 1
# UpdateSpecTerrIDs.sh - Update <special-db>.Spec_RUBridge territory IDs.
#	6/5/23.	wmk.
# Usage.	bash UpdateSpecTerrIDs.sh  <special-db>
#
# Entry.	RU/Special/<special-db>.TIDList.txt is list of territories
#			using this <special-db>.
#
# Modification History.
# ---------------------
# 6/5/23.	wmk.	OBSOLETE territory detection; comments tidied.
# Legacy mods.
# 4/24/22.	wmk.	code generalized for FL/SARA/86777;*pathbase*, 
#			 *congterr*, *conglib* env vars introduced.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# Legacy mods.
# 11/8/21.	wmk.	original code.
# 12/28/21.	wmk.	notify-send conditional; change to use $ USER env var.
#
# Notes. Copies <special-db>.TIDList.txt to {SpecialRUdb}/TIDList.txt
# then runs make or utility to cycle through each territory in TIDList.txt
# running its /RU../Terrxxx/SetSpecTerrs.sh shell to update the territory
# IDs in the Spec_RUBridge records for this <special-db>.
#
# Note on notes... SetSpecTerrs.sh shell will update RUBridge records for
# ALL databases used by that territory... redundant, but will work.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ];then
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
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ -z "$conglib" ];then
 export conglib=FLsara86777
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   RegenAllSpecRU initiated from Make."
else
  ~/sysprocs/LOGMSG "   RegenAllSpecRU initiated from Terminal."
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$HOME/temp
#
P1=$1
local_debug=0	# set to 1 for debugging
projbase=$codebase/Projects-Geany/SpecialRUdb
specbase=$pathbase/RawData/RefUSA/RefUSA-Downloads/Special
terrbase=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr
# copy TIDList.txt to project folder.
if test -f $folderbase/$specbase/$P1.TIDList.txt;then
 cp $folderbase/$specbase/$P1.TIDList.txt \
    $folderbase/$projbase/TIDList.txt
else
 echo "** No $P1.TIDList.txt file - UpdateSpecTerrIDs abandoned. ** "
 ~/sysprocs/LOGMSG "  ** No $P1.TIDList.txt file - UpdateSpecTerrIDs abandoned. ** "
 exit 1
fi
# loop running SetSpecTerrs.sh from each territory folder.
# $ terrbase has territory folder minus territory ID.
# stub in territory 602 from AvensCohosh
TID=602
 if test -f $terrbase$TID/OBSOLETE;then
  echo " Territory $TID OBSOLETE - UpdateSpecTerrIDs exiting..**"
  exit 2
 fi
  if test -f $terrbase$TID/SetSpecTerrs.sh;then
    make -f $terrbase$TID/MakeSpecials
  else
    echo "** No $P1.TIDList.txt file - UpdateSpecTerrIDs abandoned. ** "
    ~/sysprocs/LOGMSG "  ** No $P1.TIDList.txt file - UpdateSpecTerrIDs abandoned. ** "
    exit 1
  fi

#end proc body
if [ $local_debug = 1 ]; then
  popd > $TEMP_PATH/scratchfile.txt
fi
if [ "$USER" != "vncwmk3" ];then
 notify-send "UpdateSpecTerrIDs" "$1 complete."
fi
~/sysprocs/LOGMSG  "UpdateSpecTerrIDs$1 complete."
echo "  UpdateSpecTerrIDs $P1 complete."
#end UpdateSpecTerrIDs
