'// Main.bas
'//---------------------------------------------------------------
'// Main - Main for ProcessQTerrs12/
'//		8/12/23.	wmk.	13:43
'//---------------------------------------------------------------

Sub Main

'//	Usage.	macro call or
'//			call Main()
'//
'//
'// Entry.	Sheet(0) has list of territories to process.
'//			Sheet UpdateMaster exists.
'//
'//	Exit.	Territories from TerrList have _PubTerr and
'//			 _SuperTerr files generated.
'//
'// Calls. 	LoadAllLibs, AddUpdateMaster, CopyUMToUntitled,
'//			DoTerrWithCalc,	DoSuperWithCalc, SaveUMSheetAsCSV.
'//
'//	Modification history.
'//	---------------------
'// 8/12/23.	wmk.	modified for MNcrwg44586; csCodeBase introduced.
'// Legacy mods.
'// 10/30/22.	wmk.	mod to use fsUser to set gsUser; code to set module-wide
'//				 path variables.
'// 2/1/23.		wmk.	Sheets(0) replaces "TerrList" in documentation.
'// Legacy mods.
'//	7/15/21.	wmk.	original code.
'// 7/21/21.	wmk.	standard header comments added; mod
'//						to skip copying UpdateMaster to
'//						separte workbook, leave in place; assume
'//						UpdateMaster sheet exists; dead code
'//						removed.
'// 9/4/21.		wmk.	LoadAllLibs call added so can run from
'//						function reference.
'// 11/11/21.	wmk.	timestamping beginning/end territory process.
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

	'//	Code.
	ON ERROR GoTo ErrorHandler
	LoadAllLibs()
	gsUser = fsGetUser()			'// *USER environment variable.
	
	select case gsUser
	case "vncwmk3"
	  csfolderbase = "/home/vncwmk3"
	
	case "ubuntu"
	  csfolderbase = "/media/ubuntu/Windows/Users/Bill"

	case else
	  msgbox("** unknown user attempting ProcessQTerrs...- exiting. **")
	  GoTo ErrorHandler
	  
	end select
	csCongTerrPath = "/MN/CRWG/44586"
	csCodeBase = cdfolderbase & "/GitHub/TerritoriesCB/MNcrwg44586"
	csTerrBase = csfolderbase & "/Territories" & csCongTerrPath
	csTerrDataPath = csTerrBase & "/TerrData"
	csTrackingPath = csTerrBase & "/RawData/Tracking"
	csProjPath = csTerrBase & "/Projects-Geany/DoTerrsWithCalc"

	nTerrs = 0
	oDoc = ThisComponent
	oSheet = oDoc.Sheets(0)

'// debugging.
if 1 = 0 then
xray oDoc.Sheets
endif

	gbKillCycle = false
	gbKillAll = false
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
		DoTerrWithCalc(sTerrID)

		if gbKillAll then
		  exit do
		endif

		if gbKillCycle then
		  gbKillCycle = false
		  GoTo Continue1
		endif
		
		DoSuperWithCalc(sTerrID)
		if gbKillCycle then
		  gbKillCycle = false
		  GoTo Continue1
		endif
		
		'// record time stamp finish.
		oCellTime = oSheet.getCellByPosition(2,iCellIndex)
		oCellTime.SetValue(NOW()) 
		oCell.String = "#" & sTerrID		'// update list as processed
		nTerrs = nTerrs + 1
Continue1:
		iCellIndex = iCellIndex + 1
NextCell:
	loop

if 1 = 1 then
  GoTo AllDone
endif
	
	'// nTerrs is count of territories processed.
	'// if > 0 then add list to UpdateMaster sheet and export to .csv
	if nTerrs > 0 then

