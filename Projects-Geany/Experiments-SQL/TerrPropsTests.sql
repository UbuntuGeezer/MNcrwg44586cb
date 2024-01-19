.open '$pathbase/DB-Dev/PolyTerri.db'
select * from TerrProps
where congterrid is '230'
order by owningparcel,
cast(substr(unitaddress,1,instr(unitaddress,' ')-1)
  as int),
substr(UnitAddress,
 instr(unitaddress,' '))
 ;

---
drop table if exists Sort1;
CREATE TABLE Sort1 ( `OwningParcel` TEXT, `UnitAddress` TEXT NOT NULL, `Unit` TEXT NOT NULL, `Resident1` TEXT, `Phone1` TEXT, `Phone2` TEXT, `RefUSA-Phone` TEXT, `SubTerritory` TEXT, `CongTerrID` TEXT, `DoNotCall` INTEGER DEFAULT 0, `RSO` INTEGER DEFAULT 0, `Foreign` INTEGER DEFAULT 0, `RecordDate` REAL DEFAULT 0, `SitusAddress` TEXT, `PropUse` TEXT, `DelPending` INTEGER DEFAULT 0 );
Insert into Sort1
select * from TerrProps
where congterrid is '230'
order by owningparcel,
cast(substr(unitaddress,1,instr(unitaddress,' ')-1)
  as int),
substr(UnitAddress,
 instr(unitaddress,' '))
;
----
select * from sort1
order by unitaddress,rowid;

select * from sort1
order by
 owningparcel,
 cast(substr(unitaddress,1,instr(unitaddress,' ')-1)
 as int) ||
 trim(substr(unitaddress,instr(unitaddress,' '))),
rowid;

select * from Sort1
group by
 unitaddress,owningparcel;

select * from Sort1
where unitaddress like '%valencia%'
group by
 cast(substr(unitaddress,1,instr(unitaddress,' ')-1)
 as int) ||
 trim(substr(unitaddress,instr(unitaddress,' '))),
rowid;
-----
-- this query gives the streets in upper/lower case order;
select distinct 
 trim(substr(unitaddress,instr(unitaddress,' ')))
 Street
from Sort1
order by Upper(Street);
---


