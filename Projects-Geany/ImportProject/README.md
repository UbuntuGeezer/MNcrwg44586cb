README - Project documentation for ImportProject Geany project.<br>
9/20/22.	wmk.
###Modification History.
<pre><code>4/12/22.    wmk.   original document.
4/13/22.    wmk.   Project Description details added.
5/15/22.    wmk.   Setup section added.
9/20/22.	wmk.   .md formatting; hypelinks added; Supporing Files section added;
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall description of project.
<a href="#2.0">link</a> 2.0 Setup - step-by-step build instrctions.
<a href="#3.0">link</a> 3.0 Supporting Files - shell and other files key to project.
<a href="#4.0">link</a> 4.0 Significant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">Project Description.</h3>
ImportProject facilitates importing a Geany project from a different
system base into the current /Projects-Geany project management. It takes
a << project-name >>.geany file and copies it to the current *pathbase*/Projects-Geany
folder, creates a << project-name >> folder within the /Projects-Geany folder,
and copies all files from the source Projects-Geany folder.

*awk* cycles through the FILE_NAME list extracting the folder references
to a CopyFiles.txt list so that the project can also pick up files pointed
to outside the project. If the folder references are within the current
Territory system (<< state >>/<< county >>/<< congo >>), they will not
be moved. If they are outside the current territory system, they will be
copied to a folder named "ForeignFiles". The CopyFiles.txt list will 
contain the original folder references from the project being copied.

From there, the user can open the project and finish tidying up loose ends
like checking the Build menu item links and links to files not stored
directly in the project. The user may also have to edit paths within
*makefiles* as these are left untouched by *ImportProject*.<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Setup.</h3>
<pre><code>
DoSed.sh  < srcpath > < projname > < foldername >
	< srcpath > = source path (usually a /Projects-Geany folder)
	< projname > = project file to migrate
	< foldername > = (optional) Projects-Geany folder to import files to
</code></pre><br><a href="#IX">Index</a>
<h3 id="3.0">Supporting Files.</h3>
Besides the files documented in the *Setup* section, the following files
are key in the ImprtProject project:
<pre><code>
MakeMigrateGeany.tmp - makefile template for MigrateGeany.sh.
MigrateGeany.sh - shell to migrate .geany from previous system.
AllMigrateGeany.sh - shell to migrate list of .geany files from previous
  system.

BuildCopyList.sh - shell to build list of project files to copy from
  previous system.
  
CopyProject.sh - shell to copy all project files from list built by
  BuildCopyList.sh.

sedativesCB.txt - *sed* directives to migrate HP project .geany directives
  to Chromebook. 
</code></pre><br><a href="#IX">Index</a>
<h3 id="4.0">Significant Notes.</h3>
If the project being imported was specially named (e.g. AnySQLToSHHP) and
points to a directory without the suffix (HP), the files will all be
imported to a folder named "AnySQLtoSHHP" in this case...
<br><a href="#IX">Index</a>
