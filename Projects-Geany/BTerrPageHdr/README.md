README - BTerrPageHdr project documentation.<br>
5/12/22.	wmk.
	
##Modification History.
<pre><code>5/12/22.   wmk.   original document.
</code></pre>

##Document Sections.
<pre><code>Project Description - overall project description.
Method - project build overview.
Dependencies - file and other dependencies.
Significant Notes - important stuff not documented elsewhere.
</code></pre>


##Project Description.
The BTerrPageHsdr project facilitates adding page header information to
the business territory sheets. This feature will place page headings on 
each page when a spreadsheet is printed. The page headings will contain
the territory area name, and column headings for readability.

##Method.
BTerrPageHdr creates a shell file within its project folder that
can take a given business territory and add header information to its spreadsheet.

The header worksheet (by zip code) will be copied to a new
workbook. Then all the rows from the business territory will be copied
into the workboook. ??The original business territory workbook will be saved
under the new name Terrxxx_PubTerr_.xlsx. Then the new workbook will be
saved under the original name Terrxxx_PubTerr.xlsx.

##Dependencies.
BizPageHdr.ods - empty sheet with page header for all business territories.

AddBizTerrHdr.ods - Spreadsheet with internal macros to add header to
 territory spreadsheet. All runs are considered "batch" runs using the
 first sheet in the workbook as a list of territories for which to add
 headers to Terrxxx_SuperTerr.xlsx, Terrxxx_PubTerr.xlsx, and
 Terrxxx_PubTerr.pdf.


##Significant Notes.
TerrPageHeader was initially implemented under Libre Office 6.4.6. When
the ChromeBook computer was obtained, the chromeos installed Libre Office
7.2.4. AddPubTerrHdr.ods macros would hang when attempting to load and
copy the zip code header .ods into the territory sheet. Upon investigation
the "Headers and Footers" menu item under "Insert" was visible, but disabled.

Version 7.2.4 was then uninstalled and the .deb for version 7.1.7.2 was
downloaded and installed. The "Headers and Footers" menu item is enabled
in this version. Hopefully this avoids AddBizTerrHdr.ods macro
hanging issues.

The current "production" system is still running libreoffice 6.4.6.2.

There is a mysterious issue with AddPubTerrHdr.ods processing of territories.
Sometimes the *run* hangs, apparently waiting for input, but without a prompt
window being displayed. The situation seems to be improved by making sure that
the calc *Window* menu item focus matches the shortcut bar *Calc* Window dropdown,
but it does not always resolve the issue. When the hang happens do the following:
<pre><code>		Enter/start a Terminal session

	enter the *psfind* shortcut; this will start the PSFIND utility that will
	 allow searching the active jobs in the system

	press the "enter" key at the first prompt

	at the ":" prompt type "/calc"

	when the displayed jobs list appears make note of the session ID of the
	 job immediately preceding the *psfind* job (e.g. 21984)

	type "Q" to exit psfind

	enter the command "kill <jobid>" at the Terminal command prompt; this will
	 kill the hung calc session

	Use the session control with the time displayed at the lower right corner of
	 the applications window by clicking on the *time*, then select *sign out*
	 from the session control window to sigh out

	log back in when the *login* prompts appear and select *recover apps*

	restart calc and allow calc *recovery* to recover the files

	close the PageHdr342xx.ods file window

	attempt to rerun the AddPubTerrHdr.Main1 function
</code></pre>

