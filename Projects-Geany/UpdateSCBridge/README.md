README - Documentation for UpdateSCBridge Build project.<br>
	11/24/22.	wmk.
<h3>Modification History.</h3>
<pre><code>4/26/22.    wmk.   .md formatting updated for *pandoc* utility.
4/30/22.    wmk.   Project Description expanded to cover MakeUpdtSpecSCBridge
			 for updating /Special/SCBridge territories; changes reflecting
			 Terr86777.db replacing VeniceNTerritory.db
5/27/22.    wmk.   .md formatting reverted to *markdown*; links added.
7/1/22.     wmk.   GetTIDList documentation udpated.
11/24/22.   wmk.   KillTIDBlock, Actv8TIDBlock shells documentation added.
12/26/22.   wmk.   Updating Special Territories section added;
             UpdtTerrSpecBridge documented.
Legacy mods.
4/19/21.    wmk.   original documentation.
6/6/21.     wmk.   minor modifications to use as template for others.
6/26/21.    wmk.   documentation expanded.
7/3/21.     wmk.   preprocess shell documentation added;
7/23/21.    wmk.   Significant Notes added; FindAllIDinTerrs and
			 FindAllIDlist documented.
11/3/21.    wmk.   "Document Sections", Setup and :Setup Batch" sections
			 added.
12/26/21.   wmk.   corrections to Updating Special/<special-db> instructions.
3/24/22.    wmk.   .md format revisions.
</code></pre>
<h2 id="IX">Document Sections.</h2>
<pre><code><a href="#1.0">link</a> Project Description - overall project description.
<a href="#2.0">link</a> Dependencies - build dependencies.
<a href="#3.0">link</a> Build Description - build process.
<a href="#4.0">link</a> Setup - step-by-step build instructions.
<a href="#4.0.1">link></a> Setup Batch - build instructions for "batched" run.
<<a href="#4.0.1.1"><link></a>   4.0.1.1 SCBridge Batch Updates - batch updates of SCBridge tables.
<a href="#4.0.2">link></a> Setup Special Batch - build instructions for Special batched run.
<a href="#4.0.3">link></a> 4.0.3 Batch Reloading of Chromebook Territories.
<a href="#5.0">link></a> 5.0 Build Prerequisites - prerequisites for various builds.
<a href="#6.0">link></a> 6.0 Updating Special Territories - updating Specxxx_SC.dbs.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
When fresh data is downloaded from the county it is important that the databases
be updated in a specific sequence. This will ensure that downstream dependencies
are met. This sequence is as follows:<br><br>
[ImportSCPA](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ImportSCPA/README.html)&nbsp;&nbsp;&nbsp;&nbsp;SCPA\_mm-dd.db - the SCPA county-wide download database<br>
[ExtractDiff](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ExtractDiff/README.html)&nbsp;&nbsp;&nbsp;&nbsp;SCPADiff\_mm-dd.db - records in the county-wide download that are newer<br>
&nbsp;&nbsp;&nbsp;&nbsp;than the previous download<br>
[DiffsToMaster](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/DiffsToMaster/README.html)&nbsp;&nbsp;&nbsp;&nbsp;Terr86777.db - the master territory county database records<br>
[UpdateSCBridge] This project:&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Special/< special-db >.db,s - all "special" county<br>
&nbsp;&nbsp;&nbsp;&nbsp;dowload databases used in publisher territory generation<br>
[UpdateSCBridge] This project:&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Terrxxx/Specxxx\_SC.db,s - all "special" territories'<br>
&nbsp;&nbsp;&nbsp;&nbsp;publisher territory special records databases<br>
[UpdateSCBridge] This project:&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Terrxxx/Terrxxx\_SC.db,s - all publisher territories'<br>
&nbsp;&nbsp;&nbsp;&nbsp;databases

The *UpdateSCBridge* project contains 2 build processes.
UpdateSCBridge updates one or more territory's SCBridge table with the
latest changes from Terr86777.db/Terr86777 records. UpdtSpecSCBridge
updates *Special* SC database SCBridge tables.

