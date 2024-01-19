README.md - DiffsToMaster project documentation.<br>
1/23/23.    wmk.
###Modification History.
<pre><code>1/23/23.    wmk.   original document.
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Dependencies - project dependencies.
<a href="#3.0">link</a> 3.0 Project Build - step-by-step build instructions.
<a href="#4.0">link</a> 4.0 Significant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
DiffsToMaster updates the master territory county database with the newest records from
the SCPADiff_mm-dd.db differences database. This ensures that all subsequent
updates to county information in the territories are using the latest records.
Prior to this project, it was left to the database administrator to use manual
processes to ensure that the master territory database was up-to-date.

When fresh data is downloaded from the county it is important that the databases
be updated in a specific sequence. This will ensure that downstream dependencies
are met. This sequence is as follows:<br><br>
[ImportSCPA](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ImportSCPA/README.html)&nbsp;&nbsp;&nbsp;&nbsp;SCPA\_mm-dd.db - the SCPA county-wide download database<br>
[ExtractDiff](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ExtractDiff/README.html)&nbsp;&nbsp;&nbsp;&nbsp;SCPADiff\_mm-dd.db - records in the county-wide download that are newer<br>
&nbsp;&nbsp;&nbsp;&nbsp;than the previous download<br>
[DiffsToMaster] This project:&nbsp;&nbsp;&nbsp;&nbsp;Terr86777.db - the master territory county database records<br>
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html)&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Special/< special-db >.db,s - all "special" county<br>
&nbsp;&nbsp;&nbsp;&nbsp;dowload databases used in publisher territory generation<br>
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html)&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Terrxxx/Specxxx\_SC.db,s - all "special" territories'<br>
&nbsp;&nbsp;&nbsp;&nbsp;publisher territory special records databases<br>
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html)&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Terrxxx/Terrxxx\_SC.db,s - all publisher territories'<br>
&nbsp;&nbsp;&nbsp;&nbsp;databases
<pre><code>
</code></pre>
DiffsToMaster updates the master territory county database with the newest records from
the SCPADiff_mm-dd.db differences database. This is the third step in the above
sequence and ensures that all subsequent updates to county information in the
territories are using the latest records. Prior to this project, it was left to
the database administrator to use manual processes to ensure that the master
territory county database was up-to-date.

The master territory database is named Terr< congno > .db where < congno >
is the congregation number. For this territory system the master database is
named Terr86777.db. To ensure that SCPADiff_mm-dd.db records are up-to-date
and have territory IDs associated with each "difference" record, see the
[ExtractDiff](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ExtractDiff/README.html)
project documentation.

SCPADiff_mm-dd.db has two tables, Diffmmdd and DiffAccts. The DiffAccts table is
a mapping of parcel IDs (accounts) to territory IDs. Before running the 
UpdateSCBridge project it is important to ensure that all of the DiffAccts
records have an associated territory ID.

The /TerrData shell *WhichTerr?" will search all of the publisher territory data
files for a specified address. Start with the street name, then narrow the search
to the house/building number to determine which territory(ies) the address
resides in. From there, use the sqlite3 database browser to search the
/SCPA-Downloads/Terrxxx/Terrxxx_SC.db,s for the address. When it is found,
record the property ID (account #). Then use this property ID to manually update
the DiffAccts table Account entry with the correct territory number. This will
allow the UpdateSCBridge project to update the address's associated databases.
<a href="#IX">Index</a>
<h3 id="2.0">2.0 Dependencies.</h3>
DiffsToMaster depends upon the
[ExtractDiff](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ExtractDiff/README.html)
project having completed its extraction of the changed county records from the
latest county download. This will have built the SCPADiff\_mm-dd.db differences
database containing all of the download records for whose parcel information was
changed by the current county download. (mm, dd are the month/day of the current
county download).

The query DiffsToMaster.psq is the SQL source for updating the master territory
database. It uses INSERT/REPLACE to update the Terr86777.db records with the
newer download records.
<h3 id="3.0">3.0 Project Build.</h3>
<h3 id="4.0">4.0 Significant Notes.</h3>
