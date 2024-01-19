'// CopyTerrRecsToHdr.bas
'//---------------------------------------------------------------
'// CopyTerrRecsToHdr - Copy territory records to Zip code header sheet.
'//		5/12/22.	wmk.	20:53
'//---------------------------------------------------------------

public sub CopyTerrRecsToHdr( poDoc As Object, psZipCode As String)

'//	Usage.	macro call or
'//			call CopyTerrRecsToHdr(oDoc As Object, sZipCode As String)
'//
'//		oDoc = PubTerr sheet object
'//		sZipCode = (ignored) zip code of header sheet to copy to.
'//
'// Entry.	User in PubTerr sheet
'//			TerrHdr<sZipCode> sheet present in current workbook
'//			
'//	Exit.	cells $A$1 - $I$n copied from current sheet into
'//			  sheet TerrHdr<sZipCode> sheet
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/19/21.	wmk.	original code.
'// 11/21/21.	wmk.	fix to copy all rows, including 5 headings rows;
'//						source changed to sheet index 1, target to index 0.
'//	11/22/21.	wmk.	UNO code section added to eventually replace the
'//						block copy code.
'// 11/23/21.	wmk.	changed row count to add 5 instead of add 4.
'//
'//	Notes. <Insert notes here>
'//

'//	constants.

const COL_I = 8


'//	local variables.
dim nCopyRows	As Integer		'// count of rows to copy

	'// code.
	ON ERROR GOTO ErrorHandler

if 1 = 0 then
'//================================================================
'// Copy cell range.
Dim oDoc As Object
Dim oSheet As Object
dim oSel	As Object
Dim oCellRangeAddress As New com.sun.star.table.CellRangeAddress
Dim oCellAddress As New com.sun.star.table.CellAddress
dim oTargetRange	As Object
'dim oSourceRange	As Object

	oDoc = poDoc
'	oDoc = ThisComponent
	oSheet = oDoc.Sheets(1)
dim oSheet1	As Object
	oSheet1 = poDoc.Sheets(0)
	nCopyRows = fnCountActiveRows(oDoc)

'// Select active rows.
'	nCopyRows = fnCountActiveRows()
'	SelectActiveRows()
	nCopyRows = fnCountActiveRows(oDoc)
	oSel = 0
Dim oSourceRange As New com.sun.star.table.CellRangeAddress
'	oSourceRange = oSel.RangeAddress
	oSourceRange.Sheet = 1		'// assume sheet 1 for now..
	oSourceRange.StartRow = 0
	oSourceRange.StartColumn = 0
	oSourceRange.EndRow = nCopyRows + 4
	oSourceRange.EndColumn = COL_I

'// always target copy Sheet 1, Column 0, Row 5
oCellAddress.Sheet = 0
oCellAddress.Column = 0
oCellAddress.Row = 0

'CellRangeAddress.Sheet = 0
'CellRangeAddress.StartColumn = 1
'CellRangeAddress.StartRow = 1
'CellRangeAddress.EndColumn = 2
'CellRangeAddress.EndRow = 2

'CellAddress.Sheet = 0
'CellAddress.Column = 0
'CellAddress.Row = 5

oSheet.copyRange(oCellAddress, oSourceRange)
'//===============================================================
endif

if 1 = 1 then
	nCopyRows = fnCountActiveRows(poDoc)
'//'******************************************************************
'
dim oDocument 	As Object
dim oDispatcher	As Object
oDocument = poDoc.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args51(0) as new com.sun.star.beans.PropertyValue
args51(0).Name = "Nr"
args51(0).Value = 2

oDispatcher.executeDispatch(oDocument, ".uno:JumpToTable", "", 0, args51())

	'// move to cell $A$6
	dim args3(0) as new com.sun.star.beans.PropertyValue
	args3(0).Name = "ToPoint"
	args3(0).Value = "$A$1"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args3())

	if nCopyRows > 0 then
	dim args4(0) as new com.sun.star.beans.PropertyValue
		args4(0).Name = "By"
		args4(0).Value = nCopyRows + 5
		oDispatcher.executeDispatch(oDocument, ".uno:GoDownSel", "", 0, args4())
	endif
	
rem ----------------------------------------------------------------------
dim args5(0) as new com.sun.star.beans.PropertyValue
args5(0).Name = "By"
args5(0).Value = 7

oDispatcher.executeDispatch(oDocument, ".uno:GoRightSel", "", 0, args5())

rem ----------------------------------------------------------------------
oDispatcher.executeDispatch(oDocument, ".uno:Copy", "", 0, Array())

rem ----------------------------------------------------------------------
dim args16(0) as new com.sun.star.beans.PropertyValue
args16(0).Name = "Nr"
args16(0).Value = 1

oDispatcher.executeDispatch(oDocument, ".uno:JumpToTable", "", 0, args16())

rem ----------------------------------------------------------------------
dim args17(0) as new com.sun.star.beans.PropertyValue
args17(0).Name = "ToPoint"
args17(0).Value = "$A$1"

oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args17())

rem ----------------------------------------------------------------------
oDispatcher.executeDispatch(oDocument, ".uno:Paste", "", 0, Array())

'//**************************************************************
endif
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CopyTerrRecsToHdr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CopyTerrRecsToHdr	5/12/22.
'/**/
