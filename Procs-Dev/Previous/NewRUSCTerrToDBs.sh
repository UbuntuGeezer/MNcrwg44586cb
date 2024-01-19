#!/bin/bash
# NewRUSCTerrToDBs.sh - Integrate Terrxxx_RUBridge/Terrxxx_SCBridge into main dbs.
#	5/2/22.	wmk.
#
# bash NewRUSCTerrToDBs terrid
#
#	terrid = territory id for which to integrate new records
#
#	Entry Dependencies.
#   ~/SCPA/SCPA-Downloads/Terrxxx/Terrxxx_SC.db has new SC records
#	~/RefUSA/RefUSA-Downloads/Terrxxx/Terrxxx_RU.db has new RefUSA records
#
#	Exit Results.
#	<files/paths, etc. affected by proc>
#
# * Modification History.
# * ---------------------
# * 5/2/22.		wmk.	*pathbase* support.
# * Legacy mods.
#	11/21/20.	wmk.	original shell.
#	2/4/21.		wmk.	add DelPending IS NOT 1 conditional to INSERTs.
#	3/1/21.		wmk.	add territory ID to log messages; bug fix where
#						MultiMail records not checked for DelPending.
#	3/8/21.		wmk.	adapted for use by "make".
#	4/7/21.		wmk.	one-line log messages.
# 	5/27/21.	wmk		modified for use with either home or Kay's system;
#					    folderbase vars added.
#	5/30/21.	wmk.	modified for multihost system support.
#	6/7/21.		wmk.	bug fixes; equality check ($)HOME, TEMP_PATH 
#						ensured set.
#	6/17/21.	wmk.	multihost code generalized.
#	7/20/21.	wmk.	superfluous "s removed;
#	10/22/21.	wmk.	switch to extract SC records first to improve sorting.
#	Notes.
# jumpto function definition
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}
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
 system_log=$folderbase/ubuntu/SystemLog.txt
fi
TEMP_PATH=$HOME/temp
#
P1=$1
#date +%T >> $system_log #
#echo "  NewRUSCTerrToDBs $P1 (Dev) started." >> $system_log #
bash ~/sysprocs/LOGMSG "  NewRUSCTerrToDBs $P1 (Dev) started."
echo "  NewRUSCTerrToDBs (Dev) started."
if [ -z $P1 ]; then
  echo "  Territory id not specified... NewRUSCTerrToDBs abandoned." >> $system_log #
  echo -e "Territory id must be specified...\nNewRUSCTerrToDBs abandoned."
  exit 1
