'// MergeRow4.bas
'//----------------------------------------------------------------------
'// MergeRow4 - Merge row 4 cells in Territory.
'//		2/14/21.	wmk.	18:00
'//----------------------------------------------------------------------

public sub MergeRow4()

'//	Usage.	macro call or
'//			call MergeRow4()
'//
'// Entry.	user has territory sheet selectd
'//
'//	Exit.	Sheet row cells cleared and merged (A4:I4)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	2/14/21.	wmk.	original code.
'//
'//	Notes.

'//	constants.

'//	local variables.
dim oDocument   as object
dim oDispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// select range A4:I4
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$A$4:$I$4"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())
	
	oDispatcher.executeDispatch(oDocument, ".uno:ToggleMergeCells", "", 0, Array())

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("MergeRow4 - unprocessed error.")
	
end sub		'// end Merge row 4		2/14/21
