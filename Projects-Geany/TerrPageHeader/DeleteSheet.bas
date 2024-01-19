'// DeleteSheet.bas
'//---------------------------------------------------------------
'// DeleteSheet - Delete sheet by index.
'//		11/25/21.	wmk.	08:51
'//---------------------------------------------------------------

public sub DeleteSheet( poDoc As Object, pnSheetIx As Integer )

'//	Usage.	macro call or
'//			call DeleteSheet(oDoc, nSheetIx)
'//
'//		oDoc = workbook object
'//		nSheetIx = workbook sheet index
'//
'// Entry.
'//
'//	Exit.	Current workbook Sheets(oDoc, nSheetIx) removed.
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/23/21.	wmk.	original code.
'// 11/25/21.	wmk.	UNO code conditioned out to avoid prompt.
'//
'//	Notes. passed sheet index is workbook sheet index; add 1 for UNO
'// .Frame index. Sheet to delete must have focus.
'//

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler

dim sSheetName As String
	sSheetName = poDoc.Sheets(pnSheetIx).Name
	poDoc.Sheets.removeByName(sSheetName)
	
if 1 = 0 then		
rem ----------------------------------------------------------------------
rem define variables
dim oDocument   as object
dim oDispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
oDocument   = poDoc.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Nr"
args1(0).Value = pnSheetIx + 1

oDispatcher.executeDispatch(oDocument, ".uno:JumpToTable", "", 0, args1())

rem ----------------------------------------------------------------------
oDispatcher.executeDispatch(oDocument, ".uno:Remove", "", 0, Array())
endif

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("DeleteSheet - unprocessed error")
	GoTo NormalExit
	

end sub		'//	DeleteSheet		11/25/21.	08:51
