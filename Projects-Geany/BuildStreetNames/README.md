README - BuildStreetNames project documentation.<br>
12/19/22.   wmk.
###Modification History.
<pre><code>12/19/22.   wmk.   original document
</code></pre>
<h3 id=0.1>0.1 StreetNames.db Structure.</h3>
The /DB-Dev/Streetnames.db is a database of all street names within the
territory. It is built from a file-by-file scan of all of the RefuSA
publisher territory databases, selecting distinct street names. It should
be noted that for letter-writing territories the street names include
the zip code.<br>
**Streets Table.**<br>The "Streets" table is defined as follows:<br>
<pre><code>
	CREATE TABLE Streets(
	StreetName TEXT, TerrID TEXT, RUSpec TEXT, SCSpec TEXT)
	
	StreetName = extracted street name (may include zip code)
	TerrID = territory ID street is in
	RUSpec = RefUSA/Special/<db-name> containing street
	SCSpec = SCPA/Special/<db-name> containing street
</code></pre>

No fields within the table have UNIQUE values. A street name may reside
in several territories, and several RU/Special or SC/Special databases.
Records are inserted into the "Streets" table by running the following
query on each Terrxxx_RU.db:<br>
<pre><code>
	INSERT INTO Streets
	SELECT DISTINCT TRIM(SUBSTR(UnitAddress, INSTR(UnitAddress,' ')))
	  StreetName, 'xxx', '', ''
	FROM Terrxxx_RUBridge
	ORDER BY StreetName)
</code></pre>
