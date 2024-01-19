'// SelectSrchSheetArea.bas - Select all rows/columns in sheet area for subsequent operation.
'//---------------------------------------------------------------
'// SelectSrchSheetArea - Select all rows/columns in Search sheet.
'//		3/14/21.	wmk.	13:40
'//---------------------------------------------------------------

public sub SelectSrchSheetArea()

'//	Usage.	macro call or
'//			call SelectSrchSheetArea()
'//
'//		&lt;parameters description&gt;
'//
'// Entry.	user in sheet where desire to select active rows area
'//
'//	Exit.	all full active rows columns A - S selected.
'//
'// Calls. SelActiveSrchRows.
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
	'// presort imported data
	SelActiveSrchRows()
	
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
	msgbox("SelectSheetArea - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SelectSrchSheetArea		3/14/21. 13:40
