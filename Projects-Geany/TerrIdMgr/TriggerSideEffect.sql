-- * TriggerSideEffect.sql - Use TRIGGER to update second database.
-- *	5/29/23.	wmk.;
-- *
-- * Note. TRIGGER may only be used with queries on tables within the
-- * current open database;
-- * sooo this doesn't work.
-- *;

.open '/home/vncwmk3/temp/Trigger1.db'
ATTACH '/home/vncwmk3/temp/Trigger2.db'
 AS db31;

DROP TABLE IF EXISTS MainTrig; 
CREATE TABLE MainTrig (
 PropID TEXT,
 PropDesc TEXT,
 PRIMARY KEY(PropID)
 );
 
 CREATE TRIGGER PropIDChg AFTER UPDATE ON MainTrig
  BEGIN INSERT INTO TrigTable
   VALUES(CURRENT_TIMESTAMP,' MainTrig.PropID changed.');
  END;

DROP TABLE IF EXISTS db31.TrigTable;
CREATE TABLE db31.TrigTable (
 Timestamp TEXT,
 MsgText TEXT )
 ;
 
