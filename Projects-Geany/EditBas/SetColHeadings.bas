'// SetColHeadings.bas
'//---------------------------------------------------------------
'// SetColHeadings - Set sheet column headings in row 5.
'//		9/21/20.	wmk.	07:20
'//---------------------------------------------------------------

public sub SetColHeadings( psColHeadings() As String )

'//	Usage.	macro call or
'//			call SetColHeadings( sColHeadings() )
'//
'//		sColHeadings = array of column headings to set
'//
'// Entry.	user in sheet where row 5 is column headings
'//
'//	Exit.	row 5 column headings will be set to array strings
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/21/20.		wmk.	original code
'//
'//	Notes.

'//	constants.
const ROW_HEADING=4		'// row index of heading row
const CJUSt=2			'// centered

'//	local variables.
Dim oDoc As Object
Dim oSheet As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisCol as long		'// current column selected on sheet

dim oCell	As Object		'// cell working on
dim i		As Integer		'// loop index
dim	nColLimit	As Integer	'// column limit 0-based

	'// code.
	ON ERROR GOTO ErrorHandler
	nColLimit = UBound(psColHeadings)
	if nColLimit &lt; 0 then
		GoTo NormalExit
	endif	'// end no column headings conditional
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

	for i = 0 to nColLimit
		oCell = oSheet.getCellByPosition(i, ROW_HEADING)
		oCell.String = psColHeadings(i)
		oCell.HoriJustify = CJUST
	next i
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetColHeadings - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetColHeadings		9/21/20
