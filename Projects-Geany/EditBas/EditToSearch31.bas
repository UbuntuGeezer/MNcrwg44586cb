'// EditToSearch31.bas
'//---------------------------------------------------------------
'// EditToSearch31 - Convert Admin-Edit to Pub-Search sheet.
'//		3/3/31.		wmk.	23:15
'//---------------------------------------------------------------

public sub EditToSearch31()

'//	Usage.	macro call or
'//			call EditToSearc3()
'//
'// Entry.	user selection is Admin-Edit formatted sheet
'//	OwningParcel  UnitAddress Unit Resident1 Phone1 H  RUPhone
'//			A			B		C		D	    E	F     G	
'// truepeople     411     whitepages SubTerr CongTerr DoNotCall RSO Foreign  RecordDate
'//		H			I			J		 K		  L			M	   N    O       P
'//	SitusAddress PropUse  DelPending
'//		Q			R		  S
'//
'//	Exit.	produces a "Pub-Search" formatted sheet with the following fields:
'//  A      B    	C      C       D      E     	F    		G		 H	  I	  J	
'//	 H    Address  Unit   Name   Phone1  RefUSA fastpeople	truepeople	411	 DNC  FL
'//  F	     B      C	  D		   E	  F	                       			  M   O
'//
'//	Personal/Notes
'//
'// Calls.	BoldHeadings, ForceRecalc, SetTerrWidths,
'//			SetSelection, MergeOwnerCells, MergeStreetsCells,
'//			MergeSheetType, SetHdrSumFormula4
'//
'//	Modification history.
'//	---------------------
'//	2/6/21.		wmk.	original code
'// 2/15/21.	wmk.	mod to move column H to A; change to simplify
'// 					header with same code as BridgeToTerr.
'// 2/27/21.	wmk.	bug fixes sTerrID, sSheet, sCity not explcitly
'//						declared; dim oCols inside loop moved outside;
'//						name change to EditToSearch3 for version clarity
'//						SetHdrSumFormula3 to fix Record Count in B2;
'//						documentation updated; columns widths array
'//						expanded to 10 to include DNC and FL columns.
'// 3/3/21.		wmk.	bug fix; "search" lingering over column I; change
'//						to call SetHdrSumFormula4
'//
'// Admin-Edit sheet fields.
'//		9/7/20. (lines preceded by #s are SplitTable fields)
'//								source-column	target-column
'//0|OwningParcel|TEXT|1||0			A				-
'//1|UnitAddress|TEXT|1||0			B				D
'//2|Resident1|TEXT|0||0			C				B
'//3|Resident2|TEXT|0||0			D				C
'//4|Phone1|TEXT|0||0				E				D
'//5|Phone2|TEXT|0||0				F				E
'//6|RefUSA-Phone|TEXT|0||0			G				F
'//7|truepeople hyperlink			H				-
'//8|411 hyperlink					I				-
'//9|whitepages hyperlink			J				-
'//10|SubTerritory|TEXT|0||0		K				-
'//11|CongTerrID|TEXT|0||0			L				-
'//12|DoNotCall|INTEGER|0|0|0		M				G
'//13|RSO|INTEGER|0|0|0				N				-
'//14|Foreign|INTEGER|0|0|0			O				H
'//15|RecordDate|REAL|0|0|0			P
'//16|X-Pending|INTEGER|0|0|0		R
'//
'// Method.
'//		remove columns K-R

