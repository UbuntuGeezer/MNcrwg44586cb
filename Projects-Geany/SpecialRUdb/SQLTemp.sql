-- SQLTemp.sql - Set DNCs in Bridge tables
.cd '/home/vncwmk3/Territories/FL/SARA/86777'
.open './DB-Dev/junk.db' 
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777'
 ||		'/DB-Dev/TerrIDData.db'
 AS db4;
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777'
 ||		'/RawData/RefUSA/RefUSA-Downloads/Special/GondolaParkDr.db'
  AS db30;
WITH a AS (SELECT * FROM db4.DoNotCalls
)
UPDATE db30.Spec_RUBridge 
SET DoNotCall =
CASE 
WHEN UPPER(TRIM(UnitAddress))
  IN (SELECT UnitAddress FROM a)
 THEN 1
ELSE DoNotCall
END, 
RSO =
CASE 
WHEN UPPER(TRIM(UnitAddress))
  IN (SELECT UnitAddress FROM a)
 THEN (SELECT RSO FROM a 
  WHERE UnitAddress IS 
    UPPER(TRIM(Spec_RUBridge.UnitAddress)) )
ELSE RSO
END,
"Foreign" =
CASE 
WHEN UPPER(TRIM(UnitAddress))
  IN (SELECT UnitAddress FROM a)
 THEN (SELECT "Foreign" FROM a 
  WHERE UnitAddress IS 
    UPPER(TRIM(Spec_RUBridge.UnitAddress)) )
ELSE "Foreign"
END
WHERE UPPER(TRIM(UnitAddress))
  IN (SELECT UnitAddress FROM a);
--
.quit
