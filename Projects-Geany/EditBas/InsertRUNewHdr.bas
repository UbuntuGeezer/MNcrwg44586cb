'// InsertRUNewHdr.bas
'//---------------------------------------------------------------
'// InsertRUNewHdr - Insert 5-row territory sheet header.
'//		10/18/20.	wmk.	19:00
'//---------------------------------------------------------------

public sub InsertRUNewHdr(psTitle As String)

'//	Usage.	macro call or
'//			call InsertRUNewHdr(sTitle )
'//	
'//		sTitle - sheet title to set in H1-I1
'//
'// Entry.	user has RefUSA/Terrxxx.csv download sheet selected
'//			row index 0 is column headings
'//			sheet 'TerrxxxHdr' contains 1 row of information from
'//			TerrIDData.db. [if not present, call InsertTerrHdr]
'// 	Row 1
'//			  A			B			C			   D	E		F	    G
'//			TerrID, AreaName, Street-Address(s), City, Zip, Location, Type
'//		[Row 2]..[Row n]
'//			  A		   B			C				 D			E
'//			TerrID, SubTerr, Streets-Address(s), Homestead, Parcel-LIKE, 
'//				    F		 G
'//				Unit-LIKE, DBName
'//		if 2nd row is empty, no subterritory information is present
'//
'//	Exit.	Territory sheet header inserted in 1st 4 rows with passed
'//			title in H1-J1, and empty row in row 5 for headings to set
'//
'// Calls. InsertTerrHdr
'//
'//	Modification history.
'//	---------------------
'//	9/30/20.	wmk.	original code; adapted from InsertTerrHdr
'//	10/5/20.	wmk.	add TerrID to calling sequence; remove skip;
'//						bug fix, was checking ROW_1 for subterritory,
'//						changed to ROW_2
'// 10/12/20.	wmk.	bug fix; RefUSA download data has a heading row,
'//						so DO NOT insert 1 row prior to calling
'//						InsertTerrHdr; document check for "TerrNewHdr"
'//						sheet if user has presets...
'// 10/16/20.	wmk.	change to check for TerrxxxHdr sheet where xxx
'//						is TerrID (extracted from Title)
'//	Notes.
'// Method. obtain essential information from TerrNewHdr sheet;
'// if cannot find that sheet, just insert a blank row then call
'// InsertTerrHdr. If sheet found, get territory id from hdr sheet
'// and call InsertQTerrHdr.

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

'// error codes
const ERR_UNK=0			'// unknown
const ERR_HDRSHEET=1	'// header sheet 'Terr.xxx.Hdr' error

'// local variables.
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet
dim oMrgRange	As Object	'// merge range

dim oHdrSheet	As Object	'// sheet containing header information
dim oCell	As Object		'// cell working on
dim sTitle	As String		'// sheet title
dim sTerrID	As String		'// territory ID
dim nErrCode	As Integer	'// error code type 0 - unknown, 1 - sheet not found
dim sHdrShtName	As String	'// header sheet name
dim iStatus	As Integer		'// function return status
dim sAreaName	As String	'// area-commonName
dim sCity 		As String	'// city
dim	sZip		As String	'// zip code
dim sSubTerr	As String	'// subterritory
dim sPropID		As String	'// property ID
dim sOwner		As String	'// owner
dim sStreets	As String	'// streets-address(s)

	'// code.
	ON ERROR GOTO ErrorHandler
	nErrCode = ERR_UNK
	iStatus = 0
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

'	sHdrShtName = "TerrNewHdr"
	sTerrID = Mid(oDoc.Title,5,3)
	sHdrShtName = "Terr" + sTerrID + "Hdr"
	sTitle = psTitle
	
	'// see if sheet exists
	if NOT oDoc.Sheets.hasByName(sHdrShtName) then
		GoTo SimpleHeader
	endif
	
	nErrCode = ERR_UNK
	
	'// get essential info from sHdrShtName, then process
	oHdrSheet = oDoc.Sheets.getByName(sHdrShtName)

	'// get territory id from first row
	oCell = oHdrSheet.getCellByPosition(COL_A, ROW_2)
	sTerrID = oCell.String

	'// no subterritory on new territory, set streets
	sSubTerr = ""
	'// get streets information from row 1
	oCell = oHdrSheet.getCellByPosition(COL_C, ROW_2)
	sStreets = oCell.String

	'// set remaining information from row 1 (territory)
	oCell = oHdrSheet.getCellByPosition(COL_A, ROW_2)
	sTerrID = oCell.String
	oCell = oHdrSheet.getCellByPosition(COL_B, ROW_2)
	sAreaName = oCell.String
	oCell = oHdrSheet.getCellByPosition(COL_D, ROW_2)
	sCity = oCell.String
	oCell = oHdrSheet.getCellByPosition(COL_E, ROW_2)
	sZip = oCell.String
	
	'// insert 4 rows at top of sheet
	oSheet.Rows.insertByIndex(0, 4)	'// insert header rows

	'// set sheet title
	oCell = oSheet.getCellByPosition(COL_H, ROW_1)
	oCell.String = psTitle
	MergeSheetType()
	
	'// set &lt;Area-CommonName&gt;
	oCell = oSheet.getCellByPosition(COL_AREA, ROW_AREA)
	oCell.String = sAreaName
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
	
	'// set "City" and set City, Zip
	oCell = oSheet.getCellByPosition(COL_A, ROW_3)
	oCell.String = "City"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_ICITY, ROW_ICITY)
	oCell.String = sCity
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_IZIP, ROW_ICITY)
	oCell.String = sZip
	oCell.HoriJustify = CJUST
	
	'// set "SubTerr" and "CongTerrID"
	oCell = oSheet.getCellByPosition(COL_SUBTERR, ROW_SUBTERR)
	oCell.String = "SubTerritory"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_SUBTERR+1, ROW_SUBTERR)
	oCell.String = sSubTerr
	oCell.HoriJustify = CJUST
	oCell = oSheet.getCellByPosition(COL_TERRID, ROW_TERRID)
	oCell.String = "CongTerrID"
	oCell.HoriJustify = RJUST
	oCell = oSheet.getCellByPosition(COL_TERRID+1, ROW_TERRID)
	oCell.String = sTerrID
	oCell.HoriJustify = CJUST

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
	oCell.String = sStreets
	oCell.HoriJustify = CJUST
	MergePropIDCells()
	MergeOwnerCells()
	MergeStreetsCells()
	
NormalExit:
	exit sub

SimpleHeader:
	'// something wrong with header info sheet; just use InsertTerrHdr
	'// insert 1 row, then call InsertTerrHdr
'	oSheet.Rows.insertByIndex(0, 1)	'// insert 1 row
	InsertTerrHdr(sTitle)
	GoTo NormalExit:
	
ErrorHandler:
	select case nErrCode
	case ERR_HDRSHEET
		msgbox("InsertRUNewHdr - error in '" + sHdrShtName + "'")
	case else
		msgbox("InsertRUNewHdr - unprocessed error")
	end select
	
	GoTo NormalExit
	
end sub		'// end InsertRUNewHdr	10/18/20
