<p>README - ExtractDiff project documentation.
	1/14/23.	wmk.
***Modification History.
<pre><code>4/29/22.	wmk.	original document.
11/21/22.   wmk.   .md formatting; hyperlinks added.
1/14/23.    wmk.   4/26 Note obsoleted; NoTerrIDs documented.
</code></pre>
<h2>Document Sections.</h2>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.<br>
<a href="#2.0">link</a> 2.0 Primary Target Dependencies. - files and dependencies for build.<br>
<a href="#3.0">link</a> 3.0 Build Process Dependencies - process dependencies.<br>
<a href="#4.0">link</a> 4.0 Build Process - steps to build SCPADiff\_m2-d2.db<br>
<a href="#5.0">link</a> 5.0 Unassigned Properties - occupied properties unassigned to territories.<br>
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
When fresh data is downloaded from the county it is important that the databases
be updated in a specific sequence. This will ensure that downstream dependencies
are met. This sequence is as follows:
When fresh data is downloaded from the county it is important that the databases
be updated in a specific sequence. This will ensure that downstream dependencies
are met. This sequence is as follows:<br><br>
[ImportSCPA](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ImportSCPA/README.html)&nbsp;&nbsp;&nbsp;&nbsp;SCPA\_mm-dd.db - the SCPA county-wide download database<br>
[ExtractDiff] This project:&nbsp;&nbsp;&nbsp;&nbsp;SCPADiff\_mm-dd.db - records in the county-wide download that are newer<br>
&nbsp;&nbsp;&nbsp;&nbsp;than the previous download<br>
[DiffsToMaster](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/DiffsToMaster/README.html)&nbsp;&nbsp;&nbsp;&nbsp;Terr86777.db - the master territory county database records<br>
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html)&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Special/< special-db >.db,s - all "special" county<br>
&nbsp;&nbsp;&nbsp;&nbsp;dowload databases used in publisher territory generation<br>
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html)&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Terrxxx/Specxxx\_SC.db,s - all "special" territories'<br>
&nbsp;&nbsp;&nbsp;&nbsp;publisher territory special records databases<br>
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html)&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Terrxxx/Terrxxx\_SC.db,s - all publisher territories'<br>
&nbsp;&nbsp;&nbsp;&nbsp;databases<br><br>
ExtractDiff builds the shell *ExtractDownDiff.sh* that will produce a
"difference" database. This is the second step in the above sequence and ensures
that all subsequent updates to county information in the territories are using
the latest records. The "difference" database contains all the records from the
newest SC download that differ from the Terr86777.db records. This difference
database is then used downstream for bringing all other databases containing
county records up-to-date.

The Terr86777.db.Terr86777 table is now completely repopulated with the
latest download records. It turns out this is much faster than attempting
to just build a difference database with only the changed records, as it
involves comparing all the newly downloaded records with all of the present
records.

It also builds the shell *BuildDiffAccts.sh* that builds the *DiffAccts*
table within the SCPADiff_m2-d2.db . This table is a comprehensive list
of all territories affected by the new download.

The difference database is still
used to update Bridge tables in all territories to bring them "up-to-date" with
the latest SC download.

(The following CAUTION  no longer applies 4/20/22.)
CAUTION: If the newest difference database is used to update a territory that is not "up-to-date' with the latest SC download, the territory may miss one or more intervening updates. If a territory is not "up-to-date" with the latest SC download (difference), 2 options are available.
1) Run multiple updates on the territory SCBridge table using the past differences (in sequence) that the territory is out-of-date with;<br>
OR
2) Run a single update on the territory using the current Terr86777 data.<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Primary Target Dependencies.</h3>
The target ExtractDownDiff.sh is built from the BuildExtractDiff *make* and has dependencies on the following databases:
<pre><code>
Terr86777.db	- territory master database containing all SC data
SCPA_m2-d2.db - SCPA download (latest) full database
</code></pre>
The *ImportSCPA* project builds the above two databases directly from the SCPA full download
data. Their dependencies are:
<pre><code>
	SCPA-Public_mm-dd.xlsx - .xlsx full download from SC site
	SCPA-Public_mm-dd.csv - .csv of all records from .xlsx download
</code></pre>

