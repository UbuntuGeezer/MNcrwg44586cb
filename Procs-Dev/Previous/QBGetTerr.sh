#/bin/bash
# QBGetTerr.sh -  (Dev) Get business territory records.
#	5/11/22.	wmk.
#	Usage. bash QBGetTerr.sh terrid
#		terrid  - territory id to get records for
#
#	QTerr<terrid>.csv generated in ../TerrData/ folder.
#	SQLTemp.sql in ../Procs contains generated SQL.
#
# Dependencies.
# ../Territories/BTerrData/terrid/Working-Files folder exists
# uses ../Terrxxx_RU.db
#
# Modification History.
# ---------------------
# 5/11/22.	wmk.	*pathbase* support.
# Legacy mods.
# 9/28/21.	wmk.	original shell; adpated from QGetTerr.sh.
# 9/29/21.	wmk.	changed query ORDER BY to sort addresses properly.
# Legacy mods.
# 11/16/20.	wmk.	original shell
# 11/22/20.	wmk.	bug fix, .headers ON directive added to SQLTemp.sql,
#					CASE selection ALIASed to "H" for homestead
# 11/23/20. wmk.	revised with interim sorting query
# 11/25/20.	wmk.	added code to delete dups from end query; cleaned up
#					code to consistently use TBL_NAME1 env variable
# 11/28/20.	wmk.	.headers ON directive added just prior to .csv output
#					ending message corrected to use TID env variable
# 2/4/21.	wmk.	AND NOT DELPENDING IS 1 clause added to SELECTs
# 2/5/21.	wmk.	added HelluvaSort table to improve record order
# 2/8/21.	wmk.	bug fix where unitaddress contains 4-digit number
#					causing sort problems.
# 2/11/21.	wmk.	mod to use new LOGMSG to issue system log messages.
# 2/13/21.	wmk.	mod to support up to 5 digit bldg address.
# 2/19/21.	wmk.	mod to only * SC homestead record (unit uppercase)
# 3/8/21.	wmk.	adapted to run from "make".
# 4/7/21.	wmk.	mod to skip sorting and .csv generation; just get
#					territory records to QTerrxxx.db
# 4/8/21.	wmk.	bug fix where house number less than 3 digits splitting
#					street name portion of UnitAddress and direction field
#					getting messed up.
# 4/29/21.	wmk.	add code to delete duplicate DONOTCALL entries to tidy
#					up territory.
# 5/27/21.	wmk		modified for use with either home or Kay's system;
#				    folderbase vars added.
# 5/30/21.	wmk.	modified for multihost system support.
# 6/7/21.	wmk.	bug fixes; equality check ($)HOME, TEMP_PATH 
#					ensured set.
# 6/17/21.	wmk.	multihost code generalized.
# 6/18/21.	wmk.	bug fix?; jump around SELECT * corrected at comment
#					"Generate TBL-NAME.csv", then corrected back...
# 7/20/21.	wmk.	superfluous #s removed; bug fix in eliminate dups
#					code (inactive).
# 8/30/21.	wmk.	SQL modified eliminating .shell rm directive; remove
#					.csv file conditional added before sqlite call.
#
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$HOME/temp
#
TID=$1
P1=$1
if [ -z "$TID" ]; then
  TERR_MSG="  QBGetTerr.. Territory id not specified - abandoned."
#  echo "  QBGetTerr.. Territory id not specified - abandoned." >> $system_log #
  ~/sysprocs/LOGMSG "$TERR_MSG"
  echo "  QBGetTerr.. must specify territory."
  exit 1
else
  TERR_MSG="  QBGetTerr $TID - initiated from Terminal"
#  echo "  QBGetTerr $TID - initiated from Terminal" >> $system_log #
  ~/sysprocs/LOGMSG "$TERR_MSG"
  echo "  QBGetTerr $TID - initiated from Terminal"
fi 
#procbodyhere
TID=$1
if [ 1 -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
NAME_PRFX="QTerr$TID"
RU_NAME=Terr$TID
RU_SUFX=_RU.db
BR_SUFX=_RUBridge
DB_END=.db
CSV_END=.csv
DB_NAME=$NAME_PRFX$DB_END
CSV_NAME=$NAME_PRFX$CSV_END
TBL_NAME1=$NAME_PRFX
TBL_NAME2=$RU_NAME$BR_SUFX
#echo $DB_NAME
echo "-- * QBGetTerr query as batch run." > SQLTemp.sql
echo ".cd ""$pathbase""" >> SQLTemp.sql
echo ".cd './BTerrData/Terr$TID/Working-Files'" >> SQLTemp.sql
#echo ".trace 'Procs-Dev/SQLTrace.txt'" >> SQLTemp.sql
#-- insert new code here...
# ATTACH Terrxxx_RU.db;
echo "ATTACH '$pathbase/BRawData/RefUSA/RefUSA-Downloads'" >> SQLTemp.sql
echo "||		'/Terr$TID/$RU_NAME$RU_SUFX'" >> SQLTemp.sql
echo " AS db12;" >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".mode csv" >> SQLTemp.sql
echo ".separator ," >> SQLTemp.sql
echo ".output '$pathbase/BTerrData/Terr$TID/Working-Files/$TBL_NAME1.csv'" >> SQLTemp.sql
echo "SELECT * FROM $RU_NAME$BR_SUFX" >> SQLTemp.sql
echo "ORDER BY TRIM(SUBSTR(UnitAddress,INSTR(UnitAddress,' ')))," >> SQLTemp.sql
echo "  CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')-1) AS INTEGER);" >> SQLTemp.sql
#echo " ORDER BY UnitAddress;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
#endprocbody
if test -f $pathbase/BTerrData/Terr$TID/Working-Files/$TBL_NAME1.csv;then \
 rm $pathbase/BTerrData/Terr$TID/Working-Files/$TBL_NAME1.csv;fi
sqlite3 < SQLTemp.sql
if [ $? == 0 ]; then
 TERR_MSG="  QBGetTerr $TID complete."
 notify-send "QBGetTerr" "QTerr$TID.csv generated."
else 
 TERR_MSG="  QBGetTerr failed - check SQLTemp.sql."
 notify-send "QBGetTerr" "QTerr$TID.csv generation FAILED."
fi
jumpto EndProc
EndProc:
echo "$TERR_MSG"
bash ~/sysprocs/LOGMSG "$TERR_MSG"
#end QBGetTerr.sh 
