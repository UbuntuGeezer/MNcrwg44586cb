-- * ReportOrphans.psq - Report residential properties not assigned to territories.
-- *	5/3/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 4/26/23.	wmk.	original code.
-- * 5/3/23.	wmk.	name change to ReportOrphans; results on OrphansIDs.csv.
-- *
-- * Notes. modified by DoSed with m 2, d 2 changed to month/day of current download.
-- * Cannot use mm, dd since it would alter SitusAddressPropertyAddress.
-- *;
.open '$pathbase/$scpath/SCPADiff_05-28.db'
.headers off
.mode list
.output '$pathbase/TerrData/OrphansIDs.csv'
with a as (select * from DiffAccts
where terrid is '0')
select "Account#" Acct, "SitusAddress(PropertyAddress)" Situs 
FROM Diff0528
WHERE Acct IN (SELECT PropID from a);
.quit
