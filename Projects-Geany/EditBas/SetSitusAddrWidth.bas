'// SetSitusAddrWidth.bas
'//---------------------------------------------------------------
'// SetSitusAddrWidth - Set column width on situs address column.
'//		9/17/20.	wmk.	09:30
'//---------------------------------------------------------------

public sub SetSitusAddrWidth()

'//	Usage.	macro call or
'//			call SetSitusAddrWidth()
'//
'// Entry.	User in RefUSA/Admin formatted territory sheet
'//
'//	Exit.	column B width set to 1.75" (4445)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/17/20.	wmk.	original code; adapted from SetUnitAddrWidth
'//
'//	Notes.


'//	constants.
const ONE_INCH=2540
const COL_N=13
const N_WIDTH=1.75

'//	local variables.
dim oDocument   as object
dim oDispatcher as object
dim oDoc	As Object	'// ThisComponent
dim oSel	As Object	'// current selection
dim oRange	As Object	'// RangeAddress from selection
dim iSheetIx	As Integer	'// current sheet index
dim oSheet	As Object	'// current sheet
dim oCols	As Object	'// .Columns current sheet

	'// code.
	ON ERROR GOTO ErrorHandler
	'// preserve current selection
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns
	oCols(COL_N).setPropertyValue("Width", N_WIDTH*ONE_INCH)

NormalExit:
	SetSelection(oRange)	'// restore range selected
	exit sub
	
ErrorHandler:
	msgbox("SetSitusAddrWidth - unprocessed error.")
	
end sub		'// end SetSitusAddrWidth	9/11/20
