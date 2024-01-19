--* GetTerrRUSpecList.psq/sql - Get territory RU /Special db list.
--*	11/28/22.	wmk.
--*
--* Modification History.
--* 11/28/22.	wmk.	original code.
--*
--* Notes.
--* attach /DB-Dev/TerrIDData
--* set output to ArchivingBackups/SpecRUDumpList.txt, csv format, headers off
--* select SpecialDB from SpecialRU
--*  where TID is '< terrid >';
--*
--* ArchivingBackups/RUSpecDumpList.txt is list of RU/Special .dbs to include
--*  in territory dump.
--*;
.cd '/home/vncwmk3/Territories/FL/SARA/86777'
.open './DB-Dev/TerrIDData.db'
.mode csv
.headers off
.output '/home/vncwmk3/GitHub/TerritoriesCB/Projects-Geany/ArchivingBackups/SpecRUDumpList.txt'
select SpecialDB from SpecialRU
 where TID IS '116';
.quit
