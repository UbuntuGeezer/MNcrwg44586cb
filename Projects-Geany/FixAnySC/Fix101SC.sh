#/bin/bash
# 9/23/22.    wmk.   (automated) CB *codebase env var support.
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
#hdrFixXXXsc.sh - Fix RU records territory Any postprocessor.
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
#FixXXXsc_1.sh - Fix RU records territory XXX postprocessor preamble.
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
# 6/27/21.	wmk
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
#	Usage. bash FixXXXsc.sh
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
#		
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
# Dependencies.
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
#	FixXXX_SC.db exists in SCPA-Downloads/FixXXX folder
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
#	VeniceNTerritory.db exists in DB-Dev folder
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
#
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
# Modification History.
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
# ---------------------
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
# 3/15/21.	wmk.	original shell (template)
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
# 5/29/21.	wmk.	add code for multihost support.
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
# 6/19/21.	wmk.	bug fix (%)folderbase reference; multihost generalized.
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
# 6/27/21.	wmk.	separated from hdrFixXXXSC.sh; multihost generalized.
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
#jumpto function definition
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
function jumpto
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
{
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
    label=$1
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
    eval "$cmd"
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
    exit
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
}
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
P1=$1
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
if [ "$HOME" = "/home/ubuntu" ]; then
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
 folderbase=/media/ubuntu/Windows/Users/Bill
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
else 
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
 folderbase=$HOME
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
fi
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
if [ -z "$system_log" ]; then
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
  system_log=$folderbase/ubuntu/SystemLog.txt
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
  TEMP_PATH="$HOME/temp"
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
  ~/sysprocs/LOGMSG "  FixXXXsc - initiated from Make"
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
else
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
  ~/sysprocs/LOGMSG "  FixXXXsc - initiated from Terminal"
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
  echo "  FixXXXsc - initiated from Terminal"
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
fi 
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
#proc body here
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
pushd ./ > $TEMP_PATH/bitbucket.txt
echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."

