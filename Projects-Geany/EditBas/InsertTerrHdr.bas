'// InsertTerrHdr.bas
'//---------------------------------------------------------------
'// InsertTerrHdr - Insert 4-row territory sheet header.
'//		9/24/20.	wmk.	23:15
'//---------------------------------------------------------------

public sub InsertTerrHdr(psTitle As String)

'//	Usage.	macro call or
'//			call InsertTerrHdr( sTitle )
'//
'//			sTitle - sheet title to set in H1-I1
'//
'// Entry.	user has .csv download sheet selected with column names
'//			in 1st row
'//
'//	Exit.	Territory sheet header inserted in 1st 4 rows with passed
'//			title in H1-J1
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/21/20.	wmk.	original code
'//	9/24/20.	wmk.	documentation updated; sheet title in H1-I1; add
'//						date setting code
'//
'//	Notes.

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
const LJUST=1		'// left-justify HoriJustify
const CJUST=2		'// center HoriJustify		
const RJUST=3		'// right-justify HoriJustify
const MDYY=30		'// 'M/D/YY' format value

const COL_AREA=0		'// "Area-CommonName"	A1-D1
const ROW_AREA=0
const COL_CITY=8		
const COL_ZIP = 10
const COL_ICITY=1		'// &lt;city&gt;			B3
const ROW_ICITY=2
const COL_IZIP=2		'// &lt;zipcode&gt;		C3
const ROW_DATE=1
const COL_DATE=2		'// &lt;date&gt; 			C2
const ROW_BASE=5
const COL_UNITS=0		'// "Units shown:" 	A2
const ROW_UNITS=1
const COL_FUNITS=1		'// "=COUNTA(A6:A298)" B2

'// new header locations 9/2/20
const COL_SUBTERR=0		'// "SubTerritory" 	A4
const ROW_SUBTERR=3
const COL_TERRID=2		'// "CongTerrID"	B4
const ROW_TERRID=3
const COL_PROPID=3		'// "Property ID"	D1
const ROW_PROPID=0
const ROW_OWNER=1		'// "Owner"			D2
const ROW_STRADDR=2		'// "Streets/Addrs"	D3
'// end new header locations 9/2/20

'// local variables.
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet
dim oMrgRange	As Object	'// merge range

dim oCell	As Object		'// cell working on
dim sTitle	As String		'// sheet title

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

	'// insert 4 rows at top of sheet
	oSheet.Rows.insertByIndex(0, 4)	'// insert new category 1 row

	'// set sheet title
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = psTitle
	MergeSheetType()
	
	'// set &lt;Area-CommonName&gt;
	oCell = oSheet.getCellByPosition(COL_AREA, ROW_AREA)
	oCell.String = "&lt;Area - CommonName&gt;"
	MergeAreaCells()

	'// Date to header
	oCell = oSheet.getCellByPosition(COL_DATE, ROW_DATE)
	oCell.setValue(Now())					'// time stamp
	oCell.Text.NumberFormat = MDYY
	oCell.HoriJustify = CJUST
	
	'// set "Units Shown:" info
	oCell = oSheet.getCellByPosition(COL_UNITS, ROW_UNITS)
	oCell.String = "Units Shown:"
	oCell.HoriJustify = RJUST
	SetHdrSumFormula("COUNTA($A$6:$A$1299)")
	
	'// set "City" and prompt for city, zip
	oCell = oSheet.getCellByPosition(COL_A, ROW_3)
	oCell.String = "City"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_ICITY, ROW_ICITY)
	oCell.String = "&lt;city&gt;"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_IZIP, ROW_ICITY)
	oCell.String = "&lt;zip code&gt;"
	oCell.HoriJustify = CJUST
	
	'// set "SubTerr" and "CongTerrID"
	oCell = oSheet.getCellByPosition(COL_SUBTERR, ROW_SUBTERR)
	oCell.String = "SubTerritory"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_TERRID, ROW_TERRID)
	oCell.String = "CongTerrID"
	oCell.HoriJustify = RJUST

	'// set "Property ID", "Owner", and "Streets/Addrs" info
	oCell = oSheet.getCellByPosition(COL_PROPID, ROW_PROPID)
	oCell.String = "Property ID"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_PROPID+1, ROW_PROPID)
	oCell.String = "-"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_PROPID, ROW_OWNER)
	oCell.String = "Owner"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_PROPID+1, ROW_OWNER)
	oCell.String = "-"
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_PROPID, ROW_STRADDR)
	oCell.String = "Streets/Addrs"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_PROPID+1, ROW_STRADDR)
	oCell.String = "&lt;streets/addresses&gt;"
	oCell.HoriJustify = CJUST
	MergePropIDCells()
	MergeOwnerCells()
	MergeStreetsCells()

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("InsertTerrHdr - unprocessed error")
	GoTo NormalExit
	
end sub		'// end InsertTerrHdr	9/24/20
