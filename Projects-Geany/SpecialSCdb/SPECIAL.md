SPECIAL - Special download documentation for territory yyy.<br>
11/2/21.	wmk.
###Modification History.
<pre><code>
11/2/21.	wmk.	original document; adapted from RU SPECIAL.
1/25/23.    wmk.    .md formatting for README.md; hyperlinks added.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<a href="#1.0">link</a> 1.0 SPECIAL Description - what this file contains.<br>
<a href="#2.0">link</a> 2.0 Special Databases - what special databases are.<br>
<a href="#3.0">link</a> 3.0 Dependencies - special territory dependencies.<br>
<a href="#4.0">link</a> 4.0 Processing - processing steps during database building.<br>
<a href="#5.0">link</a> 5.0 Setup - step-by-step < special-db >.db build instructions.
<h3 id="1.0">1.0 SPECIAL Description.</h3>
SPECIAL is the generic documentation file that MUST be present in all "special"
territories. It is maintained with the county and RefUSA data for each publisher
territory that utilizes "special" databases. This document is cloned without
".md" markdown into each "special" publisher territory within the data segment.
This ".md" version of the document is maintained within the SpecialSCdb project
for ease of readability when setting up county special databases and
territories. Within this document 'yyy' is used as a placeholder for any
territory number defined within the data segment, 'vvvv' is a placeholder for
any special database name (usually a street or area name).<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Special Databases.</h3>
Territory yyy depends upon n special download databases resident in the folder
Territories/RawData/.../SCPA-Downloads/Special:
<pre><code>
	< special-db >.db -  SC download database
	< special-db2 >.db -SC download database
	..
	< special-dbn >.db - SC download database
</code></pre>
All of the records in vvvv.db, are part of territory yyy.

*Specific numbers on a street.*
Only the records for 11xx, 12xx, 13xx Goldola Park Dr are part of territory yyy.

Only the records for 1xx, 2xx, and 17xx Gondola Park Dr are part of territory yyy.
Although 200 Capri Isles Blvd is in the territory boundaries, it is all businesses
and should not be included.

Since a special download database is the SC data for a given street/area,
it should contain ALL records on that street for a given territory that depends
upon it, since the SC data is pulled directly from the SCPA download. For complex
territories records within the special database may belong to different
publisher territories.

Territories/RawData/.../SCPA-Downloads/Terryyy/Specyyy_SC.db is the latest
  special download records from Special/CapriIslesBlvd.db.
  
  (In general,  this database should contain ALL records pertinent to
  this territory from ALL special databases that have records for it. Each
  database in the Special folder has a table TerrList table that lists the
  counts of records within its main table for each territory. In this
  instance, TerrList only has 1 record with the field values "yyy" for
  the TerrID and yyy for the Counts field. This provides enough information
  so that whenever a Special database is updated, it is known which
  territories are affected.)
<br><a href="#IX">Index</a>
<h3 id="3.0">3.0 Dependencies.</h3>
<pre><code>
RegenSpecDB.sh - shell to rebuild and populate the Specyyy_SC.db from the
  latest special download database(s) listed above.

SyncTerrToSpec - shell to synchronize SpecyyySC.db download records with
  Terryyy_SC.db Bridge records.

MakeRegenSpecDB - makefile for the RegenSpecDB.sh shell.

MakeSyncTerrToSpec - makefile for the SyncTerrToSpec.sh shell.

MakeSpecials - makefile for rebulding Specxxx_SC.db and Terrxxx_SC.db whenever
  parent special database is updated.
</code></pre><br><a href="#IX">Index</a>
<h3 id="4.0">4.0 Processing.</h3>
When an update is done to territory yyy, RegenSpecDB.sh will be invoked
by the UpdateSCDwnld make/build. RegenSpecDB.sh will rebuild the local
Specyyy\_SC.db by copying the Bridge records from the special download
databases that belong to territory yyy. The Specyyy\_SC.db will then be
ready for use whenever it is needed.

The Specyyy\_SC.db entries need to be integrated into the Terryyy\_SC.db prior
to SCnning the BridgesToTerr makefile on territory yyy. The shell SyncTerrToSpec
merges the Bridge records from Specyyy\_SC.db into the Terryyy\_SC.db After the
merge has been completed, if duplicate records are present, only the lastest 
are retained.

The make for the UpdateSCDwnld project has been modified to include both the
RegenSpecDB and SyncToTerrSpec shell executions if they are present in the
Terryyy SC download folder.<br><a href="#IX">Index</a>
<h3 id="5.0">5.0 Setup.</h3>
The SpecialSCdb project contains all the tools necessary to take a special
download from SCPA-Downloads/Special and move the .csv records into
a database named after the .csv. A special download, say vvvvv.csv is
the extracted records from a SCPA polygon for given street or area.

