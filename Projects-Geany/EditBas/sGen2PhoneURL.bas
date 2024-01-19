'// sGen2PhoneURL.bas
'//---------------------------------------------------------------
'// sGen2PhoneURL - Generate phone look-up url with unit.
'//		2/10/21.	wmk.	05:30
'//---------------------------------------------------------------

public function sGen2PhoneURL(psAddr As String,_
				psUnit As String, psCity As String) as String

'//	Usage.	sURL = sGen2PhoneURL( sAddr, sUnit, sCity )
'//
'//		sAddr = full situs street address
'//		sCity = situs city
'//
'// Entry.	Cells pointed to by oRange.StartRow contain address information
'//         from which to generate the returned url.
'//
'//	Exit.	sURL = url of truepeoplesearch.com to search for phone number
'//           by following the url in any browser; pattern is as follows:
'//" https://www.truepeoplesearch.com/
'//    details?streetaddress=&lt;number&gt;%20&lt;street name&gt;%20&lt;unit&gt;
'//    &amp;citystatezip=&lt;city&gt;%2C%20&lt;state&gt;&amp;rid=0x0"
'//
'// Calls.	ParseSitus, ParseUnit.
'//
'//	Modification history.
'//	---------------------
'//	2/9/21.		wmk.	original code; adapted from sGenPhoneURL adding
'//						unit parameter
'//
'//	Notes.
'//

'//	constants.

'// URL building constants.
const csURLBase="https://www.truepeoplesearch.com/"
const csQuery="details?streetaddress="
'// insert house number here
const csSep="%20"
'// insert street name here
'const csSep here
'// insert unit here
const csCityStateZip="&amp;citystatezip="
'// insert city here
const csSep2="%2C%20"
'// insert state here
const csQEnd= "&amp;rid=0x0"

'//	local variables.
dim sRetValue As String		'// returned value
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
	
	'// set values from address and unit
	sAddr = psAddr
	ParseSitus(sAddr, sNumber, sStreet, sFullUnit)
	
	'// parse unit to get building/mailing unit.
	sFullUnit = psUnit
	if len(sFullUnit) &gt; 0 then
	   ParseUnit(sFullUnit, sSCUnit, sBldUnit, sBldg, sBldNum)
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
	sRetValue = csURLBase + csQuery + sNumber + csSep _
	          + sStreet
	if len(sUnit) &gt; 0 then
	   sRetValue = sRetValue + csSep + sUnit
	endif
	sRetValue = sRetValue + csCityStateZip + sCity + csSep2 _
	              + sState + csQEnd
	
NormalExit:
	sGen2PhoneURL = sRetValue
	exit function
	
ErrorHandler:
   msgbox(" sGen2PhoneURL - unprocessed error.")
   GoTo NormalExit
end function 	'// end sGen2PhoneURL	2/9/21. 17:45
