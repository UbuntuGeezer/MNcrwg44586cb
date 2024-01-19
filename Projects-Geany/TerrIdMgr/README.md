README - Documentation for TerrIdMgr project.<br>
5/28/23.	wmk.
###Modification History.
<pre><code>5/28/23.    wmk.   original document.
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Dependencies - project dependencies.
<a href="#3.0">link</a> 3.0 Adding New Territories - adding new territories.
<a href="#4.0">link</a> 4.0 Deleting and Purging Territories - removing territories.
<a href="#5.0">link</a> 5.0 Changing/Renumbering Territories - renumbering existing territories.
<a href="#n.0">link</a> n.0 Significant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
TerrIdMgr is the manager for handling territory IDs within the data segment. Its
function is to provide a single manager that facilitates adding, deleting, or 
changing territory IDs within the system.

The process of adding or deleting territories is fairly straightforward. The
process of changing a territory ID from one ID to another is complex. The TerrIdMgr
provides an automatic mechanism so that whenever a territory ID is created
or modified the changes propagate into all databases and tables referencing
that territory ID.

The TerrIdMgr uses tools developed previously that are based on the \*make utility
and build recipes for the various databases.

The TerrIdMgr enhances that process by taking advantage of FOREIGN
keys linking tables together through their territory ID. Unfortunately, the
table definitions in the first implementation of the Territories system use
different names for the territory ID field from database to database. To the
extent possible, the original database schemas have been retained.

The TerrIdMgr project modified the major databsase schemas to include
FOREIGN keys for information propagation. This provides a new level of consistency
across the databases so that related fields in separate tables are automatically
updated when the parent key field changes. For many tables the territory ID field
is a database-wide key for all information related to a given territory.
<pre><code>
	TerrIDData.db	Territory table (parent)
					DoNotCalls
					SegDefs
					SpecialRU
					SpecialSC
					SubTerrs
					Propagation new
					TerrLog new
	AuxSCPA.db	Propagation (parent) new
				AddrXcpt table
				SitusDups table
				TerrLog new
</code></pre>
<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Dependencies.</h3>
Working backwards through the publisher territory folders the following are the
overall dependencies:
<pre>code>
The "published" publisher territory has these files; all xxx's need to migrate
to a new territory, or be removed if territory is deleted.

TerrData/Terrxxx and Terrxxx/-WorkingFiles
<pre><code>
	Terrxxx_PubTerr.ods, .xlsx
	Terrxxx_SuperTerr.ods, .xlsx
	Terrxxx_PubTerr.pdf
	PUB_NOTES_xxx.html
	/WorkingFiles
		QTerrxxx.csv
		QTerrxxx.ods
		QTerrxxx.db
		TerrxxxHdr.csv
		TerrxxxHdr.ods
</code></pre>
The BridgesToTerr project takes data from Terrxxx_RU.db and Terrxxx_SC.db
and integrates it into the /DB-Dev/PolyTerri and MultiMail.dbs. If territory
number xxx is changed to a different number, it obsoletes the data in  PolyTerri
and MultiMail for that territory. The "safest" way to do this is to set the
DelPending field to '1' for all entries in all tables for that territory
(PropOwners, TerrProps, SplitOwners, SplitProps).
	/DB-Dev
		PolyTerri.db	PropOwners, TerrProps
		MultiMail.db	SplitOwners, SplitProps

	RefUSA-Downloads/Terrxxx
		Terrxxx_RU.db
	
	SCPA-Downloads/Terrxxx
		Terrxxx_SC.db

<br><a href="#IX">Index</a>
<h3 id="3.0">3.0 Adding New Territories.</h3>
Adding new territories may only be done for territories that either never
existed or else have been purged from the territory system. This prevents
overwriting any deleted or archived territories that may have been preserved
for recovery.

A territory that has been purged leaves behind empty folders that fulfill
a territory's needs within the data segment. A territory that never existed
is added by having its folders created anew within the data segment. If neither
of these criteria are met when attempting to add a new territory, the add
process warns the user and halts.

Assuming the above criteria have been met, the add process will continue
by:
<pre><code>
	prompting the user to add the new territory definition into the
	 /DB-Dev/TerrIDData.Territory table
	creating the RefUSA-Downloads/Terrxxx and Terrxxx/Previous folders
	 if they do not exist
	creating the SCPA-Downloads/Terrxxx and Terrxxx/Previous folders if
	 they do not exist
	creating the TerrData/Terrxxx and Terrxxx/Working-Files folders if
	 they do not exist
	creating an empty Mapxxx_RU.csv in the RefUSA/Downloads-Terrxxx folder
	creating an empty PUB_NOTES_xxx.md file in the RefUSA-Downloads/Terrxxx folder
	creating an empty Mapxxx_SC.csv in the SCPA/Downloads/Terrxxx folder
	prompting the user to run the FinishAdd.sh shell to:
		add the publisher territory header files into 
		 TerrData/Terrxxx/Working-Files
		run the \*make RUNewTerritory project to generate an initial
		 Terrxxx_RU.db
		run the \*make SCNewTerritory project to genearte an initial
		 Terrxxx_SC.db 
