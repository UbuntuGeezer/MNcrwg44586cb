SPECIAL - Special download documentation for territories.<br>
	5/29/22.	wmk.
<h3>Modification History.</h3>
<pre><code>5/29/22.    wmk.   original document.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Territory Considerations.
<a href="#2.0">link</a> 2.0 Special Databases.
<a href="#3.0">link</a> 3.0 Processing.
<a href="#4.0">link</a> 4.0 Setup.
</code></pre>
<h3 id="1.0">1.0 Territory Considerations.</h3>
When a publisher territory gets complex, especially in urban areas, the standard
method of downloading territory data with map polygons often does not accurately
grab the data within the territory boundaries. Condominium complexes and streets
that extend beyond a single publisher territory boundary are two common situations
that produce this problem. If the territory is defined in such a way as to prohibit
the use of map polygons (like Territory Servant letter writing territories with
addresses scattered all over the congregation assigned territory) this also forces
the use of special downloads.

In these cases one or more special downloads need to be done in order to
accurately obtain all of the addresses within the publisher territory boundaries.
Depending upon the source of the download data, it may be that the special
download will be an entire street, or an entire gated community or mobile home
park. The special download itself may span several publisher territory boundaries,
but at least it will contain all the downloadable data for its target.

For "standard" territories, their download data is contained within a "tidy"
comma separated values (CSV/.csv) file named after the territory number. For
RefUSA data the file is named *Mapxxx\_RU.csv" where 'xxx' is the territory
number. For county data the file is named *Mapxxx\_SC.csv" where 'xxx' is the
territory number. This .csv and its associated database are located in the
territory's RawData folder.

For "special" territories, their download data is contained within a special
download CSV file and its associated database that resides in the RawData../Special
folder. That data is then extracted and
saved into a database named Specxxx\_RU.db or Specxxx\_SC.db within each
territory 'xxx' RawData folder.

These "special" territories each require tailored code and data segment modification
within the Territory system. Templates are provided that somewhat ease the burden
of implementation. But the skill set required to perform the modifications fall
into the category of
 "[Data Integrator](file:///media/ubuntu/Windows/Users/Bill/NewTerritories/Documentation/Territory System Project.html#4.0.7)". For this reason, when possible it is wise to limit the use of special
territories within the Territory system.<br>
<a href="#IX">Index</a>

<h3 id="2.0">2.0 Special Databases.</h3>
With the support of < state > < county > < congno > Territory systems, a new system-wide
envionment var has been defined. *pathbase* uses the *folderbase* environment var
to define the territory path base as $folderbase/Territories/< state >/< county >/< congno >
where < state > is the 2-character state abbreviation, < county > is the 4-character
county abbreviaion, and < congno > is the congregation number.

Territory xxx depends upon n special download databases resident in the folder
*pathbase*/RawData/.../RefUSA-Downloads/Special:

** mobile home park RU dbs.**
--* BayIndiesMHP.db - Bay Indies MHP RU download
--* BayLakeMHP.db - Bay Lake Estates MHP RU download
--* CountryClubMHP.db - Country Club MHP RU download
--* RidgewoodMHP.db - Ridgewood MHP RU download

** letter-writing RU territories dbs.**
--*	AvensCohosh.db -  Windwood RU download
--*	Bellagio.db - Bellagio RU download
--* BerkshirePlace.db - Berkshire Place RU download
--* BrennerPark.db - Brenner Park RU download
--* BridleOaks.db - Bridle Oaks RU download
--* EaglePoint.db - Eagle Point RU download
--* HiddenLakes.db - Hidden Lakes RU download
--* ReclinataCir.db - Reclinata Circle RU download
--* SawgrassN.db - Sawgrass north section RU download
--* SawgrassS.db - Sawgrass south section RU download
--* TheEsplanade.db - TheEsplanade RU download
--*	TrianoCir.db - TrianoCir RU download
--* WaterfordNE.db - WaterfordNE RU download
--*	WaterfordNW.db - WaterfordNW RU download

** special RU dbs.**
--* BirdBayWay.db - all Bird Bay Way addresses in Bird Bay
--* BirdBayCir.db - all Bird Bay Circle addresses in Bird Bay
--* BirdBayDr.db - all Bird Bay Dr addresses in Bird Bay
--* BirdBayDrW.db - [old] all Bird Bay Dr W addresses in Bird Bay.

Following is a sample SELECT clause for territory xxx:

MHP select.
ATTACH '$pathbase/RawData/RefUSA/RefUSA-Downloads/Special'
   || '/BayIndiesMHP.db'
   AS db29;
