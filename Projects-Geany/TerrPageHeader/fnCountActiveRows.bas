'// fnCountActiveRows.bas
'//---------------------------------------------------------------
'// fnCountActiveRows - Count active rows containing data.
'//		11/23/21.	wmk.	13:17
'//---------------------------------------------------------------

public function fnCountActiveRows(poDoc As Object) As Integer

'//	Usage.	macro call or
'//			call fnCountActiveRows()
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
'// 11/20/21.	wmk.	original code.
'// 11/22/21.	wmk.	bug fix; sheet index corrected from 0 to 1.
'// 11/23/21.	wmk.	bug fix; start at A5 since increments first.
'//
'//	Notes. fnCountActiveRows will loop starting at $A$6 until a row is 
'// found with no data in column A. A6 is assumed non-empty

'// local variables.
dim nRetValue	As Integer		'// returned value
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
	nRetValue = 0
'	oDoc = ThisComponent
	oDoc = poDoc
'	MoveToDocSheet(oDoc, "Terr235_PubTerr")
	oSheet = oDoc.Sheets(1)
	bMoreRows = true
	nActiveRows = 0
	lThisRow = 4		'// current row index at A5
	do while bMoreRows
		lThisRow = lThisRow + 1
		oCell = oSheet.getCellByPosition(0, lThisRow)
		bMoreRows = (len(oCell.String) > 0)
		if bMoreRows then
			nActiveRows = nActiveRows + 1
		endif	'// end next row has data conditional
	loop

if 1 = 0 then
	'// move to cell $A$6
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$A$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	if nActiveRows > 0 then
	dim args2(0) as new com.sun.star.beans.PropertyValue
		args2(0).Name = "By"
		args2(0).Value = nActiveRows
		oDispatcher.executeDispatch(oDocument, ".uno:GoDownSel", "", 0, args2())
	endif
endif
Skip2:
	nRetValue = nActiveRows
	fnCountActiveRows = nRetValue
	
NormalExit:
	exit function

ErrorHandler:
	msgbox("fnCountActiveRows - unprocessed error")
	GoTo NormalExit
	
end function		'// end fnCountActiveRows	11/23/21.	13:17
