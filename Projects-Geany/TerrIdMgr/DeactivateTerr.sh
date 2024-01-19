#!/bin/bash
# DeactivateTerr.sh - Deactivate territory records in Terrxxx_SCBridge, Terrxxx_RUBridge.
# 6/4/23.	wmk.
#
# Usage. bash  DeactivateTerr.sh  <terrid>
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
# 6/4/23.	wmk.	original shell (template)
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
 echo "DeactivateTerr <terrid> missing parameter(s) - abandoned."
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
  echo "  DeactivateTerr - initiated from Make"
else
  ~/sysprocs/LOGMSG "  DeactivateCheck - initiated from Terminal"
  echo "  DeactivateTerr - initiated from Terminal"
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
pushd ./ > /dev/null
cd $projpath
if test -f $projpath/processed.lst;then rm $projpath/processed.lst;fi
# Deactivate the TerrID in TerrIDData (DeactivateTerriD)
$projpath/DoSedDeactive.sh $P1
make --silent -f $projpath/MakeDeactivateTerrID
echo "TerrIDData.Territory  $P1 deactivated." > $projpath/processed.lst
# Deactivate the territory in the Master dbs (DeactivateMasterTerr).
make --silent -f $projpath/MakeDeactivateMasterTerr
echo "PolyTerri.db, MultiMail.db territory $P1 deactivated." > $projpath/processed.lst
# Deactivate the territory in the RU and SC/Terrxxx folders (inline).
rusuffx=_RU.db
rutable=_RUBridge
scsuffx=_SC.db
sctable=_SCBridge
 # set DelPending in all SCBridge records.
 if test -s $pathbase/$scpath/Terr$P1$scsuffx;then
 echo ".open '$pathbase/$scpath/Terr$P1$scsuffx'" > sqtemp.sql
 echo "PRAGMA table_info(Terr$P1$sctable);" >> sqtemp.sql
 sqlite3 < sqtemp.sql > $TEMP_PATH/sqoutput.txt
  if test -s $TEMP_PATH/sqoutput.txt;then
   echo "SC $Terr$P1 deactivated..." >> $projpath/processed.lst
   sed "s?yyy?$P1?g" $projpath/DeactivateTerr1.psq > $projpath/DeactivateTerr1.sql
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
 sqlite3 < sqtemp.sql > $TEMP_PATH/sqoutput.txt
  if test -s $TEMP_PATH/sqoutput.txt;then
   echo "RU $Terr$P1 deactivated..." >> $projpath/processed.lst
   sed "s?yyy?$P1?g" $projpath/DeactivateTerr2.psq > $projpath/DeactivateTerr2.sql
   pushd ./ > /dev/null
   cd $altproj;./DoSed.sh $projpath DeactivateTerr2
   make --silent -f $altproj/MakeAnySQLtoSH
   $projpath/DeactivateTerr2.sh
   popd > /dev/null
  fi; # Spec_RUBridge exists
 fi  # -s *specdb (nonzero -length file)
popd > /dev/null
cat $projpath/processed.lst
#endprocbody
echo "  DeactivateTerr complete."
~/sysprocs/LOGMSG "  DeactivateTerr complete."
echo " (Use ArchvTerr.sh $P1 to archive territory files...)"
# end DeactivateTerr.sh
