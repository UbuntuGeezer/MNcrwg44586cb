'// SetGridLand.bas
'//---------------------------------------------------------------
'// SetGridLand - Send user to Page formatting dialog.
'//		1/14/21.	wmk.
'//---------------------------------------------------------------

public sub SetGridLand()

'//	Usage.	macro call or
'//			call SetGridLand()
'//
'//
'// Entry.	sheet selected
'//
'//	Exit.	selected sheet has page format Landscape and Grid ON
'//			assuming user updated with dialog interface
'//
'// Calls. UNO services
'//
'//	Modification history.
'//	---------------------
'//	1/14/21.		wmk.	original code
'//
'//	Notes. Hooked to hotkey ctrl-6 in TerrKeys.cfg
'//

'//	constants.

'//	local variables.
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dispatcher.executeDispatch(document, ".uno:PageFormatDialog", "", 0, Array())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetGridLand - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetGridLand		1/14/21
