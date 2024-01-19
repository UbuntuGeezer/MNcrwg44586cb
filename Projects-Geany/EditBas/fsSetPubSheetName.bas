'// fsSetPubSheetName.bas
'//---------------------------------------------------------------
'// fsSetPubSheetName :- Set PubTerr sheet name in module var.
'//		3/1/21.	wmk. 08:21
'//---------------------------------------------------------------

public function fsSetPubSheetName(psSheetName As String) as void

'//	Usage.	&lt;target&gt; = fsSetPubSheetName( sSheetName )
'//			or fsSetPubSheetName( sSheetName )
'//
'// Entry.	gsPubTerrSheet module var declared
'//
'//	Exit.	gsPubTerrSheet = specified sheet name
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	3/16/21.	wmk.	original code
'// 3/17/21.	wmk.	bug fix where attempting to set void function
'//						value
'//
'//	Notes. The gsPubTerrSheet module var holds the name of the PubTerr
'// sheet in the territory workbook. A territory workbook has the
'// standardized name %Terrxxx% where xxx is the territory id
'// (e.g. QTerr125 for territory 125).
'//

'//	constants.

'//	local variables.
dim aRetValue As Any

	'// code.
	ON ERROR GOTO ErrorHandler
	gsPubTerrSheet = psSheetName
	
NormalExit:
'	aRetValue = 0					'// this is a void function
'	fsSetPubSheetName = aRetValue	'// do not attempt to set retvalue
	exit function
	
ErrorHandler:
	ON ERROR GOTO
	msgbox("fsSetPubSheetName - unprocessed error")
	GoTo NormalExit

end function 	'// end fsSetPubSheetName	'//	3/17/21. 08:21
