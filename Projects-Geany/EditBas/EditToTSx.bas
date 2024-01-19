'// EditToTSx.bas
'//---------------------------------------------------------------
'// EditToTSx - Convert Admin-Edit to Admin-TSExport sheet.
'//		9/10/20.		wmk.	08:15
'//---------------------------------------------------------------

public sub EditToTSx()

'//	Usage.	macro call or
'//			call EditToTSx()
'//
'// Entry.	user selection is Admin-Edit formatted sheet
'//
'//	Exit.	produces an "Admin-TSExport" formatted sheet with the following fields:
'//      A    B        C            D                E           F
'//		id  name  phone_number street_address  city_state_zip  notes
'//	[source]  C        E			B				B3'FL'C3	M, N, O (foreign)
'//
'// Calls.	BoldHeadings, ForceRecalc, fsConcatCityToZip, SetTSColWidths,
'//			SetSelection
'//
'//	Modification history.
'//	---------------------
'//	9/8/20.		wmk.	original code
'// 9/9/20.		wmk.	modified to move entire header over to column B
'//	9/10/20.	wmk.	added SetTSColWidths call; "DO NOT CALL" set in 
'//						name field of DoNotCalls
'//
'//	Notes. With column A so narrow, much better fit for header to just
'//	move the whole thing over to column B. TSToEdit will move it back.
'//
'// Admin-Edit sheet fields.
'//		9/7/20. (lines preceded by #s are SplitTable fields)
'//								source-column	target-column
'//0|OwningParcel|TEXT|1||0
'//1|UnitAddress|TEXT|1||0			B				D
'//2|Resident1|TEXT|0||0			C				B
'//3|Resident2|TEXT|0||0
'//4|Phone1|TEXT|0||0				E				C
'//5|Phone2|TEXT|0||0
'//6|RefUSA-Phone|TEXT|0||0
'//	truepeople hyperlink
'// 411 hyperlink
'// whitepages hyperlink
'//7|SubTerritory|TEXT|0||0
'//8|CongTerrID|TEXT|0||0
'//9|DoNotCall|INTEGER|0|0|0		M
'//10|RSO|INTEGER|0|0|0				N
'//11|Foreign|INTEGER|0|0|0			O
'//12|RecordDate|REAL|0|0|0			P
'//13|X-Pending|INTEGER|0|0|0
'//
'// Method.
'//		Change A heading to "id"
'//		Concatenate City, State, Zip
'//		Move col B entries to Col D
'//		Change D heading to "street_address"
'//		Move col C entries to col B
'//		Change B heading to  "name"
'//		Move col G  entries to col C (RefUSA phone)
'//		Change C heading to "phone-number"
'//		Row-by-Row
'//		  store concatenated city, state, zip in E
'//		  store "" in A
'//       BuildNote from columns M, N, O
'//		  store note in column F
'//       if C = "Not Available", store column E in C
'//  	end Row-by-row
'//		remove columns G - P
'//		set H1 = "Admin-TSExport formatted sheet"

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
dim oCellPhone	As Object	'// cell with Phone1
dim i		As Integer		'// loop index
dim sPropID	As String		'// property ID
dim sSubTerr	As String	'// subterritory
dim sCongTerr	As String	'// cong terr ID
dim lRowCount	As Long		'// row count of addresses
dim dDate		As Double	'// date value
dim sCityStZip	As String	'// concatenated City, State, Zip
dim sNotes		As String	'// notes field
dim	nCols		As Integer	'// column count to remove

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	
	oCell =	oSheet.getCellByPosition(COL_B, ROW_2)
	lRowCount = oCell.Value

	'//		concatenate City State Zip B3 + "FL" + C3
	sCityStZip = fsConcatCityToZip()

	'//		Change col A heading to "id"
	oCell = oSheet.getCellByPosition(COL_A, ROW_HEADING)
	oCell.String = "id"
	oCell.HoriJustify = CJUST

'//		Move col B entries to Col D
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_B
	oMrgRange.EndColumn = COL_B
	oMrgRange.StartRow = ROW_HEADING + 1
	oMrgRange.EndRow = ROW_HEADING + lRowCount
dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_D
	oTarget.Row = ROW_HEADING + 1
	oSheet.moveRange(oTarget,oMrgRange)


'//		Change D heading to "street_address"
	oCell = oSheet.getCellByPosition(COL_D, ROW_HEADING)
	oCell.String = "street_address"
	oCell.HoriJustify = CJUST

'//		Move col C entries to col B
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_C
	oMrgRange.EndColumn = COL_C
	oMrgRange.StartRow = ROW_HEADING + 1
	oMrgRange.EndRow = ROW_HEADING + lRowCount
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_B
	oTarget.Row = ROW_HEADING + 1
	oSheet.moveRange(oTarget,oMrgRange)

