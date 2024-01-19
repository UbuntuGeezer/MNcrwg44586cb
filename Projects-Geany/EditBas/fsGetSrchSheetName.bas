'// fsGetSrchSheetName.bas
'//---------------------------------------------------------------
'// fsGetSrchSheetName - Set PubTerr sheet name in module var.
'//		3/17/21.	wmk. 09:53
'//---------------------------------------------------------------

public function fsGetSrchSheetName() as String

'//	Usage.	sTarget = fsGetSrchSheetName()
'//			
'//		sTarget = reserved string var for return of name
'//
'// Entry.	gsPubTerrSheet module var declared
'//
'//	Exit.	sTarget = gsSearchSheet
'//				if gsSearchSheet is empty on entry, it will be
'//				set to "Terrxxx_Search" where xxx is taken from
'//				the end of the sheet title in A1
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	3/17/21.		wmk.	original code; adapted from fsGetPubSheetName
'//
'//	Notes. The gsSearchSheet module var holds the name of the Search
'// sheet in the territory workbook. A territory workbook has the
'// standardized name %Terrxxx% where xxx is the territory id
'// (e.g. QTerr125 for territory 125).
'//

'//	constants.

'//	local variables.
dim sRetValue As String

	'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = gsSearchSheet
	
	'// check, if gsPubTerrSheet not set, set it from
	'// territory id.
	if len(sRetValue) = 0 then
		sRetValue = fsGetTerrID()
		if len(sRetValue) = 0 then
			GoTo ErrorHandler
		endif
		gsSearchSheet = "Terr" + sRetValue + "_Search"
		sRetValue = gsSearchSheet
	endif
	
NormalExit:
	fsGetSrchSheetName = sRetValue
	exit function
	
ErrorHandler:
	sRetValue = ""
	msgbox("fsGetSrchSheetName - unprocessed error")
	GoTo NormalExit

end function 	'// end fsGetSrchSheetName	3/17/21.	09:53
