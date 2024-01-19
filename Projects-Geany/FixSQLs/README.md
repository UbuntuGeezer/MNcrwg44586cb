README.md - FixSQLs project documentation.<br>
5/6/22.	wmk.
###Modification History.
<pre><code>5/6/22.     wmk.   original document.
5/30/22.    wmk.   links added.
</code></pre>
<h3 id="IX">Document Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Setup - FixSQLs shell usage.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
FixSQLs is a "reliability" project that goes through a folder's .sql files
and batch edits them to be consistent with all SQL queries for a given
Territory system. The most obvious is to ensure the SQL is using the
environment variable *pathbase* in all file referencing operations like
.open,.import.,.output and ATTACH. The single build uses *sed*, *awk* and
*cat* to modifify the .sql files in a specific folder (typically a territory
download or Geany project folder.

The project will also be used when creating new congregation Territory
systems. There are over 1,000 .sql queru files within a Territory system, many
of which have path dependencies on the *folderbase*, *basepath* and
*congterr* environment variables. Whenever these system-wide environment
variables are changed, the downstream SQL queries and shell files will be
affected. FixSQLs, especially the FixAllSQLs shell, facilitates rapidly
editing all affected SQL queries.<br>
<a href="#IX">Index</a>
<h3 id="2.0">2.0 Setup.</h3>
FixSQLs consists of "stand-alone" shells that fix .sql and .psq files.<br>
FixSQL.sh fixes a single file.
>Usage. bash FixSQL.sh < path > < file > [< extension >]
>> < path > = full file path (e.g. *pathbase*/Projects-Geany/BridgesToTerr)<br>
>> < file > = filename w/o extension (e.g. GetRecords)<br>
>> < extension > = (optional) filename extension [ .sql| .psq ]<br>
>>(   default is .sql)

FixAllSQLs.sh fixes all .sql files in the < path ><br>
>Usage. bash FixAllSQL.sh < path >
>> < path > = full file path (e.g. *pathbase*/Projects-Geany/BridgesToTerr)<br>

FixAllPSQs.sh fixes all .psq files in the < path ><br>
>Usage. bash FixAllSQL.sh < path >
>> < path > = full file path (e.g. *pathbase*/Projects-Geany/BridgesToTerr)

<a href="#IX">Index</a>
