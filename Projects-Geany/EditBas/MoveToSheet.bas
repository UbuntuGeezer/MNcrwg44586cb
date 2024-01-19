'// MoveToSheet.bas - Jump over to different sheet by sheet name.
'//---------------------------------------------------------------
'// MoveToSheet - Jump over to different sheet by sheet name.
'//		3/16/21.	wmk.	13:38
'//---------------------------------------------------------------

public sub MoveToSheet(psSheetName As String)

'//	Usage.	macro call or
'//			call MoveToSheet( sSheetName )
'//
'//		sSheetName = name of sheet to move to
'//
'// Entry.	user focused on some sheet in workbook
'//
'//	Exit.	user focus moved to sSheetName in workbook, if exists
'//
'// Calls.	uno Dispatcher.
'//
'//	Modification history.
'//	---------------------
'//	3/16/21.		wmk.	original code; cloned from macro recording
'//
'//	Notes. &lt;Insert notes here&gt;
'//

'//	constants.

'// local variables.

dim oDoc		As Object		'// ThisComponent
dim oSheets		As Object		'// Sheets() array
dim iSheetIx	As Integer		'// desired sheet index
dim iUnoSheet	As Integer		'// uno sheet number
dim bSheetExists	As Boolean	'// sheet exists flag
dim oSheet		As Object		'// this sheet

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSheets = oDoc.Sheets()
	bSheetExists = oSheets.hasByName(psSheetName)
'XRay oSheets
	if bSheetExists then
		oSheet = oSheets.getByName(psSheetName)
		iSheetIx = oSheet.RangeAddress.Sheet

if not true then
	msgbox("Index of target sheet is " + iSheetIx)
	goto NormalExit
endif
		iUnoSheet = iSheetIx + 1	'// add 1 for uno indexing

	else		'// sheet not found
		msgbox("In MoveToSheet: " + psSheetName + " - sheet not found!")
		goto ErrorHandler
	endif

	'// use uno - macro-generated code to jump to desired sheet.

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Nr"
'//args1(0).Value = 4			'// PubTerr sheet index
args1(0).Value = iUnoSheet		'// jump to desired sheet
dispatcher.executeDispatch(document, ".uno:JumpToTable", "", 0, args1())

NormalExit:
	exit sub

ErrorHandler:
	msgbox("In MoveToSheet - unprocessed error.")
	GOTO NormalExit

end sub		'// MoveToSheet		3/16/21.	13:38
