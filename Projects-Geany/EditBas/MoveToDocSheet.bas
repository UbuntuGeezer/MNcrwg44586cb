'// MoveToDocSheet.bas - Jump over to different sheet by sheet name.
'//---------------------------------------------------------------
'// MoveToDocSheet - Jump over to different sheet by sheet name.
'//		7/11/21.	wmk.	09:03
'//---------------------------------------------------------------

public sub MoveToDocSheet(poDocument AS Object, psSheetName As String)

'//	Usage.	macro call or
'//			call MoveToDocSheet( oDocument,sSheetName )
'//
'//		oDocument = document object containing sheet
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
'//	7/9/21.		wmk.	original code; cloned from macro recording.
'// 7/11/21.	wmk.	sheet not found message corrected.
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
'	oDoc = ThisComponent
	oDoc = poDocument

if 1 = 0 then
 msgbox("in MoveToDocSheet.. document URL = " &amp; CHR(13) &amp; CHR(10)_ 
  &amp; oDoc.getURL() )
endif

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
		msgbox("In MoveToDocSheet: " + psSheetName + " - sheet not found!")
		goto ErrorHandler
	endif

	'// use uno - macro-generated code to jump to desired sheet.

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
'document   = ThisComponent.CurrentController.Frame
document = oDoc.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue

args1(0).Name = "Nr"
'//args1(0).Value = 4			'// PubTerr sheet index
args1(0).Value = iUnoSheet		'// jump to desired sheet
dispatcher.executeDispatch(document, ".uno:JumpToTable", "", 0, args1())

if 1 = 1 then
dim oDocument	As Object
dim oDispatcher	As Object
' now jump to A6 to "get into" sheet...
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// move to cell $A$1
dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "ToPoint"
	args2(0).Value = "$A$1"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args2())
endif

NormalExit:
	exit sub

ErrorHandler:
	ON ERROR GOTO
	msgbox("In MoveToDocSheet - unprocessed error.")
	GOTO NormalExit

end sub		'// MoveToDocSheet		7/11/21.	09:03


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
