README - Documentation for SpecialRUdb project.<br>
1/25/23.    wmk.
###Modification History.
<pre><code>5/14/22.    wmk.    Build steps clarified for updating.
5/29/22.    wmk.   .md formatting improved; links added.
5/31/22.    wmk.   "Batch Runs of SpecialRUdb" section added.
12/25/22.	wmk.   Migrating to Other Territory Systems expanded.
12/29/22.   wmk.   hyperlinks updated for Chromebook system.
1/23/22.    wmk.	Chrome OS note added into Project Description.
1/25/23.    wmk.   Complex territories notes added to Project Description.
2/11/23.    wmk.   ForceBuild documentation.
Legacy mods.
4/24/21.    wmk.   original documentation.
6/7/21.     wmk.   documentation of SPECIAL file for RU downloads;
             Dependencies section added.
7/18/21.    wmk.   scope of project reduced to eliminate UpdateRUDwnld
			 phase; only generates special RU datbase. project
			 name change to SpecialRUdb to reflect fact that is
			 specific to RU special databases.
8/16/21.    wmk.	Documents Section section added.
8/31/21.    wmk.	download step added to Build Steps section.
9/10/21.    wmk.	Dependencies updated; InitSpecial dependency documented.
11/7/21.    wmk.	MvSpecDwnld.sh documented; Project Description expanded.
11/8/21.	wmk.	CatSpecDwnld.sh documented; Build Steps "update" comments
			 added.
11/14/21.   wmk.	IMPORTANT NOTE added to Project Description.
12/4/21.    wmk.    Build steps clarified where multiple download files
			 are used.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - general projeact description.
<a href="#2.0">link</a> 2.0 Dependencies - project dependencies.
<a href="#3.0">link</a> 3.0 Build Steps - steps to build <special-db>.db.
<a href="#3.1">link</a>     3.1   Batch Runs of SpecialRUdb.
<a href="#4.0">link</a> 4.0 Auxiliary Files and Processes - files resident in project folder.
<a href="#5.0">link</a> 5.0 Results - targets and results of build process.
<a href="#6.0">link</a> 6.0 Migrating to Other Territory Systems.
<a href="#7.0">link</a> 7.0 Significant Notes - stuff to know, not in other sections.
<a href="#8.0">link</a> 8.0 List of Special Databases - list of special dbs in RU-Downloads/Special.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
Some territories contain have streets as boundaries where one side of the street
is in one publisher territory and the other side of the street is in a different
publisher territory. If a long street serves as the boundary for several
publisher territories different segments and different sides of the street may
be in several different territories.

Complex territories pose a unique set of challenges in separating download data
into the correct territories. To meet this challenge "special" download databases
are supported that allow downloading all addresses for a single street (or area)
into one database. Then each address within that database is tagged with which
territory it is assigned into. Databases which contain this type of records are
termed "special" database. Territories which utilize these databases are called
"special" territories.

Because of using two sources for publisher territory data, there are two types
of "special" databases; those that contain county data and those that contain
RefUSA data. For consistency it is wise to define the county and the RefUSA
databases with matching names to facilitate identification. Wherever practical
the county data should be considered the "master" for the special data. By doing
this, the RefUSA data can then be more easily harmonized with the owner data in
the county special database.

The county special database should be defined and reconciled for accuracy before
defining the RefUSA special database. This makes for much easier coordination of
the publisher territory records between the county and RefUSA data. For further
information on setting up county special databases see the
[SpecialRUdb](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/SpecialSCdb/README.html)
project documentaion.

The SpecialRUdb project takes a special RU download .csv and
creates a .db that mimics a Mapxxx_RU.db database. The .csv and its
associated .db resides in folder ~/RefUSA/RefUSA-Downloads/Special.

**IMPORTANT NOTE.** Once the /Special/< special-db > has been built, each
territory using it must have a set of files specific to that territory
to incorporate the < special-db > records into its Terrxxx_RU.db. The file
[SPECIAL](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/SpecialRUdb/SPECIAL.html) with this project documents this
process.

A utility shell, MvSpecDwnld.sh, is incorporated into the project to move
Special download files from the ~/RefUSA-Downloads/Downloads folder into
the ~/RefUSA-Downloads/Special folder. The Special downloads are .csv files
of records extracted from RefUSA using either map polygons or street
names. (See "Auxiliary Files and Processes" below.)

