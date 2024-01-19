README - documentation for UpdateNVenAll Build.<br>
3/19/22.	wmk.
##Modification History.
<pre><code>
4/19/21.    wmk.   original code.
6/25/21.    wmk.   documentation update.
7/22/21.    wmk.   documentation added.
7/23/21.    wmk.   Significant Notes added.
9/30/21.    wmk.   Build Process section added.
12/2/21.    wmk.   revise 'Manual NVenAll Update' section.
1/2/22.     wmk.   formatted as .md file for html conversion;
             preamble.CreateNewSCPA.sh documented.
1/10/22.    wmk.   BuildSCDiff included in project description; SystemTracker
             note included.
2/5/22.     wmk.   SCPA Public.xlsx download documentation added.
3/19/22.    wmk.   SCPA Public.xlsx download documentation updated.
</code></pre>
##Document Sections.
<pre><code>Project Description - overall project description.<br>
Build Process - steps to follow in the build.<br>
Manual NVenAll Update - manual steps to follow in place of 'make'.<br>
Significant Notes - significant build notes not found elsewhere.<br>
</code></pre>
##Project Description.
The UpdateNvenAll project takes a given SCPA\_mm-dd.db and uses it to update
the NVenAll table within the VeniceNTerritory.db. This process will bring
the master SCPA territory records up-to-date with the SCPA\_mm-dd.db download.

The sequence for going from SC county data to updating the NVenAll table
within the VeniceNTerritory.db is as follows:
<pre><code>
Web Browser:
	
	get into the county property appraiser's site and download the data
	 for the entire county; the data should reside in a .csv file

UpdateNVenAll Project:
	
	create a new SCPA_mm-dd.db from the .csv data where mm, dd are the
	 month and day of the download; add a DownloadDate field at the end
	 of each record
	
	if this is the initial download of county data, create a database
	 that only consists of records from the county that are actually
	 within the congregation territory boundaries
	 
	add a new table to the congregation territory db containing the county
	 parcel numbers that are within the congregation territory boundaries
	
	if this is not the very first download of data from the county,
	 produce a "differences" database that contains the county records
	 for any properties that have changed since the last download; criteria
	 may be any of the columns "LastSaleDate", "HomesteadExemption"...
	 This database will be named SCPADiffs_mm-dd.db with table named
	 Diffsmmdd.
	
	insert/replace all records within the congregation territory db taken
	 from the Diffsmmdd table 
</code></pre>
###Building SCPA\_mm-dd.db.	
Provision has been made within the project to create a new SCPA\_mm-dd.db from a new SCPA download. If a new SCPA_mm-dd.db is needed, perform the following steps:
<pre><code>
	download the current SCPA data from the SCPA website; the download
	 file the site exports to is 'SCPA Public.xlsx'
	
   	(if on chromeos:
	use UpdateNVenAll/MovSCDwnld.sh to copy the spreadsheet download file from the
	 MyFiles/Downloads folder to the SCPA-Downloads/Downloads folder)

	use UpdateNVenAll/MvSCDwnld.sh to copy the spreadsheet download file from the
	 SCPA-Downloads/Downloads folder to SCPA/SCPA-Downloads/SCPA-Public_mm-dd.xlsx
	 where mm dd is month and day
	
	use Calc to load the downloaded .xlsx (this will take some time
	 as the download is approximately 84MB)
	 **Note.** Since this "loading" operation is system resource intensive, do not
	 perform any keyboard or mouse activity until after both the Calc footer (Find, etc.)
	 and Calc menu items (File, Edit, etc.) appear onscreen.
	
	Once the document is completely loaded
	 use Calc>[Auto-Calculate] checkbox and turn off autocalc 
	 save the first worksheet in the SCPA-Downloads folder as a .csv file named
	 'Datammdd.csv' where mmdd is the month/day of the download data

UpdateNVenAll Project:

	check the query code in CreateNewSCPA.psq; this will be transformed to CreateNewSCPA.sql
	 by DoSed.sh with the month and day of the download substituted in the appropriate
	 query code.

	edit the *sed* command line in the Build menu with the prior download month, day and 
	 the current download month and day.

	run *sed* from the Build menu to perform all of the modifications on dependent files
	 within the UpdatNVenAll project.

Terminal session:

	set the TODAY environment variable using the *export* command to allow shell files 
	 with embedded SQL to set the download date to TODAY in each record

	execute the following command to build the SCPA_mm-dd.db:
	  make -f MakeCreateNewSCPA
</code></pre>
At this point the SCPA_mm-dd.db will have been created in the /SCPA-Downloads folder. It has
the DownloadDate field set with each record, and has the "Account #" field as the primary key.
###Building SCPADiffs\_mm-dd.db.
With the SCPA\_mm-dd.db database in place, a "differences" database can now be built to allow
for easy updating of the congregation territory SC database. The differences db will contain
any records from the new SCPA\_mm-dd.db that differ from the current congregation territory
SC database records.

