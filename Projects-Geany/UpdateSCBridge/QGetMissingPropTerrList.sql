-- QGetMissingPropTerrList.sql
-- 	4/25/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 7/22/21.	wmk.	original code.
-- * 4/25/22.	wmk.	modified for general use;*pathbase* support.
-- gets property IDs from DiffAccts missing territory IDs.
-- export to file /UpdateSCBridge/DiffsNoTerrIDS07-22.csv
-- which is then copied to LostIDlist.txt for processing by
-- FindAllIDlist.sh;
.open '$pathbase/RawData/SCPA/SCPA-Downloads/SCPADiff_07-22.db'
select propid from DiffAccts 
where terrid isnull or length(terrid) = 0;

-- check Bridge tables for non-matching DiffAccts;
--with a AS (select propid, terrid from DiffAccts 
-- where terrid is not null and Length(terrid) > 0)

-- for each record in DiffAccts where terrid is nonempty;
-- 	get propid
--	search Bridge table matching terrid for propid
--	if not found, output propid, terrid, "not in Bridge"
-- loop on next record;
-- output "bad" records to DiffMismatches.csv
