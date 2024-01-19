'// sGenSCPAurl.bas
'//---------------------------------------------------------------
'// sGenSCPAurl - Generate sc-pa.com parcel look-up url.
'//		8/17/20.	wmk.	08:15
'//---------------------------------------------------------------

public function sGenSCPAurl(psParcel As String) as String

'//	Usage.	sURL = sGenSCPAurl( sParcel )
'//
'//		sParcel = parcel id from county info
'//
'// Entry.
'//
'//	Exit.	sURL = url of sc-pa.com to look up property details for parcel
'//           by following the url in any browser; pattern is as follows:
'//	 "https://www.sc-pa.com/propertysearch/parcel/details/&lt;parcel-id&gt;"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	8/17/20.	wmk.	original code
'//	Notes. For now, City assumed to be "Venice", State assumed to be "FL"
'// Modify to accept City as 2nd parameter; caller will obtain from
'// a fixed cell, say A4, in spreadsheet, or from Situs-City field
'// if using SCPA data.

'//	constants.
const csURLBase="https://www.sc-pa.com/propertysearch/parcel/details/"
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
dim sParcel		As String	'// copy of passed situs
dim sUnit		As String	'// unit #, if present
dim sStreet		As String	'// street here
dim sNumber		As String	'// number here

	'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = ""
	
	'// set local parcel number if nonempty.
	if len(psParcel) = 0 then
		GoTo ErrorHandler
	endif
	sParcel = psParcel
	
	'// generate url from parcel information.
	sRetValue = csURLBase + sParcel
	
NormalExit:
	sGenSCPAurl = sRetValue
	exit function
	
ErrorHandler:
   msgbox(" sGenSCPAurl - unprocessed error.")
   GoTo NormalExit
end function 	'// end sGenSCPAurl		8/16/20.
