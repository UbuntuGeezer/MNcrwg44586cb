README.md - FixTerrPSQs project documentation.<br>
5/8/22.	wmk.
##Modification History.
<pre><code>
</code></pre>
##Document Sections.
<pre><code>
</code></pre>
##Project Description.
FixTerrPSQs is a "reliability" project that goes through a list of territories
then processeS each territory's folder .psq files
and batch edits them to be consistent with all SQL queries for a given
Territory system. The most obvious is to ensure the SQL is using the
environment variable *pathbase* in all file referencing operations like
.open,.import.,.output and ATTACH. The single build uses *sed*, *awk* and
*cat* to modify the .psq files in a specific folder (typically a territory
download or Geany project folder.

The project will also be used when creating new congregation Territory
systems. There are over 1,000 .psq query files within a Territory system, many
of which have path dependencies on the *folderbase*, *basepath* and
*congterr* environment variables. Whenever these system-wide environment
variables are changed, the downstream SQL queries and shell files will be
affected. FixTerrPSQs, especially the FixAllPSQs shell, facilitates rapidly
editing all affected SQL queries.
##Setup.
FixTerrPSQs consists of "stand-alone" shells that fix .psq and .psq files.
FixTerrPSQ.sh fixes a single territory folder. FixAllPSQs.sh fixes all
territory folders in the TIDList.txt list files on the < path >.
The shells use 3 parameters < path > < file > [< extension >]. < path > is the
full path to the file; < file > is the base filename (e.g. Fix101RU);
[< extension >] where present, is the file downstream folder type ru | sc.
