##Method.<br>

The project SpecialSCdb contains the necessary support objects when setting up a special SC database. The database will be named after the principal street or area covered (e.g. TheEsplanade.db). The special database will reside in folder SCPA-Downloads/Special.

The following steps should be performed in order when setting up a special SC database: <pre><code>
	(Method 1 - records extracted from VeniceNTerritory.db)
	(Method 2 - records downloaded via SC Polygon)
</code></pre>
##Method 1:
Create the query << special-db >> \_1.sql in the /Special folder to extract the correct records from NVenAll in the Special folder. The extracted records are in file < special-db > .csv. The query also contains the SQL to take the extracted records and build the < special-db > .db, PropList, TerrList, and Spec_SCBridge tables from full SCPA download records. {SpecialSCdb}/Method1.sql is the template for this type of query.

##Method 2:
Create the query << special-db >> \_2.sql in the /Special folder to take downloaded records from SCPA polygon map data << special-db >> .csv and build the < special-db > .db \_SCPoly, PropTerr, TerrList, and Spec\_SCBridge tables from the map download data. {SpecialSCdb}/Method2.sql is the template for this type of query.

##Method 3:
Create the query << special-db >>\_3.sql in the /Special folder to extract the correct records from SCPA\_mm-dd.db in the SCPA-Downloads folder. The extracted records are in file < special-db > .csv. The query also contains the SQL to take the extracted records and build the < special-db > .db, PropList, TerrList, and Spec_SCBridge tables from full SCPA download records. {SpecialSCdb}/Method3.sql is the template for this type of query.

##Method 1 and 2:<br>
<br>
  In the SpecialSCdb Build>SetBuildCommands edit "sed">./DoSed.sh and<br>
   set <special-db> mm dd [terrid] parameters<br>
  Build>sed to update the makefile<br>
<br>
  [Build>Make Dry-run] to verify accuracy<br>
<br>
  Build>Make to generate the database <special-db>.db<br>
<br>
  use SQL db browser to verify<br>
  [Since territory will be set in all records, if not all are in<br>
   same territory, run SQL and clear the Special\_SCBridge.CongTerrID<br>
   fields]<br>
<br>
  [this step is new as of 10/6/21.]<br>
  The SQL <special-db>Tidy.sql will be implemented for territories<br>
  which are almost totally dependent upon the Special database (like<br>
  letter-writing territories with random addresses). This SQL will<br>
  "tidy up" the <special-db>.db, setting the RecordDate and <br>
  RecordType fields in the Special_SCBridge table. This will only<br>
  leave the "DoNotCall" fields unset. They will need to be be set by<br>
  theMakeSpecials make for each territory.<br>
  Use EaglePointTidy.sql as a template, as this alleviates most<br>
   problems with polygon downloaded records.<br>
   After the <special-db>Tidy.sql has been coded, it should be<br>
   processed by (bashpath)AnySQLtoSQ and (bashpath)AnySQtoSH.<br>
   run through the AnySQLtoSH project to generate its .sq shell<br>
   statements, then it should be made into a .sh file for running<br>
   the actual fixes into the <special-db>.db.<br>
  The Make.AnyTidy makefile in the Special folder will perform<br>
   the above operations after running DoSedAnyTidy.sh.<br>
 <br>
After the special database has been created in SCPA-Downloads/Special,<br>
each territory using records extracted from that db will have to be set<br>
up to process it. The processes and files for integrating the special db<br>
data with the "regular" territory SC data will all be defined in the<br>
territory's SCPA-Downloads/Terrxxx folder.<br>
<br>
[Territory Setup](file:///media/ubuntu/Windows/Users/Bill/Territories/Projects-Geany/SpecialSCdb/README.TerrSetup.html)<br>
<br>
  create parent special database using SpecialSCdb build procedures (see above)<br>
