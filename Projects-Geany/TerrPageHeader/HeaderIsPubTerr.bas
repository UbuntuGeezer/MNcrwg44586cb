'// HeaderIsPubTerr.bas
'//------------------------------------------------------------------
'// HeaderIsPubTerr - Rename zipcode header sheet to Terrxxx_PubTerr.
'//		11/25/21.	wmk.	07:51
'//------------------------------------------------------------------

public sub HeaderIsPubTerr(poPubTerrDoc As Object)

'//	Usage.	macro call or
'//			call HeaderIsPubTerr(oPubTerrDoc)
'//
'//		oPubTerrDoc = Terrxxx_PubTerr workbook
'//
'// Entry.	gsTerrID = territory ID working on
'//
'//	Exit.	oPubTerrDoc.Sheet(TerrHdr<zipcode>) renamed to Terr<gsTerrID>_PubTerr
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/21/21.	wmk.	original code.
'//	11/23/21.	wmk.	gsTerrID territory ID used for name generation.
'//	11/24/21.	wmk.	use global gsTerrID.
'// 11/25/21.	wmk.	msgbox deactivated; Remove unconditional.
'//
'//	Notes. <Insert notes here>
'//

'//	constants.
csZipSheetIx = 0		'// TerrZipHdr sheet index

'//	local variables.
dim sSheet1Name		As String
dim sSheet2Name		As String
'dim gsTerrID		As String

	'// code.
	ON ERROR GOTO ErrorHandler
'	gsTerrID = "235"		'// forced for now..
	sSheet1Name = poPubTerrDoc.Sheets(0).Name
	sSheet2Name = "Terr" & gsTerrID & "_PubTerr"

if 1 = 0 then
	msgbox("Sheet1 name = " & sSheet1Name & chr(13) & chr(10) _
		& "will be changed to" & sSheet2Name _
		& chr(13) & chr(10) _
	        & "In HeaderIsPubTerr")
endif

	RenameSheet(poPubTerrDoc, csZipSheetIx, sSheet2Name)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("HeaderIsPubTerr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end HeaderIsPubTerr		11/25/21.	07:51
