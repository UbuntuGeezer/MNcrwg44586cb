'// BridgeToSuper1.bas - Bridge sheet to Super territory sheets.
'// OLDCODE...
'//---------------------------------------------------------------
'// BridgeToSuper- Bridge sheet to Super territory sheets.
'//		3/17/21.	wmk.	10:55
'//---------------------------------------------------------------

public sub BridgeToSuper1()

'//	Usage.	macro call or
'//			call BridgeToSuper()
'//
'// Entry.	user focused on Bridge sheet for territory
'//
'//	Exit.	gsNewSheet = new Search sheet name	
'//
'// Calls.	SetSrchSheetName, SuperToUntitled
'//
'//	Modification history.
'//	---------------------
'//	3/14/21.	wmk.	original code
'//	3/16/21.	wmk.	new Search sheet name stored in public
'//						var gsNewSheet; SuperToUntitled call added.
'//	3/17/21.	wmk.	fsGetSrchSheetName, MoveToSheet calls added
'//						code added to move to Bridge sheet if not 
'//						already there.
'//
'//	Notes. Executes the following sequence:
'// move to Bridge sheet
'// copy sheet to end
'// BridgeToEdit()
'// copy sheet to end
'// EditToSearch3
'// rename sheet "Terrxxx_Search"
'// moveto sheet TerrxxxPub_Terr
'// copy to "untitled1"
'// move back to sheet "TerrxxxSearch"
'// copy to "untitled2"


'//	constants.

'//	local variables.
dim oDoc		As Object		'// current component
dim oSel		As Object		'// current selection
dim oSheet		As Object		'// sheet selected
dim sCurrName	As String		'// current sheet name
dim bIsBridge	As String		'// sheet is Bridge type
dim oRange		As Object		'// RangeSelection 
dim iSheetIx	As Integer		'// current sheet index
dim iBridgePos	As Integer		'// "Bridge" string index
dim sNewName	As String		'// new sheet name
dim sTerrID		As String		'// territory ID
dim sBridgeName	As String		'// Bridge sheet name

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	sCurrName = oSheet.getName()
	
	if InStr(sCurrName, "Bridge") = 0 then
		'// move to Bridge sheet.
		sTerrId = fsGetTerrID()
		sBridgeName = "Terr" + sTerrID + "_Bridge"
		MoveToSheet(sBridgeName)
		oSel = oDoc.getCurrentSelection()
		oRange = oSel.RangeAddress
		iSheetIx = oRange.Sheet
		oSheet = oDoc.Sheets(iSheetIx)
	endif 		'// end not in Bridge sheet
	
	'// verify sheet type by sheet name
	sCurrName = oSheet.getName()
	bIsBridge = InStr(sCurrName, "Bridge") &gt; 0
	
	if bIsBridge then
		msgbox("Sheet is type Bridge... proceeding")
	else
		msgbox("Sheet not recogonized as Bridge..")
		GoTo ErrorHandler
	endif
	
if not true then
  GoTo NormalExit
endif

	'// copy sheet to end and run BridgeToEdit
	CopyToEnd()
	UnprotectSheet()
	BridgeToEdit()

	'// rename "Bridge" portion to "Edit" with random number to avoid conflicts.
	iBridgePos = InStr(sCurrName,"Bridge")
	sNewName = left(sCurrName,iBridgePos-1) + "Edit" + INT(100*RND())
	RenameSheet(sNewName)

	'// copy Edit sheet to end and convert to Search sheet.
	ProtectSheet()
	CopyToEnd()
	UnprotectSheet()
	EditToSearch3()
dim iEditPos As Integer		'// "Edit" position
	iEditPos = Instr(sNewName,"Edit")
	sNewName = left(sNewName, iEditPos-1) + "Search" + INT(100*RND())
	RenameSheet(sNewName)
	gsNewSheet = sNewName	'// preserve name
	fsSetSrchSheetName(sNewName)
	
if not true then
  msgbox("gsNewSheet = '" + gsNewSheet + "'")
endif

	SelectSrchSheetArea()
	WrapLong()
	HltAddrBlocks4()
	SuperToUntitled			'// copy sheets to untitled sheets

NormalExit:
	exit sub
	
ErrorHandler:
	ON ERROR GOTO
	msgbox("In BridgeToSuper - unprocessed error.")
	GOTO NormalExit
	
end sub		'// BridgeToSuper1	'// 3/17/21.	10:55
