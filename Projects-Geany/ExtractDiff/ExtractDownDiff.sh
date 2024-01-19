#!/bin/bash
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 12/12/22.	wmk.
#	Usage. bash ExtractDownDiff.sh
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
  ~/sysprocs/LOGMSG "  ExtractDownDiff - initiated from Make"
  echo "  ExtractDownDiff - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ExtractDownDiff - initiated from Terminal"
  echo "  ExtractDownDiff - initiated from Terminal"
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

#preamble.s - Preamble shell for setting up SQL converted shell.
#	11/21/22.	wmk.
#
# Modification History.
# ---------------------
# 11/21/22.	wmk.	*codebase support.
# Legacy mods.
# 4/17/21.	wmk.	original code.
# 6/19/21.	wmk.	folderbase added.
# 9/30/21.	wmk.	ensure 01 13 04 04 used throughout.
# 3/19/22.	wmk.	HOME changed to USER in host test.
#
# sed modifies this file morphing it into preamble.sh with the
# following substitutions:
#P1=$1		# 01
#P2=$2		# 13
#P3=$3		# 04
#P4=$4		# 04
#-- * 	ENVIRONMENT var dependencies.
#-- *    the following are set in the preamble.sh
#-- *	folderbase = base path of host system for Territories
#-- *	SCPA_CSV = SCPA-Public_01-13.csv with 01 13 substituted
#-- *	SCPA_DB1 = SCPA_01-13.db with 01 13 substituted 
#-- * 	SCPA_TBL1 = Data0113 with 0113 substituted
#-- *	SCPA_DB2 = SCPA_04-04.db with 04 04 substituted
#-- *	SCPA_TBL2 = Data0404 with 0404 substituted
#-- *	DIFF_DB = SCPADiff_04-04.db with 04 04 substituted
#-- *	DIFF_TBL = Diff0404 with 04 04 substituted
#-- *	M2D2 = "04-04" with 04 04 substituted
#-- *
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else
  export folderbase="$HOME"
 fi
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories/FL/SARA/86777
fi
if [ -z "$codebase" ];then
 export codebase=$folderbase/GitHub/TerritoriesCB
