README - GitHub/TerritoriesCB/MNcrwg44586 project documentation.<br>
8/12/23.    wmk.
###Modification History.
<pre><code>
8/12/23.    wmk.    original document; adapted for MNcrwg44586 project.
8/16/23.	wmk.	text corrections.
Legacy mods.
9/19/22.    wmk.   original document.
9/22/22.    wmk.   update of Project Overview.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code>
<a href="#1.0">link</a> 1.0 Project Overview - overall project description.
<a href="#2.0">link</a> 2.0 Setup - build setups.
<a href="#3.0">link</a> 3.0 File - key files within TerritoriesCB.
<a href="#4.0">link</a> 4.0 Projects - projects within TerritoriesCB.
<a href="#5.0">link</a> 5.0 Significant Notes -important stuff not documented elsewhere.
</code></pre>

<h3 id="1.0">1.0 Project Overview.</h3>
The TerritoriesCB/MNcrwg44586 project manages Territories "build" code for the
Brainerd, MN congregation. Since the congregation territory covers several
counties, there are separate projects for each county. Currently only Crow Wing
county has a project.

**Definitions.**<br>
build code - shell, *make, SQL queries, and spreadsheets
used to build publisher territories; some "build" code is specific to each
publisher territory and travels with the publisher territory data.

library code - Calc libraries used by the Territories system; library code is
maintained within each library's project; .xba, .xlb, .dlb and .bas files all
make up the library code which is merged and loaded into Calc for each library.

build version - the version of the build code that is being used to generate
publisher territories; version, revision, cycle; e.g. 2.0.1 = version 2,
revision 0, cycle 1.

data version - the version of the data segment that is bein used to generate
publisher territories; code contained within the publisher territory data is of
principal concert, the data itself is not relevant.

library version - the version of the Calc library code in each library; version,
revision, cycle; e.g. 2.0.1 = version 2, revision 0, cycle 1.

territories version - the version of the Territories system; version, revision,
cycle; e.g. 2.0.1 = version 2, revision 0, cycle 1.

Within the running Territories system the following "version" constraints apply:
<pre><code>
    The "build", "data", "library", and "territories" versions must all match in
    the production system.

    The "data" and "library" revisions must match in the production system.
</code></pre>
Any modification to any data structure within the data segment forces a revision
level change in both the "library" and "data" revisions.
**End of Definitions.**<br>

The project is managed using the *git utility and is cloned from the GitHub
project by the same name. UbuntuGeezer is the owner of the project on GitHub.
The *master branch is considered a legacy branch. A separate branch exists for
each of the development computers working on the project. The development
branches are *HPChrome, Lenovo and HPPavilion. The branch name reflects the
name of the host development computer and should be the branch "pulled" on the
other development computers when changes are made to the project. This will
keep the development code 'synced' across the development computers.

The development branches are never "merged" into *master. Instead, it is left up
to each development computer to "pull" from the other computers' branches if
there have been updates made on any of the other computers. The *git
configuration for pull should be "git config pull.rebase false". This will force
reconciliation of any code conflicts where the same file has been changed on
more than one system.

Chromebooks system. It is a clone of the GitHub/github.com project by the same
name. It also functions identically to the GitHub Territories project on the
"origin" system which presently is the HP Pavilion notebook computer. The 
\*master branch is now a legacy branch. All code is now maintained on separate
branches for each computer system. The \*Lenovo branch is the branch for the
Lenovo Chromebook system.

Effective 8/2023 the TerritoriesCB GitHub project now has separate folder paths
for each county in each congregation's assigned territory. This eliminates
ambiguity in the code segment where there are multiple counties within a
congregation's assigned territory. Most of the code is common across counties
within a congregation except for code that handles county-formatted data.
This implies that whenever a congregation adds a new county to the system,
it will have its own project defined in GitHub.

The Basic code for the MNcrwg44586 library is now maintained in the GitHub
Libraries-Project/MNcrwg44586 project. That project contains the source code
and build procedures for the MNcr2wg44586 library code. This eliminates the
need for the Basic folder under the TerritoriesCB/MNcrwg44586 project.

