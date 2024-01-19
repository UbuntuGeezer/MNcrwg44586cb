'// ParseSitus.bas
'//---------------------------------------------------------------
'// ParseSitus - Parse Situs :into number, street, unit fields.
'//		9/16/20.	wmk.	8:00
'//---------------------------------------------------------------

public sub ParseSitus( psSitus As String, psNumber As String, _
                   psStreet As String, psUnit As String )

'//	Usage.	macro call or
'//			call ParseSitus( sSitus, sNumber, sStreet, sUnit )
'//
'//		sSitus = full property address number, street, [unit]
'//		sNumber = [returned] house/bldg number
'//		sStreet = [returned] street name and suffix
'//		sUnit = [returned] [unit/lot/apt number]
'//
'// Entry.	sSitus is blank/tab separated fields
'//
'//	Exit.	sNumber = extracted house/bldg number
'//			sStreet = extracted street name [with suffix]
'//			sUnit = unit/lot/apt number or ""
'//
'// Calls.	Crack
'//
'//	Modification history.
'//	---------------------
'//	8/9/20.		wmk.	original code
'//	8/10/20.	wmk.	modified to use Crack to break strings
'// 8/13/20.	wmk.	msgbox debugs deactivated
'//	8/16/20.	wmk.	bDone, bStreetDone explicitly declared; bug fix where
'//						N INDIES CIR being parsed as N INDIESCIR
'//	8/18/20.	wmk.	mod to split street direction off number
'//						(e.g. 700N Tamiami Tr)
'// 8/26/20.	wmk.	bug fix where empty string is actually found
'//						by InStr in source string at position 1
'//	9/15/20.	wmk.	day-1 bug fixes where street direction prefix
'//						returned as street, and street returned with unit
'//						and parsing ended with juxtaposed blanks;
'//						modified to return direction prefix as suffix
'//						on street to match RefUSA street formatting
'//	Notes.

'//	constants.

'//	local variables.
dim bDone	As Boolean	'// done parsing flag
dim bStreetDone	As Boolean	'// street done flag
dim sBlank	As String	'// blank
dim sTab	As String	'// tab
dim sSitus	As String	'// trimmed situs
dim nSitusLen	As Integer	'// situs length
dim iSep	As Integer	'// blank position
dim jSep	As Integer	'// tab position
dim nExtLen	As Integer	'// extracted substring len
dim bMore	As Integer	'// more street remaining flag
dim sSeps	As String	'// situs separators
dim sFullStreet	As String	'// full street
dim sSepFnd	As String	'// separator found
dim sNumber	As String	'// house number
dim sStreet	As String	'// street name
dim sUnit	As String	'// unit #
Dim iPos	As Integer	'// separator position
dim sPostDir	As String	'// post direction
dim bBlanksFlushed	As Boolean	'// blanks flushed flag

	'// code.
	ON ERROR GOTO ErrorHandler
	sTab = CHR(9)
	sBlank = " "
	sSeps= sBlank + sTab
	sSitus = Trim(psSitus)
	nSitusLen = len(sSitus)
	
	'// Extract number.
	'// Parse to first blank or tab.
	'// Also include N S E W as SCPA includes as part of number field.	'// mod081820
	sSeps= "NSEW" + sBlank + sTab										'// mod081820
	call Crack(sSitus, sSeps, sNumber, sSepFnd)
	bDone = (len(sSepFnd) = 0)

if true then
 GoTo Skip1
endif
'//-------------------------------------------------------------------------------	
	'// if separator in set "NSEW", re-insert back into sSitus at front	'// mod081820
	iPos = InStr("NSEW",sSepFnd)										'// mod082620
	if iPos  &gt; 0 then													'// mod082620
		sSitus = sSepFnd + sSitus										'// mod081820
	endif	'// end number contains direction conditional				'// mod081820
'//--------------------------------------------------------------------------------
Skip1:

	'// if separator in set "NSEW", save it and append to Street		'// mod091620
	iPos = InStr("NSEW",sSepFnd)										'// mod091620
	if iPos  &gt; 0 then													'// mod091620
		sPostDir = sSepFnd												'// mod091620
	endif	'// end number contains direction conditional				'// mod091620
	
'// flush multiple blanks between number and street name
	bBlanksFlushed = false
	sSeps= sBlank + sTab	'// limit further seps to blank and tab		'// mod081820
	sFullStreet = ""		'// clear street accumulator
	do while (NOT bBlanksFlushed)
		Crack(sSitus, sSeps, sStreet, sSepFnd)
		bBlanksFlushed = (len(sStreet) &gt; 0)
		bDone = (len(sSepFnd) = 0)
		if bDone then		'// if only number, bail out
			GoTo AllDone
		endif
 	loop

	sFullStreet = sFullStreet + " " + sStreet

'msgbox("ParseSitus - sNumber = " + sNumber + CHR(13) + CHR(10) _
'	      + " remaining Situs = " + sSitus)

	'// Extract street name.
	sSeps= sBlank + sTab	'// limit further seps to blank and tab		'// mod081820
	bStreetDone = bDone
 	do while (NOT bStreetDone)
 		call Crack(sSitus, sSeps, sStreet, sSepFnd)
 		sFullStreet = sFullStreet + " " + sStreet
 		bStreetDone = (StrComp(sSepFnd, CHR(9)) = 0) _
 		            OR (Len(sSepFnd) = 0)	'// done if tab or no separator
if false then
  GoTo Skip2
endif
'//-----------------------------------------------------------------------------
 		if (NOT bStreetDone) then
 			call Crack(sSitus, sSeps, sStreet, sSepFnd)
 			bStreetDone = (len(sStreet) = 0)	'// done if 2 separators juxt
 			if bStreetDone then
 				exit do
 			else
 				sFullStreet = sFullStreet + " " + sStreet
 			endif
 		endif	'// end not TAB conditional
 '//---------------------------------------------------------------------------
 Skip2:
 
 NextSep:
 	loop	'// end street not done conditional

AllDone: 
 	sFullStreet = trim(sFullStreet)
 	
 	'// append pre-direction as post-direction
 	if len(sPostDir) &gt; 0 then
 	   sFullStreet = sFullStreet + " " + sPostDir
 	endif
 	
 	sUnit = sSitus	'// unit is whatever is left
	
'msgbox("ParseSitus - sFullStreet = '" + sFullStreet + +"'"+CHR(13) + CHR(10) _
'          + "sUnit = '" + sUnit + "'" + CHR(13)+CHR(10) _
'	      + " remaining Situs = '" + sSitus + "'")

	'// set returned values.
	psNumber = sNumber
	psStreet = sFullStreet
	psUnit = sUnit
	
NormalExit:
	exit sub
	
ErrorHandler:
	'// clear all returned strings
	psNumber = ""
	psStreet = ""
	psUnit = ""
	msgBox("ParseSitus - unprocessed error.")
	GoTo NormalExit
	
end sub		'// end ParseSitus	9/16/20
