#!/bin/bash
echo " ** ObsoleteTerr.sh out-of-date **";exit 1
echo " ** ObsoleteTerr.sh out-of-date **";exit 1
# ObsoleteTerritory - Force territory to OBSOLETE status.
#	4/1/23.	wmk.
#
# Usage. bash ObsoleteTerritory.sh <terrid>
#
#	<terrid> = territory ID to obsolete
#
# Exit. TerrData/Terr<terrID> files removed and replaced with Obsolete.* files.
#
# Modification History.
# ---------------------
# 4/1/23.	wmk.	original shell.
P1=$1
if [ -z "$P1" ];then
 echo "ObsoleteTerritory <terrid> missing parameter(s) - abandoned."
 exit 1
fi
#echo "ObsoleteTerritory stubbed - exiting."
#exit 0
if ! test -f $pathbase/$rupath/Terr$P1/OBSOLETE;then
 echo "  OBSOLETE semaphore missing from RU/Terr$P1..."
 read -p "Do you wish to save OBSOLETE semaphore (y/n): "
 yn=${REPLY^^}
 if [ "$yn" == "Y" ];then
  touch $pathbase/$rupath/Terr$P1/OBSOLETE
  echo "  OBSOLETE semaphore created."
 fi
fi
if ! test -f $pathbase/$scpath/Terr$P1/OBSOLETE;then
 echo "  OBSOLETE semaphore missing from SC/Terr$P1..."
 read -p "Do you wish to save OBSOLETE semaphore (y/n): "
 yn=${REPLY^^}
 if [ "$yn" == "Y" ];then
  touch $pathbase/$scpath/Terr$P1/OBSOLETE
  echo "  OBSOLETE semaphore created."
 fi
fi
echo "  Clearing MainDBs of all territory $P1 records..."
$codebase/Procs-Dev/ClearTerr.sh $P1
echo "  Overwriting TerrData files.."
ls $pathbase/TerrData/Terr$P1/Terr$P1*  > $TEMP_PATH/scratchfile 2> $TEMP_PATH/scratchfile
if [ $? -eq 0 ];then
 rm -v $pathbase/TerrData/Terr$P1/Terr$P1*
fi
cp $pathbase/TerrData/Obsolete/* $pathbase/TerrData/Terr$P1
if test -f $pathbase/TerrData/Terr$P1/PUB_NOTES_$P1.html;then
 rm $pathbase/TerrData/Terr$P1/PUB_NOTES_$P1.html
fi
echo "  Editing PUB_NOTES_$P1..."
sed -i "s?xxx?$P1?g" $pathbase/TerrData/Terr$P1/PUB_NOTES_Obsolete.html
echo "  ObsoleteTerr complete."
# end ObsoleteTerr.
