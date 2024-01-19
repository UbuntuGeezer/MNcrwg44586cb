README - FlagSpecSCUpdates project documentation.<br>
1/30/23.	wmk.
###Modification History.
<pre><code>1/30/23.    wmk.   original document.
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Dependencies - project dependencies.
<a href="#3.0">link</a> 3.0 Project Build - step-by-step build instructions.
<a href="#4.0">link</a> 4.0 Significant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
FlagSpecSCUpdates cycles through the SCPA-Downloads/Special databases and generates
the table "OutOfDates". OutOfDates is a list of special SC databases that have
at least one record where the RecordDate is older than the corresponding RecordDate
in the Terr86777.db.
<pre><code>OutOfDates:
	DBName	TEXT		name of database (e.g. AuburnCoveCir.db)
	PropID	TEXT		out-of-date property ID
	Status	INTEGER		status, if odd, PropID is out-of-date
</code></pre>
<a href="#IX">Index</a>
<h3 id="2.0">2.0 Dependencies.</h3>
<h3 id="3.0">3.0 Project Build.</h3>
<h3 id="4.0">4.0 Significant Notes.</h3>
