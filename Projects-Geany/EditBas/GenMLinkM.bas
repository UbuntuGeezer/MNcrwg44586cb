'// GenMLinkM.bas
'//---------------------------------------------------------------------
'// GenMLinkM - Generate hyperlink(s) for selected MultiMail terr range.
'//		9/8/20.	wmk.	09:30
'//---------------------------------------------------------------------

public sub GenMLinkM()

'//	Usage.	macro call or
'//			call GenMLinkM()
'//
'// Entry.	user selection is Admin-Import format sheet
'//			user has selected a range of cells in desired row(s) to
'//			extract the address field from the COL_ADDR column index
'//			and create a hyperlink to look up phone/address information
'//
'//	Exit.	each row selected has a hperlink added in the COL_HLINK,
'//			COL_HLINK1 and COL_HLINK2 (N, O, P) columns in the form:
'//			HYPERLINK("&lt;url&gt;") that will allow the end-user to click
'//			on the hyperlink url and be taken to a search webpage
'//
'// Calls.	sGenPhoneURL, sGen411URL, sGenWhtPgesURL
'//
'//	Modification history.
'//	---------------------
'//	8/22/20.	wmk.	original code; adapted from GenHLinkM
'// 8/23/20.	wmk.	columns adjusted 1 right for new "Found Name" column
'// 9/8/20.		wmk.	add documentation that links are in cols N-P
'//
'//	Notes. GenMLinkM accommodates territory extracted using a combination
'// of brute force physical search and ReferenceUSA.com. These supply
'// the list of addresses. Since the first pass on the data came from 
'// the brute force method, the downstream routines for URL generation
'// use the full address. All of the ReferenceUSA.com fields are
'// present in the territory spreadsheet, but a utility was written
'// to bridge the split address into a full address for use with
'// existing software modules.
'//	Method. for each row, extract address field from COL_GULLADDR
'//		use sGenPhoneURL to generate url from address
'//     add HYPERLINK("&lt;url&gt;") to create hyperlink
'//		store hyperlink in row at COL_HLINK, COL_HLINK1, COL_HLINK2

'//	constants.
const COL_CITY=1
const ROW_CITY=2

'//	constants. (shared with ConcatAddressM)
const COL_NUMBER=3			'// house number
const COL_PREDIR=4			'// street pre-direction
const COL_STREET=5			'// street name
const COL_SUFFIX=6			'// street suffix (e.g. Ave)
const COL_POSTDIR=7			'// street post direction
const COL_UNIT=8			'// unit/apt #
const COL_FULLADDR=9		'// full concatenated address
const COL_HLINK=13			'// truepeoplesearch (N)
const COL_HLINK1=14			'// 411 search (O)
const COL_HLINK2=15			'// whitepages search (P)
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
		oCellAddr = oSheet.getCellByPosition(COL_FULLADDR, lThisRow)
		oCellHLink = oSheet.getCellByPosition(COL_HLINK, lThisRow)
		sAddress = trim(oCellAddr.String)		'// set cell address text
		if len(sAddress) = 0 then
			msgBox("GenMLinkM  - empty address field; halting process.")
			oCellAddr.CellBackColor = YELLOW
			exit for
		endif	'// null string - alert user, mark row and bail

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
	
	msgbox("GenMLinkM  - " + nRowsProcessed + " rows processed")
	
NormalExit:
	exit sub
	
ErrorHandler:
   msgbox("GenMLinkM  - unprocessed error.")
   GoTo NormalExit

end sub		'// end GenMLinkM 	9/8/20
