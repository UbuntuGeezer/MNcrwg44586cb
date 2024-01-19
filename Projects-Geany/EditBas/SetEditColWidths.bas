'// SetEditColWidths.bas
'//----------------------------------------------------------------------
'// SetEditColWidths - Set column widths on Edit formatted sheet columns.
'//		9/12/20.	wmk.	08:30
'//----------------------------------------------------------------------

public sub SetEditColWidths()

'//	Usage.	macro call or
'//			call SetEditColWidths()
'//
'// Entry.	User in Edit formatted territory sheet
'//
'//	Exit.	A = 1.0", B = 1.75, C = 1.75", D = 1.75, E = 1.0, F = 1.0"
'//			G = 1.1", H = 1.34, I = 1.34, J = 1.34, K = 1.34, L = 0.9"
'//			M = 0.9", N = 0.9", O = 0.9", P = 0.9"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/9/20.		wmk.	original code
'//	9/12/20.	wmk.	code simplification
'//
'//	Notes. UNO Dispatcher exits this module, corrupting any module-wide
'//	vars. Only way to preserve user cell selection on entry is in local
'//	vars this sub.

'//	constants.
const ONE_INCH=2540

'// columns and other definitions
const COL_PARCEL=0		'// "OwningParcel" column index
const COL_A=0
const COL_B=1
const COL_C=2	
const COL_D=3
const COL_E=4
const COL_F=5
const COL_G=6			'// column G index
const COL_H=7			'// column H index
const COL_I=8			'// column I index
const COL_J=9			'// column J index
const COL_K=10			'// column K index
const COL_L=11			'// column L index 
const COL_M=12			'// column M index (DoNotCall)
const COL_N=13			'// column N index (RSO)
const COL_O=14			'// column O index (Foreign)
const COL_P=15			'// column P index (RecordDate)
const ROW_1=0
const ROW_2=1
const ROW_3=2
const ROW_4=3
const ROW_HEADING=4		'// headings row index
const LJUST=1		'// left-justify HoriJustify				'// mod052020
const CJUST=2		'// center HoriJustify						'// mod052020
const RJUST=3		'// right-justify HoriJustify				'// mod052320
const MDYY=30		'// 'M/D/YY' format value

'// column widths
const A_WIDTH=1.0
const B_WIDTH=1.75
const C_WIDTH=1.75
const D_WIDTH=1.75
const E_WIDTH=1.0
const F_WIDTH=1.0
const G_WIDTH=1.1
const H_WIDTH=1.34
const I_WIDTH=1.34
const J_WIDTH=1.34
const K_WIDTH=1.34
const L_WIDTH=0.9
const M_WIDTH=0.9
const N_WIDTH=0.9
const O_WIDTH=0.9
const P_WIDTH=0.9

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
	oCols = oSheets.Columns

	'// set A-G widths
	oCols(COL_A).setPropertyValue("Width", A_WIDTH*ONE_INCH)
	oCols(COL_B).setPropertyValue("Width", B_WIDTH*ONE_INCH)
	oCols(COL_C).setPropertyValue("Width", C_WIDTH*ONE_INCH)
	oCols(COL_D).setPropertyValue("Width", D_WIDTH*ONE_INCH)
	oCols(COL_E).setPropertyValue("Width", E_WIDTH*ONE_INCH)
	oCols(COL_F).setPropertyValue("Width", F_WIDTH*ONE_INCH)
	oCols(COL_G).setPropertyValue("Width", G_WIDTH*ONE_INCH)
	
	'// set H, I, J widths
	SetSearchWidths()
	
	'// set K-P widths
	oCols(COL_K).setPropertyValue("Width", K_WIDTH*ONE_INCH)
	oCols(COL_L).setPropertyValue("Width", L_WIDTH*ONE_INCH)
	oCols(COL_M).setPropertyValue("Width", M_WIDTH*ONE_INCH)
	oCols(COL_N).setPropertyValue("Width", N_WIDTH*ONE_INCH)
	oCols(COL_O).setPropertyValue("Width", O_WIDTH*ONE_INCH)
	oCols(COL_P).setPropertyValue("Width", P_WIDTH*ONE_INCH)
	
	
if true then
	GoTo EndOldCode
endif
'//--------------------------------------------------------------------	
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
	args2(0).Value = A_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$B$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = B_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$C$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = C_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$D$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = D_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$E$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = E_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------f
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$F$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = F_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------G
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$G$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = G_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------H
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$H$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = H_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------I
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$I$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = I_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------J
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$J$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = J_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------K
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$K$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = K_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------L
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$L$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = L_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------M
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$M$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = M_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------N
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$N$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = N_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------O
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$O$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = O_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())

'//----------P
	'// set up arguments for uno:GoToCell interface
	args1(0).Name = "ToPoint"
	args1(0).Value = "$P$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	args2(0).Name = "ColumnWidth"
	args2(0).Value = P_WIDTH * ONE_INCH

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())
'//--------------------------------------------------------------------------------
EndOldCode:
NormalExit:
	SetSelection(oRange)	'// restore user cell selection
	exit sub
	
ErrorHandler:
	msgbox("SetEditColWidths - unprocessed error.")
	
end sub		'// end SetEditColWidths	9/12/20
