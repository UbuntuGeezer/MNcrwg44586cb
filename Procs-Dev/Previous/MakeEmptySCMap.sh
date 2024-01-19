#!/bin/bash
# MakeEmptySCMap.sh - Create an empty SC Map file for MultiMail territory.
#	4/25/22.	wmk.
#
# bash MakeEmptySCMap   <terrid> <state> <county> <congno>
#
#	<terrid> = territory id
#
#	Entry Dependencies.
#   Folder TErr<terrid> exists in ~/RawData/SCPA/SCPA-Downloads
#   (See MakeRawData proc)
#
#	Exit Results.
#	File Map<terrid>_SC.csv created empty in folder Terr<terrid>
#	in downloads. Folder name resulting from change TErr<terrid>
#
# Modification History.
# ---------------------
# 4/25/22.	wmk.	modified for general use FL/SARA/86777
# Legacy mods.
# 1/8/21.	wmk.	original shell
# 1/18/21.	wmk.	junk.txt deleted after pushd
# 5/30/21.	wmk.	modified for multihost support.
# 9/10/21.	wmk.	remove jumpto function; cleanup pushd and pop;
#			 generalize folderbase var code; eliminate
#			 superfluous "s; add LOGMSG.
#
#	Notes. This proc creates an empty map file for territories that
#	consist of all parcels that are condosOR MHPs with a single address.
#	This allows for rapid generation of territories using RU data only.
#
P1=$1
TID=$1
P2=${2^^}
P3=${3^^}
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ];then
 echo "ClearTargets <terrid> <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
fi
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
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P2$P3$P4" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P2$P3$P4 mismatch with *congterr* - FlashBacks abandoned **"
 exit 1
fi
P1=${P1,,}
#
if [ -z "$1" ]; then
  ~/sysprocs/LOGMSG "  MakeEmptyRUMap.. -terrid not specified - abandoned."
  echo "  MakeEmptyRUMap.. must specify - terrid."
  exit 1
else
  ~/sysprocs/LOGMSG "  MakeEmptyRUMap $1 - initiated from Terminal"
  echo "  MakeEmptyRUMap $1 - initiated from Terminal"
fi 
#proc body here

TID=$1
TERR_BASE="TErr$TID"
TERR_NEWBASE="Terr$TID"
MAP_FILE="Map$TID"
MAP_SFX="_SC.csv"
cd $pathbase/RawData/SCPA/SCPA-Downloads
mv $TERR_BASE $TERR_NEWBASE
cd ./$TERR_NEWBASE
touch $MAP_FILE$MAP_SFX

#end proc body
notify-send "MakeEmptySCMap $TID" "complete."
~/sysprocs/LOGMSG " MakeEmptySCMap $TID" "complete."
echo "  MakeEmptySCMap $TID complete."

# end MakeEmptySCMAP.sh