**Chrome OS Note:** A second utility shell, MovSpecDwnld.sh is provided for
builds on chromeos-based systems (e.g. ChromeBook). The raw .csv files on
these systems are downloads to /mnt/chromeos/MyFiles/Downloads. From there
they need to be moved to the ~/RefUSA-Downloads/Downloads folder. The
MovSpecDwnld.sh shell performs this move. Then MvSpecDwnld.sh is invoked
to complete the move to the ~/RefUSA-Downloads/Special folder.

Any territory that requires special RU download processing will contain
a documentation file SPECIAL, similar to README for a project. The
SPECIAL file reside in the territory's folder ~/RefUSA-Downloads/Terrxxx.
It will contain the documentation of the special database(s)
(resident in folder /RefUSA-Downloads/Special) that are required to
correctly generate the Terrxxx_RU.db/RUBridge table.

Some territories can only be properly populated when entire street(s)
are downloaded from the RU data. One such case is territory 289 located
in Gondola Park/Capri Isles. The RU data is properly allocated into
its Terr289_RU.db/Terr289_RUBridge table by isolating the appropriate
RU parcel IDs and addresses. This is handled by the UpdateRUDwnld build
running Fix289RU.sh. Its complement "fix" for the RU data is Fix289RU.sql.

SpecialRUdb builds a .db from the .csv that is the street(s)
download from RefUSA. The database has 4 tables:
<pre><code>
	< special-db > - table with same name as .db file; contains raw map/street
	 download data
	
	Spec_RUBridge - Bridge format records extracted from the raw data
	
	PropTerr - table of property IDs, street addresses, and territory
	 numbers; note that several territories may need records from the
	 same special db (like letter-writing territories)
	
	TerrList - table of territory IDs and record counts for each territory
	 having records within the database
	
	(See "Results" section for further details of the < special-db >.db)
</code></pre>
RUSpecTerr_db.sql is the SQL source for this build. It will be run through
AnySQLtoSH to generate the shell that actually runs sqlite3 and creates
the <spec-name>.db. The "preamble.s" file that AnySQLtoSH needs for 
this process is saved in the SpecialRUdb project directory.

Fix201RU.sql, Fix289RU.sql and any similar post-download fix shells will
now have the flexibility to use "special" download databases to include/exclude
download records for street(s) in their territories. The "special"
databases that they will use are created by SpecialRUdb Build processes.

**Special < special-db > Backups**
The special databases that are territory-wide (resident in the RefUSA-Downloads/Special
folder) and those that are territory-specific (resident in RefUSA-Downloads/Terxxx
folders) are all backed up by the *ArchivingBackups* project. They are included in
the dumps of RU raw data. See
 [Archiving Backups](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ArchivingBackups/README-Territories.html) project documentation for details.<br>
<a href="#IX">Index</a>
<h3 id="2.0">Dependencies.</h3>
Prior to running the Build for SpecialRUdb, the InitSpecial.sh shell
must be run to set up the base files the build uses. The base files
will have to have been edited for the territory SpecialRUdb is run on.
<pre><code>RUSpecTerr_db.sql - sql that processes new "special" downloads into .db
  for territory xxx.
  3 tables created; Specxxx_RURaw, Specxxx_RUPoly, Specxxx_RUBridge.

RUSpecTerr_db.sh - shell that processes new "special" downloads into .db
  in territory xxx;
  runs code from RUSpecTerr_db.sql query; 3 tables created; Specxxx_RURaw,
  Specxxx_RUPoly, Specxxx_RUBridge.
 
<vvvv>.csv - download data
</code></pre>
<a href="#IX">Index</a>
<h3 id="3.0">3.0 Build Steps.</h3>
The creation of the /Special/vvvvv.db involves several steps.

**Note** This method originally used street-name downloads. Some of the newer
downloads used RefUSA polygon (I think the same fields get downloaded
either way).

**Updating** There is no provision for "updating" a ~/Special/vvvvv.db. It must
be completely rebuilt whenever there is a new .csv download. This means
that all of the vvvvv.csv files must be downloaded close to the same date
as the most recent SCPA download to keep the RU Special dbs as closely
synched to the SCPA data as possible. The shell CycleSpecialRU.sh should
be run to preserve the .db history in ./Previous.

The makefile "Make.< special-db >.Terrs" is defined for each Special database
with the necessary *make* calls to regnerate all territory .dbs that are
affected by the build of the < special-db >.db. This ensures that all
territories dependent upon the < special-db >.db are rebuilt and kept in 
synch whenever a Special database is updated.

