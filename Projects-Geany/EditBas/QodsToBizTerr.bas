'// QodsToBizTerr.bas
'//-------------------------------------------------------------------
'// QodsToBizTerr - Take SQL Territory query .csv data to PubTerr sheet.
'//		12/23/21.	wmk.	16:39
'//-------------------------------------------------------------------
	
public sub QodsToBizTerr(psTerrID As String)

'//	Usage.	call QodsToBizTerr(sTerrID)
'//
'//		sTerrID = territory ID to process to PubTerr
'//
'// Entry.	~Territories/.../TerrData/Terrxxx/Working-Files/QTerrxxx.ods
'//			  contains territory records worksheet QTerrxxx and header
'//			  worksheet TerrxxxHdr to use as base for territory build
'//		Assume all sheets are closed on entry, then start clean by re-opening
'//		the workbooks/sheets needed.
'//
'//	Exit.	2 new sheets generated; Terrxxx-Bridge and Terrxxx_PubTerr.
'//			The Terxxx_PubTerr is also copied to a new workbook, which
'//			the user can save as a "ready-to-go" territory.
'//
'// Calls.	PickACell, CopyToEnd, UnprotectSheet,
'//			*[QGetToBridge] QGetToBizBridge
'// 		RenameSheet,
'//			*[BridgeToTerr3] BizBridgeToBiz
'//			CopyBizToNewWork, fsSetPubSheetName
'//
'//	Modification history.
'//	---------------------
'// 9/25/21.	wmk.	original code; adapted from QodsToPubTerr;
'//						csTerrBase constant changed; sPubTerrBase changed
'//						to '_BizTerr' from '_PubTerr'; if 1=0 sections
'//						removed.
'// 9/26/21.	wmk.	QGetToBridge replaced with QBizGetToBridge;
'//						BridgeToTerr3 replaced with BizBridgeToBiz;
'//						entry assumes all workbooks/spreadsheets are closed
'//						and ready for re-open for processing.
'// 9/29/21.	wmk.	replace CopyToNewWork with CopyBizToNewWork.
'// Legacy mods.
'//	7/11/21.	wmk.	original code; adpated from QToPubTerr3; mod 
'//				 history retained for reference.
'// 2/20/21.	wmk.	move forward to use BridgeToTerr3.
'// 3/16/21.	wmk.	preserve PubTerr sheet name for use
'//				 by other subs via fsSetPubSheetName.
'//	7/9/21.		wmk.	oDoc and oSel assignments moved ahead of all other code;
'//				 PickACell called to anchor focus; code modified to use
'//				 URL to extract territory ID instead of $D$4.
'//	7/12/21.	wmk.	depend on BridgeToTerr3 to save QTerrxxx.ods after PubTerr
'//				 generated; move sheet saving code to CopyToNewWork;
'//				 remove call to ProtectSheet after Bridge; after
'//				 BridgeToTerr3, re-open QTerrxxx.ods for subsequent
'//				 operations.
'// 12/23/21.	wmk.	updated to use csTerrBase, csBTerrDataPath for
'//				 multihost support.
'//
'//	Notes. QodsToBizTerr opens the Working-Files QTerrxxx.ods, instead of
'//	expecting it open on entry.

'//	constants.
const COL_D=3
const ROW_4=3

'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/BTerrData/"
'const csTerrBase = "defined above"
'const csBTerrDataPath = "defined above"

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
    sFullTargPath = csBTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".ods"
		
dim Args(1)	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args(1).name = "FilterName"
	Args(1).Value = "calc8"
	Args(0).name = "Hidden"
	Args(0).value = False
	oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())
	PickACell()
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	CopyToEnd()
	UnprotectSheet()
'//	QGetToBridge()
	QGetToBizBridge()

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
'//	BridgeToTerr3()
	BizBridgeToBiz()

	'// now re-open QTerrxxx.ods
    sFullTargPath = csBTerrDataPath &amp; sBasePath &amp; sTerrID &amp; "/Working-Files/"_ 
		&amp; sBaseName &amp; sTerrID &amp; ".ods"
		
dim Args4(1)	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args4(1).name = "FilterName"
	Args4(1).Value = "calc8"
	Args4(0).name = "Hidden"
	Args4(0).value = False
	oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args4())

'	sSheetName = "Terr" + sTerrID + "_BizTerr"
'	RenameSheet(sSheetName)
'	fsSetPubSheetName(sSheetName)
'	ProtectSheet()

	CopyBizToNewWork(sSheetName)

	oTestDoc.Close(1)

'dim oQTerrDoc	As Object
'	oQTerrDoc = ThisComponent.CurrentController.Frame
'	oQTerrDoc.close(1)

'oPubTerrDoc.close(1)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("QodsToBizTerr - unprocessed error")
	GoTo NormalExit
	
end sub 	'// end QodsToBizTerr	12/23/21.	16:39
