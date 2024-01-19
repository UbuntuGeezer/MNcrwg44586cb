README - AddSCBridgeRecord project documentation.<br>
	6/18/22.	wmk.

##Modification History.
<pre><code>9/22/21.    wmk.    original document.
2/3/22.     wmk.    Document Sections, and Setup sections added.
2/7/22.     wmk.    add *Make* to build sequence.
6/18/22.	wmk.	NVenAll reference corrected to Terr86777.
</code></pre>

##Document Sections.
<pre><code>Project Description - overall project description.
Setup - step-by-step build instructions.
</code></pre>
##Project Description.
The AddSCBridgeRecord project adds a new record (likely missing/omitted
from all previous SC downloads) to the Terrxxx\_SC.db table Terrxxx\_SCBridge.
The user must supply the property ID of the record to add, and the
territory ID of the territory in which to add the record.

The Terr86777 table has as the primary key the property id (Account #), so
the new record will only be added if a record exists in Terr86777 for the
specified property ID. The record with the matching property ID will be
extracted and the appropriate fields added to the Terrxxx\_SCBridge table
for territory xxx.

If this was a missing property, likely the AddTerr86777Record project will
have been used to add the missing property into Terr86777 prior to doing
the build for this project.

##Setup.
Perform the following steps to add a new record to Terrxxx_SCBridge
for territory xxx:
<pre><code>Documents:
   focus on README or README.md document to enable *Run It* in Build menu
   
Build Menu:
   edit *sed* command with property ID and territory
   
   run *sed* from the Build menu

   run *Make* from the Build menu (builds the .sh)
   
   run *Run It* from the Build menu
</code></pre>
**Note.** *Run It* is used instead of putting the command in the *Execute*
Build menu command, since there is a bug in chromeos *make* that displays
html for the Execute instead of actually executing it..

Also note that this will add a duplicate record if the property ID record
already exists in Terrxxx_SCBridge.