**UpdateSCBridge Build.**
MakeUpdateSCBuild uses the query MakeGetTIDList to build a TIDListmmdd.csv
containing all of the territory IDs affected by the latest SC download. This
can be copied to the TIDList.txt file for a batch run of updates for all
territories needing their SCBridge tables updated.
See the *UpdateSCBridge* sections below.

**UpdtSpecSCBridge Build.**
The *Special* dbs reside in the SCPA-Downloads/Special folder. They are
constructed by special queries of the SC data, and will need to be
updated whenever the SCPA data for any parcels within the *special*
db have been updated by download. See the *UpdtSpecSCBridge* sections below.

<h3 id="2.0">2.0 Dependencies.</h3>
UpdateSCBridge depends upon Terr86777.db having been updated with the latest
records from the current SC download. Two projects,
[ExtractDiff](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ExtractDiff/README.html)
and 
[DiffsToMaster](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/DiffsToMaster/README.html), 
need to have completed for the Terr86777.db to be up-to-date.

Prior to running the MakeUpdateSCBridge build, the project *FlagSCUpdates*
build should have been executed to set up the update dependencies in the
SC territories' folders. See the
 [FlagSCUpdates](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/FlagSCUpdates/README.html) documentation.
The build command "sed" must be edited with the territory ID and download
month and day inserted as its parameters. DoSed.sh is then invoked to
execute the "sed" command.

MakeUpdateSCBridge.tmp is the makefile template for make. The DoSed
execution edits the MakeUpdateSCBridge.tmp file into MakeUpdateSCBridge
for the "Make" build command.

If the "Make" build command has "tidlist" as the passed parameter for
the territory ID, the file TIDList.txt will be used as a list of
territories on which the MakeSCUpdateSCBridge makefile will be run.
Lines within the TIDList.txt file that begin with "#" will be treated
as comments. All other lines should contain valid territory IDs.
See "Batch Setup" below.

An initial pass TIDList.txt file can be created by querying the
DiffAccts table in the SCPADiff_mm-dd.db database. Using SELECT DISTINCT
to obtain the affected territories, the results can be saved to the
UpdateSCBridge project folder, then used as the TIDList.txt.

In cases where the territory is built from Special map queries, it is
possible that the _SCBridge table may not have all of the property IDs
or addresses. Phone territories are one situation where this arises.
Before UpdateSCBridge can update the any records whose property ID is
in the Diffmmdd table with the newest information, the records must
first be created in the SCBridge table.

A stand-alone query is part of the project to handle these cases. The
query CreateBridgeFromSplitProp will create new SCBridge entries for
any property IDs found in Diffmmdd that are not present in the SCBridge
table. It is able to do this by querying the territory records that are
stored in MultiMail/SplitProps (eventually add PolyTerri/TerrProps) and
extracting the Bridge information from the records for that territory.
This is the best way to do it, since the Mapxxx_SC.csv file is used
in Special cases to directly add records to MultiMail.db. [It may be that
in the future a better, more consistent, way will be found.]

The CreateBridgeFromSplitProp query uses Diffmmdd, Terrxxx_SC.db and
MultiMail databases. Until the code is included in the Create..Prop
query, the sqlite browser may be used to attach the needed databases
and the query can be cut/pasted into one of the SQL tabs and run.

<h3 id="3.0">3.0 Build Description.</h3>
The main target of the MakeUpdateSCBridge build is Terrxxx\_SC.db, where xxx is the
SC data for territory xxx.

Its prerequisites are all in the folder ~/SCPA/SCPA-Downloads/Terrxxx
where xxx is the territory ID.  This process will bring the Bridge
SCPA territory records up-to-date with the download of month mm, day dd.
The prerequisite files are:
<pre><code>
	UpdtyyyM.csv - changed records for MultiMail.db this territory
	UpdtyyyP.csv - changed records for PolyTerri.db this territory
	FixyyySC.sh - SC postprocess fixes shell for this territory
	FixyyySC.sql - SC postprocess fixes sql for this territory
</code></pre>
Terrxxx\_SC.db will be considered out-or date if changes to either the
postprocess shell, or its internal .sql query are newer than
Terrxxx_SC.db. This is so that, even if the download data is current,
if there is a change to the postprocess, the SC Bridge records will be
checked and updated if necessary.