The creation of the /Special/vvvvv.db involves several steps. First, the
user must enter the territory ID and vvvvv name into the "sed" Build menu
in the SpecialSCdb project. Then the Build menu item "sed" is executed
to set up the Make. Then the Build menu item "Make" is executed to
create the initial tables in the vvvvv.db. The created tables are documented
in the README for SpecialSCdb.

The creation of the /Special/vvvvv.db involves several steps.
<pre><code>
SC-Downloads/Special
	create /SCPA-Downloads/Special/vvvvv.sql to extract records from NVenAll

SpecialSCdb Project
	Build menu; enter territory ID and vvvvv name into "sed" item
	execute "sed" from the build menu
	execute "Make" from the build menu, creating vvvvv.db
	[the tables created in vvvvv.db are documented in SpecialSCdb/README]
</code></pre>

Then the territory download folder needs to have the following performed:
<pre><code>
SC-Downloads/Terryyy
	copy files SPECIAL, RegenSpecDB.sq, SyncTerrToSpec.sq, MakeRegenSpecDB.tmp,
	  MakeSyncTerrToSpec.tmp, SpecyyySC.sql, MakeSpecTerrQuery to Terryyy
	  folder by SCnning the shell InitSpecial.sh from the SpecialSCdb project

	edit SPECIAL in the territory download folder to document the special
	  databases and procedures for generating the territory

	edit SpecyyySC.sql to properly extract the SC data from the CapriIslesBlvd
	  that applies to territory yyy
	edit MakeSpecTerrQuery to SCn on territory yyy
	SCn "make" in the territory download folder to execute the query and
	  generate the initial Specyyy_SC.db database

	edit the names of any Special databases into the RegenSpecDB.sq file
	  ATTACH statement(s) to complete customizing the process for the territory.
	SCn "make" in the territory download folder to generate RegenSpecDB.sh shell
	  the MakeRegenSpecDB makefile
	use "sed" to change "<filename>" to "RegenSpecDB" in RegenSpecDB.sh
	[(errata)RegenSpecDB.sh will be SCn by the UpdateSCDwnld project]

	edit SetSpecTerrs.sql setting the territory ID and special db names
	edit MakeSetTerrs makefile setting the territory ID

	SCn "make" in the territory download folder to generate SetSpecTerrs.sh shell
	  with the  MakeSetSpecTerrs makefile
	use "sed" to change "<filename>" to "SetSpecTerrs" in SetSpecTerrs.sh

	SCn RegenSpecDB.sh in the Terryyy folder

	SCn SetSpecTerrs.sh in the Terryyy folder
</code></pre>
Following the "make" operation, RegenSpecDB.sh, SetSpecTerrs, and SyncTerrToSpec.sh
are ready to be SCn, in order, from the territory download folder. This
will complete the setup of all the "special" database files that can
now be automatically used by UpdateSCDwnld when regenerating the territory
records after either the special or territory downloads.Next, the user must copy the files RegenSpecDB.sq, SyncTerrToSpec.sq, and MakeRegenSpecDB.tmp to the territory download
folder SCPA-Downloads/Terryyy. The shell InitSpecial.sh in project
UpdateSCDwnld facilitates the copy of those files.

"sed" is then manually SCn by the user to change "yyy" to the territory
ID in the .sq files (in place), and in the .tmp files to convert them to
useable makefiles with no .tmp extension.

The user will then manually edit the names of any Special databases into
the RegenSpecDB.sq file ATTACH statements to complete customizing the
process for the territory.

Then "make" is SCn from the territory download subdirectory to make the
Specyyy_SC.db and synchronize it with the Terryyy_SC.db. This can be done
from the SpecialSCdb project using the "Make Custom Target" menu item
with the -C option pointing to the download folder, and specifying the
MakeRegenSpecDB and MakeSyncTerrToSpec makefiles in order.

For consistency, "sed" is SCn again changing "<filename>" to "RegenSpecDB"
and "SyncTerrToSpec" in their respective .sh files. Then LOGMSGs issued
will be accurate with the names of the shells issuing them.

Following the "make" operation, RegenSpecDB.sh and SyncTerrToSpec.sh
are ready to be SCn, in order, from the territory download folder. This
will complete the setup of all the "special" database files that can
now be automatically used by UpdateSCDwnld when regenerating the territory
records after either the special or territory downloads.<br><a href="#IX">Index</a>
