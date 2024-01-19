README - Chromebook ArchivingBackups project documentation.<br>
11/29/22.	wmk.
###Modification History.
<pre><code>9/24/22.    wmk.   original document.
9/26/22.    wmk.   USB device documentation corrected.
10/12/22.   wmk.   TarFileDate added to Shell Files section.
11/1/22.	wmk.	*sysid environment var documented.
11/16/22.	wmk.	Sandisk.sh shell file documented.
11/22/22.	wmk.	ReloadFLTerr, ReloadFLtidList documented.
11/29/22.	wmk.	MakeGenRUSpecList, MakeGenSCSpecList, SpecRUDumpList,
			 SpecSCDumpList documented for adding /Special dbs to territory
			 dumps created by DumpTerr.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Shell Files - shell archive management utilities.
</code></pre>
<h3 id="1.0">Project Description.</h3>
This ArchivingBackups project is specific to the Chromebook/chromeos environment.
This os environment "containerizes" Linux which makes removable devices (e.g. USB
flash drives) visible as */mnt/chromeos/removable/< flashdrive-name >* to the *penguin* 
Terminal. Because of this limitation many of the archiving activities which involve
a flash drive still prompt the user to use the *Files* application first to copy
any required files to the *Linux files* folder before proceeding. The *U_DISK*
environment variable points to the USB removable device base path.<br>
Additionally, the Territories code and data segments are maintained on separate
root paths. This is because the code segment shells have been heavily modified
for supporting the *chromeos* limitations. A new environment variable *codebase*
has been introduced for referencing code segment shells and files. The *pathbase*
environment variable now only references the data segment files.<br>
To differentiate different systems' archives of the code segment, a new 
environment variable has been introduced to all archiving operations involving
code segment folders. The environment variable *sysid* identifies the host system
performing the archiving. *HP* is used for the HP Paviiion development/production
system; *CB* is used for the Chromebook system. The code segment folders are
maintained on two separate GitHub repository branches. The branch *master* has
the code segment files for the HP Pavilion system. The branch *Chromebook* has
the code segment files for the Chromebook system. The data segment is not managed
by GitHub, and is common to both.<br>
The code segment and data segment both have *Projects-Geany*, *Procs-Dev*, and *include*
folders at the base level. The data segment also has *RawData* and *TerrData* folders
at the base level. Because of the limiations of computer-resident file space on the
Chromebook, only the data for territories actively being worked on should be present
in the "Linux files" system. This requires specialized dumping and loading shells
for moving territory files on/off the Chromebook. These specialized dumping and loading
shells are documented here. There is no "incremental" dump support on the Chromebook. 
All dumps and loads perform "level-0" dumps with no incremental tracking. Reloads
may specify a <filespec> pattern for reloading, or use '!' for a full reload.

There are no shell files in the *Territories/FL/SARA/86777/Projects-Geany/ArchivingBackups*
project folder. This is because **ALL** dumping and loading operations are done from
the *TerritoriesCB* folder path.
<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Shell Files.</h3>
Shell files support all of the dumping and loading operations. These shells have
identical versions, one with the *.sh* suffix, one with no suffix." This is to facilitate
easy command line invocation of the shells. The operations supported are dump and
reload. There is no "FlashBacks" support since all file transfers to the USB flash
drives are containerized through the *Files* application.