echo "   Fix101SC initiated from make."
~/sysprocs/LOGMSG "   Fix101SC initiated from make."
echo "   Fix101SC initiated from make."
echo "--Fix101SC.sql - Fix SC records territory 101."  > SQLTemp.sql
echo "--	5/16/21.	wmk."  >> SQLTemp.sql
echo "--"  >> SQLTemp.sql
echo "-- Modification History."  >> SQLTemp.sql
echo "-- ---------------------"  >> SQLTemp.sql
echo "--*  4/19/21.	wmk.	original code."  >> SQLTemp.sql
echo "-- * 5/16/21.	wmk.	updated to match RU directions."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes. 849 LAGUNA is 2 units A,B special case."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * subquery list."  >> SQLTemp.sql
echo "-- * --------------"  >> SQLTemp.sql
echo "-- * AttachDBs - Attach required databases."  >> SQLTemp.sql
echo "-- * FiX101SC - Fix SC records territory 101."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** AttachDBs **********"  >> SQLTemp.sql
echo "-- *	5/16/21.	wmk."  >> SQLTemp.sql
echo "-- *---------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * AttachDBs - Attach required databases."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	junk.db - as main, junk database so can use dbxx ATTACHes"  >> SQLTemp.sql
echo "-- *	VeniceNTerritory.db - as db2, SCPA data for NV territory"  >> SQLTemp.sql
echo "-- *		NVenAll - SCPA property records"  >> SQLTemp.sql
echo "-- *	AuxSCPAData - as db8, auxiliary data for SCPA records"  >> SQLTemp.sql
echo "-- *		SitusDups - table of ambiguous situs addresses with account #s"  >> SQLTemp.sql
echo "-- *		SitusConv - situs conversion table unitaddress <-> scpa situs"  >> SQLTemp.sql
echo "-- *		AddrXcpt - address exceptions"  >> SQLTemp.sql
echo "-- *	Terr101_SC.db - as db11, new territory records from SCPA polygon"  >> SQLTemp.sql
echo "-- *		Terr101_SCBridge - Bridge formatted records extracted from SCPA"  >> SQLTemp.sql
echo "-- *			for territory 101"  >> SQLTemp.sql
echo "-- *	Terr101_RU.db - as db12, new territory records from RefUSA polygon"  >> SQLTemp.sql
echo "-- *		Terr101_RUBridge - sorted Bridge formatted records extracted "  >> SQLTemp.sql
echo "-- *			from RefUSA polygon (see Terr101_RUPoly)"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * junk as main;"  >> SQLTemp.sql
echo ".open '/media/ubuntu/Windows/Users/Bill/Territories/DB-Dev/junk.db'"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'"  >> SQLTemp.sql
echo "||		'/DB-Dev/VeniceNTerritory.db' "  >> SQLTemp.sql
echo " AS db2;"  >> SQLTemp.sql
echo "--SELECT tbl_name FROM db2.sqlite_master "  >> SQLTemp.sql
echo "-- WHERE type is \"table\";"  >> SQLTemp.sql
echo "--pragma db2.table_info(NVenAll);"  >> SQLTemp.sql
echo " "  >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'"  >> SQLTemp.sql
echo " ||		'/DB-Dev/AuxSCPAData.db'"  >> SQLTemp.sql
echo "  AS db8;"  >> SQLTemp.sql
echo "--SELECT tbl_name FROM db8.sqlite_master;"  >> SQLTemp.sql
echo "--pragma db8.table_info(AddrXcpt); "  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'"  >> SQLTemp.sql
echo " ||		'/RawData/SCPA/SCPA-Downloads/Terr101/Terr101_SC.db'"  >> SQLTemp.sql
echo "  AS db11;"  >> SQLTemp.sql
echo "--  PRAGMA db11.table_info(Terr101_SCBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "ATTACH '/media/ubuntu/Windows/Users/Bill/Territories'"  >> SQLTemp.sql
echo " ||		'/RawData/RefUSA/RefUSA-Downloads/Terr101/Terr101_RU.db'"  >> SQLTemp.sql
echo "  AS db12;"  >> SQLTemp.sql
echo "--  PRAGMA db12.table_info(Terr101_RUBridge);"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** END AttachDBs **********;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- ** FiX101SC **********"  >> SQLTemp.sql
echo "-- *	5/16/21.	wmk."  >> SQLTemp.sql
echo "-- *---------------------"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * FixX101SC - Fix SC records territory 101."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Entry DB and table dependencies."  >> SQLTemp.sql
echo "-- *	junk.db - as main, junk database so can use dbxx ATTACHes"  >> SQLTemp.sql
echo "-- *	Terr101_SC.db - as db11, new territory records from SCPA polygon"  >> SQLTemp.sql
echo "-- *		Terr101_SCBridge - Bridge formatted records extracted from SCPA"  >> SQLTemp.sql
echo "-- *			for territory 101"  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Exit DB and table results."  >> SQLTemp.sql
echo "-- *	Terr101_SC.db - as db11, new territory records from SCPA polygon"  >> SQLTemp.sql
echo "-- *		Terr101_SCBridge - Bridge records fixed UnitAddress fields"  >> SQLTemp.sql
echo "-- *		  to match RU UnitAddress fields."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Modification History."  >> SQLTemp.sql
echo "-- * ---------------------"  >> SQLTemp.sql
echo "-- * 4/19/21.	wmk.	original code;"  >> SQLTemp.sql
echo "-- * 5/16/21.	wmk.	updated to match RU directions."  >> SQLTemp.sql
echo "-- *"  >> SQLTemp.sql
echo "-- * Notes."  >> SQLTemp.sql
echo "-- *;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * DBs attached above;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * eliminate excess unit info from Laguna;"  >> SQLTemp.sql
echo "UPDATE Terr101_SCBridge"  >> SQLTemp.sql
echo "SET Unit ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN LENGTH(Unit) > 3"  >> SQLTemp.sql
echo " THEN SUBSTR(Unit, 1, INSTR(Unit, \" \")-1 )"  >> SQLTemp.sql
echo "ELSE Unit"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo "WHERE UnitAddress LIKE \"995   LAGUNA%\";"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * ensure N suffix on The Esplanade;"  >> SQLTemp.sql
echo "UPDATE Terr101_SCBridge"  >> SQLTemp.sql
echo "SET UnitAddress ="  >> SQLTemp.sql
echo "CASE "  >> SQLTemp.sql
echo "WHEN SUBSTR(UnitAddress,LENGTH(UnitAddress)-1,2) IS NOT \" N\""  >> SQLTemp.sql
echo " THEN TRIM(UnitAddress) || \" N\""  >> SQLTemp.sql
echo "ELSE UnitAddress"  >> SQLTemp.sql
echo "END"  >> SQLTemp.sql
echo "WHERE UnitAddress LIKE \"%THE ESPLANADE%\";"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo "-- * ensure M record type on 849 LAGUNA;"  >> SQLTemp.sql
echo "UPDATE Terr101_SCBridge"  >> SQLTemp.sql
echo "SET RecordType = \"M\""  >> SQLTemp.sql
echo "WHERE UnitAddress LIKE \"849   LAGUNA%\";"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
echo ".quit"  >> SQLTemp.sql
echo "-- ** END FiX101SC **********;"  >> SQLTemp.sql
echo ""  >> SQLTemp.sql
