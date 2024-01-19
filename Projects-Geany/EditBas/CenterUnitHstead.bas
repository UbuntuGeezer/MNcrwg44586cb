'// CenterUnitHstead.bas
'//---------------------------------------------------------------
'// CenterUnitHstead - Center Unit and Homestead columns in PubTerr sheet.
'//		1/1/21.	wmk.
'//---------------------------------------------------------------

public sub CenterUnitHstead()

'//	Usage.	macro call or
'//			call CenterUnitHstead()
'//
'//
'// Entry.	_PubTerr formatted sheet selected
'//
'//	Exit.	Unit and Homestead columns centered
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	1/14/21.		wmk.	original code
'//
'//	Notes. &lt;Insert notes here&gt;
'//

'//	constants.
const COL_B=1
const COL_E=4
const CJUST=2		'// center justify

'//	local variables.
dim oDoc		As Object		'// ThisComponent
dim oSel		As Object
dim oRange		As Object
dim iSheetIx	As Integer
dim oSheet		As Object
dim oCols		AS Object

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns
	oCols(COL_B).setPropertyValue("HoriJustify", CJUST)
	oCols(COL_E).setPropertyValue("HoriJustify", CJUST)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CenterUnitHstead - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CenterUnitHstead
