-- * AddSpecSCBridgeRec.psq - AddSpecSCBridgeRec.sql template.
-- *	5/24/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/24/23.	wmk.	original code; adapted from AddSCBridgeRec.psq.
-- * Legacy mods.
-- * 9/22/21.	wmk.	original code.
-- * 6/18/22.	wmk.	*pathbase support; code changes for Terr86777.db.
-- * 3/12/23.	wmk.	db2 qualifier added to Terr86777 references.
-- *
-- * Notes. sed substitutes property id for w www, special-db 
-- * for v vvvv, and <terrid> for 802 within this query, writing the resultant to .sql.
-- *;

.open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/Aria.db'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
-- pragma db2.table_info(Terr86777);

-- code cloned from {SpecialSCdb}/SCSpecTerr_db.sql;
INSERT OR REPLACE INTO Spec_SCBridge
 SELECT "Account #",
  trim(SUBSTR("situs address (property address)",1,35)),
  SUBSTR("situs address (property address)",36),
  CASE
  WHEN LENGTH("Owner 3") > 0
   THEN "Owner 1" || ", " || "Owner 2" || ", " || "Owner 3"
  WHEN LENGTH("Owner 2") > 0
   THEN "Owner 1" || ", " || "Owner 2"
  ELSE "Owner 1"
  END, "",
  CASE 
  WHEN "Homestead Exemption" IS "YES" 
   THEN "*"
  ELSE ""
  END, "", "", '802', "", "", "", DownloadDate,
  "situs address (property address)",
  "Property Use Code", "", "" FROM db2.Terr86777
WHERE "Account #" IS '0391120115';

WITH a AS (SELECT Code, RType FROM db2.SCPropUse)
UPDATE Spec_SCBridge
SET RecordType =
CASE 
WHEN PropUse IN (SELECT Code FROM a) 
 THEN (SELECT RType FROM a
  WHERE Code IS PropUse)
ELSE RecordType
END
WHERE OwningParcel IS '0391120115';
.quit
-- End AddSpecSCBridgeRec;