Currently, it is left to the user to manually run *make* from the /Special
folder for the < special-db > after SpecialRUdb has been run rebuilding
the < special-db >. This will refresh all of the territories affected by updating
the < special-db >. These *Make.< special-db >.Terr* makefiles run the
*MakeSpecials* makefile for each territory.


*Obsolete*
[The makefile "MakeSpecTerrsUpdate" and its associated SpecTerrsUpdate.sh
shell utility are provided to update the Spec_RUBridge table from each
territory that uses the <special-db>. The "Update Special TerrIDs" Build
menu item performs the "make" and executes SpecTerrsUpdate.sh]

To regenerate the /Special/< special-db >.db perform the following steps:
<pre><code>RU-Downloads/Special

	download street(s) into /Special folder; if multiple downloads will
	 be used as one .db, name the files < special-db >-n.csv where *n*
	 is the segment number, then use *cat* utility to concatenate into one
	 < special-db >.csv file; < special-db > will be the .db name
	 Note: Download the .csv files into the RefUSA-Downloads/Downloads
	  folder. Then use SpecialRUdb/MvSpecDwnld.sh to move the .csv files
	  to the /Special folder. If multiple segments are present for the
	  < special-db > use SpecialRUdb/CatSpecDwnld.sh to run the *cat* utility
	  to consolidate the download.
	 
