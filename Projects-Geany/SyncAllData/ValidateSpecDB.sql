-- * ValidateSpecDB.psq/sql - Test whether /Special/db RecordDate fields match .csv date.
-- * 3/3/23.	wmk.
-- *
-- * Entry.	$TEMP_PATH/<db - name>CSV.txt = ls -lh output for <db - name>.csv
-- *
-- * Exit. $TEMP_PATH/CSVResults.sh = 'dbokay=1' if all records match
-- *						'dbokay=0' if at least one record does not match.
-- *
-- * Modification History.
-- * ---------------------
-- * 3/3/23.	wmk.	original code.
-- *
-- * Notes. This query is modified by DoSed1.sh setting the db - name field.
-- * By executing the resultant CSResults.sh, the environment var *dbokay
-- * is set for the process running this query.
-- *;

.open '/home/vncwmk3/Territories/FL/SARA/86777/RawData/RefUSA/RefUSA-Downloads/Special/TheEsplanade.db'

DROP TABLE IF EXISTS CSVDate;
CREATE TEMP TABLE CSVDate(
 Flags TEXT,
 Digit INTEGER,
 GroupName TEXT,
 UserName TEXT,
 FSize TEXT,
 FDate TEXT,
 FTime TEXT,
 FPath TEXT
);
.headers off
.mode csv
.separator " "
.import '/home/vncwmk3/temp/TheEsplanadeCSV.txt' CSVDate
ALTER TABLE CSVDate ADD COLUMN Mismatches INTEGER;
WITH a AS (SELECT FDate FROM CSVDate)
UPDATE CSVDate
SET Mismatches = 
 (SELECT COUNT() RecordDate FROM Spec_RUBridge
  WHERE RecordDate NOT IN (SELECT FDate FROM a));
.headers off
.mode list
.output '/home/vncwmk3/temp/CSVResults.sh'
SELECT CASE WHEN Mismatches = 0 
 THEN 'dbokay=1'
 ELSE 'dbokay=0'
 END valid
 FROM CSVDate;
.quit
-- * END ValidateSpecDB.sql;
