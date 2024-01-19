#!/bin/bash
echo " ** MakeEmptyRUMap.sh out-of-date **";exit 1
# MakeEmptyRUMap.sh - Create an empty RU Map file for territory.
#	5/22/23.	wmk.
#
# bash MakeEmptyRUMap   <terrid> <state> <county> <congno>
#
#	<terrid> = territory id
#
#	Entry Dependencies.
#   Folder TErr<terrid> checked in ~/RawData/RefUSA/RefUSA-Downloads
#   (See MakeRawData proc)
#
#	Exit Results.
#	File Map<terrid>_RU.csv created empty in folder Terr<terrid>
#	in downloads. Folder name resulting from change TErr<terrid>
#
# Modification History.
# ---------------------
# 2/21/23.	wmk.	*codebase support; notify-send removed; jumpto references
#			 removed; comments tidied.
# 5/22/23.	wmk.	error message text corrections.
# Legacy mods.
# 4/25/22.	wmk.	modified for general use FL/SARA/86777
# Legacy mods.
# 1/8/21.	wmk.	original shell; adapted from MakeEmptyRUMap
# 5/30/21.	wmk.	modified for multihost system support.
# 10/15/21.	wmk.	rm junk made conditional.
# 10/23/21.	wmk.	mv $TERR_BASE made conditional; create folder
#					RU-Downloads/Terrxxx if does not exist.
#
#	Notes. This proc creates an empty map file for territories that
#	consist of all parcels that are condos with a single address. This
#   allows for rapid generation of territories using RU data only.
#
P1=$1
TID=$1
P2=${2^^}
P3=${3^^}
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ];then
 echo "MakeEmptyRUMap <terrid> <state> <county> <congno> missing parameter(s) - abandoned."
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
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P2$P3$P4" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P2$P3$P4 mismatch with *congterr* - MakeEmptyRUMap abandoned **"
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
#procbodyhere
pushd ./ >>junk.txt
rm junk.txt

TID=$1
TERR_BASE="TErr$TID"
TERR_NEWBASE="Terr$TID"
MAP_FILE="Map$TID"
MAP_SFX="_RU.csv"
cd $pathbase/RawData/RefUSA/RefUSA-Downloads
if test -d "$TERR_BASE";then
 if ! test -d "$TERR_NEWBASE";then
  mv $TERR_BASE $TERR_NEWBASE
 fi
fi
if ! test -d "./$TERR_NEWBASE";then
 mkdir $TERR_NEWBASE
fi
cd ./$TERR_NEWBASE
if test -f "$MAP_FILE$MAP_$FX";then rm $MAP_FILE$MAP_$FX;fi
touch $MAP_FILE$MAP_SFX

popd >>junk.txt
if test -f "junk.txt";then rm junk.txt;fi
#endprocbody
echo "  MakeEmptyRUMap $TID complete."

# end MakeEmptyRUMAP.sh
