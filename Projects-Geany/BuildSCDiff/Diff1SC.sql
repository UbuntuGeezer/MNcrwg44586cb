-- * Diff1SC.sql - Difference one SCBridge with SCPA_mm-dd.db
-- *	2/6/22.	wmk.
.open 'home/vncwmk3/Territories/RawData/SCPA/SCPA-Downloads/SCPADiff_02-05.db'
ATTACH 'home/vncwmk3/Territories/RawData/SCPA/SCPA-Downloads/Terr101/Terr101_SC.db'
 as db11;
with b as (select OwningParcel from db11.Terr101_SCBridge),
a as (select "Account #" as PropID, "Homestead Exemption" as Hstead,
 "Last Sale Date" as LastSold from db2.NVenAll
 where PropID in (select OwningParcel from a)
select * from db29.Data0205
 where "account#" in (select OwningParcel from a
  where db2.LastSold is not 
