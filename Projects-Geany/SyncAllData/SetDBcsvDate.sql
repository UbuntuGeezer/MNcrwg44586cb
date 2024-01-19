-- * SetDBcsvDate.psq - Set all RecordDate fields to *csvdate in RU special db.
-- *	2/27/23.	wmk.
-- *
-- * Modification History.
-- * ---------------------
-- * 2/27/23.	wmk.	original code.
-- *
-- *;
.open '$pathbase/$rupath/Special/TheEsplanade.db'
UPDATE Spec_RUBridge
SET RecordDate = '';
.quit
