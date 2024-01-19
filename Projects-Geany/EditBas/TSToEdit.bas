'// TSToEdit.bas
'//---------------------------------------------------------------
'// TSToEdit - Convert TS formatted territory to Admin-Edit format.
'//		9/12/20.	wmk.	08:00
'//---------------------------------------------------------------

public sub TSToEdit()

'//	Usage.	macro call or
'//			call TSToEdit()
'//
'// Entry.	user has TS formatted territory selected
'// following are the columns A - id, B - name, C - phone_number
'//							  D - street_address E - city_state_zip
'//							  F - notes
'//
'//	Exit.	sheet reformatted to Admin-Edit sheet format
'// following are the Admin-Edit columns: A - OwningParcel, B - UnitAddress,
'//		C - Resident1, D - Resident2, E - Phone1, F - Phone2,
'//		G - RefUSA/Phone, H - search/truepeople, I - search/411,
'//		J - search/whitepages, K - SubTerritory, L - CongTerrID,
'//		M - DoNotCall, N - RSO, O - Foreign, P - RecordDate
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/10/20.		wmk.	original code
'// 9/12/20.		wmk.	bug fixes with column headings
'//
'//	Notes. In the Admin-Edit sheet, only columns B, C, E come from column
'// data in the TS formatted sheet. The header information is assumed to
'// contain the values for column A, column K and column L. Column O
'// will be flagged with an 'x' if column F (notes) contains 'foreign'
'// (not case-sensitive). Column M will be flagged with an 'x' if column F
'// (notes) contains 'dnc' (not case-sensitive). Column N will be flagged 
'//	with an 'x' if column F (notes) contains 'rso' (not case-sensitive).
'//
'// Method.
'//		move header information B1-I4 to A1
'//		change column A heading to "OwningParcel"
'//		change column E heading to "Phone1"
'//		set column G - P headings to "RefUSA/PHone".."RecordDate"
'//		loop on all active rows (pass 1)
'//			process column F (notes); if 'dnc' set 'x' in column M this row
'//				if 'foreign' set 'x' in column O this row,
'//				if 'rso' set 'x' in column N this row
'//			set column F to "" (Phone2)
'//			set column A to property ID from E1
'//			set column E to column C (phone_number)
'//			set column C to column B (name)
'//			set column B to column D (street_address)
'//			set column D to "" (Resident2)
'//			set column K to SubTerritory from B4
'//			set column L to CongTerrID from D4
'//		next row
'//		select all active rows
'//		use GenELinkM to generate all hyperlinks
'//		set H1 to "Admin-Edit formatted sheet'
'//		set all headings bold
'//		set EditColWidths
'//		force recalc

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
dim oCell2	As Object		'// related cell to cell working on
dim oCellPhone	As Object	'// cell with Phone1
dim i		As Integer		'// loop index
dim sPropID	As String		'// property ID
dim sSubTerr	As String	'// subterritory
dim sCongTerr	As String	'// cong terr ID
dim lRowCount	As Long		'// row count of addresses
dim dDate		As Double	'// date value
dim sCityStZip	As String	'// concatenated City, State, Zip
dim sNotes		As String	'// notes field
dim	nCols		As Integer	'// column count to remove
dim nPos		As Integer	'// position of string within notes

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
'//		Move B1-I4 entries to A1
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

	'// pick up row count from header
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value

	'// pick up propertyID from header
	oCell = oSheet.getCellByPosition(COL_E, ROW_1)
	sPropID = oCell.String
	
	'// pick up SubTerritory from header B4
	oCell =	oSheet.getCellByPosition(COL_B, ROW_4)
	sSubTerr = oCell.String
	
	'// pick up CongTerrID from header D4
	oCell =	oSheet.getCellByPosition(COL_D, ROW_4)
	sCongTerr = oCell.String
	
'//		change column A heading to "OwningParcel"
	oCell =	oSheet.getCellByPosition(COL_A, ROW_HEADING)
	oCell.String = "OwningParcel"
	
'//		change column B heading to "UnitAddress"
	oCell =	oSheet.getCellByPosition(COL_B, ROW_HEADING)
	oCell.String = "OwningParcel"

'//		change column D heading to "Resident2"
	oCell =	oSheet.getCellByPosition(COL_D, ROW_HEADING)
	oCell.String = "Resident2"

'//		change column C heading to "Resident1"
	oCell =	oSheet.getCellByPosition(COL_C, ROW_HEADING)
	oCell.String = "Resident1"

