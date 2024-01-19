'// SetColWidth.bas
'//---------------------------------------------------------------
'// SetColWidth - Set column width for specified column.
'//		9/11/20.	wmk.	22:30
'//---------------------------------------------------------------

public sub SetColWidth(plCol As Long, pdWidth As Single)

'//	Usage.	call SetColWidth(lCol, dWidth)
'//
'//		lCol - column index on which to set width
'//		dWidth - column width to set (inches"
'//
'// Entry.	User in RefUSA/Admin formatted territory sheet
'//
'//	Exit.	column lCol width set to dWidth" (2540=1")
'//
'// Calls.	PushSelection, PopSelection, fIdxColName
'//
'//	Modification history.
'//	---------------------
'//	9/2/20.		wmk.	original code
'// 9/5/20.		wmk.	separated params for dispatcher call
'//
'//	Notes. Column width is specified in inches, 2540 = 1 inch.
'//	PushSelection, PopSelection and associated "static" vars must
'// be in the same module as this sub.

'//	constants.
const	INCH_BASE=2540

'//	local variables.
dim oDocument   as object
dim oDispatcher as object
dim sCellName	As String	'// cell name in format $col$row
dim sColName	As String	'// column name
dim oDoc		As Object	'// ThisComponent
dim oSel		As Object	'// selected Range is here .RangeAddress
dim oRange		As Object	'// range selected
dim oSheet		As Object	'// this sheet
dim oCols		As Object	'// .Columns this sheet
dim iSheetIx	As Integer	'// this sheet index

	'// code.
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	iSheetIx = oRange.Sheet
	oSheet = oDoc.Sheets(iSheetIx)
	oCols = oSheet.Columns
	oCols(plCol).setPropertyValue("Width", pdWidth*INCH_BASE)

if true then
	GoTo EndOldCode
endif

'//----------------------------------------------------------------
	sColName = ""		'// empty column name

	'// preserve current selection
	
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// set column width for selected to specified width

	'// set up arguments for uno:GoToCell interface
	sColName = fIdxColName(plCol)
	sCellName = "$" + sColName + "$1"		'// set 1st row as target
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = sCellName

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


rem ----------------------------------------------------------------------
dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "ColumnWidth"
	args2(0).Value = pdWidth * INCH_BASE

	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args2())
'dim args1(0) as new com.sun.star.beans.PropertyValue
'	args1(0).Name = "ColumnWidth"
'	args1(0).Value = pdWidth * INCH_BASE

'	oDispatcher.executeDispatch(oDocument, ".uno:ColumnWidth", "", 0, args1())
'//---------------------------------------------------------------------------
EndOldCode:	
NormalExit:
	SetSelection(oRange)		'// restore user selection on entry
	exit sub
	
ErrorHandler:
	msgbox("SetColWidth - unprocessed error.")
	GoTo NormalExit
	
end sub		'// end SetColWidth	9/11/20
