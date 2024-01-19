#!/bin/bash
#begin RUTidyTerr1.sh
# RUTidyTerr_db.sh - Tidy RU records territory $1 postprocessor.
# 6/27/22.	wmk.
# bash RUTidyTerr_db.sh   <terrid>
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
# 4/25/22.	wmk.	modified for FL/SARA/86777.
# 6/27/22.	wmk.	db references to VeniceNTerritory/NVenAll removed.
# Legacy mods.
#	11/11/20.	wmk.	original shell
#	11/26/20.	wmk.	RecordType code corrected to include PropUse
#						like "05%"
#	12/1/20.	wmk.	PropUse 0200 and 2860 added for mobile homes
#						and mobile home parks
#	12/9/20.	wmk.	Added "-" constraint to 1st update
#	12/12/20.	wmk.	PropUse 0101 added for single family attached
#	12/15/20.	wmk.	PropUse 7400 added for ACLF assisted living
#	12/21/20.	wmk.	Add Unit constraint to DoNotCall field set values
#	3/6/21.		wmk.	added terrid to system log messages; adapted to run
#						from make bash call.
#	3/19/21.	wmk.	2nd query changed to better check for unit match
#						and avoid NOT NULL constraint violation.
#	3/26/21.	wmk.	marked with division comments to correspond to
#						RUTidy1..RuTidy14.sql extraction from source.
#	4/1/21.		wmk.	bug fix setting DoNotCalls where M property with 
#						multi-units all getting set instead of only units.
#	4/2/21.		wmk.	RUTidyTerr1..RUTidyTerr15 segment delineation
#						for modular bug fixes and make.
#	4/21/21.	wmk.	mod to recognize property use 740X ALF as type
#						"M" record.
# 	5/27/21.	wmk.	modified for use with Kay's system; environment checked
#						and used for correct Territory folder paths.
#	6/6/21.		wmk.	bug fixes; equality check for ($)HOME, TEMP_PATH
#						ensured set.
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
TID=$1
P2=${2^^}
P3=${3^^}
P4=$4
if [ -z "$P1" ] || [ -z "$P2" ] || [ -z "$P3" ] || [ -z "$P4" ];then
 echo "RUTidyTerr_db <terrid> <state> <county> <congno> missing parameter(s) - abandoned."
 exit 1
fi
if [ -z "$folderbase" ];then
 if [ "$USER" = "ubuntu" ]; then
  export folderbase=/media/ubuntu/Windows/Users/Bill
 else 
  export folderbase=$HOME
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$congterr" ];then
 export congterr=FLSARA86777
fi
if [ "$P2$P3$P4" != "$congterr" ];then
 echo "*congterr* = :$congterr"
 echo "** $P2$P3$P4 mismatch with *congterr* - RUTidyTerr_db abandoned **"
 exit 1
fi
#
if [ -z "$system_log" ]; then
  system_log="/media/ubuntu/Windows/Users/Bill/ubuntu/SystemLog.txt"
  TEMP_PATH="/home/ubuntu/temp"
  ~/sysprocs/LOGMSG "  RUTidyTerr_db - initiated from Make"
else
  ~/sysprocs/LOGMSG "  RUTidyTerr_db - initiated from Terminal"
  echo "  RUTidyTerr_db - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
if [ -z "$P1$" ]; then
  echo "  Territory id not specified... RUTidyTerr_db abandoned." >> $system_log #
  echo -e "Territory id must be specified...\nRUTidyTerr_db abandoned."
  exit 1
