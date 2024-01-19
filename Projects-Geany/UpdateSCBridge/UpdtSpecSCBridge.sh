#!/bin/bash
echo " ** UpdtSpecSCBridge.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash UpdtSpecSCBridge.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 10/4/22.    wmk.   (automated) fix *pathbase for CB system.
# 12/11/22.	wmk.	run SetToday.sh to export TODAY env var.
# 12/12/22.	wmk.	SetTody.sh path corrected.
# Legacy mods.
# 4/23/22.	wmk.	modified for FL/SARA/86777.
# 4/22/22.	wmk.	HOME changed to USER in host check.
# Legacy mods.
# 4/6/21.	wmk.	original shell (template)
# 6/17/21.	wmk.	multihost support.
# 9/6/21.	wmk.	jumpto function and references removed.
# 11/9/21.	wmk.	add echo when initiated from make; add $ TODAY definition.
# 12/3/21.	wmk.	'procbodyhere' replaces proc body here for awk reversal.
# 4/8/22.	wmk.	HOME changed to USER in host test.	
P1=$1
TID=$P1
TN="Terr"
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
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  UpdtSpecSCBridge - initiated from Make"
  echo "  UpdtSpecSCBridge - initiated from Make"
else
  ~/sysprocs/LOGMSG "  UpdtSpecSCBridge - initiated from Terminal"
  echo "  UpdtSpecSCBridge - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 . ~/GitHub/TerritoriesCB/Procs-Dev/SetToday.sh
#TODAY=2022-04-22
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

