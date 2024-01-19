README - DNCReport project documentation.<br>
	7/10/22.	wmk.
###Modification History.
<pre><code>
11/1/21.	wmk.	original document.
7/10/22.	wmk.	.md formatting; notes about FOREIGN KEY tables
			 support in TerrIDData for DNC related tables.
</code></pre>
<h3 id="IX">Document Sections</h3>
<pre><code>
<a href="#1.0">link</a> 1.0 Project Description.
<a href="#2.0">link</a> 2.0 Results.
<a href="#3.0">link</a> 3.0 Setup.
</code></pre>
<h3 id="1/0">1.0 Project Description.</h3>
extracts territory IDs and DNC counts from TerrIDData.DoNotCalls
and writes to DNCSummary.csv
DNCSummary.csv may then be used to update the DNC counts in 
the SystemTracker.ods.<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Results.</h3>
There are currently 4 shell queries with this project:

DNCSummary.sh and DNCDetail.sh provide summary and detail report data exported
to .csv files by their namesake. The summary is a list of territories, the total
number of DONOTCALLs, and the oldest and newest dates of the DONOTCALLs. The detail
is a complete list of DONOTCALLs, grouped by territory.

RSOSummary.sh and RSODetail.sh provide summary and detail report data exported
to .csv files by their namesake. The summary is a list of territories, the
total number of registered sex offenders, and the oldest and newest dates of
the records. The detail is a complete list of registered sex offenders, grouped
by territory.

