'// EditToTerr.bas
'//---------------------------------------------------------------
'// EditToTerr - Convert Admin-Edit to Pub-Territory sheet.
'//		9/13/20.		wmk.	01:05
'//---------------------------------------------------------------

public sub EditToTerr()

'//	Usage.	macro call or
'//			call EditToTerr()
'//
'// Entry.	user selection is Admin-Edit formatted sheet
'//
'//	Exit.	produces a "Pub-Territory" formatted sheet with the following fields:
'//        A    	B      C       D      E     F    		G		   H		I
'//		Address  Name1  Name2   Phone1  Phone2 RU/Phone	 DoNotCall	Foreign	Personal/Notes
'//[source] B      C	  D		   E	  F	        G          M       O		-
'//
'// Calls.	BoldHeadings, ForceRecalc, SetTerrWidths,
'//			SetSelection, MergeOwnerCells, MergeStreetsCells,
'//			MergeSheetType
'//
'//	Modification history.
'//	---------------------
'//	9/11/20.	wmk.	original code
'//	9/12/20.	wmk.	SetTerrWidths call corrected; MergeStreetsCells
'//						call added
'//	9/13/20.	wmk.	changed to leave RefUSA/Phone column
'//						in Territory fields
'//
'// Admin-Edit sheet fields.
'//		9/7/20. (lines preceded by #s are SplitTable fields)
'//								source-column	target-column
'//0|OwningParcel|TEXT|1||0			A				-
'//1|UnitAddress|TEXT|1||0			B				D
'//2|Resident1|TEXT|0||0			C				B
'//3|Resident2|TEXT|0||0			D				C
'//4|Phone1|TEXT|0||0				E				D
'//5|Phone2|TEXT|0||0				F				E
'//6|RefUSA-Phone|TEXT|0||0			G				F
'//	truepeople hyperlink			H				-
'// 411 hyperlink					I				-
'// whitepages hyperlink			J				-
'//7|SubTerritory|TEXT|0||0			K				-
'//8|CongTerrID|TEXT|0||0			L				-
'//9|DoNotCall|INTEGER|0|0|0		M				G
'//10|RSO|INTEGER|0|0|0				N				-
'//11|Foreign|INTEGER|0|0|0			O				H
'//12|RecordDate|REAL|0|0|0			P
'//13|X-Pending|INTEGER|0|0|0
'//
'// Method.
'//		Move header A1-H4 to B1
'//		Remove column A
'//		Change A heading to "Address"
'//		col B heading to "Name1"
'//		col C heading to "Name2"
'//		remove columns G-N
'//		remove column G
'//		set H column heading to "Personal/Notes"
'//		set H1 = "Pub-Territory formatted sheet"

'//	constants.
const COL_NAME1=1		'// column B is Name1 column
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
dim oCell2	As Object		'// cell related cell to oCell
dim i		As Integer		'// loop index
dim sPropID	As String		'// property ID
dim sSubTerr	As String	'// subterritory
dim sCongTerr	As String	'// cong terr ID
dim lRowCount	As Long		'// row count of addresses
dim dDate		As Double	'// date value
dim sCityStZip	As String	'// concatenated City, State, Zip
dim sNotes		As String	'// notes field
dim	nCols		As Integer	'// column count to remove
dim sFormula	As String	'// COUNTA formula from B2
dim bForeign	As Boolean
dim bDoNotCall	As Boolean

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value

'//		Move header A1-H4 to B1
	oCell = oSheet.getCellByPosition(COL_B, ROW_2)
	sFormula = oCell.getFormula()					'// save B2 formula
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

'//		Remove column A, then restore formula in B2
	oSheet.Columns.removeByIndex(COL_A, 1) 
	oCell = oSheet.getCellByPosition(COL_B, ROW_2)
	oCell.setFormula(sFormula)

'//		Change A heading to "Address"
'//		col B heading to "Name1"
'//		col C heading to "Name2"
	oCell = oSheet.getCellByPosition(COL_A, ROW_HEADING)
	oCell.String = "Address"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_B, ROW_HEADING)
	oCell.String = "Name1"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_C, ROW_HEADING)
	oCell.String = "Name2"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_F, ROW_HEADING-1)
	oCell.String = "RefUSA"
	oCell.HoriJustify = CJUST

'//		remove columns G-K
	nCols = ASC("K") + 1 - ASC("G")
	oSheet.Columns.removeByIndex(COL_G, nCols) 

'//		remove column H (RSO)
	oSheet.Columns.removeByIndex(COL_H, 1) 

'//		remove column I (RecordDate)
	oSheet.Columns.removeByIndex(COL_I, 1) 

'//		set I column heading to "Personal/Notes"
	oCell = oSheet.getCellByPosition(COL_I, ROW_HEADING-1)
	oCell.String = "Personal"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_I, ROW_HEADING)
	oCell.String = "Notes"
	oCell.HoriJustify = CJUST
	SetColWidth(COL_I, 2.0)
	
'//		set H1 = "Pub-Territory formatted sheet"
	'// merge H1-J1 SheetType
	MergeSheetType()
	
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Pub-Territory formatted sheet"
	oCell.HoriJustify = CJUST

	'// set column widths
	SetTerrWidths()

	'// merge owner name cells back together
	MergeOwnerCells()
	
	'// merge Streets/Addrs cells back together
'	MergeStreetsCells()

	'// for all rows, check DoNotCall/Foriegn and change Resident1 name to "DO NOT CALL"
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell = oSheet.getCellByPosition(COL_F, lThisRow)
		oCell2 = oSheet.getCellByPosition(COL_G, lThisRow)
		bForeign = (len(trim(oCell2.String)) &gt; 0)
		bDoNotCall = (len(trim(oCell.String)) &gt; 0)
		if bForeign then
			oCell = oSheet.getCellByPosition(COL_NAME1, lThisRow)
			oCell.String = "Foreign Language - Do not call"
dim oCols As Object
			oCols = oSheet.Columns
			oCols(COL_NAME1).setPropertyValue("Width", 2540*2)
		elseif bDoNotCall then
			oCell = oSheet.getCellByPosition(COL_NAME1, lThisRow)
			oCell.String = "DO NOT CALL"
		endif
		
	next i
	
	'// force recalculation
	ForceRecalc()
	
	'// restore selection to entry place
	SetSelection(oRange)
	
NormalExit:
	exit sub

ErrorHandler:
	msgbox("EditToTerr - unprocessed error.")
	GoTo NormalExit
	
end sub		'// end EditToTerr		9/13/20
