REM  *****  BASIC  *****
'// Module1Hdr.bas
'//--------------------------------------------
'// Module1 - Module1 for ProcessQTerrs12.ods (MNcrwg44586).
'//		8/21/23.
'//--------------------------------------------
'//
'// Modification History.
'// ---------------------
'// 8/12/23.	wmk.	modified for use with MNcrwg44586.
'// 8/21/23.	wmk.	ensure <name>. bas and end of / ** / in place.
'// Legacy mods.
'// 10/30/22.	wmk.	mod to use fsGetUser to get *USER environment variable;
'//				 use code to replace path constants with module-wide string
'//				 variables; Main modified to set path strings; gbKillCycle
'//				 and gbKillAll module-wide flags added.
'// Legacy mods.
'// 11/11/21.	wmk.	original code.
'// 12/23/21.	wmk.	provide for multihost path differences; module-wide constants
'//				 csTerrBase, csTerrDataPath implemented.
'// 4/14/22.	wmk.	csfolderbase added; csTerrBase and csTerrDataPath modified
'//				 to use csfolderbase.
'// 5/3/22.		wmk.	csCongTerrPath set for /FL/SARA/86777.
'//
'// Notes. As of 8/12/23 this workbook is unique to the
'// TerritoriesCB/MNcrwg44586/Projects-Geany/DoTerrsWithCalc project. This code
'// is maintained under the \*Chromebook branch of the TerritoriesCB repository. 
'//
'// This workbook is dependent upon internal macros and macros in both the
'// MNcrwg44586 and Territories libraries. To ensure library integrity during
'// "export" operations, make certain that the *Libraries-Project* is on the
'// *Chromebook* branch before exporting or importing libraries. This will
'// guarantee that the Chromebook system does not import or export the library
'// version belonging to the original host (HP Pavilion) system.
'//
'// The Main macro is responsible for invoking the fsGetUser function and setting
'// the module-wide path variables corresponding to the Chromebook system.
'//

'// module-wide variables.
public gbKillCycle	As String	'// kill this territory cycle flag
public gbKillAll	As String	'// terminate processing flag
public gsUser		As String	'// *USER environment var

dim csfolderbase 	As String	'// = "/home/vncwmk3" OR "/media/ubuntu/Windows/Users/Bill"
dim csCongTerrPath	As String	'// = "/MN/CRWG/44586"
dim csTerrBase		As String	'// = csfolderbase & "/Territories" & csCongTerrPath
dim csCodeBase		As String	'// = csfolderbase & "/GitHub/TerritoriesCB/MNcrwg44586"
dim csURLBase		As String	'// = csTerrBase & "/TerrData/Terr"

'const csCongTerrPath = "/state/county/congno"
'#const csCongTerrPath = ""
dim csTerrDataPath	As String	'// = csTerrBase & "/TerrData"
dim csTrackingPath	As String	'// = csTerrBase & "/RawData/Tracking"
dim csProjPath		As String	'// = csTerrBase & "/Projects-Geany/DoTerrsWithCalc"

'// end Module1Hdr		8/12/23.
'/**/

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

'// Main1.bas
'//---------------------------------------------------------------
'// Main1 - Run Main via function call.
'//		8/12/23.		wmk.	13:44
'//---------------------------------------------------------------
public function Main1() AS Void

'// Main1 - Run Main via function call.
'//
'// Usage.	Main1()
'//
'//	Entry.	ThisComponent.Sheets(0) contains territory list to process.
'// 		 it will either be "TerrList" or "autoload" (see Notes.)
'//
'//	Exit.	Main run with timestamps placed in sheet.
'//
'// Modification History.
'// ---------------------
'// 2/1/23.		wmk.	autoload support.
'// 8/12/23.	wmk.	edited for MNcrwg44586; csCodeBase module var
'//				 introduced.
'// Legacy mods.
'// 9/4/21.		wmk.	orignal code.
'// 11/11/21.	wmk.	timestamps added.
'//
'// Notes. ThisComponent.Sheet(0) is always a list of territories to process.
'// The original sheet was "TerrList". The code never knew the name of the
'// sheet.

'// constants.

const COL_STARTTIME = 6			'// timestamp columns, row
const COL_ENDTIME = 7
const ROW_TIME = 4

'// local variables.

dim oDoc		As Object	'// component
dim oSheet		As Object	'// sheet
dim oCellTime	As Object	'// timestamp cell

'// code.

	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSheet = oDoc.Sheets(0)

	'// record start time.
		oCellTime = oSheet.getCellByPosition(COL_STARTTIME,ROW_TIME)
		oCellTime.SetValue(NOW()) 
	Main()
	'// record end time.
		oCellTime = oSheet.getCellByPosition(COL_ENDTIME,ROW_TIME)
		oCellTime.SetValue(NOW()) 

NormalReturn:
	Exit Function
	
ErrorHandler:
	msgbox("Unprocessed error in Main1..")
	GOTO NormalReturn
		
end Function	'// end Main1	8/12/23.
'/**/

'// AddHdrToQTerr.bas
'//---------------------------------------------------------------
'// AddHdrToQTerr - Add TerrxxxHdr sheet to QTerrxxx.ods workbook.
'//		8/12/23.	wmk.
'//---------------------------------------------------------------

public sub AddHdrToQTerr0( psTerrID As String )

