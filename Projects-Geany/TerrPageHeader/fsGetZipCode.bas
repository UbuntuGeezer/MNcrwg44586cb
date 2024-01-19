'// fsGetZipCode.bas
'//---------------------------------------------------------------
'// fsGetZipCode - Get Zip code from Territory spreadsheet.
'//		11/20/21.	wmk. 07:16
'//---------------------------------------------------------------

public function fsGetZipCode(poDoc as Object) as String

'//	Usage.	sZipCode = fsGetZipCode(oDoc As Object)
'//
'//		oDoc = document to extract zip code from
'//
'// Entry.	User in Territories worksheet with pubterr header.
'//
'//	Exit.	sZipCode = zip code from cell B3
'//
'// Calls.	
'//
'//	Modification history.
'//	---------------------
'//	11/20/21.		wmk.	original code.
'//
'//	Notes. This function serves projects like TerrPageHeader that depend
'// upon knowing the territory zip code.
'//

'//	constants.
const COL_B = 1			'// index of Column B
const ROW_3 = 2			'// index of Row 3

'//	local variables
dim sRetValue		As String	'// returned value
dim oDoc			As Object	'// ThisComponent
dim oSheet			As Object	'// sheet
dim oSel			As Object	'// current selection
dim oRange			As Object	'// RangeAddress
dim oCell			As Object	'// cell for extraction
dim iSheetIx		As Integer	'// sheet selected

	'// code.
	ON ERROR GOTO ErrorHandler
	sRetValue = ""
	oDoc = poDoc
	oSel = oDoc.GetCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCell = oSheet.GetCellByPosition(COL_B,ROW_3)
	sRetValue = oCell.String
	
NormalExit:
	fsGetZipCode = sRetValue
	exit function
	
ErrorHandler:
	msgbox("fsGetZipCode - unprocessed error")
	GoTo NormalExit

end function 	'// end fsGetZipCode	11/20/21.	07:16
