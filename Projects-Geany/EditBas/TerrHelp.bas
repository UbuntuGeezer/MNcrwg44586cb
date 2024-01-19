'// TerrHelp.bas
'//---------------------------------------------------------------
'// TerrHelp -Help info for Territories.
'//		7/15/21.	wmk. 06:26
'//---------------------------------------------------------------

public sub TerrHelp()

'//	Usage.	macro call or
'//			call TerrHelp()
'//
'// Entry.	User invoked macro or hit Shift-F7 for help with TerrKeys.cfg
'// 		active
'//
'//	Exit.	Help msgbox displayed.
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	1/14/21.	wmk.	original code
'// 7/15/21.	wmk.	help menu corrections to Ctrl-8 and Shft-F7;
'//						switch to &amp; concatenation from +.
'//
'//	Notes. TerrKeys.cfg is stored on the ~/TerrData path and has the
'// following keys defined:
'//	
'//		Ctrl-4 - invokes macro to generate PubTerr sheets from query	
'//		Ctrl-6 - invokes SetGridLand macro to prompt user for setting
'//				 Page format controls Grid:Yes and Landscape:Yes
'//		Ctrl-7 - invokes SaveToXlsx macro to save current sheet in
'//				 .xlsx format
'//		Ctrl-8 - invokes ExportAsPDF macro to export current sheet
'//				 as a PDF	
'//		Shft-F7 - this menu
'//

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler
	msgBox ("Hotkeys are stored in the file TerrKeys.cfg on the path"_
	 &amp;chr(13)&amp;chr(10) &amp; "~/Territories/TerrData" &amp; chr(13)&amp;chr(10)_
	 &amp; "and may be loaded from Tools/Customize/Keyboard..." &amp;chr(13)&amp;chr(10)_
	 &amp;chr(13)&amp;chr(10) &amp; "     Ctrl-4      Generate territory sheets from query"_
	 &amp;chr(13)&amp;chr(10) &amp; "     Ctrl-6      Set Page Grid and Landscape controls"_
	 &amp;chr(13)&amp;chr(10) &amp; "     Ctrl-7      Save sheet to .xlsx file"_
	 &amp;chr(13)&amp;chr(10) &amp; "     Ctrl-8      Export sheet to PDF file"_
	 &amp;chr(13)&amp;chr(10) &amp; "     Shift-F7    This Help menu" &amp;chr(13)&amp;chr(10),_
	  0, "Territories Help")
if 1 = 0 then
	msgBox ("Hotkeys are stored in the file TerrKeys.cfg on the path"_
	 +chr(13)+chr(10) + "~/Territories/TerrData" + chr(13)+chr(10)_
	 + "and may be loaded from Tools/Customize/Keyboard..." +chr(13)+chr(10)_
	 +chr(13)+chr(10) + "     Ctrl-6      Set Page Grid and Landscape controls"_
	 +chr(13)+chr(10) + "     Ctrl-7      Save sheet to .xlsx file"_
	 +chr(13)+chr(10) + "     Ctrl-8      Export sheet to PDF file"_
	 +chr(13)+chr(10) + "Shift-F7    Help" +chr(13)+chr(10),_
	  0, "Territories Help")
endif

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("TerrHelp - unprocessed error")
	GoTo NormalExit
	
end sub		'// end TerrHelp	7/15/21.	06:26
