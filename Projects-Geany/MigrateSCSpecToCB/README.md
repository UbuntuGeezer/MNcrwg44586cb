README.md - MigrateSCSpecToCB project documentation.<br>
11/26/22.	wmk.
###Modification History.
<pre><code>11/25/22.   wmk.   original document.
11/26/22.   wmk.   Bug List section separated; Significant Notes added.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Bug List - known bugs fixed by this migration.
<a href="#3.0">link</a> 3.0 Sigificant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
MigrateSCSpecToCB migrates /SCPA-Downloads/Special dbs and the
/SCPA-Downloads/Terrxxx/ territories which use them to the Chromebook
system.<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Bug List.</h3>
The following "bugs" were discovered with the attempt to migrate territory
129.
<pre><code>
The MakeRegenSpecDB, MakeSpecials, MakeSetSpecTerrs, and MakeSyncTerrToSpec
makefiles all were running without the \*codebase environment var defined.
The makefile vars \*procpath, \*bashpath, \*projpath and *include* paths
were all referenced to the \*pathbase path.

The GenFixList.sh shell finds all territories within SCPA-Downloads that
have a Spec*.db database and lists them to file TerrFixList.txt within the
project. This list provides the territories needing to have the MigrateMakes
shell run on them.

The awkMakefixes.txt directives enable *mawk* to add a \*codebase definition
and repair all of the above path references within the above listed makefiles.

The MigrateMakes.sh shell uses the awkMakefixes.txt directives to repair
the MakeRegenSpecDB, MakeSetSpecTerrs, MakeSyncTerrToSpec, and MakeSpecials
makefiles for any given special SC territory.
	./MigrateMakes.sh < terrid >
where < terrid > is the territory ID in which to repair the makefiles.
- - - - -

Many of the old MakeRegenSpecDB, MakeSpecials, MakeSetSpecTerrs and
MakeSyncTerrToSpec makefiles still build their respective ".sh" files
taking the .sq file as source, moving it to a .sql file (bash directives),
then creating the ".sh" file. All makefiles should be updated to use
the AnySQLtoSH project to build the .sh file.

Proposed fix: awkRecipefixes.txt directives will replace the main
xxxx.sh : recipe with the appropriate recipe using AnySQLtoSH.<br><a href="#IX">Index</a>
<h3 id="3.0">3.0 Siginificant Notes.</h3>
**Recipe Fixes.** The recipe fixes are "generic". A special case which is not
handled is MakeSyncTerrToSpec. This makefile had a provision for supporting
"SyncTerrToSpec.psq" as a prerequisite. The *make recipe for the .psq file
only checked for its existence, but there is no "build" recipe to go from
the .psq file to the .sql file. The only modification needed is to substitute
the territory id for 'xxx' within the .psq file. For now, this is considered
superfluous. All builds simply depend upon the .sql file.<br><a href="#IX">Index</a>
