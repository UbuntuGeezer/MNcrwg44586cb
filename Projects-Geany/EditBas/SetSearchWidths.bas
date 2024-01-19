'// SetSearchWidths.bas
'//---------------------------------------------------------------
'// SetSearchWidths - Set column widths on search columns.
'//		9/11/20.	wmk.	22:45
'//---------------------------------------------------------------

public sub SetSearchWidths()

'//	Usage.	macro call or
'//			call SetSearchWidths()
'//
'// Entry.	User in RefUSA/Admin formatted territory sheet
'//
'//	Exit.	columns H-J widths set to 1.34" (3404)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/3/20.		wmk.	original code
'//	9/8/20.		wmk.	change from M-P to H-J columns
'//	9/11/20.	wmk.	code simplified
'//
'//	Notes. UNO Dispatcher exits this module, corrupting any module-wide
'//	vars. Only way to preserve user cell selection on entry is in local
'//	vars this sub.

'//	constants.
const OnePt34=3404		'// 1.34"
const ONE_INCH=2540
const COL_H=7
const COL_I=8
const COL_J=9
const SRCH_WIDTH=1.34

'//	local variables.
dim oDocument   as object
dim oDispatcher as object
dim oDoc	As Object	'// ThisComponent
dim oSel	As Object	'// current cell selection on entry
dim oRange	As Object	'// RangeAddress selected
dim iSheetIx	As Integer	'// current sheet index
dim oSheet	As Object	'// current sheet
dim oCols	As Object	'// .Columns current sheet

	'// code.
	ON ERROR GOTO ErrorHandler
		
	'// preserve user cell selection
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns
	oCols(COL_H).setPropertyValue("Width", SRCH_WIDTH*ONE_INCH)
	oCols(COL_I).setPropertyValue("Width", SRCH_WIDTH*ONE_INCH)
	oCols(COL_J).setPropertyValue("Width", SRCH_WIDTH*ONE_INCH)
	
if true then
	GoTo EndOldCode
endif
'//---------------------------------------------------------------------
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	'// set column widths for N-P to 1.34" (3404)

	'// set up arguments for uno:GoToCell interface
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$H$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "ColumnWidth"
	args2(0).Value = OnePt34

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

	'// set up arguments for uno:GoToCell interface
'	dim args1(0) as new com.sun.star.beans.PropertyValue
'	args1(0).Name = "ToPoint"
	args1(0).Value = "$I$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
'dim args1(0) as new com.sun.star.beans.PropertyValue
'	args1(0).Name = "ColumnWidth"
'	args1(0).Value = 2540

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

	'// set up arguments for uno:GoToCell interface
'	dim args1(0) as new com.sun.star.beans.PropertyValue
'	args1(0).Name = "ToPoint"
	args1(0).Value = "$J$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
'dim args1(0) as new com.sun.star.beans.PropertyValue
'	args1(0).Name = "ColumnWidth"
'	args1(0).Value = 2790

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())
'//----------------------------------------------------------------------------
EndOldCode:
NormalExit:
	SetSelection(oRange)	'// restore user cell selection
	exit sub
	
ErrorHandler:
	msgbox("SetPhoneWidths - unprocessed error.")
	
end sub		'// end SetSearchWidths	9/11/20
