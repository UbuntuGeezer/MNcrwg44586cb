#!/bin/bash
# MakeTerrData.sh -  (Dev) Make TerrData folders for Terr xxx.
# 4/10/22.	wmk.
#	Usage. bash MakeTerrData.sh terrid
#		terrid  - territory id
#
#	Results.
#		Folders Terrxxx and Terrxxx/Working-Files created if do not exist
#			on path ~/Territories
#
# Dependencies.
# selected folder(s)
# files/tables used
# assumptions
#
# Modification History.
# ---------------------
# 4/10/22.	wmk.	<state> <county> <congno> support; HOME replaced with USER
#			 in host check; *pathbase* env var support; jumpto function removed.
# Legacy mods
# 12/19/20.	wmk.	original shell
# 3/9/21.	wmk.	mod for make compatibility.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/17/21.	wmk.	bug fixes; ($)folderbase not substituted within ';
#					changed from cd to test in directory conditional;
#					multihost code generalized.
# 8/27/21.	wmk.	test -d used instead of cd; superfluous "s removed.
if [ -z "$folderbase" ];then
if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
P1=$1
P2=${2^^}
P3=${3^^}
P4=$4
if [ -z "$system_log" ]; then
 system_log="$folderbase/ubuntu/SystemLog.txt"
fi
TEMP_PATH="$HOME/temp"
if [ -z "$P1" ]; then
  ~/sysprocs/LOGMSG "  GenTerrHdr -Territory id not specified... abandoned."
  echo -e "Territory id must be specified...\nGenTerrHdr abandoned."
  exit 1
fi
if [ ! -z "$P2" ];then
 if [ -z "$P3" ] || [ -z "$P4" ];then
  echo "GenTerrHdr <terrid> <state> <county> <congno> missing paramter(s) - abandoned."
  exit 1
 fi
 if [ "$pathbase" != "$folderbase/Territories/$P2/$P3/$P4" ];then
  echo $pathbase
  echo -e "GenTerrHdr *pathbase* does not match $folderbase/Territories/$P2/$P3/$P4\n
    - abandoned."
  exit 1
 fi
fi
~/sysprocs/LOGMSG "  GenTerrHdr started."
echo "  GenTerrHdr started."
#
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
 cd $folderbase/Territories/Procs-Dev
fi
TEMP_PATH=$HOME/temp
if [ -z "$P1" ]; then
  ~/sysprocs/LOGMSG "  MakeTerrData.. -terrid not specified - abandoned."
  echo "  MakeTerrData.. must specify -terrid."
  exit 1
fi
if [ ! -z "$P2" ];then
 if [ -z "$P3" ] || [ -z "$P4" ];then
  echo "MakeTerrData <terrid> <state> <county> <congno> missing paramter(s) - abandoned."
  exit 1
 fi
 if [ "$pathbase" != "$folderbase/Territories/$P2/$P3/$P4" ];then
  echo $pathbase
  echo -e "MakeTerrData *pathbase* does not match $folderbase/Territories/$P2/$P3/$P4\n
    - abandoned."
  exit 1
 fi
  ~/sysprocs/LOGMSG "  MakeTerrData $P1 $P2 $P3 $P4 - initiated from Terminal"
  echo "  MakeTerrData $P1 $P2 $P3 $P4 - initiated from Terminal"
else
  ~/sysprocs/LOGMSG "  MakeTerrData $P1 - initiated from Terminal"
  echo "  MakeTerrData $P1 - initiated from Terminal"
fi 
TID=$P1
#proc body here
pushd ./ >>junk.txt
cd $pathbase/TerrData
TERR_BASE=Terr$TID
TERR_WORK=Working-Files 

# verify both paths exist
if  test -d ./$TERR_BASE  ; then
 echo "./$TERR_BASE already exists.. skipped"
else
 mkdir $TERR_BASE
 echo "./$TERR_BASE created"
fi
cd ./$TERR_BASE # 

if test -d $pathbase/TerrData/$TERR_BASE/Working-Files;then
#cd $pathbase/TerrData/$TERR_BASE/Working-Files || return
#if [ $? = 0 ]; then
 echo "./$TERR_BASE/$TERR_WORK already exists.. skipped"
else
 mkdir ./$TERR_WORK
 echo "$TERR_BASE/$TERR_WORK created"
fi

if test -f junk.txt;then
 rm junk.txt
fi
#end proc body
if [ $USER != "vncwmk3" ];then
 notify-send "MakeTerrData" "complete."
fi
~/sysprocs/LOGMSG "   MakeTerrData $TID $P2 $P3 $P4 complete."
echo "  MakeTerrData $TID $P2 $P3 $P4 complete."
#end MakeTerrData.sh 
