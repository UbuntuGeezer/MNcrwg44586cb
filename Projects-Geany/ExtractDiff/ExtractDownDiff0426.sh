#!/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/23/22.	wmk.
#	Usage. bash ExtractDownDiff0426.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
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
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
if [ -z "$system_log" ]; then
  system_log=$folderbase/ubuntu/SystemLog.txt
  ~/sysprocs/LOGMSG "  ExtractDownDiff0426 - initiated from Make"
  echo "  ExtractDownDiff0426 - initiated from Make"
else
  ~/sysprocs/LOGMSG "  ExtractDownDiff0426 - initiated from Terminal"
  echo "  ExtractDownDiff0426 - initiated from Terminal"
fi 
TEMP_PATH=$HOME/temp
#	Environment vars:
if [ -z "$TODAY" ];then
 TODAY=2022-04-22
fi
NAME_BASE="Terr"
SC_DB="_SC.db"
RU_DB="_RU.db"
SC_SUFFX="_SCBridge"
RU_SUFFX="_RUBridge"

#procbodyhere

#preamble.s - Preamble shell for setting up SQL converted shell.
#	3/19/22.	wmk.
#
# Modification History.
# ---------------------
# 4/17/21.	wmk.	original code.
# 6/19/21.	wmk.	folderbase added.
# 9/30/21.	wmk.	ensure 03 19 04 26 used throughout.
# 3/19/22.	wmk.	HOME changed to USER in host test.
#
# sed modifies this file morphing it into preamble.sh with the
# following substitutions:
#P1=$1		# 03
#P2=$2		# 19
#P3=$3		# 04
#P4=$4		# 26
#-- * 	ENVIRONMENT var dependencies.
#-- *    the following are set in the preamble.sh
#-- *	folderbase = base path of host system for Territories
#-- *	SCPA_CSV = SCPA-Public_03-19.csv with 03 19 substituted
#-- *	SCPA_DB1 = SCPA_03-19.db with 03 19 substituted 
#-- * 	SCPA_TBL1 = Data0319 with 0319 substituted
#-- *	SCPA_DB2 = SCPA_04-26.db with 04 26 substituted
#-- *	SCPA_TBL2 = Data0426 with 0426 substituted
#-- *	DIFF_DB = SCPADiff_04-26.db with 04 26 substituted
#-- *	DIFF_TBL = Diff0426 with 04 26 substituted
#-- *	M2D2 = "04-26" with 04 26 substituted
#-- *
if [ -z "$folderbase" ];then
 if [ "$USER" == "ubuntu" ]; then
  export folderbase="/media/ubuntu/Windows/Users/Bill"
 else
  export folderbase="$HOME"
 fi
fi
if [ -z "$codebase" ];then
 codebase=$folderbase/GitHub/TerritoriesCB
fi
if [ -z "$pathbase" ];then
 export pathbase=$folderbase/Territories