The *BuildSCDiff* project builds the SCPADiffs\_mm-dd.db. This project build should be run to
create the SCPADiffs\_mm-dd.db. Refer to that project documentation for details.

Once the SCPADiffs\_mm-dd.db is in place, the UpdateNVenAll project can be resumed to finish
the task of integrating the differences into the congregation territory database. Since the
table containing the congregation territory records was initially named NVenAll, this project
inherited that name. The NVenAll table is assumed to reside in the VeniceNTerritory.db.

**Note.** See the *Database Naming Conventions* section in the *Territories* project for
documentation on the database naming conventions used throughout the Territories system.
##Build Process.
Note: The Build process incorporates an embedded CP-DBsToMirror shell call to back up the exiting primary databases (DB-Dev) to a mirror drive for recovery in case the build process hoses things up. The user may also wish to execute IncDumpMainDBs.sh from the ArchivingBackups project folder as a second-level line of defense for recovery prior to initiating the build.

To update NVenAll perform the following steps:

UpdateNVenAll project:
<pre><code>
	Build menu: edit the 'sed' command line in the build menu with the
	 month and day of the older download and the month and day of the
	 new download
	 ./DoSed.sh  m1 d1  m2 d2
	
	run 'sed' from the Build Menu to edit all the UpdateNVenAll makefiles
	 and to set up the CreateNewSCPA.sql SQL directives; preamble.CreateSCPA.sh
	 now contains a test for env var TODAY not set

	run 'Make Custom Target.." from the Build menu to make 
	 CreateNewSCPA.sh to take SC raw download to SCPA_mm-dd.db
	[this can also be done outside the build in the Terminal app.
	 Terminal: Projects-Geany/UpdateNVenAll folder:

	Terminal:
	 ensure that TODAY env var is set; use *export TODAY=yyyy-m2-d2* to set

	 run ./CreateNewSCPA.sh to create SCPA_mm-dd.db with table
	  Datammdd; has exact match for columns in NVenAll, including
	  DownloadDate, but with no spaces in column names]
</code></pre>
Now that the SCPA\_mm-dd.db is built, this project can build the differences database SCPADiff\_mm-dd.db and use that to update the NVenAll table in VeniceNTerritory.db

The main target of this build is VeniceNTerritory.db. Its prerequisites are SCPA\_mm-dd.db and SCPADiff\_mm-dd.db, where SCPA\_mm-dd.db is the full SCPA download and SCPADiff\_mm-dd is the "differences" collection of records that have changed since the prefious full SCPA download. VeniceNTerritory.db will be considered to be out-of-date if either of the prerequisite files is newer.

The XDiffsToNVenAll.sh shell performs the update. It is built off DiffsToNVenAll.sh by stream editing m2 and d2 to produce XDiffsToNVenAll.sh. It takes the SCPADiff_m2-d2.db table Diffm2d2 and updates the NVenAll table by Inserting/Deleting entire records that have changed. This is more accurate than just doing an UPDATE of the NVenAll records, since
multiple fields may have changed that are not being tested for.

The SCNewVsNVenall.sql query differences the SC download with NVenAll. It is provided for reference to inspect what records will be changed. It may be run from the SQL user interface. A utility shell DiffsPendingList.sh has been provided on the (bashpath) that produces a list of territories affected to ~/Documents/DiffTerrs.txt. **NOTE: ON NON-PERSISTENT SYSTEMS THIS IS A TEMPORARY FILE ON VOLATILE STORAGE...**

To simplify usage, most menu items have been removed, but are documented below in case they need to be restored. To do the Build, all that is necessary is to edit the "sed" Build command in the Independent commands placing the month and day of the Diff file and prior downoad to use in the DoSed command.

**MakeUpdateNVenAll.**<br>
To update the NVenAll table in VeniceNTerritory.db perform the following
steps:
<pre><code>
	Build Menu: edit the 'sed' command line 
	 ./DoSed.sh m1 d1 m2 d2
		where m1 = month of previous download
		d1 = day of previous download
		m2 = month of current download
		d2 = day of current download

	run "sed" from the Build menu to set up MakeUpdateNVenAll,
	  DiffsToNVenAll.sh, SCNewVsNVenall.sql, BuildDiffAcctsTbl.sql
	  Note: BuildDiffAcctsTbl is a leftover from previous build recipe

	run "Make Dry Run" to check out the build prerequisites
	
	run "Make" to update NVenAll in VeniceNTerritory.db
</code></pre>
Once the NVenAll table has been updated, log the update in the *VeniceNTerritory.db Updated* column of the SystemTracker."SCPA Main Downloads" sheet for recordkeeping purposes.<br>

**MakeCreateNewSCPA.**<br>
MakeCreateNewSCPA is the makefile to create a new SCPA_mm-dd.db database from the .csv data for the download date. The .csv data is merely a *Calc* saved image of the SCPA-Public\_mm-dd.xlsx download from the county.
<pre><code>
   make -f MakeCreateNewSCPA
