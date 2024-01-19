'// BridgeToSuper.bas - Bridge sheet to Super territory sheets.
'//---------------------------------------------------------------
'// BridgeToSuper- Bridge sheet to Super territory sheets.
'//		12/23/21.	wmk.	21:09
'//---------------------------------------------------------------

public sub BridgeToSuper()

'//	Usage.	macro call or
'//			call BridgeToSuper()
'//
'// Entry.	Bridge sheet exists in workbook for territory
'//
'//	Exit.	gsNewSheet = new Search sheet name	
'//
'// Calls.	CopyToEnd, UnProtectSheet, BridgeToEdit2, RenameSheet,
'//			EditToSearch
'//'// Search sheet, dropping the nn suffix.
'//			fsSetSrchSheetName, SelectSrchSheetArea,
'//			WrapLong, HltAddrBlocks4, PickACell, FreezeView,
'//			SuperToUntitled
'//
'//	Modification history.
'//	---------------------
'//	3/14/21.	wmk.	original code
'//	3/16/21.	wmk.	new Search sheet name stored in public
'//						var gsNewSheet; SuperToUntitled call added.
'//	3/17/21.	wmk.	fsGetSrchSheetName, MoveToSheet calls added
'//						code added to move to Bridge sheet if not 
'//						already there.
'//	7/12/21.	wmk.	mods to push code ahead to closing QTerrxxx.ods
'//						and copy Searchnn sheet to Untitled workbook;
'//						eliminate non-error msgbox's to avoid Frame
'//						management issues; sheet protection eliminated
'//						to avoid Frame management issues.
'//	7/13/21.	wmk.	documentation brought up-to-date;_PubTerr.ods 
'//				 correction; oDoc double-defined; bug fixes to
'//				 untitled through final save; save as .xlsx
'// 10/4/21.	wmk.	error message 'recogonized' corrected.
'// 12/23/21.	wmk.	modified to use module-wide constants csTerrBase, csTerrDataPath for
'//				 multihost support.
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
'const csTerrBase = "set above"

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

	sTerrID = fsGetTerrID()	
	'// verify sheet type by sheet name
	sCurrName = oSheet.getName()
	bIsBridge = InStr(sCurrName, "Bridge") &gt; 0
	
	if bIsBridge then
'		msgbox("Sheet is type Bridge... proceeding")
	else
		msgbox("Sheet not recognized as Bridge..")
		GoTo ErrorHandler
	endif
	
if not true then
  GoTo NormalExit
endif

	'// copy sheet to end and run BridgeToEdit
	CopyToEnd()
	UnprotectSheet()
	BridgeToEdit2()

	'// rename "Bridge" portion to "Edit" with random number to avoid conflicts.
	iBridgePos = InStr(sCurrName,"Bridge")
	sNewName = left(sCurrName,iBridgePos-1) + "Edit" + INT(100*RND())
	RenameSheet(sNewName)

	'// copy Edit sheet to end and convert to Search sheet.
'	ProtectSheet()
	CopyToEnd()
'	UnprotectSheet()
	EditToSearch3()
	'// focus on Terrxxx_Searchnn sheet
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
	
	'// New code. 7/12/21.
	PickACell				'// move to $A$6
	FreezeView				'// freeze rows/columns at $A$6

'	oSuperSheetDoc.Store	'// save work to this point
dim oSuperSheetDoc	As Object
	oSuperSheetDoc = ThisComponent.CurrentController.Frame
	'// use uno:Save to save again..
dim dispatcher	As Object
dim Array()
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
dispatcher.executeDispatch(oSuperSheetDoc, ".uno:Save", "", 0, Array())
	
	SuperToUntitled			'// copy sheet to untitled sheets

	'// now have Terrxxx_Searchnn sheet in QTerrxxx.ods
	oSuperSheetDoc.close(1)

	'// now ready to append Untitled to _PubTerr to produce SuperTerr.
dim oDocUntitled	As Object
	oDocUntitled = ThisComponent.CurrentController.Frame

dim sBaseName		As String
dim sBasePath		As String
dim sTargPath		As String
dim sFullTargPath	As String
dim sTargetURL		As String
dim oTestDoc2		As Object
'	sTerrID = {set above}	
	sBaseName = "QTerr"
	sBasePath = "/Terr"
	sTargPath = sBasePath &amp; sTerrID

	'// open Terrxxx_PubTerr.ods - publisher territory
	sFullTargPath =  csTerrDataPath  &amp; sTargPath _ 
		&amp; sTargPath &amp; "_PubTerr.ods"
		
dim Args1(1)	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args1(1).name = "FilterName"
	Args1(1).Value = "calc8"
	Args1(0).name = "Hidden"
	Args1(0).value = False
	oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args1())


	
	'// use uno:Move to copy Untitled.Searchnn sheet to end of _PubTerr.
'dim document	As Object
'dim dispatcher	As Object
rem ----------------------------------------------------------------------
rem get access to the document
'document   = ThisComponent.CurrentController.Frame
'dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args2(2) as new com.sun.star.beans.PropertyValue
args2(0).Name = "DocName"
args2(0).Value = "Terr" &amp; sTerrID &amp; "_PubTerr"
args2(1).Name = "Index"
args2(1).Value = 32767
args2(2).Name = "Copy"
args2(2).Value = true

dispatcher.executeDispatch(oDocUntitled, ".uno:Move", "", 0, args2())
'dim oDoc	As Object
'dim oSel	As Object


oDoc = ThisComponent.CurrentController.Frame
oDocUntitled.Close(1)	

	'// use uno:Save As to save resultant _PubTerr as _SuperTerr.
dim sSuperTargURL	As String
dim sSuperTargPath	As String
	sSuperTargPath =  csTerrDataPath &amp; sTargPath _ 
		&amp; sBasePath &amp; sTerrID &amp; "_SuperTerr.ods"
	sSuperTargURL = convertToURL(sSuperTargPath)

dim args3(1) as new com.sun.star.beans.PropertyValue
args3(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories
'                    /TerrData/Terrxxx/TerrData/Terrxxx_PubTerr.ods"
args3(0).Value = sSuperTargURL
args3(1).Name = "FilterName"
args3(1).Value = "calc8"

dispatcher.executeDispatch(oDoc, ".uno:SaveAs", "", 0, args3())

'// now repeat Save As to .xlsx.
sSuperTargURL = left(sSuperTargURL, len(sSuperTargURL)-3) &amp; "xlsx"
dim args4(1) as new com.sun.star.beans.PropertyValue
args4(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories
'                    /TerrData/Terrxxx/TerrData/Terrxxx_PubTerr.ods"
args4(0).Value = sSuperTargURL
args4(1).Name = "FilterName"
args4(1).Value = "Calc MS Excel 2007 XML"

dispatcher.executeDispatch(oDoc, ".uno:SaveAs", "", 0, args4())

oDoc.Close(1)

	
NormalExit:
	exit sub
	
ErrorHandler:
	ON ERROR GOTO
	msgbox("In BridgeToSuper - unprocessed error.")
	GOTO NormalExit
	
end sub		'// BridgeToSuper	'// 12/23/21.	21:09
