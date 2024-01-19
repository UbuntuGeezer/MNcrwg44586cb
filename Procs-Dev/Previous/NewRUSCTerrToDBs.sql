#procbodyhere
-- SQLTemp.sql - NewRUSCTerrToDBs - - Integrate
-- Terr$TID_RUBridge/Terr$TID_SCBridge into main dbs.
.cd '$pathbase'
.shell touch SQLTrace.txt
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
.shell echo "Opening ./Terr$TID/$DB_NAME" | awk '{print \$1}' > SQLTemp.sql
.open '$pathbase/DB-Dev/junk.db' 
#
ATTACH '$pathbase'
||		'/DB-Dev/MultiMail.db'
 AS db3;
#
ATTACH '$pathbase'
 ||		'/DB-Dev/PolyTerri.db'
  AS db5;
#
ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
 AS db2;
#
.cd '$pathbase'
.cd './RawData/SCPA/SCPA-Downloads'
.cd './Terr$TID'
ATTACH './$DB_NAME2' AS db11;
#
# change to RefUSA folder.
.cd '$pathbase'
.cd './RawData/RefUSA/RefUSA-Downloads'
.cd './Terr$TID'
ATTACH './$DB_NAME' AS db12;
#
.cd '$pathbase'
#
#
#-- * AddNewSCBridge - Add new records for SCBridge territory from download.
.shell echo "Adding SC records to PolyTerri {TerrProps}" | awk '{print \$1}' >> SQLTrace.txt
.cd '$pathbase'
.cd './RawData/SCPA/SCPA-Downloads'
.cd './Terr$TID'
#-- * AddNewRUBridge - Add new records for RUBridge territory from download.
.shell echo "AddNewRUBridge - Add new records for RUBridge territory from download." | awk '{print \$1}' >> SQLTrace.txt
.shell echo "Adding RU records to PolyTerri {TerrProps}" | awk '{print \$1}' >> SQLTrace.txt
INSERT OR IGNORE INTO TerrProps
 SELECT OwningParcel, UnitAddress, Unit,
 Resident1, Phone1, Phone2, "RefUSA-Phone",
 Subterritory, CongTerrID, DoNotCall, RSO,
 "Foreign", RecordDate, SitusAddress, PropUse,
 DelPending FROM $TBL_NAME1
WHERE RecordType IS "P"
AND DelPending IS NOT 1
 ;
#
#echo "ATTACH './$DB_NAME2' AS db11;
#
INSERT OR IGNORE INTO TerrProps
 SELECT OwningParcel, UnitAddress, Unit,
 Resident1, Phone1, Phone2,
 "RefUSA-Phone",
 Subterritory, CongTerrID, DoNotCall, RSO,
 "Foreign", RecordDate, SitusAddress, PropUse,
 DelPending FROM $TBL_NAME2
WHERE RecordType IS "P"
AND DelPending IS NOT 1
 ;
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi


#-- * InsertNewOwners - Insert new owner records from PropOwners.
.shell echo "Adding records to PolyTerri {PropOwners}" | awk '{print \$1}' >> SQLTrace.txt

WITH a AS (SELECT DISTINCT OWNINGPARCEL, 
SITUSADDRESS, PROPUSE
 FROM TERRPROPS
 WHERE CONGTERRID IS "$TID"
 AND
  OWNINGPARCEL 
  NOT IN (SELECT OWNERPARCEL FROM PROPOWNERS))
INSERT OR REPLACE INTO PROPOWNERS
( OwnerParcel, "Area-CommonName",
 Situs, ParcelCity, ParcelZip, Homestead,
 PropertyUse, TerrID)
 SELECT  DISTINCT OwningParcel, "Territory $TID",
 SitusAddress, "VENICE", "34285",NULL,
 NULL, "$TID" FROM a
 ;
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi
#
#-- * UpdateOwnersFields - update name, homestead, propuse in PropOwners.
.shell echo "Setting name, homestead and propuse in PropOwners." | awk '{print \$1}' >> SQLTrace.txt
#
WITH a AS (SELECT "SITUS ADDRESS (PROPERTY ADDRESS)" AS SCSitus,
  "ACCOUNT #" AS Acct, "Owner 1" AS Owner,
 "Homestead Exemption" AS SCHomestead,
 "Property Use Code" AS PropUse
  FROM Terr86777 WHERE 
  Acct IN (SELECT OWNINGPARCEL
  FROM TERRPROPS WHERE CONGTERRID IS "$TID"))
UPDATE PROPOWNERS
#echo " SET OWNERPARCEL = (SELECT Acct FROM a
#echo "     WHERE SCSitus
#echo "      IS  SITUS),
  SET OWNERNAME1 = (SELECT Owner FROM a
     WHERE SCSitus
      IS  SITUS),
HOMESTEAD = (SELECT SCHomestead FROM a
     WHERE SCSitus
      IS  SITUS),
PROPERTYUSE = (SELECT PropUse FROM a
     WHERE SCSitus
      IS  SITUS)
WHERE TERRID IS "$TID";
if [ 1 -eq 0 ]; then
  jumpto FinishSQL
fi

