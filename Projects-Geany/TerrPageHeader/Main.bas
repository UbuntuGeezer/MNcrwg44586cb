'// Main.bas
'//---------------------------------------------------------------
'// Main - Main for AddPubTerrHdr
'//		11/24/21.	wmk.	20:58
'//---------------------------------------------------------------

Sub Main

'//	Usage.	macro call or
'//			call Main()
'//
'// Entry.	Sheet TerrList has list of territories to process.
'//			Sheet UpdateMaster exists.
'//
'//	Exit.	Territories from TerrList have _PubTerr and
'//			 _SuperTerr files generated.
'//
'// Calls. 	OpenPubTerr, MoveToDocSheet, PickACell, fsGetZipCode,
'//			OpenZipHdr, CopyTerrRecsToHdr, SetTerrColWidths()
'//			CyclePubTerr, HeaderIsPubTerr, SaveAs, ExportPDF.
'//
'//	Modification history.
'//	---------------------
'//	7/15/21.	wmk.	original code.
'// 7/21/21.	wmk.	standard header comments added; mod
'//						to skip copying UpdateMaster to
'//						separte workbook, leave in place; assume
'//						UpdateMaster sheet exists; dead code
'//						removed.
'// 9/4/21.		wmk.	LoadAllLibs call added so can run from
'//						function reference.
'// 11/11/21.	wmk.	timestamping beginning/end territory process.
'// 11/22/21.	wmk.	bug fix to correct sequencing of PubTerr close
'//						operation.
'//	11/23/21.	wmk.	dead code removed; activate SetColumnWidths,
'//						CyclePubTerr, HdrIsPubTerr
'// 11/24/21.	wmk.	set gsTerrID for module-wide use; change to
'//						copy super territory Search back into PubTerr.xlsx
'//						to preserve header information.
'//
'//	Notes. This macro/sub is cornerstone for processing
'// territories "en masse" after updating the download data.
'//

'//	constants.

'//	local variables.

dim nTerrs		As Integer
dim	oDoc		As Object
dim oSheet		As Object
dim oCell		As Object
dim sCellStr	As String
dim bMoreCells	As Boolean
dim iCellIndex	As Integer
dim sTerrID		As String
dim oCellTime	As Object		'// cell for time recording

dim sZipCode	As String		'// current zip code
dim oPubTerrDoc	As Object		'// publisher territory document
dim oZipHdrDoc	As Object		'// zipcode header document
dim sPTZip		As String		'// zip code from pubterr document

	'//	Code.
	ON ERROR GoTo ErrorHandler
	LoadAllLibs()
	nTerrs = 0
	oDoc = ThisComponent
	oSheet = oDoc.Sheets(0)
	bMoreCells = true
	iCellIndex = 5
	do while bMoreCells
		oCell = oSheet.getCellByPosition(0,iCellIndex)
		sCellStr = oCell.String
		bMoreCells = (strcomp(left(sCellStr,1),"$") <> 0)	
		if not bMoreCells then 
			exit do
		endif

		if (strcomp(left(sCellStr,1),"#") = 0) then
			iCellIndex = iCellIndex + 1
			GoTo NextCell	
		endif

		'// record time stamp start.
		oCellTime = oSheet.getCellByPosition(1,iCellIndex)
		oCellTime.SetValue(NOW()) 
		sTerrID = sCellStr
		gsTerrID = sTerrID
		OpenPubTerr(sTerrID, oPubTerrDoc)

		'// Terr&sTerrID&_PubTerr is sheet.
		MoveToDocSheet(oPubTerrDoc, "Terr" & sTerrID & "_PubTerr")
		PickACell()
		sPTZip = fsGetZipCode(oPubTerrDoc)

if 1 = 0 then
xray oPubTerrDoc
endif

		'// close PubTerr workbook
		'// use uno.Close to close PubTerr workbook.
dim document	As Object
dim dispatcher	As Object
		document   = oPubTerrDoc.CurrentController.Frame
		dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

		dim Array3()
		dispatcher.ExecuteDispatch(document, ".uno:Close", 0, "", Array3())	
		oPubTerrDoc.close(true)

if 1 = 0 then		
bMoreCells = false
GoTo NextCell
endif


		'// now open proper zip code header.
		OpenZipHdr(sPTZip, oZipHdrDoc)

		'// re-open PubTerr workbook.
		OpenPubTerr(sTerrID, oPubTerrDoc)
		PickACell()

if 1 = 0 then
		'// Terr&sTerrID&_PubTerr is sheet.
		MoveToDocSheet(oPubTerrDoc, "Terr" & sTerrID & "_PubTerr")
		PickACell()
