'// ConcatFirstLastM.bas
'//---------------------------------------------------------------
'// ConcatFirstLastM - Concatenate first/last name into single field.
'//		9/3/20.	wmk.	08:15
'//---------------------------------------------------------------

public sub ConcatFirstLastM()

'//	Usage.	macro call or
'//			call ConcatFirstLastM()
'//
'// Entry.	user has selected row(s) in which to concatenate name fields
'//			each row should have an empty column to its right in which
'//			to place the concatenated name information
'//
'//	Exit.	concatenated name is in form:
'//			&lt;First Name&gt;&lt;b&gt;&lt;Last Name&gt;
'//			where &lt;b&gt; is a single space
'//			also trim all source fields to eliminate any fields
'//			which were imported as 10-character, right-justified,
'//			space-filled fields
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/3/20.	wmk.	original code; adapted from GenHLinkM
'//
'//	Notes. Column indexes for the first/last name fields are for import
'// spreadsheet taken from ReferenceUSA .xls format spreadsheet

'//	constants.
const COL_FIRST=1			'// first name field
const COL_LAST=0			'// last name field
const COL_UNIT=8			'// unit/apt #
const COL_FULLNAME=2		'// full concatenated name
const YELLOW=16776960		'// decimal value of YELLOW color

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
dim sFirst  	As String		'// first name from current row
dim sLast		As String		'// last name from current row
dim sFullName	As String		'// HYPERTEXT link to store
dim i			As Integer		'// loop counter

'// XCell sheet objects
dim oCell as object			'// generic field

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
		oCell = oSheet.getCellByPosition(COL_FIRST, lThisRow)
		oCell.String = trim(oCell.String)		'// set first name text
		sFirst = oCell.String
		oCell= oSheet.getCellByPosition(COL_LAST, lThisRow)
		oCell.String = trim(oCell.String)
		sLast = oCell.String	'// set  last name set
		sFullName = trim(sFirst + " " + sLast)
		
		oCell = oSheet.getCellByPosition(COL_FULLNAME, lThisRow)
		oCell.String = sFullName
		oCell.HoriJustify = LJUST
		
		if len(sFullName) = 0 then
			oCell.String = ""
			oCell.CellBackColor = YELLOW
			msgbox("At row " + lThisRow + "... empty name - skipped")
		endif	'// end empty address fields conditional
		
Nextfor:
		nRowsProcessed = nRowsProcessed + 1
	next i		'// advance to next row
	
NormalExit:
	msgbox("ConcatFirstLastM complete. " + nRowsProcessed + " rows processed.")
	exit sub
	
ErrorHandler:	
	msgbox("ConcatFirstLastM - unprocessed error.")
	GoTo NormalExit

end sub		'// end ConcatFirstLastM	9/3/20.
