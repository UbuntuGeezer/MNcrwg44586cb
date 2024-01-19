Managing Territory Data - Documentation on managing territory data.<br>
	3/6/23.	wmk.
###Modification History.
<pre><code>4/7/22.     wmk.   original document.
4/10/22.    wmk.   "Defining Publisher Territories" section added.
4/11/22.    wmk.   "External Data Sources", "Downloading County Data",
             "Downloading RefUSA Data" sections added.
1/15/23.    wmk.   hyperlinks added.
1/18/23.    wmk.   'Managing Territory Code' hyperlink corrected; 'Addresses Not
             Assigned To Territories' section added.
2/5/23.     wmk.   (future) sections added to Document Sections list.
3/6/23.     wmk.   Downloading RefUSA Data and Moving RefUSA Downloads sections
             expanded.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Overview - general description of how territory data is organized.
<a href="#2.0">link</a> 2.0 Defining Publisher Territories - steps in defining publisher territories.
<a href="#3.0">link</a> 3.0 External Data Sources - sources of external data used in territories.
<a href="#4.0">link</a> 4.0 Downloading RefUSA Data - how to download RefUSA data.
<a href="#5.0">link</a> 5.0 Moving RefUSA Downloads - moving RefUSA downloads into tertitory system.
<a href="#6.0">link</a> 6.0 Downloading County Data - how to download county data.
<a href="#7.0">link</a> 7.0 Moving County Downloads - moving county downloads into territory system.
<a href="#8.0">link</a> 8.0 Addresses Not Assigned To Territories - handling unassigned addresses.
<a href="#9.0">link</a> (9.0 Integrating Downloads - integrating downloaded data into territories.)
<a href="#10.0">link</a> (10.0 Generating Publisher Territories - generating territories for publisher use.)
<a href="#11.0">link</a> (11.0 Distributing Publisher Territories - releasing territories for publisher use.)
<a href="#12.0">link</a> (12.0 Synchronizing Territory Data - keeping all the pieces synchronized.) 
</code></pre>
<h3 id="1.0">Overview.</h3>
A congregation's assigned territory primarily consists of maps
that publishers use in working house-to-house within the territory. Usually
a congregation maintains a "master" map of the whole area assigned to the
congregation, divided into sub-areas that are polygons defining individual
territories that publishers can "check out" for working. Each polygon is 
given a unique identifier, usually a number with an optional prefix indicating
the type of territory. (i.e. "B-1" might be "business territory 1", 101 might
be "house-to-house" territory 101.)

The Watchtower branch office provides standardized forms for the congregation
to use in tracking which territories are assigned out to publishers, and the
dates the territories have last been worked. There is also a provision for
tracking "do not calls", addresses (and possibly individuals) wishing not to
be visited or contacted. At the branch level, each congregation is assigned a
congregation number, and all information regarding that congregation is accessed
by congregation number.

The Territory system is a means of organizing and distributing digital territory
information derived from the congregation's territtory maps. The top tier of the
Territory system is the congregation assigned territory. In most cases, a
congregation's assigned territory will be contained within a single county's
boundaries. But in other cases the congregation's assigned territory may contain
all or part of two or more counties.

To accommodate any possible configuration of congregation assigned territory
within, or across, county boundaries, the Territory system splits the congregation
assigned territory along county lines. This is necessary since street names
and addresses may well be duplicated in different counties. This also makes
possible implementing county-specific data mining algorithms for acquiring
names and addresses within the congregation assigned territory.

To facilitate implemtation of the Territory system for the congregation, the
publisher territories must follow these rules:
<pre><code>
	any given publisher territory MUST NOT cross state lines
	any given publisher territory MUST NOT cross county lines
	a letter-writing territory SHOULD NOT cross zip codes
	mobile home parks or gated communities SHOULD NOT be part of a territory
	 which extends beyond the boundaries of the park or community
</code></pre>
If the current mapping of the congregation assigned territory does not meet
the above criteria, the maps should be changed in whatever ways are necessary
to meet the criteria. This is an important step BEFORE proceeding to implement
the Territory system.
 
