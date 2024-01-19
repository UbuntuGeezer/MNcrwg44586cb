-- MHPQuery.sql - Mobile Home Park query template.
--	9/8/21.	wmk.
. open '$folderbase/Territories/RawData/RefUSA/RefUSA-Downloads/Special/anyMHP.db'
SELECT DISTINCT 'OR UnitAddress LIKE ' ||
 "'%" ||
 TRIM(SUBSTR(UnitAddress,INSTR(UnitAddress," "))) ||
 "'" AS QueryLine FROM Spec_RUBridge
 ORDER BY QueryLine ;
