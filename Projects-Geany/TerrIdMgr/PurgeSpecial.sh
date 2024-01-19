#!/bin/bash
# PurgeSpecial.sh - <description>.
# 2/2/23.	wmk.
#
# Usage. bash  PurgeSpecial.sh  <terrid>
#
#	<terrid> = territory ID for which to purge special records.
#
# Entry. 
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/2/23.	wmk.	original shell (template)
#
# Notes. PurgeSpecial sets up and invokes Purgatory.sh to purge all territory
# records belonging to territory <terrid> from the PolyTerri and MultiMail.db,s.
# It also obtains a list of all of the /Special databases for both RefUSA and
# SCPA and cycles through them deleting all <terrid> records.
# It then edits the /Special/Make.db.Terr makefiles removing references to
# <terrid> MakeSpecials *make calls. 
#
# set parameters P1=<terrid>
#
P1=$1
if [ -z "$P1" ];then
 echo "PurgeSpecial <terrid> missing parameter(s) - abandoned."
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
  ~/sysprocs/LOGMSG "  PurgeSpecial - initiated from Make"
  echo "  PurgeSpecial - initiated from Make"
else
  ~/sysprocs/LOGMSG "  PurgeSpecial - initiated from Terminal"
  echo "  PurgeSpecial - initiated from Terminal"
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
if test -f $projpath/processed.lst;then rm $projpath/processed.lst;fi
while read -e;do
 specdb=$REPLY
 cnt=$(( cnt+=1 ))
 #if [ $cnt -le 1 ];then
 if test -s $pathbase/$rupath/Special/$specdb;then
 echo ".open '$pathbase/$rupath/Special/$specdb'" > sqtemp.sql
 echo "PRAGMA table_info(Spec_RUBridge);" >> sqtemp.sql
 sqlite3 < sqtemp.sql > sqoutput.txt
  if test -s sqoutput.txt;then
   echo "RU $specdb processed..." >> $projpath/processed.lst
   sed "s?yyy?$P1?;s?vvvvv?$specdb?g" $projpath/PurgeTerrSpec1.psq > $projpath/PurgeTerrSpec1.sql
   #cat $projpath/PurgeSpecial.sql
   pushd ./ > /dev/null
   cd $altproj;./DoSed.sh $projpath PurgeTerrSpec1
   make --silent -f $altproj/MakeAnySQLtoSH
   $projpath/PurgeTerrSpec1.sh
   popd > /dev/null
  fi; # Spec_RUBridge exists
 fi  # -s *specdb (nonzero -length file)
 #fi # cnt <= 1
done < $file
# loop on all SC special db,s.
cd $pathbase/$scpath/Special
ls *.db > $TEMP_PATH/SpecDBList.txt
#cat $TEMP_PATH/SpecDBList.txt
#echo " SC Special db list complete."
file=$TEMP_PATH/SpecDBList.txt
while read -e;do
 specdb=$REPLY
 cnt=$(( cnt+=1 ))
 #if [ $cnt -le 1 ];then
 if test -s $pathbase/$rupath/Special/$specdb;then
 echo ".open '$pathbase/$scpath/Special/$specdb'" > sqtemp.sql
 echo "PRAGMA table_info(Spec_SCBridge);" >> sqtemp.sql
 sqlite3 < sqtemp.sql > sqoutput.txt
  if test -s sqoutput.txt;then
   echo "SC $specdb processed..." >> $projpath/processed.lst
   sed "s?yyy?$P1?;s?vvvvv?$specdb?g" $projpath/PurgeTerrSpec2.psq > $projpath/PurgeTerrSpec2.sql
   #cat $projpath/PurgeSpecial.sql
   pushd ./ > /dev/null
   cd $altproj;./DoSed.sh $projpath PurgeTerrSpec2
   make --silent -f $altproj/MakeAnySQLtoSH
   $projpath/PurgeTerrSpec2.sh
   popd > /dev/null
  fi; # Spec_RUBridge exists
 fi  # -s *specdb (nonzero -length file)
 #fi # cnt <= 1
done < $file
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  PurgeSpecial complete."
~/sysprocs/LOGMSG "  PurgeSpecial complete."
# end PurgeSpecial.sh
