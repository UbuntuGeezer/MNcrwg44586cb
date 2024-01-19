--MissingIDs.sql - Log territory RU missing parcels IDs to .csv.
--	3/31/23.	wmk.
--
-- * subquery list.
-- * --------------
-- *;
-- ** MissingIDs **********
-- *	3/31/23.	wmk.
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

.cd '/home/vncwmk3/Territories/FL/SARA/86777/RawData'
.cd './RefUSA/RefUSA-Downloads/Terr314'
.open 'Terr314_RU.db'
.headers OFF
.output 'MissingIDs.csv'
SELECT * FROM Terr314_RUBridge 
WHERE OwningParcel IS "-" 
 AND DelPending IS NOT 1;
.quit

-- ** END MissingIDs **********;