TerritoriesCB folders and files are maintained and modified directly in the GitHub
project files. This is somewhat different from the original system where the
Territories project is actually a subsystem and the code segment is copied to the
GitHub Territories project for backing up to the *github.com* cloud. For
the present, TerritoriesCB and Territories are repositories that are kept
isolated from each other on github.com. (It may be that in the future
TerritoriesCB may become a "branch" of Territories).

The TerritoriesCB folders are: Projects-Geany, Procs-Dev, include and Basic.
These folders contain all of the relevant source code for Territories that
might be modified for use with the Chromebook/chromeos system.
<br><a href="#IX">Index</a>

<h3 id="1.0">2.0 Setup.</h3>
<br><a href="#IX">Index</a>

<h3 id="1.0">3.0 Files.</h3>
<br><a href="#IX">Index</a>


<h3 id="1.0">4.0 Projects.</h3>
AddNVenAllRecord - add property record to TerritoryNVenice.db/NVenAll table.
AddSCBridgeRecord - add missing property record to SCBridge table
AddTerr86777Record - add property record to Terr86777 territory master db.
AnySHtoSQL - reverse shell to .sql source.
AnySQLtoSH - build any SQL query into shell for Chromebook.
AnySQLtoSHHP - build any SQL query into shell for HP system.
ArchivingBackups - Territories subsystem file dumping and loading shells.
BizBridgeToTerr - business SCBridge and RUBridge data to territory data.
BridgesToTerr - SCBridge and RUBridge table data to territory data.
BTerrPageHdr - business territory add page header.
BuildDates - build publisher territory generation dates table (calc).
BuildSCDiff - build SC download differences db.
CBtoHPgeany - Chromebook to HP geany project migration.
DNCReport - generate report of Do Not Calls (calc)
DoBizsWithCalc - calc spreadsheet business territory generation.
DocumentationHP - Territories subsystem documentation from HP system.
DoTerrsWithCalc - calc spreadsheet territory generation and tracking.
EditBas - xba .bas module editing.
EditSQL - .sql editing.
Experiments-SQL - SQL query testing.
ExtractDiff - extract differences in SCPA download.
FixAnyRU - take FixyyyRU.sql and convert to FixyyyRU.sh for territory.
FixAnyRUHP -take FixyyyRU.sql for HP territory and convert to FixyyyRU.sh.
FixAnySC -- take FixyyySC.sql and convert to FixyyySC.sh for territory.
FixAnySCHP - take FixyyySC.sql for HP territory and convert to FixyyySC.sh.
FixMakes - fix makefiles damaged by migration.
FixShells - fix shell files damaged by migration.
FixSQLs - fix .sql files damaged by migration.
FixTerrMakes - fix territory makefiles damaged by migration.
FixTerrPSQs - fix territory .psq files damaged by migration.
FixTerrShells - fix territory .sh files damaged by migration.
FixTerrSQLs - fix territory .sql files damaged by migration.
FlagSCUpdates - flag territories needing update from SCPA download.
HdrsSQLtoSH
ImportProject - import geany project from different system.
ImportSCPA - import new SCPA download data.
MigrationRepairs - shells to repair shells and makefiles with migration issues.
NewBTerritory - create new business territory.
NewTerritory - create new territory.
ReleaseData - organize publisher territory release.
RUNewBizTerr - initialize new RefUSA business territory.
RUNewLetter - initialize new RefUSA letter territory.
RUNewTerritory - initialize new RefUSA territory.
SARANewTerritory - create new territory for Sarasota county.
SCNewLetter - initialize new SCPA letter territory.
SCNewTerritory - initialize new SCPA territory.
SpceialSCdb - **bogus name**
SpecialRUdb - create Special RefUSA database.
SpecialSCdb - create Special SCPA database.
TerrPageHeader - generate and integrate page header into publisher territory spreadsheet.
UpdateCongTerr - update congregation territory with latest SCPA download data.
UpdateMHPDwnld - update MHP RefUSA data from download.
UpdateNVenAll - (obsolete) update NVenAll records from SCPA download data.
UpdateRUDwnld - update RefUSA data from download.
UpdateRULetter - update RefUSA letter territory from download.
UpdateSCBridge - update SCBridge tables in territories from SCPA download data.
UpdtRULetter - update RefUSA letter territory.
<br><a href="#IX">Index</a>

<h3 id="1.0">5.0 Significant Notes.</h3>
<br><a href="#IX">Index</a>
