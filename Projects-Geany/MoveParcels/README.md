README - MoveParcels project documentation.<br>
1/15/23.	wmk.
###Modification History.
<pre><code>1/15/23.    wmk.   original document.
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Dependencies - project dependencies.
<a href="#3.0">link</a> 3.0 Project Build - step-by-step build instructions.
<a href="#4.0">link</a> 4.0 Significant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
MoveParcels is a utility project that facilitates moving parcels from one territory
to another. This will allow the database administrator to reorganize territories
by shifting parcels among existing territories. It will also allow the administrator
to create "temporary" territories that contain parcels not currently in the
exiting publisher territories with the goal of assigning them to new or existing
territories. This is particularly useful for gated communities being built
within the congregation territory boundaries that will likely be their own
territories once residences are completed.
<a href="#IX">Index</a>
<h3 id="2.0">2.0 Dependencies.</h3>
Both the source and target territories must be defined within the data segment
of the Territories subsystem. If the target territory is a "new" territory
the projects 
[SCNewTerritory](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/SCNewTerritory/README.html) 
and [RUNewTerritory](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/RUNewTerritory/README.html) 
should be used to create the new territory definition prior to using the *MoveParcels* project.

It may be necessary to update the DB-Dev/TerrIDData.db definition(s) of both the
source and target territories when performing the *MoveParcels* operation. This
will ensure accuracy of the publisher territory headers when they are produced.
<br><a href="#IX">Index</a>
<h3 id="3.0">3.0 Project Build.</h3>
<a href="#IX">Index</a>
<h3 id="4.0">4.0 Significant Notes.</h3>
<a href="#IX">Index</a>