jumpto MultiMail
MultiMail:
# ********** now start on MultiMail.db adding new records ***********
#-- * AddNewSCBridge - Add new records for SCBridge territory from download.
.shell echo "Adding SC records to MultiMail {SplitProps}" | awk '{print \$1}' >> SQLTrace.txt
#ATTACH '$pathbase'
#||		'/DB-Dev/MultiMail.db'
# AS db3;
#
#ATTACH '$pathbase'
# ||		'/RawData/SCPA/SCPA-Downloads/Terrxxx/Terrxxx_SC.db'
#  AS db11;
-- *;
INSERT OR IGNORE INTO SplitProps
 SELECT OwningParcel, UnitAddress, Unit,
 Resident1, Phone1, Phone2, "RefUSA-Phone",
 Subterritory, CongTerrID, DoNotCall, RSO,
 "Foreign", RecordDate, SitusAddress, PropUse,
 DelPending FROM $TBL_NAME2
WHERE RecordType IS "M"
 AND DelPending IS NOT 1
 ;
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi
#-- * AddNewRUBridge - Add new MM records for RUBridge territory from download.
.shell echo "Adding RU records to MultiMail {SplitProps}" | awk '{print \$1}' >> SQLTrace.txt
#ATTACH '$pathbase'
# ||		'/RawData/RefUSA/RefUSA-Downloads/Terr$TID/Terr$TID_RU.db'
#  AS db12;
#
INSERT OR IGNORE INTO SplitProps
 SELECT OwningParcel, UnitAddress, Unit,
 Resident1, Phone1, Phone2, "RefUSA-Phone",
 Subterritory, CongTerrID, DoNotCall, RSO,
 "Foreign", RecordDate, SitusAddress, PropUse,
 DelPending FROM $TBL_NAME1
WHERE RecordType IS "M"
 AND DelPending IS NOT 1
 ;
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi
#-- * InsertNewSplitOwners - Insert new owner records from SplitProps.
.shell echo "Adding new owner records to MultiMail {SplitOwners}" | awk '{print \$1}' >> SQLTrace.txt

#ATTACH '$pathbase'
#     ||'/DB/MultiMail.db'
#as db3;
 
WITH a AS (SELECT DISTINCT OWNINGPARCEL, 
SITUSADDRESS, PROPUSE
 FROM SPLITPROPS
 WHERE CONGTERRID IS "$TID"
 AND
  OWNINGPARCEL 
  NOT IN (SELECT OWNERPARCEL FROM SPLITOWNERS))
INSERT OR REPLACE INTO SPLITOWNERS
( OwnerParcel, "Area-CommonName",
 Situs, ParcelCity, ParcelZip, "#Units",
 PropertyUse, TerrID)
 SELECT  DISTINCT OwningParcel, "Territory $TID",
 SitusAddress, "VENICE", "34285",NULL,
 NULL, "$TID" FROM a
 ;
if [ 1 -eq 0 ]; then
  jumpto EndProc
fi


#-- * UpdateOwnersName_units_propuse - update name, homestead, propuse in SplitOwners.
.shell echo "Updating name, homestead, propuse in {SplitOwners}" | awk '{print \$1}' >> SQLTrace.txt

#ATTACH '$pathbase'
#||		'/DB-Dev/Terr86777.db' 
# AS db2;
 
#ATTACH '$pathbase'
#||		'/DB/MultiMail.db'
# AS db3;

WITH a AS (SELECT "ACCOUNT #" AS Acct, "Owner 1" AS Owner,
 "Total Living Units" AS TotUnits, "Property Use Code" AS SCPropUse
  FROM Terr86777 WHERE 
  Acct IN (SELECT DISTINCT OWNINGPARCEL
  FROM SPLITPROPS WHERE CONGTERRID IS "$TID"))
UPDATE SPLITOWNERS
 SET 
OWNERNAME1 = (SELECT Owner FROM a
     WHERE Acct IS  OWNERPARCEL),
"#UNITS" = (SELECT TotUnits FROM a
     WHERE Acct IS  OWNERPARCEL),
"PROPERTYUSE" = (SELECT SCPropUse FROM a
	WHERE Acct IS  OWNERPARCEL)
WHERE TERRID IS "$TID"
AND "#units" ISNULL;
if [  1 -eq 0 ]; then
  jumpto EndProc
fi
#
#-- * UpdateUnit_Homestead - Update overloaded Unit/Homestead field..
.shell echo "Updating Unit/Homestead field in {SplitOwners}" | awk '{print \$1}' >> SQLTrace.txt
#
#ATTACH '$pathbase'
#||		'/DB-Dev/Terr86777.db' 
# AS db2;
#
#ATTACH '$pathbase'
#||		'/DB/MultiMail.db'
# AS db3;
#
WITH a AS (SELECT "ACCOUNT #" AS Acct, 
	"HOMESTEAD EXEMPTION" AS SCHomestead,
			"TOTAL LIVING UNITS" AS TotUnits FROM Terr86777 
			WHERE Acct
			 IN (SELECT OWNERPARCEL FROM SPLITOWNERS
			     WHERE TERRID IS "$TID"))
UPDATE SplitOwners 
SET "#Units" =
  CASE 
  WHEN "#UNITS" IS 1 
     THEN (SELECT SCHomestead FROM a 
            WHERE Acct IS OWNERPARCEL)
  ELSE "#Units" 
  END
WHERE TerrID IS "$TID";
# endprocbody
