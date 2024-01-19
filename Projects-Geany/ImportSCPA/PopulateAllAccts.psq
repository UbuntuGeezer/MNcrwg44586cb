-- PopulateAllAccts - Populate AllAccts table in Terr86777.db.
-- *	4/29/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 4/29/22.	wmk.	original code.
-- *;
.open '$pathbase/DB-Dev/Terr86777.db'
DROP TABLE IF EXISTS AllAccts;
CREATE TABLE AllAccts
( Account TEXT, PRIMARY KEY(Account));
INSERT OR IGNORE INTO AllAccts
SELECT "Account #" FROM Terr86777
ORDER BY "Account #";
.quit
-- * END PopulateAllAccts.

