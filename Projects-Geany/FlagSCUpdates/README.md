README - FlagSCUpdates project documentation.<br>
	4/30/22.	wmk.
<h2>Modification History.</h2>
<pre><code>11/3/21.   wmk.   original document.
1/3/22.     wmk.   sections divided; accuracy checked.
4/30/22.    wmk.   .md formatting updated for pandoc utility.
5/27/22.    wmk.   .md formatting reverted to *markdown* utility; links
			 added.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall description of project.
<a href="#2.0">link</a> 2.0 Setup - step-by-step build instructions.
<a href="#3.0">link</a> 3.0 Updating a Territory - overview of process of updating a territory.
<a href="#4.0">link</a> 4.0 Batch Runs of FlagSCUpdates.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
FlagSCUpdates is the first in a sequence of projects to be "built" when
managing territory updates. For an overview of the process of updating a
territory see the section *Updating a Territory*.

FlagSCUpdates scans the SCPADiff\< mm >-< dd >.db to see if the specified
territory has SC records that are out-of date. It notes at least one out-of-date
record in the SCPA-Downloads/Terr< terrid > folder in the Updt< terrid >M.csv
or Updt< terrid >P.csv files.<br><a href="#IX">Index</a>
<h3 id="2.0">2/0 Setup.</h3>
Before running the build for FlagSCUpdates:<pre><code>
	Download the latest SC data to /SCPA-Downloads/SCPA\_mm-dd.db
		(e.g. SCPA\_02027.db is the download from 2/27/21.)
	(run whatever query generates SCPADiff\_mm-dd.db differences database)

FlagSCUpdates Project:
	
</code></pre>
<a href="#IX">Index</a>
<h3 id="3.0">3.0 Updating a Territory.</h3>
**Overall Sequence.**<br>
When updating a territory with new download data, perform the following sequence:
<pre><code>
	Download the latest SC data to /SCPA-Downloads/SCPA\_mm-dd.db
	 (e.g. SCPA\_02-27.db is the download from 2/27/21.)
		
	Build FlagSCUpdates (this build) for territory yyy
	
	Build UpdateSCBridge for territory yyy
	
	[ Terryyy\_SC.db/Terryyy\_SCBridge is now up-to-date ]
	
	Download the latest RU data for territory yyy to /RefUSA-Downloads/Terryyy
	
	Build UpdateRUDwnld for territory yyy
	
	[ Terryyy\_RU.db/Terryyy\_RUBridge is now up-to-date ]
	
	Build BridgesToTerr for territory yyy
	
	[ PolyTerri/MultiMail.dbs now up-to-date for territory yyy ]
	
	[ TerrData/Terryyy/Working-Files now has QTerryyy.csv base ]
</code></pre>
To generate the updated PubTerr there is a project just for territory building.
The project name is *DoTerrsWithCalc*. This project has a LibreOfficeCalc
spreadsheet "ProcessQTerrs12.ods" that integrages the entire process of creating
a publisher-ready territory from the file in the TerrData/Working-Files folder
for the territory. It has an entire Calc library of support macros, *Territories*,
along with internally defined macros that accomplish the publisher territory build.
See the *DoTerrsWithCalc* project 
[README](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/DoTerrsWithCalc/README.html)
 file for more documentation.

Following is a crude, and somewhat outdated, summary of what running the *Main* macro from ProcessQTerrs12.ods accomplishes:<br>
	Run Calc and open QTerryyy.csv<br>
	 save as workbook QTerryyy.ods<br>
	 open the TerryyyHdr.csv or .ods for the header<br>
	 [save TerryyyHdr.csv as .ods for future use]<br>
	 use alt-e to export the header to the QTerryyy.ods<br>
	 use ctrl-w to close the header sheet<br>
	 use ctrl-s to save the two-sheet QTerryyy.ods<br>
	 change the tab color on QTerrxxx to dk-lime and protect<br>
	 change the tab color on TerrxxHdr to dk-lime and protect<br>
	 use ctrl-s to save the workbook<br>
	 from the QTerrxxx sheet use ctrl-4 to generate the PubTerr<br>
	 use ctrl-s in the new "untitled" sheet to save as Terrxxx\_PubTerr.ods in the /TerrData/Terryyy folder
	 Unprotect the Terrxxx\_PubTerr sheet<br>
	 Change the View to freeze rows and columns at 6A<br>
	 Highlight all the data cells and use ctrl-F10 to align top and wrap text<br>
	 Use ctrl-h to highlight the all the address groupings<br>
	 Use ctrl-6 to set Landscape format and turn on grid lines<br>
	 use ctrl-s to ensure the whole mess is saved<br>
	 use ctrl-7 to save an .xlsx copy<br>
	 use ctrl-8 to save a .pdf copy<br>
	 use ctrl-w to close the PubTerr workbook<br>
	 use ctrl-s and ctrl-w to close the QTerryyy.ods workbook<br>

The SystemTracker.ods in the RawData/Tracking folder is used to track all changes. At each stage of the above process, the SystemTracker should be updated. (That is a whole separate topic...).<br>
<a href="#IX">Index</a>
<h3 id="4.0">4.0 Batch Runs of FlagSCUpdates.</h3>
FlagSCUpdates can be run on multiple territories when updating after a
new SCPA download. The shell *FlagAllSCUpdates.sh* will read a list of
territory IDs to process from the *UpdateSCBridge* project and process
all listed territories. To set up this territory ID list see the
[UpdateSCBridge Documentation]()

After the TIDList.txt file has been set up in the *UpdateSCBridge* project
do the following to perform the batch run:
<pre><code>
Terminal Session:
	cdj FlagSCUpdates to change to the project folder
	
	run the FlagAllSCUpdates shell with the following command:
	 ./FlagAllSCUpdates.sh mm dd
	 where mm dd is the month and day of the SCPA download (SCPADiff_mm-dd.db)
</code></pre>
If any errors occur during the batch run they will be recorded on the
*TEMP_PATH*/MakeErrors.txt file.
