'//TerrHelp.bas - Help info for Territories.
'//---------------------------------------------------------------
'// TerrHelp -Help info for Territories.
'//		11/18/21.	wmk.
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
'// 11/18/21.	wmk.	original code for ReleaseData; adapted from
'//						code for Territories.
'//	1/14/21.	wmk.	original code
'// 7/15/21.	wmk.	help menu corrections to Ctrl-8 and Shft-F7;
'//						switch to & concatenation from +.
'//
'//	Notes. TerrKeys.cfg is stored on the ~/TerrData path and has the
'// following keys defined:
'//	
'//		Ctrl-6 - invokes SetGridLand macro to prompt user for setting
'//		Shft-F7 - this menu
'//

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler
	msgBox ("Hotkeys are stored in the file ReleaseTerr.cfg on the path"_
	 &chr(13)&chr(10) & "~/Territories/ReleaseData" & chr(13)&chr(10)_
	 & "and may be loaded from Tools/Customize/Keyboard..." &chr(13)&chr(10)_
	 &chr(13)&chr(10) & "     Ctrl-6      Set Page Grid and Landscape controls"_
	 +chr(13)+chr(10) + "     Ctrl-8      Export sheet to PDF file"_
	 &chr(13)&chr(10) & "     Shift-F7    This Help menu" &chr(13)&chr(10),_
	  0, "Territories Help")

'// legacy code.
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
	
end sub		'// end TerrHelp	11/18/21.
