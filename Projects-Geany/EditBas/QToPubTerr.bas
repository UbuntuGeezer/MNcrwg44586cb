'// QToPubTerr.bas
'//------------------------------------------------------------------
'// QToPubTerr - Take SQL Territory query .csv data to PubTerr sheet.
'//		10/14/20.	wmk.
'//------------------------------------------------------------------
	
public sub QToPubTerr()

'//	Usage.	macro call or
'//			call QToPubTerr()
'//
'// Entry.	user in workbook with sheet "Terrxxx" that is the query
'//			data from the SQL territory database
'//			a second sheet "TerrxxxHdr should also have been loaded
'//			into the workbook, so that QGetToBridge has all the needed
'//			information for the sheet headings.
'//
'//	Exit.	2 new sheets generated; Terrxxx-Bridge and Terrxxx_PubTerr.
'//			The Terxxx_PubTerr is also copied to a new workbook, which
'//			the user can save as a "ready-to-go" territory.
'//
'// Calls.	CopyToEnd, UnprotectSheet, QGetToBridge, RenameSheet,
'//			BridgeToTerr, CopyToNewWork
'//
'//	Modification history.
'//	---------------------
'//	10/14/20.	wmk.	original code
'// 2/13/21.	wmk.	test call to BridgeToTerr2 for moving columns around
'//
'//	Notes.

'//	constants.
const COL_D=3
const ROW_4=3


'//	local variables.
dim oDoc		As Object
dim oSel		As Object
dim oRange		As Object
dim iSheetIx	As Integer
dim oSheet		As Object
dim oCell		As Object
dim sTerrID		As String
dim sSheetName	As String

'// code.
	ON ERROR GOTO ErrorHandler
	CopyToEnd()
	UnprotectSheet()
	QGetToBridge()

	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCell = oSheet.getCellByPosition(COL_D, ROW_4)
	sTerrID = trim(oCell.String)
	sSheetName = "Terr" + sTerrID + "_Bridge"
	RenameSheet(sSheetName)
	ProtectSheet()								'// protect sheet

	CopyToEnd()
	UnprotectSheet()
'	BridgeToTerr()
	BridgeToTerr2()
	
	sSheetName = "Terr" + sTerrID + "_PubTerr"
	RenameSheet(sSheetName)
	ProtectSheet()
	CopyToNewWork(sSheetName)

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("QToPubTerr - unprocessed error")
	GoTo NormalExit
	
end sub 	'// end QToPubTerr
