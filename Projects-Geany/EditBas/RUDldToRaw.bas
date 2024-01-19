'// RUDldToRaw.bas
'//----------------------------------------------------------------------------
'// RUDldToRaw - Restructure ReferenceUSA imported sheet to RawData.csv format.
'//		9/14/20.	wmk.	01:10	
'//----------------------------------------------------------------------------

public sub RUDldToRaw()

'//	Usage.	macro call or
'//			call RUDldToRaw()
'//
'// Entry.	sheet selected with raw .csv imported data from ReferenceUSA
'//			row index 0 contains headings
'//
'//	Exit.	sheet reorganized as per Notes below; resultant sheet is
'//			in RefUSA-RawData format
'//
'// Calls.	KillAutoRecalc, FreezeView, BoldHeadings, SetPhoneWidts
'//			SetFullAddrWidth, SetColWidth, SelectActiveRows, SetSelection,
'//			SortOnAddress, SetSearchWidths
'//
'//	Modification history.
'//	---------------------
'//	9/13/20.	wmk.	original code
'//	9/14/20.	wmk.	code completion; misc bug fixes
'//
'//	Notes. Territories/RefUSATest.csv import into sheet..
'// CREATE TABLE "RawData"
'//  ( 'LastName' TEXT NOT NULL,	
  '// 'FirstName' TEXT NOT NULL,
  '// 'HouseNumber' TEXT,
  '// 'Pre-Dir' TEXT,
  '// 'Street' TEXT,
  '// 'PostDir' TEXT, 
  '// 'AptNum' TEXT, 
  '// 'City' TEXT, 
  '// 'State' TEXT, 
  '// 'Zip' TEXT, 
  '// 'County' TEXT, 
  '// 'Phone' TEXT,
  '// 'FullAddress' TEXT,
  '// 'CongTerr' TEXT,
  '// 'RecordDate' REAL DEFAULT 0,
  '// 'DelPending' INTEGER DEFAULT 0 )
'//	Method. the following steps will be executed
'//		insert 4 rows starting at row index 0
'//		[Set View/Freeze Rows and Columns at column 0, row 5]
'//		insert column at index 2 "Found Name"
'//		set column header at index 2 "Found Name"
'//		delete 4 columns at column index 9 (city, state, zip, county)
'//		add 3 columns at column index 9 (Full Address, Phone1, Phone2)
'//		insert 3 columns at column index 13 (truepeople, 411, whitepages)
'//		write column headings in 2 cells row indexes 3,4 column indexes 13-15
'//			"search/truepeople", "search/411", "search/whitepages"

'//	constants.
const ONE_INCH=2540

const COL_FULLNAME=2		'// found name
const COL_NUMBER=3			'// house number
const COL_PREDIR=4			'// street pre-direction
const COL_STREET=5			'// street name
const COL_SUFFIX=6			'// street suffix (e.g. Ave)
const COL_POSTDIR=7			'// street post direction
const COL_UNIT=8			'// unit/apt #
const YELLOW=16776960		'// decimal value of YELLOW color
const MDYY=30				'// number format M/D/YYY
const LJUST=1		'// left-justify HoriJustify				'// mod052020
const CJUST=2		'// center HoriJustify						'// mod052020
const RJUST=3		'// right-justify HoriJustify				'// mod052320
const COL_FULLADDR=13
const COL_CONGTERR=14
const COL_RECDATE=15
const COL_DELPENDING=16

const ROW_HEADING=4

const COL_AREA=0
const ROW_AREA=0
const COL_CITY=8		'// I
const COL_ZIP = 10
const COL_ICITY=1
const ROW_ICITY=2
const COL_IZIP=2
const ROW_DATE=1
const COL_DATE=2
const ROW_BASE=5
const COL_UNITS=0		'// "Units shown:"
const ROW_UNITS=1
const COL_FUNITS=1		'// "=COUNTA(A6:A298)"

