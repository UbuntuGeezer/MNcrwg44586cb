'// sGenFastURL.bas
'//---------------------------------------------------------------
'// sGenFastURL - Generate fastpeoplesearch.com phone look-up url.
'//		2/21/21.	wmk.	00:07
'//---------------------------------------------------------------

public function sGenFastURL(psAddr As String,_
				psUnit As String, psCity As String) as String

'//	Usage.	sURL = sGenFastURL( sAddr, sUnit, sCity )
'//
'//		sAddr = street address
'//		sUnit = unit/apt number
'//		sCity = situs city
'//
'// Entry.
'//
'//	Exit.	sURL = url of whitepages.com to search for phone number
'//           by following the url in any browser; pattern is as follows:
'//  "https://www.fastpeoplesearch.com/address/413-Andros-unit_Venice-FL/?"
'//
'// Calls.	ParseSitus, ParseUnit.
'//
'//	Modification history.
'//	---------------------
'//	2/9/21.		wmk.	original code; adapted from sGenPhoneURL adding
'//						unit parameter and ParseUnit call.
'// 2/16/21.	wmk.	change to use ParseAddress to fully parse
'//						address field since need street suffix for
'//						fastpeople search hyperlink
'// 2/19/21.	wmk.	add HWY, RTE, TPK, CWY, EXT, BYP to known
'//						street types.
'// 2/20/21.	wmk.	bug fix; all street field separators must be "-"
'//						instead of spaces; fixed bug failing to include
'//						street name if no street type suffix; fixed bug
'//						where unit not trimmed prior to adding.
'//	Notes. For now, City assumed to be "Venice", State assumed to be "FL"
'// Modify to accept City as 2nd parameter; caller will obtain from
'// a fixed cell, say A4, in spreadsheet, or from Situs-City field
'// if using SCPA data.

'//	constants.
const csURLBase="https://www.fastpeoplesearch.com/address/"
'// insert house number here
const csSep="-"
'// insert street name here
'const csSep here
'// insert unit here
const csSep2="_"
'// insert city here
'const csSep here
'// insert state here


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
dim sTokens()		As String	'// address tokens array
dim sSeps			As String	'// addres token delimiter(s)

dim i				As Integer	'// loop index
dim nTokens		As Integer
dim bHasStreetDir	As Boolean
dim sStreetCompass	As String
dim sStreetType		As String
dim bHasStreetType	As Boolean

	'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = ""
	
	'// set actual values from situs
	sAddr = psAddr
'	ParseSitus(sAddr, sNumber, sStreet, sUnit)
	sSeps = " "
	redim preserve sTokens(0)
	ParseAddress(sAddr, sSeps, sTokens())
	'// flesh out address elements from tokens.
	sNumber = sTokens(0)
	sStreet = ""
	nTokens = UBound(sTokens)
	
	'// account for direction N S E W NW NE SW SE as last field
	bHasStreetDir = instr("N S E W NW NE SW SE",sTokens(nTokens)) &gt; 0
	if bHasStreetDir then
	   sStreetCompass = "-" &amp; sTokens(nTokens)
	   sStreetType = UCase(sTokens(nTokens-1))
	else
	   sStreetCompass = ""
	   sStreetType = UCase(sTokens(nTokens))
	endif
	
	bHasStreetType = _
	 instr("AVE ST RD DR CIR LN TERR WAY CT RTE EXT HWY TPK CWY BYP",_
	 	 sStreetType) &gt; 0
	
	for i = 1 to nTokens
		sStreet = sStreet + sTokens(i)
		if i &lt; nTokens then
		   sStreet = sStreet &amp; "-"
		endif
	next i
	
'	if bHasStreetType then
'	   sStreet = sStreet &amp; "-" &amp; sStreetType
'	endif
	
	'// parse unit to get building/mailing unit.
	sFullUnit = trim(psUnit)
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
'	sRetValue = csURLBase + sNumber + csSep _
'	          + sStreet + sStreetCompass
	sRetValue = csURLBase + sNumber + csSep _
	          + sStreet					'// compass already there..
	if len(sUnit) &gt; 0 then
'	   sRetValue = sRetValue + csSep + sUnit
	   sRetValue = sRetValue + "-Apt-" + sUnit
	endif
	sRetValue = sRetValue + csSep2 + sCity + csSep _
	              + sState
	
NormalExit:
	sGenFastURL = sRetValue
	exit function
	
ErrorHandler:
   msgbox(" sGenFastURL - unprocessed error.")
   GoTo NormalExit
end function 	'// end sGenFastURL	2/20/21.	00:07
