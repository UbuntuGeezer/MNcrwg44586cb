'// BizBridgeToBiz.bas
'//---------------------------------------------------------------
'// BizBridgeToBiz - Biz-Bridge sheet to Biz-Territory sheet.
'//		9/26/21.	wmk.	20:52
'//---------------------------------------------------------------

public sub BizBridgeToBiz()

'// Calls.	BoldHeadings, ForceRecalc, SetTerrColWidths3,
'//			SetSelection, MergeOwnerCells, MergeStreetsCells,
'//			MergeSheetType, SetHdrSumFormula3, CenterUnitHstead3,
'//			FreezeView
'//
'//	Modification history.
'//	---------------------
'// 9/26/21.	wmk.	original code; adapted from BridgeToTerr3.
'// Legacy mods.
'//	9/18/20.	wmk.	original code; adapted from EditToTerr
'//	9/19/20.	wmk.	Merge.. calls; FreezeView call added
'//	9/21/20.	wmk.	SetHdrSumFormula call added
'//	9/30/20.	wmk.	PropUse column support
'//	10/3/20.	wmk.	check all rows for DoNotCall
'// 10/23/20.	wmk.	support Unit column replacing Resident1,
'//						Resident2 column removed; dead code removed;
'//						ForceRecalc call added
'// 11/29/20.	wmk.	bug fix DO NOT CALL overwriting Unit field, moved
'//						to Name1 field at new position from 10/23 mod
'// 1/14/21.	wmk.	modified to center columns B and E and to 
'//						freeze view at A6
'// 2/14/21.	wmk.	columns rearranged with H in column A; header
'//						consolidated and simplified.
'// 2/15/21.	wmk.	fix bug where DONOTCALL not updated to use COL_D
'//						so overwriting Unit.
'//	2/19/21.	wmk.	rearrange columns; keep same as version 2, except
'//						H column is now COL_C; stuff that was placed in
'//						B2, B3 now back in A2, A3.
'// 2/20/21.	wmk.	bug fix; column heading missing COL_B "H"; also
'//						H - * is homestead missing *
'// 3/3/21.		wmk.	bug fix; sheet date being lost, so set again
'//						before exit in cell B2 instead of C2.
'// 3/14/21.	wmk.	Add code to Align and wrap text and hightlight
'//						address blocks.
'//	3/16/21.	wmk.	add call to SetPubSheetName to preserve generated
'//						PubTerr sheet name after renaming sheet.
'// 4/7/21.		wmk.	bug fix where DONOTCALL not being set if string "1"
'//						as opposed to numeric 1.
'// 7/10/21.	wmk.	bug fix where zip code being deleted from header;
'//						restore FreezeView call at end.
'// 7/12/21.	wmk.	add inline code to rename sheet to _PubTerr and save;
'//						sCongTerr column corrected.
'//
'//	Notes.
'// Method.
'//		remove columns J-L
'//		remove column H
'//		reset title
'//		E1 = "BizTerr formatted sheet" 

'//	constants.
const COL_PARCEL=0		'// "OwningParcel" column index
const COL_A=0
const COL_B=1
const COL_C=2	
const COL_D=3
const COL_E=4
const COL_F=5
const COL_G=6			'// column G index
const COL_H=7			'// column H index
const COL_I=8			'// column I index
const COL_J=9			'// column J index
const COL_K=10			'// column K index
const COL_L=11			'// column L index (DoNotCall)
const COL_M=12			'// column M index (RSO)
const COL_N=13			'// column N index (Foreign)
const COL_O=14			'// column O index
const COL_P=15			'// column P index
const ROW_1=0
const ROW_2=1
const ROW_3=2
const ROW_4=3
const ROW_HEADING=4		'// headings row index
const LJUST=1		'// left-justify HoriJustify				'// mod052020
const CJUST=2		'// center HoriJustify						'// mod052020
const RJUST=3		'// right-justify HoriJustify				'// mod052320
const MDYY=30		'// 'M/D/YY' format value

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
dim i		As Integer		'// loop index
dim sPropID	As String		'// property ID
dim sSubTerr	As String	'// subterritory
dim sCongTerr	As String	'// cong terr ID
dim lRowCount	As Long		'// row count of addresses
dim dDate		As Double	'// date value
dim sCityStZip	As String	'// concatenated City, State, Zip
dim sNotes		As String	'// notes field
dim nCols		As Integer	'// removal column count
dim sPhone2		As String	'// col F content
dim sCity		As String	'// City from B3
dim sZip		As String	'// Zip from C3							'// mod071021
dim sTitle		As String	'// sheet Title


	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

	'// remove columns J - L.
	oSheet.Columns.removeByIndex(COL_J, 3)
	
	'// remove column H.
	oSheet.Columns.removeByIndex(COL_H, 1)

	'// reset sheet title.	
	oCell =	oSheet.getCellByPosition(COL_E, ROW_2)
	oCell.String = "BizTerr formatted sheet"

	'// pick up terr ID.
    oCell = oSheet.getCellByPosition(COL_D, ROW_4)						'// mod071221
    sCongTerr = oCell.String

	FreezeView()		'// freeze row/column scrolling at A6		'// mod071021

dim document   as object
dim dispatcher as object
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
dim sSheetName	As String
	sSheetName = "Terr" + sCongTerr + "_BizTerr"
dim args19(0) as new com.sun.star.beans.PropertyValue
args19(0).Name = "Name"
'args1(0).Value = "Terr102_Import"
args19(0).Value = sSheetName

dispatcher.executeDispatch(document, ".uno:RenameTable", "", 0, args19())
'$
dispatcher.executeDispatch(document, ".uno:Save", "", 0, Array())

dispatcher.executeDispatch(document, ".uno:Save", "", 0, Array())
document.Close(1)	
	fsSetPubSheetName(sSheetName)					'// mod071221

NormalExit:
	exit sub

ErrorHandler:
	msgbox("BizBridgeToBiz - unprocessed error.")
	GoTo NormalExit

end sub		'// end BizBridgeToBiz	9/26/21.	20:52
