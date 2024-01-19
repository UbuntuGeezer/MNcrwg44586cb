'// SelPubSheetArea.bas - Select all rows/columns in PubTerr area.
'//---------------------------------------------------------------
'// SelPubSheetArea - Select all rows/columns in Search sheet.
'//		3/14/21.	wmk.	18:40
'//---------------------------------------------------------------

public sub SelPubSheetArea()

'//	Usage.	macro call or
'//			call SelPubSheetArea()
'//
'// Entry.	user in sheet where desire to select active rows area
'//
'//	Exit.	all full active rows columns A - S selected.
'//
'// Calls. SelectActiveRows.
'//
'//	Modification history.
'//	---------------------
'//	3/14/21.		wmk.	original code
'//
'//	Notes. 
'//

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler
	
	SelectActiveRows()
	
dim oDocument	As Object
dim oDispatcher	As Object
dim nColumns	As Integer
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	nColumns = ASC("S") - ASC("A")
dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "By"
	args2(0).Value = nColumns
oDispatcher.executeDispatch(oDocument, ".uno:GoRightSel", "", 0, args2())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SelPubSheetArea - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SelectPubSheetArea		3/14/21. 18:40
