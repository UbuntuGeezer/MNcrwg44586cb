-- Difference Queries between prior SCPADiff and current SCPADiff;
--	12/5/21.	wmk.
--;

-- general query to obtain TerrIDs from SCPADiffmmdd;
-- previous is main, newer is db19;
select distinct TerrID from DiffAccts
where length(TerrID) > 0
ORDER BY TerrID;

-- this query extracts the NEWEST TIDs not in previous;
-- previous is main, newer is db19;
with a AS (select distinct TerrID As TID from DiffAccts
where length(TerrID) > 0
ORDER BY TerrID)
select DISTINCT TerrID from db19.DiffAccts
where TerrID not in (select TID from a)
 and length(TerrID) > 0
order by TerrID;

-- this query extracts the COMMON TIDs previous/current;
-- previous is main, newer is db19;
with a AS (select distinct TerrID As TID from DiffAccts
where length(TerrID) > 0
ORDER BY TerrID)
select DISTINCT TerrID from db19.DiffAccts
where TerrID in (select TID from a)
 AND LENGTH(TerrID) > 0
 ORDER BY TerrID;

-- this query extracts the OLDEST TIDs previous/current;
-- where TIDs not in current;
-- previous is main, newer is db19;
with a AS (select distinct TerrID As TID
 from db19.DiffAccts
where length(TerrID) > 0
ORDER BY TerrID)
select DISTINCT TerrID from DiffAccts
where TerrID NOT in (select TID from a)
 AND LENGTH(TerrID) > 0
 ORDER BY TerrID;


