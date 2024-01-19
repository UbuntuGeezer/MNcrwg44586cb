'// SetPIDColFormat.bas
'//---------------------------------------------------------------
'// SetPIDColFormat - Set PropertyID column numeric format.
'//		9/19/20.	wmk.
'//---------------------------------------------------------------

public sub SetPIDColFormat()

'//	Usage.	macro call or
'//			call SetPIDColFormat()
'//
'// Entry.	user in any territory sheet where col A is Parcel ID
'//
'//	Exit.	col A formatted with 10 0's
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/19/20.		wmk.	original code
'//
'//	Notes.
'//

'//	constants.
const TEN_ZEROS=121			'// 10 0's number format
const COL_A=0

'//	local variables.
dim oDoc	As Object	'// ThisComponent
dim oSel	As Object	'// current cell selection on entry
dim oSheet	As Object	'// current sheet
dim oRange	As Object	'// RangeAddress selected
dim iSheetIx	As Integer	'// sheet index this sheet
dim oCols	As Object	'// .Columns array this sheet
dim oCell	As Object	'// cell selected

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns
	oCols(COL_A).setPropertyValue("NumberFormat", TEN_ZEROS)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetPIDColFormat - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetPIDColFormat		9/19/20
