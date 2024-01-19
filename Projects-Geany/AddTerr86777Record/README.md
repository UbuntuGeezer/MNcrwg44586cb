README - AddTerr86777Record project documentation.<br>
	6/5/22.	wmk.
###Modification History.
<pre><code>6/5/22.    wmk.   original document.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Setup - step-by-step build instructions.
</code></pre>	
<h3 id="1.0">1.0 Project Description.</h3>
The AddTErr8677lRecord project adds a new record (likely missing/omitted
from all previous SC downloads) to the Terr86777.db table Terr86777.
The user must supply the property ID of the record to add, and the SC
download month and day from which to add the record.

The Terr86777 table has as the primary key the property id (Account #), so
the new record will be added or replace an existing record if there is a
conflict with existing records. The entire record from SCPA_mm-dd.db will be added.

In addition, the new property ID will be added to the AllAccts table so
that it is seen by queries using that table.<br><a href="#IX">Index</a>
<h3 id="2.0"> 2.0 Setup.</h3>
AddTerr86777Record can either be used to add missing parcel IDs one-at-a-time or
in blocks of parcels. To add blocks of consecutive parcel IDs see the
<a href="#3.0">Batch Runs</a> section below. To add an individual parcel id perform
the following steps:
<pre><code>
	Obtain the parcel ID from the county data either by searching the map online
	or by using an SQL query to search the SCPA_mm-dd.db database. When you have
	the parcel ID, make note of the download database month and day (mm and dd
	from the .db name) that you wish to use to extract the property record from

Terminal Session.
	cdj AddTerr86777Record to change to the project folder

	run DoSed to set up the MakeAddTerr86777Record makefile
	  ./DoSed.sh < parcel-id > <mm> <dd>

	run *make* on the makefile MakeAddTerr86777Record
	  make -f MakeAddTerr86777Record

	use the *sqlite* database browser to check that the record was added to the
	Terr86777.db table Terr86777, and the table AllAccts
</code></pre><br><a href="#IX">Index</a>
<h3 id="3.0"> 3.0 Batch Runs.</h3>
The shell AddRangeTerr86777Rec.sh adds a range of property IDs into Terr86777
with a single run. To use AddRangeTerr86777Terr do the following:
<pre><code>
Terminal Session.
	cdj AddTerr86777Record to change to the project folder

	run AddRangeTerr86777.sh with the following command:
	  ./AddRangeTerr86777.sh < startID > < endID > <mm> <dd> where
		< startID > is the starting property ID
		< endID > is the ending property ID
		<mm> is the month of the SCPA_mm-dd.db to  use
		<dd> is the day of the SCPA_mm-dd.db to use
</code</pre><br>
<a href= "#IX">Index</a>
