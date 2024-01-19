'// CopyToUntitled.bas
'//---------------------------------------------------------------
'// CopyToUntitled - Copy selected sheet to new workbook.
'//		10/14/20.	wmk.
'//---------------------------------------------------------------

public sub CopyToUntitled()

'//	Usage.	macro call or
'//			call CopyToUntitled()
'//
'//		sDocName = name of new workbook
'//
'// Entry.	user has sheet selected that will be copied to new workbook
'//
'//	Exit.	selected sheet copied into "Untitled 1"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/14/20.	wmk.	original code.
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
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
args1(0).Value = "Untitled 2"
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CopyToUntitled - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CopyToUntitled	'// 3/14/21.	18:53