SpecialRUdb Project:
	
	Build menu: (move Geany to README file to expose "No file type commands"
	 in the build menu
	If this is not the initial generation of the < special-db >.db:
	 edit the < special-db > name into the "Cycle Special DB" build command field
	 run "Cycle Special DB" to preserve the current .db and its Fix.< special-db >.sql
	  to ./Previous
	
	Build menu; enter territory ID and vvvvv name into "sed" item
	execute "sed" from the build menu; if the vvvvv.db covers more than one
	 territory enter '' for the territory parameter.

	execute "Make" from the build menu, creating vvvvv.db
	[the tables created in vvvvv.db are documented in SpecialRUdb/README]

	code /Special/vvvvvTidy.sql: after the above Make operation, the vvvvv.db
	 tables still lack OwningParcel, SitusAddress, PropUse and RecordType
	 column data being set. By providing vvvvvTidy.sql, a shell can be
	 built specific to the vvvvv.db to set those fields. [WaterfordNETidy.sql
	 can be used as a template].
	   in the RU-Downloads/Special folder:
	     
Terminal session:
  cd to the RefUsa-Downloads/Special folder
  set the TODAY environment variable as a exported var with
   export TODAY=yyyy-mm-dd
  where yyyy, mm, dd are the year, month day of the download data
		 
  run ./DoSedAnyTidy.sh vvvvv to convert vvvvvTidy.sql to set up
   the makefile Make.AnyTidy
	       
  run make -f Make.AnyTidy --dry-run to test the make script
  run make -f Make.AnyTidy to create the vvvvvTidy.sh
  run ./vvvvvTidy.sh to perform the SQL table operations
	 
	Build note: In the case where error(s) are discovered in the generated
	 database due to bad data in the RU download, the file Fix.<special-db>.sql
	 will be present in the /Special folder. This file will be converted
	 to a .sq file, then a Fix.<special-db>.sh shell will be generated
	 and executed to correct the download issues.
	 MakeFixDownload makefile can be tested using the Build>Make Custom Target
	  menu item, with -C (projpath) in the parameter list
</code></pre>
The /Special/< special-db >.db will now be in place for use with territories.
If this is a new *special* database, likely the code within each territory's
RefUSA-Download folder for the special
db handling will need to be updated to contain references to the new db,
selecting the appropriate records for processing (RegenSpecDB.sql). This
implies modification of the *MakeSpecials* makefile to include the new
db name.

Sometimes the < special-db >.db looks "up-to-date" when it needs rebuilding. In
other cases sometimes the Terrxxx/Specxxx_RU.db appears to be "up-to-date" when
it is not. A semaphore file **ForceBuild** has now beeen added as a prerequisite
in many of the build *make files. If it is newer than the target for which it
is a prerequisite, it will force rebuilding of the target, regardless of other
prerequisites. A new command alias **forcebuild** updates the sempahore and 
will force subsequent "make"s to happen.

Once the territories' *special* code has been updated for all affected
territories they need to be rebuilt.
Ensure the territories dependent upon < special-db >.db are updated by running
*make* on the Make.< special-db >.Terrs makefile:
<pre><code>
  run make -f Make.< special-db >.Terrs --dry-run to verify the makefile
  run make -f Make.< special-db >.Terrs to update all affected territories.
</code></pre>
<a href="#IX">Index</a>
<h3 id="3.1">3.1 Batch Runs of SpecialRUdb.</h3>
When multiple special RU databases are downloaded, like in periodic updating
operations, batch runs are desirable. This can be accomplished by placing the
special database names to be rebuilt in the list file DBList.txt in the project.
Then it is just a matter of running a shell to regenerate all of the listed
special databases.

To perform a batch run to rebuild multiple databases do the following:
<pre><code>
SpecialRUdb Project:
	edit the DBList.txt file adding the special database names to process
	 (you may use '#' to begin a line of comments to be ignored)

Terminal session:
	cdj SpecialRUdb to get into the project folder

	run the batch rebuild shell with the following command:
	 ./RebldAllRUSpecials.sh
</code></pre>
Upon completion, all of the special databases will have been rebuilt from their
.csv download files. A log of the SpecialRUdb runs is saved on file
ReldAllSpecRUSpecials in the TEMP_PATH folder.
<br><a href="#IX">Index</a>
<h3 id="4.0">4.0 Auxiliary Files and Processes.</h3>
<pre><code>MvSpecDwnld.sh - shell utility to move download .csv files from the
  ~RefUSA-Downloads/Downloads folder to the ~/RefUSA-Downloads/Special
  folder; when data is downloaded from RefUSA, the /Downloads folder
  is the staging area to receive the data in persistent storage. The
  SpecialRUdb project needs the data to be in the /Special folder.

  Usage. bash (projbase)/MvSpecDwnld.sh < special-db > [count]


CatSpecDwnld.sh - shell utility to concatenate multiple .csv files for
  < special-db > into a single .csv < special-db >.csv
 
  Usage. bash (projbase)/CatSpecDwnld.sh < special-db > count[ >= 2 ]

CyclePrevSpecRU.sh - shell utility to cycle previous /Special/< special-db >
 files to ./Previous prior to regeneration of < special-db >.
 
  Usage. bash (projpath)/CyclePrevSpecRU.sh < special-db >
  
 Note: the wisest thing to do is to perform an IncDumpRURaw just prior
 to the MakeRegenSpecDB *make*

ClearSpecial.sh - shell utility to remove publisher territory special
 SQL, *make*, and shell files so that the folder is "clean" for InitSpecial.

  Usage. bash (projpath)/ClearSpecial.sh <terrid>

InitSpecial.sh - shell utility to edit territory id into and copy all
 SQL, *make*, and shell files into a "fresh" special publisher territory.

  Usage. bash (projpath)/InitSpecial.sh <terrid>

SetSpecialDNCs.sh - shell utility to set DNCs in < special-db > RUBridge
 records. Now called as part of MakeSpecialRUdb makefile.
  
UpdateSpecTerrIDs.sh - shell utility to update any given < special-db >
 territory IDs, given the list of territories using < special-db >. These
 lists are stored as < special_db >.TIDList.txt in the /Special folder.
 The UpdateSpecTerrIDs.sh copies the list to {SpecialRUdb}/TIDList.txt
 for use by the "make" of MakeSpecTerrsUpdate.

RebldAllRUSpecials.sh - shell utility to rebuild all special RU databases
 in the DBList.txt list of databases. All are rebuild from their current
 .csv files in the /Special folder.

**Territory SQL, makefile, and shell Templates.**
These files are cleared in the publisher territory folder by ClearSpecial.sh
and are copied to the publisher territory folder by InitSpecial.sh. Once
copied to the publisher territory, the project manager will edit them
appropriately to tailor them to the specific needs of the territory.

SPECIAL - documentation (template) for details about the "special" aspects
 of the publisher territory. Always included is the list of < special-db >
 databases upon which the territory is dependent.

MakeRegenSpecDB.tmp - (template) makefile to be copied to RU territory
  download folder and edited to MakeRegenSpecDB specific with territory
  ID. Contains all essentilal elements to build RegenSpecDB.sh that
  rebuilds the Specxxx_RU.db of special download records.

MakeSyncTerrToSpec.tmp - (template) makefile to be copied to RU territory
  download folder and edited to MakeSyncTerrToSpec with specific territory
  ID. Contains all essential elements to build SyncTerrToSpec.sh that
  synchronizes the Terrxxx_RU.db records with the special download
  records in Specxxx_RU.db.

RegenSpecDB.sql - (template) SQL query to be copied to RU territory download
  folder and edited/replaced with specific territory ID, and Special db
  ATTACH statements to rebuild the Specxxx_RU.db table Spec_RUBridge. The
  Spec_RUBridge table will be used by SyncTerrToSpec.sh to synchronize
  the Terrxxx_RU.db records with the special download records in the
  Specxxx_RU.db

SpecxxxRU.sql - SQL template for extracting data from the <special-db>.db
  for placement in the Specxxx_RU.db within territory xxx

MakeSpecialRUdb.tmp - makefile template for building the Specxxx_RU.db
  within a territory

SyncTerrToSpec.sql - (template) SQL query to be copied to RU territory
  download folder and edited/replaced with specific territory ID in SQL
  statements to merge the special download records from Specxxx_RU.db
  with the records in Terrxxx_RU.db. After the merge, the oldest duplicate
  records are removed, if present.
</code></pre>
<a href="#IX">Index</a>
<h3 id="5.0">5.0 Results.</h3>
The primary target of MakeSpecialRUdb is the database < special-db >.db
on path RU-Downloads/Special. < special-db > will have one of the names
in the List of Special Databases below.

The < special-db >.db will be considered out-of-date if its corresponding
.csv download is newer. It will also be considered out-of-date if any
of RUSpecTerr\_db.sh, .sql or .sq or SetNewBridgeTerrs.sql is newer.


< special-db >.db - database named after street or area
 
  SpecialRUdb will build 4 tables, the first being the "raw"
  map download data table "Special_Raw", and the second the sorted map
  download data "Special_Poly".

  A third table is then built, "Special_Bridge" The records in this Bridge
  table are generic, that is they have unfilled fields "CongTerrID" to
  allow for filling in with the appropriate territory that any given
  address belongs to. This accounts for the fact that the special download
  may have grabbed all the addresses on a given street, but the street
  crosses multiple territory boundaries.

  A fourth table (empty) is added, "TerrList", that will contain the list
  of territories whose records are in this .db. Since a given street may
  cross territory boundaries, its Special download may contain records
  for more than 1 territory.

By implementing this, all territories that are "special" cases can be
handled the same way. A special RU map download will download the .csv
whenever the territory RU data is to be updated. The SpecialRUdb Build
will build/rebuild the special .db from scratch with the new data. It will
then be available for the UpdateRUDwnload Build to use when updating
the RU data for the territory.

< special-db >.db may contain a table by its own name built from a .csv
for the .db. The table by its own name is not updated by MakeSpecialRUdb.
If a given territory uses that table in its processing, it is left up to
the local code for that territory (likely FixyyyRU.sql) to make any
required updates.

< special-db >.db has 4 tables rebuilt by MakeSpecialRUdb: Spec_RURaw,
Spec_RUPoly, Spec_RUBridge and TerrList. The Spec_RUxxx tables are all
derivatives of the .csv download. These tables may contain records that
belong to more than one territory, since the < special-db > may be for a
street that crosses territory boundaries.

The TerrList table is built empty by MakeSpecialRUdb. For now, the user
will need to update the TerrList table manually after the <special-db>.db
is updated. (ideas for automating the TerrList table update include having
each territory RU download folder contain a shell that adds its territory
ID to the TerrList table; an alternative might be to have a .db stored
in the Special folder that maps territory IDs to the various databases
in Special...)<br>
<a href="#IX">Index</a>
<h3 id="6.0">6.0 Migrating to Other Territory Systems.</h3>
Each Territory system will have its own Special dbs along with the special
handling code in each territory folder.

The special projects *FixMakes* and *FixTerrMakes* are provided to handle
migration of makefiles across Territory systems. The *FixMakes*project
provides for automated editing of a single makefile, or all makefiles
within a given folder. The *FixTerrMakes* project provides for automated
editing of the makefiles in multiple territory folders within a Territory
system.

These two projects standaradize the opening section of all makefiles with
variable definitions that tailor each makefile to the Territory system in
which they reside. Specific instructions are present in the README files for both *FixMakes* 
and *FixTerrMakes*. When the Territory system is implemented for a new state,
county and congregation number, These projects facilitate the migration of the
code. 
[README for FixMakes](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/FixMakes/README.html)
[README for FixTerrMakes](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/FixTerrMakes/README.html)

While the structure of a "special" publisher territory fits within a standardized
profile of support files and associated makefiles, each special territory
has its own set of constraints. The primary constraint on a special publisher
territory is the set of special databases on which it is dependent.

The dependency is defined in the system from two directions. At the top level, the
RefUSA-Downloads/Special folder contains makefiles associated with each < special-db >.
A typical < special-db > may consist of a street or a group of streets within a
community (like a gated community or mobile home park). The makefiles that build
the < special-db > from downloaded data transform the download data into "bridge"
tables that can be used to provide records for a special publisher territory. The
makefiles also map which publisher territories need to be updated when the < special-db >
is updated.

The second dependency is defined at the publisher territory level. The publisher
territory has its own "special" database when it depends upon a /Special/< special-db >.
That special database within the publisher territory is always named "Specxxx_RU.db"
where *xxx* is the territory ID. It contains all extracted records from one or more
< special-db > databases that belong with this territory. The *MakeSpecials* makefile
is coded for each special territory to build its *Specxxx_RU.db"

The shell files and makefiles for each special publisher territory exist as templates
within the *SpecialRUdb* project. Whenever a new "special" publisher territory is
implemented, shell utilities edit and copy the templates into the publisher territory
folder. To complete the setup, those copied files are edited and tailored to the
definition of the special territory.<br>
<a href="#IX">Index</a>
<h3 id="6.5">6.5 Repairs to Migration Territories.</h3>
In addition to the standard migration procedures documented in the previous section,
since there is no "install wizard" for installing a territory system additional utilities
are needed to align the migrated territories with the new system. A special project
*MigrationRepairs* has been provided that batch edits corrections into the publisher
territory code and data segments.

The documentation for repairing migrations of territories is contained within the
[Migration Repairs](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/MigrationRepairs/README.html#7.0) documentation.<a href="#IX">Index</a>
<h3 id="7.0">7.0 Significant Notes.</h3>
MakeSpecialRUdb does not account for the fact that the new .csv may not
contain all records that were in the original .db. There needs to be
another utility/query that will determine if the prior .db had records
that were not included in the current download. This is important since
RefUSA may have picked up records in the prior download that do not 
have current residents in the present download.

If some different additional records were in the previous download, they
need to be added into the current download with a "?" for the Resident1
field. This is only important for single parcel territories where there
are no RU records for each property. Thus, MHPs have Special .csv and 
.db names that reflect their name instead of street names. The UpdateRUDwnld
project will account for this and deal with ensuring address preservation
across downloads.<br>
<a href="#IX">Index</a>
<h3 id="8.0">8.0 List of Special Databases.</h3>
<pre><code>7/18/21.
AirportAveAll.csv		AlbaStAll.csv		AuroraStAll.csv
AvenidaEstancias.csv	AvensCohosh.csv	   	BayIndies.csv
BayIndies.db			BayIndiesN-1_RU.csv	BayIndiesN-2_RU.csv
BayIndiesN-3_RU.csv		BayIndiesN-4_RU.csv	BayIndiesS-1_RU.csv
BayIndiesS-2_RU.csv		BayLakeMHP.csv		BirdBayCir.csv
BirdBayDrW.csv			BirdBayDrW.db		BirdBayWay.csv
BirdBayWay.db			CapriIslesBlvd-1.csv	CapriIslesBlvd-2.csv
CapriIslesBlvd-3.csv	CapriIslesBlvd.csv	CasaDelLagoWay.csv
GondolaDiffs.txt		GondolaParkDr.csv	GondolaParkDr.db
GondolaParkDrFull.csv	MalinaCt.csv		MalinaCt.db
Previous				RUBayIndies_07-04.csv	RUBayIndies_07-04.db
RUBayLakeMHP_07-04.csv  RUBayLakeMHP_07-04.db	RUPrevious.tar.gz
RURidgewoodMHP_07-04.csvRURidgewoodMHP_07-04.db	RUSpecTerr_db.s
RidgewoodMHP.csv		SQLTemp.sql			SpecialList.txt
Special_RU.db			TheEsplanade-1.csv	TheEsplanade-2.csv
TheEsplanade.csv		TheEsplanade.db		VillageCir.csv
VillageCir.db			VistaDelLagoWay.csv	junk.txt
</code></pre><br>
<a href="#IX">Index</a>