'//	constants.
const COL_NAME1=3		'// column D is Name1 column
const COL_A=0			'// H
const COL_B=1			'// Address
const COL_C=2			'// Unit
const COL_D=3			'// Name
const COL_E=4
const COL_F=5
const COL_G=6			'// column G index
const COL_H=7			'// column H index
const COL_I=8			'// column I index
const COL_J=9			'// column J index
const COL_K=10			'// column K index
const COL_L=11			'// column L index 
const COL_M=12			'// column M index (DoNotCall)
const COL_N=13			'// column N index (RSO)
const COL_O=14			'// column O index (Foreign)
const ROW_1=0
const ROW_2=1
const ROW_3=2
const ROW_4=3
const ROW_HEADING=4		'// headings row index
const LJUST=1		'// left-justify HoriJustify				'// mod052020
const CJUST=2		'// center HoriJustify						'// mod052020
const RJUST=3		'// right-justify HoriJustify				'// mod052320
const MDYY=30		'// 'M/D/YY' format value
const INCH = 2540	'// millimeters in 1 inch
const ONEP75 = INCH*1.75
const PT35 = INCH*.35
const ONEP35 = INCH*1.35

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
dim oCell2	As Object		'// cell related cell to oCell
dim i		As Integer		'// loop index
dim sPropID	As String		'// property ID
dim sSubTerr	As String	'// subterritory
dim sCongTerr	As String	'// cong terr ID
dim lRowCount	As Long		'// row count of addresses
dim dDate		As Double	'// date value
dim sCityStZip	As String	'// concatenated City, State, Zip
dim sNotes		As String	'// notes field
dim	nCols		As Integer	'// column count to remove
dim sFormula	As String	'// COUNTA formula from B2
dim bForeign	As Boolean
dim bDoNotCall	As Boolean
dim sTerrID		As String	'// territory ID
dim sSheetName	As String	'// new sheet name
dim sCity		As String	'// city

dim nSearchColWidths(10) AS Integer

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value

if true then
	GoTo Skip1
endif
'//	Remove column A after moving header.
'//		Move header A1-H4 to B1
	oCell = oSheet.getCellByPosition(COL_B, ROW_2)
	sFormula = oCell.getFormula()					'// save B2 formula
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_A
	oMrgRange.EndColumn = COL_H
	oMrgRange.StartRow = ROW_1
	oMrgRange.EndRow = ROW_4
dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_B
	oTarget.Row = ROW_1
	oSheet.moveRange(oTarget,oMrgRange)

'//		Remove column A, then restore formula in B2
	oSheet.Columns.removeByIndex(COL_A, 1) 
	oCell = oSheet.getCellByPosition(COL_B, ROW_2)
	oCell.setFormula(sFormula)
	
Skip1:
	'// Rename column A "H".
	oCell = oSheet.getCellByPosition(COL_A, ROW_HEADING)
	oCell.String = "H"
	
	'// copy all information from column F to column A.
	'// all information from column G to column F.
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount
		lThisRow = lThisRow + 1
		oCell = oSheet.getCellByPosition(COL_F, lThisRow)
		oCell2 = oSheet.getCellByPosition(COL_A, LThisRow)
		oCell2.String = oCell.String
		oCell2 = oSheet.getCellByPosition(COL_G, lThisRow)
		oCell.String = oCell2.String
	next i

	'// set G search prompt to 'fastpeople'.
	oCell = oSheet.getCellByPosition(COL_G, ROW_HEADING)
	oCell.String = "fastpeople"
	
'//		Remove column J - L.
	oSheet.Columns.removeByIndex(COL_J, 3)
	
	'// now remove column K (RSO).
	oSheet.Columns.removeByIndex(COL_K, 1)
	
	'// now remove columns L - P.
	oSheet.Columns.removeByIndex(COL_L,4)
	 

'//		Center "H" column A, and Unit column C.

	oSheet.Columns(COL_C).HoriJustify = CJUST
	oSheet.Columns(COL_A).HoriJustify = CJUST

'//	set up column widths array.
	nSearchColWidths(0) = 0.35*INCH
	nSearchColWidths(1) = 1.75*INCH
	nSearchColWidths(2) = 1.0*INCH
	nSearchColWidths(3) = 1.75*INCH
	nSearchColWidths(4) = 1.0*INCH