'//		change column E heading to "Phone1"
	oCell =	oSheet.getCellByPosition(COL_E, ROW_HEADING)
	oCell.String = "Phone1"
	
'//		change column F heading to "Phone2"
	oCell =	oSheet.getCellByPosition(COL_F, ROW_HEADING)
	oCell.String = "Phone2"
	
'//		set column G - P headings to "RefUSA/Phone".."RecordDate"
	oCell =	oSheet.getCellByPosition(COL_G, ROW_HEADING-1)
	oCell.String = "RefUSA"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_G, ROW_HEADING)
	oCell.String = "Phone Number"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_H, ROW_HEADING-1)
	oCell.String = "search"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_H, ROW_HEADING)
	oCell.String = "truepeople"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_I, ROW_HEADING-1)
	oCell.String = "search"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_I, ROW_HEADING)
	oCell.String = "411"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_J, ROW_HEADING-1)
	oCell.String = "search"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_J, ROW_HEADING)
	oCell.String = "whitepages"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_K, ROW_HEADING)
	oCell.String = "SubTerritory"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_L, ROW_HEADING)
	oCell.String = "CongTerrID"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_M, ROW_HEADING)
	oCell.String = "DoNotCall"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_N, ROW_HEADING)
	oCell.String = "RSO"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_O, ROW_HEADING)
	oCell.String = "Foreign"
	oCell.HoriJustify = CJUST
	oCell =	oSheet.getCellByPosition(COL_P, ROW_HEADING)
	oCell.String = "RecordDate"
	oCell.HoriJustify = CJUST

	lThisRow = ROW_HEADING
'// loop on all active rows
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
'//			process column F (notes); if 'dnc' set 'x' in column M this row
'//				if 'foreign' set 'x' in column O this row,
'//				if 'rso' set 'x' in column N this row
'//			set column F to "" (Phone2)
		oCell =	oSheet.getCellByPosition(COL_F, lThisRow)
		sNotes = LCase(trim(oCell.String))
		oCell.String = ""
		nPos = InStr(sNotes, "dnc")
		if nPos &gt; 0 then
			oCell2 = oSheet.getCellByPosition(COL_M, lThisRow)
			oCell2.String = "x"
			oCell2.HoriJustify = CJUST
		endif
		nPos = InStr(sNotes, "foreign")
		if nPos &gt; 0 then
			oCell2 = oSheet.getCellByPosition(COL_O, lThisRow)
			oCell2.String = "x"
			oCell2.HoriJustify = CJUST
		endif
		nPos = InStr(sNotes, "rso")
		if nPos &gt; 0 then
			oCell2 = oSheet.getCellByPosition(COL_N, lThisRow)
			oCell2.String = "x"
			oCell2.HoriJustify = CJUST
		endif
		
		'//	set column A to property ID from E1
		oCell =	oSheet.getCellByPosition(COL_A, lThisRow)
		oCell.String = sPropID
		
		'//	set column E to column C (phone_number)
		oCell =	oSheet.getCellByPosition(COL_C, lThisRow)
		oCell2 = oSheet.getCellByPosition(COL_E, lThisRow)
		oCell2.String = oCell.String

		'//		set column C to column B (name)
		oCell2 = oSheet.getCellByPosition(COL_B, lThisRow)
		oCell.String = oCell2.String

		'//		set column B to column D (street_address)
		oCell =	oSheet.getCellByPosition(COL_D, lThisRow)
		oCell2.String = oCell.String

		'//		set column D to "" (Resident2)
		oCell.String = ""
		
		'//		set column K to SubTerritory from B4
		oCell =	oSheet.getCellByPosition(COL_K, lThisRow)
		oCell.String = sSubTerr
	
		'//		set column L to CongTerrID from D4
		oCell =	oSheet.getCellByPosition(COL_L, lThisRow)
		oCell.String = sCongTerr

	next i

	'//	select all active rows
	'//	use GenELinkM to generate all hyperlinks
	SelectActiveRows()
	GenELinkM()
	
	'//	set H1 to "Admin-Edit formatted sheet'
	oCell =	oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Admin-Edit formatted sheet"
		
	'//	set all headings bold
	BoldHeadings()
	
	'//	set EditColWidths
	SetEditColWidths()
	
	'//	force recalc
	ForceRecalc()
	
	'// restore selection
	SetSelection(oRange)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("TSToEdit - unprocessed error.")
	GoTo NormalExit

end sub		'// end TSToEdit		9/12/20