'//	Usage.	call AddHdrToQTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open QTerrxxx.csv
'//
'// Entry.	Territories/.../TerrData/Terrxxx/Working-Files/QTerrxxx.ods
'//				contains territory records for territory xxx, in sheet
'//				QTerrxxx.
'//			Territories/.../TerrData/Terrxxx/Working-Files/TerrxxxHdr.ods
'//				contains territory header information from TerrIDData.db
'//
'//	Exit.	QTerrxxx.ods has sheet TerrxxxHdr added as last sheet, from
'//			workbook TerrxxxHdr.ods
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/11/21.	wmk.	original code; adapted from abandoned code
'//						in OpenQTerr. bas		
'//	4/14/22.	wmk.	path corrections; local var sQBaseName for clarity.
'// 8/12/23.	wmk.	edited for MNcrwg44586; csCodeBase module var
'//				 introduced.
'//
'//	Notes. This is the second step in processing a QTerrxxx.csv file
'// into a PubTerr workbook. The first step openend the .csv file and
'// saved it as QTerrxxx.ods, closing it. This step re-opens the
'// QTerxxx.ods workbook, opens a second workbook TerrxxxHdr.ods, and
'// adds its TerxxxHdr sheet to the end of the QTerrxx.ods workbook,
'// closing both when finished.
'//

'//	constants.
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/"

'//	local variables.
dim oDoc			As Object	'// generic document object
dim sQBaseName		As string	'// QTerr target base filename
dim sBasePath		As String	'// target base folder
dim sTargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As String	'// target URL
dim oTestDoc		As Object	'// document object
dim oTestDoc2		As Object	'// 2nd document object

	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent
	sTerrID = psTerrID
	sQBaseName = "QTerr"
	sBasePath = "Terr"
	sTargPath = sBasePath & sTerrID

	'// open QTerrxxx.ods
    sFullTargPath = csTerrDataPath & sTargPath & "/Working-Files/"_ 
		& sQBaseName & sTerrID & ".ods"
		
dim Args(1)	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args(1).name = "FilterName"
	Args(1).Value = "calc8"
	Args(0).name = "Hidden"
	Args(0).value = False
	oTestDoc = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())

	'// open TerrxxxHdr.ods
    sFullTargPath = csTerrDataPath & sTargPath & "/Working-Files/"_ 
		& sTargPath & "Hdr.ods"

dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
	Args2(1).name = "FilterName"
	Args2(1).Value = "calc8"
	Args2(0).name = "Hidden"
	Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())

	'// Now export the header to the QTerrxxx.ods workbook.
	ExportTerrHdr()
	
if 1 = 0 then
xray oTestDoc	
endif

	oTestDoc.Store

