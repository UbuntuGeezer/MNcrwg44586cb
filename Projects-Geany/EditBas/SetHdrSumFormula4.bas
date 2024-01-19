'// SetHdrSumFormula4.bas
'//---------------------------------------------------------------
'// SetHdrSumFormula4 - Set header sum formula in Territory sheet.
'//		3/321.	wmk.	19:37
'//---------------------------------------------------------------

public sub SetHdrSumFormula4()

'//	Usage.	macro call or
'//			call SetHdrSumFormul3()
'//
'// Entry.	user has territory sheet selected
'//
'//	Exit.	cell B2 set to "='Record count: ' &amp; COUNTA($B$6:$B$1299)"
'//			formula at A2 cleared
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	3/3/21.		wmk.	original code; adapted from SetHdrSumFormula3
'//
'//	Notes. The formula is in the B column since that is where the unitaddress
'// is placed for the Edit sheet. It is used by GenFLinkM in generating
'// fastpeoplesearch links.

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

	oCell = oSheet.getCellByPosition(COL_A, ROW_2)
	oCell.setFormula ("")	
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	oCell.setFormula("=""RecordCount: "" &amp; COUNTA($B$6:$B$1299)")
	oCell.HoriJustify = CJUST
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetHdrSumFormula4 - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetHdrSumFormula4	3/3/21/	23:08
