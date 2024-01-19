-- * GetStreets.psq/sql - Get street names from Terr638_RU.db;
-- *	12/19/22.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 12/19/22.	wmk.	original code.
-- *
-- * Notes.
.open '$pathbase/DB-Dev/StreetNames.db'
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads'
 || '/Terr638/Terr638_RU.db'
 AS db12;
--PRAGMA db12.table_info("Streets");

	INSERT INTO Streets
	SELECT DISTINCT TRIM(SUBSTR(UnitAddress, INSTR(UnitAddress,' ')))
	  StreetName, '638', '', ''
	FROM db12.Terr638_RUBridge
	ORDER BY StreetName;
.quit
-- ** END GetStreets.psq/sql.
