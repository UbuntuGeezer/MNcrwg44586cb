README.md - FixMakes project documentation.<br>
5/4/22.	wmk.
##Modification History.
<pre><code>
5/4/22.    wmk.   original document.
</code></pre>
##Document Sections.
<pre><code>
Project Description - overall project description.
Setup - step-by-step build instructions.
</code></pre>
##Project Description.
FixMakes is a "reliability" mod project that goes through a folder's
*Make* files and tidies up *path* variable definitions. The single build
uses *sed*, *awk* and *cat* to modify the *Make* file in the specified
folder (typically a Geany project folder). 

The project will also be used when creating new congregation Territory
systems. There are over 1,000 makefiles within a Territory system, many
of which have path dependencies on the *folderbase*, *basepath* and
*congterr* environment variables. Whenever these system-wide environment
variables are changed, the downstream makefiles and shell files will be
affected. FixMakes, especially the FixAllMakes shell, facilitates rapidly
editing all affected makefiles.

The *Make* file header is modified with the automated revision date. The
makefile body is modified to ensure that the vars *folderbase*, *pathbase*,
and *AWK* are defined for the makefile. All of the vars of the pattern
"..path" are modified to ensure that they have no trailing '/'. All path
references "\$(folderbase)/Territories" are changed to reference *pathbase*
in place of "\$(folderbase)/Territories". All path references (..path) are
guaranteed to be followed by '/'.

**sed operations**<br>
The header of the *Make* file has a new line inserted from the file
*sedfixMake1.txt* file. This contains the automated modification date. To
avoid modifying the same file twice (and ruining the previous mods) the
file header is checked for the automated modification date being present.

All makefile path var definitions  of the form "..path =" that are ended
with '/' are modified to drop the trailing '/'. Then all path vars that
are referenced with "..path)" have a '/' appended to the reference.
This edits the makefile definitions and references of ..path vars to
be consistent.

In addition, at line 2 of the makefile a "date modified" line is added
for future reference.

After the first *awk* operation, *sed* is used to remove the "ifndef"
and "ifeq" conditionals in the last 2 lines of the extraction file.

**awk operations**<br>
The *awk* (mawk) utility is used to break the *Make* file into two segments
for rebuilding into the final makefile. The first segment contains all of 
the lines up to the beginning of the "if" conditional defining *folderbase*.
(It assumes that a *folderbase* definition is present). The second segment
contains all of the lines from the .PHONY directive to the end of the file.
(It depends upon ".PHONY" being present in the *Make* file). If the .PHONY
directive is not in the file when FixMake begins, it inserts it so that the
utility may continue.

**cat operations**<br>
After the *Make* file has been split and modified by *sed* and *awk*, the
pieces are rejoined using the *cat* utility. The original file is preserved
as *makefile*.back with the modified file assuming the name *makefile*.

##Setup.
