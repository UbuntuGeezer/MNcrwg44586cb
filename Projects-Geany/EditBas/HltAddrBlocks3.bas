'// HltAddrBlocks3.bas - Highlight address blocks.
'//---------------------------------------------------------------
'// HltAddrBlocks3 - Highlight address blocks.
'//		7/12/21.	wmk.	19:33
'//---------------------------------------------------------------

public sub HltAddrBlocks3()

'//	Usage.	macro call or
'//			call HltAddrBlocks3()
'//
'// Entry.	user has sheet with rows selected to check for address blocks
'//
'//	Exit.	rows scanned and compared; if two or more adjacent rows have
'//			the same unitaddress and unit, the first row will be
'//			highlighted green; subsequent matching row(s) will have Unit
'//			field highlighted lt blue
'//
'// Calls.	GreenRow
'//
'//	Modification history.
'//	---------------------
'//	2/14/21.	wmk.	original code
'// 2/15/21.	wmk.	bug fixes.
'//	2/16/21.	wmk.	mod to use cell B2 Row Count: xxx for row count
'// 2/17/21.	wmk.	bug fix where oRange.LastRow used to determine
'//						row limit after have modified to not use selected
'//						area, but use count from B2.
'//	2/19/21.	wmk.	mod to use count from A2; Address and unit
'//						now in Col A,B
'// 2/20/21.	wmk.	highlight Unit field in subsequent matching rows;
'//						bug fix where last row not highlighted if in 
'//						block
'//	7/12/21.	wmk.	msgbox eliminated to facilitate batch processing.
'//
'//	Notes. This sub highlights the first row of any block of addresses
'// that are the same. This makes it easier to see identical addresses
'// as a group.
'//

'//	constants.
const COL_A=0
const COL_B=1
const COL_C=2
const ROW_2=1
const LTGREEN=13953643
const LTBLUE3=11847644     '// 0xb4c7dc
const ROW_HEADING=4

'//	local variables.
dim i				As Integer		'// loop counter
dim bHltgBlocks3		AS Boolean		'// highlighting blocks in process flag
dim bEmptyIssued	AS Boolean		'// empty row message issued
dim iStatus			AS integer		'// status var
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object

dim lThisRow as long			'// current row selected on sheet
dim lLastRow	As Long			'// last row to process
dim nRowCount	As Integer		'// row count to process
dim nRowsProcessed	As Integer	'// processed row count
dim nErrCode	As integer	'// error code
dim	oCell			As Object	'// working cell
dim oCellAddr		As Object	'// addr current row
dim oCellNextAddr	AS Object	'// addr next row
dim oCellUnit		AS Object	'// unit current row
dim oCellNextUnit	AS Object	'// unit next row
dim sAddress		AS String	'// current row address
dim sNextAddr		As String	'// next row address
dim sUnit			As String	'// current row unit
dim sNextUnit		As String	'// next row unit
dim sRange			As String	'// highlight selection range

dim document   as object		'// uno frame reference object
dim dispatcher as object		'// uno dispatcher services object
dim args1(0) as new com.sun.star.beans.PropertyValue	'// uno properties
dim args9(3) as new com.sun.star.beans.PropertyValue

	'// code.
	ON ERROR GOTO ErrorHandler
	bHltgBlocks3 = false
	bEmptyIssued = false
'	nErrCode = ERR_UNK
	iStatus = 0
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

	
	'// initialie uno API hooks.
	document   = ThisComponent.CurrentController.Frame
	dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

'msgbox("In local HltAddrBlks...")
	'// set row processing from oRange information
	lThisRow = oRange.StartRow - 1		'// start at -1 since increment first
	lThisRow = ROW_HEADING
	'// get row count from A2.
	oCell = oSheet.getCellByPosition(COL_A,ROW_2)		'// Record Count: xxx
	dim sCountStr 		As String
	dim nColonPos		As Integer
	dim sNumCount		As String
	sCountStr = oCell.String
	nColonPos = Instr(sCountStr, ":")
	sNumCount = Right(sCountStr, len(sCountStr)-nColonPos)
	nRowCount = CInt(sNumCount)
	lLastRow = lThisRow + nRowCount
	nRowsProcessed = 0
'	nRowCount = oCell.getValue()

	bHltgBlocks3 = false
	for i = 1 to nRowCount
		lThisRow = lThisRow + 1		'// advance current row
		oCellAddr = oSheet.getCellByPosition(COL_A, lThisRow)
		oCellUnit = oSheet.getCellByPosition(COL_B, lThisRow)
		sAddress = ucase(trim(oCellAddr.String))		'// set cell address text
		if len(trim(oCellUnit.String)) = 0 then
			sUnit = ""
		else
			sUnit = trim(oCellUnit.String)						'// set unit address text
		endif
		
		if len(sAddress) = 0 then
			if not bEmptyIssued then
				msgBox("HLtAddrBlocks3 - empty address field; skipping row...")
				bEmptyIssued = true
			GoTo NextRow
			endif
		endif	'// null string - skip/alert user

		'// check next row.
		if lThisRow &lt; lLastRow then
		
			'// see if Address and unit of next row match this row.
			oCellNextAddr = oSheet.getCellByPosition(COL_A, lThisRow+1)
			oCellNextUnit = oSheet.getCellByPosition(COL_B, lThisRow+1)
			sNextAddr = UCase(trim(oCellNextAddr.String))
			sNextUnit = trim(oCellNextUnit.String)
			
			'// check for address and unit match across rows.
			if (strcomp(sAddress, sNextAddr) = 0)_ 
			  AND (strcomp(sUnit, sNextUnit) = 0) then
				if bHltgBlocks3 then
					oCell = oSheet.getCellByPosition(COL_B, lThisRow)
					oCell.CellBackColor = LTBLUE3
				   
				   GoTo NextRow
				else	'// 2 rows the same, turn highlighting on
					bHltgBlocks3 = true		'// turn on in block flag
					'// highlight this row.
					GreenRow(lThisRow)
				endif	'// end highlighting blocks conditional
				GoTo NextRow
			else 	'// lines different
				if bHltgBlocks3 then
					bHltgBlocks3 = false
					oCell = oSheet.getCellByPosition(COL_B, lThisRow)
'					oCell.CellBackColor = LTGREEN
					oCell.CellBackColor = LTBLUE3
				endif
			endif	'// end 2 lines same address conditional
			
		else	'// at last row
			if bHltgBlocks3 then
				bHltgBlocks3 = false
				oCell = oSheet.getCellByPosition(COL_B, lThisRow)
				oCell.CellBackColor = LTBLUE3
			endif
		endif	'// end next row exists conditional
		
NextRow:
		nRowsProcessed = nRowsProcessed + 1

	next i

'	msgbox("HltAddrBlocks3 - " + nRowsProcessed + " rows processed.")
	exit sub


NormalExit:
	exit sub					
	
ErrorHandler:
	msgbox("HltAddrBlocks3 - unprocessed error")
	GoTo NormalExit
	
end sub		'// end HltAddrBlocks3	7/12/21.	19:33
