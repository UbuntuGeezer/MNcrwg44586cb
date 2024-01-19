--#procbodyhere
-- * CombineSCBridgeNames - Combine multiple names in SC Bridge records.;
-- *
-- * Modification History.
-- * ---------------------
-- * 11/19/22.	wmk.	bug fix; VeniceNTerritory.db .NVenAll 
-- *			 > Terr86777.db .Terr86777.ls
--; *
.open '$pathbase/DB-Dev/junk.db'
--;
ATTACH '$pathbase'
||		'/DB-Dev/Terr86777.db' 
 AS db2;
--;
ATTACH '$pathbase'
 ||		"/RawData/SCPA/SCPA-Downloads/Terr$TID/Terr$TID" || "_SC.db"
  AS db11;
--
WITH a AS (SELECT "Account #" AS Acct,
 CASE 
 WHEN LENGTH(TRIM("Owner 3")) > 0
  THEN TRIM("Owner 1") || ", "
    || TRIM("Owner 2") || ", "
    || TRIM("Owner 3")
 WHEN LENGTH(TRIM("Owner 2")) > 0 
  THEN TRIM("Owner 1") || ", "
    || TRIM("Owner 2")
 ELSE  "Owner 1"
 END AS Names
 FROM Terr86777
 WHERE Acct IN (SELECT OwningParcel
   FROM Terr$TID$SC_SUFFX)
 )
UPDATE db11.Terr$TID$SC_SUFFX
SET Resident1 = 
CASE 
WHEN OwningParcel IN (SELECT Acct FROM a)
 THEN (SELECT Names FROM a
  WHERE Acct IS OwningParcel
 ) 
ELSE Resident1
END; 
--#endprocbody;
