'// CenterUnitHstead3.bas
'//---------------------------------------------------------------
'// CenterUnitHstead3 - Center Unit and Homestead columns in PubTerr sheet.
'//		2/19/21.	wmk.
'//---------------------------------------------------------------

public sub CenterUnitHstead3()

'//	Usage.	macro call or
'//			call CenterUnitHstead3()
'//
'// Entry.	_PubTerr formatted sheet selected
'//			COL_C is homestead
'//			COL B is unit
'//
'//	Exit.	Unit and Homestead columns centered
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	2/19/21.	wmk.	original code; cloned from CenterUnitHstead2
'//
'//	Notes. Support for new format simplified Pub_Terr sheet.
'//

'//	constants.
const COL_A=0
const COL_B=1
const COL_C=2
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
	oCols(COL_C).setPropertyValue("HoriJustify", CJUST)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CenterUnitHstead3 - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CenterUnitHstead3