endif
		'// insert PubTerr sheet at end of Zipcode workbook.
		CopyPubToHdrZip(oPubTerrDoc, oZipHdrDoc)
		'// move to PubTerrSheet just copied.

		'// close PubTerr workbook
		'// use uno.Close to close PubTerr workbook.
'		dim document	As Object
'		dim dispatcher	As Object
		document   = oPubTerrDoc.CurrentController.Frame
		dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

		dim Array5()
		dispatcher.ExecuteDispatch(document, ".uno:Close", 0, "", Array5())	
		oPubTerrDoc.close(true)

		MoveToSheet(oZipHdrDoc, "Terr" & sTerrID & "_PubTerr")
		PickACell()
		'// copy territory sheet data to header sheet.
		CopyTerrRecsToHdr(oZipHdrDoc, sPTZip)
						

		
		'// set sheet column widths.
		MoveToDocSheet(oZipHdrDoc, "TerrHdr" & sPTZip)
		PickACell()'// CopyToPubTerr.bas - Copy current worksheet to end of Terrxxx_PubTerr.ods.

		SetSheetColWidths(oZipHdrDoc, 0)
		
'		MoveToDocSheet(oPubTerrDoc, "Terr" & sTerrID & "_PubTerr")
'		PickACell()
		
		'// Rename PubTerrSheet.
		CyclePubTerr(oZipHdrDoc)
		
		'// Make Zip Header sheet PubTerr sheet.
		HeaderIsPubTerr(oZipHdrDoc)
		
		'// Save ZipHdr doc as PubTerr.
dim sURL	As	String
		sURL = "file:///media/ubuntu/Windows/Users/Bill/Territories/TerrData" _
		 & "/Terr" & sTerrID & "/Terr" & sTerrID & "_PubTerr.ods"
		SaveAs(oZipHdrDoc, sURL)

		'// Export PubTerr.ods as PDF.
		ExportPDF(oZipHdrDoc)
						
		'// Copy PubTerr sheet into super territory.
'		CopyPubToSuper(oZipHdrDoc)

		'// Save PubTerr as .xlsx and copy SuperTerr/Search into it.
		CopySuperToPub(oZipHdrDoc)
		'// Note: CopySuperToPub closes super territory.

		'// Move back to PubTerr sheet and SaveAs Terrxxx_SuperTerr.xlsx.
		MoveToDocSheet(oZipHdrDoc, "Terr" & sTerrID & "_Pubterr")
		sURL = convertToURL(csTerrBase & "/Terr" & sTerrID _
		   & "/Terr" & sTerrID & "_SuperTerr.xlsx")
		SaveAs(oZipHdrDoc, sURL)
	
		'// close oZipHdrDoc.
		'// close SuperTerr workbook.
		'// use uno.Close to close PubTerr workbook.
'		dim document	As Object
'		dim dispatcher	As Object
		document   = oZipHdrDoc.CurrentController.Frame
		dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

		dim Array6()
		dispatcher.ExecuteDispatch(document, ".uno:Close", 0, "", Array6())	
		oZipHdrDoc.close(true)

	
if 1 = 0 then		
bMoreCells = false
GoTo NextCell
endif

if 1 = 0 then
dim oPTSel	As Object
dim oPTSheet	As Object
dim oPTRange	As Object
dim oPTCell		As Object
dim iPTSheetIX	As Integer
		oPTSel = oPubTerrDoc.getCurrentSelection()
		oPTRange = oPTSel.RangeAddress
		iPTSheetIX = oPTRange.Sheet
		oPTSheet = oPubTerrDoc.Sheets(iPTSheetIX)
		oCell = oPTSheet.getCellByPosition(1,2)
		sPTZip = oCell.String
		oPTSheet = oPubTerrDoc.Sheets(iPTSheetIX)
'		CopyTerrRecsToHdr1("34284")
'		msgbox(oPTSheet.Name & " zip code = " & sPTZip)
'		DoTerrWithCalc(sTerrID)
'		DoSuperWithCalc(sTerrID)
endif

		'// record time stamp finish.
		MoveToDocSheet(oDoc, "AddPubTerrHdr")
		oCellTime = oSheet.getCellByPosition(2,iCellIndex)
		oCellTime.SetValue(NOW()) 
		oCell.String = "#" & sTerrID		'// update list as processed
		nTerrs = nTerrs + 1
		iCellIndex = iCellIndex + 1
NextCell:
	loop

'	MoveToDocSheet(oDoc, "AddPubTerrHdr")

if 1 = 1 then
  GoTo AllDone
endif

	
AllDone:
	msgbox( nTerrs & " territories processed" & chr(13) & chr(10)_
	   & "Territory processing complete.")

NormalExit:
	exit sub

ErrorHandler:
	msgbox("in Main - unprocessed error.")
	GoTo NormalExit
	
End Sub		'// end main	11/24/21.	20:58
