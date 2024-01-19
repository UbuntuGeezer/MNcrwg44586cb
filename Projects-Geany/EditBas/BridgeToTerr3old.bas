'// BridgeToTerr3old.bas
'//---------------------------------------------------------------
'// BridgeToTerr3old - Admin-Bridge sheet to Pub-Territory sheet.
'//		4/7/21.	wmk.	11:57
'//---------------------------------------------------------------

public sub BridgeToTerr3old()

'//	Usage.	macro call or
'//			call BridgeToTerr3()
'//
'// Entry.
'//	OwningParcel  UnitAddress  Unit	 Resident1 Phone1 Phone2 RUPhone
'//			A			B		C		D		  E		 F		G	
'//  SubTerr CongTerr DoNotCall RSO Foreign  RecordDate SitusAddress
'//		H		I		   J     K     L		M			  N		
'//  PropUse	DelPending
'//		O  			P
'//
'//	Exit.	produces a "Pub-Territory" formatted sheet with the following fields:
'//        A    	B      C       D      E     F    		G		   H		I
'//		Address   Unit  Name1   Phone1  Phone2 RU/Phone	 DoNotCall	Foreign	Personal/Notes
'//[source] B      C	  D		   E	  F	        G          J       L		-
'//
'// Proposed (Version 3)
'//	Exit.	produces a "Pub-Territory" formatted sheet with the following fields:
'//        A    	B      C       D      E         F     G	  H		    I
'//		 Address  Unit   Phone2	 Name1  Phone1  RU/Phone DNC  FL	Personal/Notes
'//[source] A      B	   	F	   C     D	        G     J    L		-




'// Calls.	BoldHeadings, ForceRecalc, SetTerrColWidths3,
'//			SetSelection, MergeOwnerCells, MergeStreetsCells,
'//			MergeSheetType, SetHdrSumFormula3, CenterUnitHstead3,
'//			FreezeView
'//
'//	Modification history.
'//	---------------------
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
'//	Notes.
'// New Method.
'//		insert new column at COL_C
'//		move all data from (new) COL_G to COL_C
'//		remove COL_G
'//		change column C heading to 'H'
'// Method.
'//		Move header A1-H4 to B1
'//		Remove column A
'//		Change A heading to "Address"
'//		col B heading to "Name1"
'//		col C heading to "Name2"
'//		col G heading to "DoNotCall"
'//		move col I data to col G
'//		col H heading to "Foreign"
'//		move col K data to col H
'//		remove columns I to N
'//		col I heading to "Personal Notes"
'//		H1 = "Admin-TSExport formatted sheet" 

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


	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value

	'// remove columns H, I since header already set
	oSheet.Columns.removeByIndex(COL_H, 2)

	'// now remove new I (RSO)
	oSheet.Columns.removeByIndex(COL_I, 1)

	'// now remove J - M
	oSheet.Columns.removeByIndex(COL_J, 4)
		
if false then		'// REVERT to prior code...
   goto Skip1
endif	
	'// move A1-H4 to B1 to allow col A removal
	'//		move data from entire column E to B
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
Skip1:
	if false then	'// REVERT to prior code..
	   goto Skip2
	endif
	
	'// remove col A
	oSheet.Columns.removeByIndex(COL_A, 1)
Skip2:	

if true then
   GoTo Skip2a
endif
	'// change col A heading to "H"
	oCell = oSheet.getCellByPosition(COL_A, ROW_HEADING)
	oCell.String = "H"
	oCell.HoriJustify = CJUST
	if false then
	   goto Skip3
	endif

Skip2a:
	'//		col B heading to "Unit"
	oCell = oSheet.getCellByPosition(COL_B, ROW_HEADING)
	oCell.String = "Unit"
	oCell.HoriJustify = CJUST

	'//		col C heading to "Name1"
	oCell = oSheet.getCellByPosition(COL_C, ROW_HEADING)
	oCell.String = "Name(s)"
	oCell.HoriJustify = CJUST