</code></pre>
At this point a "naked" new territory is ready for population with data. The
database administrator will then need to go through the process of defining the
segments of the SCPA data and using the SegDefsMgr to populate the Terrxxx_SC.db.
Then the database administrator will download the RefUSA data, and using the
UpdateRUDwnld project, populate the Terrxxx_RU.db.

If errors are discovered in this initial pass at populating the above databases,
the administrator will then code "fixes", create/use "special" databases, or
whatever other steps are necessary to produce "clean" publisher territories.
For details on these steps refer to
the [Managing Territory Data](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/DocumentationCB/ManagingTerritoryData.html) documentation.

<br><a href="#IX">Index</a>
<h3 id="4.0">4.0 Deleting and Purging Territories.</h3>
Deleting a territory involves removing it from the processes that generate
publisher territories. That implies updating all databases that reference the
territory, all data segment folders containing the territory, and all \*make
files that reference the territory. Purging a territory removes all references
to the territory from the Territory system.

The deletion process deactivates the territory, and archives the territory.
The territory ID '000' is reserved for assignment to deleted territories.
When a territory is deleted, any records pertaining to that territory that
contain the territory ID will be changed to '000'. In addition, any records
that are being retained for tracking will have their 'DelPending' field set
to the original territory number. This will prevent the records from being
picked up in any of the publisher territory generation processes, while
providing a "traceback" to the original territory. This affects the following
tables:
<pre><code>
	PolyTerri.db	TerrProps
					PropOwners
	MultiMail.db	SplitProps
					SplitOwners
	TerrIDData.db	DoNotCalls
</code></pre>
**DoNotCalls**<br>
Any DoNotCalls belonging to a territory being deleted must be preserved so
that they are not lost to the system. As with other tables.
 the 'DelPending'
flag will be set to the original territory ID for tracking purposes.

This gets really messy, since the Do Not Calls will also have to be reassigned
to a new territory in the Territory Servant system. TerrIdMgr provides two
shells to allow archiving and recovering of DoNotCalls belonging to a deleted
territory.

The archiving shell takes all DNCs belonging to the specified territory
and copies them to an archiving table. It then flags all of the DoNotCalls that
were part of the specified territory with 'DelPending', leaving the original
territory ID in the records. This effectively de-activates these DoNotCalls.

The recover shell uses the specified territory as the target territory to assign
recovered DoNotCalls to. The target territory Terrxxx_SC.db provides the property
IDs and units to search for in the archiving table to recover any DoNotCalls that
were archived (regardless of which territory they were archived from) that are
presently within Terrxxx boundaries.
<pre><code>
	ArchiveDNCs.sh < deleted-terrid > < initials >
	RecoverDNCs.sh < new-terrid > < initials >
</code></pre>

For a more complete discussion of how DoNotCalls are handled, see the
[DNCMgr](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/DNCMgr/README.html) project documentation.
(start here)
The DNCMgr manages adding, deleting, archiving and moving DoNotCalls. Whenever
the TerrIDData.DoNotCalls table has a record deleted or changed (including add),
the DNCUpdt trigger is activated. This trigger adds a log message to the DNCLog
table with the timestamp of when the table was changed. Brief descriptions of each
operation follow:
<pre><code>
	Add - adds a new record to the TerrIDData.DoNotCalls table.
	Delete - deletes a record from the TerrIDData.DoNotCalls table and adds it to
		the DeletedDNCs table.
	Archive - copies a record from the TerriData.DoNotCalls table and adds it to
		the ArchivedDNCs table; then it deletes the record from the DoNotCalls table.
	Move - moves a DNC record from one territory to another; this is a combination
		of Archive, Delete, and Recover operations.
	Recover - recover a DNC record from the ArchivedDNCs table back into the DoNotCalls
		table, resetting the territory id from the old id to the recovery ID.
</code></pre>
<br><a href="#IX">Index</a>
<h3 id="5.0">5.0 Changing/Renumbering Territories.</h3>
<br><a href="#IX">Index</a>
<h3 id="n.0">n.0 Significant Notes.</h3>
<br><a href="#IX">Index</a>
