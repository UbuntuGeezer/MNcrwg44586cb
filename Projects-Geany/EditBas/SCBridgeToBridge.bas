'// SCBridgeToBridge.bas
'//-------------------------------------------------------------------
'// SCBridgeToBridge - Make Admin-Bridge sheet from SCPA.csv download.
'//		9/21/20.	wmk.	06:45
'//-------------------------------------------------------------------

public sub SCBridgeToBridge()

'//	Usage.	macro call or
'//			call SCBridgeToBridge()
'//
'// Entry.	user has SCPA.csv download sheet selected
'//
'//	Exit.	Sheet has 4-row Admin-Bridge sheet header added; columns bold,
'//			view frozen at Row5
'//
'// Calls.	InsertTerrHdr, SetBridgeColWidths, BoldHeadings, FreezeView
'//
'//	Modification history.
'//	---------------------
'//	9/21/20.	wmk.	original code
'//
'//	Notes.

'//	constants.

'//	local variables.
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet
dim oMrgRange	As Object	'// merge range

dim oCell	As Object		'// cell working on

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	InsertTerrHdr("Admin-Bridge formatted sheet")
	SetBridgeHeadings()
	SetBridgeColWidths()
	BoldHeadings()
	FreezeView()

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SCBridgeToBridge - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SCBridgeToBridge	9/21/20
