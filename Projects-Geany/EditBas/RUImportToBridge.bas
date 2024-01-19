'// RUImportToBridge.bas
'//------------------------------------------------------------------------------
'// RUImportToBridge - Convert RU/Admin-Import spreadsheet to Admin-Bridge sheet.
'//		10/23/20.	wmk.	05:00
'//------------------------------------------------------------------------------

public sub RUImportToBridge()

'//	Usage.	macro call or
'//			call RUImportToBridge()
'//
'// Entry.	user in Admin-Import format spreadsheet (from ImportRefUSA)
'//Last Name [A], First Name [B], Full Name [C], House Number [D],
'//Pre-directional [E], Street [F], Street Suffix [G], Post-directional [H],
'//Apartment Number [I], Full Address [J], Phone1 [K],
'//Phone2 [L], RefUSA Phone [M], truepeople [N], 411 [O], whitepages [P],
'//DoNotCall [Q], RSO [R], Foreign [S]
'//
'//	Exit.	produces an "Admin-Bridge" formatted sheet with the x..Props columns:
'//	OwningParcel  UnitAddress  Unit		  Resident1	 Phone1 Phone2 RefUSA-Phone
'//	 A (from A)	  B (from K)  C (from I)  D (from C)	E	 F		G	
'//
'//  SubTerrItory CongTerrID DoNotCall RSO Foreign  RecordDate	 SitusAddress
'//		H				I		   J     K     L	M (header C2)	N (from N)
'//
'//  Property Use	DelPending
'//		  O				P
'//
'//		along with 4 header rows, populated with the Admin-Bridge header information.
'//&lt;Area-CommonName&gt;			Property ID	&lt;OwnerParcel&gt;			Admin-Bridge formatted sheet
'//Units shown:	63	9/16/20	Owner		&lt;OwnerName1&gt;
'//City	Venice	34285	Streets/Addrs	&lt;Streets-Address(s)&gt;
'//SubTerritory		CongTerrID
'//
'//sheet columns and header modified to match Admin-Bridge spec
'//			for updating MultiMail.db/SplitProps table
'//
'//
'// Calls.	ForceRecalc, SetTerrWidths, BoldHeadings, SetUnitAddrWidth,
'//			fsAddrToSCFormat, SetBridgeHeadings(), SetBridgeColWidths
'//
'//	Modification history.
'//	---------------------
'//	9/7/20.		wmk.	original code
'// 9/8/20.		wmk.	fix bug where formula in C2 being lost
'// 9/16/20.	wmk.	mod to set SubTerritory to formula =$B$4
'//						and CongTerrID to formula =$D$4; this will
'//						allow the user to set values in B4 and D4
'//						that will be part of the Bridge records
'//	9/17/20.	wmk.	field added "SitusAddress"; by adding
'//						this field, "bridge" records can be used
'//						in either the MultiMail or PolyTerri .db
'//						records for queries and other operations;
'//						field added "DelPending" last to match TerrProps
'//						table
'//	9/23/20.	wmk.	added PropUse field so addresses can be properly
'//						handled when generating territories
'// 9/27/20.	wmk.	documentation added; code compatibility with new
'//						InsertTerrHdr code; columns added to match new
'//						bridge format columns
'//	10/22/20.	wmk.	Change Bridge to support "Unit" field in place
'//						of Resident1; Resident2 to Resident1; remove dead
'//						code; set $B$4 formula to ="" if empty
'//
'//	Notes. This sub/utility is run on the Admin-Import sheet coming in from
'//	ImportRefUSA, after the raw RefUSA download has been processed.
'// updated with changes. This sheet is morphed into an Admin-Bridge
'// sheet that is then used to produce a .csv with the "bridge" fields
'// necessary to produce SplitProps or TerrProps records compatible
'// with the MulitiMail or PolyTerri tables containing territory
'// records, 1 per address.
'// is the SubTerritory name (e.g. ANDROS). That .csv will then be used
'// to create a &lt;ST&gt;Update.db containing 1 table "PropsUpdt". That .db
'// and table will be used with SQL and a SELECT..UNION..SELECT that will
'// form the union of any new records and the entire MultiMail/SplitProps
'// records. (CREATE TEMP TABLE &lt;table-name&gt; AS SELECT..UNION..SELECT)
'//
'// MultiMail/SplitProps table fields.
'//		10/22/20.					Column
'//0|OwningParcel|TEXT|1||0				A
'//1|UnitAddress|TEXT|1||0				B
'//2|Unit|TEXT|0||0						C
'//3|Resident1|TEXT|0||0				D
'//4|Phone1|TEXT|0||0					E
'//5|Phone2|TEXT|0||0					F
'//6|RefUSA-Phone|TEXT|0||0				G
'//7|SubTerritory|TEXT|0||0				H
'//8|CongTerrID|TEXT|0||0				I
'//9|DoNotCall|INTEGER|0|0|0			J
'//10|RSO|INTEGER|0|0|0					K
'//11|Foreign|INTEGER|0|0|0				L
'//12|RecordDate|REAL|0|0|0				M
'//13|SitusAddress|TEXT|0||0			N
'//14|PropertyUse|TEXT|0||0				O
'//15|DeletePending|INTEGER|0|0|0		P
'//
'//	Method. code RUImportToBridge to take import spreadsheet and move downward
'// to Bridge format:
'// Preserve Header information
'// Remove column N (search/truepeople);
'// Re-title columns N, O "SubTerritory" "CongTerrID"
'// Insert column 0 “OwningParcel”; set col 0 heading to "OwningParcel"
'// fill column 0 with OwningParcel from header;
'// Remove column B; set col B heading (from "Last Name") to "UnitAddress"
'// Set column C heading to "Unit"
'// Move data from column J ("Full Address") to column B ("UnitAddress")
'// Remove columns C-H; set col D heading (from "Full Address") to "Resident1"
'// Move data from old column I (now E) to column C (Unit)

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
const COL_K=10			'// column K index (DoNotCall)
const COL_L=11			'// column L index (RSO)
const COL_M=12			'// column M index (RecordDate)
const COL_N=13			'// column N index
const COL_O=14			'// column O index
const COL_P=15			'// column P index
const COL_S=18
const ROW_1=0
const ROW_2=1
const ROW_3=2
const ROW_4=3
const ROW_6=5
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
dim sFullAddr	As String	'// full address (col B)
dim sSCAddr		As String	'// county address (col N)

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

	'// B2.Value = row count
	ForceRecalc()
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value

	'// move the whole stinking header to column S
	'// so it's out of the way
	'// move A1 through H4 to S1
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_A
	oMrgRange.EndColumn = COL_H
	oMrgRange.StartRow = ROW_1
	oMrgRange.EndRow = ROW_4
dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_S
	oTarget.Row = ROW_1
	oSheet.moveRange(oTarget,oMrgRange)
	
	'// Remove column N (search/truepeople)
	oSheet.Columns.removeByIndex(COL_N, 1)

	'// Re-title columns N, O "SubTerritory" "CongTerrID"
	oCell = oSheet.getCellByPosition(COL_N, ROW_HEADING-1)
	oCell.String = ""
	oCell = oSheet.getCellByPosition(COL_N, ROW_HEADING)
	oCell.String = "SubTerritory"
	oCell.HoriJustify = CJUST
	
	oCell = oSheet.getCellByPosition(COL_O, ROW_HEADING-1)
	oCell.String = ""
	oCell = oSheet.getCellByPosition(COL_O, ROW_HEADING)
	oCell.String = "CongTerrID"
	oCell.HoriJustify = CJUST
	
	'// Insert column 0 “OwningParcel”; set col 0 heading to "OwningParcel"
	oSheet.Columns.insertByIndex(COL_A, 1)
	oCell = oSheet.getCellByPosition(COL_A, ROW_HEADING)
	oCell.String = "OwningParcel"
	oCell.HoriJustify = CJUST
	
	'// Remove column 1; set col 1 heading (from "Last Name") to "UnitAddress"
	oSheet.Columns.removeByIndex(COL_B, 1)
	oCell = oSheet.getCellByPosition(COL_B, ROW_HEADING)
	oCell.String = "UnitAddress"
	oCell.HoriJustify = CJUST
	
	'// Set column 2 heading to "Unit"
	oCell = oSheet.getCellByPosition(COL_C, ROW_HEADING)
	oCell.String = "Unit"
	oCell.HoriJustify = CJUST

	'// Move data from column J ("Full Address") to column B ("UnitAddress")
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_J
	oMrgRange.EndColumn = COL_J
	oMrgRange.StartRow = ROW_6
	oMrgRange.EndRow = ROW_6 + lRowCount-1
'dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_B
	oTarget.Row = ROW_6
	oSheet.moveRange(oTarget,oMrgRange)

	'// remove columns D - H
	oSheet.Columns.removeByIndex(COL_D, COL_H-COL_D+1)
	
	'// insert "Resident1" column at D
	oSheet.Columns.insertByIndex(COL_D, 1)
	oCell = oSheet.getCellByPosition(COL_D, ROW_HEADING)
	oCell.String = "Resident1"
	oCell.HoriJustify = CJUST

	'// move all column C name entries to column D
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_C
	oMrgRange.EndColumn = COL_C
	oMrgRange.StartRow = ROW_6
	oMrgRange.EndRow = ROW_6 + lRowCount-1
'dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_D
	oTarget.Row = ROW_6
	oSheet.moveRange(oTarget,oMrgRange)	

	'// Move data from old column I [now E] ("Apartment Number") to column C (Unit)
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_E
	oMrgRange.EndColumn = COL_E
	oMrgRange.StartRow = ROW_6
	oMrgRange.EndRow = ROW_6 + lRowCount-1
'dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_C
	oTarget.Row = ROW_6
	oSheet.moveRange(oTarget,oMrgRange)

	'// remove old columns I, J (now E, F)
	oSheet.Columns.removeByIndex(COL_E, 2)
	
	'// set E, F column headings to Phone1, Phone2
	oCell = oSheet.getCellByPosition(COL_E, ROW_HEADING)
	oCell.String = "Phone1"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_F, ROW_HEADING)
	oCell.String = "Phone2"
	oCell.HoriJustify = CJUST
	
	
	'// set "RecordDate" heading on col M
	oCell = oSheet.getCellByPosition(COL_M, ROW_HEADING)
	oCell.String = "RecordDate"
	oCell.HoriJustify = CJUST
	
	'// move L1 - S4 header info back to A1
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_L
	oMrgRange.EndColumn = COL_S
	oMrgRange.StartRow = ROW_1
	oMrgRange.EndRow = ROW_4
'dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_A
	oTarget.Row = ROW_1
	oSheet.moveRange(oTarget,oMrgRange)

	'// fill column 0 with OwningParcel from header;
	'// fill column A with property id from E1
	'// add SitusAddress in each column N from FullAddress (column B)
	'// B2.Value = row count
	oCell =	oSheet.getCellByPosition(COL_E, ROW_1)
	sPropID = oCell.String
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_A, lThisRow)
		oCell.setFormula("=$E$1")
		
		'// convert full address col B to SC address col N
		oCell =	oSheet.getCellByPosition(COL_B, lThisRow)
		sFullAddr = oCell.String
		sSCAddr = fsAddrToSCFormat(sFullAddr)
		oCell =	oSheet.getCellByPosition(COL_N, lThisRow)
		oCell.String = sSCAddr
		
	next i	

	'// fill column H with SubTerritory from B4; set formula so
	'// user may change dynamically
	oCell =	oSheet.getCellByPosition(COL_B, ROW_4)
	if Len(oCell.String) = 0 then
	   oCell.SetFormula("=" + CHR(34) + CHR(34))
	endif
	sSubTerr = oCell.String
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_H, lThisRow)
		oCell.setFormula("=$B$4")
	next i	
	
	'// fill column I with CongTerrID from D4; set formula so
	'// user may change dynamically
	oCell =	oSheet.getCellByPosition(COL_D, ROW_4)
	sCongTerr = oCell.String
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_I, lThisRow)
		oCell.setFormula("=$D$4")
	next i	
	SetTerrWidths()		'// also RecordDate

	'// fill column M with RecordDate from C2
	oCell =	oSheet.getCellByPosition(COL_C, ROW_2)
	dDate = oCell.Value
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_M, lThisRow)
		oCell.setValue(dDate)
		oCell.NumberFormat = MDYY
		oCell.HoriJustify = CJUST
	next i	

	SetBridgeHeadings()
	SetBridgeColWidths()
	
	'// set sheet type at H1 "Admin-Bridge formatted sheet"
	oCell =	oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Admin-Bridge formatted sheet"

	'// Reset formula =COUNTA($A$6:$A$1299) in cell C2
'	oCell = oSheet.getCellByPosition(COL_B, ROW_2)
'	oCell.setFormula("=COUNTA(A6:A1299)")
'	oCell.HoriJustify = CJUST
	SetHdrSumFormula()
		
	'// Insure all headings Bold.
	BoldHeadings()

	'// Set UnitAddress column width
	SetUnitAddrWidth()
	
	'// Set SitusAddress column width
	SetSitusAddrWidth()
	
	'// Force recalculation so count shows up correctly
	ForceRecalc()
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgBox("RUImportToBridge - unprocessed error.")
	GoTo NormalExit
end sub		'// end RUImportToBridge		10/23/20
