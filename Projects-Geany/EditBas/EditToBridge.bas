'// RUEditToBridge.bas
'//--------------------------------------------------------------------------
'// RUEditToBridge - Convert RU/Admin-Edit spreadsheet to Admin-Bridge sheet.
'//		9/30/20.	wmk.	12:00
'//--------------------------------------------------------------------------

public sub RUEditToBridge()

'//	Usage.	macro call or
'//			call RUEditToBridge()
'//
'// Entry.	user in Admin-Edit format spreadsheet
'//	OwningParcel  UnitAddress  Resident1 Resident2 Phone1 Phone2 RUPhone
'//			A			B			C		D		  E		 F		G	
'//  
'//	truepeople	411		whitepages
'//		H		 I		   J
'//
'//	SubTerr CongTerr DoNotCall RSO Foreign  RecordDate SitusAddress
'//		K		L		   M     N    O			P			  Q		
'//  PropUse	DelPending
'//		R  			S
'//
'//	Exit.	sheet columns and header modified to match Admin-Bridge spec
'//			for updating MultiMail.db/SplitProps table
'//	OwningParcel  UnitAddress  Resident1 Resident2 Phone1 Phone2 RUPhone
'//			A			B			C		D		  E		 F		G	
'//  SubTerr CongTerr DoNotCall RSO Foreign  RecordDate SitusAddress
'//		H		I		   J     K     L		M			  N		
'//  PropUse	DelPending
'//		O  			P
'//
'//
'// Calls.	SetTerrWidths, BoldHeadings
'//
'//	Modification history.
'//	---------------------
'//	9/4/20.		wmk.	original code
'// 9/5/20.		wmk.	misc. bug fixes to comply with OPTION EXPLICIT;
'//						fix RefUSA Phone column being deleted; column
'//						widths for SubTerritory, CongTerrID adjusted to 0.9"
'//	9/6/20.		wmk.	add support for "RecordDate" field in SplitProps
'//						table; take date from cell C2 in edit sheet; bug fix
'//						where DoNotCall column lost; move BoldHeadings call
'//						to after RecordDate heading set
'// 9/7/20.		wmk.	code adjustments for support of "Foreign" and
'//						"X-Pending" fields
'//	9/30/20.	wmk.	documentation updated
'//
'//	Notes. This sub/utility is run on the Admin-Edit sheet coming back from
'//	either the territory sevant, or a territory administrator after being
'// updated with changes. This sheet is morphed into an Admin-Bridge
'// sheet that is then used to produce a .csv "&lt;ST&gt;Update.csv" where &lt;ST&gt;
'// is the SubTerritory name (e.g. ANDROS). That .csv will then be used
'// to create a &lt;ST&gt;Update.db containing 1 table "PropsUpdt". That .db
'// and table will be used with SQL and a SELECT..UNION..SELECT that will
'// form the union of any new records and the entire MultiMail/SplitProps
'// records. (CREATE TEMP TABLE &lt;table-name&gt; AS SELECT..UNION..SELECT)
'//
'// MultiMail/SplitProps table fields.
'//		9/7/20.
'//0|OwningParcel|TEXT|1||0
'//1|UnitAddress|TEXT|1||0
'//2|Resident1|TEXT|0||0
'//3|Resident2|TEXT|0||0
'//4|Phone1|TEXT|0||0
'//5|Phone2|TEXT|0||0
'//6|RefUSA-Phone|TEXT|0||0
'//7|SubTerritory|TEXT|0||0
'//8|CongTerrID|TEXT|0||0
'//9|DoNotCall|INTEGER|0|0|0
'//10|RSO|INTEGER|0|0|0
'//11|Foreign|INTEGER|0|0|0
'//12|RecordDate|REAL|0|0|0
'//13|X-Pending|INTEGER|0|0|0
'//	Method. code RueditToBridge to take edit spreadsheet and move upward
'// to Bridge format:
'// Insert column 0 “OwningParcel”,
'// rename “search/truepeople column H to “SubTerritory”,
'// rename column I to CongTerrID,
'// delete column J moving DoNotCall and RSO over 1 left;
'// fill column 0 with OwningParcel from header;
'// fill SubTerritory and CongTerrID with fields from header


