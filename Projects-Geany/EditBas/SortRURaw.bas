'// SortRURaw.bas
'//---------------------------------------------------------------
'// SortRURaw - Sort RefUSA Import sheet on FullAddress field.
'//		9/15/20.	wmk.	09:50
'//---------------------------------------------------------------

public sub SortRURaw()

'//	Usage.	macro call or
'//			call SortRURaw()
'//
'// Entry.	user has selected row(s) of import data to be
'//			sorted in ascending order by FullAddress column
'//
'//	Exit.	selected rows sorted; selection extended to column Z,
'//			then restored
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/15/20.	wmk.	original code; adapted from SortOnAddress
'//
'//	Notes. Either the user will have selected all active rows, or
'// SelectActiveRows() will have been called prior to entry.

'//	constants.
const COL_STREET=4			'// street name
const COL_FULLADDR=13		'// full concatenated address

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
	nActiveColumns = 25
	
	'// set up for sort - select out to column Z
oDocument   = ThisComponent.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "By"
	args2(0).Value = nActiveColumns
	oDispatcher.executeDispatch(oDocument, ".uno:GoRightSel", "", 0, args2())

	'// set up for Sort call to sort all entries by address
	rem ----------------------------------------------------------------------
dim args55(11) as new com.sun.star.beans.PropertyValue
	args55(0).Name = "ByRows"
	args55(0).Value = true
	args55(1).Name = "HasHeader"
	args55(1).Value = false
	args55(2).Name = "CaseSensitive"
	args55(2).Value = false
	args55(3).Name = "NaturalSort"
'	args55(3).Value = false
	args55(3).Value = true				'// set true so 1,11,15 do not appear together
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
	SetSelection(oRange)
	
NormalExit:
'	msgbox("SortRURaw complete. ")
	exit sub
	
ErrorHandler:	
	msgbox("SortRURaw - unprocessed error.")
	GoTo NormalExit

end sub		'// end SortRURaw	9/15/20