Within the Territory system, all of the data for congregation's territory is 
referred to as the "data segment". Since there are many facets to entering, updating,
and distributing publisher territories, the tools and processes for performing
these operations are referred to as the "code segment". The documentation for the
code segment is contained in the"Managing Territory Code" document.<br>
[Managing Territory Code](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/DocumentationCB/ManagingTerritoryCode.html)

It transforms territory map data into spreadsheets with lists of
addresses that may be used by publishers when working territories. In order to
do that, the analog territory maps are migrated to digital text information.
This digital information is then organized into file system folders in the
Territory system. These folders allow for entry, updating, and distribution of
publisher territories. They can be updated on a territory-by-territory basis so
publishers can get the latest information about the names and addresses in each
territory they may check out.

<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Defining Publisher Territories.</h3>
The congregation territory map divides the entire area assigned to the
congregation into territories which the publishers may "check out". These
territories are areas that have boundaris on the map that define which streets
are included within each publisher territory.

The Territory system transforms territory map data into spreadsheets with lists
of addresses that may be used by publishers when working territories. In order
to do that, the analog territory maps are migrated to digital text information.
This digital information is then organized into file folders within the
Territory system. These folders allow for entry, updating, and distribution of
publisher territories. They can be updated on a territory-by-territory basis so
publishers can get the latest information about the names and addresses in each
territory they may check out.

The top tier of the Territory file system is organized by state and county. If a
congregation's assigned territory spans more than one state or county, there
will be a separate folder system in the top tier for each state and county. The \
folder system for a given congregation and county uses the naming convention:<br>
<pre><code>		< state >/< county >/< congid >
 where < state > is the two-character state abbreviation
	   < county > is a four-character county abbreviation
	   < congid > is the Watchtower branch-assigned congregation number
	   Example: FL/SARA/86777 is for Florida, Sarasota County, congregation 86777</code</pre>

Publisher territories are usually straight-forward in rural areas, but may get
extremely complex in urban areas. Within urban areas streets typically are used
as boundaries of publisher territories. The boundary streets may have residences
on both sides of the street with one set of residences in one territory, and
the residences on the opposite side of the street in a different territory. A
long street may have several segments that serve as the boundary for different
publisher territories.

This section describes defining straight-forward publisher territories. For
territories with complex boundaries see the documentation in the
[SpecialSCdb](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/SpecialSCdb/README.html)
and
[SpecialRUdb](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/SpecialRUdb/README.html)
and the territory segment definitions manager
[SegDefsMgr](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/SegDefsMgr/README.html)
projects.

Defining a publisher territory to the Territory system is a three-step process.
The first step is setting up basic information about the territory which includes
territory number, area name, location, streets, city, zip code and flags.
The project coordinator uses the TerrIdMgr project to define each territory
within the TerriDData.db resident in the /DB-Dev path. The minimal information
needed is the territory number, area name, city and zip code. The other
information is optional, used for maintenance purposes. The second step
is defining and initializing the SCPA folders for the county territory data. The
third step is defining and initializing the RefUSA folders for the Reference USA
territory data. These steps are itemized below:
<pre><code>
   Project Coordinator uses the NewTerritory project to define the territory
    within the TerrIDData.db database
   Project Coordinator uses the SCNewTerritory project to create the county 
    folders for territory data
   Project Coordinator uses the RUNewTerritory project to create the RefUSA
    folders for territory data</code></pre>

Once the publisher territory is defined within the Territory system, it is ready
to receive all of the information about any addresses within its boundaries.
That information is imported from external data sources that provide
comprehensive lists of addresses within the territory boundaries.

To complete the territory definition process the shell *GenTerrHdr* is run from
the /Procs-Dev folder. This takes the information from the TerrIDData.db and
generates a .csv for the territory header in the /TerrData/Terrxxx folder. Then
Calc is run to generate the spreadsheet file TerrxxxHdr.ods which is used
whenver the publisher territory is generated.

