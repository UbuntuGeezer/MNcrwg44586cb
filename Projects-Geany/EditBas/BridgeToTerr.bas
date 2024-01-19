'// BridgeToTerr.bas
'//---------------------------------------------------------------
'// BridgeToTerr - Admin-Bridge sheet to Pub-Territory sheet.
'//		1/14/21.	wmk.	07:00
'//---------------------------------------------------------------

public sub BridgeToTerr()

'//	Usage.	macro call or
'//			call BridgeToTerr()
'//
'// Entry.
'//	OwningParcel  UnitAddress  Unit	 Resident1 Phone1 Phone2 RUPhone
'//			A			B		C		D		  E		 F		G	
'//  SubTerr CongTerr DoNotCall RSO Foreign  RecordDate SitusAddress
'//		H		I		   J     K     L		M			  N		
'//  PropUse	DelPending
'//		O  			P
'//
'//	Exit.	produces a "Pub-Territory" formatted sheet with the following fields:
'//        A    	B      C       D      E     F    		G		   H		I
'//		Address   Unit  Name1   Phone1  Phone2 RU/Phone	 DoNotCall	Foreign	Personal/Notes
'//[source] B      C	  D		   E	  F	        G          J       L		-
'//
'// Calls.	BoldHeadings, ForceRecalc, SetTerrWidths,
'//			SetSelection, MergeOwnerCells, MergeStreetsCells,
'//			MergeSheetType, SetHdrSumFormula, CenterUnitHstead,
'//			FreezeView
'//
'//	Modification history.
'//	---------------------
'//	9/18/20.	wmk.	original code; adapted from EditToTerr
'//	9/19/20.	wmk.	Merge.. calls; FreezeView call added
'//	9/21/20.	wmk.	SetHdrSumFormula call added
'//	9/30/20.	wmk.	PropUse column support
'//	10/3/20.	wmk.	check all rows for DoNotCall
'// 10/23/20.	wmk.	support Unit column replacing Resident1,
'//						Resident2 column removed; dead code removed;
'//						ForceRecalc call added
'// 11/29/20.	wmk.	bug fix DO NOT CALL overwriting Unit field, moved
'//						to Name1 field at new position from 10/23 mod
'// 1/14/21.	wmk.	modified to center columns B and E and to 
'//						freeze view at A6
'//	Notes.
'// Method.
'//		Move header A1-H4 to B1
'//		Remove column A
'//		Change A heading to "Address"
'//		col B heading to "Name1"
'//		col C heading to "Name2"
'//		col G heading to "DoNotCall"
'//		move col I data to col G
'//		col H heading to "Foreign"
'//		move col K data to col H
'//		remove columns I to N
'//		col I heading to "Personal Notes"
'//		H1 = "Admin-TSExport formatted sheet" 

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
const COL_L=11			'// column L index (DoNotCall)
const COL_M=12			'// column M index (RSO)
const COL_N=13			'// column N index (Foreign)
const COL_O=14			'// column O index
const COL_P=15			'// column P index
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
dim sCityStZip	As String	'// concatenated City, State, Zip
dim sNotes		As String	'// notes field
dim nCols		As Integer	'// removal column count

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value

	'// remove columns H, I since header already set
	oSheet.Columns.removeByIndex(COL_H, 2)

	'// now remove new I (RSO)
	oSheet.Columns.removeByIndex(COL_I, 1)

	'// now remove J - M
	oSheet.Columns.removeByIndex(COL_J, 4)
		
	
	'// move A1-H4 to B1 to allow col A removal
	'//		move data from entire column E to B
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_A
	oMrgRange.EndColumn = COL_H
	oMrgRange.StartRow = ROW_1
	oMrgRange.EndRow = ROW_4
dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_B
	oTarget.Row = ROW_1
	oSheet.moveRange(oTarget,oMrgRange)
	
	'// remove col A
	oSheet.Columns.removeByIndex(COL_A, 1)
	
	'// change col A heading to "Address"
	oCell = oSheet.getCellByPosition(COL_A, ROW_HEADING)
	oCell.String = "Address"
	oCell.HoriJustify = CJUST

	'//		col B heading to "Unit"
	oCell = oSheet.getCellByPosition(COL_B, ROW_HEADING)
	oCell.String = "Unit"
	oCell.HoriJustify = CJUST

	'//		col C heading to "Name1"
	oCell = oSheet.getCellByPosition(COL_C, ROW_HEADING)
	oCell.String = "Name1"
	oCell.HoriJustify = CJUST

	'// Delete G4 "RefUSA", set F4 to "RefUSA"
	oCell = oSheet.getCellByPosition(COL_G, ROW_HEADING-1)
	oCell.String = ""
	oCell = oSheet.getCellByPosition(COL_F, ROW_HEADING)
	oCell.String = "RefUSA"
	oCell.HoriJustify = CJUST

	'//		col I heading to "Personal Notes"
	oCell = oSheet.getCellByPosition(COL_I, ROW_HEADING)
	oCell.String = "Personal Notes"
	oCell.HoriJustify = CJUST

	'//		H1 = "Pub-Territory formatted sheet" 
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Pub-Territory formatted sheet"

	'// check rows for DoNotCall flag and set Name1 accordingly
	lThisRow = ROW_HEADING		'// start 1 row behind
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell = oSheet.getCellByPosition(COL_G, lThisRow)
'		if StrComp(oCell.String, "1") = 0 then
		if oCell.Value = 1 then
			oCell = oSheet.getCellByPosition(COL_C, lThisRow)
			oCell.String = "DO NOT CALL"
		endif
	next i
	
	'// tidy up header information
	SetHdrSumFormula()		'// restore B2 formula
	BoldHeadings()
	SetTerrColWidths()
	MergeSheetType()	'// remerge since move destroyed merge
	CenterUnitHstead()	'// center unit and "homestead" columns
	FreezeView()		'// freeze row/column scrolling at A6
	ForceRecalc()

NormalExit:
	exit sub

ErrorHandler:
	msgbox("BridgeToTerr - unprocessed error.")
	GoTo NormalExit

end sub		'// end BridgeToTerr		1/14/21
