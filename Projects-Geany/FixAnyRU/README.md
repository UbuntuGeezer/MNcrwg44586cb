README - Documentation for FixAnyRU project.<br>
10/2/21.	wmk.
###Modification History.
<pre><code>5/31/21.	wmk.	original document.
9/18/21.	wmk.	documentation rearranged; Move Downloads -tidlist
			 build menu item added.
10/2/22.	wmk.	.md formatting; hyperlinks added.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code>
1.0 Project Description - overall project description.
2.0 Dependencies -
3.0 Build Menu/Result
4.0 Batched runs of FixAnyRU.
5.0 Auxiliary Utilities.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
FixAnyRU takes the SQL postprocess query for any given territory and
builds it into a shell that can be executed by the make for UpdateRUDwnld.
The execution of the FixyyyRU.sh shell cleans up records which have missing
OwningParcel fields, to complete as many RU download records as
possible in the RUBridge table for the territory.

Polygon data is downloaded from RefUSA into a separate .csv file for each
territory. The .csv filename is Mapyyy_RU.csv for any territory yyy.
The TerryyyRU.db is considered "out-of-date" if the 
RefUSA-Downloads/Terryyy/Mapyyy_RU.csv file is newer than Terryyy_RU.db.

An "out-of-date" Terryyy_RU.db will be rebuilt in its entirety from the
the new download data in Mapyyy_RU.csv.


<h3 id="2.0">2.0 Dependencies.</h3>
<pre><code>
	hdrFixXXXRU.sh in folder ~/Procs-Dev
	FixyyyRU.sql in folder ~/RefUSA-Downloads/Terryyy
</code></pre>
</h3>3.0 Build Menu/Results.</h3>
<pre><code>
	FixyyyRU.sh in folder ~/RefUSA-Downloads/Terryyy
</code></pre>

<h3 id="4.0">4.0 Batched runs of FixAnyRU.</h3>
The territory system has now matured to the point where multiple territories
may be downloaded at, or near, the same time. For each RefUSA polygon download,
its corresponding territory RU database needs to be brought up-to-date with
the current download information. The UpdateRUDwnld project uses the "make"
utility to accomplish this. Part of that "make" process is to run FixyyyRU.sh
after importing the records to handle exceptions in the download data.

Given the above, to facilitate the generation of multiple FixyyyRU.sh files
with a single run, the FixAllRU.sh shell has been provided. While it resides
in the Procs-Dev folder, it is included with the FixAnyRU project to keep
it bundled with the FixAnyRU make facility.

FixAllRU.sh depends upon the file TIDList.txt resident in the FixAnyRU project
folder. TIDList.txt provides FixAllRU.sh with a list of territory IDs for
which to run the MakeFixAnyRU makefile. The shell loops reading the TIDList.txt
file, invoking DoSed and make for each specified territory. All that is necessary
is to execute the FixAllRU.sh shell (no parameters), typically from the Procs-Dev
folder.

<h3 id="5.0">5.0 Auxiliary Utilities.</h3>
These are utilities which are not invoked directly by FixAnyRU make, but
which use files or parts of the make process.

DoRUSedPaths.sh - utility that changes all hardwired paths in FixyyyRU.sql
 files to paths with prefix (%)folderbase/Territories...
This utility provides support that generalizes all the SQL to be able to
use files and databases stored on different base paths when SQL is run on
different hosts. It depends upon any script processes that use any of the
.sql files to preprocess the (%)folderbase prefixes either into ($)folderbase
for substitution by bash or directly into the appropriate Territories
base path (e.g. UpdateRUDwnld).

