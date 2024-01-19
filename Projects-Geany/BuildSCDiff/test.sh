#/bin/bash
echo " ** test.sh out-of-date **";exit 1
echo " ** test.sh out-of-date **";exit 1
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
#hdrAnySQL.sh - Any .sql to .sh shell source.
# 4/5/21.	wmk.	07:31
#	Usage. bash <filename>.sh
#		
# Dependencies.
#	(leave line count the same)
#
#
# Modification History.
# ---------------------
# 4/6/21.	wmk.	original shell (template)
#jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n \"/$label:/{:a;n;p;ba};\" $0 | grep -v ':$')
    eval \"$cmd\"
    exit
}
P1=$1
TID=$P1
TN=\"Terr\"
if [ -z \"$system_log\" ]; then
  system_log=\"/media/ubuntu/Windows/Users/Bill/ubuntu/SystemLog.txt\"
  TEMP_PATH=\"/home/ubuntu/temp\"
  ~/sysprocs/LOGMSG \"  <filename> - initiated from Make\"
else
  ~/sysprocs/LOGMSG \"  <filename> - initiated from Terminal\"
  echo \"  <filename> - initiated from Terminal\"
fi 
#	Environment vars:
NAME_BASE=\"Terr\"
SC_DB=\"_SC.db\"
RU_DB=\"_RU.db\"
SC_SUFFX=\"_SCBridge\"
RU_SUFFX=\"_RUBridge\"

#proc body here
pushd ./ > $TEMP_PATH/bitbucket.txt
#preamble.s - Preamble shell for setting up SQL converted shell.
#	4/17/21.	wmk.
#
# sed modifies this file morphing it into preamble.sh with the
# following substitutions:
#P1=$1		# m1
#P2=$2		# d1
#P3=$3		# m2
#P4=$4		# d2
#-- * 	ENVIRONMENT var dependencies.
#-- *    the following are set in the preamble.sh
#-- *	SCPA_DB1 = SCPA_m1-d1.db with m1 d1 substituted 
#-- * 	SCPA_TBL1 = Datam1d1 with m1d1 substituted
#-- *	SCPA_DB2 = SCPA_m2-d2.db with m2 d2 substituted
#-- *	SCPA_TBL2 = Datam2d2 with m2d2 substituted
#-- *	DIFF_DB = SCPADiff_m2-d2.db with m2 d2 substituted
#-- *	DIFF_TBL = Diffm2d2 with m2 d2 substituted
#-- *	M2D2 = \"m2-d2\" with m2 d2 substituted
#-- *
SCPA_DB1=\"SCPA_m1-d1.db\"
SCPA_TBL1=\"Datam1d1\"
SCPA_DB2=\"SCPA_m2-d2.db\"
SCPA_TBL2=\"Datam2d2\"
DIFF_DB=\"SCPADiff_m2-d2.db\"
DIFF_TBL=\"Diffm2d2\"
M2D2=\"m2-d2\"
echo \"SCPA_DB1 : '$SCPA_DB1'\"
#
echo \"-- ** Extract_DownDiff **********\" > SQLTemp.sql
echo \"-- *	4/17/21.	wmk.\" >> SQLTemp.sql
echo \"-- *-----------------------------\" >> SQLTemp.sql
echo \"-- *\" >> SQLTemp.sql
echo \"-- * Extract_DownDiff - Extract sale-date homestead changed  records .\" >> SQLTemp.sql
echo \"-- *\" >> SQLTemp.sql
echo \"-- * entry DB and table dependencies.\" >> SQLTemp.sql
echo \"-- *	SCPADiffm2d2.db - as main, new differences database to populate\" >> SQLTemp.sql
echo \"-- *	SCPA_m1d1.db - as db14, SCPA (old) full download from date m1/d1/2020\" >> SQLTemp.sql
echo \"-- *		Datam1d1 - SCPA download records from date m1/d1/2020\" >> SQLTemp.sql
echo \"-- *	SCPA_m2d2.db - as db15, SCPA (new) full download from date m1/d1/2020\" >> SQLTemp.sql
echo \"-- *		Datam2d2 - SCPA download records from date m2/d2/2020\" >> SQLTemp.sql
echo \"-- *	AuxSCPAData - as db8, auxiliary data for SCPA records\" >> SQLTemp.sql
echo \"-- *		AcctsNVen - table of property IDs in N Venice territory\" >> SQLTemp.sql
echo \"-- *\" >> SQLTemp.sql
echo \"-- * 	ENVIRONMENT var dependencies.\" >> SQLTemp.sql
echo \"-- *    the following are set in the preamble.sh\" >> SQLTemp.sql
echo \"-- *	SCPA_DB1 = SCPA_m1-d1.db with m1 d1 substituted \" >> SQLTemp.sql
echo \"-- * 	SCPA_TBL1 = Datam1d1 with m1d1 substituted\" >> SQLTemp.sql
echo \"-- *	SCPA_DB2 = SCPA_m2-d2.db with m2 d2 substituted\" >> SQLTemp.sql
echo \"-- *	DIFF_DB = SCPADiff_m2-d2.db with m2 d2 substituted\" >> SQLTemp.sql
echo \"-- *	DIFF_TBL = Diffm2d2 with m2 d2 substituted\" >> SQLTemp.sql
echo \"-- *	M2D2 = \"m2-d2\" with m2 d2 substituted\" >> SQLTemp.sql
echo \"-- *\" >> SQLTemp.sql
echo \"-- * exit DB and table results.\" >> SQLTemp.sql
echo \"-- *	SCPADiff_m2d2.db - as main populated with tables and records\" >> SQLTemp.sql
echo \"-- *		Diffmmdd - table of new records that differ from previous\" >> SQLTemp.sql
echo \"-- *		  download; date stamped with yyyy-m2-d2 in records\" >> SQLTemp.sql
echo \"-- *		DiffAccts - (see BuildDiffAccts) reserved for recording\" >> SQLTemp.sql
echo \"-- *		  account#s and territory IDs of affected territories\" >> SQLTemp.sql
echo \"-- *		MissingParcels - (see BuildMissingParcels) reserved for\" >> SQLTemp.sql
echo \"-- *		  recording full records of differences downloaded where\" >> SQLTemp.sql
echo \"-- *		  parcel not in either PolyTerri/TerrProps or MultiMail/SplitProps\" >> SQLTemp.sql
echo \"-- *		DNCNewOwners - (see BuildDNCNewOwners) reserved for\" >> SQLTemp.sql
echo \"-- *		  recording full records of differences downloaded where\" >> SQLTemp.sql
echo \"-- *		  where new download changes property info for parcels that\" >> SQLTemp.sql
echo \"-- *		  are listed as DoNotCall in TerrIDData.db.\" >> SQLTemp.sql
echo \"-- *		\" >> SQLTemp.sql
echo \"-- *	junk.db as main, scratch database to catch changes\" >> SQLTemp.sql
echo \"-- *		DownDiff (TEMP) - extracted sale-date-changed SCPA records\" >> SQLTemp.sql
echo \"-- *\" >> SQLTemp.sql
echo \"-- * Modification History.\" >> SQLTemp.sql
echo \"-- * ---------------------\" >> SQLTemp.sql
echo \"-- * 9/30/20.	wmk.	original query\" >> SQLTemp.sql
echo \"-- * 12/3/20.	wmk.	modified to use generic SCPA_m1-d1.db as db14 for\" >> SQLTemp.sql
echo \"-- *					old SCPA full download, SCPA_m2-d2.db as db15 for\" >> SQLTemp.sql
echo \"-- *					new SCPA full download to facilitate conversion\" >> SQLTemp.sql
echo \"-- *					to QSCPADiff.sh shell script\" >> SQLTemp.sql
echo \"-- * 2/3/21.	wmk.	comments updated; mod to use SCPA_m1d1.db as db14\" >> SQLTemp.sql
echo \"-- *					SCPA_m2d2.db as db15 as new name support; all\" >> SQLTemp.sql
echo \"-- *					dbs assumed in SCPA-Downloads folder\" >> SQLTemp.sql
echo \"-- * 4/17/21.	wmk.	extracted from QSCPADiff.sql to ExtractDownDiff.sql\" >> SQLTemp.sql
echo \"-- *					and modified for use as shell query; references\" >> SQLTemp.sql
echo \"-- *					to SC download databases reformatted to match\" >> SQLTemp.sql
echo \"-- *					pattern SCPA_mm-dd.db; pragma references commented\" >> SQLTemp.sql
echo \"-- *					out; DownloadDate field eliminated from CREATE for\" >> SQLTemp.sql
echo \"-- *					new Diffm2d2 table, and added via ALTER TABLE \" >> SQLTemp.sql
echo \"-- *					after loading difference records.\" >> SQLTemp.sql
echo \"-- *\" >> SQLTemp.sql
echo \"-- * Notes. This query differences 2 SCPA downloads into a new database\" >> SQLTemp.sql
echo \"-- * SCPADiff_m2-d2.db with table Diffmmdd. The records in Diffmmdd are\" >> SQLTemp.sql
echo \"-- * all those records in SCPA_m2-d2.db that differ from records in \" >> SQLTemp.sql
echo \"-- * SCPA_m1-d1.db.\" >> SQLTemp.sql
echo \"\" >> SQLTemp.sql
echo \".cd '/media/ubuntu/Windows/Users/Bill/Territories/RawData/SCPA/SCPA-Downloads'\" >> SQLTemp.sql
echo \".open 'SCPADiff_m2-d2.db'\" >> SQLTemp.sql
echo \"\" >> SQLTemp.sql
echo \"ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'\" >> SQLTemp.sql
echo \" ||		'/DB-Dev/AuxSCPAData.db'\" >> SQLTemp.sql
echo \"  AS db8;\" >> SQLTemp.sql
echo \"--SELECT tbl_name FROM db8.sqlite_master;\" >> SQLTemp.sql
echo \"--pragma db8.table_info(AcctsNVen); \" >> SQLTemp.sql
echo \"\" >> SQLTemp.sql
echo \"ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'\" >> SQLTemp.sql
echo \" ||		'/RawData/SCPA/SCPA-Downloads/$SCPA_DB1'\" >> SQLTemp.sql
echo \" AS db14;\" >> SQLTemp.sql
echo \"--  SELECT tbl_name FROM db14.sqlite_master;\" >> SQLTemp.sql
echo \"--  PRAGMA db14.table_info($SCPA_TBL1);\" >> SQLTemp.sql
echo \" \" >> SQLTemp.sql
echo \"-- *	SCPA_m2d2.db - as db15, SCPA (new) full download from date m1/d1\" >> SQLTemp.sql
echo \"-- *		Datam2d2 - SCPA download records from date m2/d2 any uear\" >> SQLTemp.sql
echo \"ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'\" >> SQLTemp.sql
echo \" ||		'/RawData/SCPA/SCPA-Downloads/$SCPA_DB2'\" >> SQLTemp.sql
echo \" AS db15;\" >> SQLTemp.sql
echo \"--  SELECT tbl_name FROM db15.sqlite_master;\" >> SQLTemp.sql
echo \"--  PRAGMA db15.table_info($SCPA_TBL2);\" >> SQLTemp.sql
echo \"\" >> SQLTemp.sql
echo \"\" >> SQLTemp.sql
echo \"-- create empty Diffm2d2 table in New database ...\" >> SQLTemp.sql
echo \"DROP TABLE IF EXISTS $DIFF_TBL;\" >> SQLTemp.sql
echo \"CREATE TEMP TABLE \"$DIFF_TBL\"\" >> SQLTemp.sql
echo \" ( \"Account #\" TEXT NOT NULL, \"Owner 1\" TEXT, \"Owner 2\" TEXT,\" >> SQLTemp.sql
echo \" \"Owner 3\" TEXT, \"Mailing Address 1\" TEXT, \"Mailing Address 2\" TEXT, \"Mailing City\" TEXT,\" >> SQLTemp.sql
echo \" \"Mailing State\" TEXT, \"Mailing Zip Code\" TEXT, \"Mailing Country\" TEXT,\" >> SQLTemp.sql
echo \" \"Situs Address (Property Address)\" TEXT, \"Situs City\" TEXT, \"Situs State\" TEXT,\" >> SQLTemp.sql
echo \" \"Situs Zip Code\" TEXT, \"Property Use Code\" TEXT, \"Neighborhood\" TEXT, \"Subdivision\" TEXT,\" >> SQLTemp.sql
echo \" \"Taxing District\" TEXT, \"Municipality\" TEXT, \"Waterfront Code\" TEXT,\" >> SQLTemp.sql
echo \" \"Homestead Exemption\" TEXT, \"Homestead Exemption Grant Year\" TEXT, \"Zoning\" TEXT,\" >> SQLTemp.sql
echo \" \"Parcel Desc 1\" TEXT, \"Parcel Desc 2\" TEXT, \"Parcel Desc 3\" TEXT, \"Parcel Desc 4\" TEXT,\" >> SQLTemp.sql
echo \" \"Pool (YES or NO)\" TEXT, \"Total Living Units\" TEXT, \"Land Area S. F.\" TEXT,\" >> SQLTemp.sql
echo \" \"Gross Bldg Area\" TEXT, \"Living Area\" TEXT, \"Bedrooms\" TEXT, \"Baths\" TEXT,\" >> SQLTemp.sql
echo \" \"Half Baths\" TEXT, \"Year Built\" TEXT, \"Last Sale Amount\" TEXT, \"Last Sale Date\" TEXT,\" >> SQLTemp.sql
echo \" \"Last Sale Qual Code\" TEXT, \"Prior Sale Amount\" TEXT, \"Prior Sale Date\" TEXT,\" >> SQLTemp.sql
echo \" \"Prior Sale Qual Code\" TEXT, \"Just Value\" TEXT, \"Assessed Value\" TEXT,\" >> SQLTemp.sql
echo \" \"Taxable Value\" TEXT, \"Link to Property Detail Page\" TEXT, \"Value Data Source\" TEXT,\" >> SQLTemp.sql
echo \" \"Parcel Characteristics Data\" TEXT, \"Status\" TEXT,\" >> SQLTemp.sql
echo \" PRIMARY KEY(\"Account #\") );\" >> SQLTemp.sql
echo \"\" >> SQLTemp.sql
echo \"-- with db1, db2, db3 attached, the following will insert the newer rows \" >> SQLTemp.sql
echo \"-- where Last Sale Date or Homestead Exemption changed;\" >> SQLTemp.sql
echo \"INSERT OR IGNORE INTO $DIFF_TBL\" >> SQLTemp.sql
echo \" SELECT SCPA_TBL1.* FROM $SCPA_TBL1\" >> SQLTemp.sql
echo \"   INNER JOIN SCPA_TBL1\" >> SQLTemp.sql
echo \"    ON SCPA_TBL2.\"Account #\" = SCPA_TBL1.\"Account #\"\" >> SQLTemp.sql
echo \"   INNER JOIN AcctsNVen\" >> SQLTemp.sql
echo \"    ON SCPA_TBL2.\"Account #\" = AcctsNVen.\"Account\"\" >> SQLTemp.sql
echo \"	WHERE SCPA_TBL2.\"Last Sale Date\" <> SCPA_TBL1.\"Last Sale Date\"\" >> SQLTemp.sql
echo \"	    OR SCPA_TBL2.\"Homestead Exemption (YES or NO)\"\" >> SQLTemp.sql
echo \"	       <> SCPA_TBL1.\"Homestead Exemption (YES or NO)\"\" >> SQLTemp.sql
echo \"	ORDER BY \"Account #\";\" >> SQLTemp.sql
echo \"\" >> SQLTemp.sql
echo \"ALTER TABLE $DIFF_TBL ADD COLUMN DownloadDate TEXT;\" >> SQLTemp.sql
echo \"UPDATE $DIFF_TBL\" >> SQLTemp.sql
echo \"SET DownloadDate = \"2021-\" || \"$M2D2\";\" >> SQLTemp.sql
echo \"	\" >> SQLTemp.sql
echo \"-- ** END Extract_DownDiff **********\" >> SQLTemp.sql
echo \"\" >> SQLTemp.sql

#end proc body

# conditional to skip SQL execution.
if [ not = true ]; then
 jumpto EndProc
fi
jumpto DoSQL
DoSQL:
sqlite3 < SQLTemp.sql
#
jumpto EndProc
EndProc:
popd >> $TEMP_PATH/bitbucket.txt
#notify-send \"FixXXXRU.sh\" \"Terr XXX PostProcessing complete. $P1\"
echo \"  <filename> PostProcessing complete.\"
#end proc
