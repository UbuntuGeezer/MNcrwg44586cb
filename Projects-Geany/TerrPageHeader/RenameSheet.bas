'// RenameSheet.bas
'//---------------------------------------------------------------
'// RenameSheet - Rename sheet in workbook.
'//		11/23/21.	wmk.	11:44
'//---------------------------------------------------------------

public sub RenameSheet( poDoc As Object, pnSheetIx As Integer, psSheetName As String )

'//	Usage.	macro call or
'//			call <sub-name>(oDoc, nSheetIx, sSheetName))
'//
'//		oDoc = workbook object
'//		nSheetIx = workbook sheet index
'//		sSheetName = new name for sheet
'//
'// Entry.	user focus on workbook having sheet to rename
'//
'//	Exit.	current workbook.Sheets(nSheetIx).Name set
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/23/21.		wmk.	original code.
'//
'//	Notes. passed sheet index is workbook sheet index; frame sheet index
'// is +1.
'//

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler
	
rem ----------------------------------------------------------------------
rem define variables
dim oDocument   as object
dim oDispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
oDocument   = poDoc.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Nr"
args1(0).Value = pnSheetIx + 1

oDispatcher.executeDispatch(oDocument, ".uno:JumpToTable", "", 0, args1())

rem ----------------------------------------------------------------------
dim args2(0) as new com.sun.star.beans.PropertyValue
args2(0).Name = "Name"
args2(0).Value = psSheetName

oDispatcher.executeDispatch(oDocument, ".uno:RenameTable", "", 0, args2())

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("RenameSheet - unprocessed error")
	GoTo NormalExit
	
end sub		'// end RenameSheet		11/23/21.	11:44
