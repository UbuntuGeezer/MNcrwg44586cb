'// FixSCAddressM.bas
'//---------------------------------------------------------------
'// FixSCAddressM - ParseSitus Test for SCPA record extraction.
'//		9/16/20.	wmk.	13:10
'//---------------------------------------------------------------

public sub FixSCAddressM()

'//	Usage.	macro call or
'//			call FixSCAddressM()
'//
'//
'// Entry.	user in PropOwners .csv formatted spreadsheet
'//			user has rows selected to fix addresses in
'//
'//	Exit.	ParseSitus and FixSCPAaddr tested with results displayed
'//
'// Calls.	SelectActiveRows, ParseSitsus, FixSCPAaddr, SetSelection
'//
'//	Modification history.
'//	---------------------
'//	9/16/20.		wmk.	original code
'//
'//	Notes. This sub is included in PropOwners.ods, but maintained with
'// the PolyTerri-Queries in its Associated Files folder. This allows
'// editing outside of LibreCalc, which seems to still have "freeze"
'// issues with certain cursor activity.

'//	constants.
const ROW_HEADING=4			'// row index of headings
const COL_ADDRESS=3			'// column index of Address
const YELLOW=16776960		'// decimal value of YELLOW color

'//	local variables.
dim	oDoc		As Object	'// ThisComponent
dim oSel		As Object	'// current selection
dim oSheet		As Object	'// current sheet
dim iSheetIx	As Integer	'// selected sheet index
dim oRange		As Object	'// selected Range
dim oCell		As Object	'// working cell
dim lCol		As long		'// cell column
dim lRow		As long		'// cell row
dim sFullAddress	As String	'// full street address
dim sNumber		As String
dim sStreet		As String
dim sUnit		As String
dim lThisRow	As long		'// current row processing
dim oActvRange	As Object	'// active rows range
dim nRowCount	As Integer	'// active rows count
dim i			As Integer	'// loop counter
dim nRowsProcessed	As Integer	'// processed rows count
dim sNewAddress	As String	'// newly concatenated address

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

if true then
  GoTo Skip1
endif
'//---------------------------------------------------------------------
	lCol = oRange.StartColumn
	lRow = oRange.StartRow
	oCell = oSheet.getCellByPosition(lCol, lRow)
	
msgbox("Address being tested:" + CHR(13)+CHR(10) _
  + oCell.String)

	sFullAddress = oCell.String
'//---------------------------------------------------------------------
Skip1:
	oActvRange = oSel.RangeAddress
	nRowCount = oActvRange.EndRow - oActvRange.StartRow +1
	lThisRow = oActvRange.StartRow-1
	nRowsProcessed = 0
	
	for i = 0 to nRowCount-1
		lThisRow = lThisRow + 1
		oCell = oSheet.getCellByPosition(COL_ADDRESS, lThisRow)
		sFullAddress = oCell.String
		ParseSitus(sFullAddress, sNumber, sStreet, sUnit)
