'// ImportRefUSA1.bas
'//---------------------------------------------------------------
'// ImportRefUSA1 -(old) Restructure ReferenceUSA imported sheet.
'//		10/6/20.	wmk.	06:15
'//---------------------------------------------------------------

public sub ImportRefUSA1()

'//	Usage.	macro call or
'//			call ImportRefUSA()
'//
'// Entry.	sheet selected with raw .csv imported data from ReferenceUSA
'//			row index 0 contains headings
'//
'//	Exit.	sheet reorganized as per Notes below; resultant sheet is
'//			in Admin-Import format
'//Last Name, First Name, Full Name, House Number, Pre-directional, Street,
'//Street Suffix, Post-directional, Apartment Number, Full Address, Phone1,
'//Phone2, RefUSA Phone, truepeople, 411, whitepages, DoNotCall, RSO, Foreign
'//
'// Calls.	KillAutoRecalc, FreezeView, BoldHeadings, SetPhoneWidts
'//			SetFullAddrWidth, SetColWidth, SelectActiveRows, SetSelection,
'//			SortOnAddress, SetSearchWidths, ConcatAddressM, ConcatFirstLastM
'//			InsertRUNewHdr
'//
'//	Modification history.
'//	---------------------
'//	8/28/20.	wmk.	original code
'//	8/28/20.	wmk.	added calls to KillAutoRecalc and FreezeView
'// 8/30/20.	wmk.	added call to SetPhoneWidths; added header
'//						"RefUSA" at colum COL_RUPHONE, ROW 3
'//	9/1/20.		wmk.	added code to place column headings for
'//						DoNotCall, RSO
'// 9/2/20.		wmk.	Found Name column changed to Full Name; header
'//						information updated to match MultiMail.db
'//						field mapping sheet for Admin Import
'//	9/3/20		wmk.	Merge A1-A3 for &lt;Area-CommonName&gt;, merge E1-G1
'//						for &lt;OwnerParcel&gt;, merge E2-G2 for &lt;OwnerName1&gt;,
'//						merge E3-G3 for Streets-Address(s); SortOnAddress
'//						ConcatAddressM, ConcatFirstLastM calls added; 
'// 					columns M-P widths set to 1.34"
'//	9/6/20.		wmk.	add support for "RecordDate" field in SplitProps
'//						note RUImportToBridge is where the actual support
'//						code will be placed
'//	9/8/20.		wmk.	add support for "Foreign" field in SplitProps;
'//						note RUIMportToBridge and RUImportToEdit is where
'//						actual support code will be placed; range for
'//						SortAddress now includes column "S"
'// 9/16/20.	wmk.	change to sort on both street and full address
'//						so records come out in street order
'//	9/24/20.	wmk.	mod to call InsertTerrHdr to set up header rows;
'//						constants moved ahead of code; perform all column
'//						insertion and deletion prior to InsertTerrHdr;
'//						use SetColHeadings to set column headings; use
'//						SetColWidths to set column widths; SortAgain
'//						substituted for SortRUImport
'//	9/25/20.	wmk.	old abandoned code removed
'//	10/6/20.	wmk.	mod to call InsertRUNewHdr to set basic territory
'//						information in header. User can now define terr
'//						so basic territory data can be query extracted
'//						to sheet TerrxxxHdr
'//
'//	Notes. Territories/RefUSATest.csv import into sheet..
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
'//
'//	Method. the following steps will be executed
'//		turn off "Autorecalculate" Data property
'//		insert 4 rows starting at row index 0
'//		[Set View/Freeze Rows and Columns at column 0, row 5]
'//		insert column at index 2 "Found Name"
'//		set column header at index 2 "Found Name"
'//		delete 4 columns at column index 9 (city, state, zip, county)
'//		add 3 columns at column index 9 (Full Address, Phone1, Phone2)
'//		insert 3 columns at column index 13 (truepeople, 411, whitepages)
'//		write column headings in 2 cells row indexes 3,4 column indexes 13-15
'//			"search/truepeople", "search/411", "search/whitepages"

'//	constants.
const COL_FULLNAME=2		'// found name
const COL_NUMBER=3			'// house number
const COL_PREDIR=4			'// street pre-direction
const COL_STREET=5			'// street name
const COL_SUFFIX=6			'// street suffix (e.g. Ave)
const COL_POSTDIR=7			'// street post direction
const COL_UNIT=8			'// unit/apt #
const COL_FULLADDR=9		'// full concatenated address
const YELLOW=16776960		'// decimal value of YELLOW color
const MDYY=30				'// number format M/D/YYY
const LJUST=1		'// left-justify HoriJustify				'// mod052020
const CJUST=2		'// center HoriJustify						'// mod052020
const RJUST=3		'// right-justify HoriJustify				'// mod052320
const COL_AREA=0
const ROW_AREA=0
const COL_CITY=8
const COL_ZIP = 10
const COL_ICITY=1
const ROW_ICITY=2
const COL_IZIP=2
const ROW_DATE=1
const COL_DATE=2
const ROW_BASE=5
const COL_UNITS=0		'// "Units shown:"
const ROW_UNITS=1
const COL_FUNITS=1		'// "=COUNTA(A6:A298)"
'// new header locations 9/2/20
const COL_SUBTERR=0		'// "SubTerritory"
const ROW_SUBTERR=3
const COL_TERRID=2		'// "CongTerrID"
const ROW_TERRID=3
const COL_PROPID=3		'// "Property ID"
const ROW_PROPID=0
const ROW_OWNER=1		'// "Owner"
const ROW_STRADDR=2		'// "Streets/Addrs"
'// end new header locations 9/2/20
const COL_SEARCH=13		'//	search/truepeople
const COL_RUPHONE=12	'// RefUSA Phone column
const COL_DONOTCALL=16		'// do not call
const COL_RSO=17			'// registered sex offender
const COL_FOREIGN=18		'// foreign language

