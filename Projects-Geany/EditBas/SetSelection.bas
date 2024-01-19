'// SetSelection.bas
'//---------------------------------------------------------------
'// SetSelection - Select area given CellRangeAddress.
'//		9/2/20.	wmk.	16:30
'//---------------------------------------------------------------

public sub SetSelection(poRange As Object)

'//	Usage.	macro call or
'//			call SetSelection( oRange )
'//
'//		oRange = RangeAddress with selection criteria
'//
'// Entry.	
'//
'//	Exit.	selected cells in current sheet set by oRange criteria
'//
'// Calls.	fIdxColName
'//
'//	Modification history.
'//	---------------------
'//	9/1/20.		wmk.	original code; stub
'//	9/2/20.		wmk.	debug msgbox commented
'//
'//	Notes.
'//

'//	constants.

'//	local variables.
dim strColumn	As String	'// converted oRange.StartColumn
dim strRow		As String	'// converted oRange.StartRow
dim l1stColumn	As Long		'// first column index
dim l1stRow		As Long		'// first row index
dim sCellID		As String	'// cell id e.g. $A$6
	'// code.
	ON ERROR GOTO ErrorHandler

	'// oRange.StartColumn = 0.. -&gt;A..ZAA..ZZ..AAA.ZZZ etc
	'//						 26.. AA.AZ
	'//						 52.. BA..BZ etc.
	'// Modulus(StartColumn, 26) = offset into last letter
	'//	StartColumn/26 = first 
'		msgBox("In SetSelection - stubbed.")
	'// Get upper left alphanumberic cell address

	l1stColumn = poRange.StartColumn
	l1StRow = poRange.StartRow
	strColumn = fIdxColName(l1stColumn)
	strRow = CStr(l1stRow+1)
	sCellID = "$" + strColumn + "$" + strRow

'	msgBox("SetSelection - upper left = " + sCellID)
	
dim oDocument	As Object	'// UNO document object
dim oDispatcher	As Object	'// UNO service interface	
	'// move to upper left corner of selection
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// set up arguments for uno:GoToCell interface
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = sCellID

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	'// move selection cursor through defined area
dim lDownMoves	As Long		'// number of "Down 1 moves"
dim lRightMoves	As Long		'// number of "Right 1 moves"
	lDownMoves = poRange.EndRow - l1stRow
	lRightMoves = poRange.EndColumn - l1stColumn
	
dim args2(0) as new com.sun.star.beans.PropertyValue
	args2(0).Name = "By"
	if lDownMoves &gt; 0 then
	args2(0).Value = lDownMoves
oDispatcher.executeDispatch(oDocument, ".uno:GoDownSel", "", 0, args2())
	endif

	if lRightMoves &gt; 0 then
		args2(0).Value = lRightMoves
oDispatcher.executeDispatch(oDocument, ".uno:GoRightSel", "", 0, args2())
	endif
	
NormalExit:
	exit sub

ErrorHandler:
	msgbox("SetSelection - unprocessed error.")
	GoTo NormalExit
	
end sub		'// end SetSelection	9/2/20
