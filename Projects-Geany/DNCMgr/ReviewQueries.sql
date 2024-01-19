-- * DoNotCalls review queries.
-- *	6/14/23.	wmk.
-- *;

-- * (6);
with a AS (SELECT "Account #" from Terr86777
where "situs address (property address)" like '%pearl%')
select case when (select count() "Account #"  FROM a) > 1
then "9999999999" else "Account #" end Acct
from Terr86777
where "situs address (property address)" like '101%pearl%'
;

-- * (5);
SELECT * FROM DeletedDNCs where DelDate is '2023-06-08'
AND CAST(TERRID AS INTEGER) < 127
ORDER BY TERRID;

-- *(4);
select * from Terr86777
where "owner 1" like '%haines%';

-- *(3);
select * from DoNotCalls
WHERE Name LIKE '%haines%';
-- * restore record from DeletedDNCs;
insert into donotcalls ( `TerrID`, `Name`, `UnitAddress`, `Unit`, `Phone`,
 `Notes`, `RecDate`, `RSO`, `Foreign`, `PropID`, `ZipCode`, `DelPending`, `DelDate`, `Initials` )
select * from DeletedDNCs
WHERE UNITADDRESS LIKE '500%beach park%';

-- *(2);
INSERT INTO DNCdiffs(
TerrID, Name, UnitAddress, Unit,
Phone, Notes, RecDate, RSO, "Foreign", 
PropID, ZipCode, DelPending, DelDate, Initials,LangID)
SELECT * FROM DoNotCalls
WHERE TerriD IS '122';
 AND UnitAddress LIKE '500%beach park%';


 AND PropID IS '0176080015'
 AND (Unit ISNULL OR Unit IS '');
 
INSERT INTO DNCLog
SELECT CURRENT_TIMESTAMP,'Added DNCDiffs record.' || initials
 FROM Admin LIMIT 1;

 INSERT INTO DNCLog
SELECT CURRENT_TIMESTAMP,'Added 0430111031 DoNotCalls record.' || initials
 FROM Admin LIMIT 1;

where cast(terrid as integer) >= nnn
  and cast(terrid as integer) <= mmm

-- *(1);
select * from DoNotCalls
WHERE TerrID IS '127'
AND ("FOREIGN" ISNULL OR "FOREIGN" IS '')
order by substr(UnitAddress,instr(UnitAddress,' ')),
 cast(substr(unitaddress,1,instr(unitAddress,' ')) as int);
-- sorted range -v;
select * from DoNotCalls
where cast(terrid as integer) >= 235
  and cast(terrid as integer) <= 251
AND ("FOREIGN" ISNULL OR "FOREIGN" IS '')
ORDER BY terrid, substr(unitaddress,instr(unitaddress,' ')+1),
  cast(substr(unitaddress,1,3)as integer);
order by substr(UnitAddress,instr(UnitAddress,' ')),
 cast(substr(unitaddress,1,instr(unitAddress,' ')) as int);

Update DoNotCalls
SET DelPending = 0,
DelDate = ''
WHERE DelDate IS '2023-06-08'
AND ("FOREIGN" ISNULL OR "FOREIGN" IS '');
