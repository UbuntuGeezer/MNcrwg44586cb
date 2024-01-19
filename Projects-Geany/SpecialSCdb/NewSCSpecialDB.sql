-- * NewSCSpecialDB.psq/sql - Create new SCPA-Downloads/Special/<special-db>.db'
-- *	12/24/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 12/24/22.	wmk.	original code.
-- *
-- * Notes. run DoSedNewSCdb.sh to replace *spec-db* with special db name.
-- *
.open '$pathbase/RawData/SCPA/SCPA-Downloads/Special/GardensEdgeDr.db'
.read '$codebase/Projects-Geany/SpecialSCdb/BuildPropTerr.sql'
-- * more code here.
.quit
