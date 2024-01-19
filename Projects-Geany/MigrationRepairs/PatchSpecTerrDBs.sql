-- * PatchSpecTerrDBs.psq/sql - Patch SC Special territory databases .
-- * 5/10/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 5/10/23.	wmk.	original code.
-- *
-- * Notes. PatchSpecTerrDBs fills in the Resident1, Phone2 and RecordDate
-- * fields in Terr139_SC.db and Spec139_SC.db.a
-- *;
.open '$pathbase/DB-Dev/junk.txt'
ATTACH '$pathbase/DB-Dev/Terr86777.db'
 AS db2;
ATTACH '$pathbase/$scpath/Terr139/Terr139_SC.db'
 AS db11;
ATTACH '$pathbase/$scpath/Terr139/Spec139_SC.db'
 AS db21;
 
-- * fill in Terr139_SC.db records;
WITH a AS (SELECT OwningParcel PropID FROM db11.Terr139_SCBridge),
b AS (SELECT "Account #" Acct, DownloadDate DwnldDt,
 CASE WHEN "Homestead Exemption" IS 'YES'
  THEN '*'
 ELSE ''
 END Hstead,
 CASE WHEN LENGTH("Owner 3") > 0
  THEN "Owner 1" || ", " || "Owner 2" || "Owner 3"
 WHEN LENGTH("Owner 2") > 0
  THEN "Owner 1" || ", " || "Owner 2"
 ELSE "Owner 1"
 END WhosThere
 FROM db2.Terr86777
 WHERE Acct IN (SELECT PropID FROM a))
UPDATE Terr139_SCBridge
SET Resident1 =
CASE WHEN OwningParcel IN (SELECT Acct FROM b)
 THEN (SELECT WhosThere FROM b
  WHERE Acct IS OwningParcel)
ELSE Resident1
END,
Phone2 =
CASE WHEN OwningParcel IN (SELECT Acct FROM b)
 THEN (SELECT Hstead FROM b
  WHERE Acct IS OwningParcel)
ELSE Phone2
END,
RecordDate =
CASE WHEN OwningParcel IN (SELECT Acct FROM b)
 THEN (SELECT DwnldDt FROM b
  WHERE Acct IS OwningParcel)
ELSE RecordDate
END
;

-- * now fill in Spec139_DB records;
WITH a AS (SELECT OwningParcel PropID FROM db21.Spec_SCBridge),
b AS (SELECT "Account #" Acct, DownloadDate DwnldDt,
 CASE WHEN "Homestead Exemption" IS 'YES'
  THEN '*'
 ELSE ''
 END Hstead,
 CASE WHEN LENGTH("Owner 3") > 0
  THEN "Owner 1" || ", " || "Owner 2" || "Owner 3"
 WHEN LENGTH("Owner 2") > 0
  THEN "Owner 1" || ", " || "Owner 2"
 ELSE "Owner 1"
 END WhosThere
 FROM db2.Terr86777
 WHERE Acct IN (SELECT PropID FROM a))
UPDATE db21.Spec_SCBridge
SET Resident1 =
CASE WHEN OwningParcel IN (SELECT Acct FROM b)
 THEN (SELECT WhosThere FROM b
  WHERE Acct IS OwningParcel)
ELSE Resident1
END,
Phone2 =
CASE WHEN OwningParcel IN (SELECT Acct FROM b)
 THEN (SELECT Hstead FROM b
  WHERE Acct IS OwningParcel)
ELSE Phone2
END,
RecordDate =
CASE WHEN OwningParcel IN (SELECT Acct FROM b)
 THEN (SELECT DwnldDt FROM b
  WHERE Acct IS OwningParcel)
ELSE RecordDate
END
;
.quit
-- * END PatchSpecTerrDBs.sql;
