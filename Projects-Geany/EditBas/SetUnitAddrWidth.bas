'// SetUnitAddrWidth.bas
'//---------------------------------------------------------------
'// SetUnitAddrWidth - Set column width on unit address column.
'//		9/11/20.	wmk.	23:15
'//---------------------------------------------------------------

public sub SetUnitAddrWidth()

'//	Usage.	macro call or
'//			call SetUnitAddrWidth()
'//
'// Entry.	User in RefUSA/Admin formatted territory sheet
'//
'//	Exit.	column B width set to 1.75" (4445)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/7/20.		wmk.	original code; adapted from SetFullAddrWidth
'//
'//	Notes.


'//	constants.
const ONE_INCH=2540
const COL_B=1
const B_WIDTH=1.75

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
	oCols(COL_B).setPropertyValue("Width", B_WIDTH*ONE_INCH)

if true then
	GoTo EndOldCode
endif
'//--------------------------------------------------------------------
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	
	'// set column width for B to 1.75" (4445)

	'// set up arguments for uno:GoToCell interface
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$B$6"

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
	msgbox("SetUnitAddrWidth - unprocessed error.")
	
end sub		'// end SetUnitAddrWidth	9/11/20
