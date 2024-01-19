'// TerrToBridge.bas
'//---------------------------------------------------------------
'// TerrToBridge - Pub-Territory sheet to Admin-Bridge sheet.
'//		9/19/20.	wmk.	19:45
'//---------------------------------------------------------------

public sub TerrToBridge()

'//	Usage.	macro call or
'//			call TerrToBridge()
'//
'//	Entry..	user in a "Pub-Territory" formatted sheet with the following fields:
'//        A    	B      C       D      E     F    		G		   H		I
'//		Address  Name1  Name2   Phone1  Phone2 RU/Phone	 DoNotCall	Foreign	Personal/Notes
'//[source] B      C	  D		   E	  F	        G          J       L		-
'//
'// Exit.	entry sheet transformed to Admin-Bridge with following fields:
'//[src]  E1	 	   A           B       C         D      E      F
'//	OwningParcel  UnitAddress  Resident1 Resident2 Phone1 Phone2 RUPhone
'//			A			B			C		D		  E		 F		G	
'//
'//[src] B4     D4        G       -    H       C2       fsAddrToSCFormat  -
'//  SubTerr CongTerr DoNotCall RSO Foreign  RecordDate SitusAddress  DelPending
'//		H		I		   J     K     L		M			  N			  O
'//
'// Calls.	BoldHeadings, ForceRecalc, SetTerrWidths,
'//			SetSelection, MergeOwnerCells, MergeStreetsCells,
'//			MergeSheetType
'//
'//	Modification history.
'//	---------------------
'//	9/18/20.	wmk.	original code; adapted from EditToTerr
'//	9/19/20.	wmk.	Merge.. calls; FreezeView call added
'//
'//	Notes.
'// Method.
'//     Insert new column A
'//     col A heading to "OwningParcel"
'//		Move header B1-I4 to A1
'//		col B heading to "UnitAddress"
'//		col C heading to "Resident1"
'//		col D heading to "Resident2"
'//		col G heading to "RefUSA"
'//     insert 2 cols at H
'//     col H heading to "SubTerritory
'//		col I heading to "CongTerrID"
'//     insert 1 col at K
'//     col K heading to "RSO"
'//     del col M
'//		col M heAding to "RecordDate"
'//		col N heading to "SitusAddress"
'//		col O heading to "DelPending"
'// for each active row
'//			Ax = E1 OwnerParcel
'//			Nx = fsAddrToSCFormat(Bx)
'//			Mx = C2 date
'//			Ix = D4 CongTerrID
'//			Hx = B4 SubTerritory
'// next row
'//		H1 = "Admin-Bridge formatted sheet" 

'//	constants.
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
const COL_M=12			'// column M index (RecordDate)
const COL_N=13			'// column N index (SitusAddress)
const COL_O=14			'// column O index (DelPending)
const ROW_1=0
const ROW_2=1
const ROW_3=2
const ROW_4=3
const ROW_HEADING=4		'// headings row index
const LJUST=1		'// left-justify HoriJustify				'// mod052020
const CJUST=2		'// center HoriJustify						'// mod052020
const RJUST=3		'// right-justify HoriJustify				'// mod052320
const MDYY=30		'// 'M/D/YY' format value

'//	local variables.
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet
dim oMrgRange	As Object	'// merge range

dim oCell	As Object		'// cell working on
dim i		As Integer		'// loop index
dim sPropID	As String		'// property ID
dim sSubTerr	As String	'// subterritory
dim sCongTerr	As String	'// cong terr ID
dim lRowCount	As Long		'// row count of addresses
dim dDate		As Double	'// date value
dim sAddr		As String	'// full address
dim sNotes		As String	'// notes field
dim nCols		As Integer	'// removal column count
dim oCols		As Object	'// .Columns array this sheet
dim oCell2		As Object	'// target cell when moving cell contents

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns
	
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value


	'//     Insert new column A
	'//     col A heading to "OwningParcel"
	oCols.insertByIndex(COL_A, 1)
	oCell = oSheet.getCellByPosition(COL_A, ROW_HEADING)
	oCell.String = "OwningParcel"
	oCell.HoriJustify = CJUST

	'//		Move header B1-I4 to A1
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_B
	oMrgRange.EndColumn = COL_I
	oMrgRange.StartRow = ROW_1
	oMrgRange.EndRow = ROW_4
dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_A
	oTarget.Row = ROW_1
	oSheet.moveRange(oTarget,oMrgRange)

	'//	restore B2 formula row count
	oCell = oSheet.getCellByPosition(COL_B, ROW_2)
	oCell.setFormula("=COUNTA($A$6:$A$1299)")
	
	'//		col B heading to "UnitAddress"
	oCell = oSheet.getCellByPosition(COL_B, ROW_HEADING)
	oCell.String = "UnitAddress"
	oCell.HoriJustify = CJUST
	
	'//		col C heading to "Resident1"
	oCell = oSheet.getCellByPosition(COL_C, ROW_HEADING)
	oCell.String = "Resident1"
	oCell.HoriJustify = CJUST
	
	'//		col D heading to "Resident2"
	oCell = oSheet.getCellByPosition(COL_D, ROW_HEADING)
	oCell.String = "Resident2"
	oCell.HoriJustify = CJUST

	'//		col G heading to "RefUSA"
	oCell = oSheet.getCellByPosition(COL_G, ROW_HEADING)
	oCell.String = "RefUSA"
	oCell.HoriJustify = CJUST

	'//		clear old H1 title 
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = ""

	'//     insert 2 cols at H
	'//     col H heading to "SubTerritory
	'//		col I heading to "CongTerrID"
	oCols.insertByIndex(COL_H, 2)
	oCell = oSheet.getCellByPosition(COL_H, ROW_HEADING)
	oCell.String = "SubTerritory"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_I, ROW_HEADING)
	oCell.String = "CongTerrID"
	oCell.HoriJustify = CJUST
	
	'//     insert 1 col at K
	'//     col K heading to "RSO"
	oCols.insertByIndex(COL_K,1)
	oCell = oSheet.getCellByPosition(COL_K, ROW_HEADING)
	oCell.String = "RSO"
	oCell.HoriJustify = CJUST
	
	'//     del col M
	'//		col M heading to "RecordDate"
	oCols.removeByIndex(COL_M, 1)
	oCell = oSheet.getCellByPosition(COL_M, ROW_HEADING)
	oCell.String = "RecordDate"
	oCell.HoriJustify = CJUST
	
	'//		col N heading to "SitusAddress"
	oCell = oSheet.getCellByPosition(COL_N, ROW_HEADING)
	oCell.String = "SitusAddress"
	oCell.HoriJustify = CJUST

	'//		col O heading to "DelPending"
	oCell = oSheet.getCellByPosition(COL_O, ROW_HEADING)
	oCell.String = "DelPending"
	oCell.HoriJustify = CJUST

	'// grab E1 PropertyID
	oCell = oSheet.getCellByPosition(COL_E, ROW_1)
	sPropID = oCell.String
	
	'// for each active row
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1

		'//			Ax = E1 OwnerParcel
		oCell = oSheet.getCellByPosition(COL_A, lThisRow)
		oCell.String = sPropID
		
		'//			Hx = B4 SubTerritory
		oCell = oSheet.getCellByPosition(COL_H, lThisRow)
		oCell.setFormula("=$B$4")
		
		'//			Ix = D4 CongTerrID
		oCell = oSheet.getCellByPosition(COL_I, lThisRow)
		oCell.setFormula("=$D$4")

		'//			Mx = C2 date
		oCell = oSheet.getCellByPosition(COL_C, ROW_2)
		oCell2 = oSheet.getCellByPosition(COL_M, lThisRow)
		oCell2.setValue(oCell.getValue())
		oCell2.NumberFormat = MDYY
		
		'//			Nx = fsAddrToSCFormat(Bx)
		oCell = oSheet.getCellByPosition(COL_B, lThisRow)
		sAddr = oCell.String
		oCell2 = oSheet.getCellByPosition(COL_N, lThisRow)
		oCell2.String = fsAddrToSCFormat(sAddr)
		oCell2.HoriJustify = LJUST
		
	'// next row
	next i

	'//		H1 = "Admin-Bridge formatted sheet" 
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Admin-Bridge formatted sheet"

	'// tidy up header information
	ForceRecalc()
	BoldHeadings()
	SetBridgeColWidths()
'	MergeAreaCells()
'	MergeOwnerCells()
'	MergePropIDCells()
'	MergeSheetType()
'	MergeStreetsCells()
	FreezeView()
	
NormalExit:
	exit sub

ErrorHandler:
	msgbox("TerrToBridge - unprocessed error.")
	GoTo NormalExit

end sub		'// end TerrToBridge		9/19/20
