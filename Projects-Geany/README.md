README - Projects-Geany projects documentation.<br>
9/27/22.	wmk.
###Modification History.
<pre><code>9/26/22.    wmk.   original document.
9/27/22.    wmk.   project brief descriptions added.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description.
<a href="#2.0">link</a> 2.0 Code Segment Projects - project that work on the code segment.
<a href="#3.0">link</a> 3.0 Data Segment Projects - projects that work on the data segment.
</code></pre>
<h3 id="1.0">Project Description.</h3>
Projects-Geany is the capsule in which both the code and data that comprise the
Territories subsystem are developed and maintained. The Geany utility is the
project manager that bundles and coordinates source code and build procedures
that construct the data elements for the Territories.

This approach is a bit unorthodox, since the *make* utility and much of the Geany
build tools are primarily for constructing executable modules and libraries. However,
due to the complexity of data dependencies where updating one part of the data
affects other parts, the use of prerequisites and recipes is ideal to coordinate
keeping all of the data elements synchronized.<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Code Segment Projects.</h3>
Code segment projects are those whose focus is in the \*codebase folders. These
projects manage SQL, Basic, and shells that comprise the subsystem code for
the Territories subsystem. On *chromeos* these folders are isolated to their
own folders (*codebase) since they contain system-dependent code and paths
that are unique to Chromebook systems. This keeps code segment projects
with the same names segregated to their respective operating systems
(i.e. Linux/ubuntu, chromeos).

Since the Projects-Geany folder is considered part of the code segment, all
projects are maintained under this folder. However, some of these projects
are focused on the data segment. Projects focused on the data segment manage
territory downloads, territory generation, and system tracking functions.
The data segment projects are documented in the
<a href="#3.0"> [Data Segment Projects]</a> section below.
The following projects are code segment projects:
<pre><code>
AnySHtoSQL - extract SQL block from SH shell (reverse of AnySQLtoSH).
AnySQLtoSH - convert SQL query file to *bash* shell
AnySQLtoSHHP - convert SQL query file to *bash* shell (HP Pavilion system).
ArchivingBackups - Territories subsystem file dumping/loading.
CBtoHPgeany - convert Chromebook project to HP Pavilion system.
EditBas - maintain Calc library macro code.
EditSQL - maintain SQL modularized code.
Experiments-SQL - experimental SQL queries.
FixMakes - fix makefiles with *pathbase and *make directives.
FixShells - fix shell files with *pathbase.
FixSQLs - fix SQL source files with *pathbase.
ImportProject - import project from other subsystem.
MigrationRepairs - fix paths and other migration issues.
</code></pre>
<br><a href="#IX">Index</a>
<h3 id="3.0">3.0 Data Segment Projects.</h3>
Data segment projects focus on the \*pathbase folders. These projects manage
territory download data, publisher territory generation and code that travels
with individual territories like SQL that corrects anomalies in download data.

The projects themselves are considered code, as they use build utilities like
*make* which utilize "recipes" that usually contain commands and shell references
to accomplish the requred data manipulations. Some projects contain LibreOffice
Calc spreadsheets which utilize libraries of macros to perform data transormations.

The following projects are data segment projects:
<pre><code>
AddNVenAllRecord - (obsolete) Add record to old VeniceNTerritory.NVenAll master.
AddSCBridgeRecord - add missing property to territory SCBridge records.
AddTerr86777Record - Add record to Terr86777.Terr86777 master db table (replaces AddNVenAllRecord).
BizBridgeToTerr - move business bridge data to territory generation .csv.
BridgesToTerr - move SCPA and RefUSA bridge data to territory generation .csv.
BTerrPageHdr - add page header to business territory.
BuildDates - generate publisher territory "build dates" .csv.
BuildSCDiff - generate SCPA differences table with records updated by download.
DNCReport - generate Do Not Calls report .csv.
DoBizsWithCalc - batch process business territories .csvs to publisher territories.
DoTerrsWithCalc - batch process publisher territories .csvs to publisher territories.
ExtractDiff - extract differences between 2 SCPA downloads.
FixAnyRU - convert any FixyyyRU.sql to FixyyyRU.sh for territory yyy.
FixAnyRUHP - convert any FixyyyRU.sql to FixyyyRY.sh for mobile home park.
FixAnySC - convert any FixyyySC.sql to FixyyySC.sh for territory yyy.
FixAnySCHP - convert any FixyyySC.sql to FixyyySC.sh for territory yyy (HP Pavilion).
FixTerrMakes - fix any makefiles in territory data segment.
FixTerrPSQs - fix any .psq SQL files in territory data segment.
FixTerrShells - fix any .sh shell files in territory data segment.
FixTerrSQLs - fix any .sql SQL files in territory data segment.
FlagSCUpdates - flag territory with latest updates from SCPA download.
HdrsSQLtoSH - convert .sql to .sh with preamble/postprocessing *bash commands.
ImportSCPA - import project from another territory subsystem.
NewTerritory - create data segment framework for new territory.
ReleaseData - organize publisher territory release.
RUNewBizTerr - create new RefUSA business territory data segment.
RUNewLetter - create new RefUSA letter territory data segment.
RUNewTerritory- create new RefUSA territory data segment.
SARANewTerritory - (obsolete) create new territory for FL/SARA/xxxxx.
SCNewLetter - create new SCPA letter territory data segment.
SCNewTerritory - create new SCPA territory data segment.
SpceialSCdb - bogus misnamed project. (see SpecialSCdb)
SpecialRUdb - create special RefUSA database for use with SPECIAl territories.
SpecialSCdb - create special SCPA database for use with SPECIAL territories.
TerrPageHeader - add page header to publisher territory.
UpdateCongTerr - update master congregation territory with SCPA download data.
UpdateMHPDwnld - update mobile home park data with new download data.
UpdateNVenAll - old update of master congregation territory data. (see UpdateCongTerr)
UpdateRUDwnld - update RefUSA territory with new download data.
UpdateRULetter - update RefUSA letter territory with new download data.
UpdateSCBridge - update SCPA territory with new download data.
UpdtRULetter - update RefUSA letter territory with new download data.
</code></pre>
<br><a href="#IX">Index</a>

<h3 id="4.0">Project Description.</h3>
<br><a href="#IX">Index</a>

<h3 id="5.0">Project Description.</h3>
<br><a href="#IX">Index</a>

