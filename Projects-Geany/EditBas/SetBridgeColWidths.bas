'// SetBridgeColWidths.bas
'//----------------------------------------------------------------------
'// SetBridgeColWidths - Set column widths on Bridge formatted sheet.
'//		10/23/20.	wmk.	04:45
'//----------------------------------------------------------------------

public sub SetBridgeColWidths()

'//	Usage.	macro call or
'//			call SetBridgeColWidths()
'//
'// Entry.	User in Admin-Bridge formatted sheet
'//	OwningParcel  UnitAddress  Unit		  Resident1	 Phone1 Phone2 RefUSA-Phone
'//	 A (from A)	  B (from K)  C (from I)  D (from C)	E	 F		G	
'//
'//  SubTerrItory CongTerrID DoNotCall RSO Foreign  RecordDate	 SitusAddress
'//		H				I		   J     K     L	M (header C2)	N (from N)
'//
'//  Property Use	DelPending
'//		  O				P
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/11/20.	wmk.	original code; adapted from SetEditColWidths
'//	9/18/20.	wmk.	widths readjusted and set through col I
'// 9/30/20.	wmk.	adjust SubTerritory column (H) width to 1.35
'// 10/23/20.	wmk.	adjust width of new Unit Column (C) to 1.0
'//
'//	Notes.

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
const A_WIDTH=1.0
const B_WIDTH=1.75
const C_WIDTH=1.0
const D_WIDTH=1.75
const E_WIDTH=1.0
const F_WIDTH=1.0
const G_WIDTH=1.1
const H_WIDTH=1.35
const I_WIDTH=1.0
const J_WIDTH=1.0
const K_WIDTH=0.45
const L_WIDTH=0.6
const M_WIDTH=0.85
const N_WIDTH=1.75
const O_WIDTH=0.85

'//	local variables.
dim oDocument   as object
dim oDispatcher as object
dim oDoc	As Object	'// ThisComponent
dim oSel	As Object	'// current cell selection on entry
dim oSheet	As Object	'// current sheet
dim oRange	As Object	'// RangeAddress selected
dim iSheetIx	As Integer	'// sheet index this sheet
dim oCols	As Object	'// .Columns array this sheet

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
	oCols(COL_G).setPropertyValue("Width", G_WIDTH*ONE_INCH)
	oCols(COL_H).setPropertyValue("Width", H_WIDTH*ONE_INCH)
	oCols(COL_I).setPropertyValue("Width", I_WIDTH*ONE_INCH)
	oCols(COL_J).setPropertyValue("Width", J_WIDTH*ONE_INCH)
	oCols(COL_K).setPropertyValue("Width", K_WIDTH*ONE_INCH)
	oCols(COL_L).setPropertyValue("Width", L_WIDTH*ONE_INCH)
	oCols(COL_M).setPropertyValue("Width", M_WIDTH*ONE_INCH)
	oCols(COL_N).setPropertyValue("Width", N_WIDTH*ONE_INCH)
	oCols(COL_O).setPropertyValue("Width", O_WIDTH*ONE_INCH)

NormalExit:
	SetSelection(oRange)	'// restore user cell selection
	exit sub
	
ErrorHandler:
	msgbox("SetBridgeColWidths - unprocessed error.")
	
end sub		'// end SetBridgeColWidths	10/23/20
