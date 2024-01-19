-- * <sqlmodule>.sql - module description.
-- * 1/30/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 1/30/23.	wmk.	original code.
-- *
-- * Notes.
-- *;

ATTACH '/home/vncwmk3/Territories/FL/SARA/86777/DB-Dev/Terr86777.db'
 AS db2;

WITH a AS (SELECT OwningParcel PropID FROM Terr112_SCBridge),
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
UPDATE Terr112_SCBridge
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

WITH a AS (SELECT OwningParcel PropID FROM Spec_SCBridge),
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
UPDATE Spec_SCBridge
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
-- * END <sqlmodule>.sql;
