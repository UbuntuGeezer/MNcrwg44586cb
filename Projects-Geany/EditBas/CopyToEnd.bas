'// CopyToEnd.bas
'//---------------------------------------------------------------
'// CopyToEnd - Copy currently selected sheet to end of workbook.
'//		10/15/20.	wmk.
'//---------------------------------------------------------------

public sub CopyToEnd()

'//	Usage.	macro call or
'//			call CopyToEnd()
'//
'// Entry.	user has worksheet selected
'//
'//	Exit.	copy of worksheet made to end of workbook, automatic
'//			naming
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/12/20.	wmk.	original code; cloned from macro recording
'//	10/15/20.	wmk.	bug fix; code was welded to "Terr102"
'//
'//	Notes.
'//

'//	constants.

'//	local variables.
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

dim oDoc		As Object
dim sTitle		As String
dim sDocName	As String

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	sTitle = oDoc.getTitle()
	sDocName = left(sTitle,len(sTitle)-4)		

rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
args1(0).Value = sDocName
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CopyToEnd - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CopyToEnd		10/15/20
