-- Method3.sql - extract records from SCPA_mm-dd.db.
-- * 5/28/22.	wmk.	(automated) *pathbase* integration.
--	12/30/21.	wmk.
.output "$pathbase/RawData/SCPA/SCPA-Downloads/Special/<special-db>.csv"
.headers ON
.mode csv
.open "$pathbase/RawData/SCPA/SCPA-Downloads/SCPA_mm-dd.db"
select * from Datammdd
 where "situs address (property address)"
  like 'street%'
   order by "situs address (property address)";
.quit
