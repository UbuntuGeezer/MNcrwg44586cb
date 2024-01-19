'// CyclePubTerr.bas
'//---------------------------------------------------------------
'// CyclePubTerr - Cycle Terrxxx_PubTerr sheet name, renaming it.
'//		11/25/21.	wmk.	07:44
'//---------------------------------------------------------------

public sub CyclePubTerr( poZipHdrDoc AS Object )

'//	Usage.	macro call or
'//			call CyclePubTerr( oZipHdrDoc )
'//
'//		oZipHdrDoc = zipcode header workbook
'//
'// Entry.	oZipHdrDoc workbook has 2 sheets; 2nd is PubTerr sheet.
'//
'//	Exit.	Sheets(cnPubTerrIx) removed.
'//
'// Calls.	DeleteSheet.
'//
'//	Modification history.
'//	---------------------
'//	11/23/21.		wmk.	original code.
'// 11/25/21.		wmk.	delete msgbox deactivated;delete unconditional.
'//
'//	Notes.
'//

'//	constants.
const cnPubTerrIx = 1

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler

if 1 = 0 then
dim sSheetName	As String
	sSheetName = poZipHdrDoc.Sheets(cnPubTerrIx).Name
	msgbox("Sheet name = " & sSheetName & "will be deleted." _
	 & chr(13) & chr(10) _
	        & "In CyclePubTerr")
endif

	DeleteSheet(poZipHdrDoc, cnPubTerrIx)

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CyclePubTerr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CyclePubTerr	11/25/21.	07:44