WITH a AS (SELECT UnitAddress AS StreetAddr
 FROM db11.Terr237_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE upper(UnitAddress) IN (SELECT StreetAddr FROM a);
DETACH db29;

non-MHP Special select.
WITH a AS (SELECT OwninigParcel AS Acct
 FROM db11.Terr237_SCBridge)
INSERT INTO Spec_RUBridge
SELECT * FROM db29.Spec_RUBridge
WHERE OwningParcel IN (SELECT Acct FROM a);
DETACH db29;

street select.
select * from Spec_RUBridge 
where cast("housenumber" AS INT) = 845
ORDER BY HOUSENUMBER, ApartmentNumber

Since a special download database is only the RU data for a given street/area,
it may not contain any records for a given territory that depends upon it, since
the RU data is only "occupied" addresses.<br>
<a href="#IX">Index</a>
<h3 id="2.0">2.0 Dependencies.</h3>
RegenSpecDB.sh - shell to rebuild and populate the Specxxx_RU.db from the latest special
  download databases listed above. This shell is tailored to each territory
  xxx and resides in ~/RefUSA-Downloads/Terrxxx folder.<br>
<a href="#IX">Index</a>
<h3 id="3.0">3.0 Processing.</h3>
When an update is done to territory xxx, RegenSpecDB.sh will be invoked
by the UpdateRUDwnld make/build. RegenSpecDB.sh will rebuild the local
Specxxx_RU.db by copying the Bridge records from the special download
databases that belong to territory xxx. The Specxxx_RU.db will then be
ready for use whenever it is needed.

The Specxxx_RU.db entries need to be integrated into the Terrxxx_RU.db prior
to running the BridgesToTerr makefile on territory xxx. The shell SyncTerrToSpec
merges the Bridge records from Specxxx_RU.db into the Terrxxx_RU.db After the
merge has been completed, if duplicate records are present, only the lastest 
are retained.

The make for the UpdateRUDwnld project has been modified to include both the
RegenSpecDB and SyncToTerrSpec shell executions if they are present in the
Terrxxx RU download folder.<br>
<a href="#IX">Index</a>
<h3 id="4.0">4.0 Setup.</h3>
The SpecialRUdb project contains all the tools necessary to take a special
download from RefUSA-Downloads/Special and move the .csv records into
a database named after the .csv. A special download, say vvvvv.csv is
the extracted records from a RefUSA polygon for given street or area.

CAUTION: The RegenSpecDB.sql for Mobile Home Park,s (MHPs) has been
implemented to depend upon the UnitAddress,s in the Terrxxx_SC.db. This
makes the RegenSpecDB processing identical for MHPs and letter/phone
territories. PRIOR TO EXECUTING RegenSpecDB.sh 'Export RU Data to SC'
must be run to set up the initial Terrxxx_SC.db from an existing MHP,s
Terrxxx_RU.db.

RU-Downloads/Special
The creation of the /Special/vvvvv.db involves several steps.
	SpecialRUdb Project:
	Build menu; enter territory ID and vvvvv name into "sed" item
	execute "sed" from the build menu
	execute "Make" from the build menu, creating vvvvv.db
	[the tables created in vvvvv.db are documented in SpecialRUdb/README]

RU-Downloads/Terrxxx
	copy files SPECIAL, RegenSpecDB.sq, SyncTerrToSpec.sq, MakeRegenSpecDB.tmp,
	  MakeSyncTerrToSpec.tmp, SpecxxxRU.sql, MakeSpecTerrQuery, MakeSpecials to Terrxxx
	  folder by running the shell InitSpecial.sh from the SpecialRUdb project

	edit SPECIAL in the territory download folder to document the special
	  databases and procedures for generating the territory

	edit SpecxxxRU.sql to properly extract the RU data from the <special-db>
	  that applies to territory xxx
	edit MakeSpecTerrQuery to run on territory xxx
	run "make" in the territory download folder to execute the query and
	  generate the initial Specxxx_RU.db database

	edit the names of any Special databases into the RegenSpecDB.sq file
	  ATTACH statement(s) to complete customizing the process for the territory.
	run "make" in the territory download folder to generate RegenSpecDB.sh shell
	  the MakeRegenSpecDB makefile
	use "sed" to change "<filename>" to "RegenSpecDB" in RegenSpecDB.sh
	[RegenSpecDB.sh will be run by the UpdateRUDwnld project]

	edit SetSpecTerrs.sql setting the territory ID and special db names
	edit MakeSetTerrs makefile setting the territory ID

	run "make" in the territory download folder to generate SetSpecTerrs.sh shell
	  with the  MakeSetSpecTerrs makefile
	use "sed" to change "<filename>" to "SetSpecTerrs" in SetSpecTerrs.sh

	run "make" in the territory download folder to generate SyncTerrToSpec.sh shell
	  using the MakeSyncTerrToSpec makefile
	use "sed" to change "<filename>" to "SyncTerrToSpec" in SyncTerrsToSpec.sh

	[letter-writing territory]
	if this is a letter territory, code AddZips.sql to add zip codes to all
	 UnitAddress fields in Bridge tables used by this territory. The code
	 for this may be cloned from Terr626/AddZips.sql and should be saved
	 in the Terrxxx folder
	copy the MakeAddZips makefile from Terr 626 and edit for this territory
	run make -f MakeAddZips to make the AddZips.sh shell

	run RegenSpecDB.sh in the Terrxxx folder

	run SetSpecTerrs.sh in the Terrxxx folder

	run SyncTerrToSpec.sh in the Terrxxx folder

	[letter-writing territory]
	run AddZips.sh to add the zip codes to all UnitAddress fields

	edit MakeSpecials and remove .PHONY qualifier to activate makefile
	ensure territory ID and database(s) names are all set for downstream call
	 whenever any upstream database is updated
	if MakeSpecials is for a letter-writing territory, incude the prerequisite
	 and Make for AddZips.sh after the SyncTerrToSpec.sh call to add the
	 zip codes to the UnitAddresses in all the Bridge tables referenced
	 by the territory

Following the "make" operation, RegenSpecDB.sh, SetSpecTerrs, and SyncTerrToSpec.sh
are ready to be run, in order, from the territory download folder. This
will complete the setup of all the "special" database files that can
now be automatically used by UpdateRUDwnld when regenerating the territory
records after either the special or territory downloads.<br>
<a href="#IX">Index</a>

