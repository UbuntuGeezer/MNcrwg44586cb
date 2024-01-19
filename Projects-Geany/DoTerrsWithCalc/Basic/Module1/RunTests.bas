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
