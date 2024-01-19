#!/bin/bash
# SCPropTerrToBridge.sh - Generate Terrxxx_SC.db/Terrxxx_SCBridge from PropTerr table.
# 6/5/23.	wmk.
#
#	Usage. bash SCPropTerrToBridge <terrid> <special-db>
#		<terrid> - territory id for which to build bridge records
#		<special-db> - base name of special SC db with PropTerr table
#
# Dependencies.
#	PropTerr table contains records with PropID, StreetAddr, and TerrID
#	  that are the information for a special territory (like phone/letter)
#	<special-db>.db is a special download database generated from a
#	  (most likely) quirky extraction of SC download data either from
#	  a polygon or from the SC full download database.
#
#
#	Exit. <special-db>.SC_Bridge table is a bridge table exactly compatible
#			with any Terrxxx_SC.db.SC_Bridge table. It is kept separately
#			in this database to avoid merging issues in the event there
#			is also a Terrxxx_SC.db for the territory(ies) affected
#
# Modification History.
# ---------------------
# 6/5/23.	wmk.	*folderbase redefinition updated; comments tidied.
# Legacy mods.
# 9/23/22.  wmk.    (automated) CB *codebase env var support.
# 12/24/22.	wmk.	jumpto references eliminated; *codebase, *pathbase activated;
#			 VeniceNTerritory.db replaced with Terr86777; NVenAll replaced with
#			 Terr86777; TBL_NAME2 changed to Spec_SCBridge.
# Legacy mods.
# 7/2/21.	wmk.	original code (multihost support).
#
# Notes. This query/shell generates a new SCBridge table within the
# <special-db>.db database. The <special-db> may have records belonging
# to several different territories, as the data was most likely extracted
# using an SCPA polygon that traversed territory boundaries. Any FixyyySC.sql
# that references this table must ensure that the TerrID is one of the
# constraints on any query extracting records.
#
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else 
  export folderbase=$HOME
 fi
fi
# pathbase block.
# 5/30/22.
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
  export pathbase=$folderbase/Territories/FL/SARA/86777
fi
# end pathbase block.
if [ -z "$system_log" ]; then
 system_log=$folderbase"/ubuntu/SystemLog.txt"
fi
#
P1=$1
P2=$2
local_debug=0	# set to 1 for debugging
#local_debug=1
#
# handle case where called from Make.
if [ -z "$system_log" ]; then
  system_log="$folderbase/ubuntu/SystemLog.txt"
  TEMP_PATH="$folderbase/temp"
  bash ~/sysprocs/LOGMSG "   SCPropTerrToBridge initiated from Make."
  echo "   SCPropTerrToBridge initiated."
else
  bash ~/sysprocs/LOGMSG "   SCPropTerrToBridge initiated from Terminal."
  echo "   SCPropTerrToBridge initiated."
fi
#
if [ -z "$P1" ]; then
  echo "  SCPropTerrToBridge ignored.. must specify <terrid> <special-db>." >> $system_log #
  echo "  SCPropTerrToBridge ignored.. must specify <terrid> <special-db>."
  exit 1
fi
if [ -z "$P2" ];then
  echo "  SCPropTerrToBridge ignored.. must specify <special-db>." >> $system_log #
  echo "  SCPropTerrToBridge ignored.. must specify <special-db>."
  exit 1
fi
echo "  SCPropTerrToBridge $P1 - initiated from Terminal" >> $system_log #
echo "  SCPropTerrToBridge $P1 - initiated from Terminal"
#
if [ $local_debug = 1 ]; then
 pushd ./
 cd ~/Documents		# write files to Documents folder
fi
TID=$P1	
DB_BASE=$P2
DB_NAME=$P2.db
TBL_NAME1=PropTerr
TBL_NAME2=Spec_SCBridge
#procbodyhere
pushd ./ > $TEMP_PATH/scratchfile
echo "-- PropTerrToBridge - generate SCBridge table in special db." > SQLTemp.sql
echo ".cd '$pathbase/RawData/SCPA/SCPA-Downloads'" >> SQLTemp.sql
echo ".cd './Special'" >> SQLTemp.sql
echo ".open $DB_NAME" >> SQLTemp.sql
echo "ATTACH '$pathbase/DB-Dev/Terr86777.db'" >> SQLTemp.sql
echo " AS db2;" >> SQLTemp.sql
echo "-- now create SCBridge table;" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS $TBL_NAME2;" >> SQLTemp.sql
echo "CREATE TABLE $TBL_NAME2" >> SQLTemp.sql
echo "( OwningParcel TEXT NOT NULL," >> SQLTemp.sql
echo " UnitAddress TEXT NOT NULL," >> SQLTemp.sql
echo " Unit TEXT, Resident1 TEXT, " >> SQLTemp.sql
echo " Phone1 TEXT,  Phone2 TEXT," >> SQLTemp.sql
echo " \"RefUSA-Phone\" TEXT, SubTerritory TEXT," >> SQLTemp.sql
echo " CongTerrID TEXT, DoNotCall INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RSO INTEGER DEFAULT 0, \"Foreign\" INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RecordDate REAL DEFAULT 0," >> SQLTemp.sql
echo " SitusAddress TEXT, PropUse TEXT," >> SQLTemp.sql
echo "  DelPending INTEGER DEFAULT 0," >> SQLTemp.sql
echo " RecordType TEXT);" >> SQLTemp.sql
echo "-- now populate the SCBridge table;" >> SQLTemp.sql
echo "INSERT INTO $TBL_NAME2" >> SQLTemp.sql
echo " ( OwningParcel," >> SQLTemp.sql
echo " UnitAddress," >> SQLTemp.sql
echo " Unit, Resident1, Phone1, Phone2," >> SQLTemp.sql
echo "  \"RefUSA-Phone\", SubTerritory, CongTerrID, DoNotCall," >> SQLTemp.sql
echo "   RSO, \"Foreign\", RecordDate, SitusAddress," >> SQLTemp.sql
echo "    PropUse, DelPending, RecordType )" >> SQLTemp.sql
echo "SELECT \"ACCOUNT #\" AS Acct, " >> SQLTemp.sql
echo " TRIM(SUBSTR(\"SITUS ADDRESS (PROPERTY ADDRESS)\"," >> SQLTemp.sql
echo "   1,35))," >> SQLTemp.sql
echo "   TRIM(SUBSTR(\"SITUS ADDRESS (PROPERTY ADDRESS)\",36)), \"OWNER 1\", \"\"," >> SQLTemp.sql
echo " CASE WHEN \"HOMESTEAD EXEMPTION\" IS \"YES\" THEN \"*\"" >> SQLTemp.sql
echo " ELSE \"\" END, \"\", \"\", \"$TID\", \"\", \"\", \"\", DownloadDate," >> SQLTemp.sql
echo " \"SITUS ADDRESS (PROPERTY ADDRESS)\", \"PROPERTY USE CODE\"," >> SQLTemp.sql
echo " \"\",\"\" FROM Terr86777 " >> SQLTemp.sql
echo "WHERE Acct IN (SELECT \"Account #\" FROM $TBL_NAME1);" >> SQLTemp.sql
#echo "     WHERE TerrID IS \"$TID\");" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
#
popd > $TEMP_PATH/scratchfile
#endprocbody
sqlite3 < SQLTemp.sql
#
echo "  SCPropTerrToBridge $P1 $P2 complete."
~/sysprocs/LOGMSG "SCPropTerrToBridge $P1 $P2 complete."
#end SCPropTerrToBridge