echo "--UpdtSpecSCBridge.psq/sql - Update SC Bridge table for TrianoCir."  > SQLTemp.sql
echo "--	2/5/23.	wmk."  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 4/25/22.	wmk.	modified for general use;*pathbase* support."  >> SQLTemp.sql
echo "-- * 2/5/23.	wmk.	superfluous '.db' removed from ATTACH."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 11/6/21.	wmk.	original code; adapted from UpdateSCBridge;"  >> SQLTemp.sql
echo "-- *					integrate change records fields into"  >> SQLTemp.sql
echo "-- *					TrianoCir.db.Spec_SCBridge; @ @ and z z used"  >> SQLTemp.sql
echo "-- *					for mm dd in SCPADiff db name."  >> SQLTemp.sql
echo "-- * 3/20/22.	wmk.	remove DownDate criteria from 11/6."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 11/3/21.	Total rewrite; change to use Diffsmmd within Terrxxx_SC.db"  >> SQLTemp.sql
echo "-- *			containing change records; Integrate change records fields"  >> SQLTemp.sql
echo "-- *			into Terrxxx_SCBridge;"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. t errrbase is used as a placeholder in file paths to"  >> SQLTemp.sql
echo "-- * facilitate sed stream editing, substituting ($)folderbase for the"  >> SQLTemp.sql
echo "-- * shell script to pick up."  >> SQLTemp.sql
echo "-- * <s pecial-db> is used as a placeholder in filepaths and database"  >> SQLTemp.sql
echo "-- * table name(s) to facilitate stream editing by sed. These strings"  >> SQLTemp.sql
echo "-- * will be fixed by DoSed1 from the Build menu."  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * UpdtSpecSCBridge - Update Special SC Bridge table."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- *-------------------------------------------------------------"  >> SQLTemp.sql
echo "-- * UpdtSpecSCBridge - Update Special SC Bridge table."  >> SQLTemp.sql
echo "-- *	2/5/23.	wmk."  >> SQLTemp.sql
echo "-- *-------------------------------------------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * UpdtSpecSCBridge - Update SC Bridge table for territory xxx."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	junk.db - as main, scratch db"  >> SQLTemp.sql
echo "-- *	TrianoCir.db - as db29, Special download of SC records"  >> SQLTemp.sql
echo "-- *		Spec_SCBridge - Bridge formatted records extracted from SCPA"  >> SQLTemp.sql
echo "-- *			for street/area TrianoCir."  >> SQLTemp.sql
echo "-- *	folderbase = environment var set before this query is executed from"  >> SQLTemp.sql
echo "-- *	  a shell by being written via echo statements"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 4/25/22.	wmk.	*pathbase* replaces *folderbase* stuff."  >> SQLTemp.sql
echo "-- * 2/5/23.	wmk.	superfluous '.db' suffix removed from ATTACH."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 11/6/21.	wmk.	original code; adapted from UpdateSCBridge;"  >> SQLTemp.sql
echo "-- *					integrate change records fields into"  >> SQLTemp.sql
echo "-- *					vvvvv.db.Spec_SCBridge."  >> SQLTemp.sql
echo "-- * 11/6/21.	wmk.	mod to include DownDate in update criteria."  >> SQLTemp.sql
echo "-- * 3/20/22.	wmk.	remove DownDate criteria from 11/6."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. UpdtSpecSCBridge takes both the UpdtP.csv and UpdtM.csv file"  >> SQLTemp.sql
echo "-- * data, places the records into temp tables, then uses the temp tables"  >> SQLTemp.sql
echo "-- * to update the Resident1, Phone2 (Homestead), and PropUse fields"  >> SQLTemp.sql
echo "-- * in the SC Bridge table for the territory where the OwningParcel"  >> SQLTemp.sql
echo "-- * matches the Account # field on the temp table(s)."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads/Special/TrianoCir.db'"  >> SQLTemp.sql
echo "  AS db29;"  >> SQLTemp.sql
echo "--  PRAGMA db29.table_info(Spec_SCBridge);"  >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo "  || '/SCPADiff_05-28.db'"  >> SQLTemp.sql
echo "as db11;"  >> SQLTemp.sql
echo "--  PRAGMA db11.table_info(Diff0528);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * Now Update records using information from Diffs0528.;"  >> SQLTemp.sql
echo "WITH a AS (SELECT \"Account#\" AS Acct,"  >> SQLTemp.sql
echo " CASE "  >> SQLTemp.sql
echo " WHEN \"HomesteadExemption(YesorNo)\" IS \"YES\""  >> SQLTemp.sql
echo "  THEN \"*\" "  >> SQLTemp.sql
echo " ELSE \" \""  >> SQLTemp.sql
echo " END AS Hstead,"  >> SQLTemp.sql
echo " \"propertyusecode\" AS UseType, "  >> SQLTemp.sql
echo "  CASE"  >> SQLTemp.sql
echo "  WHEN LENGTH(\"Owner3\") > 0"  >> SQLTemp.sql
echo "   THEN TRIM(SUBSTR(\"Owner1\",1,25)) || \", \""  >> SQLTemp.sql
echo "     || TRIM(\"Owner2\") || \", \" "  >> SQLTemp.sql
echo "     || TRIM(\"Owner3\")"  >> SQLTemp.sql
echo "  WHEN LENGTH(\"Owner2\") > 0 "  >> SQLTemp.sql
echo "   THEN TRIM(SUBSTR(\"Owner1\",1,25)) || \", \""  >> SQLTemp.sql
echo "     || TRIM(\"Owner2\")"  >> SQLTemp.sql
echo "  ELSE TRIM(SUBSTR(\"Owner1\",1,25))"  >> SQLTemp.sql
echo "  END AS Owners,"  >> SQLTemp.sql
echo "  DownloadDate AS DownDate"  >> SQLTemp.sql
echo "  FROM db11.Diff0528 )"  >> SQLTemp.sql
echo "UPDATE db29.Spec_SCBridge"  >> SQLTemp.sql
echo "SET Resident1 ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT Owners from a "  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel"  >> SQLTemp.sql
echo " )"  >> SQLTemp.sql
echo "ELSE Resident1 "  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo " Phone2 = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT Hstead from a "  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel"  >> SQLTemp.sql
echo " )"  >> SQLTemp.sql
echo "ELSE Phone2"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo " PropUse = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT UseType from a "  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel"  >> SQLTemp.sql
echo " )"  >> SQLTemp.sql
echo "ELSE PropUse"  >> SQLTemp.sql
echo "END,"  >> SQLTemp.sql
echo "RecordDate = "  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN OwningParcel IN (SELECT Acct FROM a)"  >> SQLTemp.sql
echo " THEN (SELECT DownDate from a"  >> SQLTemp.sql
echo "  WHERE Acct IS OwningParcel"  >> SQLTemp.sql
echo " )"  >> SQLTemp.sql
echo "ELSE RecordDate"  >> SQLTemp.sql
echo "END;"  >> SQLTemp.sql
echo "--WHERE OwningParcel IN (SELECT Acct FROM a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END UpdtSpecSCBridge **********;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  UpdtSpecSCBridge complete."
~/sysprocs/LOGMSG "  UpdtSpecSCBridge complete."
#end proc
