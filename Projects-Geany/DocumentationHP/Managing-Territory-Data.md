Managing Territory Data - Documentation on managing territory data.<br>
	4/11/22.	wmk.
##Modification History.
<pre><code>4/7/22.     wmk.   original document.
4/10/22.    wmk.   "Defining Publisher Territories" section added.
4/11/22.    wmk.   "External Data Sources", "Downloading County Data",
             "Downloading RefUSA Data" sections added.
</code></pre>
##Document Sections.
<pre><code>Overview - general description of how territory data is organized.
Defining Publisher Territories - steps in defining publisher territories.
External Data Sources - sources of external data used in territories.
Downloading RefUSA Data - how to download RefUSA data.
Moving RefUSA Downloads - moving RefUSA downloads into tertitory system.
Downloading County Data - how to download county data.
Moving County Downloads - moving county downloads into territory system
</code></pre>
##Overview.
A congregation's assigned territory primarily consists of maps
that publishers use in working house-to-house within the territory. Usually
a congregation maintains a "master" map of the whole area assigned to the
congregation, divided into sub-areas that are polygons defining individual
territories that publishers can "check out" for working. Each polygon is 
given a unique identifier, usually a number with an optional prefix indicating
the type of territory. (i.e. "B-1" might be "business territory 1", 101 might
be "house-to-house" territory 101.)

The Watchtower branch office provides standardized forms for the congregation
to use in tracking
which territories are assigned out to publishers, and the dates the territories
have last been worked. There is also a provision for tracking "do not calls",
addresses (and possibly individuals) wishing not to be visited or contacted. At
the branch level, each congregation is assigned a congregation number, and all
information regarding that congregation is accessed by congregation number.

The Territory system is a means of organizing and distributing digital territory
information. It transforms territory map data into spreadsheets that may be
used by publishers when working territories. In order to do that, the analog
territory maps are migrated to digital text information. This digital
information is then organized into file system folders in the Territory system. These
folders allow for entry, updating and distribution of publisher territories. They
can be updated on a territory-by-territory basis so publishers can get the latest
information about the names and addresses in each territory they may check out.

Within the Territory system, all of the data for congregation's territory is 
referred to as the "data segment". Since there are many facets to entering, updating,
and distributing publisher territories, the tools and processes for performing
these operations are referred to as the "code segment". The documentation for the
code segment is contained in the"Managing Territory Support Code" document.<br>
[Managing Territory Support Code](file:///media/ubuntu/Windows/Users/Bill/Territories/Projects-Geany/Documentation/'Managing Territory Support Code')

##Defining Publisher Territories.
Defining a publisher territory involves setting up basic information about the territory.
This includes territory number, area name, location, streets, city, zip code and flags.
The mandatory information is the territory number, area name, city and zip code. Other
information is optional, used for maintenance purposes.

**Defining a Publisher Territory With Calc.**
The easiest way to define a new publisher territory is by running the shell *CreateCalcHeader*
from the Territories/Procs-Dev folder. This shell will create a generic publisher territory header
file *Terrxxxhdr.ods* in the TerrData/Terrxxx/Working-Files folder for territory *xxx*. From
there, the user uses the Calc app to edit the second row with the desired basic territory
information.

##External Data Sources.

##Downloading RefUSA Data.

##Moving RefUSA Downloads.

##Downloading County Data.

##Moving County Downloads.