fi
export SCPA_CSV="SCPA-Public_03-19.csv"
export SCPA_DB1="SCPA_03-19.db"
export SCPA_TBL1="Data0319"
export SCPA_DB2="SCPA_04-26.db"
export SCPA_TBL2="Data0426"
export DIFF_DB="SCPADiff_04-26.db"
export DIFF_TBL="Diff0426"
export M2D2="04-26"
echo "SCPA_DB1 : '$SCPA_DB1'"
# end preamble.s
echo "-- ** ExtractDownDiff0426 **********" > SQLTemp.sql
echo "-- *	5/1/22.	wmk." >> SQLTemp.sql
echo "-- *-----------------------------" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Extract_DownDiff - Extract sale-date homestead changed  records ." >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * entry DB and table dependencies." >> SQLTemp.sql
echo "-- *	SCPADiff0426.db - as main, new differences database to populate" >> SQLTemp.sql
echo "-- *	SCPA_0205.db - as db14, SCPA (old) full download from date 02/05/2020" >> SQLTemp.sql
echo "-- *		Data0205 - SCPA download records from date 02/05/2020" >> SQLTemp.sql
echo "-- *	SCPA_0426.db - as db15, SCPA (new) full download from date 02/05/2020" >> SQLTemp.sql
echo "-- *		Data0426 - SCPA download records from date 04/26/2020" >> SQLTemp.sql
echo "-- *	AuxSCPAData - as db8, auxiliary data for SCPA records" >> SQLTemp.sql
echo "-- *		AcctsNVen - table of property IDs in N Venice territory" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * 	ENVIRONMENT var dependencies." >> SQLTemp.sql
echo "-- *    the following are set in the preamble.sh" >> SQLTemp.sql
echo "-- *	folderbase = base path of host system for Territories" >> SQLTemp.sql
echo "-- *	SCPA_DB1 = SCPA_02-05.db with 02 05 substituted " >> SQLTemp.sql
echo "-- * 	SCPA_TBL1 = Data0205 with 0205 substituted" >> SQLTemp.sql
echo "-- *	SCPA_DB2 = SCPA_04-26.db with 04 26 substituted" >> SQLTemp.sql
echo "-- *	DIFF_DB = SCPADiff_04-26.db with 04 26 substituted" >> SQLTemp.sql
echo "-- *	DIFF_TBL = Diff0426 with 04 26 substituted" >> SQLTemp.sql
echo "-- *	M2D2 = \"04-26\" with 04 26 substituted" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * exit DB and table results." >> SQLTemp.sql
echo "-- *	SCPADiff_0426.db - as main populated with tables and records" >> SQLTemp.sql
echo "-- *		Diffmmdd - table of new records that differ from previous" >> SQLTemp.sql
echo "-- *		  download; date stamped with yyyy-04-26 in records" >> SQLTemp.sql
echo "-- *		DiffAccts - (see BuildDiffAccts) reserved for recording" >> SQLTemp.sql
echo "-- *		  account#s and territory IDs of affected territories" >> SQLTemp.sql
echo "-- *		MissingParcels - (see BuildMissingParcels) reserved for" >> SQLTemp.sql
echo "-- *		  recording full records of differences downloaded where" >> SQLTemp.sql
echo "-- *		  parcel not in either PolyTerri/TerrProps or MultiMail/SplitProps" >> SQLTemp.sql
echo "-- *		DNCNewOwners - (see BuildDNCNewOwners) reserved for" >> SQLTemp.sql
echo "-- *		  recording full records of differences downloaded where" >> SQLTemp.sql
echo "-- *		  where new download changes property info for parcels that" >> SQLTemp.sql
echo "-- *		  are listed as DoNotCall in TerrIDData.db." >> SQLTemp.sql
echo "-- *		" >> SQLTemp.sql
echo "-- *	junk.db as main, scratch database to catch changes" >> SQLTemp.sql
echo "-- *		DownDiff (TEMP) - extracted sale-date-changed SCPA records" >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Modification History." >> SQLTemp.sql
echo "-- * ---------------------" >> SQLTemp.sql
echo "-- * 5/1/22.	wmk.	modified to use Terr86777.db/AllAccts in place" >> SQLTemp.sql
echo "-- *			 of AuxSCPAData/NVenAccts; 02 05 forced to 02 05." >> SQLTemp.sql
echo "-- * 4/26/22.	wmk.	completed .sql ExtractDownDiff0426.sql migrated" >> SQLTemp.sql
echo "-- *			 into /86777/..ExtractDiff project." >> SQLTemp.sql
echo "-- * Legacy mods." >> SQLTemp.sql
echo "-- * 9/30/20.	wmk.	original query." >> SQLTemp.sql
echo "-- * 12/3/20.	wmk.	modified to use generic SCPA_02-05.db as db14 for" >> SQLTemp.sql
echo "-- *			 old SCPA full download, SCPA_04-26.db as db15 for" >> SQLTemp.sql
echo "-- *			 new SCPA full download to facilitate conversion" >> SQLTemp.sql
echo "-- *			 to QSCPADiff.sh shell script" >> SQLTemp.sql
echo "-- * 2/3/21.	wmk.	comments updated; mod to use SCPA_0205.db as db14" >> SQLTemp.sql
echo "-- *			 SCPA_0426.db as db15 as new name support; all" >> SQLTemp.sql
echo "-- *			 dbs assumed in SCPA-Downloads folder" >> SQLTemp.sql
echo "-- * 4/17/21.	wmk.	extracted from QSCPADiff.sql to ExtractDownDiff.sql" >> SQLTemp.sql
echo "-- *			 and modified for use as shell query; references" >> SQLTemp.sql
echo "-- *			 to SC download databases reformatted to match" >> SQLTemp.sql
echo "-- *			 pattern SCPA_mm-dd.db; pragma references commented" >> SQLTemp.sql
echo "-- *			 out; DownloadDate field eliminated from CREATE for" >> SQLTemp.sql
echo "-- *			 new Diff0426 table, and added via ALTER TABLE " >> SQLTemp.sql
echo "-- *			 after loading difference records." >> SQLTemp.sql
echo "-- * 6/19/21.	wmk.	multihost support modifications." >> SQLTemp.sql
echo "-- * 7/22/21.	wmk.	temporary modification since 0426 field names" >> SQLTemp.sql
echo "-- *				 re trimmed (automatic import), but 0205 field" >> SQLTemp.sql
echo "-- *			 names are not...!!!" >> SQLTemp.sql
echo "-- * 9/30/21.	wmk.	'Last Sale Date' corrected to 'LastSaleDate';" >> SQLTemp.sql
echo "-- *			 'Homestead Exemption' corrected to" >> SQLTemp.sql
echo "-- *			 'HomesteadExemption(YESorNO)'; compress all field" >> SQLTemp.sql
echo "-- *			 names for consistency." >> SQLTemp.sql
echo "-- * 1/2/22.	wmk.	DownloadDate field included in CREATE." >> SQLTemp.sql
echo "-- * 2/7/22.	wmk.	db8, db14, db15 qualifiers added to INSERT query." >> SQLTemp.sql
echo "-- * 3/19/22.	wmk.	manually edited for SCPA_03-19.db, SCPA_04-26.db" >> SQLTemp.sql
echo "-- *			 Data0319, Data0426." >> SQLTemp.sql
echo "-- *" >> SQLTemp.sql
echo "-- * Notes. This query differences 2 SCPA downloads into a new database" >> SQLTemp.sql
echo "-- * SCPADiff_04-26.db with table Diffmmdd. The records in Diffmmdd are" >> SQLTemp.sql
echo "-- * all those records in SCPA_04-26.db that differ from records in " >> SQLTemp.sql
echo "-- * SCPA_02-05.db.;" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo ".cd '$pathbase/RawData/SCPA/SCPA-Downloads'" >> SQLTemp.sql
echo ".open 'SCPADiff_04-26.db'" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/DB-Dev/Terr86777.db'" >> SQLTemp.sql
echo "  AS db2;" >> SQLTemp.sql
echo "--SELECT tbl_name FROM db8.sqlite_master;" >> SQLTemp.sql
echo "--pragma db2.table_info(AllAccts); " >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/DB-Dev/AuxSCPAData.db'" >> SQLTemp.sql
echo "  AS db8;" >> SQLTemp.sql
echo "--SELECT tbl_name FROM db8.sqlite_master;" >> SQLTemp.sql
echo "--pragma db8.table_info(AcctsNVen); " >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads/SCPA_02-05.db'" >> SQLTemp.sql
echo " AS db14;" >> SQLTemp.sql
echo "--  SELECT tbl_name FROM db14.sqlite_master;" >> SQLTemp.sql
echo "--  PRAGMA db14.table_info($SCPA_TBL1);" >> SQLTemp.sql
echo " " >> SQLTemp.sql
echo "-- *	SCPA_0426.db - as db15, SCPA (new) full download from date 02/05" >> SQLTemp.sql
echo "-- *		Data0426 - SCPA download records from date 04/26 any uear" >> SQLTemp.sql
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads/SCPA_04-26.db'" >> SQLTemp.sql
echo " AS db15;" >> SQLTemp.sql
echo "--  SELECT tbl_name FROM db15.sqlite_master;" >> SQLTemp.sql
echo "--  PRAGMA db15.table_info($SCPA_TBL2);" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- create empty Diff0426 table in New database ...;" >> SQLTemp.sql
echo "DROP TABLE IF EXISTS Diff0426;" >> SQLTemp.sql
echo "CREATE TABLE Diff0426" >> SQLTemp.sql
echo " ( \"Account#\" TEXT NOT NULL, " >> SQLTemp.sql
echo " \"Owner1\" TEXT, \"Owner2\" TEXT, \"Owner3\" TEXT, " >> SQLTemp.sql
echo " \"MailingAddress1\" TEXT, \"MailingAddress2\" TEXT, " >> SQLTemp.sql
echo " \"MailingCity\" TEXT, \"MailingState\" TEXT, " >> SQLTemp.sql
echo " \"MailingZipCode\" TEXT, \"MailingCountry\" TEXT," >> SQLTemp.sql
echo " \"SitusAddress(PropertyAddress)\" TEXT," >> SQLTemp.sql
echo " \"SitusCity\" TEXT, \"SitusState\" TEXT, \"SitusZipCode\" TEXT, " >> SQLTemp.sql
echo " \"PropertyUseCode\" TEXT, \"Neighborhood\" TEXT, " >> SQLTemp.sql
echo " \"Subdivision\" TEXT, \"TaxingDistrict\" TEXT, " >> SQLTemp.sql
echo " \"Municipality\" TEXT, \"WaterfrontCode\" TEXT, " >> SQLTemp.sql
echo " \"HomesteadExemption\" TEXT, " >> SQLTemp.sql
echo " \"HomesteadExemptionGrantYear\" TEXT, " >> SQLTemp.sql
echo " \"Zoning\" TEXT, \"ParcelDesc1\" TEXT, \"ParcelDesc2\" TEXT, " >> SQLTemp.sql
echo " \"ParcelDesc3\" TEXT, \"ParcelDesc4\" TEXT, " >> SQLTemp.sql
echo " \"Pool(YESorNO)\" TEXT, \"TotalLivingUnits\" TEXT, " >> SQLTemp.sql
echo " \"LandAreaS.F.\" TEXT, \"GrossBldgArea\" TEXT, " >> SQLTemp.sql
echo " \"LivingArea\" TEXT, \"Bedrooms\" TEXT, \"Baths\" TEXT, " >> SQLTemp.sql
echo " \"HalfBaths\" TEXT, \"YearBuilt\" TEXT, " >> SQLTemp.sql
echo " \"LastSaleAmount\" TEXT, " >> SQLTemp.sql
echo " \"LastSaleDate\" TEXT, \"LastSaleQualCode\" TEXT, " >> SQLTemp.sql
echo " \"PriorSaleAmount\" TEXT, \"PriorSaleDate\" TEXT, " >> SQLTemp.sql
echo " \"PriorSaleQualCode\" TEXT, \"JustValue\" TEXT, " >> SQLTemp.sql
echo " \"AssessedValue\" TEXT, \"TaxableValue\" TEXT, " >> SQLTemp.sql
echo " \"LinktoPropertyDetailPage\" TEXT, " >> SQLTemp.sql
echo " \"ValueDataSource\" TEXT, " >> SQLTemp.sql
echo " \"ParcelCharacteristicsData\" TEXT, \"Status\" TEXT," >> SQLTemp.sql
echo " DownloadDate TEXT," >> SQLTemp.sql
echo "  PRIMARY KEY(\"Account#\") );" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "-- with db2, db14, db15 attached, the following will insert the newer rows " >> SQLTemp.sql
echo "-- where Last Sale Date or Homestead Exemption changed;" >> SQLTemp.sql
echo "INSERT OR IGNORE INTO Diff0426" >> SQLTemp.sql
echo " SELECT Data0426.* FROM db15.Data0426" >> SQLTemp.sql
echo "   INNER JOIN db14.Data0205" >> SQLTemp.sql
echo "    ON db15.Data0426.\"Account#\" = db14.Data0205.\"Account#\"" >> SQLTemp.sql
echo "   INNER JOIN db2.AllAccts" >> SQLTemp.sql
echo "    ON db15.Data0426.\"Account#\" = db2.AllAccts.\"Account\"" >> SQLTemp.sql
echo "	WHERE db15.Data0426.\"LastSaleDate\" <> db14.Data0205.\"LastSaleDate\"" >> SQLTemp.sql
echo "	    OR db15.Data0426.\"HomesteadExemption(YESORNO)\"" >> SQLTemp.sql
echo "	       <> db14.Data0205.\"HomesteadExemption(YESorNO)\"" >> SQLTemp.sql
echo "	ORDER BY db14.Data0205.\"Account#\";" >> SQLTemp.sql
echo "" >> SQLTemp.sql
echo "--ALTER TABLE $DIFF_TBL ADD COLUMN DownloadDate TEXT;" >> SQLTemp.sql
echo "--UPDATE $DIFF_TBL" >> SQLTemp.sql
echo "--SET DownloadDate = \"2022-\" || \"$04-26\";" >> SQLTemp.sql
echo ".quit" >> SQLTemp.sql

#endprocbody - changed from end proc body 12/3/21 for awk reversal.
# jumpto references removed 9/6/21.
sqlite3 < SQLTemp.sql
if [ "$USER" != "vncwmk3" ];then
 notify-send "ExtractDownDiff0426.sh" "ExtractDownDiff0426 processing complete. $P1"
fi
echo "  ExtractDownDiff0426 complete."
~/sysprocs/LOGMSG "  ExtractDownDiff0426 complete."
#end proc
