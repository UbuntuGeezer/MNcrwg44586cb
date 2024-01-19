README - CBtoHPgeany project documentation.<br>
	4/1/22.	wmk.
##Document Sections.
<pre><code>Project Description - overall description of project.
Supporting Files - shells and other files supporting project.
Setup - step-by-step build instructions.
</code></pre>
##Project Desciption.
CBtoHPgeany facilitates migrating Geany projects from a
ChromeBook host system to an HP Pavilion system. The ChromeBook system
is assumed to have created the project in its Linux framework, so that
all of the pathnames use '/' as the folder separator.

*CBtoHPGeany* project files are organized under two Geany project names.
*CBtoHPGeany.geany* is the project name for Geany running on a Linux/Ubuntu
os-based system.
*CBtoHPGeanyWHP.geany* is the project name for Geany running on a Windows
os-based system.
Both projects map to the same set of files in the *Projects-Geany/CBtoHPgeany*
folder.

Edits are performed on the .geany files from a ChromeBook host, changing the
folder references to match the HP host. The HP target host may either be
running Linux/Ubuntu or Windows.
The designator for the Linux/Ubuntu is *HP*, for Windows is *WHP*.

Editing transforms the Geany project files to contain correct
folder references within the HP file system. The name of the project file
will have the characters *HP* appended for conversions to the Linux/Ubuntu
operating environment or the characters *WHP* appended for conversions to
the Windows operating environment on the HP system.

**Caution** Migrating project files to the Windows operating environment
on will facilitate using a Windows-based Geany to edit and
manage project files. However, the Windows-based Geany will not be able to
perform *make* operations unless a set of GNU-compatible utilities has
been installed on Windows. One such package is MinGW which installs several
utilities, including *mingw-make.exe*. It is advisable to set an environment
variable like *make* with 'export MAKE=mingw-make' so that $MAKE may be
used in shell files to invoke the *make* equivalent.

**History**
The ChromeBook Linux environment was the primary development system at
the time that this project was initiated. A system crash on the ChromeBook
necessitated the move of all the active projects back to the HP system.
To facilitate that move, the *MigrateGeany* project was expanded. This
project was originally designed for moves from "Kay's Linux System" to
the "262 Linux System".

The project was then modified to facilitate a mass move from the ChromeBook
system to the HP Pavilion system. To avoid confusion with prior work the
*MigrateGeany* project was cloned into this project *CBtoHPgeany*. As the
project name implies, this project is specifically one-direction, migrating from
ChromeBook Linux to the HP Linux/Ubuntu.

On any given host system, the folder *Projects-Geany* contains projects
maintained by Geany. Geany defines a file <proj-name>.geany for each of
the projects it is managing. The Geany "Preferences" settings determine
the base Project Files path which Geany will use for storing *.geany*
definition files for the projects. The Build commands and folder names
for any given project are saved in its .geany file. The list of active
files which are opened automatically by Geany are also saved
in the *.geany* file.

Beginning in late March 2022, the names of .geany files for projects that
must be able to migrate across more than one host system follow this
naming convention: *projectname*\[*host*].geany where *projectname* is 
the name of the project and \[*host*] is an optional host suffix that will
indicate which host the .geany applies to. This allows the same set
of subfolders to contain the project files by using different prefix
folders in the applicable *.geany* files.

Example: MigrateGeany.geany  vs.  MigrateGeanyHP.geany in the
*Territories/Projects-Geany* folder

Whenever a Projects-Geany subsystem is migrated from one host system to
another (e.g. by using tar create/extract), the target system receives
the Geany projects "as-is" from the source system. As a result, the Build
commands and active files list entries in may not point to the correct
folders in the target system.

Each potential target system will have a sedatives< host >.txt file defined
in CBtoHPgeany to take .geany files from the ChromeBooks system and edit
the folder paths to match the target system. These shell files are itemized
and described in the section "Supporting Files" below.
##Supporting Files.
The current supporting shell files for MigrateGeany are:
<pre><code>
	Migrate262ToKays.sh - Migrate .geany file from 262 system to Kay's system.
	MigrateKaysTo262.sh - Migrate .geany file from Kay's system to 262 system.
	MigrateGeany.sh - Migrate a single .geany file from Chromebooks to any of 
	  the following systems: *HP*, *WHP*.
	AllMigrateGeany.sh - Migrate batch list of projects from *ProjList.txt*.
	ProjList.txt - list of project names for batch AllMigrateGeany.
	DoSed.sh - preprocesing edit shell for MakeMigrateGeany.

*sed* directives files
	sedativesHP.txt - directives to migrate from ChromeBooks to HP Linux.
	sedativesWHP.txt - directives to migrate from ChromeBooks to HP Windows.
</code></pre>
##Setup.
To perform the migration from ChromeBooks do the following:
<pre><code>CBtoHPgeany Project:
	Build Menu: edit the *sed* command line parameters with the *project*
	 and *hostname* (e.g. ./DoSed  AnySQLtoSH HP)
	run *sed* from the Build menu to fix MakeCBtoHPgeany.tmp > MakeCBtoHPgeany

Terminal session:
	set pathbase with the following command:
		export pathbase=$folderbase/Territories

	use the command "cdj  MakeCBtoHPgeany" to switch to the project folder
	run "make  -f MakeDBtoHPgeany" to create the new *project**hostname*.geany
	 file
</code></pre>
The project file *project**hostname*.geany is now ready to use.