Skip3:

	'// insert new column at C.
	oSheet.Columns.insertByIndex(COL_C, 1)
	oCell = oSheet.getCellByPosition(COL_C,ROW_HEADING)
	oCell.String = "H"
	oCell.HoriJustify = CJUST
		
	'// revision 3 copy to C instead of A
     '// copy G column data to column C; Phone2 is "homestead".
	lThisRow = ROW_HEADING		'// start 1 row behind
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell = oSheet.getCellByPosition(COL_F, lThisRow)
		sPhone2 = oCell.String
		oCell = oSheet.getCellByPosition(COL_C, lThisRow)
		oCell.String = sPhone2
	next i
    oSheet.Columns(COL_C).HoriJustify = CJUST
     '// delete column F; F is now RefUSA data.
	oSheet.Columns.removeByIndex(COL_F, 1)
     
     
	'// Set G4 "DNC", H4 "FL", set F4 to "RefUSA"
	oCell = oSheet.getCellByPosition(COL_G, ROW_HEADING-1)
	oCell.String = ""
	oCell = oSheet.getCellByPosition(COL_G, ROW_HEADING)
	oCell.String = "DNC"
	oCell = oSheet.getCellByPosition(COL_H, ROW_HEADING)
	oCell.String = "FL"
	oCell = oSheet.getCellByPosition(COL_F, ROW_HEADING)
	oCell.String = "RefUSA"
	oCell.HoriJustify = CJUST

	'//		col I heading to "Personal Notes"
	oCell = oSheet.getCellByPosition(COL_I, ROW_HEADING)
	oCell.String = "Personal Notes"
	oCell.HoriJustify = CJUST

	'//		H1 = "Pub-Territory formatted sheet" 
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Pub-Territory formatted sheet"

	'// check rows for DoNotCall flag and set Name1 accordingly
	lThisRow = ROW_HEADING		'// start 1 row behind
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		oCell = oSheet.getCellByPosition(COL_G, lThisRow)
'		if StrComp(oCell.String, "1") = 0 then
'		if oCell.Value = 1 then
		if (oCell.Value = 1) OR (StrComp(oCell.String, "1") = 0) then
			oCell = oSheet.getCellByPosition(COL_D, lThisRow)
			oCell.String = "DO NOT CALL"
		endif
	next i
	
	'// tidy up header information.
	'// revision 3 puts new data in A2,A3, not B2, B3
	oCell = oSheet.getCellByPosition(COL_A, ROW_2)
	oCell.String = ""
	SetHdrSumFormula3()		'// A2 formula "record count" xxx
	
	'// merge City and State at A3.
	oCell = oSheet.getCellByPosition(COL_B, ROW_3)
	sCity = oCell.String
	oCell.String = ""
	oCell = oSheet.getCellByPosition(COL_A, ROW_3)
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

	'// select range D2:H3
	dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "ToPoint"
	args2(0).Value = "$D$2:$H$3"
	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args2())
    dispatcher.executeDispatch(document, ".uno:ClearContents", "", 0, Array())

'	MergeHelpArea()		'// there are merged cells, split them
	MergeHelpArea()		'// now merge the cells
	oCell = oSheet.getCellByPosition(COL_D,ROW_2)
	oCell.String = "H = * is homestead     DNC = do not call     FL = foreign language" _
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

	BoldHeadings()
	SetTerrColWidths3()
'	MergeSheetType2()	'// split cells
'	MergeSheetType2()	'// remerge
	oCell = oSheet.getCellByPosition(COL_E, ROW_1)
	oCell.String = "PubTerr"
	
	args18(0).Name = "Bold"
	args18(0).Value = true
	dispatcher.executeDispatch(document, ".uno:Bold", "", 0, args18())

	args3(0).Name = "ToPoint"
	args3(0).Value = "$D$1:$D$1"
	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args3())
	args18(0).Name = "Bold"
	args18(0).Value = true
	dispatcher.executeDispatch(document, ".uno:Bold", "", 0, args18())

	'// Set sheet date in B2.
	oCell = oSheet.getCellByPosition(COL_B, ROW_2)
	oCell.setValue(Now())					'// time stamp
	oCell.Text.NumberFormat = MDYY
	oCell.HoriJustify = CJUST

	CenterUnitHstead3()	'// center unit and "homestead" columns
'	FreezeView()		'// freeze row/column scrolling at A6
	ForceRecalc()
	SelPubSheetArea()
	WrapLong()
	HltAddrBlocks3()
	

NormalExit:
	exit sub

ErrorHandler:
	msgbox("BridgeToTerr3 - unprocessed error.")
	GoTo NormalExit

end sub		'// end BridgeToTerr3		4/7/21.		11:57
