'// ConcatAddressM.bas
'//---------------------------------------------------------------
'// ConcatAddressM - Concatenate Number, Predirectional, Street,
'//	  Street Suffix, Unit into single address field.
'//		10/12/20.	wmk.	11:00
'//---------------------------------------------------------------

public sub ConcatAddressM()

'//	Usage.	macro call or
'//			call ConcatAddressM()
'//
'// Entry.	user has selected row(s) in which to concatenate address fields
'//			each row should have an empty column to its right in which
'//			to place the concatenated address information
'//
'//	Exit.	concatenated address is in form:
'//			&lt;number&gt;&lt;b&gt;&lt;b&gt;&lt;b&gt;&lt;Predir&gt;&lt;b&gt;&lt;Street&gt;&lt;b&gt;&lt;Street Suffix&gt;&lt;b_35&gt;&lt;Unit&gt;
'//			where &lt;b&gt; is a single space
'//			&lt;b_35&gt; is blank field ending in column 35
'//			also trim all source fields to eliminate house numbers
'//			which were imported as 10-character, right-justified,
'//			space-filled fields
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	8/21/20.	wmk.	original code; adapted from GenHLinkM
'//	8/22/20.	wmk.	modified to replace all address fields with
'//						trimmed strings
'//	8/28/20.	wmk.	source and target columns advanced by 1 to acccount for
'//						new "Found Name" column in standardized
'//						territory worksheet
'//	9/3/20.		wmk.	shift concatentated address to uppercase for consistency
'//						with addresses imported from SC-PA
'//	9/15/20.	wmk.	modified to insert 3 spaces after number token
'//						to match SCPA download of addresses; if there is
'//						a "pre-direction" token, it is now moved to the
'//						"post-direction" to make directional entries consistent
'//						with RefUSA download data
'//	9/16/20.	wmk.	fix bug introduced with 9/15 modifications where
'//						full address being stored in wrong column
'//	9/18/20.	wmk.	mod to space out unit 17 spaces from end of street;
'//						dead code deleted
'//	10/8/20.	wmk.	mod to space out unit 16 instead of 17 spaces from
'//						end of street
'// 10/12/20.	wmk.	mod to space out unit to always start in col 36
'//
'//	Notes. Column indexes for the address fields are for import spreadsheet
'// taken from ReferenceUSA .xls format spreadsheet

'//	constants.
const COL_NUMBER=3			'// house number
const COL_PREDIR=4			'// street pre-direction
const COL_STREET=5			'// street name
const COL_SUFFIX=6			'// street suffix (e.g. Ave)
const COL_POSTDIR=7			'// street post direction
const COL_UNIT=8			'// unit/apt #
const COL_FULLADDR=9		'// full concatenated address
const YELLOW=16776960		'// decimal value of YELLOW color
const BLANKS_30="                              "	'// exactly 30 spaces
const BLANKS_17="                 "	'// exactly 17 spaces
const BLANKS_16="                "	'// exactly 16 spaces
const BLANKS_3="   "				'// exactly 3 spaces
const BLANKS_2="  "					'// exactly 2 spaces

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
dim sPrefix	As String		'// url generated from sAddress
dim sStreet	As String		'// HYPERTEXT link to store
dim sSuffix As String		'// 
dim sUnit	As String	
dim i		As Integer		'// loop counter
dim nBlanks		As Integer		'// space count to insert to fill 35 columns

'// XCell sheet objects
dim oCellAddr as object		'// address field
dim oCellHLink as object	'// hyperlink field
dim oCity 	As object		'// city for sheet
dim sCity	As String		'// city from sheet
dim sPreDir	As String		'// prefix direction
dim sPostDir	As String		'// post-direction token

'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	nRowsProcessed = 0		'// clear processed count

	'// set row processing from oRange information
	lThisRow = oRange.StartRow - 1		'// start at -1 since increment first
	nRowCount = oRange.EndRow - lThisRow	'// set row count to process
	for i = 1 to nRowCount
		lThisRow = lThisRow + 1		'// advance current row
		oCellAddr = oSheet.getCellByPosition(COL_NUMBER, lThisRow)
		oCellAddr.String = trim(oCellAddr.String)		
		sAddress = oCellAddr.String						'// set number token text
		oCellAddr.String = trim(oCellAddr.String)		'// set cell address text
		oCellAddr = oSheet.getCellByPosition(COL_PREDIR, lThisRow)
		sPreDir = oCellAddr.String				'// save pre-direction for post..
		oCellAddr = oSheet.getCellByPosition(COL_STREET, lThisRow)
		oCellAddr.String = trim(oCellAddr.String)		'// set street token
		sAddress = sAddress + BLANKS_3 + oCellAddr.String	'// 3 spaces past number
		oCellAddr = oSheet.getCellByPosition(COL_SUFFIX, lThisRow)
		oCellAddr.String = trim(oCellAddr.String)
		sAddress = sAddress + " " + oCellAddr.String	'// set Ave, St, etc
		oCellAddr = oSheet.getCellByPosition(COL_POSTDIR, lThisRow)
'		oCellAddr.String = trim(oCellAddr.String)		'// get post-direction
		sPostDir = trim(oCellAddr.String)		'// get post-direction
		if len(sPreDir) &gt; 0 then
			sAddress = sAddress + " " + sPreDir			'// set non-empty pre-direction
		endif
	    if len(sPostDir) &gt; 0 then
			sAddress = sAddress + " " + sPostDir	'// set post-direction
	    endif	'// end post-direction present conditional
		oCellAddr = oSheet.getCellByPosition(COL_UNIT, lThisRow)
		sUnit = trim(oCellAddr.String)
		'// add unit text spaced out to col 36
		if len(sUnit) &gt; 0 then
            nBlanks = 35 - len(sAddress)		'// get space count
            sAddress = sAddress + left(BLANKS_30, nBlanks) + sUnit
'			sAddress = sAddress + BLANKS_16 + oCellAddr.String	'// add unit text
		endif
	
		oCellAddr = oSheet.getCellByPosition(COL_FULLADDR, lThisRow)
		sAddress = trim(sAddress)
		if len(sAddress) = 0 then
			oCellAddr.String = ""
			oCellAddr.CellBackColor = YELLOW
			msgbox("At row " + lThisRow + "... empty address - skipped")
		else
			oCellAddr.String = UCase(sAddress)
		endif	'// end empty address fields conditional
		
Nextfor:
		nRowsProcessed = nRowsProcessed + 1
	next i		'// advance to next row
	
NormalExit:
	msgbox("ConcatAddressM complete. " + nRowsProcessed + " rows processed.")
	exit sub
	
ErrorHandler:	
	msgbox("ConcatAddressM - unprocessed error.")
	GoTo NormalExit

end sub		'// end ConcatAddressM	10/12/20.
