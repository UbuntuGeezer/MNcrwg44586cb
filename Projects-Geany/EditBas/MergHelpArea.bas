'// MergHelpArea.bas
'//----------------------------------------------------------------------
'// MergeHelpArea - Merge D2 - H3 cells in Territory.
'//		2/19/21.	wmk.	19:00
'//----------------------------------------------------------------------

public sub MergeHelpArea()

'//	Usage.	macro call or
'//			call MergeHelpArea()
'//
'// Entry.	user has territory sheet selected
'//
'//	Exit.	Sheet row cells cleared and merged (D2:H3)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	2/14/21.	wmk.	original code.
'// 2/19/21.	wmk.	changed area to D2:H3
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
	args1(0).Value = "$D$2:$H$3"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())
	
	dim Array(0) as new com.sun.star.beans.PropertyValue
	oDispatcher.executeDispatch(oDocument, ".uno:ToggleMergeCells", "", 0, Array())

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("MergeHelpArea - unprocessed error.")
	
end sub		'// end MergeHelpArea		2/19/21.	19:15
