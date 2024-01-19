'// RenameSheet.bas
'//---------------------------------------------------------------
'// RenameSheet - Rename sheet with new name.
'//		10/12/20.	wmk.		13:00
'//---------------------------------------------------------------

public sub RenameSheet( psNewName As String )

'//	Usage.	macro call or
'//			call RenameSheet(sNewName As String)
'//
'//		sNewName = new sheet name
'//
'// Entry.	ThisComponent = this XFrame object
'//
'//	Exit.	table name changed to psNewName
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

	'// code.
	ON ERROR GOTO ErrorHandler

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Name"
'args1(0).Value = "Terr102_Import"
args1(0).Value = psNewName

dispatcher.executeDispatch(document, ".uno:RenameTable", "", 0, args1())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("RenameSheet - unprocessed error")
	GoTo NormalExit
	
end sub		'// end RenameSheet		10/12/20
