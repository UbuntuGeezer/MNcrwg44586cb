'// SelActiveSrchRows.bas
'//---------------------------------------------------------------
'// SelActiveSrchRows - Select active Search rows containing data.
'//		3/14/21.	wmk.	13:35
'//---------------------------------------------------------------

public sub SelActiveSrchRows()

'//	Usage.	macro call or
'//			call SelActiveSrchRows()
'//
'// Entry.	user in a spreadsheet with data in column "A", starting
'//			in cell $A$6
'//
'//	Exit.	cells $A$6 througn $A$n selected as though user highlighted
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'// 3/14/21.	wmk.	original code; adapted from SelectActiveRows;
'//						modified to get row count from colunn B
'//
'//	Notes. SelActiveSrchRows will loop starting at $B$6 until a row is 
'// found with no data in column B. B6 is assumed non-empty

'// local variables.
dim oDocument   as object
dim oDispatcher as object

Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet
dim oCell		As Object		'// current scan cell
dim bMoreRows	As Boolean
dim nActiveRows	As Integer	'// active row counter

'//	code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

if true then
  GoTo Skip1
endif
	'// loop looking ahead and advancing until empty cell found
'	dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "By"
	args2(0).Value = 1
Skip1:

	bMoreRows = true
	nActiveRows = 0
	lThisRow = 5		'// current row index at A6
	do while bMoreRows
		lThisRow = lThisRow + 1
		oCell = oSheet.getCellByPosition(1, lThisRow)
		bMoreRows = (len(oCell.String) &gt; 0)
		if bMoreRows then
			nActiveRows = nActiveRows + 1
		endif	'// end next row has data conditional
	loop


	'// move to cell $A$6
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$A$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	if nActiveRows &gt; 0 then
	dim args2(0) as new com.sun.star.beans.PropertyValue
		args2(0).Name = "By"
		args2(0).Value = nActiveRows
		oDispatcher.executeDispatch(oDocument, ".uno:GoDownSel", "", 0, args2())
	endif
Skip2:

NormalExit:
	exit sub

ErrorHandler:
	msgbox("SelActiveSrchRows - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SelActiveSrchRows	3/14/21.	13:35
