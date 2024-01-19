'// SetPhoneWidths.bas
'//---------------------------------------------------------------
'// SetPhoneWidths - Set column widths on phone columns.
'//		9/11/20.	wmk.	22:15
'//---------------------------------------------------------------

public sub SetPhoneWidths()

'//	Usage.	macro call or
'//			call SetPhoneWidths()
'//
'// Entry.	User in RefUSA/Admin formatted territory sheet
'//
'//	Exit.	columns K,L widths set to 1.0" (2540)
'//			column M width set to 1.1" (2794)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	8/30/20.		wmk.	original code
'// 9/2/20.		wmk.	preserve and restore user cell selection on entry
'//						and exit; error handling added
'//	9/11/20.	wmk.	code simplified; constants implemented
'//
'//	Notes. UNO Dispatcher exits this module, corrupting any module-wide
'//	vars. Only way to preserve user cell selection on entry is in local
'//	vars this sub.
'//

'//	constants.
const COL_K=10			'// column K index
const COL_L=11			'// column L index 
const COL_M=12			'// column M index

const	ONE_INCH=2540
const	K_WIDTH=1.0
const	L_WIDTH=1.0
const	M_WIDTH=1.1

'//	local variables.
dim oDocument   as object
dim oDispatcher as object
dim oDoc	As Object	'// ThisComponent
dim oSel	As Object	'// current cell selection on entry
dim oRange	As Object	'// RangeAddress selected
dim oSheet	As Object	'// current sheet
dim oCols	As Object	'// columns this sheet
dim iSheetIx	As Integer	'// this sheet index

	'// code.
	ON ERROR GOTO ErrorHandler
	
	'// preserve user cell selection
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns

	oCols(COL_K).setPropertyValue("Width", K_WIDTH*ONE_INCH)
	oCols(COL_L).setPropertyValue("Width", L_WIDTH*ONE_INCH)
	oCols(COL_M).setPropertyValue("Width", M_WIDTH*ONE_INCH)
	
if true then
	GoTo EndOldCode
endif
'//---------------------------------------------------------
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	'// set column widths for K, L, to 1.0" (2540)
	'//							 M to 1.1" (2794)

	'// set up arguments for uno:GoToCell interface
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$K$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
'dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ColumnWidth"
	args1(0).Value = 2540

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args1())

	'// set up arguments for uno:GoToCell interface
'	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$L$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
'dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ColumnWidth"
	args1(0).Value = 2540

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args1())

	'// set up arguments for uno:GoToCell interface
'	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$M$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
'dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ColumnWidth"
	args1(0).Value = 2790

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args1())
'//---------------------------------------------------------------------------
EndOldCode:

NormalExit:
	SetSelection(oRange)	'// restore user cell selection
	exit sub
	
ErrorHandler:
	msgbox("SetPhoneWidths - unprocessed error.")
	
end sub		'// end SetPhoneWidths	9/2/20