'// new header locations 9/2/20
const COL_SUBTERR=0		'// "SubTerritory"
const ROW_SUBTERR=3
const COL_TERRID=2		'// "CongTerrID"
const ROW_TERRID=3
const COL_PROPID=3		'// "Property ID"
const ROW_PROPID=0
const ROW_OWNER=1		'// "Owner"
const ROW_STRADDR=2		'// "Streets/Addrs"
'// end new header locations 9/2/20
const COL_SEARCH=13		'//	search/truepeople
const COL_RUPHONE=12	'// RefUSA Phone column
const COL_DONOTCALL=16		'// do not call
const COL_RSO=17			'// registered sex offender
const COL_FOREIGN=18		'// foreign language

'//	local variables.
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim oCols	As Object		'// .Columns this sheet
dim lThisRow as long		'// current row selected on sheet
dim oMrgRange	As Object	'// merge range

'// processing variables.
dim oCell 		As Object	'// transient cell data
dim	i			As Integer	'// loop counter
dim nRowCount	As Integer	'// active rows count
dim nRowsProcessed	As Integer	'// processed rows count
dim sFullAddress	As String	'// full address string
dim dTodaysDate	As Double	'// today's date NOW()
dim sTerrID		As String	'// territory ID from D4

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns

	'// insert 4 rows at top of sheet
	oSheet.Rows.insertByIndex(0, 4)	'// insert new category 1 row
	'// set up heading information
	'// merge columns 0,1,2 in row 0 "&lt;AREA NAME&gt;"
	'// column 0, row 1 "Units shown"
	'// column 1, row 1 formula "=COUNTA(A6:A1298)
	'// column 0, row 2 "City", row 3 "Street"
	'// columns 1,2,3 row 3 merged "&lt;street list&gt;"
	'// column 3, row 1 set date
	'// column 3, row 2 set zip from cell data row 5 cell 10
	'// column 1, row 2 set city from cell data row 5 cell 8


	'// set header information dependent on RefUSA import columns
	'// set &lt;AREA NAME&gt; in header
	oCell = oSheet.getCellByPosition(COL_AREA, ROW_AREA)
	oCell.String = "Territory n&gt;"
	'// Merge cells A1-C1.
	oMrgRange = oRange
	oMrgRange.Sheet = oRange.Sheet
	oMrgRange.StartColumn = 0	'// $A
	oMrgRange.EndColumn = 2		'// $C
	oMrgRange.StartRow = 0
	oMrgRange.EndRow =0
	SetSelection(oMrgRange)
	MergeNCenter()
	
	
'// K6 has Zip, I6 has City
dim sCity	As String	'// city from import data
dim sZip	As String	'// zip code from import data	
	oCell = oSheet.getCellByPosition(COL_CITY, ROW_BASE)
	sCity = oCell.String
	oCell = oSheet.getCellByPosition(COL_ZIP, ROW_BASE)
	sZip = oCell.String
	oCell = oSheet.getCellByPosition(COL_ICITY-1, ROW_ICITY)
	oCell.String = "City"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_ICITY, ROW_ICITY)
	oCell.String = sCity
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_IZIP, ROW_ICITY)
	oCell.String = sZip
	oCell.HoriJustify = CJUST
	
	
	'// Units shown header and formula.
	oCell = oSheet.getCellByPosition(COL_UNITS, ROW_UNITS)
	oCell.String = "Units shown:"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_FUNITS, ROW_UNITS)
	oCell.setFormula("=COUNTA(A6:A1298)")
	SetColWidth(COL_UNITS, 1.0)