CloseFiles:
	'// close the workbooks and cleanup.
	oTestDoc2.close(1)
	oTestDoc.close(1)
	
	'// Now ready to process territory....

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("AddHdrToQTerr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end AddHdrToQTerr	8/12/23.
'/**/

'// PickCellByIndex.bas
'//---------------------------------------------------------------
'// PickCellByIndex - Select any cell to bring sheet into focus.
'//		7/16/21.	wmk.	00:06
'//---------------------------------------------------------------

public sub PickCellByIndex(plCol As Long, plRow As Long)

'//	Usage.	macro call or
'//			call PickCellByIndex(lCol, lRow)
'//
'// Entry.	user in sheet where desires to GoTo cell
'//
'//	Exit.	user focus on desired cell, lCol adds to "A", lRow converted
'//			 to character value of itself - 1.
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/16/21.	wmk.	original code.

'// local variables.
dim oDocument   as object
dim oDispatcher as object
dim sCellID		As String
dim sCellCol	As String	'// cell column A..Z
dim sCellRow	As String	'// cell roW..
dim lCol		As Long
dim lRow		As Long

'//	code.
	ON ERROR GOTO ErrorHandler

	lCol = plCol
	lRow = plRow
	sCellCol = chr(asc("A") + lCol)
	sCellRow = trim(str(lRow+1))
	sCellID = "$" & sCellCol & "$" & sCellRow
	
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// move to cell $A$6
dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = sCellID

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


NormalExit:
	exit sub

ErrorHandler:
	msgbox("PickCellByIndex - unprocessed error")
	GoTo NormalExit
	
end sub		'// end PickCellByIndex	10/11/20
'/**/

'// RunTests.bas
public sub RunTests

	'// code.
	ON ERROR GOTO ErrorHandler
	'// eventually add this code after loop which
	'// processes territories into PubTerr and SuperTerr.
	'// this code should only execute if the processed
	'// territories count is > 0.

dim lCol	As Long
dim lRow	As Long

lCol = 0
lRow = 0

if 1 = 1 then
  GoTo NormalExit
endif

dim oDoc		As Object
dim oSel		As Object
dim oSheet		As Object
dim oRange		As Object
dim iSheetIx	As Integer
dim oCell		As Object
dim sCellStr	As String
dim bMoreCells	As Boolean
dim iCellIndex	As Integer

	
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
	AddUpdateMaster
	msgbox("back from AddUpdateMaster")

dim nMoved		As Integer
dim oDoc2		As Object	'// UpdateMaster worksheet
dim oSel2		As Object	'// UpdateMaster selecction
dim oSheet2		As Object	'// actual sheet object
dim iSheetIx2	As Integer	'// UpdateMaster sheet index
dim oRange2		As Object	'// UpdateMaster RangeAddress

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
			MoveToSheet("UpdateMaster")
			oCell = oSheet2.getCellByPosition(0,nMoved)
			oCell.String = "$"
			MoveToSheet("Territory List")
			exit do
		endif
		if (strcomp(left(sCellStr,1),"#") = 0)_
		 and (InStr("0123456789",mid(sCellStr,2,1)) = 0) then
			iCellIndex = iCellIndex + 1
			GoTo NextCell	
		endif
		sTerrID = mid(sCellStr,2,4)
		
		'// save territory ID in new list at A<nMoved).
		MoveToSheet("UpdateMaster")
		oCell = oSheet2.getCellByPosition(0,nMoved)
		oCell.String = sTerrID
		MoveToSheet("Territory List")
		
		'// advance indexes and move back to 1st sheet.
		MoveToSheet("Territory List")
		nMoved = nMoved + 1
		iCellIndex = iCellIndex + 1
		
NextCell:
	loop

	MoveToSheet("UpdateMaster")
	
	'// export UpdateMaster to .csv.
	CopyUMToUntitled()
	SaveUMSheetAsCSV()
	
	'// use uno.Close to close .csv workbook.
	'// now refocused on ProcessQTerrs12 workbook.
dim document	As Object
dim dispatcher	As Object
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

dim Array2()
dispatcher.ExecuteDispatch(document, ".uno:Close", 0, "", Array2())	

	'// delete UpdateMaster sheet.		
	MoveToSheet("UpdateMaster")
	RmvUpdateMaster
	msgbox("back from RmvUpdateMaster")
	GoTo NormalExit

if 1 = 0 then
'//=======================================================================
'dim oDoc	As Object
dim oPropertySetInfo	As Object
dim Array()

	oDoc = ThisComponent.CurrentController.Frame
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dispatcher.executeDispatch(document, ".uno:PageFormatDialog", "", 0, Array())
'//=========================================================================
endif


if 1 = 0 then
'//=========================================================================

	oPropertySetInfo = oDoc.LayoutManager.getPropertySetInfo()
		
dim oProperties as Object
	oProperties = oDoc.getProperties()
dim bHasGrid as Boolean
	bHasGrid = oDoc.HasPropertyByName("Grid")
'dim oPropertySetInfo	As Object
	oPropertySetInfo = oDoc.getPropertySetInfo()
'	Array = oDoc.LayoutManager.GetPropertyValues()
'//============================================================
endif
		
if 1 = 0 then
xray odoc	
endif

if 1 = 0 then
'//==================================================
'oDoc = ThisComponent
'dim sUrl AS STRING
'	Surl = oDoc.GetURL()
dim oFrames As Object
	oFrames = oDoc.GetFrames()
	oDoc.Activate()
'//==================================================
endif

NormalExit: 
	exit sub
	
ErrorHandler:
	msgbox("RunTests - unprocessed error.")
	GoTo NormalExit
	
end sub		'// end RunTests
'/**/

'// OpenQTerrold.bas
'// legacy code.
'//---------------------------------------------------------------
'// OpenQTerr - Open QTerrxxx.csv for territory xxx.
'//		8/12/23.	wmk.
'//---------------------------------------------------------------

public sub OpenQTerrold( psTerrID As String )

'//	Usage.	call OpenQTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open QTerrxxx.csv
'//
'// Entry.	Territories/.../TerrData/Terrxxx/Working-Files/QTerrxxx.csv
'//				contains territory records for territory xxx, delimited
'//				by "|"
'//
'//	Exit.	QTerrxxx.ods opened in new spreadsheet (visible)
'//			TerrxxxHdr.ods opened in new spreadsheet (visible)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/9/21.		wmk.	original code
'//
'//	Notes. Once the user has opened the spreadsheet, the user should
'// be able to run all the Territories macros and process the territory.
'// This sub bypasses the step of opening QTerrxxx.csv, but proves the
'// concept that by using uno:loadComponentFromURL, one can load additional
'// sheets for processing, then close them at will..
'//

'//	constants.
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/"
'const csTerrDataFolder = csTerrBase & "/Territories/TerrData"

'//	local variables.
dim sQBaseName		As string	'// target base filename
dim sBasePath		As String	'// target base folder
dim TargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As Object	'// target URL
dim oTestDoc		As Object	'// document object

	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent

if 0 = 1 then
xray oTestDoc
endif
	sTerrID = psTerrID
	sQBaseName = "QTerr"
	sBasePath = "/Terr"
	sTargPath = sBasePath & sTerrID
REM edit the file name as needed
'    Target = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr240/Working-Files"_
'      & "/QTerr240.csv"

'    sFullTargPath = csTerrDataPath & sBasePath & sTerrID & "/Working-Files/"_ 
'		& sBaseName & sTerrID & ".csv"
'    TargetURL = convertToURL(sFullTargPath)

'// open QTerrxxx.csv
    sFullTargPath = csTerrDataPath & sTargPath & "/Working-Files/"_ 
		& sQBaseName & sTerrID & ".csv"
		
if 1 = 1 then
	TargetURL = convertToURL(sFullTargPath)
'    Empty() = Array()
dim Args(1)	As new com.sun.star.beans.PropertyValue 
   Args(1).name = "FilterName"
   Args(1).Value = "Text - txt - csv"
   Args(0).name = "Hidden"
   Args(0).value = False
    oTestDoc = StarDesktop.loadComponentFromURL(TargetURL, "_blank", 0, Args())
endif

if 0 = 1 then
  xray oTestDoc
endif
'// open TerrxxxHdr.ods; sTargPath = "Terrxxx"
    sFullTargPath = csTerrDataPath & "/Working-Files/"_ 
		& sTargPath & "Hdr.ods"
dim oTestDoc2	as Object
	oTestDoc2 = ThisComponent
dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	TargetURL = convertToURL(sFullTargPath)
   Args2(1).name = "FilterName"
   Args2(1).Value = "calc8"
   Args2(0).name = "Hidden"
   Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(TargetURL, "_blank", 0, Args2())
dim iResp as integer
	iResp = msgbox("Both .ods files opened..." & chr(13) & chr(10)_
	  & "  Drop 1st file?", MB_OKCANCEL+ MB_ICONQUESTION)
	if iResp = IDOK then
	   oTestDoc.close(1)
	endif
	
	'// Now export the header to the QTerrxxx.ods workbook.
	ExportTerrHdr()	

	'// move to header sheet just exported.
	'// Now close the TerrxxxHdr.ods workbook.
	oTestDoc2.close(1)
	
'// Now ready to process territory.
	QToPubTerr3()
if 0 = 1 then	
	msgbox( "Moving to " & oTestDoc.getURL & "." & sBaseName & sTerrID )
	MoveToDocSheet( oTestDoc, sBaseName & sTerrID )
	DkLimeTab()
	ProtectSheet()
	MoveToSheet(sBasePath & sTerrId)
	DkLimeTab()
	ProtectSheet()
	MoveToSheet(sBaseName & sTerrID)
endif
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("OpenQTerr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end OpenQTerrold	8/12/23.
'/**/

'// InsertFromFile.bas
sub InsertFromFile
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
rem dispatcher.executeDispatch(document, ".uno:InsertSheetFromFile", "", 0, Array())


end sub		'// end InsertFromFile
'/**/

'// test.bas
sub test

Dim FileNo As Integer
Dim CurrentLine As String
dim x,y,z as integer
dim s as object
dim oFolderPicker as object
dim NextFile as string
dim url as string
dim newworkbook as object
Dim Args(2) As new com.sun.star.beans.PropertyValue
dim sExport as string
dim oExport as object

oFolderPicker = createUnoService("com.sun.star.ui.dialogs.FolderPicker")
oFolderPicker.setdisplaydirectory("c:\")
oFolderPicker.execute

NextFile = dir(oFolderPicker.getdirectory & "/*.txt",0)

x = 0
y = 0
while NextFile <> ""

   x = x + 1
   NextFile = Dir
   
wend
   
NextFile = dir(oFolderPicker.getdirectory & "/*.txt",0)
   
while NextFile <> ""
   com.sun.star.beans.PropertyValue
   y = y +1
   
   thiscomponent.currentcontroller.statusindicator.start "Loading " & y &  " of the total " & x & " files ......",0
   
   url = oFolderPicker.getdirectory & "/" & left(NextFile,len(NextFile)-3) & "ods"
   
   MkDir oFolderPicker.getdirectory & "/Temporary/"
   
   FileCopy oFolderPicker.getdirectory & "/" & NextFile, oFolderPicker.getdirectory & "/Temporary/" & left(NextFile,len(NextFile)-3) & "csv"
   
   sExport = ConvertToURL(oFolderPicker.getdirectory & "/Temporary/" & left(NextFile,len(NextFile)-3) & "csv")
   
   Args(1).name = "FilterName"
   Args(1).Value = "Text - txt - csv (StarCalc)"
   Args(2).name = "FilterOptions"
   Args(2).Value = "9,0,76,1,1/2/2/2/3/2/4/2/5/2/6/2/7/2/8/2/9/2/10/2/11/2/12/2/13/2/14/2/15/2/16/2/17/2/18/2/19/2/20/2/21/2/22/2/23/2/24/2/25/2/26/2/27/2/28/2/29/2/30/2/31/2/32/2/33/2/34/2/35/2/36/2/37/2/38/2/39/2/40/2/41/2/42/2/43/2/44/2/45/2/46/2/47/2/48/2/49/2/50/2"
   Args(0).name = "Hidden"
   Args(0).value = True

   oExport = StarDesktop.loadComponentFromURL(sExport, "_blank", 0, Args())
   
   oExport.sheets(0).getcellrangebyposition(0,0,256,0).columns.OptimalWidth = true
   
   Args(0).Name = "CharacterSet"
    Args(0).Value = "UTF-8"
   
   oExport.storeasurl(url,Array())
                                                                                                                                                                                                                                                                                                                                  
   oExport.close(true)
   
   NextFile = Dir
   
wend

RmDir oFolderPicker.getdirectory & "/Temporary/"

thiscomponent.currentcontroller.statusindicator.Reset

msgbox "complete"

end sub		'// end test
'/**/

'// wmktest1.bas
sub wmktest1


Dim FileNo As Integer
Dim CurrentLine As String
dim x,y,z as integer
dim s as object
dim oFolderPicker as object
dim NextFile as string
dim url as string
dim newworkbook as object
Dim Args(2) As new com.sun.star.beans.PropertyValue
dim sExport as string
dim oExport as object

oFolderPicker = createUnoService("com.sun.star.ui.dialogs.FolderPicker")
oFolderPicker.setdisplaydirectory("file://" & csTerrDataPath)
oFolderPicker.execute
sDirectory = oFolderPicker.getDisplayDirectory()
msgbox("sDirectory = '" & sDirectory & "'")

end sub	'// wmktest1
'/**/

'// MyTest.bas
sub MyTest
dim oServiceManager as Object
'dim oServiceInfo AS New com.sun.star.lang.XServiceinfo
dim oFolderPicker as object
dim oServiceInfo AS Object
oServiceInfo = createUnoService("com.sun.star.lang.XServiceinfo")
oFolderPicker = createUnoService("com.sun.star.ui.dialogs.FolderPicker")
'xray oServiceInfo
xray oFolderPicker
oFolderPicker.setdisplaydirectory("")
oFolderPicker.execute
sDisplayDir = oFolderPicker.GetDisplayDirectory()
msgbox("sDisplayDir = '" & sDisplayDir & "'")
oServiceManager = GetProcessServiceManager()
  MsgBox oServiceManager.Dbg_SupportedInterfaces

end sub		'// end MyTest
'/**/

'// OpenDiffFile.bas
sub OpenDiffFile
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
dim oExport		As	Object
dim Args(1)		As new com.sun.star.beans.PropertyValue


rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
xray Args
rem ----------------------------------------------------------------------
rem dispatcher.executeDispatch(document, ".uno:OpenFromCalc", "", 0, Array())
'sTargetURL = "file:///media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr241"_
'   & "/Working-Files/NewTerr241Hdr.csv"
sTargetURL = "file://" & csTerrDataPath & "/Terr241"_
   & "/Working-Files/NewTerr241Hdr.csv"
'   Args(3).name = "Separated By"
'  Args(3).Value = "|"
   Args(1).name = "FilterName"
   Args(1).Value = "Text - txt - csv"
'   Args(2).name = "FilterOptions"
'   Args(2).Value = "9,0,76,1,1/2/2/2/3/2/4/2/5/2/6/2/7/2/8/2/9/2/10/2/11/2/12/2/13/2/14/2/15/2/16/2/17/2/18/2/19/2/20/2/21/2/22/2/23/2/24/2/25/2/26/2/27/2/28/2/29/2/30/2/31/2/32/2/33/2/34/2/35/2/36/2/37/2/38/2/39/2/40/2/41/2/42/2/43/2/44/2/45/2/46/2/47/2/48/2/49/2/50/2"
'   Args(2).Value = "comma-delimited"
   Args(0).name = "Hidden"
   Args(0).value = False

   oExport = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())
' xray oExport 
' dim Args2()
' Args2=oExport.getArgs()
' dbug = 1 
dispatcher.executeDispatch(document,".unoOpenFromCalc",sTargetURL,0,Array())

end sub		'// end OpenDiffFile
'/**/

'// InsertFromCSV.bas
sub InsertFromCSV
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
rem dispatcher.executeDispatch(document, ".uno:InsertSheetFromFile", "", 0, Array())


end sub		'// end InsertFromCSV
'/**/

'// SaveDiffoDS.bas
sub SaveDiffODS
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(1) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Territories/Projects-Geany/DoTerrsWithCalc/ProcessQTerrs12.ods"
args1(0).Value = "file://" & csProjPath & "/ProcessQTerrs12.ods"
args1(1).Name = "FilterName"
args1(1).Value = "calc8"

dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, args1())


end sub		'// end SaveDifODS		10/30/22.
'/**/

'// MoveToDocSheet1.bas
'//---------------------------------------------------------------
'// MoveToDocSheet1 - Jump over to different sheet by sheet name.
'//		7/9/21.	wmk.	18:55
'//---------------------------------------------------------------

public sub MoveToDocSheet1(poDocument AS Object, psSheetName As String)

'//	Usage.	macro call or
'//			call MoveToDocSheet( oDocument,sSheetName )
'//
'//		oDocument = document object containing sheet
'//		sSheetName = name of sheet to move to
'//
'// Entry.	user focused on some sheet in workbook
'//
'//	Exit.	user focus moved to sSheetName in workbook, if exists
'//
'// Calls.	uno Dispatcher.
'//
'//	Modification history.
'//	---------------------
'//	7/9/21.		wmk.	original code; cloned from macro recording
'//
'//	Notes. <Insert notes here>
'//

'//	constants.

'// local variables.

dim oDoc		As Object		'// ThisComponent
dim oSheets		As Object		'// Sheets() array
dim iSheetIx	As Integer		'// desired sheet index
dim iUnoSheet	As Integer		'// uno sheet number
dim bSheetExists	As Boolean	'// sheet exists flag
dim oSheet		As Object		'// this sheet

	'// code.
	ON ERROR GOTO ErrorHandler
'	oDoc = ThisComponent
	oDoc = poDocument
	oSheets = oDoc.Sheets()
	bSheetExists = oSheets.hasByName(psSheetName)
'XRay oSheets
	if bSheetExists then
		oSheet = oSheets.getByName(psSheetName)
		iSheetIx = oSheet.RangeAddress.Sheet

if not true then
	msgbox("Index of target sheet is " + iSheetIx)
	goto NormalExit
endif
		iUnoSheet = iSheetIx + 1	'// add 1 for uno indexing

	else		'// sheet not found
		msgbox("In MoveToSheet: " + psSheetName + " - sheet not found!")
		goto ErrorHandler
	endif

	'// use uno - macro-generated code to jump to desired sheet.

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
'document   = ThisComponent.CurrentController.Frame
document = oDoc.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Nr"
'//args1(0).Value = 4			'// PubTerr sheet index
args1(0).Value = iUnoSheet		'// jump to desired sheet
dispatcher.executeDispatch(document, ".uno:JumpToTable", "", 0, args1())

NormalExit:
	exit sub

ErrorHandler:
	ON ERROR GOTO
	msgbox("In MoveToDocSheet - unprocessed error.")
	GOTO NormalExit

end sub		'// MoveToDocSheet1		7/9/21.	18:55
'/**/

'// SaveFile.bas
sub SaveFile
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dispatcher.executeDispatch(document, ".uno:Save", "", 0, Array())


end sub		'// end SaveFile
'/**/

'// OpenCSV.bas
sub OpenCSV
rem ----------------------------------------------------------------------
rem define variables
dim document   as object

'sFullTargPath = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr40/Working-Files/QTerr240.ods"
sFullTargPath = csTerrDataPath & "/Terr240/Working-Files/QTerr240.ods"
	TargetURL = convertToURL(sFullTargPath)
'    Empty() = Array()
'dim Args(1)	As new com.sun.star.beans.PropertyValue 
'   Args(1).name = "FilterName"
 '  Args(1).Value = "Text - txt - csv"
  ' Args(0).name = "Hidden"
   'Args(0).value = False
    'oTestDoc = StarDesktop.loadComponentFromURL(TargetURL, "_blank", 0, Args())

	TargetURL = convertToURL(sFullTargPath)
	document = ThisComponent.CurrentController.Frame
'    Empty() = Array()
dim Args(2)	As new com.sun.star.beans.PropertyValue 
   Args(0).name = "URL"
   Args(0).value = TargetURL
   Args(1).name = "FilterName"
   Args(1).Value = "calc8"
   Args(2).name = "Hidden"
   Args(2).value = False
'   oTestDoc = StarDesktop.loadComponentFromURL(TargetURL, "_blank", 0, Args())
dispatcher.executeDispatch(document,".uno:OpenFromCalc","",0,Args())
rem ----------------------------------------------------------------------
rem dispatcher.executeDispatch(document, ".uno:OpenFromCalc", "", 0, Array())


end sub		'// end OpenCSV
'/**/

'// AddUpdateMaster.bas
'//---------------------------------------------------------------
'// AddUpdateMaster - Add UpdateMaster sheet to current workbook.
'//		7/15/21.	wmk.	09:53
'//---------------------------------------------------------------

sub AddUpdateMaster

'//	Usage.	macro call or
'//			call AddUpdateMaster()
'//
'// Entry.	UpdateMaster sheet selected by user
'//
'//	Exit.	UpdateMaster sheet removed from workbook
'//
'// Calls.	fbSheetExists.
'//
'//	Modification history.
'//	---------------------
'//	7/15/21.	wmk.	original code; cloned from Record Macro.
'// 7/21/21.	wmk.	add fbSheetExists check.
'//
'//	Notes. Specifically for ProcessQTerr12.ods; Adds sheet UpdateMaster
'// to workbook. (See also RmvUpdateMaster).
'//

'//	constants.

'//	local variables.
dim bSheetExists	As Boolean	'// UpdateMaster already exists flag

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
	bSheetExists = fbSheetExists("UpdateMaster")
	if bSheetExists then
		MoveToSheet("UpdateMaster")
		GoTo NormalExit
	else
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Name"
args1(0).Value = "UpdateMaster"

dispatcher.executeDispatch(document, ".uno:Add", "", 0, args1())
	endif	
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("AddUpdateMaster - unprocessed error")
	GoTo NormalExit
	
end sub		'// end AddUpdateMaster	7/15/21.	09:53
'/**/

'// AddUpdateMaster1.bas
sub AddUpdateMaster1
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Name"
args1(0).Value = "UpdateMaster"

dispatcher.executeDispatch(document, ".uno:Add", "", 0, args1())


end sub		'// end AddUpdateMaster1
'/**/

'// CopyUMToUntitled.bas
'//---------------------------------------------------------------
'// CopyUMToUntitled - Copy UpdateMaster sheet to new workbook.
'//		7/15/21.	wmk.
'//---------------------------------------------------------------

sub CopyUMToUntitled()

'//	Usage.	macro call or
'//			call CopyUMToUntitled()
'//
'//		sDocName = name of new workbook
'//
'// Entry.	user has UpdateMaster sheet selected that will be copied to new workbook
'//
'//	Exit.	selected sheet copied into "Untitled n"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/15/21.	wmk.	original code.
'//
'//	Notes.
'//

'//	constants.

'//	local variables.
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
args1(0).Value = ""
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CopyUMToUntitled - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CopyUMToUntitled	'// 7/15/21.	21:01
'/**/

'// RmvUpdateMaster.bas
'//---------------------------------------------------------------
'// RmvUpdateMaster - Remove UpdateMaster worksheet from workbook.
'//		7/15/21.	wmk.	7/15/21.	09:50
'//---------------------------------------------------------------

sub RmvUpdateMaster

'//	Usage.	macro call or
'//			call RmvUpdateMaster()
'//
'// Entry.	<entry conditions>
'//
'//	Exit.	<exit conditions>
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/15/21.		wmk.	original code; cloned from Record Macro.
'//
'//	Notes. Specifically for ProcessQTerr12.ods; Removes sheet UpdateMaster
'// from workbook. (See also AddUpdateMaster).
'//

'//	constants.

'//	local variables.
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
dim oDoc		As Object
dim oSel		As Object
dim oRange		As Object
dim iSheetIx	As Integer
dim oSheet		As Object
dim sSheetName	As String

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	sSheetName = oSheet.Name
	
	'// check if in UpdateMaster sheet...
	if strcomp(sSheetName, "UpdateMaster") <> 0 then
		msgbox("** Not in UpdateMaster sheet...cannot remove! **")
		GoTo NormalExit
	endif

rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dispatcher.executeDispatch(document, ".uno:Remove", "", 0, Array())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("RmvUpdateMaster - unprocessed error")
	GoTo NormalExit
	
end sub		'// end RmvUpdateMaster		7/15/21.	09:50
'/**/

'// RmvUpdateMaster1.bas
sub RmvUpdateMaster1
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dispatcher.executeDispatch(document, ".uno:Remove", "", 0, Array())


end sub		'// end RmvUpdateMaster1
'/**/

'// SaveSheetAsCSV.bas
'//---------------------------------------------------------------
'// SaveSheetAsCSV - Save current sheet as .csv file.
'//		10/12/20.	wmk.	20:40
'//---------------------------------------------------------------

public sub SaveSheetAsCSV()

'//	Usage.	macro call or
'//			call SaveSheetAsCSV()
'//
'// Entry.	user has sheet selected that desires saved as .csv file
'//			Note: best if save with only row headings, then data
'//			as opposed to more heading information rows
'//
'//	Exit.	sheet saved on current URL path as <sheet-name>.csv
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/12/20.	wmk.	original code; cloned from macro recording.
'// 12/23/21.	wmk.	modified for multihost support; csTerrBase, csTerrDataPath
'//				 constants introduced.
'//
'//	Notes.
'//

'//	constants.

'//	local variables.
dim oDoc		As Object	'// ThisComponent
dim oSel		As Object	'// current selection
dim oRange		As Object	'// selection RangeAddress
dim iSheetIx	As Integer	'// selected sheet index
dim oSheet		As Object	'// sheet object
dim sSheetName	As String	'// name of this sheet
dim sDocURL	As String		'// URL this string
dim sNewURL		As String		'// new URL to save under
dim nURLLen		As Integer		'// URL length
dim sURLBase	As String		'// URL base string

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	sSheetName = oDoc.Sheets(iSheetIx).Name
	
	'// set up for save as .csv
	'// it is known that the URL will end in "Terrxxx.ods" (11 chars)
	sDocURL = ThisComponent.getURL()
	nURLlen = len(sDocURL)
	sURLBase = left(sDocURL, nURLLen-11)
	sNewURL = sURLBase + sSheetName + ".csv"
	
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file://" & csTerrBase & "/Territories/csvs-Dev/Terr102_Bridge.csv"
args1(0).Value = sNewURL
args1(1).Name = "FilterName"
args1(1).Value = "Text - txt - csv (StarCalc)"
args1(2).Name = "FilterOptions"
args1(2).Value = "44,34,76,1,,0,false,true,true,false,false"

dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, args1())


	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SaveSheetAsCSV - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveSheetAsCSV		10/12/20
