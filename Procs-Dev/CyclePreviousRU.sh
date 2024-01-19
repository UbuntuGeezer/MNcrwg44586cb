#!/bin/bash
# CyclePreviousRU.sh - Cycle /Previous folder for territory xxx.
#	7/9/23.	wmk.
#	Usage. bash CyclePreviousRU.sh <terrid> [-k]
#		<terrid> - territory id
#		[-k] - optional; keep current .db, but copy to ./Previous
#
# Dependencies.
#	Copies /Previous/Terrxxx_RU.db to Terrxxx_RU~.db in /Previous folder.
#	Copies /Previous/FixyyyRU.sql to FixyyyRU~.sql in /Previous folder.
#   Copies Terrxxx_RU.db to Terrxxx_RU.db in /Previous folder.
#	Copies Fixyyy.RU.sql to FixyyyRU.sql in /Previous folder.
#	All these files are older versions for fixing future yyy RU downloads.
#
# Modification History.
# ---------------------
# 7/9/23.	wmk.	deactivate code that rm'd Terrxxx_RU.sql.
# 7/17/22.	wmk.	*pathbase support; -k option (keep current); -p added to
#			 cp commands to preserve file dates.
# 10/2/22.	wmk.	modified for Chromebook; *codebase support.
# Legacy mods.
# 3/13/12.	wmk.	original shell.
# 5/31/21.	wmk.	multihost system support.
# 9/10/21.	wmk.	superfluous "s removed; multihost code generalized;
#					test -d used instead of cd; pushd ./ popd sequences
#					removed.
# 10/12/21.	wmk.	add test and cycle Specxxx_RU.db to code for SPECIAL territories.
# 11/12/21.	wmk.	test for Fix file before removing.
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
TEMP_PATH=$HOME/temp
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
#
P1=$1			# terrid
P2=${2^^}		# -k
if [ -z "$P1" ];then
 echo "CyclePreviousRU <terrid> [-k] missing parameter(s) - abandoned."
 exit 1
fi
if [ ! -z "$P2" ];then		# check for -K option
 if [ "$P2" != "-K" ];then
  echo "CyclePrevious $P1  $P2 - unrecognized option $P2 - abandoned."
  exit 1
 fi
fi
TID=$P1
F_BASE=Terr
S_BASE=Spec
FIX_BASE=Fix
FIX_SUFFX=RU.sql
FIX2_SUFFX=RU~.sql
DB_SUFFX=_RU.db
DB2_SUFFX=_RU~.db

FOLDER=$F_BASE$TID		
F_NAME=$F_BASE$TID$DB_SUFFX	
F2_NAME=$F_BASE$TID$DB2_SUFFX	
F3_NAME=$FIX_BASE$TID$FIX_SUFFX	
F4_NAME=$FIX_BASE$TID$FIX2_SUFFX
S_NAME=$S_BASE$TID$DB_SUFFX
S2_NAME=$S_BASE$TID$DB2_SUFFX
local_debug=0	# set to 1 for debugging
#local_debug=1

if [ $local_debug -eq 1 ]; then
 echo "   processing $F_NAME $F2_NAME $F3_NAME $F4_NAME"
fi

# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "   CyclePreviousRU initiated from Make."
  echo "   CyclePreviousRU initiated."
else
  ~/sysprocs/LOGMSG "   CyclePreviousRU initiated from Terminal."
  echo "   CyclePreviousRU initiated."
fi
  TEMP_PATH=$HOME/temp
#
#proc body here
cd $pathbase/RawData/RefUSA/RefUSA-Downloads
if test -d ./$FOLDER/Previous ; then
#if cd ./$FOLDER/Previous ; then
  ~/sysprocs/LOGMSG "   $F_BASE$TID/Previous folder exists, proceeding.."
  echo "   $F_BASE$TID/Previous folder exists, proceeding.."
else
  ~/sysprocs/LOGMSG "   $F_BASE$TID/Previous folder nonexistent - CyclePreviousRU abandoned." $system_log
  echo "   $F_BASE$TID/Previous folder nonexistent - CyclePreviousRU abandoned."
  echo " Run CyclePreviousRU.sh first."
  exit 1
fi
# see if Fix.. files exist first..
if test -f ./$FOLDER/$F_NAME; then
  if test -f ./$FOLDER/Previous/$F_NAME ; then
    mv $FOLDER/Previous/$F_NAME ./$FOLDER/Previous/$F2_NAME
  fi
  cp -p ./$FOLDER/$F_NAME ./$FOLDER/Previous/$F_NAME
  if [ -z "$P2" ];then
   rm ./$FOLDER/$F_NAME
  fi
#
# why in the world did we remove Fix..RU.sql???...
if [ 1 -eq 0 ];then
  #if ls $FOLDER/Previous/$F3_NAME >> $TEMP_PATH/bitbucket.txt; then
  if test -f ./$FOLDER/Previous/$F3_NAME;then
    mv ./$FOLDER/Previous/$F3_NAME ./$FOLDER/Previous/$F4_NAME
  fi
  if test -f ./$FOLDER/$F3_NAME;then
   cp -p ./$FOLDER/$F3_NAME ./$FOLDER/Previous/$F3_NAME
   if [ -z "$P2" ];then
    rm ./$FOLDER/$F3_NAME
   fi
  fi
fi
fi	# end 1=0
#
if test -f ./$FOLDER/Previous/$S_NAME;then
  mv ./$FOLDER/Previous/$S_NAME ./$FOLDER/Previous/$S2_NAME
fi
cp -p ./$FOLDER/$S_NAME $FOLDER/Previous
if [ -z "$P2" ];then
 rm ./$FOLDER/$S_NAME
fi
#
DIGIT=${TID:0:1}
if [ "$DIGIT" == "6" ];then
  $codebase/Procs-Dev/RUNewTerr_db.sh $TID
fi
# end proc body
#
~/sysprocs/LOGMSG "   CyclePreviousRU $TID $P2 complete."
echo "  CyclePreviousRU $TID $P2 complete."
#end CyclePreviousRU
