'// SetHdrSumFormula3.bas
'//---------------------------------------------------------------
'// SetHdrSumFormula3 - Set header sum formula in Territory sheet.
'//		3/321.	wmk.	19:37
'//---------------------------------------------------------------

public sub SetHdrSumFormula3()

'//	Usage.	macro call or
'//			call SetHdrSumFormul3()
'//
'// Entry.	user has territory sheet selected
'//
'//	Exit.	cell A2 set to "='Record count: ' &amp; COUNTA($A$6:$A$1299)"
'//			formula at A2 cleared
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'// 2/19/21.	wmk.	original code; cloned from SetHdrSumFormula2.
'// 2/27/21.	wmk.	mod back to set formula in B2, A2 cleared.
'//	3/3/21.		wmk.	mod back to set formula in A2 COUNTA($A:6..)
'//
'//	Notes. THe formula is in the A column since that is where the unitaddress
'// is placed for version 3 of the PubTerr sheet. It is used by
'// HltAddrBlocks to get the row count to process


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

	oCell = oSheet.getCellByPosition(COL_B, ROW_2)
	oCell.setFormula ("")	
	oCell =	oSheet.getCellByPosition(COL_A, ROW_2)
	oCell.setFormula("=""RecordCount: "" &amp; COUNTA($A$6:$A$1299)")
	oCell.HoriJustify = CJUST
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetHdrSumFormula3 - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetHdrSumFormula3	3/3/21/	19:37
