'// GenELinkM.bas
'//---------------------------------------------------------------------
'// GenELinkM - Generate hyperlink(s) for selected Admin-Edit terr range.
'//		7/13/21.	wmk.	10:41
'//---------------------------------------------------------------------

public sub GenELinkM()

'//	Usage.	macro call or
'//			call GenELinkM()
'//
'// Entry.	Admin-Edit sheet is active; user has selected a range of
'//			cells in desired row(s) to
'//			extract the address field from the COL_ADDR column index
'//			and create a hyperlink to look up phone/address information
'//
'//	Exit.	each row selected has a hperlink added in the COL_HLINK,
'//			COL_HLINK1 and COL_HLINK2 columns in the form:
'//			HYPERLINK("&lt;url&gt;") that will allow the end-user to click
'//			on the hyperlink url and be taken to a search webpage
'//
'// Calls.	sGen2PhoneURL, sGen2411URL, sGen2WhtPgesURL
'//
'//	Modification history.
'//	---------------------
'//	9/4/20.		wmk.	original code; adapted from GenMLinkM
'// 9/8/20.		wmk.	documentation updated to latest format information
'//						column range is now H-J; column B contains full address
'//						error handling modified to just skip empty address row
'//						ForceRecalc called to set HYPERLINKs
'// 2/9/21.		wmk.	Changed to call sGen2PhoneURL to pass unit; const
'//						COL_UNIT added for unit handling.
'// 2/10/21.	wmk.	Changed to call sGen2411URL, sGen2WhtPgesURL
'//						to pass unit.
'// 7/13/21.	wmk.	eliminate non-error msgboxes for batch processing.
'//
'//	Notes. GenELinkM accommodates territory extracted using ImportRefUSA
'//	on raw data downloaded into a .csv from ReferenceUSA.com
'// The import goes through several phases.
'//	The 1st phase is to an Admin-Import spreadsheet by taking the ReferenceUSA
'// data and running the ImportRefUSA utility on it.

'// The second phase is to an Admin-Bridge spreadsheet that has the
'// data in columns compatible with MultiMail.db SplitProps table import.

'// The third phase is, using the Admin-Bridge sheet, an Admin-Edit sheet
'// is generated that is simplified for data entry/checking. The Admin-Edit
'// sheet contains the hyperlinks to search truepeople, 411, and whitepages.
'// GenELinkM is used to place the hyperlinks in the Admin-Edit sheet.
'//	If there is newer information in the searches, the address records can be
'// edited to either add/change names/phone numbers.

'// The fourth phase is the Admin-TSExport sheet that is set up to export
'// the territory in fields compatible with Territory Servant app. The
'// Admin-TSExport sheet is the essential information the publisher will
'// get when they have the territory checked out through Territory Servant.

'// On territory completion, the spreadsheet will follow the reverse process.
'// The spreadsheet will be moved directly to the Admin-Edit sheet.
'// If the publisher noted changes in name(s), phone(s) or status (e.g. DoNotCall)
'//	the spreadsheet will then be edited to reflect the changes.

'// Once updated if necessary on the return cycle, the spreadsheet will
'// migrate upwards to the Admin-Bridge spreadsheet. From there, any
'// changed records can be found and replaced in the MultiMail SplitProps
'// table. Once updated, the spreadsheet will go back through the phases
'// and supplied to the territory servant as an updated territory.
'//
'//	Method. for each row, extract address field from COL_GULLADDR
'//		use sGen2PhoneURL to generate url from address
'//     add HYPERLINK("&lt;url&gt;") to create hyperlink
'//		store hyperlink in row at COL_HLINK, COL_HLINK1, COL_HLINK2

'// Notes2. Due to mods to the bridge sheet format, the address column
'// now only contains the street address, and a new column was added
'// next to it containing the unit. The SitusAddress column may/may not
'// have a unit. So this version does not need to parse the situs. Instead
'// it will parse the UnitAddress field (COL_B) which will never contain
'// a unit. It will set the Unit to the unit passed as a parameter.

'//	constants.
const COL_CITY=1
const ROW_CITY=2

'//	constants.
const COL_UNITADDR=1		'// unit address
const COL_UNIT=2			'// unit
const COL_HLINK=7			'// truepeoplesearch (H)
const COL_HLINK1=8			'// 411 search (I)
const COL_HLINK2=9			'// whitepages search (J)
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
dim sUnit	As String		'// unit field from current row
dim sURL	As String		'// url generated from sAddress, sUnit
dim sHLink	As String		'// HYPERTEXT link to store
dim i		As Integer		'// loop counter

'// XCell sheet objects
dim oCellAddr as object		'// address field
dim oCellUnit As Object		'// unit field
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
		oCellAddr = oSheet.getCellByPosition(COL_UNITADDR, lThisRow)
		sAddress = trim(oCellAddr.String)		'// set cell address text
		if len(sAddress) = 0 then
'			msgBox("GenELinkM  - empty address field; skipping..") '//
			oCellAddr.CellBackColor = YELLOW
			GoTo Nextfor
		endif	'// null string - alert user, mark row and bail
		oCellUnit = oSheet.getCellByPosition(COL_UNIT, lThisRow)
		sUnit = trim(oCellUnit.String)			'// unit for call(s)
		
		'// Generate truepeople.. URL
		sURL = sGen2PhoneURL(sAddress, sUnit, sCity)
		sHLink = "="+TXT_HLINK + sURL + CHR(34)+";"+CHR(34) _
	 + "Click here to search" + CHR(34) + ")"
