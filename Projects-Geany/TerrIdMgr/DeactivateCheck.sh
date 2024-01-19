#!/bin/bash
# DeactivateCheck.sh - <description>.
# 2/2/23.	wmk.
#
# Usage. bash  DeactivateCheck.sh  <terrid>
#
#	<terrid> = territory ID for which to check existence of Terryyy_RUBridge
#	  and Terryyy_SCBridge Records..
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. # runs CheckTerrBridge.sh to check for existence of
# Terryyy_RU.db.Terryyy_RUBridge and Terryyy_SC.db.Terryyy_SCBridge tables.
# Results are stored in $TEMP_PATH/FoundSCBridge.txt and FoundRUBridge.txt. 
# DeactivateCheck sets up 
#
# set parameters P1=<terrid>
#
P1=$1
if [ -z "$P1" ];then
 echo "DeactivateCheck <terrid> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export pathbase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  DeactivateCheck - initiated from Make"
  echo "  DeactivateCheck - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DeactivateCheck - initiated from Terminal"
  echo "  DeactivateCheck - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/TerrIdMgr
altproj=$codebase/Projects-Geany/AnySQLtoSH
pushd ./ > $TEMP_PATH/scratchfile
cd $projpath
./DoSedPurge.sh $P1
# loop on all RU special db,s.
cd $pathbase/$rupath/Special
ls *.db > $TEMP_PATH/SpecDBList.txt
#cat $TEMP_PATH/SpecDBList.txt
#echo " RU Special db list complete."
file=$TEMP_PATH/SpecDBList.txt
cnt=0
rusuffx=_RU.db
rutable=_RUBridge
scsuffx=_SC.db
sctable=_SCBridge
if test -f $projpath/processed.lst;then rm $projpath/processed.lst;fi
 # set DelPending in all SCBridge records.
 if test -s $pathbase/$scpath/Terr$P1$scsuffx;then
 echo ".open '$pathbase/$scpath/Terr$P1$scsuffx'" > sqtemp.sql
 echo "PRAGMA table_info(Terr$P1$sctable);" >> sqtemp.sql
 sqlite3 < sqtemp.sql > sqoutput.txt
  if test -s sqoutput.txt;then
   echo "SC $Terr$P1 processed..." >> $projpath/processed.lst
   sed "s?yyy?$P1?g" $projpath/DeactivateTerr1.psq > $projpath/DeactivateTerr1.sql
   #cat $projpath/DeactivateCheck.sql
   pushd ./ > /dev/null
   cd $altproj;./DoSed.sh $projpath DeactivateTerr1
   make --silent -f $altproj/MakeAnySQLtoSH
   $projpath/DeactivateTerr1.sh
   popd > /dev/null
  fi; # Spec_SCBridge exists
 fi  # -s *specdb (nonzero -length file)
 # set DelPending in all RUBridge records.
 if test -s $pathbase/$rupath/Terr$P1$rusuffx;then
 echo ".open '$pathbase/$rupath/Terr$P1$rusuffx'" > sqtemp.sql
 echo "PRAGMA table_info(Terr$P1$rutable);" >> sqtemp.sql
 sqlite3 < sqtemp.sql > sqoutput.txt
  if test -s sqoutput.txt;then
   echo "RU $Terr$P1 processed..." >> $projpath/processed.lst
   sed "s?yyy?$P1?g" $projpath/DeactivateTerr2.psq > $projpath/DeactivateTerr2.sql
   pushd ./ > /dev/null
   cd $altproj;./DoSed.sh $projpath DeactivateTerr2
   make --silent -f $altproj/MakeAnySQLtoSH
   $projpath/DeactivateTerr2.sh
   popd > /dev/null
  fi; # Spec_RUBridge exists
 fi  # -s *specdb (nonzero -length file)
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  DeactivateCheck complete."
~/sysprocs/LOGMSG "  DeactivateCheck complete."
# end DeactiveateCheck.sh
