#!/bin/bash
echo " ** ValidateAllSpecDB.sh out-of-date **";exit 1
echo " ** ValidateAllSpecDB.sh out-of-date **";exit 1
# ValidateAllSpecDB.sh - Set all SC/Special databases RecordDate fields to .csv date.
# 2/27/23.	wmk.
#
# Usage. bash  ValidateAllSpecDB.sh  [< special-db >]
#
#	< special-db > = (optional) single special db to run ValidateAllSpecDB on.
#
# Entry. SCPA-Downloads/Special/< special -db >.dbs are SC special downloads.
#		 < special-db >.db.TerrList is territory list and counts table.
#
# Exit.	< special-db >.db.TerrList tables rebuilt.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 2/27/23.	wmk.	original shell; adapted from RefreshAllSCTerrIDs.
#
# Notes. 
#
# set parameters P1..Pn here..
#
P1=$1
doall=1
if [ ! -z "$P1" ];then
 doall=0
 if [[ "$P1" =~ /.*\.db/ ]];then
  dbname=$P1
 else
  dbname=$P1.db
 fi
fi # nonempty P1
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  folderbase=/media/ubuntu/Windows/Users/Bill
 else
  folderbase=$HOME
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
  ~/sysprocs/LOGMSG "  ValidateAllSpecDB - initiated from Make"
  echo "  ValidateAllSpecDB - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ValidateAllSpecDB - initiated from Terminal"
  echo "  ValidateAllSpecDB - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
#procbodyhere
projpath=$codebase/Projects-Geany/SyncAllData
export csvdate=dummy
pushd ./ > $TEMP_PATH/scratchfile
cd $pathbase/$scpath/Special
if [ $doall -eq 0 ];then
 $projpath/ValidateSpecDB.sh $P1
else
 ls *.db > $TEMP_PATH/SpecDBList.txt
 nbad=0
 if test -f $projpath/RUSpecbadList.txt;then rm $projpath/RUSpecbadList.txt;fi 
 file=$TEMP_PATH/SpecDBList.txt
 cd $projpath
 while read -e;do
  len=${#REPLY}
  len3=$((len-3))
  nextname=${REPLY:0:$len3}
  . $projpath/ValidateSpecDB.sh $nextname
  if [ $dbokay -ne 1 ];then
   echo "$nextname.db RecordDate,s mismatched with .csv file date" \
    >> $projpath/RUSpecbadList.txt
   nbad=$((nbad+1))
  fi 
 done < $file
 if [ $nbad -gt 0 ];then
  echo " $nbad /Special databases have mismatched RecordDate,s..."
  echo " cat RUSpecbadList.txt for list of names."
 fi
fi	# end doall
popd > $TEMP_PATH/scratchfile
#endprocbody
echo "  ValidateAllSpecDB complete."
~/sysprocs/LOGMSG "  ValidateAllSpecDB complete."
# end ValidateAllSpecDB.sh
