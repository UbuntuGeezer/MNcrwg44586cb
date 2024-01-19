#!/bin/bash
#GetUseDesc.sh - Get property use and description for parcel
#	5/27/22.	wmk.
#
# bash GetUseDesc parcel target-file
#
#	parcel = SCPA account #
#
#	Entry Dependencies.
#-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory
#-- *		NVenAll - SCPA property records
#-- *	AuxSCPAData - as db8, auxiliary data for SCPA records
#-- *		PropertyUse - table of property use codes and descriptions
#-- *	user must pass in parcel # 
#   
#
#	Exit Results.
#		1 row output to stdout or target file
#
# Modification History.
# ---------------------
# 5/27/22.	wmk.	*pathbase* support.
# Legacy mods.
# 12/3/20.	wmk.	original shell.
# 6/17/21.	wmk.	multihost support added; LOGMSG used.
#
#	Notes.

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
~/sysprocs/LOGMSG "  GetUseDesc (Dev) started."
if [ -z $1 ]; then
  echo "  Parcel id not specified... GetUseDesc abandoned." >> $system_log #
  echo -e "Parclel id must be specified...\nGetUseDesc abandoned."
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
if [ -z "$system_log" ]; then
 system_log="$folderbase/ubuntu/SystemLog.txt"
fi
TEMP_PATH=$HOME/temp
PID=$1
QOUT=$2
if [ true ]; then
TST_STR="(test)"
else
TST_STR=""
fi

touch $TEMP_PATH/scratchfile
error_counter=0
# db8 - AuxSCPAData.db
echo "-- SQLTemp.sql - GetUseDesc - Get parcel property use description." > SQLTemp.sql
if [ -z "$QOUT" ]; then
 touch nothing
 rm nothing
else
 echo ".output $QOUT " >> SQLTemp.sql
fi
echo ".cd ""$pathbase""" >> SQLTemp.sql
echo ".cd './DB-Dev' " >> SQLTemp.sql
echo "ATTACH 'AuxSCPAData.db' AS db8;" >> SQLTemp.sql
#-- *db2 - VeniceNTerritory.db
echo "ATTACH 'VeniceNTerritory.db'  AS db2;" >> SQLTemp.sql
#-- use parcel to query NVenAll with AuxSCPA information
echo "WITH a AS (SELECT CODE, DESCRIPTION " >> SQLTemp.sql
echo "FROM PROPERTYUSE)" >> SQLTemp.sql
echo "SELECT \"ACCOUNT #\" AS Acct, " >> SQLTemp.sql
echo "\"SITUS ADDRESS (PROPERTY ADDRESS)\" AS Situs," >> SQLTemp.sql
echo "\"Property Use Code\" AS PropUse," >> SQLTemp.sql
echo "a.DESCRIPTION AS Desc " >> SQLTemp.sql
echo "FROM NVENALL" >> SQLTemp.sql
echo "INNER JOIN a " >> SQLTemp.sql
echo " ON PropUse = a.code " >> SQLTemp.sql
echo "WHERE Acct IS \"$PID\";" >> SQLTemp.sql
jumpto FinishSQL
FinishSQL:
echo ".quit" >> SQLTemp.sql
#
notify-send "GetUseDesc" "SQLTemp created."
if [ true ]; then
  jumpto TrySQL
fi
if [ true ]; then
  jumpto TestEnd
fi
jumpto TrySQL
TrySQL:
sqlite3 < SQLTemp.sql
jumpto TestEnd
TestEnd:
date +%T >> $system_log #
echo "  GetUseDesc (Dev) $TST_STR complete." >> $system_log #
echo "  GetUseDesc (Dev) $TST_STR complete."