UpdtyyyM.csv and UpdtyyyP.csv contain changed records that are newer in 
the current SC download than the previous SC download. If either of these
files are newer than Terrxxx\_SC.db, then Terrxxx\_SC.db will be considered
out-of-date. The new records contained in either of these files will
have to be used to UPDATE Terrxxx\_SC.db table Terrxxx\_SCBridge. The fields
that are assumed to have changed with the new records are OwningParcel,
Resident1, and Phone2 (homestead status). The DownloadDate field from
the UpdtyyyM or UpdtyyyP record will be used as the new RecordDate.

Terrxxx\_SC.db has its records updated by UpdateSCBridge.sql, edited
to use the territory with the month and day of the latest SC download.
The edited .sql is placed on SQLTemp.sql and used as the input file for
sqlite3.<br>
<a href="#IX">Index</a>
<h3 id="4.0">4.0 Setup.</h2>
MakeUpdateSCBridge updates the SCBridge tables within a territory's Terrxxx\_SC.db.
MakeUpdtSpecSCBridge updates the SCBridge tables within Special dbs resident
in the SCPA-Downloads/Special folder.
Before running either UpdateSCBridge, or UpdtSpecSCBridge be sure that
Terr86777 is up-to-date with the lastest SCPA\_mm-dd.db database information.

**NOTE:** See <a href="#4.0.1">Batch Setup</a> below if doing multiple SCBridge updates.<br>
**NOTE:** (5/2/22.) A bug in the previous builds has forced a change in MakeUpdateSCBridge
recipe for SpecxxxSC.sh. The previous hdr..\_1 file had a bug in the first
line where the shebang got lost and became simply #/bin/bash. This manifested
itself with a *segmentation error* happening during bash processing of the
SpecxxxSC.sh shell. The SpecxxxSC.sh file is now ALWAYS rebuilt by forcing the
recipe to a .PHONY target. This fixes any "shebang"s in question without having
to go through manually and correct all of the SpecxxxSC.sh files.

<pre><code>Updating territory Terrxxx-_SC.db Terrxxx\_SCBridge table.
Build menu:

	edit 'sed' command line with territory ID, month and day of latest
	 SCPA_mm-dd.db database
	run 'sed' from the Build Menu
	
	[run Make Dry-run to check the makefile]
	
	run Make to Update the Terrrxxx_SC.db.Terrxxx_SCBridge table
	
