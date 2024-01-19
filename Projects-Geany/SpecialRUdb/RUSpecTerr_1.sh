#!/bin/bash
echo " ** RUSpecTerr_1.sh out-of-date **";exit 1
echo " ** RUSpecTerr_1.sh out-of-date **";exit 1
# RUSpecTerr_db.sh - Process RefUSA new territory download into db.
#	3/1/23.	wmk. (Dev) 20:56
#
# RUSpecTerr_db - run sqlite processing raw download data into db
#	download from .csv (Phase 1) into SQL table TerrProps
#
#	Usage. bash RUSpecTerr_db.sh <spec-name>
#		<spec-name> = special name for territory (e.g. GondolaParkDr)
#		<spec-name>.csv assumed to exist in ~/RefUSA-Downloads/Special folder
#		user assumed to be in RawData/RefUSA/RefUSA-Downloads folder
#
# Exit. <spec-name>.db created in folder /RefUSA-Downloads/Special, if
#		  does not exist; updated with new tables if already exists
#			Spec_RURaw - raw download data from Special/<spec-name>.csv
#			Spec_RUPoly - sorted download data from RURaw
#			Spec_RUBridge - Bridge template records from Spec_RUPoly
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.  wmk.    (automated) fix *pathbase for CB system.
# 3/1/23.	wmk.	modified to preserve date on <special>.csv by editing to
#			 target <spceial>.csv.imp; (RUSpecTerr_db.sql will now import the
#			 .imp file.
# Legacy mods.
# 4/25/22.	wmk.	modified for <state> <county> <congno> support;
#			 *pathbase* support.
# 5/31/22.	wmk.	TEMP_PATH defined; RUSpecTerr_db.log on temp path.
# Legacy mods.
# 4/24/21.	wmk.	original shell (compatible with make); adapted from
#					RUNewTerr_db.sql; mod history below kept while debugging.
# 6/7/21.	wmk.	multihost support added.
# 7/18/21.	wmk.	database base name changed from Terr to Spec.
# 8/17/21.	wmk.	<terrid> parameter eliminated.
#
# Notes. RUSpecTerr_db generates an .sql batch directives
# file, then runs sqlite to import the raw .csv data into table
# Special_Raw. Then a sorting query is run to create a second table
# Special_Poly containing the download records sorted by street
# and number for easy extraction in correct order for territories.
# jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
# check for 262system as special case.
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else
  export folderbase=$HOME
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 pathbase=$folderbase/Territories/FL/SARA/86777
fi
TEMP_PATH=$HOME/temp
P1=$1
P2=$2
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/"SystemLog.txt"
 NO_PROMPT=1
  bash ~/sysprocs/LOGMSG "   RUSpecTerr_db initiated from Make."
  echo "   RUSpecTerr_db initiated."
else
 NO_PROMPT=0
  bash ~/sysprocs/LOGMSG "   RUSpecTerr_db initiated from Terminal."
  echo "   RUSpecTerr_db initiated."
fi
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ]; then
  ~/sysprocs/LOGMSG "  special db name not specified... RUSpecTerr_db abandoned."
  echo -e "special db name must be specified...\nRUSpecTerr_db abandoned."
  exit 1
fi
if [ true ]; then
TST_STR=(test)
else
TST_STR=""
fi
#TID=$1
CSV_BASE=$P1
CSV_SUFFX=.csv
CSV_NAME=$CSV_BASE$CSV_SUFFX
echo "special db source = \"Special/$CSV_NAME\""
DB_END=".db"
DB_RUEND="_RU.db"
TBL_END1="_RURaw"
TBL_END2="_RUPoly"
TBL_END3="_RUBridge"
NAME_PRFX="$CSV_BASE"
MAP_SUFFX="_RU"
CSV_NAME1="$NAME_PRFX.csv"
DB_NAME=$P1$DB_END
TBL_NAME1=Spec$TBL_END1
TBL_NAME2=Spec$TBL_END2
TBL_NAME3=Spec$TBL_END3
echo "DB_NAME = \"$DB_NAME\""  > $TEMP_PATH/RUSpecTerr_db.log
echo "TBL_NAME1 = \"$TBL_NAME1\"" >> $TEMP_PATH/RUSpecTerr_db.log
echo "TBL_NAME2 = \"$TBL_NAME2\"" >> $TEMP_PATH/RUSpecTerr_db.log
echo "TBL_NAME3 = \"$TBL_NAME3\"" >> $TEMP_PATH/RUSpecTerr_db.log
#remove column headings if present.
export csvdate=dummy
. $codebase/Projects-Geany/SyncAllData/SetCSVDate.sh $P1
echo $csvdate
# Note! This resets the .csv filedate to *now...; the original .csv date should
# have been captured in *csvdate BEFORE this...
sed '/Last Name/ d' $pathbase/RawData/RefUSA/RefUSA-Downloads/Special/$CSV_NAME \
 > $pathbase/RawData/RefUSA/RefUSA-Downloads/Special/$CSV_NAME1.imp
#echo -e "! If you did not delete the 'headings' from the .csv file..."
touch $TEMP_PATH/scratchfile
# end RUSpecTerr_1.sh

