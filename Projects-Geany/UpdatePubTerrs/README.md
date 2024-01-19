README.md - UpdatePubTerrs project documentation.<br>
2/1/23.	wmk.
###Modification History.
<pre><code>2/1/23.    wmk.   original document.
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Dependencies - project dependencies.
<a href="#3.0">link</a> 3.0 Project Build - step-by-step build instructions.
<a href="#4.0">link</a> 4.0 Significant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
UpdatePubTerrs updates publisher territories that are out-of-date. A territory
xxx is considered out-of-date if TerrData/Terrxxx/Working-Files/QTerrxxx.ods
is newer than TerrData/Terrxxx/PubTerrxxx.ods.
<a href="#IX">Index</a>
<h3 id="2.0">2.0 Dependencies.</h3>
UpdatePubTerrs depends upon the spreadsheet ProcessQTerrs12.ods which is
part of the
[DoTerrsWithCalc](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/DoTerrsWithCalc/README.html)
project. The ProcessQTerrs.ods spreadsheet invokes macros to process a list of
territories from the first sheet in the workbook. UpdatePubTerrs generates
a .csv file that is manually placed in the first sheet of ProcessQTerrs.ods.
The user then runs the MAIN1 macro to process the list.
<h3 id="3.0">3.0 Project Build.</h3>
<h3 id="4.0">4.0 Significant Notes.</h3>
