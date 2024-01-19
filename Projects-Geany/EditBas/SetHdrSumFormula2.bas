'// SetHdrSumFormula2.bas
'//---------------------------------------------------------------
'// SetHdrSumFormula2 - Set header sum formula in Territory sheet.
'//		2/14/21.	wmk.	15:55
'//---------------------------------------------------------------

public sub SetHdrSumFormula2()

'//	Usage.	macro call or
'//			call SetHdrSumFormul2a()
'//
'// Entry.	user has territory sheet selected
'//
'//	Exit.	cell B2 set to "='Record count: ' &amp; COUNTA($A$6:$A$1299)"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/21/20.		wmk.	original code
'// 2/14/21.	wmk.	mod to "Record count: " &amp; COUNTA($A$6:$A$1299)
'//
'//	Notes.


'//	constants.
const COL_A=0
const COL_B=1
const ROW_2=1
const CJUST=2

'//	local variables.
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet
dim oMrgRange	As Object	'// merge range

dim oCell	As Object		'// cell working on

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	oCell.setFormula("=""RecordCount: "" &amp; COUNTA($A$6:$A$1299)")
	oCell.HoriJustify = CJUST
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetHdrSumFormula2 - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetHdrSumFormula2	2/14/21
