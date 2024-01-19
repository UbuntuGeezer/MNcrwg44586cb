'// ParseAddress.bas - Parse address into multiple fields.
'//---------------------------------------------------------------
'// ParseAddress - Parse address into multiple fields.
'//		2/19/21.	wmk.	13:34
'//---------------------------------------------------------------

public sub ParseAddress( psAddress AS String, psSeps As String, _
				psTokens() AS String )

'//	Usage.	macro call or
'//			call ParseAddress( sAddress, sSeps, sTokens() )
'//
'//		sAddress = address string to parse
'//		sSeps = string of legal separators, if empty, comma will be used
'//		sTokens = (returned) array of tokens extracted from sAddress
'//
'// Entry.	
'//
'//	Exit.	sTokens contains parsed fields from sAddress
'//			UBound(sTokens) will allow the caller to get token count
'//
'// Calls. Crack.
'//
'//	Modification history.
'//	---------------------
'//	2/16/21.	wmk.	original code
'// 2/19/21.	wmk.	bug fixes to satisfy OPTION EXPLICIT
'//
'//	Notes. Addresses are all over the show, whether dealing with search
'// engines or downloads. This little guy parses any address field
'// into an array.
'//	Compensates for bug in Crack where source string not being reduced.

'//	constants.

'//	local variables.
dim sAddress	As String		'// copy of passed address
dim sArray()	AS String
dim sSepFnd		AS String		'// separator found
dim sToken		AS String		'// token extracted
dim sSource		AS String		'// source string remaining
dim nTokens		AS Integer		'// token count
dim bContinue	AS Boolean		'// loop control flag
dim sSepList	As String		'// local separator list

	'// code.
	ON ERROR GOTO ErrorHandler
	sAddress = psAddress
	sSepList = psSeps
	sSepFnd = ""
	sToken = ""
	redim psTokens()
	nTokens = 0
	if len(sSepList) = 0 then
		sSepList = " "			'// default to space
	endif
	
	if len(sAddress) = 0 then
		GoTo NormalExit
	endif
	
	bContinue = len(sAddress) &gt; 0
	Do While bContinue
		Crack(sAddress, sSepList, sToken, sSepFnd)
'		if len(sAddress) &gt; len(sToken) then
'		   sAddress = Right(sAddress,len(sAddress)-len(sToken)-1)
'		else
'		   sAddress =""
'		endif
		if len(sToken) = 0 then	'// flush multiple seps
		   GoTo NextToken
		endif
		bContinue = len(sAddress) &gt; 0
		redim preserve psTokens(nTokens)
		psTokens(nTokens) = sToken
		nTokens = nTokens + 1 
NextToken:		
	Loop
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("ParseAddress - unprocessed error")
	GoTo NormalExit
	
end sub		'// end ParseAddress	2/19/21.	13:34