Updating Special/<special-db>.db Spec_SCBridge table.
Build menu:

	edit 'sed1' command line with territory ID, month and day of latest
	 SCPA_mm-dd.db database
	run 'sed1' from the Build Menu
	
	run 'Make Spec Update SC Bridge' to update the /Special <special-db>
	 SCBridge table
	
	[if more than 1 /Special .db, repeat above steps]
	 (see also <a href="#4.0.2"> Special Batch SC Updates"</a>)
</code></pre>
<a href="#IX">Index</a>
<h3 id="4.0.1">4.0.1 Batch Setup.</h3>
UpdateSCBridge can handle "batch" requests for multiple SCBridge
updates with a single run. It can also handle batch requests for multiple
SCSpecials with a single run.

<p id="4.0.1.1"><strong>SCBridge Batch Updates.</strong>
The makefile \*MakeGetTIDList\* will build a "batch" list of territory IDs that
need updating as a result of a new SCPA download. It uses the information in 
the SCPADiff\_m2-d2.db *DiffAccts* table to generate a file named TIDListm2d2.csv
that can be copied to the TIDList.txt file as described below. To build the
TIDListm2d2.csv do the following:
<pre><code>UpdateSCBridge Project:
Terminal Session:
	cdj UpdateSCBridge to change to the project folder

	run DoSed2 to transform the GetTIDList.psq > GetTIDList.sql
	 ./DoSed2.sh mm dd	# mm dd is current download month/day

	run the following *make* command to generate the TIDListm2d2.csv:
	 make -f MakeGetTIDList
</code></pre>
TheTIDListm2d2.csv contains territory IDs, one per line. For FlagSCUpdates or
UpdateSCBridge processing, copy this file to TIDList.txt. This list may be edited
to include comments or to produce shorter batch runs where the entire list is not
processed. Either an empty line or a line starting with '#" will be treated as
a comment by either FlagsSCUpdates of UpdateSCBridge.

It may be advisable to run FlagSCUpdates or UpdateSCBridge on subsets of the
TIDList.txt list. For example, it may be desirable to handle the list in
groups of 100 territories, say, all territories beginning with '1'. Or it may
be that a trial run using only 1 or 2 territories is desired. A line starting
with '$' is treated as an "end of processing" flag and no further lines will
be processed by either FlagSCUpdates or UpdateSCBridge.

Two shell files have been provided to assist in editing the TIDListm2d2.csv
file grouping batch runs as described above. *KillTIDBlock.sh" allows the user
to "kill" processing of all TIDList lines starting with a specified digit.<br>
Example:<br>
>./KillTIDBlock.sh  1<br>
<p>will comment all lines beginning with '1' in TIDList.txt with a leading '#'. It
is left to the user to manually edit the TIDList.txt file and insert a '$' where
processing is to stop.

Actv8TIDBlock.sh allows the user to "activate" processing of all TIDList lines
starting with a specified digit.<br>
Example:<br>
>./Actv8TIDBlock.sh 1<br>
<p>will un-comment all lines beginning with '#1' in TIDList.txt by removing the
'#'. It is left to the user to manually edit the TIDList.txt file and inserr a
'$' where processing is to stop.

The TIDList.txt file may now be used for the batch
run of [FlagSCUpdates](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/FlagSCUpdates/README.html) and 
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html).
 **FlagSCUpdates should be run prior to the UpdateSCBridge build.**

To do a batch run of UpdateSCBridge on a list of territories do the following:
<pre><code>UpdateSCBridge Project:

	edit the TIDList.txt file to contain the list of all territories
	 for which to do the UpdateSCBridge process, one territory per line
	 in column A. A cell which begins with '#' is skipped as a comment.
	 NOTE: When updating territories after an SCPA_mm-dd.db download, the
	 SCPADiff_mm-dd.db table DiffAccts has the territory IDs of all territories
	 known to be affected by the differences in the download. The following
	 query can extract a .csv containing all the affected territories:
		SELECT DISTINCT TerrID FROM DiffAccts where length(terrid) > 0 ORDER BY TerrID
	 place the query results in file TIDListmmdd.csv in this project folder.
	 
Terminal Session:
	cdj UpdateSCBridges

	run UpdateAllSCBridge
	  ./UpdateAllSCBridge mm dd

Build menu:

	*Batch SCBridges* command line: edit the month and day of the download with
	which to compare records needing to be updated
	
	ensure that the list of territories is in TIDList.txt (see note on
	 TIDListmmdd.csv in above paragraph)
	 
	run 'Batch SCBridges' menu item
</code></pre>
<a href="#IX">Index</a>
<h3 id="4.0.2">4.0.2 Special Batch Updates.</h3>
SCSpecials batch updates update the SCPA-Downloads/Special databases. The
list of databases to update is in DBList.txt. For now, it is assumed that
if one Special database is out-of-date, they all are and should be updated.
<pre><code>.UpdateSCBridge Project:

  edit the DBList.txt file to contain the list of all Special databases
   for which to do the Batch SCSpecials build, one database name per line
   (with .db suffix) in column A. A cell which begins with '#' is skipped
   as a comment. (note: SCPA-Downloads/Special/GenDBList.sh will generate a
   "current" list of Special databases in the /Special folder.)

Terminal Session:
	cdj UpdateSCBridge

	run the shell to update all of the databases in the DBList.txt
	 ./UpdtAllSCSpecials.sh mm dd
	   where mm dd is the month, day of the latest SC download
OR Build menu:

  *Batch SCSpecials* command line: edit the month and day of the download with
   which to compare records needing to be updated
	
  run 'Batch SCSpecials' menu item
