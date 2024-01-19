#!/bin/bash
echo " ** SetRUDNCs.sh out-of-date **";exit 1
# SetRUDNCs.sh - Set DNCs in RUBRidge records.
#	7/2/23.	wmk.
# Usage. bash SetRUDNCs.sh   <terrid>
#
#	<terrid> = territory for which to tidy up _RUBridge records
#
#	Entry Dependencies.
#-- *	Terr<terrid>_RU.db - as db12, new territory records from RefUSA polygon
#-- *		Terr<terrid>_RUBridge - sorted Bridge formatted records extracted 
#-- *			from RefUSA polygon (see Terr<terrid>_RURaw)
#
#	Exit Results.
#-- *	Terr<terrid>_RU.db - as db12, new territory records from RefUSA polygon
#-- *		Terr<terrid>_RUBridge - Bridge records with the following fields
#-- *			updated: OwningParcel, Situs, PropUse, RecordType
#		Spits out a query at the end for any records where the
#		OwningParcel was not set, hence incomplete data
#
# Modification History.
# ---------------------
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 10/4/22.	wmk.	comments updated.
# 7/2/23.	wmk.	[ not = true ] changed to [ 1 -eq-0 ];
# Legacy mods.
# 4/24/22.	wmk.	*pathbase* env var incorporated.
# 5/11/22.	wmk.	VeniceNTerritory.db changed to Terr86777.db
# Legacy mods.
#	4/29/21.	wmk.	original shell; adapted from RUTidy11.sh
# 	5/27/21.	wmk.	modified for use with Kay's system; environment checked
#						and used for correct Territory folder paths.
# 	5/30/21.	wmk.	modified for multihost system support.
#	6/6/21.		wmk.	bug fixes; equality check ($)HOME, TEMP_PATH
#						ensures set.
#	Notes. The Terr<terrid>_RUBridge table contains the initial data
#	skeleton from the RefUSA import. This utility tidies up the OwningParcel,
#	Situs, PropertyUse, and RecordType fields to facilitate integrating
#	the new data into the existing TerrProps and MultiMail databases.
#	Queries herein are "shell" versions of the following queries from 
#	the CreateNewRUTerr.sql utility subqueries {SetOwningParcels,
#	SetSitusPropUse, SetDoNotCalls, SetRecTypes, SetXcptOwningParcels}
# jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
P1=$1
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
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  ~/sysprocs/LOGMSG "  SetRUDNCs - initiated from Make"
else
  ~/sysprocs/LOGMSG "  SetRUDNCs - initiated from Terminal"
  echo "  SetRUDNCs - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
if [ -z "$P1$" ]; then
  echo "  Territory id not specified... RUTidyTerr_db abandoned." >> $system_log #
  echo -e "Territory id must be specified...\nRUTidyTerr_db abandoned."
  exit 1