**This section may only be on the HP dead computer...**
**Defining a Publisher Territory With Calc.**
The easiest way to define a new publisher territory is by running the shell
\*CreateCalcHeader\* from the Territories/Procs-Dev folder. This shell will
create a generic publisher territory header file \*Terrxxxhdr.ods\* in the
TerrData/Terrxxx/Working-Files folder for territory *xxx*. From there, the
database administrator uses the Calc app to edit the second row with the
desired basic territory information.
<br><a href="#IX">Index</a>

<h3 id="2.5">2.5 Pre-defining Proposed Territories.</h3>
Some congregations have assigned territory that is rapidly increasing in
population with the addition of condominiums and gated communities. This poses
a challenge because of the need to subdivide existing territories into
smaller territories.

A provision has been made for pre-defining proposed territories that are
split out from existing territories, or are totally new for unassigned areas.
The standard for these territories is to number them 801 - 899. This allows
for creating maps and data downloads as if the territories already exist.
Once the Congregation Service Overseer approves a proposed territory, it may
be migrated into the active territories system and assigned an appropriate
permanent territory number.

Databases are created in both the RefUSA-Downloads and SCPA-Downloads folders
for these proposed territories, so they may be managed using all of the existing
project and code modules.
<br><a href="#IX">Index</a>
<h3 id="3.0">3.0 External Data Sources.</h3>
Two external sources of address data are supported by the Territory system.
The primary source of data is the county property records. The secondary source
of data is the Reference USA system. The Territory system integrates these two
sources of information when generating publisher territories.

The county data provides property ownership and use information. The Territory
system treats this data as the primary information about any given parcel of
property. The only time this data changes for any given property is when the
parcel is sold, its use changes, or its homestead status changes. This data is
the more static of the two sources.

The data provided by each county varies in both format and content. The database
administrator needs to incorporate both SQL database management code and "Calc"
macros that are taylored to the county data. These modules are considered part
of the CodeSegment, so are beyond the scope of this document.

The Reference USA (RefUSA) data provides occupant information. Since many
properties may be rentals, this data is especially useful for letter writing and
telephone witnessing. The RefUSA data is frequently updated and is one of the
best sources of occupancy information.

The data provided by RefUSA is the same, regardless of which state or county
contains the territory. The database administrator need only to verify that
the "standard" SQL database management code and "Calc" macros released with
the Territory system are working properly for the RefUSA data.

Not all residences may have their own parcel information in the county data. One
example of this is mobile home parks where the entire park is considered one
parcel within the county data. The lot boundaries and management within the park
are managed by whatever entity owns the mobile home park. For these parcels
RefUSA or a park-published directory are the only sources of occupants within
the mobile home park.

Some counties do not provide public access to digital ownership information. For
these counties a source of digital property ownership information is the
Government Information System (GIS) data. This is a federally maintained database
of property information. Its accessibility for obtaining data pertaining to any
given county varies by state and county. There are no "template" SQL queries
of "Calc" macros in the Territory system release for GIS data. It is left to the
database administrator to create these for any county providing GIS data. In the
absence of both county and GIS data for an area, the only option is to use the
available RefUSA data.

The Territory system provides for downloading both county and RefUSA data. The
oveall method for downloading RefUSA data is the same regardless of the state(s)
and county(ies) within the congregation territory boundaries. The specifics for
downloading county data varies for every county. See the appropriate sections
below for details on downloading territory data from either of these sources.
<br><a href="#IX">Index</a>

<h3 id="4.0">4.0 Downloading RefUSA Data.</h3>
The DataAxle/ReferenceSolutions website is used for downloading RefUSA data. The
term RefUSA comes from the predecessor website name "Reference USA". The website
is accessible through the major public library systems throughout the United
States. The Sarasota County Library System provides a hyperlink to the website
in its Sarasota Digital Library page. To access the link one logs into the
Sarasota Digital Library using their library card number.

Once logged into the Sarasota Digital Library move to the "Business and Careers"
link, then navigate within that link to "Reference Solutions (formerly Reference
USA)" and click on that hyperlink. You will then be redirected to the
DataAxle/Reference Solutions webpage.

