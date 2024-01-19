README.md - SegDefsMgr project documentation.<br>
3/5/23.	wmk.
###Modification History.
<pre><code>1/15/23.    wmk.   original document.
3/5/23.     wmk.    Project Builds section expanded.
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Dependencies - project dependencies.
<a href="#3.0">link</a> 3.0 Project Builds - step-by-step build instructions.
<a href="#4.0">link</a> 4.0 Database Builds - building databases from segment definitions.
<a href="#5.0">link</a> 5.0 Significant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
SegDefsMgr is the segment definitions manager for the territory system. It
handles the definition, extraction and deletion of segment definitions for
all territories.
<a href="#IX">Index</a>
<h3 id="2.0">2.0 Dependencies.</h3>
The SegDefsMgr depends on the TerrIDData.db tables SegDefs and SegSelect when
performing territory segment operations. It also depends upon the column
"Segmented" in the Territories table.

** Single-entry SegSelect;
Example - SegSelect specifies both territory and dbname.
<pre><code>
	delete from SegSelect;
	insert into SegSelect(Type, tidFilter, dbFilter)
	values('terrid','284', 'CapriIslesBlvd');

	WITH a AS (SELECT * FROM SegSelect)
	SELECT TerrID, dbName, sqldef
	 FROM SegDefs
	 INNER JOIN a
	 ON a.tidFilter IS TerrID
	  AND a.dbFilter IS dbName
	 WHERE TerrID IS a.tidFilter
	  AND dbName IS a.dbFilter;
</code></pre>

Example - SegSelect specifies only territory.
<pre><code>
	delete from SegSelect;
	insert into SegSelect(Type, tidFilter)
	values('terrid','284');

	WITH a AS (SELECT * FROM SegSelect)
	SELECT TerrID, dbName, sqldef
	 FROM SegDefs
	 WHERE TerrID IN (SELECT tidFilter FROM a);
</code></pre>

Example - SegSelect specifies only dbname.
<pre><code>
	delete from SegSelect;
	insert into SegSelect(Type, dbFilter)
	values('dbname','CapriIslesBlvd');

	WITH a AS (SELECT * FROM SegSelect)
	SELECT TerrID, dbName, sqldef
	 FROM SegDefs
	 WHERE dbName IN (SELECT dbFilter FROM a)
</code></pre>
<a href="#IX">Index</a>
<h3 id="3.0">3.0 Project Builds.</h3>
There are several pieces to the SegDefsMgr, each with its own build process. The
functions built are: LoadSegDefs, AddSegDefs, ClearSegDefs, and ListTerrSegs.
Each build process is documented in this section.

The DoSedSegDefs.sh shell must be executed prior to any build process. This
shell initializes the territory ID, special db and/or SCPA database references.
This is a "one size fits all" shell, so it pre-edits all build processes with
the specified parameters that are relevant to each process.

To run the DoSedSegDefs shell:
<pre><code>
	./DoSedSegDefs.sh  < terrid >  < special-db >|SCPA <mm> <dd>
	  < terrid > = territory ID
	  < special-db > = special db name (e.g. BirdBayDr)
					or 'SCPA'
	  < mm > = month of current SCPA download
	  < dd > - day of current SCPA download
</code></pre>
Once DoSedSegDefs has been run, all builds may be run and executed.

**ClearSegDefs** has been provided to clear errant or obsolete segment definitions.
To run ClearSegDefs initialize using the DoSedSegDefs shell. Then do:
<code><pre>
	make -f MakeClearSegDefs
</pre></code>
This will clear the segment definitions from the /DB-Dev/TerrIDData.db.

**DefineSegDefs** defines a new set of segment definitions for a territory.
Prior to running DefineSegDefs initialize using the DoSedSegDefs shell. Also,
the segement definitions need to be defined in a file named "segdefs.csv".
This file will reside either in  the /RefUSA-Downloads/Terrxxx or
SCPA-Downloads/Terrxxx folder. A segment definition is one or more lines
that define the SQL clauses to properly extract properties from the
< special-db > named in the DoSedSegDefs setup.