fi
TID=$P1
TN="Terr"
if [ 1 -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
#end RUTidyTerr1.sh
#begin preRUTidy.sh
# 6/27/22.	wmk.
#
# Modification History.
# ---------------------
# 4/2/21.	wmk.	original code.
# 6/27/22.	wmk.	environment vars moved to top; *pathbase support integrated.
DB_END="_RU.db"
TBL_END1="_RUBridge"
TBL_END2=""
TBL_END3=""
NM_PRFX="Terr"
DB_NAME="$NM_PRFX$TID$DB_END"
TBL_NAME1="$NM_PRFX$TID$TBL_END1"
TBL_NAME2="$NM_PRFX$TID$TBL_END2"
TBL_NAME3="$NM_PRFX$TID$TBL_END3"
pushd ./ > $TEMP_PATH/bitbucket.txt
# end preRUTidy.sh
#procbodyhere
echo "--begin RUTidyTerr2.sh;" > SQLTemp.sql
echo "-- SQLTemp.sql - RUTidyTerr -Tidy up _RUBridge records in" >> SQLTemp.sql
echo "--  new RefUSA territory db." >> SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './RawData/RefUSA/RefUSA-Downloads'" >> SQLTemp.sql
echo ".cd './$TN$TID'"  >> SQLTemp.sql
echo ".shell touch SQLTrace.txt" >> SQLTemp.sql
echo ".trace 'SQLTrace.txt'" >> SQLTemp.sql
# echo ".open './DB/PolyTerri.db'" >> SQLTemp.sql
echo ".shell echo \"Opening ./$TN$TID/$DB_NAME\" | awk '{print \$1}' > SQLTrace.txt" >> SQLTemp.sql
echo "--#.shell sed -i '1s/^/-- SQLTrace initialization/' SQLTrace.txt" >> SQLTemp.sql
echo "--#.shell sed -i -e '$aOpening ./$TN$TID/$DB_NAMEn' SQLTrace.txt" >> SQLTemp.sql
echo ".open $DB_NAME " >> SQLTemp.sql
echo ".shell echo \"SetOwningParcels - Set OwningParcel fields in $TBL_NAME1.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo "||		'/DB-Dev/Terr86777.db' " >> SQLTemp.sql
echo "AS db2;" >> SQLTemp.sql
echo "-- * SetOwningParcels - Set OwningParcel fields in $TBL_NAME1." >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'" >> SQLTemp.sql
echo " ||		'/DB-Dev/AuxSCPAData.db'" >> SQLTemp.sql
echo "  AS db8;" >> SQLTemp.sql
echo "--end RUTidyTerr2.sh;" >> SQLTemp.sql
#endprocbody
#procbodyhere
echo "--begin RUTidyTerr3.sh;" >> SQLTemp.sql
echo ".shell echo \"look for direct matches, straight across with SC situs address\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "-- # look for direct matches, straight across with SC situs address;" >> SQLTemp.sql
echo "WITH" >> SQLTemp.sql
echo " a AS (SELECT \"Account #\", \"situs address (Property address)\"" >> SQLTemp.sql
echo "      AS Situs" >> SQLTemp.sql
echo "  FROM Terr86777)" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1 " >> SQLTemp.sql
echo "SET OwningParcel = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN UPPER(TRIM(UnitAddress)) IN (SELECT Situs FROM a)" >> SQLTemp.sql
echo "THEN" >> SQLTemp.sql
echo "    (SELECT \"Account #\" from a" >> SQLTemp.sql
echo "     WHERE" >> SQLTemp.sql
echo " TRIM(\"situs address (property address)\")" >> SQLTemp.sql
echo "      IS upper(TRIM(\"UnitAddress\")))" >> SQLTemp.sql
echo "ELSE OwningParcel" >> SQLTemp.sql
echo "END" >> SQLTemp.sql
echo "WHERE UPPER(TRIM(UNITADDRESS))" >> SQLTemp.sql
echo " IN (SELECT \"SITUS ADDRESS (PROPERTY ADDRESS)\" " >> SQLTemp.sql
echo "   FROM a)" >> SQLTemp.sql
echo " AND OwningParcel IS \"-\"" >> SQLTemp.sql
echo "--end RUTidyTerr3.sh;" >> SQLTemp.sql
#endprocbody
#procbodyhere
echo "--begin RUTidyTerr4.sh;" >> SQLTemp.sql
echo ";" >> SQLTemp.sql
echo ".shell echo \"second pass at unit address + unit to match Terr86777.situs..\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "-- only looking at situs lengths > 35, since these have units;" >> SQLTemp.sql
echo "WITH a AS (SELECT" >> SQLTemp.sql
echo " \"Account #\", \"situs address (Property address)\"" >> SQLTemp.sql
echo "  FROM Terr86777" >> SQLTemp.sql
echo "  WHERE \"account #\" NOTNULL" >> SQLTemp.sql
echo "AND LENGTH(\"situs address (Property address)\") > 35)" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1 " >> SQLTemp.sql
echo "SET OwningParcel = " >> SQLTemp.sql
echo "CASE " >> SQLTemp.sql
echo "WHEN LENGTH(UNIT) > 0" >> SQLTemp.sql
echo "  AND upper(TRIM(UNITADDRESS))" >> SQLTemp.sql
echo "	     IN (SELECT " >> SQLTemp.sql
echo "TRIM(SUBSTR(\"situs address (Property address)\"," >> SQLTemp.sql
echo "           1,35)) FROM a " >> SQLTemp.sql
echo "           WHERE SUBSTR(\"situs address (property address)\",36,3)" >> SQLTemp.sql
echo "           IS UNIT)" >> SQLTemp.sql
echo "THEN" >> SQLTemp.sql
echo "	(SELECT \"Account #\" from a" >> SQLTemp.sql
echo "	 WHERE" >> SQLTemp.sql
echo "TRIM(SUBSTR(\"situs address (property address)\",1,35))" >> SQLTemp.sql
echo "      IS upper(TRIM(\"UnitAddress\"))" >> SQLTemp.sql
echo "	AND " >> SQLTemp.sql
echo "	 SUBSTR(\"situs address (property address)\",36,3)" >> SQLTemp.sql
echo "	        IS TRIM(UNIT))" >> SQLTemp.sql
echo "ELSE OWNINGPARCEL" >> SQLTemp.sql
echo "END" >> SQLTemp.sql
echo "WHERE OWNINGPARCEL IS \"-\";" >> SQLTemp.sql
echo "--end RUTidyTerr4.sh;" >> SQLTemp.sql
#endprocbody
#procbodyhere
echo "--begin RUTidyTerr5.sh;" >> SQLTemp.sql
echo ".shell echo \"SetOPStripDir - Set OwningParcels stripping UnitAddress direction.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "-- look in situs dups for unit address, since these are ambiguous withour direction;" >> SQLTemp.sql
echo "WITH a AS (SELECT \"ACCOUNT #\"," >> SQLTemp.sql
echo "		 \"SITUS ADDRESS (PROPERTY ADDRESS)\"" >> SQLTemp.sql
echo "		FROM Terr86777" >> SQLTemp.sql
echo "  WHERE LENGTH(\"SITUS ADDRESS (PROPERTY ADDRESS)\") < 36)," >> SQLTemp.sql
echo "     b AS (SELECT RUFULL FROM SITUSDUPS)" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1" >> SQLTemp.sql
echo "SET OwningParcel =" >> SQLTemp.sql
echo "  CASE" >> SQLTemp.sql
echo "  WHEN upper(trim(UnitAddress)) NOT IN" >> SQLTemp.sql
echo "        (SELECT RUFULL FROM b)" >> SQLTemp.sql
echo " AND UPPER(trim(SubStr(UnitAddress, 1, " >> SQLTemp.sql
echo "           LENGTH(UnitAddress)-1)))" >> SQLTemp.sql
echo "        IN (SELECT \"SITUS ADDRESS (PROPERTY ADDRESS)\" from a)" >> SQLTemp.sql
echo "  THEN  (SELECT \"ACCOUNT #\" FROM a" >> SQLTemp.sql
echo "       WHERE \"SITUS ADDRESS (PROPERTY ADDRESS)\"" >> SQLTemp.sql
echo "  IS UPPER(trim(substr(UnitAddress, 1," >> SQLTemp.sql
echo "     LENGTH(UnitAddress)-1))))" >> SQLTemp.sql
echo "  ELSE OwningParcel" >> SQLTemp.sql
echo "  END" >> SQLTemp.sql
echo "WHERE OwningParcel IS \"-\";" >> SQLTemp.sql
echo "--end RUTidyTerr5.sh;" >> SQLTemp.sql
#endprocbody
#procbodyhere
echo "--begin RUTidyTerr6.sh;" >> SQLTemp.sql
echo ".shell echo \"SetDupOwningParcels - Set OwningParcels and Situs for UnitAddresses with dups\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account#\", RUFull, Situs" >> SQLTemp.sql
echo "  FROM SitusDups)" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1" >> SQLTemp.sql
echo "SET OwningParcel =" >> SQLTemp.sql
echo "  CASE" >> SQLTemp.sql
echo "  WHEN UPPER(TRIM(UnitAddress))" >> SQLTemp.sql
echo "   IN (SELECT RuFull FROM a)" >> SQLTemp.sql
echo "   THEN (SELECT \"Account#\" FROM a " >> SQLTemp.sql
echo "         WHERE RUFull IS UPPER(TRIM(UnitAddress)))" >> SQLTemp.sql
echo "  ELSE OwningParcel" >> SQLTemp.sql
echo "  END," >> SQLTemp.sql
echo " SitusAddress =" >> SQLTemp.sql
echo "  CASE" >> SQLTemp.sql
echo "  WHEN UPPER(TRIM(UnitAddress))" >> SQLTemp.sql
echo "   IN (SELECT RuFull FROM a)" >> SQLTemp.sql
echo "   THEN (SELECT Situs FROM a " >> SQLTemp.sql
echo "         WHERE RUFull IS UPPER(TRIM(UnitAddress)))" >> SQLTemp.sql
echo "  ELSE SitusAddress" >> SQLTemp.sql
echo "  END" >> SQLTemp.sql
echo "WHERE OwningParcel IS \"-\";" >> SQLTemp.sql
echo "--end RUTidyTerr6.sh;" >> SQLTemp.sql
#endprocbody
#procbodyhere
echo "--begin RUTidyTerr7.sh;" >> SQLTemp.sql
echo ".shell echo \"SetDirXcptOwningParcels - Set OwningParcel fields with direction exceptions.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "-- *SetDirXcptOwningParcels - Set OwningParcel fields with direction exceptions;" >> SQLTemp.sql
echo "WITH a AS (SELECT PropID, RUFull, SCPASitus" >> SQLTemp.sql
echo "  FROM db8.AddrXcpt" >> SQLTemp.sql
echo "  WHERE CongTerr is \"$TID\")" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1 " >> SQLTemp.sql
echo "SET OwningParcel = " >> SQLTemp.sql
echo " CASE" >> SQLTemp.sql
echo " WHEN LENGTH(Unit) > 0" >> SQLTemp.sql
echo "   THEN" >> SQLTemp.sql
echo "   CASE " >> SQLTemp.sql
echo "   WHEN upper(TRIM(SUBSTR(\"UnitAddress\",1," >> SQLTemp.sql
echo "				LENGTH(\"UnitAddress\")-1)))" >> SQLTemp.sql
echo "	IN (SELECT TRIM(SUBSTR(RUFUll,1,35)) FROM a" >> SQLTemp.sql
echo "	   WHERE SUBSTR(RUfULL,36,3) IS Unit" >> SQLTemp.sql
echo "	)" >> SQLTemp.sql
echo "    THEN" >> SQLTemp.sql
echo "    (SELECT \"PropID\" from a" >> SQLTemp.sql
echo "	 WHERE" >> SQLTemp.sql
echo "       TRIM(SUBSTR(RUFUll,1,35))" >> SQLTemp.sql
echo "        IS upper(TRIM(SUBSTR(\"UnitAddress\",1," >> SQLTemp.sql
echo "				LENGTH(\"UnitAddress\")-1)))" >> SQLTemp.sql
echo "     AND SUBSTR(RUfULL,36,3) IS Unit)" >> SQLTemp.sql
echo "   ELSE OwningParcel" >> SQLTemp.sql
echo "   END" >> SQLTemp.sql
echo " ELSE OwningParcel" >> SQLTemp.sql
echo " END," >> SQLTemp.sql
echo "SitusAddress =" >> SQLTemp.sql
echo " CASE" >> SQLTemp.sql
echo " WHEN Unit IS NOT \"\" AND Unit IS NOT NULL" >> SQLTemp.sql
echo "   THEN" >> SQLTemp.sql
echo "   CASE " >> SQLTemp.sql
echo "   WHEN upper(TRIM(SUBSTR(\"UnitAddress\",1," >> SQLTemp.sql
echo "				LENGTH(\"UnitAddress\")-1)))" >> SQLTemp.sql
echo "	IN (SELECT TRIM(SUBSTR(RUFUll,1,35)) FROM a" >> SQLTemp.sql
echo "	   WHERE SUBSTR(RUfULL,36,3) IS Unit" >> SQLTemp.sql
echo "	)" >> SQLTemp.sql
echo "    THEN" >> SQLTemp.sql
echo "    (SELECT \"SCPASitus\" from a" >> SQLTemp.sql
echo "	 WHERE" >> SQLTemp.sql
echo "       TRIM(SUBSTR(RUFUll,1,35))" >> SQLTemp.sql
echo "        IS upper(TRIM(SUBSTR(\"UnitAddress\",1," >> SQLTemp.sql
echo "				LENGTH(\"UnitAddress\")-1)))" >> SQLTemp.sql
echo "     AND SUBSTR(RUfULL,36,3) IS Unit)" >> SQLTemp.sql
echo "   ELSE SitusAddress" >> SQLTemp.sql
echo "   END" >> SQLTemp.sql
echo " ELSE SitusAddress" >> SQLTemp.sql
echo " END" >> SQLTemp.sql
echo "WHERE UPPER(TRIM(\"UnitAddress\"))" >> SQLTemp.sql
echo "  IN (SELECT TRIM(SUBSTR(RUFUll,1,35)) FROM a)" >> SQLTemp.sql
echo "  AND OwningParcel IS \"-\";" >> SQLTemp.sql
echo "--end RUTidyTerr7.sh;" >> SQLTemp.sql
#endprocbody
echo "--procbodyhere;"  > SQLTemp.sql
echo "--begin RUTidyTerr8.sh;"  >> SQLTemp.sql
echo ".shell echo \"SetXcptOwningParcels - Set OwningParcel fields from exceptions.\" | awk '{print \$1}' >> SQLTrace.txt"  >> SQLTemp.sql
echo "WITH a AS (SELECT PropID, RUFull"  >> SQLTemp.sql
echo "  FROM db8.AddrXcpt"  >> SQLTemp.sql
echo "  WHERE CongTerrID is \"$TID\""  >> SQLTemp.sql
echo "   AND Length(PropID) > 0)"  >> SQLTemp.sql
echo "UPDATE $TBL_NAME1 "  >> SQLTemp.sql
echo "SET OwningParcel = "  >> SQLTemp.sql
echo " CASE"  >> SQLTemp.sql
echo " WHEN Unit IS NOT \"\" AND Unit IS NOT NULL"  >> SQLTemp.sql
echo "   THEN"  >> SQLTemp.sql
echo "   CASE "  >> SQLTemp.sql
echo "   WHEN UPPER(TRIM(UnitAddress)) "  >> SQLTemp.sql
echo " IN (SELECT TRIM(SUBSTR(RUFull,1,35)) FROM a"  >> SQLTemp.sql
echo "  WHERE Unit IS SUBSTR(RUFull,36,3) )"  >> SQLTemp.sql
echo "    THEN (SELECT \"PropID\" from a"  >> SQLTemp.sql
echo "	 WHERE"  >> SQLTemp.sql
echo "       TRIM(SUBSTR(RUFUll,1,35))"  >> SQLTemp.sql
echo "       IS upper(TRIM(\"UnitAddress\"))"  >> SQLTemp.sql
echo "     AND SUBSTR(RUfULL,36,3) IS Unit)"  >> SQLTemp.sql
echo "    ELSE OwningParcel"  >> SQLTemp.sql
echo "    END"  >> SQLTemp.sql
echo " ELSE OwningParcel"  >> SQLTemp.sql
echo " END,"  >> SQLTemp.sql
echo "SitusAddress = "  >> SQLTemp.sql
echo "CASE"  >> SQLTemp.sql
echo " WHEN Unit IS NOT \"\" AND Unit IS NOT NULL"  >> SQLTemp.sql
echo "   THEN"  >> SQLTemp.sql
echo "   CASE "  >> SQLTemp.sql
echo "   WHEN UPPER(TRIM(UnitAddress)) "  >> SQLTemp.sql
echo " IN (SELECT TRIM(SUBSTR(RUFull,1,35)) FROM a"  >> SQLTemp.sql
echo "  WHERE Unit IS SUBSTR(RUFull,36,3) )"  >> SQLTemp.sql
echo "    THEN (SELECT \"SCPASitus\" from a"  >> SQLTemp.sql
echo "	 WHERE"  >> SQLTemp.sql
echo "       TRIM(SUBSTR(RUFUll,1,35))"  >> SQLTemp.sql
echo "        IS upper(TRIM(SUBSTR(UnitAddress,1,"  >> SQLTemp.sql
echo "				LENGTH(\"UnitAddress\")-1)))"  >> SQLTemp.sql
echo "     AND SUBSTR(RUfULL,36,3) IS Unit)"  >> SQLTemp.sql
echo "    ELSE SitusAddress "  >> SQLTemp.sql
echo "    END"  >> SQLTemp.sql
echo " ELSE SitusAddress"  >> SQLTemp.sql
echo " END"  >> SQLTemp.sql
echo "WHERE UPPER(TRIM(UnitAddress))"  >> SQLTemp.sql
echo "  IN (SELECT TRIM(SUBSTR(RUFUll,1,35)) FROM a)"  >> SQLTemp.sql
echo "  AND OwningParcel IS \"-\";"  >> SQLTemp.sql
echo "--end RUTidyTerr8.sh;"  >> SQLTemp.sql
echo "--endprocbody;"  >> SQLTemp.sql
#procbodyhere
echo "--begin RUTidyTerr9.sh;" >> SQLTemp.sql
echo ".shell echo \" second pass at exceptions with (unitaddress minus direction) + unit\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "WITH a AS (SELECT PropID, RUFull" >> SQLTemp.sql
echo "  FROM db8.AddrXcpt" >> SQLTemp.sql
echo "  WHERE CongTerrID is \"$TID\")" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1 " >> SQLTemp.sql
echo "SET OwningParcel = " >> SQLTemp.sql
echo " CASE" >> SQLTemp.sql
echo " WHEN Unit IS NOT \"\" AND Unit IS NOT NULL" >> SQLTemp.sql
echo "   THEN" >> SQLTemp.sql
echo "   CASE " >> SQLTemp.sql
echo "   WHEN  upper(TRIM(SUBSTR(\"UnitAddress\",1," >> SQLTemp.sql
echo "				LENGTH(\"UnitAddress\")-1)))" >> SQLTemp.sql
echo "	  IN (SELECT TRIM(SUBSTR(RUFull,1,35)) FROM a" >> SQLTemp.sql
echo "	     WHERE SUBSTR(RUFull,36,3) IS Unit)" >> SQLTemp.sql
echo "    THEN (SELECT \"PropID\" from a" >> SQLTemp.sql
echo "	 WHERE" >> SQLTemp.sql
echo "       TRIM(SUBSTR(RUFUll,1,35))" >> SQLTemp.sql
echo "        IS upper(TRIM(SUBSTR(\"UnitAddress\",1," >> SQLTemp.sql
echo "				LENGTH(\"UnitAddress\")-1)))" >> SQLTemp.sql
echo "     AND SUBSTR(RUfULL,36,3) IS Unit)" >> SQLTemp.sql
echo "   ELSE OwningParcel" >> SQLTemp.sql
echo "   END" >> SQLTemp.sql
echo " ELSE OwningParcel" >> SQLTemp.sql
echo " END," >> SQLTemp.sql
echo "SitusAddress = " >> SQLTemp.sql
echo "CASE" >> SQLTemp.sql
echo " WHEN Unit IS NOT \"\" AND Unit IS NOT NULL" >> SQLTemp.sql
echo "   THEN" >> SQLTemp.sql
echo "   CASE " >> SQLTemp.sql
echo "   WHEN upper(TRIM(SUBSTR(\"UnitAddress\",1," >> SQLTemp.sql
echo "				LENGTH(\"UnitAddress\")-1)))" >> SQLTemp.sql
echo "	  IN (SELECT TRIM(SUBSTR(RUFull,1,35)) FROM a" >> SQLTemp.sql
echo "	     WHERE SUBSTR(RUFull,36,3) IS Unit)" >> SQLTemp.sql
echo "    THEN (SELECT \"SCPASitus\" from a" >> SQLTemp.sql
echo "	 WHERE" >> SQLTemp.sql
echo "       TRIM(SUBSTR(RUFUll,1,35))" >> SQLTemp.sql
echo "        IS upper(TRIM(SUBSTR(\"UnitAddress\",1," >> SQLTemp.sql
echo "				LENGTH(\"UnitAddress\")-1)))" >> SQLTemp.sql
echo "       AND SUBSTR(RUfULL,36,3) IS Unit)" >> SQLTemp.sql
echo "   ELSE SitusAddress" >> SQLTemp.sql
echo "   END" >> SQLTemp.sql
echo " ELSE SitusAddress" >> SQLTemp.sql
echo " END" >> SQLTemp.sql
echo "WHERE UPPER(TRIM(\"UnitAddress\"))" >> SQLTemp.sql
echo "  IN (SELECT TRIM(SUBSTR(RUFUll,1,35)) FROM a)" >> SQLTemp.sql
echo "  AND OwningParcel IS \"-\"; " >> SQLTemp.sql
echo "--end RUTidyTerr9.sh;" >> SQLTemp.sql
#endprocbody
#procbodyhere
echo "--begin RUTidyTerr10.sh;" >> SQLTemp.sql
echo ".shell echo \"* SetDiffXcptOwningParcels - Set UnitAddress exceptions matching.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "WITH a AS (SELECT PropID, RUFull, SCPASitus" >> SQLTemp.sql
echo "  FROM db8.AddrXcpt" >> SQLTemp.sql
echo "  WHERE CongTerrID is \"$TID\")" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1 " >> SQLTemp.sql
echo "SET OwningParcel = " >> SQLTemp.sql
echo " CASE" >> SQLTemp.sql
echo " WHEN Unit ISNULL OR Unit IS \"\"" >> SQLTemp.sql
echo "   THEN" >> SQLTemp.sql
echo "    (SELECT \"PropID\" from a" >> SQLTemp.sql
echo "	 WHERE" >> SQLTemp.sql
echo "	   RUFull" >> SQLTemp.sql
echo "       IS upper(TRIM(\"UnitAddress\")))" >> SQLTemp.sql
echo " ELSE OwningParcel" >> SQLTemp.sql
echo " END," >> SQLTemp.sql
echo "SitusAddress =" >> SQLTemp.sql
echo " CASE" >> SQLTemp.sql
echo " WHEN Unit ISNULL OR Unit IS \"\"" >> SQLTemp.sql
echo "   THEN" >> SQLTemp.sql
echo "    (SELECT \"SCPASitus\" from a" >> SQLTemp.sql
echo "	 WHERE" >> SQLTemp.sql
echo "	   RUFull" >> SQLTemp.sql
echo "       IS upper(TRIM(\"UnitAddress\")))" >> SQLTemp.sql
echo " ELSE SitusAddress" >> SQLTemp.sql
echo " END" >> SQLTemp.sql
echo "WHERE UPPER(TRIM(\"UnitAddress\"))" >> SQLTemp.sql
echo "  IN (SELECT RUFull FROM a)" >> SQLTemp.sql
echo "  AND OwningParcel IS \"-\";" >> SQLTemp.sql
echo "--end RUTidyTerr10.sh;" >> SQLTemp.sql
#endprocbody
#procbodyhere
echo "--begin RUTidyTerr11.sh;" >> SQLTemp.sql
echo ".shell echo \" set situs and property use fields\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "-- * SetSitusPropUse - Set Situs and Property Use from SCPA data." >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\", \"situs address (property address)\"," >> SQLTemp.sql
echo "	\"Property Use Code\" FROM Terr86777" >> SQLTemp.sql
echo "	WHERE \"Account #\" IN (SELECT OwningParcel FROM $TBL_NAME1))" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1 " >> SQLTemp.sql
echo "SET SitusAddress =" >> SQLTemp.sql
echo " (SELECT \"situs address (property address)\" FROM a" >> SQLTemp.sql
echo "   WHERE \"Account #\" IS OwningParcel)," >> SQLTemp.sql
echo "PropUse = " >> SQLTemp.sql
echo " (SELECT \"Property Use Code\" FROM a" >> SQLTemp.sql
echo "   WHERE \"Account #\" IS OwningParcel)" >> SQLTemp.sql
echo "WHERE OwningParcel IS NOT \"-\";" >> SQLTemp.sql
echo "--end RUTidyTerr11.sh;" >> SQLTemp.sql
#endprocbody
#procbodyhere
echo "--begin RUTidyTerr12.sh;" >> SQLTemp.sql
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
echo "	ELSE \"\"" >> SQLTemp.sql
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
echo "	ELSE \"Foreign\"" >> SQLTemp.sql
echo "	END" >> SQLTemp.sql
echo "WHERE OwningParcel IN (SELECT PropID FROM a);" >> SQLTemp.sql
echo "-- * SetRecTypes - Set \"P\", \"M\", \"C\" record types in Bridge table." >> SQLTemp.sql
echo "--end RUTidyTerr12.sh;" >> SQLTemp.sql
#endprocbody
#procbodyhere
echo "--begin RUTidyTerr13.sh;"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * ??/??/??.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 6/27/22.	wmk.	modified to use SCPropUse table in db2."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ".shell echo \"* SetRecTypes - Set \"P\", \"M\", \"C\", \"A\" record types in Bridge table.\" | awk '{print \$1}' >> SQLTrace.txt"  >> SQLTemp.sql
echo "WITH a AS (SELECT Code, RType FROM db2.SCPropUse)"  >> SQLTemp.sql
echo "UPDATE $TBL_NAME1"  >> SQLTemp.sql
echo "SET RecordType ="  >> SQLTemp.sql
echo "CASE"  >> SQLTemp.sql
echo "WHEN PropUse IN (SELECT Code FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT RType FROM a"  >> SQLTemp.sql
echo "   WHERE Code IS PropUse)"  >> SQLTemp.sql
echo "ELSE RecordType"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo "--end RUTidyTerr13.sh;"  >> SQLTemp.sql
#endprocbody"
#procbodyhere
echo "--begin RUTidyTerr14.sh;" >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account #\" AS Acct," >> SQLTemp.sql
echo " \"Homestead Exemption\" AS QHomestead," >> SQLTemp.sql
echo " \"Situs Address (Property Address)\" AS Situs" >> SQLTemp.sql
echo " FROM Terr86777" >> SQLTemp.sql
echo " WHERE Acct IN (SELECT OWNINGPARCEL" >> SQLTemp.sql
echo "  FROM $TBL_NAME1))" >> SQLTemp.sql
echo "UPDATE $TBL_NAME1 " >> SQLTemp.sql
echo "SET Phone2 = " >> SQLTemp.sql
echo "CASE" >> SQLTemp.sql
echo "WHEN (SELECT QHomestead FROM a " >> SQLTemp.sql
echo "   WHERE Acct IS OWNINGPARCEL) IS \"YES\"" >> SQLTemp.sql
echo "   THEN \"*\"" >> SQLTemp.sql
echo "ELSE \"\"" >> SQLTemp.sql
echo "END," >> SQLTemp.sql
echo " SitusAddress =" >> SQLTemp.sql 
echo "CASE" >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)" >> SQLTemp.sql
echo " THEN (SELECT Situs FROM a" >> SQLTemp.sql
echo "   WHERE Acct IS OwningParcel)" >> SQLTemp.sql
echo "ELSE SitusAddress" >> SQLTemp.sql
echo "END;" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql
echo ".shell echo \"SQLTemp.sql finished.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "sqlite3 < SQLTemp.sql" >> SQLTemp.sql
echo "--end RUTidyTerr14.sh;" >> SQLTemp.sql
#endprocbody

#procbodyhere
#begin RUTidyTerr15.sh
# conditional to skip SQL execution.
if [ 1 -eq 0 ]; then
 jumpto EndProc
fi
jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql
jumpto EndProc
EndProc:
popd >> $TEMP_PATH/bitbucket.txt
echo "  Terr $TID PostProcessing complete."
~/sysprocs/LOGMSG "   RUTidyTerr_db complete."
echo "   RUTidyTerr_db complete."
#end RUTidyTerr15.sh
#endprocbody

