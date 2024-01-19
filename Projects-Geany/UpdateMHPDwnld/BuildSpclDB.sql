--BuildSpclDB.sql - Build RU<special>_07-04.db from download data.
-- * 5/30/22.	wmk.	(automated) VeniceNTerritory > Terr86777.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
--	7/4/21.	wmk.
--
-- * subquery list.
-- * --------------
-- * BuildSpclDB - Build RU<special>_07-04.db from download data.
-- *;

-- ** BuildSpclDB **********
-- *	7/4/21.	wmk.
-- *------------------------
-- *
-- * BuildSpclDB - Build RU<special>_07-04.db from download data.
-- *
-- * Entry DB and table dependencies.
-- *   Special/RUBayIndies_07-04.csv contains records to place in db
-- *	  in table BayIndies.
-- *
-- * Exit DB and table results.
-- *	Special/RUBayIndies_07-04.db created from RUBayIndies_07-04.csv
-- *
-- * Notes. This query gets executed directly in MakeUpdateMHPDwnld.tmp
-- *;

.cd '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
.open 'RUBayIndies_07-04.db'
.headers ON
.separator ,
.mode csv
.import RUBayIndies_07-04.csv BayIndies
.quit
-- ** END query **********;
-- ** END subquery_name **********;
