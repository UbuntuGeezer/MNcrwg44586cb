'// SetHdrSumFormula.bas
'//---------------------------------------------------------------
'// SetHdrSumFormula - Set header sum formula in Territory sheet.
'//		9/21/20.	wmk.	05:50
'//---------------------------------------------------------------

public sub SetHdrSumFormula()

'//	Usage.	macro call or
'//			call SetHdrSumFormula()
'//
'// Entry.	user has territory sheet selected
'//
'//	Exit.	cell B2 set to "=$COUNTA($A$6:$A$1299)"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/21/20.		wmk.	original code
'//
'//	Notes.


'//	constants.
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
	oCell.setFormula("=COUNTA($A$6:$A$1299)")
	oCell.HoriJustify = CJUST
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetHdrSumFormula - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetHdrSumFormula	9/21/20
