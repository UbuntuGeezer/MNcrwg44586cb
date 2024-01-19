'// SuperToUntitled.bas
'//------------------------------------------------------------------
'// SuperToUntitled - Copy sheets for SuperTerr to Untitled workbook.
'//		7/13/21.	wmk.	18:34
'//------------------------------------------------------------------

public sub SuperToUntitled()

'//	Usage.	macro call or
'//			call SuperToUntitled()
'//
'// Entry.	User in any sheet in workbook
'//			gsPubTerrSheet = name of PubTerr sheet
'//			User has opened "Untitled 1" workbook
'//			gsNewSheet = new Search sheet name
'//			gsPubTerrSheet = name of PubTerr sheet
'//
'//	Exit.	Sheets Terrxxx_PubTerr and Terrxxx_Search copied to
'//			Untitled workbook
'//
'// Calls.	fsGetSrchSheetName
'//
'//	Modification history.
'//	---------------------
'//	3/15/21.	wmk.	original code
'// 3/17/21.	wmk.	change to only save Search sheet.
'// 7/13/21.	wmk.	shorten name to Terrxxx_Search.
'//
'//	Notes. Changed to only save Search sheet until figure out
'// how to get control back to this workbook doing the saving.
'//

'//	constants.

'//	local variables.

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

dim oDoc		As Object		'// ThisComponent
dim oSel		As Object		'// current selection
dim oRange		As Object		'// RangeAddress currently selected
dim iSheetIx	As Integer		'// desired sheet index
dim iUnoSheet	As Integer		'// uno sheet number
dim sThisName	As String		'// name of current sheet
dim oSheet		As Object		'// this sheet
dim oSheets		As Object		'// sheets array
dim bSheetExists	As Boolean	'// sheet exists flag
dim sSearchName		As String		'// search sheet name	

	'// code.
	ON ERROR GOTO ErrorHandler

	'// get access to the document.
	document   = ThisComponent.CurrentController.Frame
	dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

if true then
   GoTo OnlyDoSearch
endif	
	sThisName = fsGetPubSheetName()		'// get PubTerr sheet name
	MoveToSheet(sThisName)
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	sThisName = oSheet.getName()
	if InStr(sThisName, "PubTerr") = 0 then
	   msgbox("SuperToUntitled - NOT in PubTerr sheet; cannot copy")
	   GoTo NormalExit
	endif		'// not in PubTerr sheet
	
	'// Now copy the PubTerr sheet to Untitled 1.

rem get access to the document
rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
args1(0).Value = ""
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())

	msgbox("Pub_Terr saved to new Untitled sheet" + CHR(13)+CHR(10)_
		+ "Click or Enter to continue...")

OnlyDoSearch:		
	'// now Move to Search sheet.
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheets = oDoc.Sheets()
	oSheet = oDoc.Sheets(iSheetIx)

if true then
	GoTo GetSrchName
endif
dim iNameLen		As Integer		'// search sheet name base length
	iNameLen = len(sThisName) - 7	'// name length sans 'PubTerr'
	sSearchName = left(sThisName, iNameLen) + "Search"
	sSearchName = gsNewSheet
	bSheetExists = oSheets.hasByName(sSearchName)
	if bSheetExists then
		MoveToSheet(sSearchName)
	else
		msgbox(sSearchName + " sheet not found; Search sheet not copied")
		GoTo NormalExit
	endif	'// end Search sheet exists conditional
	
GetSrchName:
	sSearchName = fsGetSrchSheetName()
	
if true then
	GoTo SkipStuff
endif

if not true then
	msgbox("Index of target sheet is " + iSheetIx)
	goto NormalExit
endif

rem ----------------------------------------------------------------------
dim args2(0) as new com.sun.star.beans.PropertyValue
args2(0).Name = "Nr"
args2(0).Value = 4

dispatcher.executeDispatch(document, ".uno:JumpToTable", "", 0, args2())

SkipStuff:

	'// now copy the Search sheet to Untitled.
rem ----------------------------------------------------------------------
dim args3(2) as new com.sun.star.beans.PropertyValue
args3(0).Name = "DocName"
args3(0).Value = ""
args3(1).Name = "Index"
args3(1).Value = 32767
args3(2).Name = "Copy"
args3(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args3())
	
	'// now in the "Untitled.ods" workbook...
	'// rename the "Untitled.ods" Search sheet, dropping the nn suffix.
dim oDocUntitled	As Object
'dim oSheets			As Object
dim sSheetName		As String
dim sShortName		As String
	oDocUntitled = ThisComponent
	oSheets = oDocUntitled.Sheets
	oSheet = oDocUntitled.Sheets(0)
	sSheetName = oSheet.Name
	sShortName = left(sSheetName, len("Terrxxx_Search"))
	RenameSheet(sShortName)
	

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SuperToUntitled - unprocessed error")
	GoTo NormalExit
	
end sub		'// SuperToUntitled		7/13/21.	18:34
