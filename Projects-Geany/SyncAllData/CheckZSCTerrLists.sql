-- * CheckZSCTerrLists.psq/sql - Check SC/Special/<spec-db> TerrList table for ''.
-- * 2/20//23.	wmk.
-- *
-- * Entry. *sed (DoSed1) has modified < db-name > to be special (full) datbase name.
-- *	    SCPA-Downloads/Special/< spec-db >.db exists - special download database.
-- * 		< spec-db >.db.TerrList = list of territory IDs and Counts
-- *
-- * Exit.	$TEMP_PATH/zTIDsc.<dbname>.txt has record from < spec-db >.TerrList with ' '.
-- *
-- *
-- * Modification History.
-- * ---------------------
-- * 2/20/23.	wmk.	original code.
-- *
-- * Notes. 
-- *;

.open '$pathbase/$scpath/Special/TheEsplanade'
.mode csv
.separator ,
.output $TEMP_PATH/zTIDsc.TheEsplanade.txt
SELECT * FROM TerrList
WHERE TerrID IS '';
.quit
-- * END CheckZSCTerrLists.psq.sql;

