'// SetTerrWidths.bas
'//---------------------------------------------------------------
'// SetTerrWidths - Set column widths on search columns.
'//		9/11/20.	wmk.	23:00
'//---------------------------------------------------------------

public sub SetTerrWidths()

'//	Usage.	macro call or
'//			call SetTerrWidths()
'//
'// Entry.	User in RefUSA/Admin formatted territory sheet
'//
'//	Exit.	columns I, J, K widths set to 0.9" (2286)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/5/20.		wmk.	original code
'// 9/6/20.		wmk.	mod to include RecordDate column (M)
'//	9/11/20.	wmk.	code simplfied
'//
'//	Notes. UNO Dispatcher exits this module, corrupting any module-wide
'//	vars. Only way to preserve user cell selection on entry is in local
'//	vars this sub.

'//	constants.
const ZeroPt9=2286		'// 0.9"
const ONE_INCH=2540
const COL_WIDTH=0.9
const COL_I=8
const COL_J=9
const COL_K=10
const COL_M=12

'//	local variables.
dim oDocument   as object
dim oDispatcher as object
dim oDoc	As Object	'// ThisComponent
dim oSel	As Object	'// current cell selection on entry
dim oRange	As Object	'// RangeAddress selected
dim iSheetIx	As Integer	'// this sheet index
dim oSheet	As Object	'// this sheet
dim oCols	As Object	'// .Columns this sheet

	'// code.
	ON ERROR GOTO ErrorHandler
	
	'// preserve user cell selection
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns
	oCols(COL_I).setPropertyValue("Width", COL_WIDTH*ONE_INCH)
	oCols(COL_J).setPropertyValue("Width", COL_WIDTH*ONE_INCH)
	oCols(COL_K).setPropertyValue("Width", COL_WIDTH*ONE_INCH)
	oCols(COL_M).setPropertyValue("Width", COL_WIDTH*ONE_INCH)

if true then
	GoTo EndOldCode
endif
'//--------------------------------------------------------------------
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	'// set column widths for N-P to 1.34" (3404)

	'// set up arguments for uno:GoToCell interface
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$I$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "ColumnWidth"
	args2(0).Value = ZeroPt9

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

	'// set up arguments for uno:GoToCell interface
'	dim args1(0) as new com.sun.star.beans.PropertyValue
'	args1(0).Name = "ToPoint"
	args1(0).Value = "$J$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
'dim args1(0) as new com.sun.star.beans.PropertyValue
'	args1(0).Name = "ColumnWidth"
'	args1(0).Value = 2540

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

	'// set up arguments for uno:GoToCell interface
'	dim args1(0) as new com.sun.star.beans.PropertyValue
'	args1(0).Name = "ToPoint"
	args1(0).Value = "$M$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
'dim args1(0) as new com.sun.star.beans.PropertyValue
'	args1(0).Name = "ColumnWidth"
'	args1(0).Value = 2540

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())
'//----------------------------------------------------------------------------
EndOldCode:
NormalExit:
	SetSelection(oRange)	'// restore user cell selection
	exit sub
	
ErrorHandler:
	msgbox("SetTerrWidths - unprocessed error.")
	
end sub		'// end SetTerrWidths	9/11/20
