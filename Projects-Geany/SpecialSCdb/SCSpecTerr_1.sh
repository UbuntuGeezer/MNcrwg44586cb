#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
# SCSpecTerr_db.hd1 - Preamble for SCSpecTErr_db.sh.
#	6/5/22.	wmk. (Dev)
#
#	Usage. bash SCSpecTerr_db.sh  <spec-name> <mm> <dd> [<terrid>]
#		<spec-name> = special name for territory (e.g. GondolaParkDr)
#		<spec-name>.csv assumed to exist in ~/SCPA-Downloads/Special folder
#		<mm> = month of download csv data extracted from (year 2021)
#		<dd> = day of download csv data extracted from 
#		user assumed to be in RawData/SCPA/SCPA-Downloads folder
#
#		[<terrid>] = (optional) territory ID to preset in all
#			<spec-name> table records
#
# Exit. <spec-name>.db created in folder /SCPA-Downloads/Special
#		  <spec-name> table is raw data from map polygon download
#		  PropTerr table is account#, situsaddress, terrid
#		  TerrList table is territory IDs and counts
#
# Modification History.
# ---------------------
# 6/5/22.	wmk.	name change from SCSpecTerr_1.sh to SCSpecTerr_db.hd1;
#			 for use with HdrsSQLtoSH project *make*.
# Legacy mods.
# 5/30/22.	wmk.	(automated) *pathbase* block added.
# Legacy  mods.
# 7/2/21.	wmk.	original shell (compatible with make); adapted from
#					RUSpecTerr.sh.
# 7/24/21.	wmk.	superfluous "s removed; passed parameters added to
#					log messages for tracking.
# 7/25/21.	wmk.	added <terrid> preset option.
#
# Notes. SCSpecTerr_db generates an .sql batch directives
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
P1=$1
P2=$2
P3=$3
P4=$4
TID=$P4
MM=$P2
DD=$P3
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  TEMP_PATH=$HOME/temp
 NO_PROMPT=1
  bash ~/sysprocs/LOGMSG "   SCSpecTerr_db  $P1  initiated from Make."
  echo "   SCSpecTerr_db  $P1  initiated."
else
 NO_PROMPT=0
  bash ~/sysprocs/LOGMSG "   SCSpecTerr_db initiated from Terminal."
  echo "   SCSpecTerr_db  $P1  initiated."
fi
# pathbase block.
# 5/30/22.
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 if [ ! -z "$congpath" ];then
  export pathbase=$folderbase/Territories
 else
  export pathbase=$folderbase/Territories
 fi
fi
# end pathbase block.
TEMP_PATH=$HOME/temp
#
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ]; then
  ~/sysprocs/LOGMSG "  missing parameter(s)... SCSpecTerr_db abandoned."
  echo -e "<special-db> mm dd must be specified...\nSCSpecTerr_db abandoned."
  exit 1
fi
#TID=$1
CSV_BASE=$P1
CSV_SUFFX=".csv"
CSV_NAME=$CSV_BASE$CSV_SUFFX
echo "special db source = \"Special/$CSV_NAME\""
if [ true ]; then
TST_STR="(test)"
else
TST_STR=""
fi
#remove column headings if present.
sed -i '/Account #/d' $pathbase/RawData/SCPA/SCPA-Downloads/Special/$CSV_NAME
touch $TEMP_PATH/scratchfile
#.trace 'Procs-Dev/SQLTrace.txt'
# .open './DB/PolyTerri.db'
DB_END=".db"
TBL_END1=""
NAME_PRFX="$CSV_BASE"
MAP_SUFFX="_SC"
CSV_NAME1="$NAME_PRFX.csv"
DB_NAME="$P1$DB_END"
TBL_NAME1=$CSV_BASE
TBL_NAME2=PropTerr
TBL_NAME3=Spec_SCBridge
echo "DB_NAME = \"$DB_NAME\""
echo "TBL_NAME1 = \"$TBL_NAME1\""
echo "TBL_NAME2 = \"$TBL_NAME2\""
echo "TBL_NAME3 = \"$TBL_NAME3\""
#procbodyhere.
