'// GenHLinkM.bas
'//---------------------------------------------------------------
'// GenHLinkM - Generate hyperlink(s) for selected range.
'//		8/16/20.	wmk.	14:00
'//---------------------------------------------------------------

public sub GenHLinkM()

'//	Usage.	macro call or
'//			call GenHLinkM()
'//
'//
'// Entry.	user has selected a range of cells in desired row(s) to
'//			extract the address field from the COL_ADDR column index
'//			and create a hyperlink to look up phone/address information
'//
'//	Exit.	each row selected has a hperlink added in the COL_HLINK
'//			column in the form:
'//			HYPERLINK("&lt;url&gt;") that will allow the end-user to click
'//			on the hyperlink url and be taken to a search webpage
'//
'// Calls.	sGenPhoneURL, sGen411URL
'//
'//	Modification history.
'//	---------------------
'//	8/11/20.	wmk.	original code; adapted from InsRowM.bas
'// 8/13/20.	wmk.	call to sGen411URL added for 411.com lookup;
'//						"=" added in front and "Click here to search"
'//						added to cell
'// 8/16/20.	wmk.	call to sGenWhtPgesURL added for whitepages.com
'//						lookup; constants moved to module header
'//
'//	Notes. The curreht sGenPhoneURL only generates links to the
'// truepeoplesearch.com website. It could possible be expanded in the
'//	future to be able to use.
'// Wishlist. Pick up COL_ADDR and COL_HLINK from predetermined cells
'// in the oRange.Sheet.
'//	Method. for each row, extract address field from COL_ADDR
'//		use sGenPhoneURL to generate url from address
'//     add HYPERLINK("&lt;url&gt;") to create hyperlink
'//		store hyperlink in row at COL_HLINK

'//	constants.
'// see Module header...
'const COL_ADDR=1		'// column index for extracting address
'const COL_HLINK=4		'// column for truepeople hyperlink
'const COL_HLINK1=5		'// column for 411 hyperlink
'const COL_CITY=1		'// column index for city
'const ROW_CITY=2		'// row index for city -B3

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
dim nRowsProcessed	 As Integer	'// count of rows processed
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
		oCellAddr = oSheet.getCellByPosition(COL_ADDR, lThisRow)
		oCellHLink = oSheet.getCellByPosition(COL_HLINK, lThisRow)
		sAddress = trim(oCellAddr.String)		'// set cell address text
		if len(sAddress) = 0 then
			msgBox("GenHLinkM - empty address field; halting process.")
			oCellAddr.CellBackColor = YELLOW
			exit for
		endif	'// null string - alert user, mark row and bail

		'// see what piece of oCellHLink contains HYPERLINK.. maybe function?
'XRay oCellHLink
'sLink = oCellHLink.String
'msgbox("HLink cell .String = '" + sLink + "'"
'sLink = oCellHLink.getFormula()
'msgbox("HLink cell .Formula = '" + sLink + "'"
'sLink = oCellHLink.Hyperlink
'msgbox("HLink cell .Hyperlink = '" + sLink + "'"
'        if true then
'        if false then
'           GoTo Nextfor
'        endif

		'// Generate truepeople.. URL
		sURL = sGenPhoneURL(sAddress, sCity)
		sHLink = "="+TXT_HLINK + sURL + CHR(34)+";"+CHR(34) _
	 + "Click here to search" + CHR(34) + ")"
'msgbox("Double quote = " + ASC("""") )
'msgbox("Generated URL =" + CHR(13) + CHR(10) _
'		+ "'" + sURL + "'" + CHR(13) + CHR(10) _
'		+ "Generated Hypertext link = " + CHR(13) + CHR(10) _
'		+ "'" + sHLink )
'		oCellHLink.String = sHLink
		oCellHLink.setFormula(sHLink)
		
		'// Generate 411.. URL
		sURL = sGen411URL(sAddress, sCity)
		sHLink = "="+TXT_HLINK + sURL + CHR(34)+";"+CHR(34) _
	 + "Click here to search" + CHR(34) + ")"
'msgbox("Generated URL =" + CHR(13) + CHR(10) _
'		+ "'" + sURL + "'" + CHR(13) + CHR(10) _
'		+ "Generated Hypertext link = " + CHR(13) + CHR(10) _
'		+ "'" + sHLink )
		oCellHLink = oSheet.getCellByPosition(COL_HLINK1, lThisRow)
		oCellHLink.setFormula(sHLink)

		'// Generate whitepages.. URL
		sURL = sGenWhtPgesURL(sAddress, sCity)
		sHLink = "="+TXT_HLINK + sURL + CHR(34)+";"+CHR(34) _
	 + "Click here to search" + CHR(34) + ")"
'msgbox("Generated URL =" + CHR(13) + CHR(10) _
'		+ "'" + sURL + "'" + CHR(13) + CHR(10) _
'		+ "Generated Hypertext link = " + CHR(13) + CHR(10) _
'		+ "'" + sHLink )
		oCellHLink = oSheet.getCellByPosition(COL_HLINK2, lThisRow)
		oCellHLink.setFormula(sHLink)
		
Nextfor:
		nRowsProcessed = nRowsProcessed + 1

	next i
	
	msgbox("GenHLinkM - " + nRowsProcessed + " rows processed")
	
NormalExit:
	exit sub
	
ErrorHandler:
   msgbox("GenHLinkM - unprocessed error.")
   GoTo NormalExit

end sub		'// end GenHLinkM	8/16/20.
