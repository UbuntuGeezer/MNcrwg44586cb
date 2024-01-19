'// MergeAreaCells.bas
'//---------------------------------------------------------------
'// MergeAreaCells - Merge Area cells in Territory sheet header.
'//		9/18/20.	wmk.	22:30
'//---------------------------------------------------------------

public sub MergeAreaCells()

'//	Usage.	macro call or
'//			call MergeAreaCells()
'//
'// Entry.	user has territory sheet selectd
'//
'//	Exit.	Area name cells merged (A1:C1)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/11/20.		wmk.	original code; generated by Record Macro
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

	'// select range A1:C1
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$A$1:$C$1"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	oDispatcher.executeDispatch(oDocument, ".uno:ToggleMergeCells", "", 0, Array())


NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("MergeAreaCells - unprocessed error.")
	
end sub		'// end MergeAreaCells