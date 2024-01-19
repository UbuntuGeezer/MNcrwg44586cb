--BuildDiffAccts.psq/sql - Build DiffAccts table in new SCPADiff_mm-dd.db.
-- 	4/30/22.	wmk.
--
-- * Entry.	starts out in database SCPADiff_mm-dd.db as main
-- *		MultiMail.db, PolyTerri.db both attached
-- *
-- * Modification History.
-- * ---------------------
-- * 4/30/22.	wmk.	modified to be integrated into BuildDiffAccts.sh
-- * Legacy mods.
-- * 4/19/21.	wmk.	original code.
-- * 6/19/21.	wmk.	multihost support added; mm dd in comments.
-- * 3/19/21.	wmk.	added db#s to attach comments; WARNING added.
-- *
-- * Notes. This will yield a table with the PropIDs and Territories
-- * affected by this download.
-- *;

-- attach MultiMail.db db3;
-- attach PolyTerri.db db5;
-- *** WARNING - edit code below with Diffmmdd **;
.open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/SCPA/SCPA-Downloads/SCPADiff_04-04.db'
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777'
	|| '/DB-Dev/MultiMail.db'
	AS db3;
ATTACH '/home/vncwmk3/Territories/FL/SARA/86777'
	|| '/DB-Dev/PolyTerri.db'
	AS db5;

DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE DiffAccts 
( PropID TEXT NOT NULL, TerrID TEXT
 );
DROP TABLE IF EXISTS DiffAccts;
CREATE TABLE DiffAccts 
( PropID TEXT NOT NULL, TerrID TEXT
 );

-- add PropIDs to DiffAccts table;
 WITH a AS (SELECT DISTINCT "Account#",'' from Diff0404)
 INSERT INTO DiffAccts
 SELECT * FROM a;

-- now set CongTerrID in props in either SplitProps or TerrProps;
UPDATE DiffAccts
set TerrID =
case
when PropID in (select distinct OwningParcel from db3.SplitProps)
 then (select CongTerrID from db3.SplitProps
  where OwningParcel is DiffAccts.PropID)
when PropID in (select distinct OwningParcel from db5.TerrProps)
 then (select CongTerrID from db5.TerrProps
   where OwningParcel is DiffAccts.PropID)
else TerrID
end
where length(terrid) = 0;
.quit
--*****************************************************;
.cd '/home/vncwmk3/Territories/FL/SARA/86777/Projects-Geany/BuildSCDiff'
.output 'MissingTerrIDs.csv'
.mode csv
.headers ON
.delim ,
select PropID from DiffAccts
where length(TerrID) = 0;

UPDATE DiffAccts
set TerrID =
case
when PropID in (select distinct OwningParcel from db3.SplitProps)
 then (select CongTerrID from db3.SplitProps
  where OwningParcel is DiffAccts.PropID)
when PropID in (select distinct OwningParcel from db5.TerrProps)
 then (select CongTerrID from db5.TerrProps
   where OwningParcel is DiffAccts.PropID)
else TerrID
end
where length(terrid) = 0;
-- the following should be done with INNER JOIN on OwningParcel
-- and PropID from DiffAccts;
 WITH a AS (SELECT DISTINCT OwningParcel,
  CongTerrID FROM SplitProps WHERE DelPending IS NOT 1)
 INSERT INTO DiffAccts
 SELECT * FROM a;
 
 -- * eliminate earliest rows, likely from TerrProps;
DELETE FROM DiffAccts
 where rowid NOT IN (SELECT Max(rowid) FROM DiffAccts
  GROUP BY PROPId,TerrID);

