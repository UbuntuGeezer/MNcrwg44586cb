'// GenFLinkM.bas
'//---------------------------------------------------------------
'// GenFLinkM - Generate hyperlink(s) for selected range.
'//		7/13/21.	wmk.	10:36
'//---------------------------------------------------------------

public sub GenFLinkM()

'//	Usage.	macro call or
'//			call GenFLinkM()
'//
'//
'// Entry.	user has selected a range of cells in desired row(s) to
'//			extract the address field from the COL_ADDR column index
'//			and create a hyperlink to look up phone/address information
'//			from fastpeoplesearch.com
'//			cell B3 has city name
'//
'//	Exit.	each row selected has a hperlink added in the COL_HLINK
'//			column in the form:
'//			HYPERLINK("&lt;url&gt;") that will allow the end-user to click
'//			on the hyperlink url and be taken to a search webpage
'//
'// Calls.	
'//
'//	Modification history.
'//	---------------------
'// 2/16/21.	wmk.	original code; adapted from GenHLinkM
'//	2/18/21.	wmk.	bug fix "City" being included in sCity.
'//
'//	Notes. Semicolon ";" MUST be used for the HYPERLINK paramters
'// delimiter in order for the hyperlinks to work in Excel.
'// The current sGenPhoneURL only generates links to the
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
const ROW_HEADING=4		'// heading row index
const COL_ADDR=1		'// column index for extracting address
const COL_FLINK=6		'// column for fastpeople hyperlink
const COL_CITY=1		'// column for city
const ROW_CITY=2		'// row for city
const COL_UNIT=2		'// column index for unit
const COL_B=1			'// column index for col B
const ROW_2=1			'// row index for row 2

'// cell formatting constants.
const LJUST=1		'// left-justify HoriJustify
const CJUST=2		'// center HoriJustify
const RJUST=0		'// right-justify HoriJustify
const YELLOW=16776960		'// decimal value of YELLOW color
const TXT_HLINK="HYPERLINK("""	'// HYPERLINK prefix

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
dim oCellUnit	As Object	'// unit field
dim oCellFLink as object	'// hyperlink field
dim oCity 	As object		'// city for sheet
dim sCity	As String		'// city from sheet
dim sUnit	As String		'// unit from sheet
dim oCell		As Object	'// working cell

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
	dim sCountStr 		As String
	dim nColonPos		As Integer
	dim sNumCount		As String
	'// extract city applying to sheet
	oCity = oSheet.getCellByPosition(COL_CITY, ROW_CITY)
	sCity = trim(oCity.String)
	nColonPos = instr(sCity, ":")
	if nColonPos &gt; 0 then
		sCity = trim(right(sCity, len(sCity)-nColonPos))
	endif
	
	if len(sCity) = 0 then
		sCity = "Venice"
	endif
	nRowsProcessed = 0		'// clear processed count

	'// set row processing from oRange information
'	lThisRow = oRange.StartRow - 1		'// start at -1 since increment first
	lThisRow = ROW_HEADING
	nRowCount = oRange.EndRow - lThisRow	'// set row count to process

	'// get row count from B2.
	oCell = oSheet.getCellByPosition(COL_B,ROW_2)		'// Record Count: xxx
	sCountStr = oCell.String
	nColonPos = Instr(sCountStr, ":")
	sNumCount = Right(sCountStr, len(sCountStr)-nColonPos)
	nRowCount = CInt(sNumCount)
'	nRowCount = oCell.getValue()
	for i = 1 to nRowCount
		lThisRow = lThisRow + 1		'// advance current row
		oCellAddr = oSheet.getCellByPosition(COL_ADDR, lThisRow)
		oCellUnit = oSheet.getCellByPosition(COL_UNIT, lThisRow)
		oCellFLink = oSheet.getCellByPosition(COL_FLINK, lThisRow)
		sAddress = trim(oCellAddr.String)		'// set cell address text
		
		if len(oCellUnit.String) = 0 then
			sUnit = ""
		else
			sUnit = trim(oCellUnit.String)			'// set unit text
		endif
		
		if len(sAddress) = 0 then
'			msgBox("GenFLinkM - empty address field; halting process.")
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

		'// Generate fastpeople.. URL
		sURL = sGenFastURL(sAddress, sUnit, sCity)
		sHLink = "="+TXT_HLINK + sURL + CHR(34)+";"+CHR(34) _
	 + "Click here to search" + CHR(34) + ")"
'msgbox("Double quote = " + ASC("""") )
'msgbox("Generated URL =" + CHR(13) + CHR(10) _
'		+ "'" + sURL + "'" + CHR(13) + CHR(10) _
'		+ "Generated Hypertext link = " + CHR(13) + CHR(10) _
'		+ "'" + sHLink )

'		oCellHLink.String = sHLink
		oCellFLink.setFormula(sHLink)
		
		
Nextfor:
		nRowsProcessed = nRowsProcessed + 1

	next i
	
'	msgbox("GenFLinkM - " + nRowsProcessed + " rows processed")
	
NormalExit:
	exit sub
	
ErrorHandler:
   msgbox("GenFLinkM - unprocessed error.")
   GoTo NormalExit

end sub		'// end GenFLinkM	7/13/21.	10:36
