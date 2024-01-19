'// UnprotectSheet.bas
'//----------------------------------------------------------------------
'// UnprotectSheet - Remove protection from selected sheet (no password).
'//		10/12/20.	wmk.
'//----------------------------------------------------------------------

public sub UnprotectSheet()

'//	Usage.	macro call or
'//			call UnprotectSheet()
'//
'//
'// Entry.	selected sheet "protected" (no password)
'//
'//	Exit.	selected sheet "unprotected"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/12/20.		wmk.	original code
'//
'//	Notes.
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
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Protect"
args1(0).Value = false

dispatcher.executeDispatch(document, ".uno:Protect", "", 0, args1())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("UnprotectSheet - unprocessed error")
	GoTo NormalExit
	
end sub		'// end UnprotectSheet		10/12/20