The project coordinator has defined territory polygons and street selection
searches to access RefUSA data for each publisher territory within the
North Venice Congregation assigned territory. There is a "saved searches"
submenu that accesses all of these saved searches. There are currently more
than 250 saved searches. Most are for map polygons that match the congregation
publisher territory maps. Many are for specific streets. The naming convention
used for the saved searches is "Terrxxx" for map polygons, and < street > for
street-specific searches. Other saved searches are for areas, like Bay Indies
mobile home park "BayIndiesN" and "BayIndiesS".

To download the current data desired, simply click on the search name from
the "saved" list. This will bring up a results screen that lists the records
25 per page. At the top of each page list is a checkbox that allows selecting
all records from the page. When finished selecting the pages (usually all) for
download, clicking on the [Download] control will navigate to the Download
inteface page. The default selections grab the data when the [Download] control
is clicked on the Download interface page. The data will be stored on your
computer in whatever folder captures your browser downloads.

The Territories system depends upon certain naming conventions for RefUSA
download files. Files are renamed to "Mapxxx\_RU.csv" for map polygon downloads,
"< street >".csv for street downloads, and "< area >".csv for area downloads.
All subsequent Territories operations depend upon this name convention to
properly move and process downloaded data. (See the
<a href="#5.0"> Moving RefUSA Downloads</a> section that follows for moving
newly downloaded data to territory folders.)

The RefUSA system limits the number of records on a single download to 250. For
large areas like Bay Indies mobile home park this requires performing multiple
downloads by selecting groups of up to 10 pages and downloading. When an map,
area or street requires multiple downloads the naming convention for these
downloads adds '-n' to each download name (e.g. Terr102-1\_Map.csv, Terr102-2\_Map.csv).
There is a special procedure for moving these .csv files to their appropriate
territories (discussed below). If you exceed a daily limit for downloads
(determined by DataAxle) you will be instructed to contact them. Merely waiting
typically ovenight will restore your download capability. The system may also
intevene with an "I am not a robot" verification. Simply go through the
verification and continue with whatever you were doing.
<br><a href="#IX">Index</a>
<h3 id="5.0">5.0 Moving RefUSA Downloads.</h3>
Once the RefUSA download data has been captured to the /Downloads folder, it
needs to be moved to the appropriate territory folder. The file naming
convention facilitates this process, since all "map" downloads have the
territory number as part of their name. Three shells within the UpdateRUDwnld
project facilitate moving the files into their proper territories.
<pre><code>
MovDwnld.sh - moves one or more downloads to a congregation territory.
	./MovDwnld.sh  < terrid > [< count >]
	  < terrid > = territory ID
	  < count > = (optional) count of files to move (default 1)
	  		if > 1, Mapxxx-1_RU.csv .. Mapxxx-n_RU.csv files moved

CatDwnld.sh - concatenates downloads in the territory folder.
	./CatDwnld.sh  < terrid > < count >
	  < terrid > = territory ID
	  < count > = count of files to concatenate
	  Files Mapxxx-1_RU.csv .. Mapxxx-n_RU.csv concatenated to Mapxxx_RU.csv

MovMapsDwnld.sh - move all Map*_RU.csv downloads to territories in names.
	For each file, if a newer Mapxxx_RU.csv exists in the territor folder,
	 the move is skipped. Otherwise the copy is performed preserving the .csv
	 file date.
</code></pre>
Once the download data is in place for any given territory, different
operations may be performed with the up-to-date territory data. This includes
building the territory's database of records, updating the territory's
database of records, and generating the publisher territory.

Generating a publisher territory from the data is a complex process. It
involves processing the download data into territory databases, then merging
the data from the RefUSA and county databases for the territory into a
spreadsheet of address records for the publisher. That process is documented
in the
[SyncAllData](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/SyncAllData/README.html)
 project. That project synchronizes all of the relevant data for any given
 publisher territory and produces the publisher territory spreadsheets.
<br><a href="#IX">Index</a>

<h3 id="6.0">6.0 Downloading County Data.</h3>
The process for downloading county data will vary from county to county within
any given state. If the congregation territory crosses county lines there will
likely be different procedures for downloading county data into the Territories
system. Each county will have its own documentation within this section.

