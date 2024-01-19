'// sGen2WhtPgesURL.bas
'//---------------------------------------------------------------
'// sGen2WhtPgesURL - Generate 411.com phone look-up url.
'//		2/10/21.	wmk.	05:30
'//---------------------------------------------------------------

public function sGen2WhtPgesURL(psAddr As String,_
				psUnit As String, psCity As String) as String

'//	Usage.	sURL = sGen2411URL( sAddr, sUnit, sCity )
'//
'//		sAddr = street address
'//		sUnit = unit/apt number
'//		sCity = situs city
'//
'// Entry.
'//
'//	Exit.	sURL = url of whitepages.com to search for phone number
'//           by following the url in any browser; pattern is as follows:
'//  "https://www.whitepages.com/address/413-Andros-unit/Venice-FL/?"
'//
'// Calls.	ParseSitus, ParseUnit.
'//
'//	Modification history.
'//	---------------------
'//	2/9/21.		wmk.	original code; adapted from sGenPhoneURL adding
'//						unit parameter and ParseUnit call.
'//
'//	Notes. For now, City assumed to be "Venice", State assumed to be "FL"
'// Modify to accept City as 2nd parameter; caller will obtain from
'// a fixed cell, say A4, in spreadsheet, or from Situs-City field
'// if using SCPA data.

'//	constants.
const csURLBase="https://www.whitepages.com/address/"
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

dim sAddr		As String	'// copy of passed situs
dim sFullUnit	As String	'// full unit from bridge field
dim sSCUnit		As String	'// parsed SC unit or just full unit
dim sBldUnit	As String	'// parsed building/mailing unit
dim sBldg		As String	'// parsed"BLD" or "BLDG" or empty
dim sBldNum		As String	'// parsed building number

dim sUnit		As String	'// bldg/mailing unit #, if present
dim sStreet		As String	'// street here
dim sNumber		As String	'// number here

	'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = ""
	
	'// set actual values from situs
	sAddr = psAddr
	ParseSitus(sAddr, sNumber, sStreet, sUnit)

	'// parse unit to get building/mailing unit.
	sFullUnit = psUnit
	if len(sFullUnit) &gt; 0 then
	   ParseUnit(sFullUnit, sSCUnit, sBldUnit, sBldg, sBldNum)
	   sUnit = sBldUnit
	   if len(sBldUnit) = 0 then
	      sUnit = sSCUnit
	   else
	      sUnit = sBldUnit
	   endif
	else
	   sUnit = ""
	endif

	'// default city to Venice.
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
'	   sRetValue = sRetValue + csSep + sUnit
	   sRetValue = sRetValue + " Apt " + sUnit
	endif
	sRetValue = sRetValue + csSep2 + sCity + csSep _
	              + sState + csSep2 + csQuery
	
NormalExit:
	sGen2WhtPgesURL = sRetValue
	exit function
	
ErrorHandler:
   msgbox(" sGen2WhtPgesURL - unprocessed error.")
   GoTo NormalExit
end function 	'// end sGen2WhtPgesURL	2/10/21.