'//	constants.
const COL_PARCEL=0		'// "OwningParcel" column index
const COL_A=0
const COL_B=1
const COL_C=2	
const COL_D=3
const COL_E=4
const COL_G=6			'// column G index
const COL_H=7			'// column H index
const COL_I=8			'// column I index
const COL_J=9			'// column J index
const COL_K=10			'// column K index (DoNotCall)
const COL_L=11			'// column L index (RSO)
const COL_M=12			'// column M index (Foreign)
const COL_N=13			'// column N index (RecordDate)
const COL_O=14			'// column O index (X-Pending)
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

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
	'// delete columns H, I, search columns 
	oSheet.Columns.removeByIndex(COL_H,2)
	
	'// insert 2 columns at H for SubTerritory and CongTerr ID
	oSheet.Columns.insertByIndex(COL_H,2)
	
	'// insert 1 column at A for OwningParcel
	oSheet.Columns.insertByIndex(COL_PARCEL,1)
	SetBridgeHeadings()
	
if true then
	GoTo NewCode
endif

	'// insert column at index 0 for "OwningParcel"
	oSheet.Columns.insertByIndex(COL_PARCEL,1)
	
	'// delete column J (search whitepages, index 9)
	oSheet.Columns.removeByIndex(COL_J,1)

	'// remove columns I, J and replace with 2 new columns
	oSheet.Columns.removeByIndex(COL_I,2)
	oSheet.Columns.insertByIndex(COL_I,2)
	SetBridgeHeadings()

NewCode:	
if true then
	GoTo Skip1
endif

	'// correct column headings
	'// set OwningParcel heading
	oCell = oSheet.getCellByPosition(COL_PARCEL, ROW_HEADING)
	oCell.String = "OwningParcel"
	oCell.HoriJustify = CJUST

	'// set SubTerritory heading
	oCell = oSheet.getCellByPosition(COL_I, ROW_HEADING)
	oCell.String = "SubTerritory"
	oCell.HoriJustify = CJUST
	
	'// set CongTerrID heading
	oCell = oSheet.getCellByPosition(COL_I+1, ROW_HEADING)
	oCell.String = "CongTerrID"
	oCell.HoriJustify = CJUST
'	SetColWidth(COL_I, 0.9)
'	SetColWidth(COL_J, 0.9)
	SetTerrWidths()		'// also RecordDate

	'// set DoNotCall heading (K)
	
	'// set RSO heading (L)
	
	'// set Foreign heading (M)
	oCell = oSheet.getCellByPosition(COL_M, ROW_HEADING)
	oCell.String = "Foreign"
	oCell.HoriJustify = CJUST
	
	
	'// set RecordDate heading
	oCell = oSheet.getCellByPosition(COL_N, ROW_HEADING)
	oCell.String = "RecordDate"
	oCell.HoriJustify = CJUST

	'// set X-Pending heading.
	oCell = oSheet.getCellByPosition(COL_O, ROW_HEADING)
	oCell.String = "X-Pending"
	oCell.HoriJustify = CJUST
Skip1:
	
	'// Insure all headings Bold.
	BoldHeadings()
	
	'// move B1 through G3 to A1
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_B
	oMrgRange.EndColumn = COL_G
	oMrgRange.StartRow = ROW_1
	oMrgRange.EndRow = ROW_3
dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_A
	oTarget.Row = ROW_1
	oSheet.moveRange(oTarget,oMrgRange)

	'// move B4 through E4 to A4
	oMrgRange.StartColumn = COL_B
	oMrgRange.EndColumn = COL_E
	oMrgRange.StartRow = ROW_4
	oMrgRange.EndRow = ROW_4
	oTarget.Column = COL_A
	oTarget.Row = ROW_4
	oSheet.moveRange(oTarget,oMrgRange)
	
	'// right-justify A2-A4
	oCell = oSheet.getCellByPosition(COL_A, ROW_2)
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_A, ROW_3)
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_A, ROW_4)
	oCell.HoriJustify = RJUST
	
	'// fill column A with property id from E1
	'// B2.Value = row count
	oCell =	oSheet.getCellByPosition(COL_E, ROW_1)
	sPropID = oCell.String
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_A, lThisRow)
		oCell.String = sPropID
	next i	

	'// fill column I with SubTerritory from B4
	oCell =	oSheet.getCellByPosition(COL_B, ROW_4)
	sSubTerr = oCell.String
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_I, lThisRow)
		oCell.String = sSubTerr
	next i	
	
	'// fill column J with CongTerrID from D4
	oCell =	oSheet.getCellByPosition(COL_D, ROW_4)
	sCongTerr = oCell.String
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_J, lThisRow)
		oCell.String = sCongTerr
	next i	

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
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgBox("RUEditToBridge - unprocessed error.")
	GoTo NormalExit
