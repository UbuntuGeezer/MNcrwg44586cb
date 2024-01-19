'// SetSheetColWidths.bas
'//----------------------------------------------------------------------
'// SetSheetColWidths - Set column widths in named sheet columns.
'//		11/21/21.	wmk.	09:27
'//----------------------------------------------------------------------

public sub SetSheetColWidths(poDoc As Object, pnSheetIx As Integer)

'//	Usage.	macro call or
'//			call SetTerrColWidths(oDoc, nSheetIx)
'//
'//		oDoc = workbook to set column widths in
'//		onSheetIx = sheet index to set column widths in
'//
'// Entry.	
'//
'//	Exit.	A = 1.75", B = 1.0, C = 1.75", D = 1.0, E = 0.45, F = 1.0"
'//			G = 0.9", H = 0.9. I = 2.5"
'//
'// Calls.	SetSheetColWidths
'//
'//	Modification history.
'//	---------------------
'//	9/11/20.	wmk.	original code; adapted from SetEditColWidths
'//	9/18/20.	wmk.	widths readjusted and set through col I
'//	10/23/20.	wmk.	new Unit column width set; dead code removed
'// 1/13/21.	wmk.	E width set to 0.45 for "homestead" column
'//
'//	Notes. UNO Dispatcher exits this module, corrupting any module-wide
'//	vars. Only way to preserve user cell selection on entry is in local
'//	vars this sub.

'//	constants.
const ONE_INCH=2540

'// column and row indexes
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
const A_WIDTH=1.75
const B_WIDTH=1.0
const C_WIDTH=1.75
const D_WIDTH=1.0
const E_WIDTH=0.45
const F_WIDTH=1.1
const G_WIDTH=0.9
const H_WIDTH=0.9
const I_WIDTH=2.5

'//	local variables.
dim oDocument   as object
dim oDispatcher as object
dim oDoc	As Object	'// ThisComponent
dim oSel	As Object	'// current cell selection on entry
dim oSheet	As Object	'// current sheet
dim oRange	As Object	'// RangeAddress selected
dim iSheetIx	As Integer	'// sheet index this sheet
dim oCols	As Object	'// .Columns array this sheet
dim anColWidths(8) As Integer	'// columns widths array

	'// code.
	ON ERROR GOTO ErrorHandler
	'// preserve user cell selection
'	oDoc = ThisComponent
'	oSel = oDoc.getCurrentSelection()
'	oRange = oSel.RangeAddress

	anColWidths(0) = A_WIDTH*ONE_INCH
	anColWidths(1) = B_WIDTH*ONE_INCH
	anColWidths(2) =	C_WIDTH*ONE_INCH
	anColWidths(3) = D_WIDTH*ONE_INCH
	anColWidths(4) = E_WIDTH*ONE_INCH
	anColWidths(5) = F_WIDTH*ONE_INCH
	anColWidths(6) = G_WIDTH*ONE_INCH
	anColWidths(7) = H_WIDTH*ONE_INCH
	anColWidths(8) = I_WIDTH*ONE_INCH
	SetColWidths(poDoc, pnSheetIx, anColWidths)
	
NormalExit:
'	SetSelection(oRange)	'// restore user cell selection
	exit sub
	
ErrorHandler:
	msgbox("SetTerrColWidths - unprocessed error.")
	
end sub		'// end SetTerrColWidths	11/21/21	09:27