Each segment definition line is a triplet consisting of the territory ID,
the database the SQL clause applies to, and an SQL clause. The database
will either be one of the special databases in RefUSA/Special folder
(e.g. AvensCohosh) or will be 'SCPA'. SCPA tells the manager that the
/DB-Dev/Terr86777.db is the source for the records.

Examples.
<pre><code>

segdef from BirdBayDr
	  201,BirdBayDr,WHERE (UnitAddress LIKE '%birdbay dr%'
	  201,BirdBayDr, AND CAST(SUBSTR(UnitAddress,1,INSTR(UnitAddress,' ')) AS INTEGER) >= 800)

segdef from Terr86777.db
	  211,SCPA,WHERE "situs address (property address)" LIKE '%saint clair%'
	  211,SCPA, OR "situs address (property address)" LIKE '%waterside dr%'
	  211,SCPA, OR "situs address (property address)" LIKE '%chatham dr%'		
</code><pre>
With the segment definitions in place and DoSedSegDefs initialization complete
run DefineSegs:
<pre><code>	./DefineSegDefs.sh</code></pre>
DefineSegDefs will run the LoadSegDefs and AddSegDefs build processes to define the
segments for the territory specified.

<br><a href="#IX">Index</a>
<h3 id="4.0">4.0 Database Builds.</h3>
Once the segment definitions are in place databases may be constructed from
them. There are two separate processes for building database from segdefs. One
builds SCPA databases, the othe builds RefUSA databases.

**Building SCPA Databases.**
SCPA databases within the territories have the filename Terrxx_SC.db. These
all have a table Terrxxx\_SCBridge which contains the bridge format extracted
data from the Terr86777.db. The segdefs.csv contains the SQL clauses used to
extract the data.

SCPA databases are built using the makefile MakeBuildSCFromSegDefs within the
SegDefsMgr. Once the segdefs.csv file is in place in /SCPA-Downloads/Terrxxx
use \*make\* to build the database:
<pre><code>
	./DoSedSegDefs.sh < terrid > SCPA < mm > < dd >
	make -f MakeBuildSCFromSegDefs
	./MakeBuildSCFromSegDefs.sh
</code></pre>
When the \*make\* is complete and the resultant shell executed,
SCPA-Downloads/Terrxxx/Terrxxx\_SC.db will be the resultant database. Likely
there will need to be adjustments to the records for matching with
RefUSA-Downloads/Terrxxx_RU.db. The database manager will provide the code in
FixxxxSC.sql to make these adjustments.

**Building Special SCPA Databases.**
Special SCPA databases reside within the SCPA-Downloads/Special folder. These
all have a table Spec\_SCBridge which contains the bridge format extracted
data from Terr86777.db. The < spec-db >.segdefs.csv file contains the segment
definitions for special database < spec-db >.db. These databases are the
"anchors" for special RefUSA databases residing in the RefUSA-Downloads/Special
folder.

With the continual addition of new gated communities within the Venice North
congregation territory, the need arose to be able to define databases for these
new communities. These special databases facilitate creating new letter-writing
territories which include the addresses in these new communities.

Special SCPA databases are built using the makefile MakeBuildSpecSCFromSegDefs
within the SegDefsMgr. once the /Special/< spec-db >.segdefs.csv is in place
use \*make\* to build the database:
<pre><code>
	DoSedBuildSpecSC.sh < spec-db >
	make -f MakeBuildSpecSCFromSegDefs
	./BuildSpecSCFromSegDefs.sh
</code></pre> 
When the \*make\* is complete and the resultant shell executed,
SCPA-Downloads/Special/< spec-db >.db will be the resultant database.
There may need to be adjustments to the records for matching with
RefUSA-Downloads/Terrxxx_RU.db. The database manager will provide the code in
< spec-db >Tidy.sql to make these adjustments.
<h3 id="5.0">5.0 Significant Notes.</h3>
<br><a href="#IX">Index</a>
