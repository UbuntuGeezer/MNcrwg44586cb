-- * DNCDiffs.sql - Difference log between TS records and DoNotCalls.
-- *	6/8/23.	wmk.
DROP TABLE DNCdiffs;
CREATE TABLE DNCdiffs ( 
TerrID TEXT NOT NULL DEFAULT '000', Name TEXT, UnitAddress TEXT NOT NULL, Unit TEXT,
Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, "Foreign" INTEGER, 
PropID TEXT, ZipCode TEXT, DelPending INTEGER, DelDate TEXT, Initials TEXT,
Langid INTEGER, "Desc" TEXT,
 FOREIGN KEY(TerrID)
 REFERENCES Territory(TerriD)
 ON UPDATE CASCADE
 ON DELETE SET DEFAULT )
;
select * from DoNotCalls
WHERE TerrID IS '115'
AND ("FOREIGN" ISNULL OR "FOREIGN" IS '')
order by substr(UnitAddress,instr(UnitAddress,' ')),
 cast(substr(unitaddress,1,instr(unitAddress,' ')) as int);

INSERT INTO DNCdiffs(
TerrID, Name, UnitAddress, Unit,
Phone, Notes, RecDate, RSO, "Foreign", 
PropID, ZipCode, DelPending, DelDate, Initials,LangID)
SELECT * FROM DoNotCalls
WHERE TerriD IS '111'
 AND PropID IS '0176080015'
 AND (Unit ISNULL OR Unit IS '');
 
INSERT INTO DNCLog
SELECT CURRENT_TIMESTAMP,'Added DNCDiffs record.' || initials
 FROM Admin LIMIT 1;