</code></pre>
Once all of the /Special SC datbases have been updated, the Terrxxx_Spec.db,s
all need to be updated for affected territories. Since any /Special <special-db>.db
out-of-date updates all of the /Special db,s ALL of the Make.<special-db>.Terr
makefiles in /Special should be run to ensure that the special db,s within the
SC territories need to be regenerated. This should not have any significant effect
on Terrxxx_SC.db,s whose Bridge records have already been updated by 
UpdateSCBridge. See the [Special](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/Territories/RawData/SCPA/SCPA-Downloads/Special/README.html) documentation for using the Make.< special-db >.Terr
makefiles.
<a href="IX">Index</a> 
<h3 id="4.0.3">4.0.3 Batch Reloading of Chromebook Territories.</h3>
The Chromebook system is limited on hdd space, so not all territory data may
be available when it is desired to update the SC bridge tables. A new
makefile *MakeReloadList* creates a *TEMP_PATH/ReloadList.txt file with
a list of all territories that had changes in the latest SC download.
This list of territory ids should be copied to the UpdateSCBridge project
folder for use by the *ArchivingBackups* shell "ReloadFLtidList".

"ReloadFLtidList" cycles through the list of territory IDs in the
ReloadList.txt file and reloads all of the territory data for each territory
ID in the list. The list file will treat as a comment blank lines or any
lines beginning with '#'. Either a line beginning with '$' or end-of-file
terminates the list.

Use the following command from *ArchivingBackups* to perform a batch
reload of territories from the Lexar flash drive:
<pre><code>    ./ReloadFLtidList.sh  $codebase/$Projects-Geany/UpdateSCBridge/ReloadList.txt -u Lexar</pre></code>
After reloading of the territory data with ReloadFLtidList, a batch run
of *FlagSCUpdates* and *UpdateSCBridge* projects may be done to bring all
of the SCPA-Downloads/Terrxxx/Terrxxx_SC.db files up-to-date with the
latest SCPA download.<br><a href="#IX">Index</a>
<h3 id="5.0">5.0 Build Prerequisites.</h3>
UpdtyyyM.csv and UpdtyyyP.csv will be considered to be out-of-date if the
SCDiff_mm-dd.db is newer. This would indicate that different records
may have been downloaded since the territory was last updated.

If either .csv is out-of-date, the utility $(bashpath)FlagSCUpdates.sh yyy @@ zz
will update these files for territory yyy using the SCDiff_@@-zz.db to
extract updated records that will apply to either PolyTerri or MultiMail
for this territory.

---

SCPADiff_@@-zz.db is the differences download database. If it is non-existent,
it will not be built, as it has an empty recipe.

---

FixyyySC.sh is the postprocessing shell for territory yyy; FixyyySC.sql
is the .sql query that is the basis for the shell. FixyyySC.sh will be
considered out-of-date if FixyyySC.sql is newer. If FixyyySC.sql does
not exist, it will be created empty using "touch" and a do-nothing shell
FixyyySC.sh will be generated.

---

SpecyyySC.sh is the optional preprocessing shell for Territory yyy.
SpecyyySC.sql is the sql query that is the basis for the shell. SpecyyySC.sh
will be considered out-of-date if SpecyyySC.sql is newer. If there is no
SpecyyySC.sh file the primary targe make will not attempt to run it.
The primary function of the SpecyyySC.sql is to ensure that all the
relevant addresses for the territory are present in the Bridge records
before the update from the download occurs.

In several territories, the SCPA map polygon data either misses addresses
or is too cumbersome to accurately get all the addresses in the territory.
The folder Special in the SCPA-Downloads directory contains .dbs built
from street-oriented SCPA downloads. A given street download may contain
many addresses outside of the territory, so it is up to the preprocessing
query to extract only the relevant addresses.

The file SPECIAL within an SCPA territory download's raw data is used to
document the dependencies the territory has on .dbs within the
SCPA-Downloads/Special folder. It will be considered to be of high
importance, like the README file, documenting quirks of the territory.

---