fi
export SCPA_CSV="SCPA-Public_01-13.csv"
export SCPA_DB1="SCPA_01-13.db"
export SCPA_TBL1="Data0113"
export SCPA_DB2="SCPA_04-04.db"
export SCPA_TBL2="Data0404"
export DIFF_DB="SCPADiff_04-04.db"
export DIFF_TBL="Diff0404"
export M2D2="04-04"
echo "SCPA_DB1 : '$SCPA_DB1'"
# end preamble.s
echo "-- ** ExtractDownDiff **********"  > SQLTemp.sql
echo "-- *	5/1/22.	wmk."  >> SQLTemp.sql
echo "-- *-----------------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Extract_DownDiff - Extract sale-date homestead changed  records ."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	SCPADiff0404.db - as main, new differences database to populate"  >> SQLTemp.sql
echo "-- *	SCPA_0113.db - as db14, SCPA (old) full download from date 01/13/2010"  >> SQLTemp.sql
echo "-- *		Data0113 - SCPA download records from date 01/13/2010"  >> SQLTemp.sql
echo "-- *	SCPA_0404.db - as db15, SCPA (new) full download from date 01/13/2010"  >> SQLTemp.sql
echo "-- *		Data0404 - SCPA download records from date 04/04/2010"  >> SQLTemp.sql
echo "-- *	AuxSCPAData - as db8, auxiliary data for SCPA records"  >> SQLTemp.sql
echo "-- *		AcctsNVen - table of property IDs in N Venice territory"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * 	ENVIRONMENT var dependencies."  >> SQLTemp.sql
echo "-- *    the following are set in the preamble.sh"  >> SQLTemp.sql
echo "-- *	folderbase = base path of host system for Territories"  >> SQLTemp.sql
echo "-- *	SCPA_DB1 = SCPA_01-13.db with 01 13 substituted "  >> SQLTemp.sql
echo "-- * 	SCPA_TBL1 = Data0113 with 0113 substituted"  >> SQLTemp.sql
echo "-- *	SCPA_DB2 = SCPA_04-04.db with 04 04 substituted"  >> SQLTemp.sql
echo "-- *	DIFF_DB = SCPADiff_04-04.db with 04 04 substituted"  >> SQLTemp.sql
echo "-- *	DIFF_TBL = Diff0404 with 04 04 substituted"  >> SQLTemp.sql
echo "-- *	M2D2 = \"04-04\" with 04 04 substituted"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * exit DB and table results."  >> SQLTemp.sql
echo "-- *	SCPADiff_0404.db - as main populated with tables and records"  >> SQLTemp.sql
echo "-- *		Diffmmdd - table of new records that differ from previous"  >> SQLTemp.sql
echo "-- *		  download; date stamped with yyyy-04-04 in records"  >> SQLTemp.sql
echo "-- *		DiffAccts - (see BuildDiffAccts) reserved for recording"  >> SQLTemp.sql
echo "-- *		  account#s and territory IDs of affected territories"  >> SQLTemp.sql
echo "-- *		MissingParcels - (see BuildMissingParcels) reserved for"  >> SQLTemp.sql
echo "-- *		  recording full records of differences downloaded where"  >> SQLTemp.sql
echo "-- *		  parcel not in either PolyTerri/TerrProps or MultiMail/SplitProps"  >> SQLTemp.sql
echo "-- *		DNCNewOwners - (see BuildDNCNewOwners) reserved for"  >> SQLTemp.sql
echo "-- *		  recording full records of differences downloaded where"  >> SQLTemp.sql
echo "-- *		  where new download changes property info for parcels that"  >> SQLTemp.sql
echo "-- *		  are listed as DoNotCall in TerrIDData.db."  >> SQLTemp.sql
echo "-- *		"  >> SQLTemp.sql
echo "-- *	junk.db as main, scratch database to catch changes"  >> SQLTemp.sql
echo "-- *		DownDiff (TEMP) - extracted sale-date-changed SCPA records"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 5/1/22.	wmk.	modified to use Terr86777.db/AllAccts in place"  >> SQLTemp.sql
echo "-- *			 of AuxSCPAData/NVenAccts; INNER JOIN code reinstated."  >> SQLTemp.sql
echo "-- * 4/26/22.	wmk.	completed .sql ExtractDownDiff0404.sql migrated"  >> SQLTemp.sql
echo "-- *			 into /86777/..ExtractDiff project."  >> SQLTemp.sql
echo "-- * Legacy mods."  >> SQLTemp.sql
echo "-- * 9/30/20.	wmk.	original query."  >> SQLTemp.sql
echo "-- * 12/3/20.	wmk.	modified to use generic SCPA_01-13.db as db14 for"  >> SQLTemp.sql
echo "-- *			 old SCPA full download, SCPA_04-04.db as db15 for"  >> SQLTemp.sql
echo "-- *			 new SCPA full download to facilitate conversion"  >> SQLTemp.sql
echo "-- *			 to QSCPADiff.sh shell script"  >> SQLTemp.sql
echo "-- * 2/3/21.	wmk.	comments updated; mod to use SCPA_0113.db as db14"  >> SQLTemp.sql
echo "-- *			 SCPA_0404.db as db15 as new name support; all"  >> SQLTemp.sql
echo "-- *			 dbs assumed in SCPA-Downloads folder"  >> SQLTemp.sql
echo "-- * 4/17/21.	wmk.	extracted from QSCPADiff.sql to ExtractDownDiff.sql"  >> SQLTemp.sql
echo "-- *			 and modified for use as shell query; references"  >> SQLTemp.sql
echo "-- *			 to SC download databases reformatted to match"  >> SQLTemp.sql
echo "-- *			 pattern SCPA_mm-dd.db; pragma references commented"  >> SQLTemp.sql
echo "-- *			 out; DownloadDate field eliminated from CREATE for"  >> SQLTemp.sql
echo "-- *			 new Diff0404 table, and added via ALTER TABLE "  >> SQLTemp.sql
echo "-- *			 after loading difference records."  >> SQLTemp.sql
echo "-- * 6/19/21.	wmk.	multihost support modifications."  >> SQLTemp.sql
echo "-- * 7/22/21.	wmk.	temporary modification since 0404 field names"  >> SQLTemp.sql
echo "-- *				 re trimmed (automatic import), but 0113 field"  >> SQLTemp.sql
echo "-- *			 names are not...!!!"  >> SQLTemp.sql
echo "-- * 9/30/21.	wmk.	'Last Sale Date' corrected to 'LastSaleDate';"  >> SQLTemp.sql
echo "-- *			 'Homestead Exemption' corrected to"  >> SQLTemp.sql
echo "-- *			 'HomesteadExemption(YESorNO)'; compress all field"  >> SQLTemp.sql
echo "-- *			 names for consistency."  >> SQLTemp.sql
echo "-- * 1/2/22.	wmk.	DownloadDate field included in CREATE."  >> SQLTemp.sql
echo "-- * 2/7/22.	wmk.	db8, db14, db15 qualifiers added to INSERT query."  >> SQLTemp.sql
echo "-- * 3/19/22.	wmk.	manually edited for SCPA_03-19.db, SCPA_04-04.db"  >> SQLTemp.sql
echo "-- *			 Data0319, Data0404."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. This query differences 2 SCPA downloads into a new database"  >> SQLTemp.sql
echo "-- * SCPADiff_04-04.db with table Diffmmdd. The records in Diffmmdd are"  >> SQLTemp.sql
echo "-- * all those records in SCPA_04-04.db that differ from records in "  >> SQLTemp.sql
echo "-- * SCPA_01-13.db.;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".cd '$pathbase/RawData/SCPA/SCPA-Downloads'"  >> SQLTemp.sql
echo ".open 'SCPADiff_04-04.db'"  >> SQLTemp.sql
echo ".shell echo \"Differencing SCPA_01-13.db with SCPA_04-04.db..may take a few minutes\""  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/DB-Dev/Terr86777.db'"  >> SQLTemp.sql
echo "  AS db2;"  >> SQLTemp.sql
echo "--SELECT tbl_name FROM db8.sqlite_master;"  >> SQLTemp.sql
echo "--pragma db2.table_info(AllAccts); "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/DB-Dev/AuxSCPAData.db'"  >> SQLTemp.sql
echo "  AS db8;"  >> SQLTemp.sql
echo "--SELECT tbl_name FROM db8.sqlite_master;"  >> SQLTemp.sql
echo "--pragma db8.table_info(AcctsAll); "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads/SCPA_01-13.db'"  >> SQLTemp.sql
echo " AS db14;"  >> SQLTemp.sql
echo "--  SELECT tbl_name FROM db14.sqlite_master;"  >> SQLTemp.sql
echo "--  PRAGMA db14.table_info($SCPA_TBL1);"  >> SQLTemp.sql
echo " "  >> SQLTemp.sql
echo "-- *	SCPA_0404.db - as db15, SCPA (new) full download from date 01/13"  >> SQLTemp.sql
echo "-- *		Data0404 - SCPA download records from date 04/04 any uear"  >> SQLTemp.sql
echo "ATTACH '$pathbase'"  >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads/SCPA_04-04.db'"  >> SQLTemp.sql
echo " AS db15;"  >> SQLTemp.sql
echo "--  SELECT tbl_name FROM db15.sqlite_master;"  >> SQLTemp.sql
echo "--  PRAGMA db15.table_info($SCPA_TBL2);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- create empty Diff0404 table in New database ...;"  >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Diff0404;"  >> SQLTemp.sql
echo "CREATE TABLE Diff0404"  >> SQLTemp.sql
echo " ( \"Account#\" TEXT NOT NULL, "  >> SQLTemp.sql
echo " \"Owner1\" TEXT, \"Owner2\" TEXT, \"Owner3\" TEXT, "  >> SQLTemp.sql
echo " \"MailingAddress1\" TEXT, \"MailingAddress2\" TEXT, "  >> SQLTemp.sql
echo " \"MailingCity\" TEXT, \"MailingState\" TEXT, "  >> SQLTemp.sql
echo " \"MailingZipCode\" TEXT, \"MailingCountry\" TEXT,"  >> SQLTemp.sql
echo " \"SitusAddress(PropertyAddress)\" TEXT,"  >> SQLTemp.sql
echo " \"SitusCity\" TEXT, \"SitusState\" TEXT, \"SitusZipCode\" TEXT, "  >> SQLTemp.sql
echo " \"PropertyUseCode\" TEXT, \"Neighborhood\" TEXT, "  >> SQLTemp.sql
echo " \"Subdivision\" TEXT, \"TaxingDistrict\" TEXT, "  >> SQLTemp.sql
echo " \"Municipality\" TEXT, \"WaterfrontCode\" TEXT, "  >> SQLTemp.sql
echo " \"HomesteadExemption\" TEXT, "  >> SQLTemp.sql
echo " \"HomesteadExemptionGrantYear\" TEXT, "  >> SQLTemp.sql
echo " \"Zoning\" TEXT, \"ParcelDesc1\" TEXT, \"ParcelDesc2\" TEXT, "  >> SQLTemp.sql
echo " \"ParcelDesc3\" TEXT, \"ParcelDesc4\" TEXT, "  >> SQLTemp.sql
echo " \"Pool(YESorNO)\" TEXT, \"TotalLivingUnits\" TEXT, "  >> SQLTemp.sql
echo " \"LandAreaS.F.\" TEXT, \"GrossBldgArea\" TEXT, "  >> SQLTemp.sql
echo " \"LivingArea\" TEXT, \"Bedrooms\" TEXT, \"Baths\" TEXT, "  >> SQLTemp.sql
echo " \"HalfBaths\" TEXT, \"YearBuilt\" TEXT, "  >> SQLTemp.sql
echo " \"LastSaleAmount\" TEXT, "  >> SQLTemp.sql
echo " \"LastSaleDate\" TEXT, \"LastSaleQualCode\" TEXT, "  >> SQLTemp.sql
echo " \"PriorSaleAmount\" TEXT, \"PriorSaleDate\" TEXT, "  >> SQLTemp.sql
echo " \"PriorSaleQualCode\" TEXT, \"JustValue\" TEXT, "  >> SQLTemp.sql
echo " \"AssessedValue\" TEXT, \"TaxableValue\" TEXT, "  >> SQLTemp.sql
echo " \"LinktoPropertyDetailPage\" TEXT, "  >> SQLTemp.sql
echo " \"ValueDataSource\" TEXT, "  >> SQLTemp.sql
echo " \"ParcelCharacteristicsData\" TEXT, \"Status\" TEXT,"  >> SQLTemp.sql
echo " DownloadDate TEXT,"  >> SQLTemp.sql
echo "  PRIMARY KEY(\"Account#\") );"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- with db8, db14, db15 attached, the following will insert the newer rows "  >> SQLTemp.sql
echo "-- where Last Sale Date or Homestead Exemption changed;"  >> SQLTemp.sql
echo "INSERT OR IGNORE INTO Diff0404"  >> SQLTemp.sql
echo " SELECT Data0404.* FROM db15.Data0404"  >> SQLTemp.sql
echo "   INNER JOIN db14.Data0113"  >> SQLTemp.sql
echo "    ON db15.Data0404.\"Account#\" = db14.Data0113.\"Account#\""  >> SQLTemp.sql
echo "   INNER JOIN db8.AcctsAll"  >> SQLTemp.sql
echo "    ON db15.Data0404.\"Account#\" = db8.AcctsAll.Account"  >> SQLTemp.sql
echo "	WHERE db15.Data0404.\"LastSaleDate\" <> db14.Data0113.\"LastSaleDate\""  >> SQLTemp.sql
echo "	    OR db15.Data0404.\"HomesteadExemption(YESORNO)\""  >> SQLTemp.sql
echo "	       <> db14.Data0113.\"HomesteadExemption(YESorNO)\""  >> SQLTemp.sql
echo "	ORDER BY db14.Data0113.\"Account#\";"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "--ALTER TABLE $DIFF_TBL ADD COLUMN DownloadDate TEXT;"  >> SQLTemp.sql
echo "--UPDATE $DIFF_TBL"  >> SQLTemp.sql
echo "--SET DownloadDate = \"2022-\" || \"$04-26\";"  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
echo "  ExtractDownDiff complete."
~/sysprocs/LOGMSG "  ExtractDownDiff complete."
#end proc
