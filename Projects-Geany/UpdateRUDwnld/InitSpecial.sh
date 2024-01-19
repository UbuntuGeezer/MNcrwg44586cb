#!/bin/bash
echo " ** InitSpecial.sh out-of-date **";exit 1
echo " ** InitSpecial.sh out-of-date **";exit 1
#InitSpecial.sh - Create initial file set for territorY RU Special processing.
# 7/10/23.	wmk.
#
#	Usage. bash InitSpecial.sh  <terrid> <state> <county> <congo>
#
#		<terrid> = territory ID  for which to create files.
#
# Dependencies.
#
#	Exit.	SPECIAL, RegenSpecDB.*, SyncTerrToSpec.*, MakeRegenSpecDB,
#			MakeSyncTerrToSpec files copied to ~RefUSA-Downloads/Terr<terrid>
#
# Modification History.
# ---------------------
# 6/6/23.	wmk.	OBSOLETE territory detection; *congterrid test fixed;
#			 comments tidied.
# 7/10/23.	wmk.	exit after informing user to use SpecialRUdb project.
# Legacy mods.
# 4/25/22.	wmk.	modified for general use;*pathbase* support; -p option
#			 added to cp to preserve dates.
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# Legacy mods.
# 6/28/21.	wmk.	original code (multihost support).
# 7/6/21.	wmk.	multihost code generalized.
# function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
echo "To initialize files in an RU territory, use"
echo " InitSpecial from the SpecialRUdb project..."
exit 0
P1=$1
TID=$P1
P2=${2^^}
P3=${3^^}
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ];then
 echo "InitSpecial <terrid> <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
fi
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
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P2$P3$P4" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P2$P3$P4 mismatch with *congterr* - InitSpecial abandoned **"
 exit 1
fi
if test -f $pathbase/$rupath/OBSOLETE;then
 echo " ** Territory $P1 OBSOLETE - InitSpecial exiting...**"
 exit 2
fi
#
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="%folderbase/ubuntu/SystemLog.txt"
  ~/sysprocs/LOGMSG "   InitSpecial initiated from Make."
  echo "   InitSpecial initiated."
else
  bash ~/sysprocs/LOGMSG "   InitSpecial initiated from Terminal."
  echo "   InitSpecial initiated."
fi
TEMP_PATH="$HOME/temp"
#
if [ -z "$P1" ]; then
  echo "  InitSpecial ignored.. must specify <terrid>." >> $system_log #
  echo "  InitSpecial ignored.. must specify <terrid>."
  exit 1
else
  echo "  InitSpecial $P1 - initiated from Terminal" >> $system_log #
  echo "  InitSpecial $P1 - initiated from Terminal"
fi 
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
#
#procbodyhere
dwnldpath=$pathbase/RawData/RefUSA/RefUSA-Downloads/Terr$P1
if test -f $dwnldpath/SPECIAL;then 
 echo " SPECIAL already present - skippped."
else
 cp -p SPECIAL $dwnldpath
fi
if test -f $dwnldpath/RegenSpecDB.sq; then
 echo "  RegenSpecDB.* already exist - skippped. "
else
 cp -p RegenSpecDB.* $dwnldpath
fi
if test -f $folderbase/$dwnldpath/SyncTerrToSpec.sq; then
 echo " SyncTerrToSpec.* already exist - skipped."
else
 cp -p SyncTerrToSpec.* $dwnldpath
fi
if test -f $folderbase/$dwnldpath/MakeRegenSpecDB; then
 echo " MakeRegenSpecDB already exists - skipped."
else
 cp -p MakeRegenSpecDB.tmp $dwnldpath
fi
if test -f $dwnldpath/MakeSyncTerrToSpec; then
 echo " MakeSyncTerrToSpec* already exists - skipped."
else
 cp -p MakeSyncTerrToSpec.tmp $dwnldpath
fi
#end proc body
if [ $local_debug = 1 ]; then
  popd
fi
jumpto EndProc
EndProc:
if [ "$USER" != "vncwmk3" ];then
notify-send "InitSpecial" "complete - $P1"
 echo "  InitSpecial $P1 complete."
fi
~/sysprocs/LOGMSG "InitSpecial $P1 complete."
echo "  Now use 'sed' to change xxx to the territory ID in"
echo "  the RegenSpecDB.sq and SyncTerrToSpec.sq files"
echo "  and the MakeRegenSpecDB.tmp and MakeSyncTerrToSpec.tmp"
echo "  files to their respective files with no .tmp extensions."
echo "  Manually edit the <special-db> names into the RegenSpecDB.sq"
echo "  file ATTACH statements."
#end InitSpecial