'	nSearchColWidths(4) = 0.35*INCH
	nSearchColWidths(5) = 1.0*INCH
	nSearchColWidths(6) = 1.35*INCH
	nSearchColWidths(7) = 1.35*INCH
	nSearchColWidths(8) = 1.35*INCH
	nSearchColWidths(9) = 0.35*INCH
	nSearchColWidths(10) = 0.35*INCH
	SetColWidths(nSearchColWidths())

'//		Change B heading to "Address"
'//		col C heading to "Unit"
'//		col D heading to "Name"
	oCell = oSheet.getCellByPosition(COL_B, ROW_HEADING)
	oCell.String = "Address"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_C, ROW_HEADING)
	oCell.String = "Unit"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_D, ROW_HEADING)
	oCell.String = "Name"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_G, ROW_HEADING-1)
	oCell.String = "search"
	oCell.HoriJustify = CJUST

	
'//		set H1 = "Pub-Search formatted sheet"
	'// merge H1-J1 SheetType
	MergeSheetType()
	
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Pub-Search formatted sheet"
	oCell.HoriJustify = CJUST

	oCell = oSheet.getCellByPosition(COL_D, ROW_4)
	sTerrID = trim(oCell.String)
	sSheetName = "Terr" + sTerrID + "_Search"
	RenameSheet(sSheetName)
'	SaveQSearchTerr()			'// save workbook as SearchTerr



	oCell = oSheet.getCellByPosition(COL_F, ROW_HEADING)
	oCell.String = "RefUSA"
	oCell.HoriJustify = CJUST

'//		set J column heading to "DNC", K heading to "FL"
	oCell = oSheet.getCellByPosition(COL_J, ROW_HEADING)
	oCell.String = "DNC"
	oCell.HoriJustify = CJUST
	SetColWidth(COL_J, 0.35)
	oCell = oSheet.getCellByPosition(COL_K, ROW_HEADING)
	oCell.String = "FL"
	oCell.HoriJustify = CJUST
	SetColWidth(COL_K, 0.35)
if true then GoTo CheckDNC
	
	'// set column widths
	SetTerrWidths()

	'// merge owner name cells back together
	MergeOwnerCells()
	
	'// merge Streets/Addrs cells back together
'	MergeStreetsCells()

CheckDNC:
	'// for all rows, check DoNotCall/Foriegn and change Resident1 name to "DO NOT CALL"
dim oCols As Object
	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell = oSheet.getCellByPosition(COL_J, lThisRow)
		oCell2 = oSheet.getCellByPosition(COL_K, lThisRow)
		bForeign = (len(trim(oCell2.String)) &gt; 0)
		bDoNotCall = (len(trim(oCell.String)) &gt; 0)
		if bForeign then
			oCell = oSheet.getCellByPosition(COL_NAME1, lThisRow)
			oCell.String = "Foreign Language - Do not call"
			oCols = oSheet.Columns
			oCols(COL_NAME1).setPropertyValue("Width", 2540*2)
		elseif bDoNotCall then
			oCell = oSheet.getCellByPosition(COL_NAME1, lThisRow)
			oCell.String = "DO NOT CALL"
		endif
		
	next i

if false then
   GoTo Cleanup
endif
	'// tidy up header information
	oCell = oSheet.getCellByPosition(COL_A, 1)
	oCell.String = ""
	SetHdrSumFormula4()		'//  this has to be the COUNTA($B formula
	
	'// merge City and State at B3.
	oCell = oSheet.getCellByPosition(COL_A, 2)
	oCell.String = ""
	oCell = oSheet.getCellByPosition(COL_B, 2)
	sCity = oCell.String
	oCell.String = "City: " &amp; sCity	

    '// merge Territory/Subterritory at D1.
    oCell = oSheet.getCellByPosition(COL_D, 3)
    sCongTerr = oCell.String
    oCell = oSheet.getCellByPosition(COL_B, 3)
    sSubTerr =trim( oCell.String)
    oCell = oSheet.getCellByPosition(COL_D, 0)
    oCell.String = "Territory: " &amp; sCongTerr
    oCell.HoriJustify = LJUST
    if len(sSubTerr) &gt; 0 then
    	oCell.String = oCell.String &amp; "/" &amp; sSubTerr
    endif
    
    '// empty A4-I4 and merge for blank row.
    '// clear A4, C4, D4.
    oCell = oSheet.getCellByPosition(COL_A,ROW_4)
	oCell.String = ""
    oCell = oSheet.getCellByPosition(COL_C,ROW_4)
	oCell.String = ""
    oCell = oSheet.getCellByPosition(COL_D,ROW_4)
	oCell.String = ""
	
