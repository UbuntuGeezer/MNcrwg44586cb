ReleaseExtractionInstructions.md - Territory release extraction instructions.<br>
3/6/23.	wmk.

You will have received the following link via email:
https://drive.google.com/drive/folders/16EH9LsJ-Y84LUi4NuqgOZxpBWcavyHN6?usp=sharing
You have been given permission to access that GoogleDrive folder of
release files for 03-06-23. After reading these instructions, click on this
[link](https://drive.google.com/drive/folders/177S04hgcinaEvHPzwEAr7RXANGtnvCXU?usp=share_link)
<br>
and it will take you into that GoogleDrive folder.

Once in the GoogleDrive folder *Release\_03-06-23*, locate the title bar
immediately below the "Search In Drive* dialog box. It will look something
like "CongInfoExchange > Territories > Release\_03-06-23".. Right-click on
the "Release\_03-06-23" text. This will bring up the following drop-down
menu:
<pre><code>
	Open With
	New Folder
	----------
	Share
	Get Link
	Add shortcut to drive
	Move to
	Add to Starred
	Rename
	Change color
	Search within Release_03-06-23 folder
	---------
	Download
	---------
	Remove
</code></pre>
Left-click on "Download"
This will start a process labelled "Preparing Download" with the message
"Zipping 1 file". When the zipping process is complete, the window labelled
"Opening Release\_03-06-23.." will appear with the following options:
<pre><code>
 () Open with
 () Save file
 () Do this automatically...
</code></pre>
Select (*) Save file to save the zipped download file onto your local
hard drive. Then click { OK } to save the download to whatever path you
have specified for saving downloads in your browser.

The downloaded file will have a name like *Release\_03-06-23...zip*. Using
the FileManager app on your system, locate the .zip file in the download
folder and douple-click on the file name/icon. This will invoke the *unzip*
utility on your system allowing you to extract all of the .tar files within
the .zip file.

Once you have extracted the files, you can use the *tar* utility to extract
all of the individual territories. *tar* will be run from your "Terminal" app
(Linux systems) or your "Cmd" app (Windows systems). The *tar* command to
extract files is:
<pre><code>   tar extract -f Terr100-199.tar</code></pre>
Run this command from your downloads folder where you *unzipped* the files from
*Release\_03-06-23.zip*. (e.g. cd $HOME/Downloads prior to using the *tar*
command.) The above *tar* command will have extracted all
of the territory information for territories 100-199. Repeat the *tar*
command for all the .tar files to extract all of the territories.

One of the extracted files will be "BuildDates.xlsx". This is an Excel
spreadsheet with all of the build dates for each of the territories. This
list will give you the dates that each of the territories was built,
and some idea of which territories are oldest, perhaps needing to be
updated.

