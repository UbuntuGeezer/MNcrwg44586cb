'// fsConcatRawAddress.bas
'//---------------------------------------------------------------
'// fsConcatRawAddress - Concatenate Number, Predirectional, Street,
'//	  Street Suffix, Unit into single address field.
'//		9/18/20.	wmk.	12:00
'//---------------------------------------------------------------

public function fsConcatRawAddress(plRow As long) As String

'//	Usage.	macro call or
'//			sFullAddr = fsConcatRawAddress( lRow )
'//
'//		lRow = row containing address information to concatenate
'//				in RefUSA raw data columns C - H
'//
'// Entry.	user has selected row(s) in which to concatenate address fields
'//			each row should have an empty column to its right in which
'//			to place the concatenated address information
'//
'//	Exit.	concatenated address is in form:
'//			&lt;Number&gt;&lt;b*3&gt;&lt;Street&gt;&lt;b&gt;&lt;Street Suffix&gt;&lt;b*17&gt;&lt;Unit&gt;
'//			where &lt;b&gt; is a single space
'//			also trim all source fields to eliminate house numbers
'//			which were imported as 10-character, right-justified,
'//			space-filled fields
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/13//20.	wmk.	original code; adapted from ConcatAddressM
'//	9/15/20.	wmk.	modified to insert 3 spaces between number token
'//						and street token for SCPA address compatibility
'//						also move pre-direction to post-direction space
'//	9/18/20.	wmk.	constants added for spacing fields
'//
'//	Notes. Column indexes for the address fields are for raw .csv spreadsheet
'// taken from ReferenceUSA download.

'//	constants.
const COL_NUMBER=2			'// house number
const COL_PREDIR=3			'// street pre-direction
const COL_STREET=4			'// street name
const COL_SUFFIX=5			'// street suffix (e.g. Ave)
const COL_POSTDIR=6			'// street post direction
const COL_UNIT=7			'// unit/apt #
const YELLOW=16776960		'// decimal value of YELLOW color
const BLANKS_17="                 "	'// exactly 17 spaces
const BLANKS_3="   "				'// exactly 3 spaces
const BLANKS_2="  "					'// exactly 2 spaces

'//	local variables.
dim sRetValue	As String	'// returned value
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet

'// processing variables.
dim sAddress As String		'// address field from current row
dim sPrefix	As String		'// url generated from sAddress
dim sStreet	As String		'// HYPERTEXT link to store
dim sSuffix As String		'// 
dim sUnit	As String
dim sPreDir	As String		'// pre-direction letter

'// XCell sheet objects
dim oCellAddr as object		'// address field
dim oCity 	As object		'// city for sheet
dim sCity	As String		'// city from sheet

'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = ""
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	lThisRow = plRow

	'// Concatenate address
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
	oCellAddr.String = trim(oCellAddr.String)		'// get post-direction
	if len(sPreDir) &gt; 0 then
		sAddress = sAddress + " " + sPreDir			'// set non-empty pre-direction
	endif
	if len(oCellAddr.String) &gt; 0 then
		sAddress = sAddress + " " + oCellAddr.String	'// set post-direction
	endif
	oCellAddr = oSheet.getCellByPosition(COL_UNIT, lThisRow)
	oCellAddr.String = trim(oCellAddr.String)
	if len(oCellAddr.String) &gt; 0 then
		sAddress = sAddress + BLANKS_17 + oCellAddr.String	'// add unit text
	endif

	sRetValue = trim(sAddress)

NormalExit:
	fsConcatRawAddress = sRetValue
'	msgbox("fsConcatRawAddress complete. " + nRowsProcessed + " rows processed.")
	exit function
	
ErrorHandler:	
	msgbox("fsConcatRawAddress - unprocessed error.")
	GoTo NormalExit

end function	'// end fsConcatRawAddress	9/18/20.
