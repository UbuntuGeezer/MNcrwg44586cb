'// sGen411URL.bas
'//---------------------------------------------------------------
'// sGen411URL - Generate 411.com phone look-up url.
'//		8/16/20.	wmk.	15:45
'//---------------------------------------------------------------

'public function sGen411URL(poRange As Object) as String
public function sGen411URL(psSitus, psCity) as String

'//	Usage.	sURL = sGen411URL( sSitus )
'//	Usage.	sURL = sGen411URL( oRange )
'//
'//		sSitus = full situs address
'//		[oRange = CellRangeAddress of row with relevant data]
'//
'// Entry.	Cells pointed to by oRange.StartRow contain address information
'//         from which to generate the returned url.
'//
'//	Exit.	sURL = url of truepeoplesearch.com to search for phone number
'//           by following the url in any browser; pattern is as follows:
'//  "https://www.411.com/address/413-Andros/Venice-FL/?"
'//
'// Calls.	ParseSitus.
'//
'//	Modification history.
'//	---------------------
'//	8/12/20.	wmk.	original code
'//	8/13/20.	wmk.	minor bug fixes where "number" not in URL and
'//                     wrong city-state separator
'//	8/15/20.	wmk.	calling sequence changed adding City parameter
'//	8/16/20.	wmk.	sCity corrected to psCity in parameters
'//
'//	Notes. For now, City assumed to be "Venice", State assumed to be "FL"
'// Modify to accept City as 2nd parameter; caller will obtain from
'// a fixed cell, say A4, in spreadsheet, or from Situs-City field
'// if using SCPA data.

'//	constants.
const csURLBase="https://www.411.com/address/"
'// insert house number here
const csSep="-"
'// insert street name here
'const csSep here
'// insert unit here
const csSep2="/"
'// insert city here
'const csSep here
'// insert state here
'const csSep2
const csQuery="?"

'//	local variables.
dim sRetValue 	As String	'// returned value
dim sState		As String	'// state from address
dim sCity		As String	'// city from address
dim sSitus		As String	'// copy of passed situs
dim sUnit		As String	'// unit #, if present
dim sStreet		As String	'// street here
dim sNumber		As String	'// number here

	'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = ""
	
	'// set actual values from situs
	sSitus = psSitus
	ParseSitus(sSitus, sNumber, sStreet, sUnit)
	if len(psCity) = 0 then
		sCity = "Venice"
	else
		sCity = psCity
	endif
	sState = "FL"
	
	'// generate url from extracted information.
	sRetValue = csURLBase + sNumber + csSep _
	          + sStreet
	if len(sUnit) &gt; 0 then
	   sRetValue = sRetValue + csSep + sUnit
	endif
	sRetValue = sRetValue + csSep2 + sCity + csSep _
	              + sState + csSep2 + csQuery
	
NormalExit:
	sGen411URL = sRetValue
	exit function
	
ErrorHandler:
   msgbox(" sGen411URL - unprocessed error.")
   GoTo NormalExit
end function 	'// end sGen411URL	8/16/20.