const COL_A=0
const COL_B=1
const COL_C=2
const COL_D=3
const COL_E=4
const COL_H=7
const ROW_1=0
const ROW_2=1
const ROW_3=2
const ROW_4=3
	'// A4 = "SubTerritory, B4 =""
	oCell = oSheet.getCellByPosition(COL_A, ROW_4)
	oCell.String = "SubTerritory"
	oCell = oSheet.getCellByPosition(COL_B, ROW_4)
	oCell.String = ""
	
	'// C4 = "CongTerrID", D4 = "&lt;territory_number&gt;"
	oCell = oSheet.getCellByPosition(COL_C, ROW_4)
	oCell.String = "CongTerrID"
	oCell = oSheet.getCellByPosition(COL_D, ROW_4)
	oCell.String = "&lt;territory-number&gt;"
	
	'// D1 - D3 = "Property ID", "Owner", "Streets-Address(s)"
	oCell = oSheet.getCellByPosition(COL_D, ROW_1)
	oCell.String = "Property ID"
	oCell = oSheet.getCellByPosition(COL_D, ROW_2)
	oCell.String = "Owner"
	oCell = oSheet.getCellByPosition(COL_D, ROW_3)
	oCell.String = "Streets-Address(s)"

	'// E1 - E3 = "-", "-", "All streets in Territory &lt;territory_number&gt;"
	oCell = oSheet.getCellByPosition(COL_E, ROW_1)
	oCell.String = "-"
	oCell = oSheet.getCellByPosition(COL_E, ROW_2)
	oCell.String = "-"
	oCell = oSheet.getCellByPosition(COL_E, ROW_3)
	oCell.String = "All streets in Territory &lt;territory_number&gt;"
	
	'// H1 = "Terr-RawData formatted sheet"
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Terr-RawData formatted sheet"
	
'//	Define new columns at end FullAddress, CongTerr, RecordDate, DeletePending	
	'// define column at end "FullAddress"
'	oSheet.Columns.insertByIndex(COL_FULLADDR, 1)
	oCell = oSheet.getCellByPosition(COL_FULLADDR, ROW_HEADING)
	oCell.String = "FullAddress"
	oCell.HoriJustify = CJUST
	oCols(COL_FULLADDR).setPropertyValue("Width", 1.75*ONE_INCH)

	oCell = oSheet.getCellByPosition(COL_CONGTERR, ROW_HEADING)
	oCell.String = "CongTerr"
	oCell.HoriJustify = CJUST
	oCols(COL_CONGTERR).setPropertyValue("Width", 0.75*ONE_INCH)

	oCell = oSheet.getCellByPosition(COL_RECDATE, ROW_HEADING)
	oCell.String = "RecordDate"
	oCell.HoriJustify = CJUST
	oCols(COL_RECDATE).setPropertyValue("Width", 2.0*ONE_INCH)

	oCell = oSheet.getCellByPosition(COL_DELPENDING, ROW_HEADING)
	oCell.String = "DelPending"
	oCell.HoriJustify = CJUST
	oCols(COL_DELPENDING).setPropertyValue("Width", 0.75*ONE_INCH)

	'// loop on all active rows
	'// set COL_DELPENDING.Value = 0
	'//	set COL_RECDATE = Now(); .NumberFormat=30
	'//	set COL_CONG_TERR = sCongTerr
	'// set COL_FULLADDR = fsConcatRawAddress( lThisRow )
	dTodaysDate = Now()
	lThisRow = ROW_HEADING
	nRowsProcessed = 0
	oCell = oSheet.getCellByPosition(COL_FUNITS, ROW_UNITS)
	nRowCount = oCell.getValue()
	for i = 0 to nRowCount-1
		lThisRow = lThisRow + 1
		'// set COL_DELPENDING.Value = 0
		oCell = oSheet.getCellByPosition(COL_DELPENDING, lThisRow)
		oCell.setValue(0)
		
		'//	set COL_RECDATE = Now(); .NumberFormat=30
		oCell = oSheet.getCellByPosition(COL_RECDATE, lThisRow)
		oCell.setValue(dTodaysDate)
		oCell.NumberFormat = MDYY
		
		'//	set COL_CONG_TERR = sCongTerr
		oCell = oSheet.getCellByPosition(COL_CONGTERR, lThisRow)
		oCell.setFormula("=$D$4")

		'// because may skip, concatenate address last
		sFullAddress = fsConcatRawAddress(lThisRow)
		oCell = oSheet.getCellByPosition(COL_FULLADDR, lThisRow)
		if Len(sFullAddress) = 0 then
			oCell.String = ""
			oCell.CellBackColor = YELLOW
			msgbox("At row " + lThisRow + "... empty address - skipped")
		else
			oCell.String = UCase(sFullAddress)
		endif	'// end empty address fields conditional

