README.md - ImportSCPA project documentation.<br>
6/30/22.	wmk.
<h2>Modification History.</h2>
<pre><code>4/27/22.    wmk.   Original document.
5/1/22.     wmk.   UpdateCongTerr replaced with ImportSCPA.
5/26/22.    wmk.   CreateNewSCPA.sh step added; internal hyperlinks.
6/30/22.    wmk.   correct DoSed parameters documentation.
</pre></code>
<h2>Document Sections.</h2>
<pre><code>Project Description - overall project description.
Setup - step-by-step build instructions.
<a href="#3.0">link</a> 3.0 Building SCPA_mm-dd.db.
</code></pre>
<h2>Project Description.</h2>
When fresh data is downloaded from the county it is important that the databases
be updated in a specific sequence. This will ensure that downstream dependencies
are met. This sequence is as follows:<br><br>
[ImportSCPA] This Project:&nbsp;&nbsp;&nbsp;&nbsp;SCPA\_mm-dd.db - the SCPA county-wide download database<br>
[ExtractDiff](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ExtractDiff/README.html)&nbsp;&nbsp;&nbsp;&nbsp;SCPADiff\_mm-dd.db - records in the county-wide download that are newer<br>
&nbsp;&nbsp;&nbsp;&nbsp;than the previous download<br>
[DiffsToMaster](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/DiffsToMaster/README.html)&nbsp;&nbsp;&nbsp;&nbsp;Terr86777.db - the master territory county database records<br>
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html)&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Special/< special-db >.db,s - all "special" county<br>
&nbsp;&nbsp;&nbsp;&nbsp;dowload databases used in publisher territory generation<br>
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html)&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Terrxxx/Specxxx\_SC.db,s - all "special" territories'<br>
&nbsp;&nbsp;&nbsp;&nbsp;publisher territory special records databases<br>
[UpdateSCBridge](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateSCBridge/README.html)&nbsp;&nbsp;&nbsp;&nbsp;/SCPA-Downloads/Terrxxx/Terrxxx\_SC.db,s - all publisher territories'<br>
&nbsp;&nbsp;&nbsp;&nbsp;databases
<h2>Setup.</h2>
<h2 id="3.0">3.0 Building SCPA_mm-dd.db.	</h2>

To create a new SCPA\_mm-dd.db from a new SCPA download, perform the following steps:
<pre><code>
	download the current SCPA data from the SCPA website; the download
	 file the site exports to is 'SCPA Public.xlsx'
	
   	(if on chromeos:)
	use ImportSCPA/MovSCDwnld.sh to copy the spreadsheet download file from the
	 MyFiles/Downloads folder to the SCPA-Downloads/Downloads folder

	(if on HP/ubuntu:)
	use ImportSCPA/MovSCDwnld.sh to copy the spreadsheet download file from the
	 *folderbase*/Downloads folder to SCPA/SCPA-Downloads/SCPA-Public_mm-dd.xlsx
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

ImportSCPA Project:

	check the query code in CreateNewSCPA.psq; this will be transformed to CreateNewSCPA.sql
	 by DoSed.sh with the month and day of the download substituted in the appropriate
	 query code.

	edit the MakeImportSCPA.tmp makefile and set the *SCPAonly* var
	 set = 1 if have previous Terr86777.db that is to be preserved
	     = 0 if Terr86777.db is to be completely rebuilt

	edit the *sed* command line in the Build menu with the new download month and day 

	run *sed* from the Build menu to perform all of the modifications on dependent files
	 within the ImportSCPA project.

Terminal session:
	cd to the ImportSCPA project folder
	 cdj ImportSCPA

	set the TODAY environment variable using the *export* command to allow shell files 
	 with embedded SQL to set the download date to TODAY in each record

	execute the following command to build the CreateNewSCPA.sh:
	  make -f MakeCreateNewSCPA
	  
	execute the following command to build the SCPA_mm-dd.db:
	  ./CreateNewSCPA.sh
	note: if *SCPAonly* = 0 in the makefile, the Terr86777.db database is also completely
	 rebuilt. There is no point in running BuildSCPADiff, since all of the Terr86777.db
	 records have been effectively updated to the *TODAY* date.	  
</code></pre>
The new SCPA_mm-dd.db will be saved into the \*pathbase\*/RawData/SCPA/SCPA-Downloads folder.
To complete the database setup for use with the Territory system, a second file should be
built at this time. The SCPADiff_mm-dd.db is the "differences" database that is used in
updating all territories' SCBridge tables. To build the SCPADiff_mm-dd.db, use the
*ExtractDiff* project. See the *ExtractDiff* project [README](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/ExtractDiff/README.html) file for details.

