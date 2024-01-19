README.md - FixShells project documentation.<br>
5/30/22.	wmk.
##Modification History.
<pre><code>
5/15/22.    wmk.   original document.
5/30/22.    wmk.   links added; Setup section expanded.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code>
<a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Setup - Usage instructions.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
FixShells is a "reliability" mod project that goes through a folder's
*.sh* files and tidies up *path* variable definitions. The single build
uses *sed*, *awk* and *cat* to modify the .sh file in the specified
folder (typically a Geany project folder). The paths containing
"FL/SARA/86777" are changed to contain "TX/HDLG/99999".

The project will also be used when creating new congregation Territory
systems. There are over 1,000 *.sh* files within a Territory system, many
of which have path dependencies on the *folderbase*, *basepath* and
*congterr* environment variables. Whenever these system-wide environment
variables are changed, the downstream makefiles and shell files will be
affected. FixShells, especially the FixAllShells shell, facilitates rapidly
editing all affected *.sh* files.

The *.sh* file header is modified with the automated revision date. The
shell body is modified to ensure that the vars *folderbase*, *pathbase*,
and *AWK* are defined properly for the shell.

**sed operations**<br>
The *sedfixShell1.txt* file has the *sed* directives that FixShell.sh
uses when fixing shells. Generally this file contains "basic" fixes
that are more readily accomplished by *sed* rather than *awk*. More
extensive fixes can be done by supplying *awk* directives. See the 
<a href="#3.0">Tailoring the Fixes</a> section below.

**awk operations**<br>
The *awkfixShell1.txt* file has the *awk* directives that FixShell.sh
uses when fixing shells. Generally this file contains "advanced" fixes
that are more readily accomplishted by *awk* rather than *sed*. See the
<a href="#3.0">Tailoring the Fixes</a> section below.

**cat operations**<br>
After the *Make* file has been split and modified by *sed* and *awk*, the
pieces are rejoined using the *cat* utility. The original file is preserved
as *makefile*.back with the modified file assuming the name *makefile*.<br>
<a href="#IX">Index</a>
<h3 id="2.0">2.0 Setup.</h3>
There are no *make* files for the FixShells project. Two shell files handle
all of the operations. *FixShell* fixes one shell (.sh) file. *FixAllShells*
fixes all of the shell files on a given path. When specifying a single shell
file the ".sh" file suffix is not specified, and assumed. The "fix all" shell
looks for all files with ".sh" suffix on the specified path.

FixShell - Fix one shell file.
>Usage.   bash FixShell.sh  < shpath > < shfile ><br>
>>< shpath > = full path to shell file<br>
>>< shfile > = filename to fix (sans .sh suffix)<br>

FixAllShells - Fix all shells on path.
>Usage.   bash FixAllShells.sh < shpath ><br>
>>< shpath > = full path to shell files<br>
<a href="#IX">Index</a>
<h3 id="3.0">3.0 Tailoring the Fixes.</h3>
FixShells may be tailored to any specific need in fixing shell files. The
*sedfixShell?.txt* file(s) contain(s) the *sed* utility directives for fixing
the shells. The *awkfixShell?.txt* file(s) contain(s) the *awk* utility
directives for fixing the shells. 

Either file may contain all or no directives for the shell repair, but
it is advised that at least one of these make provision for including a
line with the "fix date" (e.g. 5/30/22). This will allow any subsequent
runs of the FixShells to identify files that have already been "fixed"
and not run the same fixes twice. At present, the "fix date" is hardwired
into the *FixShell.sh* and *sedfixShell1.txt* files. If one is changed,
both should be changed.

**sed Fixes.**
(maybe provide a link here to custom fixes that can provide info on
local fixes...)
The header of the *.sh* file has a new line inserted from the file
*sedfixShell1.txt* file. This contains the automated modification date. To
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

**awk Fixes.**
The *awk* (mawk) utility is used to break the *.sh* file into segments, insert
lines from files, then rejoining the segments to produce the final *.sh* file.

for rebuilding into the final makefile. The first segment contains all of 
the lines up to the beginning of the "if" conditional defining *folderbase*.
(It assumes that a *folderbase* definition is present). The second segment
contains all of the lines from the .PHONY directive to the end of the file.
(It depends upon ".PHONY" being present in the *Make* file). If the .PHONY
directive is not in the file when FixMake begins, it inserts it so that the
utility may continue.
<br>
<a href="#IX">Index</a>

