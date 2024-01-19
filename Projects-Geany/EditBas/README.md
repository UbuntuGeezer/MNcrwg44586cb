README.md - EditBas project documentation.<br>
	3/9/22.	wmk.
##Modification History.
<pre><code>3/7/22.     wmk.   original document.
3/8/22.     wmk.   Supporting Files section added.
3/9/22.		wmk.	Make changed to Extract XBA Code.
</code></pre>
##Document Sections.
<pre><code>Project Description - overall project description.
Setup - step-by-step instructions for various builds done by project.
Supporting Files - files integrated with project processes.
</code></pre>
##Project Description.
The EditBas project provides tools for editing an integrating .bas code
modules into the Territories Calc library. A utility uses *awk* to extract
modules from the current library. It uses *sed* to replace modules within
the Territories library. It prompts the user to use *Calc* to update the
Territories library in the *GitHub/Libraries Project* folder. It uses
*make* to  perform the above operations.

EditBas depends upon minimal special formatting of each subroutine/function
within the Calc library. Each module (subroutine/function) should be preceded
by a line containing *'// modulename.bas*. Each module should
be followed by a line containing *'/\*\*/*. These lines delimit the subroutine/function
to allow extraction, replacement or deletion of the module.

The project flow follows these logical steps:
<pre><code>    Use Calc to Export the current Territories library to GitHub/Territories

    1. run *GetXBAModule.sh* shell from project to make a working copy of the
     current code module from GitHub/Territories in the project folder
    
    2. *make* MakeExtractBas to extract the subroutine/function from the local
     copy of the .xba file; the extracted code will be in <procname>.bas
     in the project folder (<procname> is the sub/function name).
    
    3. run CopyXBAoverBAS.sh to update the /Basic folder version of
     <procname>.bas with the current running library code. This will serve
     as a backup if you need to revert the changes.
      
    4. edit the source code in <procname>.bas to make the desired changes
      or
     *make* MakeDeleteXBAbas to remove the <procname> from the local
      .xba file. **Note:** If you delete a <procname> from the local
      .xba and want to note this as a permanent change, it would be wise
      to make a notation in the /Basic/<procname>.bas that this code
      has been removed from the running library.
     
    when your editing is complete:
    5. *make* MakeReplaceBas to replace the old <procname> code with the
      edited <procname> code in the local .xba file
     
     repeat steps 2 - 5 for all <procname>,s you desire to modify.
</code>/<pre>    
To test all the new code added above, the Territories library in the running
Calc system will need to be replaced. This involves several steps:
<pre><code>    1. Replace the existing .xba for the module in the GitHub/Libraries-Project/Territories
  folder. Use the *PutXBAModule.sh* project shell to accomplish this. This shell
  automatically cycles the previous .xba module to a file named *old<modulename>.xba*
  where <modulename> is the original module filename (e.g. Module1).

    2.Use Calc to reload the Territories library from GitHub into the running
     system. The Organizer has an Import function to do this; be sure to
     check the "Replace existing libraries" checkbox to ensure that the
     GitHub version replaces the current running Territories version.
    
    3. Test your changed <procnames> with the appropriate Territory activities
     that will exercise the new code.
    
    If you are satisfied with all of your changes, update the /Basic folder
    with all of the changed .bas files:
    
    4. run UpdateBasicFiles.sh to update all of the .bas files in /Basic that
     have been changed in the project folder. This will also remove the .bas
     files from the project folder, allowing fresh extracts to obtain more
     <procfile> source without the clutter of old code.
     
     If you are not satisfied with all of your changes... you're on your own.. 
</code></pre>
##Setup.
There are several setups for the EditBas project.

**Setup for ExtractBas.**
<pre><code>Build Menu:
	ensure the .xba in GitHub/Libraries-Project/Territories is current by
	 using Calc>Tools>Macros>Organize Macros>Basic>[Organizer][Libraries]>Territories[Export](*)Export as Basic Library
	 to export the Territories .xba files to GitHub/Libraries-Project (this 
	 will automatically overwrite the Territories folder under /Libraries-Project)
	 
    copy the appropriate .xba from GitHub/Libraries-Project/Territories to
     the project folder (e.g. Module1.xba) by using the GetXBAModule.sh
     shell file
     
	edit 'sed' command parameters with basmodule and *bafile* parameters
	run *sed* from the Build Menu
	run *Extract XBA Code* from the Build Menu to extract the source to a .bas file
</code></pre>
The file \<basmodule>.bas in the project is the stripped .bas source for
the module. It can be replaced over the appropriate /Basic/\<basmodule>.bas
file to freshen the Basic source image to match the current Territories
library module. Use *CopyXBAoverBAS.sh* to do the copy.
##Supporting Files.
<pre><code>CopyXBAoverBAS.sh - shell to copy extracted XBA module.bas file over
 existing /Basic/module.bas file.

GetXBAModule.sh - shell to copy XBA module from GitHub/Territories folder
 to project folder; typically done to extract current source from tracked
 .xba library file.
 
 DoSed.sh - shell to edit *basmodule* and *bafile* into .tmp makefiles
  for project.

MakeExtractBas.tmp - makefile template for extraction builds.

ModuleHdr.xba - (read-only) XML module header lines for use when replacing
  module into <xmafile>.

scratch.xba - intermediate .xba file used when replacing module into
  <xmafile>.
</code></pre>