fi
TID=$P1
if [ 1  -eq 1 ]; then
TST_STR="(test)"
else
TST_STR=""
fi
touch $TEMP_PATH/scratchfile
error_counter=0
pushd ./ >> $TEMP_PATH/scratchfile
cd $pathbase/Procs-Dev
#procbodyhere
echo "-- SQLTemp.sql - NewRUSCTerrToDBs - - Integrate" > SQLTemp.sql
echo "-- Terr$TID_RUBridge/Terr$TID_SCBridge into main dbs." >> SQLTemp.sql
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".shell touch SQLTrace.txt" >> SQLTemp.sql
DB_END="_RU.db"
DB_END2="_SC.db"
TBL_END1="_RUBridge"
TBL_END2="_SCBridge"
TBL_END3=""
DB_NAME="Terr$TID$DB_END"
DB_NAME2="Terr$TID$DB_END2"
TBL_NAME1="Terr$TID$TBL_END1"
TBL_NAME2="Terr$TID$TBL_END2"
TBL_NAME3="Terr$TID$TBL_END3"
#echo $DB_NAME
echo ".shell echo \"Opening ./Terr$TID/$DB_NAME\" | awk '{print \$1}' > SQLTrace.txt" >> SQLTemp.sql
echo ".open '$pathbase/DB-Dev/junk.db' " >> SQLTemp.sql
#
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo "||		'/DB-Dev/MultiMail.db'" >> SQLTemp.sql
echo " AS db3;" >> SQLTemp.sql
#
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo " ||		'/DB-Dev/PolyTerri.db'" >> SQLTemp.sql
echo "  AS db5;"  >> SQLTemp.sql
#
echo "ATTACH '$pathbase'" >> SQLTemp.sql
echo "||		'/DB-Dev/Terr86777.db' " >> SQLTemp.sql
echo " AS db2;" >> SQLTemp.sql
#
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './RawData/SCPA/SCPA-Downloads'" >> SQLTemp.sql
echo ".cd './Terr$TID'"  >> SQLTemp.sql
echo "ATTACH './$DB_NAME2' AS db11;" >> SQLTemp.sql
#
# change to RefUSA folder.
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './RawData/RefUSA/RefUSA-Downloads'" >> SQLTemp.sql
echo ".cd './Terr$TID'"  >> SQLTemp.sql
echo "ATTACH './$DB_NAME' AS db12;" >> SQLTemp.sql
#
echo ".cd '$pathbase'" >> SQLTemp.sql
#
#
echo ".cd '$pathbase'" >> SQLTemp.sql
echo ".cd './RawData/SCPA/SCPA-Downloads'" >> SQLTemp.sql
echo ".cd './Terr$TID'"  >> SQLTemp.sql
#-- * AddNewRUBridge - Add new records for RUBridge territory from download.
echo ".shell echo \"AddNewRUBridge - Add new records for RUBridge territory from download.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo ".shell echo \"Adding RU records to PolyTerri {TerrProps}\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "INSERT OR IGNORE INTO TerrProps" >> SQLTemp.sql
echo " SELECT OwningParcel, UnitAddress, Unit," >> SQLTemp.sql
echo " Resident1, Phone1, Phone2, \"RefUSA-Phone\"," >> SQLTemp.sql
echo " Subterritory, CongTerrID, DoNotCall, RSO," >> SQLTemp.sql
echo " \"Foreign\", RecordDate, SitusAddress, PropUse," >> SQLTemp.sql
echo " DelPending FROM db12.$TBL_NAME1" >> SQLTemp.sql
echo "WHERE RecordType IS \"P\"" >> SQLTemp.sql
echo "AND DelPending IS NOT 1" >> SQLTemp.sql
echo " ;" >> SQLTemp.sql
#
#echo "ATTACH './$DB_NAME2' AS db11;" >> SQLTemp.sql
#
#-- * AddNewSCBridge - Add new records for SCBridge territory from download.
echo ".shell echo \"Adding SC records to PolyTerri {TerrProps}\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
echo "INSERT OR IGNORE INTO TerrProps" >> SQLTemp.sql
echo " SELECT OwningParcel, UnitAddress, Unit," >> SQLTemp.sql
echo " Resident1, Phone1, Phone2," >> SQLTemp.sql
echo " \"RefUSA-Phone\"," >> SQLTemp.sql
echo " Subterritory, CongTerrID, DoNotCall, RSO," >> SQLTemp.sql
echo " \"Foreign\", RecordDate, SitusAddress, PropUse," >> SQLTemp.sql
echo " DelPending FROM db11.$TBL_NAME2" >> SQLTemp.sql
echo "WHERE RecordType IS \"P\"" >> SQLTemp.sql
echo "AND DelPending IS NOT 1" >> SQLTemp.sql
echo " ;" >> SQLTemp.sql
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi


#-- * InsertNewOwners - Insert new owner records from PropOwners.
echo ".shell echo \"Adding records to PolyTerri {PropOwners}\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql

