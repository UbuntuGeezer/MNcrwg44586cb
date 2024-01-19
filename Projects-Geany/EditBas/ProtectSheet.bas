'// ProtectSheet.bas
'//---------------------------------------------------------------
'// ProtectSheet - Protect current sheet from input.
'//		10/12/20.	wmk.
'//---------------------------------------------------------------

public sub ProtectSheet()

'//	Usage.	macro call or
'//			call ProtectSheet()
'//
'// Entry.	user has sheet selected
'//
'//	Exit.	sheet "protected" from input/changes
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/12/20.		wmk.	original code; from macro recording
'//
'//	Notes.

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
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Protect"
args1(0).Value = true

dispatcher.executeDispatch(document, ".uno:Protect", "", 0, args1())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("ProtectSheet - unprocessed error")
	GoTo NormalExit
	
end sub		'// end ProtectSheet		10/12/20