end sub		'// end RUEditToBridge		9/30/20
'// EditToBridge.bas
'//--------------------------------------------------------------------------
'// EditToBridge - Convert Admin-Edit spreadsheet to Admin-Bridge sheet.
'//		9/30/20.	wmk.	13:30
'//--------------------------------------------------------------------------

public sub EditToBridge()

'//	Usage.	macro call or
'//			call EditToBridge()
'//
'// Entry.	user in Admin-Edit format spreadsheet
'//	OwningParcel  UnitAddress  Resident1 Resident2 Phone1 Phone2 RUPhone
'//			A			B			C		D		  E		 F		G	
'//  
'//	truepeople	411		whitepages
'//		H		 I		   J
'//
'//	SubTerr CongTerr DoNotCall RSO Foreign  RecordDate SitusAddress
'//		K		L		   M     N    O			P			  Q		
'//  PropUse	DelPending
'//		R  			S
'//
'//	Exit.	sheet columns and header modified to match Admin-Bridge spec
'//			for updating MultiMail.db/SplitProps table
'//	OwningParcel  UnitAddress  Resident1 Resident2 Phone1 Phone2 RUPhone
'//			A			B			C		D		  E		 F		G	
'//  SubTerr CongTerr DoNotCall RSO Foreign  RecordDate SitusAddress
'//		H		I		   J     K     L		M			  N		
'//  PropUse	DelPending
'//		O  			P
'//
'//
'// Calls.	SetTerrWidths, BoldHeadings
'//
'//	Modification history.
'//	---------------------
'//	9/30/20.		wmk.	original code; adapted from RUEditToBridge
'// 				this differs from RUEditToBridge, in that it is not
'//					necessary to insert a column (A) for OwningParcel
'//					since it is already present.
'//
'//	Notes. This sub/utility is run on the Admin-Edit sheet coming back from
'// a territory administrator after being updated with changes. This sheet
'// is morphed into an Admin-Bridge sheet that is then used to produce a
'// .csv "&lt;ST&gt;Update.csv" where &lt;ST&gt; is the SubTerritory name (e.g. ANDROS).
'//.. 9/30/20 this may change.. That .csv will then be used
'// to create a &lt;ST&gt;Update.db containing 1 table "PropsUpdt". That .db
'// and table will be used with SQL and a SELECT..UNION..SELECT that will
'// form the union of any new records and the entire MultiMail/SplitProps
'// records. (CREATE TEMP TABLE &lt;table-name&gt; AS SELECT..UNION..SELECT)
'//
'// MultiMail/SplitProps table fields.
'//		9/7/20.
'//0|OwningParcel|TEXT|1||0
'//1|UnitAddress|TEXT|1||0
'//2|Resident1|TEXT|0||0
'//3|Resident2|TEXT|0||0
'//4|Phone1|TEXT|0||0
'//5|Phone2|TEXT|0||0
'//6|RefUSA-Phone|TEXT|0||0
'//7|SubTerritory|TEXT|0||0
'//8|CongTerrID|TEXT|0||0
'//9|DoNotCall|INTEGER|0|0|0
'//10|RSO|INTEGER|0|0|0
'//11|Foreign|INTEGER|0|0|0
'//12|RecordDate|REAL|0|0|0
'//13|X-Pending|INTEGER|0|0|0
'//	Method. code EditToBridge to take edit spreadsheet and move upward
'// to Bridge format:
'// Insert column 0 “OwningParcel”,
'// rename “search/truepeople column H to “SubTerritory”,
'// rename column I to CongTerrID,
'// delete column J moving DoNotCall and RSO over 1 left;
'// fill column 0 with OwningParcel from header;
'// fill SubTerritory and CongTerrID with fields from header


'//	constants.
const COL_PARCEL=0		'// "OwningParcel" column index
const COL_A=0
const COL_B=1
const COL_C=2	
const COL_D=3
const COL_E=4
const COL_G=6			'// column G index
const COL_H=7			'// column H index
const COL_I=8			'// column I index
const COL_J=9			'// column J index
const COL_K=10			'// column K index (DoNotCall)
const COL_L=11			'// column L index (RSO)
const COL_M=12			'// column M index (Foreign)
const COL_N=13			'// column N index (RecordDate)
const COL_O=14			'// column O index (X-Pending)
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

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
	'// delete columns H-J
	oSheet.Columns.removeByIndex(COL_H,3)

if true then
  GoTo Skip3
endif
	'// delete columns H, I, search columns 
	oSheet.Columns.removeByIndex(COL_H,2)
	
	'// insert 2 columns at H for SubTerritory and CongTerr ID
	oSheet.Columns.insertByIndex(COL_H,2)
Skip3:

if true then
  GoTo Skip2
