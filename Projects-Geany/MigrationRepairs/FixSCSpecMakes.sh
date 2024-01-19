#!/bin/bash
echo " ** FixSCSpecMakes.sh out-of-date **";exit 1
echo " ** FixSCSpecMakes.sh out-of-date **";exit 1
# FixSCSpecMakes.sh - Fix SC/Special/Make.<db-name>.Terr makefiles.
# 5/5/23.	wmk.
#
# Usage. bash  FixSCSpecMakes.sh
#
# Entry.	/SCPA-Downloads/Special/Make.<db-names>.Terr files are
#		makefiles for rebuilding affected territories whenever
#		<db-names>.db has been updated.
#
# Modification History.
# ---------------------
# 5/5/23.	wmk.	original code; adapted from FixSetSpecTerrs.sh
# Legacy mods.
# 12/16/22.	wmk.	original code; adapted from FixSyncTerrs.sh.
# Legacy mods.
# 6/3/22.	wmk.	original code.
# 9/21/22.	wmk.	modified for Chromebook.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
#
# Notes. FixSCSpecMakes corrects a bug in all of the existing SC/Special
# /Make.<spec-db>.Terr makefiles where the target .db of the make was
# _RU.db and it should have been _SC.db. Each makefile has as (grouped)
# targets all Terrxx_SC.db,s that need to be updated when <spec-db>.db
# has been updated. The *MakeSpecials makefile is invoked for each
# affected territory.
if [ 1 -eq 0 ];then
#----------------------------------
P1=$1
P2=$2
if [ -z "$P1" ] || [ -z "$P2" ];then
 echo "FixSCSpecMakes  <rawpath> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
# do not process if P2 in range 500 - 700; business & letter
if [ $P2 -ge 500 ] && [ $P2 -le 699 ];then
 echo "  FixSCSpecMakes territory $P2 is letter or business - skipped."
 exit 0
fi
fi
#-----------------------------------
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
  export system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  FixSCSpecMakes - initiated from Make"
  echo "  FixSCSpecMakes - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FixSCSpecMakes - initiated from Terminal"
  echo "  FixSCSpecMakes - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#beginprocbody
projpath=$codebase/Projects-Geany/MigrationRepairs
SCpath=$pathbase/$scpath/Special
pushd ./ > $TEMP_PATH/scratchfile
cd $SCpath
echo "PWD = '$PWD'"
ls Make.*.Terr > $TEMP_PATH/MakeList.txt
# loop on Makelist files editing with sedscspecmakes.txt.
nfiles=0
file=$TEMP_PATH/MakeList.txt
while read -e;do
 nfiles=$((nfiles+1))
 fname=$REPLY
 echo "  processing $fname..."
sed  -i -f $projpath/sedscspecmakes.txt $fname
done < $file
popd > $TEMP_PATH/scratchfile
echo "  $nfiles makefiles processed."
#endprocbody
echo "  FixSCSpecMakes $P1 $P2 complete."
~/sysprocs/LOGMSG "  FixSCSpecMakes $P1 $P2 complete."
# end FixSCSpecMakes
