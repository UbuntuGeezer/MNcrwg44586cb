-- * ReportUnassigned.psq - Report residential properties not assigned to territories.
-- *	4/26/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 4/26/23.	wmk.	original code.
-- *
-- * Notes. modified by DoSed with m 2, d 2 changed to month/day of current download.
-- * Cannot use mm, dd since it would alter SitusAddressPropertyAddress.
-- *;
.open '$pathbase/$scpath/SCPADiff_04-04.db'
.headers off
.mode list
.output '$pathbase/TerrData/UnassignedIDs.csv'
with a as (select * from DiffAccts
where terrid is '998')
select "Account#" Acct, "SitusAddress(PropertyAddress)" Situs 
FROM Diff0404
WHERE Acct IN (SELECT PropID from a);
.quit
