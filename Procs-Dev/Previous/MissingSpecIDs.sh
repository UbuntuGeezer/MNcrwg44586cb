#!/bin/bash
#MissingSpecIDs.sh - Generic post-processor extract Special RU records with missing IDs.
# 6/3/22.	wmk.
#	Usage. bash MissingSpecIDs.sh <special-db>
#		<special-db> - RU/Special/<specia-db> to search
#
# Exit.	/Special/MissingSpecIDs.csv = missing IDs records for this special db.
#
# Dependencies.
#
# Modification History.
# ---------------------
# 6/3/2022.	wmk.	original shell; adapted from MissingIDs.sh
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
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
TEMP_PATH=$HOME/temp
#
P1=$1
TID=$P1
F_BASE="Terr"
DB_SUFFX=".db"
TBL_SUFFX="_RUBridge"
FOLDER=Special
F_NAME=$P1$DB_SUFFX
T_NAME=Spec$TBL_SUFFX
local_debug=0	# set to 1 for debugging
#local_debug=1

if [ $local_debug = 1 ]; then
 echo "   processing $F_NAME "
 echo "    table $T_NAME "
fi

# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  TEMP_PATH="/$HOME/temp"
  bash ~/sysprocs/LOGMSG "   MissingSpecIDs initiated from Make."
  echo "   MissingSpecIDs initiated."
else
  bash ~/sysprocs/LOGMSG "   MissingSpecIDs initiated from Terminal."
  echo "   MissingSpecIDs initiated."
fi
#
if [ -z "$P1" ]; then
  echo "  MissingSpecIDs ignored.. must specify <terrid>." >> $system_log #
  echo "  MissingSpecIDs ignored.. must specify <terrid>."
  exit 1
fi
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi

#proc body here
echo "--MissingSpecIDs.sql - Log territory RU missing parcels IDs to .csv." > SQLTemp.sql
echo "--	3/11/21.	wmk." >> SQLTemp.sql
echo "--" >> SQLTemp.sql
echo "-- * subquery list." >> SQLTemp.sql
echo "-- * --------------" >> SQLTemp.sql
echo "-- *;" >> SQLTemp.sql
echo "-- ** MissingSpecIDs **********" >> SQLTemp.sql
echo "-- *	3/12/21.	wmk." >> SQLTemp.sql
echo "-- *--------------------------" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * MissingSpecIDs - Log territory RU missing parcels IDs to .csv." >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Entry DB and table dependencies." >> SQLTemp.sql
echo "-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon" >> SQLTemp.sql
echo "-- *		Terrxxx_RUBridge - Bridge records from latest RU download " >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Exit DB and table results." >> SQLTemp.sql
echo "-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon" >> SQLTemp.sql
echo "-- *		Terrxxx_RUBridge - query exports any records with OwningParcel" >> SQLTemp.sql
echo "-- *		  unset (= \"-\") to MissingSpecIDs.csv" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Notes." >> SQLTemp.sql
echo "-- *;" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo ".cd '$pathbase/RawData'" >> SQLTemp.sql
echo ".cd './RefUSA/RefUSA-Downloads/$FOLDER'" >> SQLTemp.sql
echo ".open '$F_NAME'" >> SQLTemp.sql
echo ".headers ON" >> SQLTemp.sql
echo ".output 'MissingSpecIDs.csv'" >> SQLTemp.sql
echo "SELECT * FROM $T_NAME " >> SQLTemp.sql
echo "WHERE OwningParcel IS \"-\" " >> SQLTemp.sql 
echo " AND DelPending IS NOT 1;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- ** END MissingSpecIDs **********;" >> SQLTemp.sql
#end proc body

if [ $local_debug = 1 ]; then
  popd
  jumpto EndProc
fi

jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql

jumpto EndProc
EndProc:
notify-send "MissingSpecIDs" "$TID complete."
bash ~/sysprocs/LOGMSG "  MissingSpecIDs $TID complete."
echo "  MissingSpecIDs $TID complete."
#end MissingSpecIDs