endif	
	'// insert 1 column at A for OwningParcel
	oSheet.Columns.insertByIndex(COL_PARCEL,1)
Skip2:

	'// set sheet type field and headings
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Admin-Bridge formatted sheet"

	SetBridgeHeadings()
	
if true then
	GoTo NewCode
endif

	'// insert column at index 0 for "OwningParcel"
	oSheet.Columns.insertByIndex(COL_PARCEL,1)
	
	'// delete column J (search whitepages, index 9)
	oSheet.Columns.removeByIndex(COL_J,1)

	'// remove columns I, J and replace with 2 new columns
	oSheet.Columns.removeByIndex(COL_I,2)
	oSheet.Columns.insertByIndex(COL_I,2)

	'// set sheet type field and headings
	oCell = oSheet.getByPosition(COL_H, ROW_1)
	oCell.String = "Admin-Bridge formatted sheet"
	oCell = oSheet.getCellByPosition(COL_J, ROW_4)
	oCell.String = ""
	SetBridgeHeadings()

NewCode:	
if true then
	GoTo Skip1
endif

	'// correct column headings
	'// set OwningParcel heading
	oCell = oSheet.getCellByPosition(COL_PARCEL, ROW_HEADING)
	oCell.String = "OwningParcel"
	oCell.HoriJustify = CJUST

	'// set SubTerritory heading
	oCell = oSheet.getCellByPosition(COL_I, ROW_HEADING)
	oCell.String = "SubTerritory"
	oCell.HoriJustify = CJUST
	
	'// set CongTerrID heading
	oCell = oSheet.getCellByPosition(COL_I+1, ROW_HEADING)
	oCell.String = "CongTerrID"
	oCell.HoriJustify = CJUST
'	SetColWidth(COL_I, 0.9)
'	SetColWidth(COL_J, 0.9)
	SetTerrWidths()		'// also RecordDate

	'// set DoNotCall heading (K)
	
	'// set RSO heading (L)
	
	'// set Foreign heading (M)
	oCell = oSheet.getCellByPosition(COL_M, ROW_HEADING)
	oCell.String = "Foreign"
	oCell.HoriJustify = CJUST
	
	
	'// set RecordDate heading
	oCell = oSheet.getCellByPosition(COL_N, ROW_HEADING)
	oCell.String = "RecordDate"
	oCell.HoriJustify = CJUST

	'// set X-Pending heading.
	oCell = oSheet.getCellByPosition(COL_O, ROW_HEADING)
	oCell.String = "X-Pending"
	oCell.HoriJustify = CJUST
Skip1:
	
	'// Insure all headings Bold.
	BoldHeadings()

if true then
  GoTo Skip5
endif	
	'// move B1 through G3 to A1
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_B
	oMrgRange.EndColumn = COL_G
	oMrgRange.StartRow = ROW_1
	oMrgRange.EndRow = ROW_3
dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_A
	oTarget.Row = ROW_1
	oSheet.moveRange(oTarget,oMrgRange)

	'// move B4 through E4 to A4
	oMrgRange.StartColumn = COL_B
	oMrgRange.EndColumn = COL_E
	oMrgRange.StartRow = ROW_4
	oMrgRange.EndRow = ROW_4
	oTarget.Column = COL_A
	oTarget.Row = ROW_4
	oSheet.moveRange(oTarget,oMrgRange)
Skip5:
	
	'// right-justify A2-A4
	oCell = oSheet.getCellByPosition(COL_A, ROW_2)
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_A, ROW_3)
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_A, ROW_4)
	oCell.HoriJustify = RJUST

	'// set row count for following loop(s)
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value
	
if true then
  GoTo Skip4
endif
	'// fill column A with property id from E1
	'// B2.Value = row count
	oCell =	oSheet.getCellByPosition(COL_E, ROW_1)
	sPropID = oCell.String
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_A, lThisRow)
		oCell.String = sPropID
	next i	

	'// fill column I with SubTerritory from B4
	oCell =	oSheet.getCellByPosition(COL_B, ROW_4)
	sSubTerr = oCell.String
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_I, lThisRow)
		oCell.String = sSubTerr
	next i	
	
	'// fill column J with CongTerrID from D4
	oCell =	oSheet.getCellByPosition(COL_D, ROW_4)
	sCongTerr = oCell.String
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell =	oSheet.getCellByPosition(COL_J, lThisRow)
		oCell.String = sCongTerr
	next i	
Skip4:

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
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgBox("EditToBridge - unprocessed error.")
	GoTo NormalExit
end sub		'// end EditToBridge		9/30/20
