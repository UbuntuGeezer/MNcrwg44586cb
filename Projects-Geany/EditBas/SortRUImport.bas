'// SortRUImport.bas
'//---------------------------------------------------------------
'// SortRUImport - Sort RefUSA Import sheet on FullAddress field.
'//		9/16/20.	wmk.	18:00
'//---------------------------------------------------------------

public sub SortRUImport()

'//	Usage.	macro call or
'//			call SortRUImport()
'//
'// Entry.	user has selected row(s) of import data to be
'//			sorted in ascending order by FullAddress column
'//
'//	Exit.	selected rows sorted
'//			then restored
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/16/20.	wmk.	original code; adapted from SortRURaw
'//
'//	Notes. Either the user will have selected all active rows, or
'// SelectActiveRows() will have been called prior to entry,
'// and the selection will have been extended to include column S.

'//	constants.
const COL_STREET=5		'// street name
const COL_FULLADDR=9		'// full concatenated address

'//	local variables.

dim oDocument   as object
dim oDispatcher as object
dim oDoc 		As Object
dim oSel		As Object
dim oRange		As Object
dim oNewRange	As Object
dim nActiveColumns	As Integer

'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSel = oDoc.getCurrentSelection()
	oRange = oSel.RangeAddress
	oNewRange = oRange				'// capture current range
	oNewRange.EndColumn = 25		'// set out to column Z for sort
	
if false then
  GoTo Skip1
endif
'//--------------------------------------------------------------------------
	nActiveColumns = 25
	SelectActiveRows()
	'// set up for sort - select out to column Z
oDocument   = ThisComponent.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "By"
	args(2).Value = nActiveColumns
	oDispatcher.executeDispatch(oDocument, ".uno:GoRightSel", "", 0, args2())
'//--------------------------------------------------------------------------
Skip1:

	'// set up for Sort call to sort all entries by address
	rem ----------------------------------------------------------------------
dim args20(11) as new com.sun.star.beans.PropertyValue
args20(0).Name = "ByRows"
args20(0).Value = true
args20(1).Name = "HasHeader"
args20(1).Value = false
args20(2).Name = "CaseSensitive"
args20(2).Value = false
args20(3).Name = "NaturalSort"
args20(3).Value = false
args20(4).Name = "IncludeAttribs"
args20(4).Value = true
args20(5).Name = "UserDefIndex"
args20(5).Value = 0
args20(6).Name = "Col1"
args20(6).Value = 5
args20(7).Name = "Ascending1"
args20(7).Value = true
args20(8).Name = "Col2"
args20(8).Value = 9
args20(9).Name = "Ascending2"
args20(9).Value = true
args20(10).Name = "IncludeComments"
args20(10).Value = false
args20(11).Name = "IncludeImages"
args20(11).Value = true

if true then
  GoToSkip2
endif
dim args55(11) as new com.sun.star.beans.PropertyValue
	args55(0).Name = "ByRows"
	args55(0).Value = true
	args55(1).Name = "HasHeader"
	args55(1).Value = false
	args55(2).Name = "CaseSensitive"
	args55(2).Value = false
	args55(3).Name = "NaturalSort"
	args55(3).Value = false
'	args55(3).Value = true				'// set true so 1,11,15 do not appear together
	args55(4).Name = "IncludeAttribs"
	args55(4).Value = true
	args55(5).Name = "UserDefIndex"
	args55(5).Value = 0
	args55(6).Name = "Col1"
	args55(6).Value = COL_STREET + 1		'// plus 1 for $&lt;Lletter&gt;..
	args55(7).Name = "Ascending1"
	args55(7).Value = true
	args55(8).Name = "Col2"
	args55(8).Value = COL_FULLADDR + 1		'// plus 1 for $&lt;letter?..
	args55(9).Name = "Ascending2"
	args55(9).Value = true
	args55(10).Name = "IncludeComments"
	args55(10).Value = false
	args55(11).Name = "IncludeImages"
	args55(11).Value = true

	oDispatcher.executeDispatch(oDocument, ".uno:DataSort", "", 0, args55())
Skip2:
oDocument   = ThisComponent.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	oDispatcher.executeDispatch(oDocument, ".uno:DataSort", "", 0, args20())

NormalExit:
'	msgbox("SortRUImport complete. ")
	exit sub
	
ErrorHandler:	
	msgbox("SortRUImport - unprocessed error.")
	GoTo NormalExit

end sub		'// end SortRUImport	9/16/20
