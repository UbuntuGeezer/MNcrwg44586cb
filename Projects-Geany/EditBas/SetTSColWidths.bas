'// SetTSColWidths.bas
'//---------------------------------------------------------------
'// SetTSColWidths - Set column widths on TS formatted sheet columns.
'//		9/11/20.	wmk.	23:00
'//---------------------------------------------------------------

public sub SetTSColWidths()

'//	Usage.	macro call or
'//			call SetTSColWidths()
'//
'// Entry.	User in TS formatted territory sheet
'//
'//	Exit.	A = 0.75", B = 1.75, C = 1.0" , D = 1.75, E = 1.75, F = 2.0"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/9/20.		wmk.	original code
'//
'//	Notes. UNO Dispatcher exits this module, corrupting any module-wide
'//	vars. Only way to preserve user cell selection on entry is in local
'//	vars this sub.

'//	constants.
const ONE_INCH=2540
const COL_A=0
const COL_B=1
const COL_C=2
const COL_D=3
const COL_E=4
const COL_F=5

'// column widths
const A_WIDTH=0.75		'// 0.75
const B_WIDTH=1.75		'// 1.75
const C_WIDTH=1.1		'// 1.1
const D_WIDTH=1.75		'// 1.75
const E_WIDTH=1.75		'// 1.75
const F_WIDTH=2.0		'// 2.0

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
	oCols(COL_A).setPropertyValue("Width", A_WIDTH*ONE_INCH)
	oCols(COL_B).setPropertyValue("Width", B_WIDTH*ONE_INCH)
	oCols(COL_C).setPropertyValue("Width", C_WIDTH*ONE_INCH)
	oCols(COL_D).setPropertyValue("Width", D_WIDTH*ONE_INCH)
	oCols(COL_E).setPropertyValue("Width", E_WIDTH*ONE_INCH)
	oCols(COL_F).setPropertyValue("Width", F_WIDTH*ONE_INCH)

if true then
	GoTo EndOldCode
endif
'//-------------------------------------------------------------------
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	'// set column widths to width constants
'//--------
	'// set up arguments for uno:GoToCell interface
dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$A$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "ColumnWidth"
	args2(0).Value = A_WIDTH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$B$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = B_WIDTH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$C$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = C_WIDTH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$D$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = D_WIDTH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$E$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = E_WIDTH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$F$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = F_WIDTH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())
'//--------------------------------------------------------------------------
EndOldCode:
NormalExit:
	SetSelection(oRange)	'// restore user cell selection
	exit sub
	
ErrorHandler:
	msgbox("SetTSColWidths - unprocessed error.")
	
end sub		'// end SetTSColWidths	9/11/20
