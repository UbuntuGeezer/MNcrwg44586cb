--MissingIDs.sql - Log territory RU missing parcels IDs to .csv.
--	3/11/21.	wmk.
--
-- * subquery list.
-- * --------------
-- *;
-- ** MissingIDs **********
-- *	3/12/21.	wmk.
-- *--------------------------
-- *
-- * MissingIDs - Log territory RU missing parcels IDs to .csv.
-- *
-- * Entry DB and table dependencies.
-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terrxxx_RUBridge - Bridge records from latest RU download 
-- *
-- * Exit DB and table results.
-- *	Terrxxx_RU.db - as db12, new territory records from RefUSA polygon
-- *		Terrxxx_RUBridge - query exports any records with OwningParcel
-- *		  unset (= "-") to MissingIDs.csv
-- *
-- * Notes.
-- *;

.cd '/media/ubuntu/Windows/Users/Bill/Territories/RawData'
.cd './RefUSA/RefUSA-Downloads/Terr612'
.open 'Terr612_RU.db'
.headers ON
.output 'MissingIDs.csv'
SELECT * FROM Terr612_RUBridge 
WHERE OwningParcel IS "-" 
 AND DelPending IS NOT 1;
.quit

-- ** END MissingIDs **********;
