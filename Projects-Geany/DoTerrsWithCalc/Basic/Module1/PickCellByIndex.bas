'// PickCellByIndex.bas
'//---------------------------------------------------------------
'// PickCellByIndex - Select any cell to bring sheet into focus.
'//		7/16/21.	wmk.	00:06
'//---------------------------------------------------------------

public sub PickCellByIndex(plCol As Long, plRow As Long)

'//	Usage.	macro call or
'//			call PickCellByIndex(lCol, lRow)
'//
'// Entry.	user in sheet where desires to GoTo cell
'//
'//	Exit.	user focus on desired cell, lCol adds to "A", lRow converted
'//			 to character value of itself - 1.
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/16/21.	wmk.	original code.

'// local variables.
dim oDocument   as object
dim oDispatcher as object
dim sCellID		As String
dim sCellCol	As String	'// cell column A..Z
dim sCellRow	As String	'// cell roW..
dim lCol		As Long
dim lRow		As Long

'//	code.
	ON ERROR GOTO ErrorHandler

	lCol = plCol
	lRow = plRow
	sCellCol = chr(asc("A") + lCol)
	sCellRow = trim(str(lRow+1))
	sCellID = "$" & sCellCol & "$" & sCellRow
	
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// move to cell $A$6
dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = sCellID

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


NormalExit:
	exit sub

ErrorHandler:
	msgbox("PickCellByIndex - unprocessed error")
	GoTo NormalExit
	
end sub		'// end PickCellByIndex	10/11/20
'/**/