Following are the shell files and their descriptions:
<pre><code>
Archiving.sh - *source* function definitions for archiving operations.
CBArchiving.sh - *source* function definitions for Chromebook Archiving operations.
DumpBasic.sh - dump *Basic* code segment to local archive.
DumpGeany.sh - dump *Projects-Geany* code segment to loacal archive.
DumpProcs.sh - dump *Procs-Dev* code segment to local archive.
DumpTerr.sh - dump all data segment files for territory xxx.
FindFileInTars.sh - search .tar files for occurrence of file.
GenSpecDBList.sh - generate dblist< terrid >.txt of Special dbs referenced by < terrid >.
GetTerrRUSpecList.sh - generate SpecRUDumpList.txt for use by DumpTerr.
GetTerrSCSpecList.sh - generate SpecSCDumpList.txt for use by DumpTerr.
ReloadBasic.sh - reload file(s) or all *Basic* code segment files.
ReloadGeany.sh - reload project or all *Projects-Geany* CB projects.
ReloadProcs.sh - reload file(s) or all *Procs-Dev* shell files.
ReloadRURaw.sh - reload RefUSA-Downloads/Terrxxx files.
ReloadSCRaw.sh - reload SCPA-Downloads/Terrxxx files.
ReloadSpecRU.db - reload RefUSA-Downloads/Special < spec-db >|< dblist< terrid > > database.
ReloadSpecSC.db -reload SCPA-Downloads/Special < spec-db >
ReloadTerrData.sh - reload TerrData/Terrxxx files.
ReloadFLTerr.sh - reload RefUSA-Downloads, SCPA-Downloads, TerrData/Terrxxx files.
ReloadFLtidList.sh - perform ReloadFLTerr.sh for list of territory IDs.
ReloadTerr.sh - reload file(s) or all data segment files for territory xxx;
 this operation reloads from *RefUSA-RawData*, *SCPA-RawData* and *TerrData*
 folders.
Sandisk.sh - *source* function definitions for SANDISK archiving operations.
TarFileDate.sh - display modified date of archived file.
UpdateShells.sh - ensure that all mirror copies of shells are up-to-date
 with the shells having the same name with the *.sh *file extension.
</code></pre>
(see UpdateSCBridge [README](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB//Projects-Geany/UpdateSCBridge/README.html) for details on ReloadFLtidList territory ID list.)
**Support Files for Shells.**
<pre><code>
MakeGenRUSpecList - makefile for creating SpecRUDumpList.txt uses special db list
 from TerrIDData.db extracted by GetTerrSCSpecList.sql; SpecSCDumpList.txt is
 then used by DumpTerr.sh to append any SCPA-Downloads/Special/<special-db>.dbs
 to the CBTerrxxx.0.tar
MakeGenSCSpecList - makefile for creating SpecSCDumpList.txt; uses special db list
 from TerrIDData.db extracted by GetTerrSCSpecList.sql; SpecSCDumpList.txt is
 then used by DumpTerr.sh to append any SCPA-Downloads/Special/<special-db>.dbs
 to the CBTerrxxx.0.tar
SpecSCdblist.txt - list of special territory dbs for ReloadSpecSC; typically a copy
 of ./SCData/dblistxxx.txt for Special (SC) territory xxx. (e.g. ReloadSpecSC.sh dblist)

SpecRUdblist.txt - list of special territory dbs for ReloadSpecRU; ;typically a copy
 of ./RUData/dblistxxx.txt for Special (RU) territory xxx. (e.g. ReloadSpecRU.sh dblist)
 
/SCData/dblistxxx.txt - special database lists for all SC Special territories (xxx)

/RUData/dblistxxx.txt - special database lists for all RU SpecialTerritories (xxx)
</code></pre>
<br><a href="#IX">Index</a>
<h3 id="3.0">3.0 Single Territory Archiving.</h3>
Because of resident hdd disk space limitations on the Chromebook provision has been
made to dump and load individual territories using their own .tar archive. The origin
system had enough resident hdd space to support all of the territories' data being
continually resident. The ArchivingBackups for the origin system are full backups
of each major Territories segment (i.e. FLSARA86777RawDataSC.n.tar is the set of
all RawData/SCPA/SCPA-Downloads incremental dumps, FLSARA86777RawDataRU.n.tar is
the set of all RawData/RefuSA/RefuSA-Downloads incremental dumps; both including
all of the /Special/<special-db>.dbs)

Reloading the data for any individual territory from the full backups can be
accomplished, but is a bit rigorous. To provide for creating a "contained" backup
of an individual territory two new shells were added to ArchivingBackups.
<pre><code>    DumpTerr - dump all data for a single territory
   ReloadTerr - reload individual files or all data for a single territory
</code><pre>
Full documentation of single territory archiving is found in the [README-Territories]() document.
<br><a href="#IX">Index</a>
