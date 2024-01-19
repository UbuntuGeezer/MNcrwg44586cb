'// FixSCUnitAddrM.bas
'//-----------------------------------------------------
'// FixSCUnitAddrM - Fix UnitAddress fields by stripping unit token.
'//		9/22/20.	wmk.	12:00
'//---------------------------------------------------------------------

public sub FixSCUnitAddrM()

'//	Usage.	macro call or
'//			call FixSCUnitAddrM()
'//
'// Entry.	Admin-SCEdit formatted sheet is active; user has selected a
'//			range of cells in desired row(s) to
'//			extract the address field from the COL_ADDR column index
'//			strip the unit field, if present, and rewrite
'//
'//	Exit.	each row selected has its UnitAddress field modified to
'//			have no unit #; the unit# information is in the SitusAddress
'//			field at the end of each record
'//
'// Calls.	fsStripSCUnit
'//
'//	Modification history.
'//	---------------------
'//	9/22/20.	wmk.	original code; adapted from GenELinkM
'//
'//	Notes. FixSCUnitAddrM accommodates Bridge data extracted using
'// SQL on an SCPA download full/partial database, then placed in a
'// Bridge spreadsheet from the query .csv file.
'// The import goes through several phases.
'//	The 1st phase is to an Admin-Bridge spreadsheet by taking the
'//	query data and running the SCBridgeToBridge utility on it.
'//
'// The 2nd phase is, using the Admin-Bridge sheet, an Admin-SCEdit sheet
'// is generated that is simplified for data entry/checking. The Admin-SCEdit
'// sheet contains the hyperlinks to search truepeople, 411, and whitepages.
'// GenELinkM is used to place the hyperlinks in the Admin-SCEdit sheet, but
'// before GenELinkM can generate proper links, the unit#s need to be removed
'// from the SC Bridge UnitAddress fields. The original unit information is
'// still preserved in the SitusAddress field near the end of each record.
'//
'//	If there is newer information in the searches, the address records can be
'// edited to either add/change names/phone numbers.
'//
'// The 3rd phase is the Pub-Territory sheet that is generated to go out
'// as a territory sheet to the territory servant and, eventually to the
'// publisher who checks out the territory.
'//
'//	Method. for each row, extract address field from COL_FULLADDR
'//		run the .String of the field through fsStripSCUnit
'//		replace the .String of the field with the stripped address

'//	constants.
const COL_CITY=1
const ROW_CITY=2

'//	constants.
const COL_UNITADDR=1		'// full address from TerrProps/SplitProps UnitAddress
const YELLOW=16776960		'// decimal value of YELLOW color

'// cell formatting constants.
'const LJUST=1		'// left-justify HoriJustify
'const CJUST=2		'// center HoriJustify
'const RJUST=0		'// right-justify HoriJustify
'const YELLOW=16776960		'// decimal value of YELLOW color
'const TXT_HLINK="HYPERLINK("""	'// HYPERLINK prefix

'//	local variables.
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet

'// processing variables.
dim nRowsProcessed As Integer	'// count of rows processed
dim nRowCount		As Integer	'// # rows to process
dim sAddress As String		'// address field from current row
dim sURL	As String		'// url generated from sAddress
dim sHLink	As String		'// HYPERTEXT link to store
dim i		As Integer		'// loop counter

'// XCell sheet objects
dim oCellAddr as object		'// address field
dim oCellHLink as object	'// hyperlink field
dim oCity 	As object		'// city for sheet
dim sCity	As String		'// city from sheet

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
	'// extract city applying to sheet
	oCity = oSheet.getCellByPosition(COL_CITY, ROW_CITY)
	sCity = trim(oCity.String)
	if len(sCity) = 0 then
		sCity = "Venice"
	endif
	nRowsProcessed = 0		'// clear processed count

	'// set row processing from oRange information
	lThisRow = oRange.StartRow - 1		'// start at -1 since increment first
	nRowCount = oRange.EndRow - lThisRow	'// set row count to process
	for i = 1 to nRowCount
		lThisRow = lThisRow + 1		'// advance current row
		oCellAddr = oSheet.getCellByPosition(COL_UNITADDR, lThisRow)
		sAddress = trim(oCellAddr.String)		'// set cell address text
		if len(sAddress) = 0 then
			msgBox("FixSCUnitAddrM  - empty address field; skipping..") '//
			oCellAddr.CellBackColor = YELLOW
			GoTo Nextfor
		endif	'// null string - alert user, mark row and bail

		'// strip unit from address field and replace
		sAddress = fsStripSCUnit(sAddress)
		oCellAddr.String = sAddress
Nextfor:
		nRowsProcessed = nRowsProcessed + 1

	next i
	
'	msgbox("FixSCUnitAddrM  - " + nRowsProcessed + " rows processed")
		
NormalExit:
	exit sub
	
ErrorHandler:
   msgbox("FixSCUnitAddrM  - unprocessed error.")
   GoTo NormalExit

end sub		'// end FixSCUnitAddrM 	9/21/20.
