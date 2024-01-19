'// RUNewTerr_1.bas
'//---------------------------------------------------------------
'// RUNewTerr_1 - RefUSA new territory phase 1 process.
'//		10/16/20.	wmk.	22:15
'//---------------------------------------------------------------

public sub RUNewTerr_1()

'//	Usage.	macro call or
'//			call RUNewTerr_1()
'//
'// Entry.	user has loaded Terxxx.csv RefUSA raw data with column headings
'//			user has also (optionally) created TErrxxxHdr sheet with
'//			 essential territory definition fields set
'//
'//	Exit.	Terrxxx_Bridge.csv created and ready for SQL .import using
'//			RUNewTerr_2.sh proc
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/15/20.	wmk.	original code
'//	10/16/20.	wmk.	add CopyToEnd and delete 4 lines before copy
'//						to file for export; export sheet as .csv with
'//						name Terrxxx_Bridge.csv; mod to require
'//						TerrNewHdr to be present
'//	Notes.


'//	constants.
const DKLIME=6207774			'// DARKLIME color value

'//	local variables.
dim oDoc		As Object
dim oSel		As Object
dim oRange		As Object
dim oSheet		As Object
dim iSheetIx	As Integer
dim sSheetName	As String
dim sTerrID	As String		'// territory ID

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
		
	TabColor( DKLIME )
	ProtectSheet()
	CopyToEnd()
	UnprotectSheet()

	'// presort imported data
	SelectNewRows()
	
dim oDocument	As Object
dim oDispatcher	As Object
dim nColumns	As Integer
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	nColumns = ASC("S") - ASC("A")
dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "By"
	args2(0).Value = nColumns
oDispatcher.executeDispatch(oDocument, ".uno:GoRightSel", "", 0, args2())
	SortByStreetNum()

	ImportRefUSA()
	sTerrID = Mid(ThisComponent.getTitle(),5,3)
	sSheetName = "Terr" + sTerrID + "_Import"
	RenameSheet(sSheetName)
	ProtectSheet()
	CopyToEnd()
	
	UnprotectSheet()
	RUImportToBridge
	sSheetName = "Terr" + sTerrID + "_Import"
	RenameSheet(sSheetName)
	ProtectSheet()
	CopyToEnd()
	
	UnprotectSheet()
	'// pick up new sheet pointers
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	'// leave all header rows, since linked values will lose refs if delete
	sSheetName = "Terr" + sTerrID + "_IBridge"
	RenameSheet(sSheetName)
	ProtectSheet()
	CopyToNewWork()
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("RUNewTerr_1 - unprocessed error")
	GoTo NormalExit
	
end sub		'// end RUNewTerr_1		10/16/20