'/**/

'// SaveUMSheetAsCSV.bas
'//---------------------------------------------------------------
'// SaveUMSheetAsCSV - Save UpdateMaster sheet as .csv file.
'//		10/15/20.	wmk.	20:40
'//---------------------------------------------------------------

public sub SaveUMSheetAsCSV()

'//	Usage.	macro call or
'//			call SaveUMSheetAsCSV()
'//
'// Entry.	user has sheet UpdateMaster selected saved as .csv file
'//			Note: best if save without headihgs, then data
'//			as opposed to more heading information rows
'//
'//	Exit.	sheet saved on URL path csTerrBase/Territories/RawData/Tracking
'//			 as <sheet-name>.csv
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/1520.		wmk.	original code; adapted from SaveSheetAsCSV.
'//
'//	Notes.
'//

'//	constants.
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/RawData/Tracking/"
'const csTrackingPath = csTerrBase & "/RawData/Tracking"

'//	local variables.
dim oDoc		As Object	'// ThisComponent
dim oSel		As Object	'// current selection
dim oRange		As Object	'// selection RangeAddress
dim iSheetIx	As Integer	'// selected sheet index
dim oSheet		As Object	'// sheet object
dim sSheetName	As String	'// name of this sheet
dim sDocURL	As String		'// URL this string
dim sNewURL		As String		'// new URL to save under
dim nURLLen		As Integer		'// URL length
dim sURLBase	As String		'// URL base string

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	sSheetName = oDoc.Sheets(iSheetIx).Name
	
	'// set up for save as .csv
	'// it is known that the URL will end in "Terrxxx.ods" (11 chars)
	sURLBase = csTrackingPath & "/" & sSheetName + ".csv"
	sNewURL = convertToURL(sURLBase)
	
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories/csvs-Dev/Terr102_Bridge.csv"
args1(0).Value = sNewURL
args1(1).Name = "FilterName"
args1(1).Value = "Text - txt - csv (StarCalc)"
args1(2).Name = "FilterOptions"
args1(2).Value = "44,34,76,1,,0,false,true,true,false,false"

dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, args1())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SaveUMSheetAsCSV - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveUMSheetAsCSV		10/15/20.	20:40
'/**/

'// ExportPDF.bas
'//---------------------------------------------------------------
'// ExportPDF - Export PubTerr to PDF.
'//		8/12/23.	wmk.
'//---------------------------------------------------------------

public sub ExportPDF( poDocPubTerr As Object )

'//	Usage.	macro call or
'//			call ExportPDF( oDocPubTerr )
'//
'//		oDocPubTerr = publisher territory workbook
'//
'// Entry.
'//
'//	Exit.	oDocPubTerr workbook saved as PDF
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'// 8/12/23.	wmk.	csURLBase dependency fixed in header.
'// Legacy mods.
'//	11/23/21.	wmk.	original code.
'// 12/17/21.	wmk.	bug fix in target URL always exporting to terr 235;
'//				 Module-wide var gsTerrID set.
'// 12/24/21.	wmk.	csURLBase set for chromeos host.
'//
'//	Notes. This exports the current Terrxxx_PubTerr.ods to a PDF.
'//

'//	constants.
'const csURLBase = "file:///media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr"
'const csURLBase = "file:///home/vncwmk3/Territories/TerrData/Terr"
const csURLEnd = "_PubTerr.pdf"

'//	local variables.
dim sDocTitle	as String
dim sTerrID		AS String
dim sURLFull	AS String

	'// code.
	ON ERROR GOTO ErrorHandler
	
