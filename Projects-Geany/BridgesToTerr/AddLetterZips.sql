-- AddLetterZips - add zipcodes to letter territory SC UnitAddress fields;
--		10/22/21.	wmk.
-- Modification History.
-- ---------------------
-- 4/24/22.		wmk.	*pathbase* env var added.
-- Legacy mods.
-- 10/11/21.	wmk.	original code.
-- 10/22/21.	wmk.	bug fix where 34275- getting doubled.
--TID=$P1
--NAME_BASE=Terr
--Q_NAME=Q$NAME_BASE
--DB_SUFFX=.db
--RU_SUFFX=_RUBridge
--SC_SUFFX_SCBridge
--RU_DB=_RU.db
--SC_DB=_SC.db
-- * Begin AddLetterZips - Attach databases;
.cd '$pathbase/RawData/SCPA/SCPA-Downloads'
.cd './$NAME_BASE$TID'
.open $NAME_BASE$TID$SC_DB
ATTACH '$pathbase/DB-Dev'
 ||		'/VeniceNTerritory.db'
 AS db2;
WITH a AS (SELECT "Account #" AS Acct,
 "situs zip code" AS Zip
  FROM NVenAll)
UPDATE $NAME_BASE$TID$SC_SUFFX
SET UnitAddress =
case
when OWNINGPARCEL IN (SELECT Acct FROM a)
 then trim(UnitAddress) || '   '
  || (SELECT Zip FROM a
      WHERE Acct IS OwningParcel)
ELSE UnitAddress
end
WHERE CONGTERRID LIKE '6%'
  AND SUBSTR(UnitAddress,LENGTH(UnitAddress)-5) NOT LIKE '%342%';
.quit
