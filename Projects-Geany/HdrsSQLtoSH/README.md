README - HdrsSQLtoSH project documentation.<br>
9/27/22.     wmk.
###Modification History.
<pre><code>6/5/22.     wmk.   original document.
9/27/22.    wmk.   minor additions.
</code><pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
HdrsSQLtoSH mimics [AnySQLtoSH](file:///media/fuse/crostini_67db2e155275fc7e48975519462d5b22a040848a_termina_penguin/GitHub/TerritoriesCB/Projects-Geany/AnySQLtoSH/README.html), the primary difference being that it allows
each .sql to have associated .hd1 and .hd2 files that will serve as the
shell surrounding the generated "batched" .sql query.

< filename >.hd1 header looks just like hdrAnySQL_1.sh with mods specific to
setting up the SQL #procbodyhere section.
< filename >.hd2 header looks just likt hdrAnySQL_2.sh with mods specific to
closing out the SQL #endprocbody section.