rem ----------------------------------------------------------------------
rem define variables
dim oDocument   as object
dim oDispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
oDocument   = poDocPubTerr.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

sDocTitle = oDocument.Title
sTerrID = mid(sDocTitle,5,3)
gsTerrID = sTerrID
sURLFull = csURLBase & sTerrID & "/Terr" & sTerrID & csURLEnd

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr235/Terr235_PubTerr.pdf"
args1(0).Value = sURLFull
args1(1).Name = "FilterName"
args1(1).Value = "calc_pdf_Export"
args1(2).Name = "FilterData"
args1(2).Value = Array(Array("UseLosslessCompression",0,false,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Quality",0,90,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ReduceImageResolution",0,true,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("MaxImageResolution",0,300,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("UseTaggedPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SelectPdfVersion",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportNotes",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ViewPDFAfterExport",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportBookmarks",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SinglePageSheets",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("OpenBookmarkLevels",0,-1,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("UseTransitionEffects",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("IsSkipEmptyPages",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportPlaceholders",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("IsAddStream",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportFormFields",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("FormsType",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("AllowDuplicateFieldNames",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("HideViewerToolbar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("HideViewerMenubar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("HideViewerWindowControls",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ResizeWindowToInitialPage",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("CenterWindow",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("OpenInFullScreenMode",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("DisplayPDFDocumentTitle",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("InitialView",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Magnification",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Zoom",0,100,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("PageLayout",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("FirstPageOnLeft",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("InitialPage",0,1,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Printing",0,2,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Changes",0,4,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("EnableCopyingOfContent",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("EnableTextAccessForAccessibilityTools",0,true,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportLinksRelativeFsys",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("PDFViewSelection",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ConvertOOoTargetToPDFTarget",0,false,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("ExportBookmarksToPDFDestination",0,false,_
 com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("_OkButtonString",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Watermark",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("EncryptFile",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("PreparedPasswords",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("RestrictPermissions",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("PreparedPermissionPassword",0,_
 Array(),com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("Selection",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureLocation",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureReason",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureContactInfo",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignaturePassword",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureCertificate",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("SignatureTSA",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),_
 Array("UseReferenceXObject",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE))

oDispatcher.executeDispatch(oDocument, ".uno:ExportToPDF", "", 0, args1())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("ExportPDF - unprocessed error")
	GoTo NormalExit
	
end sub		'// end ExportPDF		8/12/23.
'/**/

'// fbSheetExists.bas
'//----------------------------------------------------
'// fbSheetExists - check to see if sheet name exists.
'//		10/30/22.	wmk.
'//----------------------------------------------------
function fbSheetExists(psSheetName As String) As Boolean

'// Modification History.
'// ---------------------
'// ??/??/??.	wmk.	original code.
'// 10/30/22.	wmk.	header documentation added.
'//

'// local variables.

dim oDoc		As Object		'// ThisComponent
dim oSheets		As Object		'// Sheets() array
dim bSheetExists	As Boolean	'// sheet exists flag

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSheets = oDoc.Sheets()
	bSheetExists = oSheets.hasByName(psSheetName)

NormalExit:
	fbSheetExists = bSheetExists
	exit function

ErrorHandler:
	msgbox("fbSheetExists - unprocessed error.")
	bSheetExists = false
	GoTo NormalExit:

end function	'// end fbSheetExists	10/30/22.
'/**/

'// xportPDF.bas
sub xportPDF

'// Modification History.
'// ---------------------
'// 8/12/23.	wmk.	export path modified for MNcrwg44586.

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
args1(0).Value = "file:///home/vncwmk3/GitHub/TerritoriesCB/MNcrwg44586/Projects-Geany/DoTerrsWithCalc/ProcessQTerrs12.pdf"
args1(1).Name = "FilterName"
args1(1).Value = "calc_pdf_Export"
args1(2).Name = "FilterData"
args1(2).Value = Array(Array("UseLosslessCompression",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Quality",0,90,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ReduceImageResolution",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("MaxImageResolution",0,300,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseTaggedPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SelectPdfVersion",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PDFUACompliance",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportNotes",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ViewPDFAfterExport",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportBookmarks",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SinglePageSheets",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("OpenBookmarkLevels",0,-1,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseTransitionEffects",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("IsSkipEmptyPages",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportPlaceholders",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("IsAddStream",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportFormFields",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("FormsType",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("AllowDuplicateFieldNames",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerToolbar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerMenubar",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("HideViewerWindowControls",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ResizeWindowToInitialPage",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("CenterWindow",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("OpenInFullScreenMode",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("DisplayPDFDocumentTitle",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("InitialView",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Magnification",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Zoom",0,100,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PageLayout",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("FirstPageOnLeft",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("InitialPage",0,1,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Printing",0,2,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Changes",0,4,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EnableCopyingOfContent",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EnableTextAccessForAccessibilityTools",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportLinksRelativeFsys",0,true,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PDFViewSelection",0,0,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ConvertOOoTargetToPDFTarget",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("ExportBookmarksToPDFDestination",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignPDF",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("_OkButtonString",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Watermark",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("EncryptFile",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PreparedPasswords",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("RestrictPermissions",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("PreparedPermissionPassword",0,Array(),com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("Selection",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureLocation",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureReason",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureContactInfo",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignaturePassword",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureCertificate",0,,com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("SignatureTSA",0,"",com.sun.star.beans.PropertyState.DIRECT_VALUE),Array("UseReferenceXObject",0,false,com.sun.star.beans.PropertyState.DIRECT_VALUE))

dispatcher.executeDispatch(document, ".uno:ExportToPDF", "", 0, args1())


end sub		'// end xportPDF
'/**/