Before downloading county data your internet browser should have the *Downloads*
option set to point to the folder into which data will be downloaded from the
internet. This download folder must also be known to all territory processes
that handle download data (e.g. UpdateSCBridge project processes). The **DNWLD\_PATH**
environment variable needs to be set up by the Project Manager to point to this
download folder. (link this to a Project Manager documentation file of some sort).
For the Chromebook system DWNLD_PATH is set to /home/vncwmk3/Downloads.

**Sarasota County**<br>
The Sarasota County Property Appraiser has as dedicated website providing access
to county property records. There are two primary tabs within the website that
are useful for territory management. The principal tab for downloading county
propety data is the "download-data" tab linked here: 
[SCPA Downloads](https://www.sc-pa.com/downloads/download-data/) The other tab
that is quite useful is the "Map Search" tab. This allows searching for a parcel
by its address or parcel # within the Sarasota County property system. When the
desired parcel is located, the map view shows an aerial view of the parcel, its
parcel number, and boundaries. The "map search" tab is linked here:
[SCPA Map Search](https://ags3.scgov.net/scpa/).

The "Database Downloads for General Use" section has a hyperlink to download
the "SCPA Public.xlsx" spreadsheet. This is a massive spreadsheet (84M) that
contains all of the county property records along with multiple tables for
converting various codes within the property records to English descriptions.

Where possible, this spreadsheet should be downloaded without entering any
spreadsheet handler (e.g. Microsoft Excel or Calc). This is because of the
huge overhead in loading the file into the spreadsheet app. Once the file
has been downloaded it is advisable to load it into the spreadsheet app
with no other applications running. This will minimize the demand for system
resources and speed up the loading process.

Within the spreadsheet app as soon as the 'SCPA Public.xlsx' file has been
loaded, turn off "AutoCalc" automatic calculations. This will prevent the
spreadsheet app from unnecessarily checking if any cells have been modified
when performing any spreadsheet operations. Otherwise, the simplest of
operations (like saving the file) can take FOREVER.

With AutoCalc disabled use the File/SaveAs menu tab to save this file as
a comma-separated-values (CSV) file named "SCPA-Public_mm-dd.csv" where
mm and dd are the month and day of the download. This will set up the
downloaded data for the *ImportSCPA* project to import the new download
data. 

The warning message "Only the active sheet has been saved" will be
issued by the spreadsheet app. This is normal. At this point exit the
spreadsheet app and go on to the "Moving County Downloads" section.
<br><a href="#IX">Index</a>

<h3 id="7.0">7.0 Moving County Downloads.</h3>
<br><a href="#IX">Index</a>

<h3 id="8.0">8.0 Addresses Not Assigned to Territories.</h3>
Congregation territories which contain large tracts of undeveloped land may go
through stages where parcels of undevloped land are subdivided then developed
into residential areas. This is a common occurrence in congregation territories
where gated communities are being added. In urban areas sometimes business
parcels are rezoned and replaced with condominiums.

During the process of building a gated community or new condominium complexes,
new addresses may show up in the county data that are not assigned to a
territory. Another possibility is that the new addresses are part of a large
tract of territory that is being worked door-to-door, but the new addresses
are within a gated community that will likely become a separate territory.

To accommodate these parcels a new record type is now valid in publisher territory
Bridge data. A "U" record type indicates that the parcel/address is currently
unassigned to a specific publisher territory. Territory numbers >= 800 should
be the only territories containing this record type. The standard publisher
territory generation procedures may be used on these "unassigned" territories
for the convenience of producing spreadsheets of the unassigned addresses. See
[UpdateCongTerr](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/UpdateCongTerr/README.html)
 project documentation for details on how the system handles property IDs
 not currently assigned to territories.
<br><a href="#IX">Index</a>
<h3 id="9.0">(9.0 Integrating Downloads - integrating downloaded data into territories.)</h3>
<h3 id="10.0">(10.0 Generating Publisher Territories - generating territories for publisher use.)</h3>
<h3 id="11.0">(11.0 Distributing Publisher Territories - releasing territories for publisher use.)</h3>
<h3 id="12.0">(12.0 Synchronizing Territory Data - keeping all the pieces synchronized.)</h3>
