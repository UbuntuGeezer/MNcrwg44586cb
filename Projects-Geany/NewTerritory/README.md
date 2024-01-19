README - NewTerritory project documentation.<br>
	6/2/23.	wmk.
###Modification History.
<pre><code>4/26/23.    wmk.   original document.
9/10/21.    wmk.   added Calc step for defining hdr .ods file.
9/16/21.    wmk.   WARNING about runnning SCNewTerritory project before
             running RUNewTerritory.
10/23/21.   wmk.   documentation added for letter writing territories.
3/31/22.    wmk.   project expanded for <state> <county> <congno> support;
			 .md file formatting.
4/1/22.     wmk.   Setup section expanded.
1/21/23.    wmk.   Setup section updated; .md formatting and hyperlinks.
4/26/23.	wmk.   Project Description minor changes.
4/28/23.	wmk.   New publisher territory documentation clarified.
6/2/23.		wmk.   New Territory overview clarified.
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Setup - step-by-step build instructions.
<a href="#3.0">link</a> 3.0 Support Shells - shell utilities supporting NewTerritory.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
NewTerritory sets up the code and data segments for a new congregation 
territory or for a single publisher territory. This build menu items  are
present for both the system-wide process, and the single publisher territory process.

(For detailed documentation for creating new publisher territories
within the congregation territory, see the 
[RUNewTerritory](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/RUNewTerritory/README.html)
and
[SCNewTerritory](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/SCNewTerritory/README.html)
projects.)
<br>

** New system-wide congregation territory.**<br>
The \*makefile MakeDefineCongTerr is built to create a new system-wide
territory. The "Make FullCongTerr" build menu selection performs this.
This will create both code and data segments for the new congregation territory.

To support state, county and congregation numbers for keeping territories
segregated, the state, county and congregation number is used in the
folder structure under the \*Territories\* parent folder. This allows for
congregation assigned territories that span county boundaries to be
managed under one parent directory.

**New publisher territory.**<br>
The \*makefile MakePubTerr creates a new publisher territory.
The "Make PubTerr" build menu selection performs this. This creates the
new publisher territory within the current data segment.

The initial folders created are RefUSA-Downloads/Terrxxx, 
SCPA-Downloads/Terrxxx and TerrData/Terrxxx. A "naked" publisher territory
has 0-length files Mapxxx_RU.csv and PUB_NOTES_xxx.md in the
RefUSA-Data/Terrxxx folder and Mapxxx_SC.csv in the SCPA/SCPA-Downloads/Terrxxx
folder. The empty map download .csv,s are created by the /Procs-Dev shells
MakeEmptyRUMap and MakeEmptySCMap.

Before starting, the user is prompted to define the new Territory in the
/DB-Dev/TerrIDData.db database. The database administrator will handle this
process. Once that process is complete, the *RUNewTerritory* and *SCNewTerritory*
projects are run to finish setting up the initial publisher territory databases
and TerrData files.<br>
**Associated Projects.**<br>
Two projects support the \*NewTerritory\* project for defining a new
system-wide congregation territory. They are \*NewCodeSegment\*
and \*NewDataSegment\*. Each congregation's assigned territory is treated
as its own Territory system. Any given Territory system has two segments,
a code segment, and a data segment.

The *NewTerritory* project invokes the two supporting projects to create
the segments that make up the Territory system for any given congregation.
See the README.html files under each of these projects for a discussion
of the details.

The *NewTerritory* project will first create a new data segment that
contains critical databases for the congregation's territory system. The
data segment folder system will also be defined. Then a new code segment
containing general code for managing the territory data will be created.
The code segment makes allowances for the congregation to add code that is
county-specific, and territory number-specific for generating territories
for the publishers.<br><a href="#IX">Index</a>

<h3 id="2.0">2.0 Setup.</h3>
There are two tiers to the process of setting up a new territory. The upper
tier, DefineTerr, sets up a new Territory system for a congregation. The second
tier, MakePubTerr, sets up new publisher territories within the congregation
territory system.

If a congregation's assigned territory spans more than one county, a separate
Territory system must be set up for each county. This is because each county
has its own property appraiser data that is unique to that county.

**Setting Up a Congregation Territory System**<br>
The *NewTerritory* project (this project) has all of the build components for
setting up a new congregation Territory system. Each county territory system
is organized by state, county and congregation number. This provides for data
separation even if two congregations have territory within the same county.

Three pieces of information are necessary before beginning: the two-character
state abbreviation, a four-character county abbreviaion, the congregation number.
In the steps below, the state abbreviation is represented by < state >, the
county abbreviation is represented by < county > and the congregation number is
represented by < congno >.