echo "WITH a AS (SELECT DISTINCT OWNINGPARCEL, " >> SQLTemp.sql
echo "SITUSADDRESS, PROPUSE" >> SQLTemp.sql
echo " FROM db5.TERRPROPS" >> SQLTemp.sql
echo " WHERE CONGTERRID IS \"$TID\"" >> SQLTemp.sql
echo " AND" >> SQLTemp.sql
echo "  OWNINGPARCEL " >> SQLTemp.sql
echo "  NOT IN (SELECT OWNERPARCEL FROM db5.PROPOWNERS))" >> SQLTemp.sql
echo "INSERT OR REPLACE INTO PROPOWNERS" >> SQLTemp.sql
echo "( OwnerParcel, \"Area-CommonName\"," >> SQLTemp.sql
echo " Situs, ParcelCity, ParcelZip, Homestead," >> SQLTemp.sql
echo " PropertyUse, TerrID)" >> SQLTemp.sql
echo " SELECT  DISTINCT OwningParcel, \"Territory $TID\"," >> SQLTemp.sql
echo " SitusAddress, \"VENICE\", \"34285\",NULL," >> SQLTemp.sql
echo " NULL, \"$TID\" FROM a" >> SQLTemp.sql
echo " ;" >> SQLTemp.sql
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi
#
#-- * UpdateOwnersFields - update name, homestead, propuse in PropOwners.
echo ".shell echo \"Setting name, homestead and propuse in PropOwners.\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
#
echo "WITH a AS (SELECT \"SITUS ADDRESS (PROPERTY ADDRESS)\" AS SCSitus," >> SQLTemp.sql
echo "  \"ACCOUNT #\" AS Acct, \"Owner 1\" AS Owner," >> SQLTemp.sql
echo " \"Homestead Exemption\" AS SCHomestead," >> SQLTemp.sql
echo " \"Property Use Code\" AS PropUse" >> SQLTemp.sql
echo "  FROM db2.Terr86777 WHERE " >> SQLTemp.sql
echo "  Acct IN (SELECT OWNINGPARCEL" >> SQLTemp.sql
echo "  FROM db5.TERRPROPS WHERE CONGTERRID IS \"$TID\"))" >> SQLTemp.sql
echo "UPDATE PROPOWNERS" >> SQLTemp.sql
#echo " SET OWNERPARCEL = (SELECT Acct FROM a" >> SQLTemp.sql
#echo "     WHERE SCSitus" >> SQLTemp.sql
#echo "      IS  SITUS)," >> SQLTemp.sql
echo "  SET OWNERNAME1 = (SELECT Owner FROM a" >> SQLTemp.sql
echo "     WHERE SCSitus" >> SQLTemp.sql
echo "      IS  SITUS)," >> SQLTemp.sql
echo "HOMESTEAD = (SELECT SCHomestead FROM a" >> SQLTemp.sql
echo "     WHERE SCSitus" >> SQLTemp.sql
echo "      IS  SITUS)," >> SQLTemp.sql
echo "PROPERTYUSE = (SELECT PropUse FROM a" >> SQLTemp.sql
echo "     WHERE SCSitus" >> SQLTemp.sql
echo "      IS  SITUS)" >> SQLTemp.sql
echo "WHERE TERRID IS \"$TID\";" >> SQLTemp.sql
if [ 1 -eq 0 ]; then
  jumpto FinishSQL
fi

