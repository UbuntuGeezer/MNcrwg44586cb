-- * DeactivateMasterTerr.psq/sql - Deactivate records in PolyTerri, MultiMail for terr.
-- *	5/29/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 1/30/23.	wmk.	original code.
-- *
-- * Notes. DeactivateMasterTerr sets the 'DelPending' field = 1 for all
-- * records in PolyTerri.PropOwners, TerrProps and 
-- * MultiMail.SplitProps, .SplitOwners.
-- *
-- * This prevents BridgesToTerr from picking up any obsoleted publisher
-- * records, while preserving the records for archiving.
-- *;

.quit
-- * END DeactivateMasterTerr.sql;