'// column widths
const ONE_INCH=2540	'// one inch in .001cm
const A_WIDTH=1.0	'// Last Name
const B_WIDTH=1.0	'// First Name
const C_WIDTH=1.75	'// Full Name
const D_WIDTH=1.04	'// House Number
const E_WIDTH=1.01	'// Pre-directional
const F_WIDTH=1.0	'// Street
const G_WIDTH=0.9	'// Street Suffix
const H_WIDTH=1.1	'// Post-directional
const I_WIDTH=1.30	'// Apartment Number
const J_WIDTH=1.75	'// Full Address
const K_WIDTH=1.0	'// Phone1
const L_WIDTH=1.0	'// Phone2
const M_WIDTH=1.1	'// RefUSA Phone
const N_WIDTH=0.9	'// truepeople
const O_WIDTH=0.9	'// 411
const P_WIDTH=0.9	'// whitepages
const Q_WIDTH=0.9	'// DoNotCall
const R_WIDTH=0.9	'// RSO
const S_WIDTH=0.9	'// Foreign

'//	local variables.
Dim oDoc As Object
Dim oSheet As Object
Dim NewColumn As Object
dim oSel as Object
dim iSheetIx as integer
dim oRange as Object
dim lThisRow as long		'// current row selected on sheet
dim oMrgRange	As Object	'// merge range

'// processing variables.
dim oCell As Object			'// transient cell data
dim sColHdgs(18)	As String	'// column heading strings
dim nColWidths(18)	As Integer	'// column widths

	'// code.
	ON ERROR GoTo ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

	'// insert and delete columns before doing anything else
	'// insert column at index 2 "Full Name"
	oSheet.Columns.insertByIndex(COL_FULLNAME, 1)

	'// remove 4 columns at Full Address column
	oSheet.Columns.removeByIndex(COL_FULLADDR, 4)
	
	'// insert 3 columns at Full Address column
	'// Headings "Full Address", "Phone1", "Phone2"
	oSheet.Columns.insertByIndex(COL_FULLADDR, 3)

	'// now that columns in place, InsertTerrHdr
	InsertRUNewHdr("Admin-Import formatted sheet")
	
	'// set column headings
	sColHdgs(0) = "Last Name"
	sColHdgs(1) = "First Name"
	sColHdgs(2) = "Full Name"
	sColHdgs(3) = "House Number"
	sColHdgs(4) = "Pre-directional"
	sColHdgs(5) = "Street"
	sColHdgs(6) = "Street Suffix"
	sColHdgs(7) = "Post-directional"
	sColHdgs(8) = "Apartment Number"
	sColHdgs(9) = "Full Address"
	sColHdgs(10) = "Phone1"
	sColHdgs(11) = "Phone2"
	sColHdgs(12) = "RefUSA Phone"
	sColHdgs(13) = "truepeople"
	sColHdgs(14) = "411"
	sColHdgs(15) = "whitepages"
	sColHdgs(16) = "DoNotCall"
	sColHdgs(17) = "RSO"
	sColHdgs(18)= "Foreign"
	SetColHeadings(sColHdgs)
	
	'// set column widths
	nColWidths(0) = A_WIDTH * ONE_INCH
	nColWidths(1) = B_WIDTH * ONE_INCH
	nColWidths(2) = C_WIDTH * ONE_INCH
	nColWidths(3) = D_WIDTH * ONE_INCH
	nColWidths(4) = E_WIDTH * ONE_INCH
	nColWidths(5) = F_WIDTH * ONE_INCH
	nColWidths(6) = G_WIDTH * ONE_INCH
	nColWidths(7) = H_WIDTH * ONE_INCH
	nColWidths(8) = I_WIDTH * ONE_INCH
	nColWidths(9) = J_WIDTH * ONE_INCH
	nColWidths(10) = K_WIDTH * ONE_INCH
	nColWidths(11) = L_WIDTH * ONE_INCH
	nColWidths(12) = M_WIDTH * ONE_INCH
	nColWidths(13) = N_WIDTH * ONE_INCH
	nColWidths(14) = O_WIDTH * ONE_INCH
	nColWidths(15) = P_WIDTH * ONE_INCH
	nColWidths(16) = Q_WIDTH * ONE_INCH
	nColWidths(17) = R_WIDTH * ONE_INCH
	nColWidths(18) = S_WIDTH * ONE_INCH
	SetColWidths(nColWidths)
	
	'// kill AutoCalculate
	KillAutoRecalc()

	'// Freeze header so stays when scrolling
	FreezeView()
	
	'// Bold and center headings
	BoldHeadings()

	'// select all active rows.
	SelectActiveRows()
	
	'// concatenate addresses
	ConcatAddressM()
	
	'// concatenate names
	ConcatFirstLastM()

	'// select through column S (at column A in last row)
'// 
dim oDocument	As Object
dim oDispatcher	As Object
dim nColumns	As Integer
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	nColumns = ASC("S") - ASC("A")
dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "By"
	args2(0).Value = nColumns
oDispatcher.executeDispatch(oDocument, ".uno:GoRightSel", "", 0, args2())
'	SortRUImport()
	SortAgain()
		
	'// restore user entry range selection.
	SetSelection(oRange)
		
	'// finished
	msgbox("ImportRefUSA complete.")
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("ImportRefUSA - unprocessed error.")
	GoTo NormalExit
	
end sub		'// end ImportRefUSA	10/6/20
