'// sGenPhoneURL.bas
'//---------------------------------------------------------------
'// sGenPhoneURL - Generate phone look-up url.
'//		8/16/20.	wmk.	15:45
'//---------------------------------------------------------------

public function sGenPhoneURL(psSitus As String, psCity As String) as String

'//	Usage.	sURL = sGenPhoneURL( sSitus, sCity )
'//
'//		sSitus = full situs street address
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
'// Calls.	ParseSitus.
'//
'//	Modification history.
'//	---------------------
'//	8/9/20.		wmk.	original code
'// 8/10/20.	wmk.	bug fixes
'//	8/15/20.	wmk.	calling sequence changed adding City parameter
'// 8/16/20.	wmk.	psState corrected to psCity
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
	sRetValue = csURLBase + csQuery + sNumber + csSep _
	          + sStreet
	if len(sUnit) &gt; 0 then
	   sRetValue = sRetValue + csSep + sUnit
	endif
	sRetValue = sRetValue + csCityStateZip + sCity + csSep2 _
	              + sState + csQEnd
	
NormalExit:
	sGenPhoneURL = sRetValue
	exit function
	
ErrorHandler:
   msgbox(" sGenPhoneURL - unprocessed error.")
   GoTo NormalExit
end function 	'// end sGenPhoneURL	8/15/20.
