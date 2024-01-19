'// ForceRecalc.bas
'//---------------------------------------------------------------
'// ForceRecalc - Force calculation on sheet.
'//		9/8/20.	wmk.
'//---------------------------------------------------------------

public sub ForceRecalc()

'//	Usage.	macro call or
'//			call ForceRecalc()
'//
'// Entry.	user selection is in Admin-Edit sheet
'//
'//	Exit.	sheet is recalculated; all HYPERLINK fields should read
'//			"click to search"
'//
'//
'//	Modification history.
'//	---------------------
'//	9/8/20.		wmk.	original code; stolen from macro recording
'//
'//	Notes. Autocalc is turned off in territories, since there may be
'// literally thousands of HYPERLINKs in the larger sheets. After
'// the hyplerlinks for search fields are set (GenELinkM), ForceRecalc
'//	will be called to update the hyperlinks so they read "Click to search"

'//	constants.

'//	local variables.
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
	document   = ThisComponent.CurrentController.Frame
	dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	dispatcher.executeDispatch(document, ".uno:Calculate", "", 0, Array())

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("ForceRecalc - unprocessed error.")
	GoTo NormalExit

end sub		'// end ForceRecalc		9/8/20