NextFor:
		nRowsProcessed = nRowsProcessed + 1
	next i
	
if true then
	GoTo EndOldCode
endif
'//---------------------------------------------------------------
	'// remove 4 columns at Full Address column
	oSheet.Columns.removeByIndex(COL_FULLADDR, 4)
	
	'// insert 3 columns at Full Address column
	'// Headings "Full Address", "Phone1", "Phone2"
	oSheet.Columns.insertByIndex(COL_FULLADDR, 3)
	
	'// Now all columns in place; set headings
	'// Date to header
	oCell = oSheet.getCellByPosition(COL_DATE, ROW_DATE)
	oCell.setValue(Now())					'// time stamp

'	oCell.String = Date
	oCell.Text.NumberFormat = MDYY
	oCell.HoriJustify = CJUST
	
	'// set column headings
	oCell = oSheet.getCellByPosition(COL_IZIP, ROW_ICITY)
	oCell.String = sZip
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_FULLADDR, ROW_HEADING)
	oCell.String = "Full Address"
	oCell.HoriJustify = CJUST
	SetColWidth(COL_FULLADDR, 1.75)
	oCell = oSheet.getCellByPosition(COL_FULLADDR+1, ROW_HEADING)
	oCell.String = "Phone1"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_FULLADDR+2, ROW_HEADING)
	oCell.String = "Phone2"
	oCell.HoriJustify = CJUST
	
	'// place "RefUSA" heading above its phone heading.
	oCell = oSheet.getCellByPosition(COL_RUPHONE, ROW_HEADING-1)
	oCell.String = "RefUSA"
	
	'// place column headings on search/truepeople, search/411,
	'//  search/whitepages
	oCell = oSheet.getCellByPosition(COL_SEARCH, ROW_HEADING)
	oCell.String = "truepeople"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_SEARCH+1, ROW_HEADING)
	oCell.String = "411"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_SEARCH+2, ROW_HEADING)
	oCell.String = "whitepages"
	oCell.HoriJustify = CJUST

	oCell = oSheet.getCellByPosition(COL_SEARCH, ROW_HEADING-1)
	oCell.String = "search"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_SEARCH+1, ROW_HEADING-1)
	oCell.String = "search"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_SEARCH+2, ROW_HEADING-1)
	oCell.String = "search"
	oCell.HoriJustify = CJUST

	'// place column headings on DoNotCall, RSO, and Foreign
	oCell = oSheet.getCellByPosition(COL_DONOTCALL, ROW_HEADING)
	oCell.String = "DoNotCall"
	oCell.HoriJustify = CJUST
	
	oCell = oSheet.getCellByPosition(COL_RSO, ROW_HEADING)
	oCell.String = "RSO"
	oCell.HoriJustify = CJUST
	
	oCell = oSheet.getCellByPosition(COL_FOREIGN, ROW_HEADING)
	oCell.String = "Foreign"
	oCell.HoriJustify = CJUST
	
	'// Columns fixed; now set remaining header information
	'// new header locations 9/2/20
