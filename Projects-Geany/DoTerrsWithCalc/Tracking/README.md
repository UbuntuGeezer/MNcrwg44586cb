README - Tracker folder documentation.<br>
6/9/22.	wmk.<br>
<h3>Modification History.</h3>
<pre><code>1/26/22.    wmk.    original documentation.
4/26/22.    wmk.   MultiHost Support section added.
6/9/22.     wmk.   Confidential Record Handling section added; links added.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Tracker Description - overall content of Tracker folder.
<a href="#2.0">link</a> 2.0 Files - brief description of files in Tracker.
<a href="#3.0">link</a> 3.0 SystemTracker Tabs - spreadheets within the SystemTracker.ods workbook.
<a href="#4.0">link</a> 4.0 MultiHost Support - support for different host systems.
<a href="#5.0">link</a> 5.0 Confidential Record Handling - handling sensitive addresses.
<a href="#5.1">link</a>     5.1 Registered Sex Offenders.
<a href="#5.2">link</a>     5.2 Confidentail Owners.
</code></pre>
<h3 id="1.0">1.0 Tracker Description.</h3>
The *Tracker* folder contains spreadsheets and files containing all of the tracking information about the territories project except for releases. Territory releases are tracked in the *Territories/ReleaseData* folder.

The Tracker folder consolidates all information so that the download and generation status of each territory within the system is up-to-date. This facilitates prioritizing the updating of territories with fresh data from either the Sarasota County Property Appraiser or RefUSA websites.
<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Files.</h3>
<pre><code>SystemTracker.ods - main Territories tracking workbook.(See *System Tracker Tabs*
   below for further information.)

TerritoryBugs.xls - summary of territory bugs extracted from the *ToDo-Bugs* worksheet
   in SystemTracker.ods

DNCSummary.csv - extracted list of territories and DNC counts from TerrIDData.db table
   of DoNotCalls; this should roughly correspond to /Territory-PDFs/DoNotCalls.pdf list
</code></pre><a href="#IX">Index</a>
<h3 id="3.0">3.0 SystemTracker Tabs.</h2>
There are multiple tabs within the SystemTracker.ods workbook for keeping track of various aspects of the Territories system. Following is the list of tabs in their order of occurrence:
<pre><code>ToDo Project Management - tasks involving Service Overseer or
   Territory Servant

ToDo Integration - tasks involving *make* dependencies

ToDo Data Managment - tasks involving data downloads, db building, territory
   requests, release generation, tracking

ToDo_DNC_Updates - current DNC list status

SCPA Map Downloads - SCPA download and db generation tracking

RefUSA Map Downloads - RefUSA download and db generation tracking

ToDo_Features - tasks involving feature requests or wishlist items

ToDo_Bugs - tasks involving any bugs; reported, testing, released or
   outstanding bugs

ToDo_Coding - tasks for coding in Basic, SQL, shell or code documentation

Pending Territory Master Updates - territory list from UpdateMaster.txt
   (created by DNCMaintenance/QueryAllDNCs.sql)

Territory Master Map - complete territory list, map locations, generation status

Territory Generation - detailed list of generation dates and hyperlinks to territory
  data files

MHP-RU Downloads - RefUSA Mobile Home Park download summary

SCPA Main Downloads - SCPA full downloads log

Territory Master Map_Sorting - Territory Master Map sorted by generation date

Coding Tracker - scratch sheet of tasks for tracking large coding projects
   by territory

Pending Updates - old pending db updates needed list

DB Status - staus of "critical" databases

TIDList - list of territory IDs extracted from Territory Master Map; this sheet
 gets exported to Tracking/SystemTrackerTIDList.csv for use by other projects;
 macro *GenTIDList* can be run from any sheet to generate this sheet and the
 resulting .csf
</code></pre><a href="#IX">Index</a>
<h3 id="4.0">4.0 MultiHost Support.</h3>
The Territory system may be run on different hosts and different operating
systems. Because of the differences in the file systems, the SystemTracker
must be able to accommodate variances in the Territory file directories/folders.
The sheet most affected by migration across systems is the Territory Generation tab.
This is because it contains hyperlinks to the generated territory spreadsheets.

The SystemTracker spreadsheet has an internal macro *FixHyperlinks* that repairs
hyperlinks that have become out-of-date because of migrating to a different host
system. Two string constants defined within the FixHyperlinks macro provide the
bridge between the out-of-date and current host paths.

*csOldBasePath* specifies the out-of-date base path for the Territory system from
 the old host. (e.g. "/home/vncwmk3")
*csNewBasePath* specifies the current  base path for the Territory system on the
 new host. (e.g. "/media/ubuntu/Windows/Users/Bill")

Whenever the SystemTracker is migrated to a new system, the above two string constants
should be set appropriately. Then using Calc>Tools>Macros>Run Macro select the
*FixHyperlinks* macro and run it. This will repair all broken hyperlinks.<br><a href="#IX">Index</a>
<h3 id="">5.0 Confidential Record Handling.</h3>
There are two types of confidential records in the territory data. One is "DoNotCall"s
that are registered sex offenders (RSO). The second is owners that have sought protection
under state statutes that none of their personal information be released with property
records. In Florida these are protected by Florida statutes f.s.section 119.071
 <a href="#5.2">below</a>.

<a id="5.1"></a>**Registered Sex Offenders.**
Registered sex offenders (RSO) are a special subcategory of "DoNotCalls". While the information
on RSOs is public, the publisher territories only list them as "DoNotCall". This list is
maintained by the congregation Territory servant. The utility shell *GetRSOListsh* in the
/Tracking folder obtains the current list of RSOs from the territory data. Whenever a
territory is updated, the current RSO list is consulted.

The data for DoNotCalls (DNC) is recorded in the /DB-Dev/TerrIDData.db in the table named
*DoNotCalls*. Each entry has an *RSO* field that is set to 1 if this DNC is an RSO. The
TerrIDData.db is updated by the Data Integrator with information from the Territory
servant.<br><a href="#IX">Index</a>

<a id="5.2"></a>**Confidential Owners.**
Confidential owners have sought protection under state statutes limiting their information
being exposed in public records. In Florida this protection is under Florida statutes
section 119.071. Sarasota County honors this by listing the owner as "CONFIDENTIAL". The
publisher territories have "CONFIDENTIAL" or "Confidential" as the listed resident.

To protect the privacy of these confidential owners, the congregation should have an
established policy for contact. Generally speaking, door-to-door contact is allowable
as long as they are not listed as DNC. However, phone contact likely would be ruled out, and
letter writing would likely address the letter/envelope "Current Occupant" to avoid
disturbing the privacy of the individual. The list of "confidential"s is obtained by
running the utility shell *GetConfidentials.sh"* in the /Tracking folder.<br><a href="#IX">Index</a>
