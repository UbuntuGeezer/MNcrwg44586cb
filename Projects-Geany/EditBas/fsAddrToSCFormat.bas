'// fsAddrToSCFormat.bas
'//---------------------------------------------------------------
'// fsAddrToSCFormat - Convert FullAddress to SC formatted address.
'//		10/12/20.	wmk.	17:30
'//---------------------------------------------------------------

public function fsAddrToSCFormat(psFullAddr As String) As String

'//	Usage.	macro call or
'//			sSCAddr = fsAddrToSCFormat( sFullAddr )
'//
'//		sFullAddr = full address from concatenation routines
'//			&lt;number&gt;&lt;b&gt;&lt;b&gt;&lt;b&gt;&lt;street&gt;&lt;street_suffix&gt;&lt;b&gt;&lt;unit&gt;&lt;b&gt;&lt;post-dir&gt;
'//
'// Entry.
'//
'//	Exit.	sSCAddr = SCPA formatted address:
'//			&lt;number&gt;&lt;post-dir&gt;&lt;b*2&gt;&lt;street&gt;&lt;street_suffix&gt;[&lt;b_35&gt;&lt;unit&gt;]
'//			or &lt;number&gt;&lt;b*3&gt;&lt;street&gt;&lt;street_suffix&gt;[&lt;b_35&gt;&lt;unit&gt;]
'//			where b is space, b_35 is spacing through col 35
'//			for now, only the 2nd format is generated
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/17/20.	wmk.	original code
'// 9/18/20.	wmk.	dead code removed
'//	10/12/20.	wmk.	bug fix where unit number not always starting
'// 					in col 36; (ConcatAddrM fixed, documentation
'//						updated.
'//
'//	Notes. This is designed to generate an address format that is
'//	compatible with SCPA download-generated database property addresses
'//	to facilitate queries, searches and updates. Apparently, if a number
'// has a directional suffix, only 2 spaces intervene between that
'// and the street name. The street address is a fixed-length field
'// that ends at column 35, with the unit number always beginning in
'// col 36. The best guess for situs address is to not use the post-dir
'// at all in the SC address.
'// It appears that in most cases in SC data, the direction suffix has
'// been left out of the SitusAddress. For the time being, the post-direction
'// will just be dropped, as it stands a better chance of matching the
'// SC data address. An exceptions list can eventually be developed that
'// can be used to check for exceptions where the directional suffix is
'// part of the number token in the SC data (e.g.526S HARBOR DR).

'//	constants.
const COL_NUMBER=2			'// house number
const COL_PREDIR=3			'// street pre-direction
const COL_STREET=4			'// street name
const COL_SUFFIX=5			'// street suffix (e.g. Ave)
const COL_POSTDIR=6			'// street post direction
const COL_UNIT=7			'// unit/apt #
const YELLOW=16776960		'// decimal value of YELLOW color
const BLANKS_30="                              "	'// exactly 30 spaces
const BLANKS_17="                 "	'// exactly 17 spaces
const BLANKS_3="   "				'// exactly 3 spaces
const BLANKS_2="  "					'// exactly 2 spaces

'//	local variables.
dim sRetValue	As String	'// returned value
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet

'// processing variables.
dim sAddress As String		'// address field from current row
dim sPrefix	As String		'// url generated from sAddress
dim sStreet	As String		'// HYPERTEXT link to store
dim sSuffix As String		'// 
dim sUnit	As String
dim sPreDir	As String		'// pre-direction letter

dim sRight2		As String	'// rightmost 2 of passed address
dim sDir		As String	'// anticipated leading space of last 2
dim sSeps		As String	'// string of separators to find 'NSEW'
dim sSepFnd		As String	'// anticipated direction NSEW	
dim bHaveDir	As Boolean	'// have direction flag
dim nSpaces		As Integer	'// number of fill spaces to col 36

'// XCell sheet objects
dim oCellAddr as object		'// address field
dim oCity 	As object		'// city for sheet
dim sCity	As String		'// city from sheet

'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = psFullAddr		'// stub; just echo back passed address
	
	'// at the right end of the full address check for
	'// &lt;b&gt;{N,S,E,W}*1; if is there, assume it is direction and delete it.
	'// modify the Concat routines to place exactly the correct spacing
	'// to start the unit token in col 36, so that no other
	'// action is necessary to get the two address formats to match.
	
'// begin new code.
dim sNoUnitAddr		As String	'// full address with unit stripped
dim sUnitAddr		As String	'// unit stripped from address
dim nBlanks			As Integer	'// space fill count

	sAddress = psFullAddr
	sNoUnitAddr = trim(left(sAddress,35))'// unit always starts at 36
	sUnitAddr = Mid(sAddress,36,len(sAddress))		'// grab unit substring
	
	sRight2 = Right(sNoUnitAddr, 2)
	sSeps="NSEW"
	Crack(sRight2, sSeps, sDir, sSepFnd)
	bHaveDir = (StrComp(sDir, " ") = 0)
	if bHaveDir then
		bHaveDir = (InStr("NSEW", sSepFnd) &gt; 0)
	endif
	
	'// if have direction, drop it, otherwise leave address alone
	if bHaveDir then
		sRetValue = Left(sNoUnitAddr, Len(sNoUnitAddr)-2)
	else
		sRetValue = sNoUnitAddr
	endif

    if len(sRetValue) &lt; 35 then
		nBlanks = 35 - len(sRetValue)
		sRetValue = sRetValue + left(BLANKS_30, nBlanks)
    endif
    sRetValue = sRetValue + sUnitAddr
	sRetValue = trim(sRetValue)

NormalExit:
	fsAddrToSCFormat = sRetValue
	exit function
	
ErrorHandler:	
	msgbox("fsAddrToSCFormat - unprocessed error.")
	GoTo NormalExit

end function	'// end fsAddrToSCFormat	10/12/20.