This build updates the \_SCBridge table inside the Terrxxx\_SC.db for
territory xxx. The primary target of this build is Terrxxx\_SC.db.
UpdateTerr86777 is project that will take a given SCPA\_mm-dd.db and use
it to update the Terr86777 table within the Terr86777.db. This
process will bring the master SCPA territory records up-to-date with
the SCPA\_mm-dd.db download.

Its prerequisites are SCPA\_mm-dd.db and SCPADiff\_mm-dd.db, where
SCPA\_mm-dd.db is the full SCPA download and SCPADiff\_mm-dd is the
"differences" collection of records that have changed since the
prefious full SCPA download. Terr86777.db will be considered
to be out-of-date if either of the prerequisite files is newer.

The DiffsToTerr86777.sh shell performs the update. It is built off
DiffsToTerr86777.sh by stream editing m2 and d2 to produce XDiffsToTerr86777.sh.
It takes the SCPADiff\_m2-d2.db table Diffm2d2 and updates the Terr86777
table by Inserting/Deleting entire records that have changed. This is
more accurate than just doing an UPDATE of the Terr86777 records, since
multiple fields may have changed that are not being tested for.

The SCNewVsTerr86777.sql query differences the SC download with Terr86777.
It is provided for reference to inspect what records will be changed.

To simplify usage, most menu items have been removed, but are documented
below in case they need to be restored. To do the Build, all that is
necessary is to edit the "sed" Build command in the Independent commands
placing the month and day of the Diff file and prior downoad to use in
the DoSed command.<pre><code>
	./DoSed.sh m1 d1 m2 d2
where m1 = month of previous download
	  d1 = day of previous download
	  m2 = month of current download
	  d2 = day of current download
</code></pre>
<h3>Significant Notes.</h3>
Two utility shells are resident with UpdateSCBridge to facilitate getting
"stray" UnitAddress(s) associated with the proper territory.

FindAllIDinTerrs takes a single property ID and searches all of the
Terrxxx\_SC.db/Terrxxx_Bridge tables for a matching property ID. If a 
match is found, it is written to the file xxxxxxxxxx.sqllist.txt in
the $WINCONG\_PATH/temp folder, where xxxxxxxxxx is the property ID.

FindAllIDlist takes a list of property IDs from the LostIDlist.txt file
and runs FindAllIDinTerrs with each property ID in the list. The list
file is resident in the UpdateSCBridge project folder.

The LostIDlist.txt file is populated by copying a .csv that contains
the "difference" records of properties that have no territory ID
associated with them. This file has a standardized naming format:
DiffsNoTerIDsmm-dd.csv where mm, dd are the month and day of the
download differences database. Its records are obtained by query from
the DiffAccts table in SCPADiff_mm-dd.db where the records have an
empty TerrID field.

**(future).**
If the "stray" UnitAddress is not located in any of the Bridge tables
searched, a last-resort query can be run, also using the LostIDlist.txt
property IDs. These records can then be used to extract the property
record from Terr86777 (up-to-date) in order to obtain the full situs
address. The full situs address can then be queried against all Bridge
tables' SitusAddress fields, looking only at the first 35 (non-unit)
characters, with the house number field (1st field up to 1st blank)
stripped. If the street matches, it will be considered a "pretty good
guess" as to which territory the record belongs with. When a match is
found, the property ID, situs address, and Bridge territory number are
exported to the file <property-id>.situsmatches.lst in the
$WINCONG\_PATH/temp folder.

These records can then be "harvested" and placed into their proper
Bridge tables after review. Eventually, the PolyTerri and MultiMail
records for each territory will be fully completed as the addresses
are picked up on each subsequent download.<br>
<a href="#IX">Index</a>
<h3 id="6.0">link></a> 6.0 Updating Special Territories.</h3>
The UpdateSCBridge.sh shell only updates Terrxxx\_SC.db. This is a problem
for special territories since there is also a Specxxx\_SC.db that will
now be out-of-date with Terrxxx\_SC.db. DoSed.sh has been modified
to edit a new makefile, MakeUpdtSpecSCBridge.tmp. This makefile
is the template for building UpdtSpecSCBridge.sh from the query
UpdtSpecSCBridge.sql (build by \*sed\* from .psq).

<br><a href="#IX">Index</a>
