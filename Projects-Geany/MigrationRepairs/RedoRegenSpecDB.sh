#!/bin/bash
echo " ** RedoRegenSpecDB.sh out-of-date **";exit 1
echo " ** RedoRegenSpecDB.sh out-of-date **";exit 1
# RedoMakeRegenSpecDB.sh - Redo MakeRegenSpecDB makefile in territory xxx.
#	2/27/23.	wmk.
#
# Usage. bash RedoMakeRegen.sh <fixpath> [<terrid>]
#
#   <fixpath> = path to either <terrid> or if <terrid> omitted, to
#				MakeRegenSpecDB to modify (e.g. *codebase/Projects-Geany/SpecialRUdb)
#	<terrid> = (optional) territory ID for which to redo MakeRegenSpecDB.
#
# Modification History.
# ---------------------
# 12/16/22.	wmk.	ForceRegen semaphore added; documentation expanded
#		 with Notes.
# 2/27/23.	wmk.	documentation tweeks.
# Legacy mods.
# 9/23/22.  wmk.   (automated) CB *codebase env var support.
# 10/4/22.  wmk.   (automated) fix *pathbase for CB system.
# Legacy mods.
# 6/7/22.	wmk.	original code.
# 6/10/22.	wmk.	added <fixpath> support for fixing SCPA specials.
# 6/19/22.	wmk.	code generalized to handle no territory case (SpecialRUdb).
#
# Notes.
# RedoMakeRegen does the following:
#   if ForceRegen is not newer than *fixpath/Terr<terrid>/MakeRegenSpecDB
#	 *fixpath/Terr<terrid>/MakeRegenSpecDB checked for already modified.
#   if not already modified or ForceRegen is newer:
#	  *sed* with sedRegenSpecDB.txt
#		deletes recipe bounded by #============= lines
#		adds modification date comment at top
#	    adds new altproj definition after existing altproj definition
#		writes results to *TEMP_PATH/buffer1.txt
#	  backs up existing MakeRegenSpecDB to MakeRegenSpecDB.bak
#	  creates new MakeRegenSpecDB by concatenating buffer1.txt and
#		*project/MakeRegenSpecDB.txt to Terr<terrid>/MakeRegenSpecDB
#		   or <fixpath>/MakeRegenSpecDB
P1=$1		# <fixpath>
P2=$2		# <terrid>
if  ! test -f ForceRegen;then
 echo " ** missing ForceRegen semaphore file for RedoMakeRegen **"
 exit 1
fi
if [ -z "$P1" ];then
 echo "RedoMakeRegen <fixpath> <terrid> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$P2" ];then
 echo "RedoMakeRegen assuming not a <terrid> subfolder..."
fi
fixpath=$P1
if [ ! -z "$P2" ];then
 if ! test -f $fixpath/Terr$P2/MakeRegenSpecDB;then
  echo "RedoMakeRegen /Terr$P2/MakeRegenSpecDB file does not exist - abandoned."
  exit 1
 fi
else
 if ! test -f $fixpath/MakeRegenSpecDB;then
  echo "RedoMakeRegen $fixpath/MakeRegenSpecDB file does not exist - abandoned."
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
  ~/sysprocs/LOGMSG "  RedoMakeRegen $P2 - initiated from Make"
  echo "  RedoMakeRegen $P2 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RedoMakeRegen - initiated from Terminal"
  echo "  RedoMakeRegen - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
# procbodyhere.
projpath=$codebase/Projects-Geany/MigrationRepairs
if [ ! -z "$P2" ];then
 grep -q -e "main RegenSpecDB recipe" $fixpath/Terr$P2/MakeRegenSpecDB
 if [ $? -ne 0 ] || [ $projpath/ForceRegen -nt $fixpath/Terr$P2/MakeRegenSpecDB ];then
  sed -f $projpath/sedRegenSpecDB.txt $fixpath/Terr$P2/MakeRegenSpecDB > $TEMP_PATH/buffer1.txt 
  sed -i -f $projpath/sedRegenSpecDB.txt $TEMP_PATH/buffer1.txt
  mv $fixpath/Terr$P2/MakeRegenSpecDB $fixpath/Terr$P2/MakeRegenSpecDB.bak
  cat $TEMP_PATH/buffer1.txt  $projpath/MakeRegenSpecDB.txt \
   > $fixpath/Terr$P2/MakeRegenSpecDB
  # now ensure *codebase defined and fix *bash paths.
  mawk -f $projpath/awkaddcodebase.txt $fixpath/Terr$P2/MakeRegenSpecDB \
   > $TEMP_PATH/buffer2.txt
  mawk -f $projpath/awkfixpathbase.txt $TEMP_PATH/buffer2.txt \
   > $TEMP_PATH/buffer3.txt
   cp -pv $TEMP_PATH/buffer3.txt $fixpath/Terr$P2/MakeRegenSpecDB 
   sed -i 's?/Territories$?Territories/FL/SARA/86777?g' $fixpath/Terr$P2/MakeRegenSpecDB
 else
  echo "  Terr$P2/MakeRegenSpecDB already updated - skipping..."
  ~/sysprocs/LOGMSG "  Terr$P2/MakeRegenSpecDB already updated - skipping..."
  exit 0
 fi
else	# no territory specified (e.g. SpecialRUdb project)
 grep -q -e "main RegenSpecDB recipe" $fixpath/MakeRegenSpecDB
 if [ $? -ne 0 ];then
  sed -f $projpath/sedRegenSpecDB.txt $fixpath/MakeRegenSpecDB \
    > $TEMP_PATH/buffer1.txt
  sed -i -f $projpath/sedRegenSpecDB2.txt $TEMP_PATH/buffer1.txt
  mv $fixpath/MakeRegenSpecDB $fixpath/MakeRegenSpecDB.bak
  cat $TEMP_PATH/buffer1.txt $projpath/MakeRegenSpecDB.txt \
    > $fixpath/MakeRegenSpecDB
 else
  echo "  $fixpath/MakeRegenSpecDB already updated - skipping..."
  ~/sysprocs/LOGMSG "  $fixpath/MakeRegenSpecDB already updated - skipping..."
  exit 0
 fi
fi
# endprocbody.
echo "  RedoMakeRegen $P2 complete."
~/sysprocs/LOGMSG "  RedoMakeRegen $P2 complete."
# end RedoRegenSpecDB.sh

