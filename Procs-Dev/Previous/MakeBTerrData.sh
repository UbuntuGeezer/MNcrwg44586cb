#/bin/bash
# MakeBTerrData.sh -  (Dev) Make TerrData folders for Terr xxx.
# 5/11/22.	wmk.
#	Usage. bash MakeBTerrData.sh terrid
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
# 5/11/22.	wmk.	*pathbase* support.
# 8/12/22.	wmk.	change to use /TerrData in place of BRawData.
# Legacy mods.
# 9/24/21.	wmk.	original shell; adapted from MakeBTerrData.sh; jumpto
#					function eliminated.
# 9/25/21.	wmk.	bug fix TerrData path changed to BTerrData.
if [ -f "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
#
P1=$1
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
 cd $pathbase/Procs-Dev
fi
TEMP_PATH=$HOME/temp
if [ -z "$P1" ]; then
  echo "  MakeBTerrData.. must specify -terrid."
  exit 1
else
  ~/sysprocs/LOGMSG "  MakeBTerrData $P1 - initiated from Terminal"
  echo "  MakeBTerrData $P1 - initiated from Terminal"
fi 
TID=$P1
#proc body here
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
if test -d $pathbase/BTerrData/$TERR_BASE/Working-Files;then
#cd $pathbase/TerrData/$TERR_BASE/Working-Files || return
#if [ $? = 0 ]; then
 echo "./$TERR_BASE/$TERR_WORK already exists.. skipped"
else
 mkdir ./$TERR_WORK
 echo "$TERR_BASE/$TERR_WORK created"
fi

#end proc body
~/sysprocs/LOGMSG "   MakeBTerrData $TID complete."
echo "  MakeBTerrData $TID complete."
#end MakeBTerrData.sh 