'msgbox("Double quote = " + ASC("""") )
'msgbox("Generated URL =" + CHR(13) + CHR(10) _
'		+ "'" + sURL + "'" + CHR(13) + CHR(10) _
'		+ "Generated Hypertext link = " + CHR(13) + CHR(10) _
'		+ "'" + sHLink )
'		oCellHLink.String = sHLink
		oCellHLink = oSheet.getCellByPosition(COL_HLINK, lThisRow)
		oCellHLink.setFormula(sHLink)
		
		'// Generate 411.. URL
		sURL = sGen2411URL(sAddress, sUnit, sCity)
		sHLink = "="+TXT_HLINK + sURL + CHR(34)+";"+CHR(34) _
	 + "Click here to search" + CHR(34) + ")"
'msgbox("Generated URL =" + CHR(13) + CHR(10) _
'		+ "'" + sURL + "'" + CHR(13) + CHR(10) _
'		+ "Generated Hypertext link = " + CHR(13) + CHR(10) _
'		+ "'" + sHLink )
		oCellHLink = oSheet.getCellByPosition(COL_HLINK1, lThisRow)
		oCellHLink.setFormula(sHLink)

		'// Generate whitepages.. URL
		sURL = sGen2WhtPgesURL(sAddress, sUnit, sCity)
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
	
	ForceRecalc()
'	msgbox("GenELinkM  - " + nRowsProcessed + " rows processed")
		
NormalExit:
	exit sub
	
ErrorHandler:
   msgbox("GenELinkM  - unprocessed error.")
   GoTo NormalExit

end sub		'// end GenELinkM 	7/13/21. 10:41
'// GenELinkM.bas
'//---------------------------------------------------------------------
'// GenELinkM - Generate hyperlink(s) for selected Admin-Edit terr range.
'//		9/8/20.	wmk.	11:25
'//---------------------------------------------------------------------

public sub GenELinkMOld()

'//	Usage.	macro call or
'//			call GenELinkM()
'//
'// Entry.	Admin-Edit sheet is active; user has selected a range of
'//			cells in desired row(s) to
'//			extract the address field from the COL_ADDR column index
'//			and create a hyperlink to look up phone/address information
'//
'//	Exit.	each row selected has a hperlink added in the COL_HLINK,
'//			COL_HLINK1 and COL_HLINK2 columns in the form:
'//			HYPERLINK("&lt;url&gt;") that will allow the end-user to click
'//			on the hyperlink url and be taken to a search webpage
'//
'// Calls.	sGenPhoneURL, sGen411URL, sGenWhtPgesURL
'//
'//	Modification history.
'//	---------------------
'//	9/4/20.		wmk.	original code; adapted from GenMLinkM
'// 9/8/20.		wmk.	documentation updated to latest format information
'//						column range is now H-J; column B contains full address
'//						error handling modified to just skip empty address row
'//						ForceRecalc called to set HYPERLINKs
'//
'//	Notes. GenELinkM accommodates territory extracted using ImportRefUSA
'//	on raw data downloaded into a .csv from ReferenceUSA.com
'// The import goes through several phases.
'//	The 1st phase is to an Admin-Import spreadsheet by taking the ReferenceUSA
'// data and running the ImportRefUSA utility on it.

'// The second phase is to an Admin-Bridge spreadsheet that has the
'// data in columns compatible with MultiMail.db SplitProps table import.

'// The third phase is, using the Admin-Bridge sheet, an Admin-Edit sheet
'// is generated that is simplified for data entry/checking. The Admin-Edit
'// sheet contains the hyperlinks to search truepeople, 411, and whitepages.
'// GenELinkM is used to place the hyperlinks in the Admin-Edit sheet.
'//	If there is newer information in the searches, the address records can be
'// edited to either add/change names/phone numbers.

'// The fourth phase is the Admin-TSExport sheet that is set up to export
'// the territory in fields compatible with Territory Servant app. The
'// Admin-TSExport sheet is the essential information the publisher will
'// get when they have the territory checked out through Territory Servant.

'// On territory completion, the spreadsheet will follow the reverse process.
'// The spreadsheet will be moved directly to the Admin-Edit sheet.
'// If the publisher noted changes in name(s), phone(s) or status (e.g. DoNotCall)
'//	the spreadsheet will then be edited to reflect the changes.

'// Once updated if necessary on the return cycle, the spreadsheet will
'// migrate upwards to the Admin-Bridge spreadsheet. From there, any
'// changed records can be found and replaced in the MultiMail SplitProps
'// table. Once updated, the spreadsheet will go back through the phases
'// and supplied to the territory servant as an updated territory.
'//
'//	Method. for each row, extract address field from COL_GULLADDR
'//		use sGenPhoneURL to generate url from address
'//     add HYPERLINK("&lt;url&gt;") to create hyperlink
'//		store hyperlink in row at COL_HLINK, COL_HLINK1, COL_HLINK2

'//	constants.
const COL_CITY=1
const ROW_CITY=2

'//	constants.
const COL_FULLADDR=1		'// full concatenated address
const COL_HLINK=7			'// truepeoplesearch (H)
const COL_HLINK1=8			'// 411 search (I)
const COL_HLINK2=9			'// whitepages search (J)
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
		sAddress = trim(oCellAddr.String)		'// set cell address text
		if len(sAddress) = 0 then
			msgBox("GenELinkM  - empty address field; skipping..") '//
			oCellAddr.CellBackColor = YELLOW
			GoTo Nextfor
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
		oCellHLink = oSheet.getCellByPosition(COL_HLINK, lThisRow)
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
	
	ForceRecalc()
	msgbox("GenELinkM  - " + nRowsProcessed + " rows processed")
		
NormalExit:
	exit sub
	
ErrorHandler:
   msgbox("GenELinkM  - unprocessed error.")
   GoTo NormalExit

end sub		'// end GenELinkM 	9/8/20.
