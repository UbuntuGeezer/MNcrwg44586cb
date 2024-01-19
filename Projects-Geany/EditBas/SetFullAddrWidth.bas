'// SetFullAddrWidth.bas
'//---------------------------------------------------------------
'// SetFullAddrWidth - Set column width on full address column.
'//		9/11/20.	wmk.	22:30
'//---------------------------------------------------------------

public sub SetFullAddrWidth()

'//	Usage.	macro call or
'//			call SetPhoneWidths()
'//
'// Entry.	User in RefUSA/Admin formatted territory sheet
'//
'//	Exit.	column J width set to 1.75" (4445)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	8/30/20.	wmk.	original code
'//	9/2/20.		wmk.	code added to preserve user cell selection on 
'//						entry/restore on exit; error handling included
'//	9/11/20.	wmk.	code simplified
'//
'//	Notes.

'//	constants.
const	ONE_INCH=2540
const	COL_J=9
const 	J_WIDTH=1.75

'//	local variables.
dim oDocument   as object
dim oDispatcher as object
dim oDoc	As Object	'// ThisComponent
dim oSel	As Object	'// current selection
dim oRange	As Object	'// RangeAddress from selection
dim iSheetIx	As Integer	'// this sheet index
dim oSheet	As Object	'// this sheet
dim oCols	As Object	'// .Columns this sheet

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns
	oCols(COL_J).setPropertyValue("Width", J_WIDTH*ONE_INCH)

if true then
	GoTo EndOldCode
endif
'//--------------------------------------------------------
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// preserve current selection
	
	'// set column width for J to 1.75" (4445)

	'// set up arguments for uno:GoToCell interface
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$J$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
'dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ColumnWidth"
	args1(0).Value = 4445

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args1())
'//---------------------------------------------------------------------------
EndOldCode:
NormalExit:
	SetSelection(oRange)	'// restore range selected
	exit sub
	
ErrorHandler:
	msgbox("SetFullAddrWidth - unprocessed error.")
	
end sub		'// end SetFullAddrWidth	9/11/20