jumpto MultiMail
MultiMail:
# ********** now start on MultiMail.db adding new records ***********
#-- * AddNewSCBridge - Add new records for SCBridge territory from download.
echo ".shell echo \"Adding SC records to MultiMail {SplitProps}\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
#ATTACH '$pathbase'
#||		'/DB-Dev/MultiMail.db'
# AS db3;
#
#ATTACH '$pathbase'
# ||		'/RawData/SCPA/SCPA-Downloads/Terrxxx/Terrxxx_SC.db'
#  AS db11;
echo "-- *;" >> SQLTemp.sql
echo "INSERT OR IGNORE INTO SplitProps" >> SQLTemp.sql
echo " SELECT OwningParcel, UnitAddress, Unit," >> SQLTemp.sql
echo " Resident1, Phone1, Phone2, \"RefUSA-Phone\"," >> SQLTemp.sql
echo " Subterritory, CongTerrID, DoNotCall, RSO," >> SQLTemp.sql
echo " \"Foreign\", RecordDate, SitusAddress, PropUse," >> SQLTemp.sql
echo " DelPending FROM db11.$TBL_NAME2" >> SQLTemp.sql
echo "WHERE RecordType IS \"M\"" >> SQLTemp.sql
echo " AND DelPending IS NOT 1" >> SQLTemp.sql
echo " ;" >> SQLTemp.sql
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi
#-- * AddNewRUBridge - Add new MM records for RUBridge territory from download.
echo ".shell echo \"Adding RU records to MultiMail {SplitProps}\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
#ATTACH '$pathbase'
# ||		'/RawData/RefUSA/RefUSA-Downloads/Terr$TID/Terr$TID_RU.db'
#  AS db12;
#
echo "INSERT OR IGNORE INTO SplitProps" >> SQLTemp.sql
echo " SELECT OwningParcel, UnitAddress, Unit," >> SQLTemp.sql
echo " Resident1, Phone1, Phone2, \"RefUSA-Phone\"," >> SQLTemp.sql
echo " Subterritory, CongTerrID, DoNotCall, RSO," >> SQLTemp.sql
echo " \"Foreign\", RecordDate, SitusAddress, PropUse," >> SQLTemp.sql
echo " DelPending FROM db12.$TBL_NAME1" >> SQLTemp.sql
echo "WHERE RecordType IS \"M\"" >> SQLTemp.sql
echo " AND DelPending IS NOT 1" >> SQLTemp.sql
echo " ;" >> SQLTemp.sql
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi
#-- * InsertNewSplitOwners - Insert new owner records from SplitProps.
echo ".shell echo \"Adding new owner records to MultiMail {SplitOwners}\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql

#ATTACH '$pathbase'
#     ||'/DB/MultiMail.db'
#as db3;
 
echo "WITH a AS (SELECT DISTINCT OWNINGPARCEL, " >> SQLTemp.sql
echo "SITUSADDRESS, PROPUSE" >> SQLTemp.sql
echo " FROM db3.SPLITPROPS" >> SQLTemp.sql
echo " WHERE CONGTERRID IS \"$TID\"" >> SQLTemp.sql
echo " AND" >> SQLTemp.sql
echo "  OWNINGPARCEL " >> SQLTemp.sql
echo "  NOT IN (SELECT OWNERPARCEL FROM db3.SPLITOWNERS))" >> SQLTemp.sql
echo "INSERT OR REPLACE INTO SPLITOWNERS" >> SQLTemp.sql
echo "( OwnerParcel, \"Area-CommonName\"," >> SQLTemp.sql
echo " Situs, ParcelCity, ParcelZip, \"#Units\"," >> SQLTemp.sql
echo " PropertyUse, TerrID)" >> SQLTemp.sql
echo " SELECT  DISTINCT OwningParcel, \"Territory $TID\"," >> SQLTemp.sql
echo " SitusAddress, \"VENICE\", \"34285\",NULL," >> SQLTemp.sql
echo " NULL, \"$TID\" FROM a" >> SQLTemp.sql
echo " ;" >> SQLTemp.sql
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi


#-- * UpdateOwnersName_units_propuse - update name, homestead, propuse in SplitOwners.
echo ".shell echo \"Updating name, homestead, propuse in {SplitOwners}\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql

#ATTACH '$pathbase'
#||		'/DB-Dev/Terr86777.db' 
# AS db2;
 
#ATTACH '$pathbase'
#||		'/DB/MultiMail.db'
# AS db3;