'//		Change B heading to  "name"
	oCell = oSheet.getCellByPosition(COL_B, ROW_HEADING)
	oCell.String = "name"
	oCell.HoriJustify = CJUST

'//		Move col G  entries to col C (RefUSA phone)
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_G
	oMrgRange.EndColumn = COL_G
	oMrgRange.StartRow = ROW_HEADING + 1
	oMrgRange.EndRow = ROW_HEADING + lRowCount -1
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_C
	oTarget.Row = ROW_HEADING + 1
	oSheet.moveRange(oTarget,oMrgRange)

'//		Change C heading to "phone_number"
	oCell = oSheet.getCellByPosition(COL_C, ROW_HEADING)
	oCell.String = "phone_number"
	oCell.HoriJustify = CJUST

'//		Change E heading to "city_state_zip"
	oCell = oSheet.getCellByPosition(COL_E, ROW_HEADING)
	oCell.String = "city_state_zip"
	oCell.HoriJustify = CJUST

'//		Change F heading to "notes"
	oCell = oSheet.getCellByPosition(COL_F, ROW_HEADING)
	oCell.String = "notes"
	oCell.HoriJustify = CJUST

'//		Row-by-Row
'//x	  store concatenated city, state, zip in E
'//x	  store "" in A
'//       BuildNote from columns M, N, O
'//		  store note in column F
'//       if C = "Not Available", store column E in C
'//  	end Row-by-row
	lThisRow = ROW_HEADING
dim sOldPhone	As String
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		
		'// store city, state, zip
		oCell = oSheet.getCellByPosition(COL_E, lThisRow)
		sOldPhone = oCell.String
		oCell.String = sCityStZip
'//		  for each entry set col A = ""
		oCell = oSheet.getCellByPosition(COL_A, lThisRow)
		oCell.String = ""

'//       for each entry if DoNotCall (M) "Do NotCall" into F
        sNotes = ""
		oCell = oSheet.getCellByPosition(COL_M, lThisRow)
		if len(trim(oCell.String)) &gt; 0 then
			sNotes = "DoNotCall " 
			oCell = oSheet.getCellByPosition(COL_B, lThisRow)
			oCell.String = "DO NOT CALL"
		endif
		
'//       for each entry if RSO (N) "RSO" into F
		oCell = oSheet.getCellByPosition(COL_N, lThisRow)
		if len(trim(oCell.String)) &gt; 0 then
			sNotes = sNotes + "RSO "
		endif

'//       for each entry if Foreign (O) "Foreign" into F
		oCell = oSheet.getCellByPosition(COL_O, lThisRow)
		if len(trim(oCell.String)) &gt; 0 then
			sNotes = sNotes + "Foreign"
		endif
		oCell = oSheet.getCellByPosition(COL_F, lThisRow)
		oCell.String = sNotes
		
'//		check if C = "Not Available"; if so, change to data from E		
		oCell = oSheet.getCellByPosition(COL_C, lThisRow)
		if (strComp(trim(oCell.String),"Not Available") = 0) then
			oCell.String = sOldPhone
		endif

	next i	'// end loop setting row data
	
'// set count formula in B2 to count column B
	oCell = oSheet.getCellByPosition(COL_B, ROW_2)
	oCell.setFormula("=COUNTA(B6:B1299)")

'// remove all columns G-P
	nCols = ASC("Q") - ASC("G")
	oSheet.Columns.removeByIndex(COL_G, nCols) 

'//	set I1 sheet format to "Admin-TSExport formatted sheet
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = "Admin-TSExport formatted sheet"

	BoldHeadings()
	
'//	shift all heading information over to column B
'// move H1 one right first to make room
'// move A1 through G4 over 1 column right
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_H
	oMrgRange.EndColumn = COL_H
	oMrgRange.StartRow = ROW_1
	oMrgRange.EndRow = ROW_1
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_I
	oTarget.Row = ROW_1
	oSheet.moveRange(oTarget,oMrgRange)

	oMrgRange = oRange
	oMrgRange.StartColumn = COL_A
	oMrgRange.EndColumn = COL_G
	oMrgRange.StartRow = ROW_1
	oMrgRange.EndRow = ROW_4
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_B
	oTarget.Row = ROW_1
	oSheet.moveRange(oTarget,oMrgRange)


	'// set column widths
	SetTSColWidths()
	
	'// force recalculation
	ForceRecalc()
	
	'// restore entry selection
	SetSelection(oRange)
	
NormalExit:
	exit sub

ErrorHandler:
	msgbox("EditToTSx - unprocessed error.")
	GoTo NormalExit
	
end sub		'// end EditToTSx		9/10/20
