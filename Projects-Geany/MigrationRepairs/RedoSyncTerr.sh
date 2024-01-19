#!/bin/bash
echo " ** RedoSyncTerr.sh out-of-date **";exit 1
echo " ** RedoSyncTerr.sh out-of-date **";exit 1
# RedoMakeSyncTerr.sh - Redo MakeSyncTerrToSpec makefile in territory xxx.
#	2/27/23.	wmk.
#
# Usage. bash RedoMakeSyncTerr.sh <fixpath> [<terrid>]
#
#   <fixpath> = path to either <terrid> or if <terrid> omitted, to
#				MakeSyncTerrTerrs to modify (e.g. *codebase/Projects-Geany/SpecialRUdb)
#	<terrid> = (optional) territory ID for which to redo MakeSyncTerrTerrs.
#
# Modification History.
# ---------------------
# 12/16/22.	wmk.	ForceRegen semaphore added; documentation expanded.
#		 with Notes.
# 2/27/23.	wmk.	sedSetSpecTerrs2.txt added; *sed sequence changed to properly
#			 insert new code.
# Legacy mods.
# 9/23/22.  wmk.   (automated) CB *codebase env var support.
# 10/4/22.  wmk.   (automated) fix *pathbase for CB system.
# Legacy mods.
# 6/7/22.	wmk.	original code.
# 6/10/22.	wmk.	added <fixpath> support for fixing SCPA specials.
# 6/19/22.	wmk.	code generalized to handle no territory case (SpecialRUdb).
#
# Notes.
# RedoMakeSyncTerr does the following:
#   if ForceRegen is not newer than *fixpath/Terr<terrid>/MakeSyncTerrDB
#	*fixpath/Terr<terrid>/MakeSyncTerrToSpec checked for already modified.
#   if not already modified or ForceRegen is newer:
#	  *sed* with sedRegenSpecDB.txt
#		deletes recipe bounded by #============= lines
#		adds modification date comment at top
#	    adds new altproj definition after existing altproj definition
#		writes results to *TEMP_PATH/buffer1.txt
#	  backs up existing MakeSyncTerrSpecDB to MakeSyncTerrSpecDB.bak
#	  creates new MakeSyncTerrSpecDB by concatenating buffer1.txt and
#		*project/MakeSyncTerrSpecDB.txt to Terr<terrid>/MakeSyncTerrSpecDB
#		   or <fixpath>/MakeSyncTerrSpecDB
P1=$1
P2=$2
if  ! test -f ForceRegen;then
 echo " ** missing ForceRegen semaphore file for RedoMakeSyncTerr **"
 exit 1
fi
if [ -z "$P1" ];then
 echo "RedoMakeSyncTerr <fixpath> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 echo "RedoMakeSyncTerr assuming not a <terrid> subfolder..."
fi
fixpath=$P1
if [ ! -z "$P2" ];then
 if ! test -f $fixpath/Terr$P2/MakeSyncTerrToSpec;then
  echo "RedoMakeSyncTerr /Terr$P2/MakeSyncTerrToSpec file does not exist - abandoned."
  exit 1
 fi
else
 if ! test -f $fixpath/MakeSyncTerrToSpec;then
  echo "RedoMakeSyncTerr $fixpath/MakeSyncTerrToSpec file does not exist - abandoned."
  exit 1
 fi
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
  ~/sysprocs/LOGMSG "  RedoMakeSyncTerr $P2 - initiated from Make"
  echo "  RedoMakeSyncTerr $P2 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RedoMakeSyncTerr - initiated from Terminal"
  echo "  RedoMakeSyncTerr - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# procbodyhere.
projpath=$codebase/Projects-Geany/MigrationRepairs
if [ ! -z "$P2" ];then
 grep -q -e "main SyncTerrToSpec recipe" $fixpath/Terr$P2/MakeSyncTerrToSpec
 if [ $? -ne 0 ] || [ $projpath/ForceRegen -nt $fixpath/Terr$P2/MakeSyncTerrToSpec ];then
  sed -f $projpath/sedSyncTerrToSpec.txt $fixpath/Terr$P2/MakeSyncTerrToSpec \
    > $TEMP_PATH/buffer1.txt
  sed -i -f $projpath/sedSyncTerrToSpec2.txt $TEMP_PATH/buffer1.txt
  mv $fixpath/Terr$P2/MakeSyncTerrToSpec $fixpath/Terr$P2/MakeSyncTerrToSpec.bak
  cat $TEMP_PATH/buffer1.txt $projpath/MakeSyncTerrToSpec.txt \
    > $fixpath/Terr$P2/MakeSyncTerrToSpec
  # now ensure *codebase defined and fix *bash paths.
  mawk -f $projpath/awkaddcodebase.txt $fixpath/Terr$P2/MakeSyncTerrToSpec \
   > $TEMP_PATH/buffer2.txt
  mawk -f $projpath/awkfixpathbase.txt $TEMP_PATH/buffer2.txt \
   > $TEMP_PATH/buffer3.txt
   cp -pv $TEMP_PATH/buffer3.txt $fixpath/Terr$P2/MakeSyncTerrToSpec
   sed -i 's?/Territories$?Territories/FL/SARA/86777?g' $fixpath/Terr$P2/MakeSyncTerrToSpec
 else
  echo "  Terr$P2/MakeSyncTerrTerrToSpec already updated - skipping..."
  ~/sysprocs/LOGMSG "  Terr$P2/MakeSyncTerrToSpec already updated - skipping..."
  exit 0
 fi
else	# no territory specified (e.g. SpecialRUdb project)
 grep -q -e "main SyncTerrToSpec recipe" $fixpath/MakeSyncTerrTerrToSpec
 if [ $? -ne 0 ];then
  sed -f $projpath/sedsetSyncTerrToSpec.txt $fixpath/MakeSyncTerrTerrToSpec \
    > $TEMP_PATH/buffer1.txt
  sed -i -f $projpath/sedsetSyncTerrToSpec2.txt $TEMP_PATH/buffer1.txt
  mv $fixpath/MakeSyncTerrToSpec $fixpath/MakeSyncTerrToSpec.bak
  cat $TEMP_PATH/buffer1.txt $projpath/MakeSyncTerrToSpec.txt \
    > $fixpath/MakeSyncTerrToSpec
 else
  echo "  $fixpath/MakeSyncTerrToSpec already updated - skipping..."
  ~/sysprocs/LOGMSG "  $fixpath/MakeSyncTerrToSpec already updated - skipping..."
  exit 0
 fi
fi
# endprocbody.
echo "  RedoMakeSyncTerr $P2 complete."
~/sysprocs/LOGMSG "  RedoMakeSyncTerr $P2 complete."
# end RedoRegenSpecDB.sh

