'// QodsToPubTerr.bas
'//-------------------------------------------------------------------
'// QodsToPubTerr - Take SQL Territory query .csv data to PubTerr sheet.
'//		12/23/21.	wmk.	21:05
'//-------------------------------------------------------------------
	
public sub QodsToPubTerr(psTerrID As String)

'//	Usage.	call QodsToPubTerr(sTerrID)
'//
'//		sTerrID = territory ID to process to PubTerr
'//
'// Entry.	~Territories/.../TerrData/Terrxxx/Working-Files/QTerrxxx.ods
'//			  contains territory records worksheet QTerrxxx and header
'//			  worksheet TerrxxxHdr to use as base for territory build
'//
'//	Exit.	2 new sheets generated; Terrxxx-Bridge and Terrxxx_PubTerr.
'//			The Terxxx_PubTerr is also copied to a new workbook, which
'//			the user can save as a "ready-to-go" territory.
'//
'// Calls.	CopyToEnd, UnprotectSheet, QGetToBridge, RenameSheet,
'//			BridgeToTerr3, CopyToNewWork, fsSetPubSheetName
'//
'//	Modification history.
'//	---------------------
'//	7/11/21.	wmk.	original code; adpated from QToPubTerr3; mod 
'//						history retained for reference.
'// 2/20/21.	wmk.	move forward to use BridgeToTerr3.
'// 3/16/21.	wmk.	preserve PubTerr sheet name for use
'//						by other subs via fsSetPubSheetName.
'//	7/9/21.		wmk.	oDoc and oSel assignments moved ahead of all other code;
'//						PickACell called to anchor focus; code modified to use
'//						URL to extract territory ID instead of $D$4.
'//	7/12/21.	wmk.	depend on BridgeToTerr3 to save QTerrxxx.ods after PubTerr
'//				 generated; move sheet saving code to CopyToNewWork;
'//				 remove call to ProtectSheet after Bridge; after
'//				 BridgeToTerr3, re-open QTerrxxx.ods for subsequent
'//				 operations.
'// 12/23/21.	wmk.	modified to use csTerrBase, csTerrDataPath module-wide
'//				 variables for multihost support.
'//
'//	Notes. QodsToPubTerr opens the Working-Files QTerrxxx.ods, instead of
'//	expecting it open on entry.

'//	constants.
const COL_D=3
const ROW_4=3
'const csTerrBase = "defined above"
'const csTerrDataPath = "defined above" 


'//	local variables.
dim oDoc		As Object
dim oSel		As Object
dim oRange		As Object
dim iSheetIx	As Integer
dim oSheet		As Object
dim oCell		As Object
dim sTerrID		As String
dim sSheetName	As String

dim oTestDoc	As Object
dim sBaseName	As String
dim sBasePath	As String
dim sTargPath	As String
dim sFullTargPath	As String
dim sTargetURL	As String

'// code.
	ON ERROR GOTO ErrorHandler

	'// open QTerrxxx.ods to process.
	oTestDoc = ThisComponent
	sTerrID = psTerrID
	sBaseName = "QTerr"
	sBasePath = "/Terr"
	sTargPath = sBasePath &amp; sTerrID

	'// open QTerrxxx.ods
    sFullTargPath = csTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".ods"
		
dim Args(1)	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args(1).name = "FilterName"
	Args(1).Value = "calc8"
	Args(0).name = "Hidden"
	Args(0).value = False
	oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())

if 1 = 0 then
  GoTo NormalExit
endif

	PickACell()
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	CopyToEnd()
	UnprotectSheet()
	QGetToBridge()

	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

dim sDocURL		As	String
dim nURLlen		As	Integer
dim sURLBase	As	String
dim sFileBase	As	String
dim sHdrFile	As	String

	'// modify code to get sTerrID from URL ...QTerrxxx.ods
	sDocURL = ThisComponent.getURL()
	'// expected URL = ../TerrData/Working-Files/QTerrxxx.ods
	nURLlen = len(sDocURL)
	sURLBase = left(sDocURL, nURLLen-12)	'// up to last '/'
	sFileBase = right(sDocURL,11)	'// Terrxxx.ods
	sHdrFile = left(sFileBase,7) + "Hdr" + right(sFileBase,4)
	sTerrID = mid(sFileBase,5,3)
		
'	oCell = oSheet.getCellByPosition(COL_D, ROW_4)
'	sTerrID = trim(oCell.String)
	sSheetName = "Terr" + sTerrID + "_Bridge"
	RenameSheet(sSheetName)
'	ProtectSheet()								'// protect sheet

	CopyToEnd()
	UnprotectSheet()
	BridgeToTerr3()

	'// now re-open QTerrxxx.ods
    sFullTargPath = csTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".ods"
		
dim Args4(1)	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args4(1).name = "FilterName"
	Args4(1).Value = "calc8"
	Args4(0).name = "Hidden"
	Args4(0).value = False
	oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args4())

'	sSheetName = "Terr" + sTerrID + "_PubTerr"
'	RenameSheet(sSheetName)
'	fsSetPubSheetName(sSheetName)
'	ProtectSheet()

if 1 = 0 then
'//================================================================
'// inline code to save sheet...
'dim oQTerrDoc	As Object
dim Array()

'	oQTerrDoc = ThisComponent.CurrentController.Frame
'	oQTerrDoc.Store
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
'dispatcher.executeDispatch(oQTerrDoc, ".uno:Save", "", 0, Array())
'//===============================================================
endif

	CopyToNewWork(sSheetName)

if 1 = 0 then
'//============================================================
'// now focus is on Untitled x.ods new workbook; save it
'// there is no URL for it, so will have to generate a SaveAs
'// uno request...
dim sPubTerrURL		As String
dim sPubTargPath	As String
dim sPubTerrBase	As String
dim sPubTargURL		As String
dim oPubTerrDoc		As Object
	oPubTerrDoc = ThisComponent.CurrentController.Frame
	sPubTerrBase = "_PubTerr"
    sPubTargPath = csTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/"_ 
		&amp; sBasePath &amp; sTerrID &amp; sPubTerrBase &amp; ".ods"
	sPubTargURL = convertToURL(sPubTargPath)
	
	'// inline SaveAs to save Terrxxx_PubTerr.ods

rem ----------------------------------------------------------------------
rem get access to the document
dim document   as object
'dim dispatcher as object

'document   = ThisComponent.CurrentController.Frame
'dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(1) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories
'                    /TerrData/Terrxxx/TerrData/Terrxxx_PubTerr.ods"
args1(0).Value = sPubTargURL
args1(1).Name = "FilterName"
args1(1).Value = "calc8"

dispatcher.executeDispatch(oPubTerrDoc, ".uno:SaveAs", "", 0, args1())
'//===========================================================================
endif

if 1 = 0 then
'//===========================================================
	'// Now reformat as Landscape with grid.
'	oPubTerrDoc = ThisComponent.CurrentController.Frame
'	SetGridLand()
'	oPubTerrDoc.Store

	'// Now save as .xlsx
	SaveXlsx()
	
	'// Now save as .pdf.
'	ExportPDF()
	ExportTerrAsPDF1()
	
document   = ThisComponent.CurrentController.Frame
document.close(1)
'oQTerrDoc.close(1)
'//==========================================================
endif

oTestDoc.Close(1)
'dim oQTerrDoc	As Object
'	oQTerrDoc = ThisComponent.CurrentController.Frame
'	oQTerrDoc.close(1)

'oPubTerrDoc.close(1)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("QodsToPubTerr - unprocessed error")
	GoTo NormalExit
	
end sub 	'// end QodsToPubTerr		12/23/21.	21:06