The resultant .csv files are saved in the {DoTerrsWithCalc}/Tracking folder.
The data in each .csv that can be imported into Calc, then
used to update all the DNC counts in the RefUSA-Downloads sheet. (All of
the RefUSA-Downloads DNC count fields are linked to the SCPA-Downloads
sheet so they stay in sync. They have all been imported to .xlsx spreadsheets
named after their namesakes.<br><a href="#IX">Index</a>
<h3 id="3.0">3.0 Setup.</h3>
<pre><code>Build menu:
	run 'Execute' from Build menu
OR
Terminal: /Geany-Projects/DNCReport
	run ./DNCReport.sh
</code></pre>
/Tracking/DNCSummary.csv is ready to import into the SystemTracking workbook.
<br><a href="#IX">Index</a>
<h3 id="4.0">4.0 Linked Tables.</h3>
The primary database for Do Not Call information is TerrIDData.db. Within this
database there are 3 tables used to manage DoNotCalls. DoNotCalls is the table
used in territory generation that contains the DNC information that the
publisher sees in the publisher territories. It has fields for Foreign Language
('Foreign'), and Registered Sex Offender (RSO) as extended flags.

(new) Previously the values in the 'Foreign' and 'RSO' fields were only 1 or 0,
with 1 indicating the flag applies to the Do Not Call Record. To support the
capability of generating specific reports for registered sex offenders, or
foreign language, these fields now contain record index numbers for either
the RSO table or the ForLang table. Both these tables are new to the TerrIDData.db.

**RSO Tables.**
There are now two tables for recording registered sex offender information. *RSOAddress*
contains the minimal registered sex offender information of property ID and unit. This
is the "parent" table, with each record having a unique RSO id field. The RSO id field
is a "foreign" key to both the DoNotCalls and RSOInfo tables. This links all three tables
together so that if any records are deleted or updated in the *RSOAddress* table, the
information is reflected in the DoNotCalls and RSOInfo tables.

-- * first set existing RSO fields to rowid in RSOs within DoNotCalls;
UPDATE DoNotCalls
 SET RSO = rowid
WHERE RSO <> 0
 AND length(RSO) > 0
;

PRAGMA Foreign_Key=ON;
CREATE TABLE RSOAddress
(RSOid INTEGER PRIMARY KEY AUTOINCREMENT,
 PropID TEXT, Unit TEXT, Initials TEXT,
 RecDate TEXT);

CREATE TABLE RSOInfo
(Name TEXT, Phone TEXT, Notes TEXT,
 RSOid INTEGER NOT NULL,
 PRIMARY KEY(RSOid),
 FOREIGN KEY(RSOid)
  REFERENCES RSOAddress(RSOid));

-- * initially populate RSOAddress with entries from DoNotCalls;
WITH a AS (SELECT rowid, PropID, Unit, RecDate,
RSO
  FROM DoNotCalls WHERE RSO = rowid)
INSERT INTO RSOAddress
SELECT rowid,PropID, Unit, 'wmk', RecDate
FROM a;

-- * initially populate RSOInfor with data from DoNotCalls;
-- NAME, PHONE, NOTES, RSOid;
WITH a AS (SELECT rowid, Name Nm, Phone Ph, Notes Nt,
 RSO FROM DoNotCalls)
INSERT INTO RSOInfo
SELECT Nm, Ph, Nt, RSO
FROM a
 WHERE RSO = rowid;


-- This query returns count of all that are NOT RSO;
select count() RSO FROM DoNotCalls
WHERE RSO = 0
  or length(RSO) = 0
  Or RSO IS NULL;

**ForLang Tables.**
There are now three tables for recording foriegn language information. *FLAddress*
contains the information about each foreign language. This
is the "parent" table, with each record having a unique Foreign Language id field. 
The FL id field
is a "foreign" key to the DoNotCalls, FLInfo, and FLCong tables. This links all
the tables
together so that if any records are deleted or updated in the *FLAddress* table, the
information is reflected in the other three tables.

PRAGMA Foreign_Keys=ON;
CREATE TABLE ForLang
(
Language TEXT, FLid INTEGER,
 PRIMARY KEY( FLid ));

CREATE TABLE FLInfo
(CongName TEXT, CongContact TEXT, CongPhone TEXT,
 FLid INTEGER,
 PRIMARY KEY( FLid ),
 FOREIGN KEY (Flid)
  REFERENCES ForLang (FLid));

CREATE TABLE DoNotCalls
( TerrID TEXT NOT NULL, Name TEXT, UnitAddress TEXT NOT NULL, Unit TEXT,
 Phone TEXT, Notes TEXT, RecDate TEXT, RSO INTEGER, "Foreign" INTEGER,
 PropID TEXT, ZipCode TEXT, DelPending INTEGER, DelDate TEXT, Initials TEXT,
 FOREIGN KEY (RSO)
  REFERENCES RSOAddress(RSOid),
 FOREIGN KEY ("Foreign")
  REFERENCES ForLang (FLid));
-- pragma foreign_keys=ON;
-- TerrIDData - db8;

-- initialize "foreign" to rowid in DoNotCalls;
--UPDATE db8.DoNotCalls
--SET "Foreign" = 
--CASE 
--WHEN "Foreign" IS 1
-- THEN rowid
--ELSE "Foreign"
--END;

-- create FLAddress table within TerrIDData;
--"CREATE TABLE FLAddress
--(FLid INTEGER PRIMARY KEY AUTOINCREMENT,
-- PropID TEXT, Unit TEXT, Initials TEXT,
-- RecDate TEXT, LangID INTEGER)"

-- populate FLAddress table with current DoNotCalls;
--WITH a AS (SELECT "Foreign" dflid, PropID pid,
-- Unit ut, RecDate rd,
-- CASE
-- WHEN INSTR(upper(Notes),"SPANISH") > 0
--  THEN 1
-- WHEN INSTR(upper(Notes),"POLISH") > 0
--  THEN 2
-- WHEN INSTR(upper(Notes),"RUSSIAN") > 0
--  THEN 3
-- ELSE NULL
-- END lang
-- FROM DoNotCalls
-- WHERE dflid > 0 AND LENGTH(dflid) > 0
--)
--INSERT INTO FLAddress
--SELECT dflid, pid, ut, 'wmk',
-- rd, lang FROM a);

-- create FLInfo table within TerrIDData;
--"CREATE TABLE FLInfo
--(Name TEXT, Address TEXT, Unit TEXT, Phone TEXT, Notes TEXT,
-- FLid INTEGER NOT NULL,
-- PRIMARY KEY(FLid),
-- FOREIGN KEY(FLid)
--  REFERENCES FLAddress(FLid))"

-- populate FLInfo with existing records from DoNotCalls;
--WITH a AS(SELECT Name nm, UnitAddress ad, Unit ut, Phone ph, Notes nt,
--  ZipCode zc, "Foreign" dflid FROM DoNotCalls
-- WHERE dflid > 0 AND LENGTH(dflid) > 0)
--INSERT INTO FLInfo
--SELECT nm, ad, ut, ph, nt, zc, dflid FROM a;

-- create FLCong in TerrIDData;
--CREATE TABLE FLCong (7/12/22 done)
--(LangID INTEGER PRIMARY KEY AUTOINCREMENT,
-- Lang TEXT, CongName TEXT, CongAddress TEXT);