The data segment setup by the DefineCongTerr \*make\* process consists of the following folders:
<pre><code>
			pathbase = folderbase/Territories/< state >/< county >/< congno >
			pathbase/DB-Dev
			pathbase/RawData
			pathbase/RawData/RefUSA
			pathbase/RawData/RefUSA/RefUSA-Downloads
			pathbase/RawData/RefUSA/RefUSA-Downloads/Special
			pathbase/RawData/SCPA
			pathbase/RawData/SCPA/SCPA-Downloads
			pathbase/RawData/SCPA/SCPA-Downloads/Special
			pathbase/RawData/SCPA/SCPA-Downloads/Previous
			pathbase/TerrData
			pathbase/Territory-PDFs
</code></pre>
The code segment setup by the DefineCongTerr \*make\* process consists of the following folders:
<pre><code>
			codebase
			codebase/Procs-Dev
			codebase/Projects-Geany
			codebase/Projects-Geany/ArchivingBackups
</code></pre>
The code segment is also defined as a GitHub project to facilitate collaborative
development of code, as well as providing a second-tier of offsite backup
for the Terrtitory system code. For documention on the GitHub project see
the
[README](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/README.html)
file for the GitHub project.

**Setting Up New Publisher Territories**<br>
A new publisher territory is set up by defining the territory boundaries
and basic information in the TerrIDData.db. Once that has been done, the
*MakePubTerr* \*make\* process builds the essential file system framework
for the data segment of the new publisher territory. The database administrator
then downloads the publisher territory data from the external data sources.
Two additional projects, SCNewTerritory and RUNewTerritory
are then used to populate the publisher territory with the address data for all
parcels within the new territory. See the
[SCNewTerritory](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/SCNewTerritory/README.html)
and
[RUNewTerritory](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/RUNewTerritory/README.html)
documentation for details on these projects.

Here is an overview of the steps involved in creating a new publisher territory:
<pre><code>
	If the territory is a letter territory, the territory.pdf needs to
	 be ported to a Terrxxx_TS.ods spreadsheet file. The project to do
	 this operation is 

	Define the territory boundaries and basic information in the TerrIDData.db.
	 This includes the territory number, DoNotCalls, area name, optional
	 subterritories, zip code and status. The territory header information
	 is taken from this database.
	
	edit the territory id into the "sed" item in the Build menu
	run "sed" from the Build menu to set up the makefile for building
	 folders for the territory.
	 
	run "Make Dry Run" from the Build menu to check the setup.
	
	run "Make" from the Build menu to build the initial territory folders.
	 The initial folders are named TErrxxx so they appear first in the
	 file folders under RawData for SCPA and RefUSA. This makes the folders
	 stand out for receiving territory download data.

	run Calc on TerrData/Terrxxxhdr.csv to create Terrxxxhdr.ods
	
	use RefUSA to define and save the download polygon for the territory
	download the RefUSA polygon data into the Downloads folder
	rename the download Mapxxx_RU.csv
	move/copy the download to the TErrxxx folder under RefUSA-Downloads
	rename the folder Terrxxx so it is in its proper place in the system
	update the SystemTracker.Territory Master List sheet with the date
	 of the download, as well as the RefUSA Downloads sheet
	
	use SCPA Property Search map to define the download polygon for the
	 territory. There is no mechanism within SCPA to save the polygon.
	download the SCPA polygon data into the Downloads folder
	rename the download Mapxxx_SC.csv
	move/copy the download to the TErrxxx folder under SCPA-Downloads
	rename the folder Terrxxx so it is in its proper place in the system
	update the SystemTracker.Territory Master List sheet with the date
	 of the download, as well as the SCPA Downloads sheet
	[Note. Some territories have only 1 SCPA record (e.g. mobile home
	 parks). For these, run MakeEmptySCMap.sh from the Procs-Dev folder
	 to create an empty SC map.]
	
	move to the SCNewTerritory project to build the Terrxxx_SC.db
	set the build commands and run make

	WARNING: The RUNewTerritory project depends upon SCNewTerritory having
	 run first!
	move to the RUNewTerritory project to build the Terrxxx_RU.db
	set the Build commands and run make
</code></pre>
<a href="#IX">Index</a>
<h3 id="3.0">3.0 Support Shells.</h3>
Several support shells provide utilties for the NewTerritory project.
<pre><code>
CheckTerrDefined.sh - Check if territory file system in place for terr xxx.
CreateDataSegment.sh -  (Dev) Make RawData folders for Terr xxx.
DoSed.sh - perform *sed modifications of MakeNewTerritory.
NewTerrHdr.sh - Generate territory header .csv.
</code></pre>
<a href="#IX">Index</a>