dim document   as object
dim dispatcher as object
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	'// select range A4:I4
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$A$4:$I$4"
dim Array(0)  as new com.sun.star.beans.PropertyValue

	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args1())
    dispatcher.executeDispatch(document, ".uno:ClearContents", "", 0, Array())

    MergeRow4()

	'// select range A4:I4
	dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "ToPoint"
	args2(0).Value = "$D$2:$I$3"
	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args2())
    dispatcher.executeDispatch(document, ".uno:ClearContents", "", 0, Array())

	MergeHelpArea()		'// there are merged cells, split them
	MergeHelpArea()		'// now merge the cells
	oCell = oSheet.getCellByPosition(COL_D,ROW_2)
	oCell.String = "H = homestead     DNC = do not call     FL = foreign language" _
	   + CHR(13) + CHR(10) + "ALL CAPS = SC county data     Mixed Case = RefUSA data"

	'// clear sheet type area.
	dim args3(0) as new com.sun.star.beans.PropertyValue
	args3(0).Name = "ToPoint"
	args3(0).Value = "$E$1:$G$1"
	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args3())
    dispatcher.executeDispatch(document, ".uno:ClearContents", "", 0, Array())
	dispatcher.executeDispatch(document, ".uno:ToggleMergeCells", "", 0, Array())
    
	args3(0).Name = "ToPoint"
	args3(0).Value = "$H$1:$I$1"
	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args3())
    dispatcher.executeDispatch(document, ".uno:ClearContents", "", 0, Array())
	dispatcher.executeDispatch(document, ".uno:ToggleMergeCells", "", 0, Array())

	args3(0).Name = "ToPoint"
	args3(0).Value = "$E$1:$I$1"
	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args3())
	dispatcher.executeDispatch(document, ".uno:ToggleMergeCells", "", 0, Array())
	dim args18(0) as new com.sun.star.beans.PropertyValue
	args18(0).Name = "Bold"
	args18(0).Value = true
	dispatcher.executeDispatch(document, ".uno:Bold", "", 0, args18())

	oCell = oSheet.getCellByPosition(COL_E, ROW_1)
	oCell.String = "PubSearch"
	
	args18(0).Name = "Bold"
	args18(0).Value = true
	dispatcher.executeDispatch(document, ".uno:Bold", "", 0, args18())

	args3(0).Name = "ToPoint"
	args3(0).Value = "$D$1:$D$1"
	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args3())
	args18(0).Name = "Bold"
	args18(0).Value = true
	dispatcher.executeDispatch(document, ".uno:Bold", "", 0, args18())
	
	'// clear I4 of "search" again...
	oCell = oSheet.getCellByPosition(COL_I, ROW_HEADING-1)
	oCell.String = ""
	
	'// generate hyperlinks.
	GenFLinkM()
	SetGridLand()

Cleanup:		
	'// force recalculation
	ForceRecalc()
	
	'// restore selection to entry place
	SetSelection(oRange)
	
NormalExit:
	exit sub

ErrorHandler:
	msgbox("EditToSearch3 - unprocessed error.")
	GoTo NormalExit
	
end sub		'// end EditToSearch31		3/3/21.	23:15
