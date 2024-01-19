'// fsStripSCUnit.bas
'//---------------------------------------------------------------
'// fsStripSCUnit - Strip unit field from SC Situs Address.
'//		9/22/20.	wmk.	12:15
'//---------------------------------------------------------------

public function fsStripSCUnit(psSitusAddr As String) As String

'//	Usage.	sSrchAddr = fsStripSCUnit(SitusAddr)
'//
'//		sSitusAddr = SCPA formatted Situs address
'//
'// Entry.
'//
'//	Exit.	sSrchAddr = situs address with unit field removed and trimmed
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/22/20.		wmk.	original code
'//
'//	Notes. SCPA Situs Address fields contain exactly 17 spaces between the
'// unit and the rest of the address information
'//

'//	constants.
const SPACE_17="                 "	'// EXACTLY 17 spaces

'//	local variables.
dim sRetValue	As String	'// returned value
dim n17BlanksPos	As Integer	'// location of first of 17 spaces

	'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = ""
	n17BlanksPos = InStr(psSitusAddr, SPACE_17)
	if n17BlanksPos &gt; 0 then
		sRetValue = trim(Left(psSitusAddr, n17BlanksPos-1))
	else
		sRetValue = psSitusAddr
	endif
	
NormalExit:
	fsStripSCUnit = sRetValue
	exit function
	
ErrorHandler:
	msgbox("fsStripSCUnit - unprocessed error")
	GoTo NormalExit
	
end function		'// end fsStripSCUnit	9/22/20
