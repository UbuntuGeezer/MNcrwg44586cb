-- DiffCSVtoDB.sql - Process Diff .csv into DB.
--	4/27/22.	wmk.
--
-- * Dependencies.
-- * -------------
-- * Environment vars - 
-- *	pathbase - host system base path for Territories
-- *	SCPA_CSV = .csv import source file (e.g. SCPA-Public_06-19.csv)
-- *	SCPA_DB2 - target database name to process into (e.g. SCPA_06-19.db)
-- * 	SCPA_TBL2 = target table name in SCPA_DB1 (e.b.Data0619)
-- *
-- * Modification History.
-- * ---------------------
-- * 3/19/22.	wmk.	original code.
-- * 4/27/22.	wmk.	*pathbase* support.
-- *
-- * Notes. This query is in "shell-ready" format, where ($) environment
-- * vars will be substituted into the query at appropriate places. The
-- * expected environment vars are documented above in the Dependencies
-- * list.
-- *;
 
-- * subquery list.
-- * --------------
-- * DiffCSVtoDB.sql - Process Diff .csv into DB.

-- ** DiffCSVtoDB **********
-- *	3/19/22.	wmk.
-- *--------------------------
-- *
-- * DiffCSVtoDB.sql - Process Diff .csv into DB.
-- *
-- * Entry DB and table dependencies.
-- *	($)folderbase = host base path for Territories
-- *	($)SCPA_CSV = .csv import source file (e.g. SCPA-Public_06-19.csv)
-- *	($)SCPA_DB2 = target database name
-- *	($)SCPA_TBL2 = target table in database
-- *
-- * Exit DB and table results.
-- *	SCPADiff_mm-dd.db AS main, SCPA differences this mm dd.
-- *		Diffmmdd - table of difference records
-- *
-- * Notes. By not explicitly using CREATE TABLE, sqlite will import the
-- * .csv records assuming that the 1st row is headers/field names. When
-- * the records are imported using the sqlite browser, the
-- * "trim fields" option also removes any whitespace from the table
-- * field names. When the records are imported using the .import SQL
-- * batch directive, whitespace is not removed. This produces a 
-- * discrepancy between the older imports (e.g.04 16) and the newer
-- * imports (e.g. 06 19).
-- *;

-- * SCPADiff_$m2-$d2 as main;
.cd '$pathbase/RawData/SCPA/SCPA-Downloads'
.open 'SCPADiff_$m2-$d2'
.headers ON
.mode csv
.import 'Diff$m2$d2.CSV' Diff$m2$d2 
.quit

-- ** END DiffCSVtoDB **********;

