'// InsertZipSheet.bas
'//-------------------------------------------------------------------------
'// InsertZipSheet - Insert zipcode header sheet at end of PubTerr workbook.
'//		11/21/21.	wmk.	06:59
'//-------------------------------------------------------------------------

public sub InsertZipSheet( poZipDoc  AS Object, poPubTerrDoc AS Object )

'//	Usage.	macro call or
'//			call InsertZipSheet(oZipHdrDoc, oPubTerrDoc)
'//
'//		oZipHdrDoc = zip code header workbook
'//		oPubTerrDoc = publisher territory workbook
'//
'// Entry.	<entry conditions>
'//
'//	Exit.	oZipHdr.Doc.Sheet(TerrHdr<zipcode>) inserted at end of
'//			  oPubTerrDoc workbook
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/21/21.		wmk.	original code.
'//
'//	Notes. <Insert notes here>
'//

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler
	
dim sSheetName	As String
	sSheetName = poZipDoc.Sheets(0).Name
	sTargURL = poPubTerrDoc.URL
	msgbox("Sheet name = " & sSheetName & chr(13) & chr(10) _
		& "to be inserted into" & chr(13) & chr(10) _
		& sTargURL & chr(13) & chr(10) _
	        & "In InsertZipSheet")
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("InsertZipSheet - unprocessed error")
	GoTo NormalExit
	
end sub		'// end InsertZipSheet		11/21/21.	06:59
