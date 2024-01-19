#!/bin/bash
echo " ** FlagSCUpdate.sh out-of-date **";exit 1
echo " ** FlagSCUpdate.sh out-of-date **";exit 1
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash FlagSCUpdate.sh
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
  ~/sysprocs/LOGMSG "  FlagSCUpdate - initiated from Make"
  echo "  FlagSCUpdate - initiated from Make"
else
  ~/sysprocs/LOGMSG "  FlagSCUpdate - initiated from Terminal"
  echo "  FlagSCUpdate - initiated from Terminal"
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

echo "-- * FlagSCUpdqate.psq/sql - Flag SC territory for update."  > SQLTemp.sql
echo "-- * 7/1/22.	wmk."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry.	[m m d d edited by DoSed with P2, P3 command line parameters.]"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit.	Terr305_SC.db new table Diff0528 containing records from"  >> SQLTemp.sql
echo "-- *		SCPADiff_05-28.db.Diff0528 whose property IDs are in"  >> SQLTemp.sql
echo "-- *		Terr305_SC.Terr305_SCBridge."  >> SQLTemp.sql
echo "-- *		if record count > 0, UpdtyyyM.csv has 1 record written to"  >> SQLTemp.sql
echo "-- *		 flag UpdateRUDwnld makefile."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 5/1/22.	wmk.	*pathbase* support."  >> SQLTemp.sql
echo "-- * 7/1/22.	wmk.	path fixes."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 11/3/21.	wmk.	complete rewrite."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 3/1/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 3/18/21.	wmk.	AttachDBs added for setup; db references qualified."  >> SQLTemp.sql
echo "-- * 4/19/21.	wmk.	bug fix where table names for SELECT not picking"  >> SQLTemp.sql
echo "-- *					up 0528 from Diff download spec."  >> SQLTemp.sql
echo "-- * 5/27/21.	wmk.	modified to work with Kay's system."  >> SQLTemp.sql
echo "-- * 6/19/21.	wmk.	external dependencies documented."  >> SQLTemp.sql
echo "-- * 6/20/21.	wmk.	restore full field names."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Dependencies."  >> SQLTemp.sql
echo "-- * -------------"  >> SQLTemp.sql
echo "-- * The placeholder *pathbase* is used in file paths within this query."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * The placeholder \"305\" is used in place of a territory id within this"  >> SQLTemp.sql
echo "-- * query. All occurrrences should be replaced by the territory id for"  >> SQLTemp.sql
echo "-- * which to flag SC updates."  >> SQLTemp.sql
echo "--- *"  >> SQLTemp.sql
echo "-- * The placeholders \"@ @-z z\" and \"@ @z z\" are used in date-dependent fields"  >> SQLTemp.sql
echo "-- * within this query. All occurrences should be replaced with the 2-digit"  >> SQLTemp.sql
echo "-- * month (@ @) and day (z z) prior to execution (e.g. 04 26)."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * These dependencies imply that this SQL query will be edited to a"  >> SQLTemp.sql
echo "-- * separate file (e.g. SQLTemp.sql) before being read by the SQL command"  >> SQLTemp.sql
echo "-- * line processor (sqlite3)."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * AttachDBs - Attach required databases."  >> SQLTemp.sql
echo "-- * FlagSCUpdate - Flag SC territory for update."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** AttachDBs **********"  >> SQLTemp.sql
echo "-- *	5/1/22.	wmk."  >> SQLTemp.sql
echo "-- *----------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * AttachDBs - Attach required databases."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	SCPADiff_m2-d2.db as db16,  Difference collection of new/updated"  >> SQLTemp.sql
echo "-- *	  property records between current and past SCPA downloads"  >> SQLTemp.sql
echo "-- *		Diffm2d2 - table of differences new/updated SCPA records"  >> SQLTemp.sql
echo "-- *		  where either last sale date or homestead exemption field(s)"  >> SQLTemp.sql
echo "-- *		  have changed"  >> SQLTemp.sql
echo "-- *		DiffAccts (future) table of property ids and territory ids of"  >> SQLTemp.sql
echo "-- *		  parcels in Diffm2d2 table"  >> SQLTemp.sql
echo "-- *	caller must use sed to change: m2-d2 and m2d2 to correct date,"  >> SQLTemp.sql
echo "-- *	  and 305 to territory ID."  >> SQLTemp.sql
echo "-- *	MultiMail.db - as db3, territory parcels with multiple residents"  >> SQLTemp.sql
echo "-- *		SplitProps - territory parcels with multiple dwellings"  >> SQLTemp.sql
echo "-- *		SplitOwners - parcel owner information"  >> SQLTemp.sql
echo "-- *	TerrIDData.db - as db4, territory and subterritories (all) defs"  >> SQLTemp.sql
echo "-- *		Territory - territory id definitions"  >> SQLTemp.sql
echo "-- *		SubTerrs - subterritory definitions"  >> SQLTemp.sql
echo "-- *		DoNotCalls - DoNotCall addresses by territory"  >> SQLTemp.sql
echo "-- *	PolyTerri.db - as db5, territory parcels from map polygons"  >> SQLTemp.sql
echo "-- *		TerrProps - territory parcels"  >> SQLTemp.sql
echo "-- *		PropOwners - parcel owner information"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	UpdtP305.csv - file containing Diff records from SC download of @ @-z z"  >> SQLTemp.sql
echo "-- *	  that matched in PolyTerri/TerrProps that can be used to update"  >> SQLTemp.sql
echo "-- *      the Terr305_SCBridge table."  >> SQLTemp.sql
echo "-- *	UpdtM305.csv - file containing Diff records from SC download of @ @-z z"  >> SQLTemp.sql
echo "-- *	  that matched in MultiMail/SplitProps that can be used to update"  >> SQLTemp.sql
echo "-- *      the Terr305_SCBridge table."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 3/18/21.	wmk.	AttachDBs added for setup; db references qualified."  >> SQLTemp.sql
echo "-- * 5/27/21.	wmk.	modified to work with various host systems."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo "||		'/DB-Dev/MultiMail.db'"  >> SQLTemp.sql
echo " AS db3;"  >> SQLTemp.sql
echo "--SELECT tbl_name FROM db3.sqlite_master;"  >> SQLTemp.sql
echo "--pragma db3.table_info(SplitProps); "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/DB-Dev/TerrIDData.db'"  >> SQLTemp.sql
echo " AS db4;"  >> SQLTemp.sql
echo "--SELECT tbl_name FROM db4.sqlite_master "  >> SQLTemp.sql
echo "-- WHERE type is \"table\";"  >> SQLTemp.sql
echo "--pragma db4.table_info(DoNotCalls);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/DB-Dev/PolyTerri.db'"  >> SQLTemp.sql
echo "  AS db5;"  >> SQLTemp.sql
echo "--SELECT tbl_name FROM db5.sqlite_master;"  >> SQLTemp.sql
echo "--pragma db5.table_info(TerrProps); "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads/SCPADiff_05-28.db'"  >> SQLTemp.sql
echo " AS db16;"  >> SQLTemp.sql
echo "  SELECT tbl_name FROM db16.sqlite_master;"  >> SQLTemp.sql
echo "--  PRAGMA db16.table_info(Diff0528);"  >> SQLTemp.sql
echo "--  PRAGMA db16.table_info(DiffAccts);"  >> SQLTemp.sql
echo "--  PRAGMA db16.table_info(MissingParcels);"  >> SQLTemp.sql
echo "--  PRAGMA db16.table_info(DNCNewOwners);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** END AttachDBs **********;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** FlagSCUpdate **********"  >> SQLTemp.sql
echo "-- *	5/1/22.	wmk."  >> SQLTemp.sql
echo "-- *-------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * FlagSCUpdate - Flag SC territory for update."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	SCPADiff_m2d2.db as db16,  Difference collection of new/updated"  >> SQLTemp.sql
echo "-- *	  property records between current and past SCPA downloads"  >> SQLTemp.sql
echo "-- *		Diffm2d2 - table of differences new/updated SCPA records"  >> SQLTemp.sql
echo "-- *		  where either last sale date or homestead exemption field(s)"  >> SQLTemp.sql
echo "-- *		  have changed"  >> SQLTemp.sql
echo "-- *		DiffAccts (future) table of property ids and territory ids of"  >> SQLTemp.sql
echo "-- *		  parcels in Diffm2d2 table"  >> SQLTemp.sql
echo "-- *	caller must use sed to change: m2-d2 and m2d2 to correct date,"  >> SQLTemp.sql
echo "-- *	  and 305 to territory ID."  >> SQLTemp.sql
echo "-- *	MultiMail.db - as db3, territory parcels with multiple residents"  >> SQLTemp.sql
echo "-- *		SplitProps - territory parcels with multiple dwellings"  >> SQLTemp.sql
echo "-- *		SplitOwners - parcel owner information"  >> SQLTemp.sql
echo "-- *	PolyTerri.db - as db5, territory parcels from map polygons"  >> SQLTemp.sql
echo "-- *		TerrProps - territory parcels"  >> SQLTemp.sql
echo "-- *		PropOwners - parcel owner information"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	UpdtP305.csv - file containing Diff records from SC download of @ @-z z"  >> SQLTemp.sql
echo "-- *	  that matched in PolyTerri/TerrProps that can be used to update"  >> SQLTemp.sql
echo "-- *      the Terr305_SCBridge table."  >> SQLTemp.sql
echo "-- *	UpdtM305.csv - file containing Diff records from SC download of @ @-z z"  >> SQLTemp.sql
echo "-- *	  that matched in MultiMail/SplitProps that can be used to update"  >> SQLTemp.sql
echo "-- *      the Terr305_SCBridge table."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 5/1/22.	*pathbase* support."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 11/3/21.	complete rewrite."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 3/1/21.	original code."  >> SQLTemp.sql
echo "-- * 3/18/21.	db ATTACHes moved up to start; db references qualified."  >> SQLTemp.sql
echo "-- * 5/27/21.	wmk.	modified to work with Kay's system."  >> SQLTemp.sql
echo "-- * 6/20/21.	wmk.	restore full field names."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. Creating the Updt305P.csv or Updt305M.csv file sets a dependency"  >> SQLTemp.sql
echo "-- * for the UpdateSCBridge make. If the Updt305.csv file is newer than the"  >> SQLTemp.sql
echo "-- * Terr305_SC.db, UpdateSCBridge make will update the Terr305_SC.db"  >> SQLTemp.sql
echo "-- * Terr305_SCBridge table with the new records on the Updt305.csv file."  >> SQLTemp.sql
echo "-- * The sed method in the \"make\" will need to change \"@ @-z z\" to the"  >> SQLTemp.sql
echo "-- * month and day of the Diff file, and \"@ @z z\" to the same as well."  >> SQLTemp.sql
echo "-- * In addition, sid will need to change \"305\" to the territory ID."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo "-- * select difference records into 2 separate .csv files.;"  >> SQLTemp.sql
echo "-- * UpdtP305.csv is records that will update into PolyTerri and will be"  >> SQLTemp.sql
echo "-- *  RecordType P in Terr305_SCBridge."  >> SQLTemp.sql
echo "-- * UpdtM305.csv is records that will update into MultiMail and will be"  >> SQLTemp.sql
echo "-- *  RecordType M in Terr305_SCBridge."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--.shell \"rm '$pathbase/RawData/SCPA/SCPA-Downloads/Terr305/Updt305.csv' \""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db'"  >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo "	|| '/SCPADiff_05-28.db'"  >> SQLTemp.sql
echo "	AS db19;"  >> SQLTemp.sql
echo "ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo "	|| '/Terr305/Terr305_SC.db'"  >> SQLTemp.sql
echo "	AS db11;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS db11.Diffs0528;"  >> SQLTemp.sql
echo "CREATE TABLE db11.Diffs0528 "  >> SQLTemp.sql
echo "( \"Account#\" TEXT, Owner1 TEXT, Owner2 TEXT, Owner3 TEXT, "  >> SQLTemp.sql
echo "MailingAddress1 TEXT, MailingAddress2 TEXT, MailingCity TEXT, "  >> SQLTemp.sql
echo "MailingState TEXT, MailingZipCode TEXT, MailingCountry TEXT, "  >> SQLTemp.sql
echo "\"SitusAddress(PropertyAddress)\" TEXT, SitusCity TEXT, SitusState TEXT, "  >> SQLTemp.sql
echo "SitusZipCode TEXT, PropertyUseCode TEXT, Neighborhood TEXT, "  >> SQLTemp.sql
echo "Subdivision TEXT, TaxingDistrict TEXT, Municipality TEXT, "  >> SQLTemp.sql
echo "WaterfrontCode TEXT, \"HomesteadExemption(YESorNO)\" TEXT, "  >> SQLTemp.sql
echo "HomesteadExemptionGrantYear TEXT, Zoning TEXT, ParcelDesc1 TEXT, "  >> SQLTemp.sql
echo "ParcelDesc2 TEXT, ParcelDesc3 TEXT, ParcelDesc4 TEXT, "  >> SQLTemp.sql
echo "\"Pool(YESorNO)\" TEXT, TotalLivingUnits TEXT, \"LandAreaS.F.\" TEXT, "  >> SQLTemp.sql
echo "GrossBldgArea TEXT, LivingArea TEXT, Bedrooms TEXT, Baths TEXT, "  >> SQLTemp.sql
echo "HalfBaths TEXT, YearBuilt TEXT, LastSaleAmount TEXT, LastSaleDate TEXT, "  >> SQLTemp.sql
echo "LastSaleQualCode TEXT, PriorSaleAmount TEXT, PriorSaleDate TEXT, "  >> SQLTemp.sql
echo "PriorSaleQualCode TEXT, JustValue TEXT, AssessedValue TEXT, "  >> SQLTemp.sql
echo "TaxableValue TEXT, LinktoPropertyDetailPage TEXT, ValueDataSource TEXT, "  >> SQLTemp.sql
echo "ParcelCharacteristicsData TEXT, Status TEXT, DownloadDate TEXT,"  >> SQLTemp.sql
echo "PRIMARY KEY (\"Account#\") );"  >> SQLTemp.sql
echo "WITH a AS (SELECT OwningParcel AS PropID FROM db11.Terr305_SCBridge"  >> SQLTemp.sql
echo " WHERE PropID IS NOT '-')"  >> SQLTemp.sql
echo "INSERT OR IGNORE INTO db11.Diffs0528"  >> SQLTemp.sql
echo "SELECT * FROM db19.Diff0528 "  >> SQLTemp.sql
echo "WHERE \"Account#\" IN (SELECT PropID FROM a);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * write 1 record to Updt305M.csv if count > 0;"  >> SQLTemp.sql
echo ".output '$pathbase/RawData/SCPA/SCPA-Downloads/Terr305/Updt305M.csv'"  >> SQLTemp.sql
echo ".mode csv"  >> SQLTemp.sql
echo ".separator ,"  >> SQLTemp.sql
echo "SELECT * FROM Diffs0528"  >> SQLTemp.sql
echo "limit 1;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "--***** END FlagSCUpdate *****;"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  FlagSCUpdate complete."
~/sysprocs/LOGMSG "  FlagSCUpdate complete."
#end proc
