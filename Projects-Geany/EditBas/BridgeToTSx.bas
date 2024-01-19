'// BridgeToTSx.bas
'//---------------------------------------------------------------
'// BridgeToTSx - Admin-Bridge sheet to TSExport formatted sheet.
'//		9/13/20.	wmk.	07:45
'//---------------------------------------------------------------

public sub BridgeToTSx()

'//	Usage.	macro call or
'//			call BridgeToTSx()
'//
'// Entry.
'//	OwningParcel  UnitAddress  Resident1 Resident2 Phone1 Phone2 RUPhone SubTerr CongTerr DoNotCall RSO Foreign  RecordDate
'//			A			B			C		D		  E		 F		G		H		I		   J     K     L		M
'//
'//	Exit.	produces an "Admin-TSExport" formatted sheet with the following fields:
'//      A    B        C            D                E           F
'//		id  name  phone_number street_address  city_state_zip  notes
'//			  C        E			B				B3'fl'C3	L, M, N (foreign)
'//
'// Calls. fsConcatCityToZip
'//
'//	Modification history.
'//	---------------------
'//	9/7/20.		wmk.	original code
'//	9/13/20.	wmk.	name change from BridgeToTerr to BridgeToTSx
'//
'//	Notes.
'// MultiMail/SplitProps table fields.
'//		9/7/20.
'//0|OwningParcel|TEXT|1||0
'//1|UnitAddress|TEXT|1||0
'//2|Resident1|TEXT|0||0
'//3|Resident2|TEXT|0||0
'//4|Phone1|TEXT|0||0
'//5|Phone2|TEXT|0||0
'//6|RefUSA-Phone|TEXT|0||0
'//7|SubTerritory|TEXT|0||0
'//8|CongTerrID|TEXT|0||0
'//9|DoNotCall|INTEGER|0|0|0
'//10|RSO|INTEGER|0|0|0
'//11|Foreign|INTEGER|0|0|0
'//12|RecordDate|REAL|0|0|0
'//13|DeletePending|INTEGER|0|0|0
'// Method.
'//		Change colA heading to "id"
'//     Insert 2 columns at B
'//		move data from entire column E to B
'//		concatenate City State Zip B3 + "FL" + C3
'//		for each entry
'//       store concatenated city,state,zip in col E
'//       If RefUSAPhone &lt;&gt; "Not Available" and &lt;&gt; ""
'//			move column I to column C
'//       else
'//         move column G to column C
'//		  endif	end phone conditional
'//		  for each entry set col A = ""
'//       for each entry if DoNotCall "Do NotCall" into F
'//       for each entry if RSO "RSO" into F
'//       for each entry if Foreign "Foreign" into F
'//	    next (for)
'//		remove columns G - M
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

	'//     Insert 2 columns at B
	oSheet.Columns.insertByIndex(COL_B,2)

	'//		move data from entire column E to B
	oMrgRange = oRange
	oMrgRange.StartColumn = COL_E
	oMrgRange.EndColumn = COL_E
	oMrgRange.StartRow = ROW_HEADING + 1
	oMrgRange.EndRow = ROW_HEADING + lRowCount -1
dim oTarget as new com.sun.star.table.CellAddress
	oTarget.Sheet = oRange.Sheet
	oTarget.Column = COL_B
	oTarget.Row = ROW_HEADING + 1
	oSheet.moveRange(oTarget,oMrgRange)

	lThisRow = ROW_HEADING
	for i = 0 to lRowCount-1
		lThisRow = lThisRow + 1
		
		'// store city, state, zip
		oCell = oSheet.getCellByPosition(COL_E, lThisRow)
		oCell.String = sCityStZip
'//		  for each entry set col A = ""
		oCell = oSheet.getCellByPosition(COL_A, lThisRow)
		oCell.String = ""
'//       for each entry if DoNotCall (J) "Do NotCall" into F
        sNotes = ""
		oCell = oSheet.getCellByPosition(COL_L, lThisRow)
		if len(trim(oCell.String)) &gt; 0 then
			sNotes = "DoNotCall " 
		endif
		
'//       for each entry if RSO (K) "RSO" into F
		oCell = oSheet.getCellByPosition(COL_M, lThisRow)
		if len(trim(oCell.String)) &gt; 0 then
			sNotes = sNotes + "RSO "
		endif

'//       for each entry if Foreign (L) "Foreign" into F
		oCell = oSheet.getCellByPosition(COL_N, lThisRow)
		if len(trim(oCell.String)) &gt; 0 then
			sNotes = sNotes + "Foreign"
		endif
		oCell = oSheet.getCellByPosition(COL_F, lThisRow)
		oCell.String = sNotes
		
	next i	'// end loop setting row data

NormalExit:
	exit sub

ErrorHandler:
	msgbox("BridgeToTSx - unprocessed error.")
	GoTo NormalExit

end sub		'// end BridgeToTSx		9/13/20