dim nMoved		As Integer
dim oDoc2		As Object	'// UpdateMaster worksheet
dim oSel2		As Object	'// UpdateMaster selecction
dim oSheet2		As Object	'// actual sheet object
dim iSheetIx2	As Integer	'// UpdateMaster sheet index
dim oRange2		As Object	'// UpdateMaster RangeAddress
dim oCell2		As Object	'// UpdateMaster cell content

		MoveToSheet("UpdateMaster")
		oDoc2 = ThisComponent
		oSel2 = oDoc2.getCurrentSelection()
		oRange2 = oSel2.RangeAddress
		oSheet2 = oDoc2.Sheets(oRange2.Sheet)

		'// copy Territory List sheet starting at A6 until encounter $.
		MoveToSheet("Territory List")
		bMoreCells = true
		iCellIndex = 5
		nMoved = 0
		do while bMoreCells
			oCell = oSheet.getCellByPosition(0,iCellIndex)
			sCellStr = oCell.String
			bMoreCells = (strcomp(left(sCellStr,1),"$") <> 0)	
if 1 = 0 then
  msgbox("cell content is: ' " & sCellStr & "'")
endif
 			if not bMoreCells then 
'				MoveToSheet("UpdateMaster")
'				oCell = oSheet2.getCellByPosition(0,nMoved)
'				oCell.String = "$"
'				MoveToSheet("Territory List")
'				exit do
				GoTo NextCell2
			endif
			
			if (strcomp(left(sCellStr,1),"#") = 0)_
			 and (InStr("0123456789",mid(sCellStr,2,1)) = 0) then
				iCellIndex = iCellIndex + 1
				GoTo NextCell2	
			endif
			sTerrID = mid(sCellStr,2,4) 
			'// save territory ID in new list at A<nMoved).
			MoveToSheet("UpdateMaster")
			oCell2 = oSheet2.getCellByPosition(0,nMoved)
			oCell2.String = sTerrID
		
			'// advance indexes and move back to 1st sheet.
			MoveToSheet("Territory List")
			nMoved = nMoved + 1
			iCellIndex = iCellIndex + 1
		
NextCell2:
		loop

'		MoveToSheet("UpdateMaster")
	
if 1 = 1 then
  GoTo AllDone
endif
		'// export UpdateMaster to .csv.
		CopyUMToUntitled()
		
		'// still focused on ProcessQTerrs.UpdateMaster.
		RmvUpdateMaster()
if 1 = 1 then
  GoTo AllDone
endif
		
		
		'SaveUMSheetAsCSV()
	
		'// use uno.Close to close .csv workbook.
		'// now refocused on ProcessQTerrs12 workbook.
		dim document	As Object
		dim dispatcher	As Object
		document   = ThisComponent.CurrentController.Frame
		dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

		dim Array2()
		dispatcher.ExecuteDispatch(document, ".uno:Close", 0, "", Array2())	

if 1 = 0 then
		'// delete UpdateMaster sheet.		
		MoveToSheet("UpdateMaster")
		RmvUpdateMaster
		msgbox("back from RmvUpdateMaster")
endif
	endif
	
if 1 = 1 then
  GoTo AllDone
endif

'// export the processed list to RawData/Tracking/UpdateMaster.csv
'// Insert sheet UpdateMaster
'// copy entries from A6 until hit $ to sheet UpdateMaster
'// MoveToSheet("UpdateMaster")
'// call SaveToCSV from UpdateMaster sheet
'// delete sheet UpdateMaster
'// RunTests is an internal test block...

'// Insert sheet UpdateMaster.
	AddUpdateMaster()

'// copy entries from A6 until hit $ to sheet UpdateMaster

'// export UpdateMaster as .csv

'// Delete sheet UpdateMaster.
	RmvUpdateMaster()
	
AllDone:
	msgbox( nTerrs & " territories processed" & chr(13) & chr(10)_
	   & "Territory processing complete.")
NormalExit:
	exit sub

ErrorHandler:
	msgbox("in Main - unprocessed error.")
	GoTo NormalExit
	
End Sub		'// end main	8/12/23.
'/**/
