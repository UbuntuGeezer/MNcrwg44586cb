'// fsConcatCityToZip.bas
'//---------------------------------------------------------------
'// fsConcatCityToZip - Concatenate City, State, Zip.
'//		9/7/20.	wmk.	17:15
'//---------------------------------------------------------------

public function fsConcatCityToZip() as String

'//	Usage.	sCity_Zip = fsConcatCityToZip()
'//
'// Entry.	B3 = City
'//			C3 = Zip
'//
'//	Exit.	sCity_Zip = B3$ + "FL" + C3$
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/7/20.		wmk.	original code
'//
'//	Notes.
'//

'//	constants.
const COL_CITY=1		'// B
const COL_ZIP=2			'// C
const ROW_CITYZIP=2		'// 3

'//	local variables.
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
dim sRetValue As String
dim sCityZip As String		'// concatenation strin

	'// code.
	ON ERROR GOTO ErrorHandler	
	sRetValue = ""
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)

	sCityZip = ""
	oCell = oSheet.getCellByPosition(COL_CITY, ROW_CITYZIP)
	sCityZip = trim(oCell.String) + " FL "
	oCell = oSheet.getCellByPosition(COL_ZIP, ROW_CITYZIP)
	sCityZip = sCityZip + trim(oCell.String)
	
	sRetValue = sCityZip
	
NormalExit:	
	fsConcatCityToZip = sRetValue
	exit function

ErrorHandler:
   msgbox("fsConcatCityToZip - unprocessed error.")
   GoTo NormalExit
   
end function 	'// end fsConcatCityToZip		9/7/20
