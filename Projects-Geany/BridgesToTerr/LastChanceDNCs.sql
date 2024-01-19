--LastChanceDNCs.sql - Last chance correction of DNCs in QTerr$P1.SCBridge table;
-- * 5/7/22.	wmk.	(automated) *pathbase* integration.
-- this file will be converted to shell commands to write SQLTemp.sql;
-- 4/24/22.	wmk.
-- Modification History.
-- ---------------------
-- 4/24/22.	wmk.	*pathbase* env var included.
-- Legacy mods.
-- 7/8/21.	wmk.	original query script
-- 9/15/21.	wmk.	modified to only use DNC records with DelPending <> 1;
--					env var set statements commented out;
-- 10/5/21.	wmk.	ensure that Unit with blank(s) only treated as no unit;
--TID=$P1
--NAME_BASE=Terr
--Q_NAME=Q$NAME_BASE
--DB_SUFFX=.db
--RU_SUFFX=_RUBridge
--SC_SUFFX_SCBridge
--RU_DB=_RU.db
--SC_DB=_SC.db
--#proc body here
--pushd ./ >> $TEMP_PATH/bitbucket.txt
--cd $pathbase/Procs-Dev
-- * Begin LastChanceDNCs - Attach databases;
.cd '$pathbase/TerrData'
.cd './$NAME_BASE$TID/Working-Files'
.open $Q_NAME$TID$DB_SUFFX
ATTACH '$pathbase/DB-Dev'
 ||		'/TerrIDData.db'
 AS db4;
--
-- * Start fresh, clearing all DNC fields;
UPDATE $Q_NAME$TID
SET DONOTCALL = "", 
 RSO = "", 
 "FOREIGN" = "" 
;
-- * Set DNCs in newly created QTerrxxx records.
-- *   in _SCBridge first;
WITH a AS (SELECT * FROM DONOTCALLS 
WHERE TERRID IS "$TID"
 AND DelPending IS NOT 1)
UPDATE $Q_NAME$TID
SET DONOTCALL = 
case
when LENGTH(trim(Unit)) > 0
 then
  CASE 
  WHEN Unit IN (SELECT Unit FROM a 
    where propid is OWNINGPARCEL
    AND UPPER(TRIM(UnitAddress))
     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))
  	AND Unit IS $Q_NAME$TID.Unit)
   THEN 1
  ELSE DONOTCALL
  END
else
    case
    when OwningParcel IN (SELECT PropID FROM a 
       where Unit isnull or Length(Unit) = 0
       and upper(trim(UnitAddress))
        IN (select upper(trim(UnitAddress)) FROM a))
     then 1
    else DONOTCALL
    end
end,
 "FOREIGN" = 
case
when LENGTH(Unit) > 0
 then
  CASE 
  WHEN Unit IN (SELECT Unit FROM a 
    where propid is OWNINGPARCEL
    AND UPPER(TRIM(UnitAddress))
     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))
  	AND Unit IS $Q_NAME$TID.Unit)
   THEN  (SELECT "foreign" from a 
  			WHERE Unit IS $Q_NAME$TID.Unit
    AND UPPER(TRIM(UnitAddress))
     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))
    )
  ELSE "Foreign"
  END
else
  case
  when OwningParcel IN (SELECT PropID FROM a 
       where Unit isnull or Length(Unit) = 0)
   then (select "Foreign" from a 
      where propid is OwningParcel
       and upper(trim(UnitAddress))
        IN (select upper(trim(UnitAddress)) FROM a))
  else "Foreign"
  end
end,
RSO = 
case
when LENGTH(Unit) > 0
 then
  CASE 
  WHEN Unit IN (SELECT Unit FROM a 
    where propid is OWNINGPARCEL
    AND UPPER(TRIM(UnitAddress))
     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))
  	AND Unit IS $Q_NAME$TID.Unit)
   THEN  (SELECT RSO from a 
  			WHERE Unit IS $Q_NAME$TID.Unit
    AND UPPER(TRIM(UnitAddress))
     IS UPPER(TRIM($Q_NAME$TID.UnitAddress))
    )
  ELSE RSO
  END
else
  case
  when OwningParcel IN (SELECT PropID FROM a 
       where Unit isnull or Length(Unit) = 0)
   then (select RSO from a 
      where propid is OwningParcel
      and upper(trim(UnitAddress))
        IN (select upper(trim(UnitAddress)) FROM a))
   else RSO
  end
end
WHERE OWNINGPARCEL IN (SELECT PROPID FROM a); 
.quit
-- end LastChanceDNCs ***;
