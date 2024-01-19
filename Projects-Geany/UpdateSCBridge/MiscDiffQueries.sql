-- MiscDiffQueries exploring...
--	7/24/21.	wmk.
--
-- * Modification History.
-- * ---------------------
-- * 7/24/21.	wmk.	lots of experimentation.
-- *;
	
-- used this one after using SCPA map, taking property ID from DifAccts
-- where propid had no terrid; found using "search by value" cut and paste
-- propid into search window; matched up with territory map on island
-- and updated DiffAccts table;
update DiffAccts 
set terrid = '107'
where propid like '0407142%';

-- used this one to look up address where had propid but no terrid;
select "account #" as account,
"situs address (property address)" as StreetAddr
FROM Diff0722
where account is '0406021074';

-- Terr207_SC.db attached as db11, to find which territory Bird Bay Way
-- address was in... exposed need to create Special dbs in SCPA-Downloads
-- that mimic same in RefUSA-Downloads;
select * from Terr207_SCBridge
where unitaddress like '1152%';
detach db11;
select * from Terr208_SCBridge
where unitaddress like '1152%';

-- used this to find territory ID of adjoining property;
select owningparcel, unitaddress, congterrid
 from Terrprops 
 where owningparcel is '0175150013';
 
-- used this to mimic RefUSA download of all addresses on a street;
-- need to come up with SC project SpecialSCdb LIKE SpecialRUDB;
 select * from Terr86777 
where "situs address (property address)" 
like '%waterside dr%';
