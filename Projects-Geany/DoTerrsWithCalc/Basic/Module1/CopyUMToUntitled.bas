'// CopyUMToUntitled.bas
'//---------------------------------------------------------------
'// CopyUMToUntitled - Copy UpdateMaster sheet to new workbook.
'//		7/15/21.	wmk.
'//---------------------------------------------------------------

sub CopyUMToUntitled()

'//	Usage.	macro call or
'//			call CopyUMToUntitled()
'//
'//		sDocName = name of new workbook
'//
'// Entry.	user has UpdateMaster sheet selected that will be copied to new workbook
'//
'//	Exit.	selected sheet copied into "Untitled n"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/15/21.	wmk.	original code.
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
args1(0).Value = ""
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CopyUMToUntitled - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CopyUMToUntitled	'// 7/15/21.	21:01
'/**/