</code></pre>
The preceding make creates SCPA\_mm-dd.db in the SCPA-Downloads folder. This *make* process has the Build menu item *Make Custom Target..* linked to it, so it need not be run manually from Terminal in the project folder.



##=========== Build menu items for .sql file selection ===================
Following are the Build menu items. Note that these items are only visible if a file with suffix .sql is the current selection in the Geany editor.

##--- SQL commands -----------------------------------------------------
**GenSQLTemp Build...**<pre><code>	sed '{s/mm-dd/02-27/g;s/mmdd/0227/g}' SCNewVsNVenall.sql > SQLTemp.sql
</code></pre>

**CreateDiffs Build...**<pre><code>	sqlite3  < SQLTemp.sql
</code></pre>

**UpdateNVenAll Build...**<pre><code>	sed '{s/m2-d2/02-28/g;s/mmdd/0227/g}' DiffsToNVenAll.sql > SQLTemp.sql \
	  | sqlite3 < SQLTemp.sql
</code></pre>


##--- Independent commands ----------------------------------------------
**Make Build...**<pre><code>	make -f MakeUpdateNVenAll
</code></pre>

**Make Dry Run...**<pre><code>	make --dry-run -f MakeUpdateNVenAll
</code></pre>


##--- Execute commands --------------------------------------------------
**sed Build...**<pre><code>	sed -f seddirs.txt MakeUpdateNVenAll.tmp > MakeUpdateNVenAll
</code></pre>


##=========== Build menu items for .sh file selection ===================

##--- sh commands -------------------------------------------------------
**sed Build...**<pre><code>	sed '{s/m2/02/g;s/d2/27/g;s/mmdd/0227/g}' DiffsToNVenAll.sh > XDiffsToNVenAll.sh
</code></pre>


##Manual NVenAll Update.
To manually update NVenAll from a given download and prior download
perform the following steps:

-- create and populate new SCPA\_mm-dd.db
<pre><code>	Web Browser: SCPA Property Search.

	download the current SCPA data using the SCPA site "Downloads" to
	 download today's SCPA data to file 'SCPA Public.xlsx', and change
	 the filename to SCPA-Public_mm-dd.xlsx where mm and dd are the
	 current month and date

	Calc: - folder SCPA/SCPA-Downloads open SCPA-Public_mm-dd-yy.xlsx
	use Calc to save the file as 'SCPA-Public_mm-dd.csv as a text .csv
	 file that can be used by SQL to import all the data into a new .db

	SQL Browser:
	use SQL browser to create new database SCPA-mm_dd.db in SCPA-Downloads
	 folder, empty with no table defined
	 
	use Import from the File menu in SQL browser to import from csv file
	 created by calc above; select 'header in first row' option; select 
	 trim fields option; this trims blanks out of all the column names
	 as well; name the table 'Datammdd' for the month and date of the
	 download
</code></pre>

-- create and populate a differences database SCPADiff_mm-dd.db
<pre><code>	run the QSCPADiff query to create a new empty database SCPADiff_mm-dd.db,
	 extract a Diffm2d2.csv of difference records comparing SCPA_m1-d1.db against
	 SCPA_m2-d2.db by recording records from the newer m2-d2 where the
	 LastSaleDate or HomesteadExemption(YESorNO) field has changed from m1-d1,
	 then importing those records into table Diffm2d2 in the new database
</code></pre>

-- backup the exiting key databases to the mirror folder
<pre><code>	execute (procpath)CP-DBsToMirror.sh
</code></pre>

-- run the XDiffsToNVenall shell to integrate the changed records into
	the NVenall table
<pre><code>		ensure that the m1 d1 m2 d2 are properly set in XDiffsToNVenAll.sh by
	 using DoSed from the UpdateNVenAll project to edit DiffsToNVenAll.sh
	
	execute XDiffsToNVenAll.sh from the project

	run sqlite on BuildDiffAcctsTbl.sql to update the TerrID table in
	 SCPADiff_m2-d2.db with all territory IDs affected by this difference
	 table; that list is obtained by grabbing CongTerrID fields from
	 PolyTerri and MultiMail TerrProps and SplitProps tables where the
	 OwningParcel is in the TerrID table.
</code></pre>

##Significant Notes.
**NOTE:** As of 9/30/21 there is a bug in the build recipe that keeps running QSCPADiff from the (bashpath), when the SCPADiff\_mm-dd.db has already been created/updated. The makefile has been modified to throw a fatal error when this occurs. If everything else has beeen set up properly, enter the Terminal and run XDiffsToNVenAll.sh to force the update of NVenAll records around the makefile.
**END NOTE.**

BugFixes.sql contains queries that fix database bugs introduced by various updates.

As of 8/26/21 spaces in field names for Diffm2d2 table have been removed. SCPA-mm\_dd.db download fields, SCPADiff\_mm-dd.db fields are now consistent with no spaces in the field names. This is because downloads are now imported with "trim fields" option.

The VeniceNTerritory.db database still has the original space-filled field names, so this is taken into consideration when the NVenAll tables are updated.

