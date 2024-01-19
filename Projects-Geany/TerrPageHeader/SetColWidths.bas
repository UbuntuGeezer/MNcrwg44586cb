'// SetColWidths.bas
'//---------------------------------------------------------------
'// SetColWidths - Set sheet column headings in specified doc.
'//		11/21/20.	wmk.	09:30
'//---------------------------------------------------------------

public sub SetColWidths( poDoc As Object, pnSheetIX As Integer, _
						 panColWidths() As Integer )

'//	Usage.	macro call or
'//			call SetColWidths( nColWidths() )
'//
'//		poDoc = workbook
'//		pnSheetIx = sheet index
'//		sColWidths = array of column headings to set
'//
'// Entry.	user in sheet where column widths are to be set
'//
'//	Exit.	starting with column index 0, columns widths will be set
'//			from array values
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
dim oCols	As Object		'// .Columns array current sheet

dim oCell	As Object		'// cell working on
dim i		As Integer		'// loop index
dim	nColLimit	As Integer	'// column limit 0-based

	'// code.
	ON ERROR GOTO ErrorHandler
	nColLimit = UBound(panColWidths)
	if nColLimit < 0 then
		GoTo NormalExit
	endif	'// end no column headings conditional
	oDoc = poDoc
'	oSel = oDoc.getCurrentSelection()
'	oRange = oSel.RangeAddress
	iSheetIx = pnSheetIx
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns
	
	for i = 0 to nColLimit
		oCols(i).setPropertyValue("Width", panColWidths(i))
	next i
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetColWidths - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetColWidths		11/21/21.	09:30
