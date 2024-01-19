-- SearchBridges4Diff.sql
-- * Modification History.
-- * ??/??/??.	wmk.	original code.
-- * 4/25/22.	wmk.	*pathbase* support.
detach db11;
.open '$pathbase/RawData/SCPA/SCPA-Downloads/SCPADiff_07-22.db'
ATTACH '$pathbase/RawData/SCPA/SCPA-Downloads/Terr102/Terr102_SC.db'
 AS db11;
-- if street matches, set the property ID in the territory;
-- note that street match doesn't account for direction anomalies;
with a AS (SELECT * FROM Diff0722 
WHERE "SITUS ADDRESS (PROPERTY ADDRESS)"
IN (SELECT UNITADDRESS FROM TERR102_SCBRIDGE
 WHERE UNITADDRESS
 LIKE "%" 
 || trim(SUBSTR(
 DIFF0722."SITUS ADDRESS (PROPERTY ADDRESS)",
  7,20)) || "%"))
UPDATE DiffAccts 
set TERRID = 
CASE 
WHEN PROPID IN (SELECT "ACCOUNT #" FROM a)
 THEN "102" 
ELSE TERRID
END ; 