fi
TID=$P1
TN="Terr"
if [ true ]; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
#end RUTidyTerr1.sh
#begin RUTidyTerr2.sh
DB_END="_RU.db"
TBL_END1="_RUBridge"
TBL_END2=""
TBL_END3=""
NM_PRFX="Terr"
DB_NAME="$NM_PRFX$TID$DB_END"
TBL_NAME1="$NM_PRFX$TID$TBL_END1"
TBL_NAME2="$NM_PRFX$TID$TBL_END2"
TBL_NAME3="$NM_PRFX$TID$TBL_END3"
#procbodyhere
echo ".shell echo \"Opening ./$TN$TID/$DB_NAME\" | awk '{print \$1}' > SQLTrace.txt" >> SQLTemp.sql
echo "--#.shell sed -i '1s/^/-- SQLTrace initialization/' SQLTrace.txt" >> SQLTemp.sql
echo "--#.shell sed -i -e '$aOpening ./$TN$TID/$DB_NAMEn' SQLTrace.txt" >> SQLTemp.sql
echo ".open $DB_NAME " >> SQLTemp.sql
echo ".shell echo \"SetOwningParcels - Set OwningParcel fields in $TBL_NAME1.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo "||		'/DB-Dev/Terr86777.db' " >> SQLTemp.sql
echo "AS db2;" >> SQLTemp.sql
echo "-- * SetOwningParcels - Set OwningParcel fields in $TBL_NAME1." >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/DB-Dev/AuxSCPAData.db'" >> SQLTemp.sql
echo "  AS db8;" >> SQLTemp.sql
echo ".shell echo \"* SetDoNotCalls - Flag DoNotCalls in Bridge tables.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "-- * SetDoNotCalls - Flag DoNotCalls in Bridge tables." >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/DB-Dev/TerrIDData.db'" >> SQLTemp.sql
echo " AS db4;" >> SQLTemp.sql
echo "WITH a AS (SELECT PropID, Unit, RSO, \"Foreign\"" >> SQLTemp.sql
echo "  FROM DoNotCalls" >> SQLTemp.sql
echo "	WHERE TerrID IS \"$TID\")" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1" >> SQLTemp.sql
echo "SET DoNotCall = " >> SQLTemp.sql
echo "	CASE " >> SQLTemp.sql
echo "	WHEN OwningParcel" >> SQLTemp.sql
echo "	 IN (SELECT PropID FROM a)" >> SQLTemp.sql
echo "   AND Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
echo "       WHERE PropID IS OwningParcel)" >> SQLTemp.sql
echo "	THEN 1" >> SQLTemp.sql
echo "	ELSE DoNotCall" >> SQLTemp.sql
echo "	END," >> SQLTemp.sql
echo "RSO =" >> SQLTemp.sql
echo "	CASE " >> SQLTemp.sql
echo "	WHEN OwningParcel" >> SQLTemp.sql
echo "	 IN (SELECT PropID FROM a)" >> SQLTemp.sql
echo "   AND Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
echo "       WHERE PropID IS OwningParcel)" >> SQLTemp.sql
echo "	THEN " >> SQLTemp.sql
echo "	  (SELECT RSO FROM a " >> SQLTemp.sql
echo "		WHERE PROPID IS OwningParcel)" >> SQLTemp.sql
echo "	ELSE RSO" >> SQLTemp.sql
echo "	END," >> SQLTemp.sql
echo "\"Foreign\" = " >> SQLTemp.sql
echo "	CASE " >> SQLTemp.sql
echo "	WHEN OwningParcel" >> SQLTemp.sql
echo "	 IN (SELECT PropID FROM a)" >> SQLTemp.sql
echo "   AND Unit IN (SELECT Unit FROM a " >> SQLTemp.sql
echo "       WHERE PropID IS OwningParcel)" >> SQLTemp.sql
echo "	THEN " >> SQLTemp.sql
echo "	  (SELECT \"FOREIGN\" FROM a " >> SQLTemp.sql
echo "		WHERE PROPID IS OwningParcel)" >> SQLTemp.sql
echo "	ELSE \"Foreign"\" >> SQLTemp.sql
echo "	END" >> SQLTemp.sql
echo "WHERE OwningParcel IN (SELECT PropID FROM a);" >> SQLTemp.sql
#-- ** END SetDoNotCalls **********;
echo "-- * Add missing DNCs;"  >> SQLTemp.sql
echo "WITH a AS (SELECT PropID,UnitAddress, Unit,"  >> SQLTemp.sql
echo "Name, Phone, \"Foreign\" as FL,"  >> SQLTemp.sql
echo " RSO AS SCSO, RecDate FROM DoNotCalls "  >> SQLTemp.sql
echo " WHERE TerrID IS \"$TID\")"  >> SQLTemp.sql
echo "INSERT OR IGNORE INTO $TBL_NAME1"  >> SQLTemp.sql
echo "SELECT PropID, UnitAddress, Unit,"  >> SQLTemp.sql
echo " Name, Phone, \"\", \"\", \"\", \"$TID\", 1,"  >> SQLTemp.sql
echo " SCSO, \"Foreign\", RecDate, UPPER(UnitAddress),"  >> SQLTemp.sql
echo " \"\", \"\", \"M\" FROM a"  >> SQLTemp.sql
echo "WHERE PropID NOT IN (SELECT OwningParcel"  >> SQLTemp.sql
echo " FROM $TBL_NAME1"  >> SQLTemp.sql
echo " WHERE Unit IS a.Unit);"  >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo "-- ** END UpdateDNCS **********;" >> SQLTemp.sql
#endprocbody
# conditional to skip SQL execution.
if [ 1 -eq 0 ]; then
 jumpto EndProc
fi
jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql
jumpto EndProc
EndProc:
#popd >> $TEMP_PATH/bitbucket.txt
#end proc
bash ~/sysprocs/LOGMSG "   SetRUDNCs complete."
echo "   SetRUDNCs complete."
#end SetRUDNCs.sh
