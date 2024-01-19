'// StripHLinkM.bas
'//---------------------------------------------------------------
'// StripHLinkM - Strip hyperlink function to isolate URL.
'//		8/16/20.	wmk.	15:00
'//---------------------------------------------------------------

public sub StripHLinkM()

'//	Usage.	macro call or
'//			call StripHLinkM()
'//
'//
'// Entry.	user has selected a range of cells in desired row(s) to
'//			strip the HYPERLINK function from, leaving only the URL
'//
'//	Exit.	each row selected has a hperlink added in the COL_HLINK
'//			and COL_HLINK1 columns in the form:
'//			HYPERLINK("&lt;url&gt;") that will allow the end-user to click
'//			on the hyperlink url and be taken to a search webpage
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	8/16/20.	wmk.	original code; adapted from GenHLinkM; constants
'// 					moved to Module1 header; modified to de-link
'//						3 URL columns
'//
'// Wishlist. Pick up COL_ADDR and COL_HLINK from predetermined cells
'// in the oRange.Sheet.
'//	Method. for each row, extract HYPERLINK field from COL_HLINK
'//		and COL_HLINK1
'//		use cell.getFormula() function to extract formula from cell
'//     strip "=HYPERLINK(" from front of formula, ","Click to search")"
'//     from end of formula to isolate URL
'//		use cell.setFormula() function to set "=" at front of URL and
'//       store as new formula

'// constants.
'// see Module header...

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
dim sURL	As String		'// url generated from sAddress
dim sHLink	As String		'// HYPERTEXT link to store
dim i		As Integer		'// loop counter
dim sLink	As String		'// existing HYPERTEXT link string
dim nLinkLen	As	Integer	'// existing link length
dim nURLLen	As Integer		'// URL length

'// XCell sheet objects
dim oCellHLink as object	'// hyperlink field

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
		
		'// delink truepeoplesearch
		oCellHLink = oSheet.getCellByPosition(COL_HLINK, lThisRow)
		sHLink = oCellHLink.getFormula()	'// retrieve hyperlink formula text
		nLinkLen = Len(sHLink)
		if nLinkLen = 0 then
			msgBox("StripHLinkM - empty hyperlink field; skipping.")
			oCellAddr.CellBackColor = YELLOW
			GoTo NextLink
		endif	'// null string - alert user, mark row and continue

		'// strip "=HYPERLINK(" from front of function string
		'// strip ", "Click here to search"" from back of function
		nStripLen = Len("=HYPERLINK(")
		sURL = "=" + Right(sHLink, nLinkLen-nStripLen)
		nURLLen = Len(sURL)
		nStripLen = Len("," + CHR(34) + "Click here to search" + CHR(34) + ")")
		sURL = Left(sURL, nURLLen-nStripLen)
		oCellHLink.setFormula(sURL)
msgbox("StripHLinkM - URL =" +CHR(13)+CHR(10) + sURL)

NextLink:
		'// delink 411.com
		oCellHLink = oSheet.getCellByPosition(COL_HLINK1, lThisRow)
		sHLink = oCellHLink.getFormula()	'// retrieve hyperlink formula text
		nLinkLen = Len(sHLink)
		if nLinkLen = 0 then
			msgBox("StripHLinkM - empty hyperlink field; skipping.")
			oCellAddr.CellBackColor = YELLOW
			GoTo Nextfor
		endif	'// null string - alert user, mark row and continue

		'// strip "=HYPERLINK(" from front of function string
		'// strip ", "Click here to search"" from back of function
		nStripLen = Len("=HYPERLINK(")
		sURL = "=" + Right(sHLink, nLinkLen-nStripLen)
		nURLLen = Len(sURL)
		nStripLen = Len("," + CHR(34) + "Click here to search" + CHR(34) + ")")
		sURL = Left(sURL, nURLLen-nStripLen)
		oCellHLink.setFormula(sURL)
msgbox("StripHLinkM - URL =" +CHR(13)+CHR(10) + sURL)

NextLink2:
		'// delink whitepages.com
		oCellHLink = oSheet.getCellByPosition(COL_HLINK2, lThisRow)
		sHLink = oCellHLink.getFormula()	'// retrieve hyperlink formula text
		nLinkLen = Len(sHLink)
		if nLinkLen = 0 then
			msgBox("StripHLinkM - empty hyperlink field; skipping.")
			oCellAddr.CellBackColor = YELLOW
			GoTo Nextfor
		endif	'// null string - alert user, mark row and continue

		'// strip "=HYPERLINK(" from front of function string
		'// strip ", "Click here to search"" from back of function
		nStripLen = Len("=HYPERLINK(")
		sURL = "=" + Right(sHLink, nLinkLen-nStripLen)
		nURLLen = Len(sURL)
		nStripLen = Len("," + CHR(34) + "Click here to search" + CHR(34) + ")")
		sURL = Left(sURL, nURLLen-nStripLen)
		oCellHLink.setFormula(sURL)
msgbox("StripHLinkM - URL =" +CHR(13)+CHR(10) + sURL)
		
Nextfor:
		nRowsProcessed = nRowsProcessed + 1

	next i
	
	msgbox("StripHLinkM - " + nRowsProcessed + " rows processed")
	
NormalExit:
	exit sub
	
ErrorHandler:
   msgbox("StripHLinkM - unprocessed error.")
   GoTo NormalExit

end sub		'// end StripHLinkM	8/16/20.
