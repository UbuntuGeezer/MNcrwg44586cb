'// fbSheetExists.bas
'//----------------------------------------------------
'// fbSheetExists - check to see if sheet name exists.
'//		10/30/22.	wmk.
'//----------------------------------------------------
function fbSheetExists(psSheetName As String) As Boolean

'// Modification History.
'// ---------------------
'// ??/??/??.	wmk.	original code.
'// 10/30/22.	wmk.	header documentation added.
'//

'// local variables.

dim oDoc		As Object		'// ThisComponent
dim oSheets		As Object		'// Sheets() array
dim bSheetExists	As Boolean	'// sheet exists flag

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSheets = oDoc.Sheets()
	bSheetExists = oSheets.hasByName(psSheetName)

NormalExit:
	fbSheetExists = bSheetExists
	exit function

ErrorHandler:
	msgbox("fbSheetExists - unprocessed error.")
	bSheetExists = false
	GoTo NormalExit:

end function	'// end fbSheetExists	10/30/22.
'/**/