'const COL_SUBTERR=0		'// "SubTerritory"
'const ROW_SUBTERR=3
'const COL_TERRID=2		'// "CongTerrID"
'const ROW_TERRID=3
'const COL_PROPID=3		'// "Property ID"
'const ROW_PROPID=0
'const ROW_OWNER=0		'// "Owner"
'const ROW_STRADDR=2		'// "Streets/Addrs"
'// end new header locations 9/2/20

	oCell = oSheet.getCellByPosition(COL_SUBTERR, ROW_SUBTERR)
	oCell.String = "SubTerritory"
	oCell.HoriJustify = RJUST

	oCell = oSheet.getCellByPosition(COL_TERRID, ROW_TERRID)
	oCell.String = "CongTerrID"
	oCell.HoriJustify = RJUST

	oCell = oSheet.getCellByPosition(COL_PROPID, ROW_PROPID)
	oCell.String = "Property ID"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_PROPID+1, ROW_PROPID)
	oCell.String = "&lt;OwnerParcel&gt;"
	oCell.HoriJustify = CJUST
	
	oCell = oSheet.getCellByPosition(COL_PROPID, ROW_OWNER)
	oCell.String = "Owner"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_PROPID+1, ROW_OWNER)
	oCell.String = "&lt;OwnerName1&gt;"
	oCell.HoriJustify = LJUST
	
	oCell = oSheet.getCellByPosition(COL_PROPID, ROW_STRADDR)
	oCell.String = "Streets/Addrs"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_PROPID+1, ROW_STRADDR)
	oCell.String = "&lt;Streets-Address(s)&gt;"

	'// kill AutoCalculate
	KillAutoRecalc()

	'// Set phone column widths.
	SetPhoneWidths()

	'// Set full address column width.
	SetFullAddrWidth()

	'// Set search columns widths.
	SetSearchWidths()
	
	'// Merge cells A1-C1.
	oMrgRange = oRange
	oMrgRange.Sheet = oRange.Sheet
	oMrgRange.StartColumn = 0	'// $A
	oMrgRange.EndColumn = 2
	oMrgRange.StartRow = 0
	oMrgRange.EndRow =0
	SetSelection(oMrgRange)
	MergeNCenter()
	
	'// Merge cells E1-G1.
	oMrgRange.StartColumn = 4	'// $E
	oMrgRange.EndColumn = 6	'// $G
	oMrgRange.StartRow = 0
	oMrgRange.EndRow = 0		'// .$1
	SetSelection(oMrgRange)
	MergeNCenter()
	
	'// Merge cells E2-G2
	oMrgRange.StartColumn = 4	'// $E
	oMrgRange.EndColumn = 6	'// $G
	oMrgRange.StartRow = 1
	oMrgRange.EndRow = 1		'// .$2
	SetSelection(oMrgRange)
	MergeNCenter()
	
	'// Merge cells E3-G3.
	oMrgRange.StartColumn = 4	'// $E
	oMrgRange.EndColumn = 6	'// $G
	oMrgRange.StartRow = 2
	oMrgRange.EndRow = 2		'// .$3
	SetSelection(oMrgRange)
	MergeNCenter()
	
'const COL_H=7
'const ROW_1=0
	'// set sheet type at H1 "Admin-Bridge formatted sheet"
	oCell =	oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Admin-Import formatted sheet"
	
	'// select all active rows.
	SelectActiveRows()
	
	'// concatenate addresses
	ConcatAddressM()
	
	'// concatenate names
	ConcatFirstLastM()

	'// select through column S (at column A in last row)
'// 
dim oDocument	As Object
dim oDispatcher	As Object
dim nColumns	As Integer
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	nColumns = ASC("S") - ASC("A")
dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "By"
	args2(0).Value = nColumns
oDispatcher.executeDispatch(oDocument, ".uno:GoRightSel", "", 0, args2())
	SortOnAddress()
	
'//--------------------------------------------------------------------	
EndOldCode:

	'// Freeze header so stays when scrolling
	FreezeView()
	
	'// Bold and center headings
	BoldHeadings()
	SetColWidth(COL_RECDATE, 1.0)
	oCols(COL_FULLADDR).setPropertyValue("Width", 1.75*ONE_INCH)
		
	'// restore user entry range selection.
	SetSelection(oRange)
		
	'// finished
	msgbox("RUDldToRaw complete.")

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("RUDldToRaw - unprocessed error.")
	GoTo NormalExit
	
end sub		'// end RUDldToRaw	9/14/20
