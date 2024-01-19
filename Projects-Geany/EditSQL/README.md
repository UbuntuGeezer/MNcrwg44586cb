README.md - EditSQL project documentation.<br>
	7/6/22.	wmk.
###Modification History.
<pre><code>7/6/22.     wmk.   original document; adapted from EditBas.
</code></pre>
<h3 id="IX">Document Sections.<h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#1.0">link</a> 2.0 Setup - step-by-step instructions for various builds done by project.
<a href="#1.0">link</a> 3.0 Supporting Files - files integrated with project processes.
</code></pre>
<h3 id="1.0">Project Description.</h3>
The EditSQL project provides tools for editing an integrating .sql code
modules into Territories .sql files.. A utility uses *awk* to extract
modules from the current file version. It uses *sed* to replace modules within
the current file version. It prompts the user to use either the *FixAnyRU*
or *AnySQLtoSH* to update any relevant .sh file that utilizes the .sql
code. It uses *make* to  perform the above operations.

EditSQL depends upon minimal special formatting of each .sql query module
within the .sql file. Each module should be preceded
by a line containing -- * modulename.sql*. Each module should
be followed by a line containing --/\*\*/*. These lines delimit the query
module to allow extraction, replacement or deletion of the module.

The project flow follows these logical steps:
<pre><code>    Change to the EditSQL project folder.

    1. run *GetSQLModule.sh* shell from project to make a working copy of the
     current code module from its parent folder.
    
    2. *make* MakeExtractSQL to extract the SQL module from the local
     copy of the .sql file; the extracted code will be in <procname>.sql
     in the project folder (<procname> is the module name).
    
    3. run CopySQLoverBak.sh to copy the source parent folder version of
     <procname>.bak with the current running .sql. This will serve
     as a backup if you need to revert the changes.
      
    4. edit the source code in <procname>.sql to make the desired changes
      or
     *make* MakeDeleteSQLsql to remove the <procname> from the local
      .sql file. **Note:** If you delete a <procname> from the local
      .sql and want to note this as a permanent change, it would be wise
      to make a notation in the /<parent>/<procname>.sql that this code
      has been removed.
     
    when your editing is complete:
    5. *make* MakeReplaceSQL to replace the old <procname> code with the
      edited <procname> code in the local .sql file
     
     repeat steps 2 - 5 for all <procname>,s you desire to modify.
</code>/</pre>    
To test all the new code added above, if it is part of a *.sh* shell, the shell
will need to be regenerated either with *FixAnyRU* or *AnySQLtoSH*, as appropriate.
<h3 id="2.0">2.0 Setup.</h3>
There are several setups for the EditSQL project.

**Setup for ExtractSQL.**
If the .sql file does not have '-- * <modname>.sql' and '--/**/' delimiting
the SQL module you wish to extract, run the PrepSQL.sh shell to add the
delimiting lines
<p>PrepSQL.sh  < modname > < srcfile >

<pre><code>Terminal Session:
    change to the EditSQL project
      cdj EditSQL
 
    copy the appropriate .sql from its parent folder to
     the project folder (e.g. Fix212RU.sql) by using the GetSQLModule.sh
     shell file

    use *sed* to edit the *make* files with the .sql module name and path
     ./DoSed.sh < modulename >  < sqlfile >  

	run *ExtractSQL* from the Build Menu to extract the source to an .sql file
</code></pre>
The file \<sqlmodule>.sql in the project is the stripped .sql source for
the module. It can be replaced over the appropriate /SQLic/\<sqlmodule>.sql
file to freshen the SQLic source image to match the current Territories
library module. Use *CopyXBAoverBAS.sh* to do the copy.
##Supporting Files.
<pre><code>CopyXBAoverBAS.sh - shell to copy extracted XBA module.sql file over
 existing /SQLic/module.sql file.

GetXBAModule.sh - shell to copy XBA module from GitHub/Territories folder
 to project folder; typically done to extract current source from tracked
 .xba library file.
 
 DoSed.sh - shell to edit *sqlmodule* and *bafile* into .tmp makefiles
  for project.

MakeExtractSQL.tmp - makefile template for extraction builds.

ModuleHdr.xba - (read-only) XML module header lines for use when replacing
  module into <xmafile>.

scratch.xba - intermediate .xba file used when replacing module into
  <xmafile>.
</code></pre>
