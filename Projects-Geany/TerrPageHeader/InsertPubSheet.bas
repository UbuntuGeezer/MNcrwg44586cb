'// InsertPubSheet.bas
'//-------------------------------------------------------------------------
'// InsertPubSheet - Insert PubTerrsheet at end of Zipcode workbook.
'//		11/21/21.	wmk.	16:05
'//-------------------------------------------------------------------------

public sub InsertPubSheet( poZipDoc  AS Object, poPubTerrDoc AS Object )

'//	Usage.	macro call or
'//			call InsertPubSheet(oZipHdrDoc, oPubTerrDoc)
'//
'//		oZipHdrDoc = zip code header workbook
'//		oPubTerrDoc = publisher territory workbook
'//
'// Entry.	<entry conditions>
'//
'//	Exit.	oPubTerrDoc.Sheet(Terrxxx_PubTerr) inserted at end of
'//			  oZipHdrDoc workbook
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/21/21.		wmk.	original code.
'//
'//	Notes. Move/Copy sheet does not copy the Header/Footer Style information.
'// For this reason, the PubTerr sheet must be copied to the end of the
'// zipcode workbook. Then the PubTerr sheet information will be copied back
'// into the zipcode worksheet. This retains the Header/Footer style information.
'// Then the sheet is saved as Terrxxx_PubTerrH.ods. The rest may be accomplished
'// with shell file copying commands.
'//

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler
	
dim sSheetName	As String

if 1 = 1 then
 Xray poZipDoc
endif

	sTargURL = poZipDoc.URL
if 1 = 1 then
	sSheetName = poPubTerrDoc.Sheets(0).Name
	msgbox("Sheet name = " & sSheetName & chr(13) & chr(10) _
		& "to be inserted at end of" & chr(13) & chr(10) _
		& "Target URL not known yet" & chr(13) & chr(10) _
	        & "In InsertZipSheet")
else
	sSheetName = poPubTerrDoc.Sheets(0).Name
	msgbox("Sheet name = " & sSheetName & chr(13) & chr(10) _
		& "to be inserted at end of" & chr(13) & chr(10) _
		& sTargURL & chr(13) & chr(10) _
	        & "In InsertZipSheet")
endif
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("InsertPubSheet - unprocessed error")
	GoTo NormalExit
	
end sub		'// end InsertPubSheet		11/21/21.	16:05