<h3 id="3.0">3.0 Build Process Dependencies.</h3>
The build process has the following dependencies:
<pre><code>
	ExtractDownDiff.sql - SQL query to extract new records from SCPA_m2-d2.db
	 into the SCPADiff_m2-d2.db table Diffm2d2 table. (Note that the table
	 DiffAccts is not populated, since no longer testing differences record-by-record.

	BuildDiffAccts.sql - SQL query to buid the DiffAccts table which will be
	 used by the *UpdateSCBridge* project when rebuilding SCBridge tables in 
	 territories which need to be updated with fresh download data.
</code></pre>	
SCPADiff\_m2-d2.db is unconditionally rebuilt by ExtractDownDiff.sh. ExtractDownDiff.sh
is considered out-of-date if either ExtractDownDiff.s or preamble.s is newer.

preamble.s is a series of shell statements that set up the following
environment variables that are embedded in the ExtractDownDiff.sql:
<pre><code>
	SCPA_DB1="SCPA_m1-d1.db"
	SCPA_TBL1="Datam1d1"
	SCPA_DB2="SCPA_m2-d2.db"
	SCPA_TBL2="Datam2d2"
	DIFF_DB="SCPADiff_m2-d2.db"
	DIFF_TBL="Diffm2d2"
	M2D2="m2-d2"
</code></pre>	
<h3 id="4.0">4.0 Build Process.</h3>
Perform the following steps to create an SCPADiff\_m2-d2.db:
<pre><code>
ExtractDiff Project:
	edit the 'sed' Build menu command line with m1 d1 m2 d2 of the old
	 and new SCPA download dates

	run the *sed* Build command to modify preamble.s
	 into preamble.sh with all of the date fields set in the environment
	 vars

	run the *Make* Build commands to build ExtractDownDiff.sh
	 and BuildDiffAccts.sh shells
		make -f MakeExtractDiff
		make -f MakeBuildDiffAccts
</code></pre>
The following note is obsolete as of 5/22<br>
**Note.** ExtractDownDiff0426.sql now contains a valid "extract differences" SQL
query that used SCPA\_m1-d1.db against SCPA\_m2-d2.db successfully. This does the
full blown difference extraction rapidly using an INNER JOIN clause. The only
drawback for FL/SARA/8677 is that it uses the AuxSCPA.db table NVenAccts in the
INNER JOIN. This needs to be changed to use the Terr86777.AllAccts table.
<pre><code>	
Terminal session:
	 cdj ExtractDiff
	 
	 run ./ExtractDownDiff.sh to extract the new SCPA records for all
	  territories into Terr86777.db and SCPADiff_m2-d2.db
	 
	 run ./BuildDiffAccts.sh to build the DiffAccts table within SCPADiff_m2d2.db
</code></pre>	
The differences database SCPADiff\_m2-d2.db is now available for the 
UpdateTerr86777 project to use in updating the Territories Terr86777 table.

The DiffAccts table can be queried to produce a TIDList of territories that are now
out-of-date for an automated UpdateSCBridge>BridgesToTerr>ProcessQTerrs>AddPUbTerrHdr rebuild of the affected territories.

The next project to use once the Terr86777.db has been updated and the SCPADiff_m2-d2.db
has been generated is *UpdateSCBridge*. A shell file within the *UpdateSCBridge* project
will repeatedly invoke the project Build sequence for each territory in a TIDList. See
the *UpdateSCBridge* project [README](file:///media/ubuntu/Windows/Users/Bill/Territories/FL/SARA/86777/Projects-Geany/UpdateSCBridge/README.html) file for details.
<h2>Support Shells.</h2>
<pre><code>FindTerrID.sh - Search Terrxxx_SC.dbs for property ID to get territory ID.
 (in Procs-Dev folder)
</code></pre>
<h3 id="5.0"> 5.0 Unassigned Properties - occupied properties unassigned to territories.</h3>
The SCPADiff_mm-dd.db may contain records that are not assigned to any territory.
This may either be because of oversights in the addresses within exiting territories,
or new residences in newly constructed gated communities. To assist in getting all
occupied properties into territories the *NoTerrIDs* utility has been added to
the ExtractDiff project.

NoTerrIDs scans the SCPADiff_mm-dd.db table DiffAccts for records where no territory
ID has been set. It then extracts the situs addresses of all such records and
summarizes them to file NoTerrIDlist.txt. Whenever *DoSed* is run for the ExtractDiff
project, it updates the \*make process for NoTerrIDs. After the ExtractDiff shells
have completed, running the NoTerrIDs.sh shell will update the NoTerrIDlist.txt
file.

The NoTerrIDlist.txt file may then be used to 1) see if the address is in the
Terr86777.db and/or 2) see if the address is not in the SCPA-Downloads/Terrxxx/Terrxxx_SC.db
for the territory where the address belongs. If the address is not in Terr86777.db
then the [AddTerr86777Record](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/AddTerr86777Record/README.html) project is used to add the address. If the address is not in the
SCPA-Downloads/Terrxxx/Terrxxx_SC.db then the [AddSCBridgeRecord](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/AddSCBridgeRecord/README.html)  project is used to add the address.
<br><a href="#IX">link<Index>

