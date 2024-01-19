README - UpdateLtrDwnld project documentation.<br>
2/5/23.	wmk.
###Modification History.
<pre><code>2/5/23.    wmk.   original document.
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Dependencies - project dependencies.
<a href="#3.0">link</a> 3.0 Project Build - step-by-step build instructions.
<a href="#4.0">link</a> 4.0 Significant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
UpdateLtrDwnld only updates letter-writing territories. Since letter-writing
territories may have addresses scattered throughout the congregation's assigned
territory, it is not possible to consistently try to map them with polygons of
RefUSA data. Instead, each letter-writing terrirtory must be a special territory
which obtains its records from /Special/< spec-db >.db,s. Hence, there is no
Mapxxx_RU.csv polygon download data.

Each letter-writing territory has the SQL query file RegenSpecDB.sql that extracts
the records from the /Special/< spec-db >.db,s containing records for that
territory. The first database built in the RefUSA-Download/Terrxxx folder
is Spec\_RU.db.

The Terrxxx\_RU.db is built from the Spec\_RU.db records using the SQL query
SyncTerrToSpec.sql. That SQL copies all of the Bridge records from the Specxxx\_RU.db
into the Terrxxx\_RU.db. Any previous records within the Terrxxx\_RU.db are
abandoned, so the only records will be the newest records from the
/Special/< db-name >.db,s.
<a href="#IX">Index</a>
<h3 id="2.0">2.0 Dependencies.</h3>
<h3 id="3.0">3.0 Project Build.</h3>
<h3 id="4.0">4.0 Significant Notes.</h3>
