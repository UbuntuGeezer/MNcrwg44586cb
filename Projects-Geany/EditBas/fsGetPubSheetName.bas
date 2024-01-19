'// fsGetPubSheetName.bas
'//---------------------------------------------------------------
'// fsGetPubSheetName - Set PubTerr sheet name in module var.
'//		3/16/21.	wmk. 11:44
'//---------------------------------------------------------------

public function fsGetPubSheetName() as String

'//	Usage.	sTarget = fsGetPubSheetName()
'//			
'//		sTarget = reserved string var for return of name
'//
'// Entry.	gsPubTerrSheet module var declared
'//
'//	Exit.	sTarget = gsPubTerrSheet
'//				if gsPubTerrSheet is empty on entry, it will be
'//				set to "Terrxxx_PubTerr" where xxx is taken from
'//				the end of the sheet title in A1
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	3/16/21.		wmk.	original code
'//
'//	Notes. The gsPubTerrSheet module var holds the name of the PubTerr
'// sheet in the territory workbook. A territory workbook has the
'// standardized name %Terrxxx% where xxx is the territory id
'// (e.g. QTerr125 for territory 125).
'//

'//	constants.

'//	local variables.
dim sRetValue As String

	'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = gsPubTerrSheet
	
	'// check, if gsPubTerrSheet not set, set it from
	'// territory id.
	if len(sRetValue) = 0 then
		sRetValue = fsGetTerrID()
		if len(sRetValue) = 0 then
			GoTo ErrorHandler
		endif
		gsPubTerrSheet = "Terr" + sRetValue + "_PubTerr"
		sRetValue = gsPubTerrSheet
	endif
	
NormalExit:
	fsGetPubSheetName = sRetValue
	exit function
	
ErrorHandler:
	sRetValue = ""
	msgbox("fsGetPubSheetName - unprocessed error")
	GoTo NormalExit

end function 	'// end fsGetPubSheetName	3/16/21.	11:44
