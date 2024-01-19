README.md - FixTerrShells project documentation.<br>
5/14/22.	wmk.
##Modification History.
<pre><code>5/8/22.     wmk.   original document.
5/14/22.    wmk.   Setup section expanded.
5/28/22.    wmk.   name correction from FixTerrMakes.
</code></pre>
##Document Sections.
<pre><code>Project Description - overall project description.
Setup - step-by-step build instructions.
</code></pre>
##Project Description.
FixTerrShells is a "reliability" project that goes through a list of territories
then processes each territory's folder *make* files
and batch edits them to be consistent with all "makes" for a given
Territory system. The most obvious is to ensure the makefile is using the
environment variable *pathbase* in all file referencing operations that
are in recipes and variable assignments. The single build uses *sed*, *awk* and
*cat* to modify the *make* files in a specific folder (typically a territory
download or Geany project folder.

The project will also be used when creating new congregation Territory
systems. There are hundreds *make* files within a Territory system, many
of which have path dependencies on the *folderbase*, *basepath* and
*congterr* environment variables. Whenever these system-wide environment
variables are changed, the downstream *make* files will be
affected. FixTerrShells, especially the FixAllTerrMakes shell, facilitates rapidly
editing all affected *make* files..
##Setup.
FixTerrShells has  "stand-alone" shells that fix *make* files.

FixTerrMake.sh fixes a single territory's makefiles. FixAllTerrMakes.sh fixes all
makefiles for territories in the TIDList.txt file. The TIDList.txt file resides
on the *SpecialRUDB* project path. The most common makefile needing modification
across territories is *MakeSpecials*. Each territory that uses special databases
from the RefUSA-Downloads/Special folder has its own *MakeSpecials* makefile. Within
that makefile is a territory-specific list of /Special databases that are linked
to the territory.

FixTerrMake shell has 2 parameters < path > < file >. < path > is the
full path to the file; < file > is the base filename (e.g. MakeSpecials).