echo "WITH a AS (SELECT \"ACCOUNT #\" AS Acct, \"Owner 1\" AS Owner," >> SQLTemp.sql
echo " \"Total Living Units\" AS TotUnits, \"Property Use Code\" AS SCPropUse" >> SQLTemp.sql
echo "  FROM db2.Terr86777 WHERE " >> SQLTemp.sql
echo "  Acct IN (SELECT DISTINCT OWNINGPARCEL" >> SQLTemp.sql
echo "  FROM db3.SPLITPROPS WHERE CONGTERRID IS \"$TID\"))" >> SQLTemp.sql
echo "UPDATE SPLITOWNERS" >> SQLTemp.sql
echo " SET " >> SQLTemp.sql
echo "OWNERNAME1 = (SELECT Owner FROM a" >> SQLTemp.sql
echo "     WHERE Acct IS  OWNERPARCEL)," >> SQLTemp.sql
echo "\"#UNITS\" = (SELECT TotUnits FROM a" >> SQLTemp.sql
echo "     WHERE Acct IS  OWNERPARCEL)," >> SQLTemp.sql
echo "\"PROPERTYUSE\" = (SELECT SCPropUse FROM a" >> SQLTemp.sql
echo "	WHERE Acct IS  OWNERPARCEL)" >> SQLTemp.sql
echo "WHERE TERRID IS \"$TID\"" >> SQLTemp.sql
echo "AND \"#units\" ISNULL;" >> SQLTemp.sql
if [  1 -eq 0 ]; then
  jumpto EndProc
fi
#
#-- * UpdateUnit_Homestead - Update overloaded Unit/Homestead field..
echo ".shell echo \"Updating Unit/Homestead field in {SplitOwners}\" | awk '{print \$1}' >> SQLTrace.txt" >> SQLTemp.sql
#
#ATTACH '$pathbase'
#||		'/DB-Dev/Terr86777.db' 
# AS db2;
#
#ATTACH '$pathbase'
#||		'/DB/MultiMail.db'
# AS db3;
#
echo "WITH a AS (SELECT \"ACCOUNT #\" AS Acct, " >> SQLTemp.sql
echo "	\"HOMESTEAD EXEMPTION\" AS SCHomestead," >> SQLTemp.sql
echo "			\"TOTAL LIVING UNITS\" AS TotUnits FROM db2.Terr86777 " >> SQLTemp.sql
echo "			WHERE Acct" >> SQLTemp.sql
echo "			 IN (SELECT OWNERPARCEL FROM db3.SPLITOWNERS" >> SQLTemp.sql
echo "			     WHERE TERRID IS \"$TID\"))" >> SQLTemp.sql
echo "UPDATE SplitOwners " >> SQLTemp.sql
echo "SET \"#Units\" =" >> SQLTemp.sql
echo "  CASE " >> SQLTemp.sql
echo "  WHEN \"#UNITS\" IS 1 " >> SQLTemp.sql
echo "     THEN (SELECT SCHomestead FROM a " >> SQLTemp.sql
echo "            WHERE Acct IS OWNERPARCEL)" >> SQLTemp.sql
echo "  ELSE \"#Units\" " >> SQLTemp.sql
echo "  END" >> SQLTemp.sql
echo "WHERE TerrID IS \"$TID\";" >> SQLTemp.sql
# endprocbody
if [ 1 -eq 0 ]; then
   jumpto EndProc
fi
#
jumpto FinishSQL
FinishSQL:
echo ".quit" >> SQLTemp.sql
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi
#
jumpto TrySQL
TrySQL:
sqlite3 < SQLTemp.sql
jumpto NewestShell9
NewestShell9:

jumpto EndProc
EndProc:
popd >> $TEMP_PATH/scratchfile
#date +%T >> $system_log #
#echo "  NewRUSCTerrToDBs $P1 (Dev) $TST_STR complete." >> $system_log #
bash ~/sysprocs/LOGMSG "  NewRUSCTerrToDBs $P1 (Dev) $TST_STR complete."
echo "  NewRUSCTerrToDBs $P1 (Dev) $TST_STR complete."
