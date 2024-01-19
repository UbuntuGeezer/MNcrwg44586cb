-- * GetConfidentials.sql - Get CONFIDENTIAL record information from master territory dbs.
-- *	6/9/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 6/9/22.	wmk.	original code.

-- * DBs.
-- * MultiMail.db - territory records for multiple occupancy addresses;
-- * PolyTerri.db - territory rercords for single occupancy addresses;

.open '$pathbase/DB-Dev/junk.db'
ATTACH '$pathbase'
	|| '/DB-Dev/MultiMail.db'
	AS db3;
--pragma db3.table_info(SplitProps);

ATTACH '$pathbase'
	|| '/DB-Dev/PolyTerri.db'
	AS db5;
--pragma db5.table_info(TerrProps);

-- * output this to ConfidTerrList so have list for PUB_NOTES_xxx;
.output '$pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/ConfidTerrList.txt'
.headers ON
.separator ,
.mode csv
-- * get territory ids having CONFIDENTIAL records;
select distinct congterrid AS TerrID from SplitProps
where resident1 like '%confidential%'
union select distinct congterrid AS TerrID from TerrProps
where resident1 like '%confidential%'
  and delpending is not 1
order by TerrID;

-- * output this to ConfidList.txt so have list of CONFIDENTIALs;
.output '$pathbase/Projects-Geany/DoTerrsWithCalc/Tracking/ConfidList.csv'
select * from SplitProps
where resident1 like '%confidential%'
union select * from TerrProps
where resident1 like '%confidential%'
  and delpending is not 1
order by CongTerrID;
.quit
-- * end GetConfidentials.sql;

