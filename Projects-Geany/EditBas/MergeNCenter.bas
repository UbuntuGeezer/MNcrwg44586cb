'// MergeNCenter.bas
'//---------------------------------------------------------------
'// MergeNCenter - &lt;sub description&gt;.
'//		9/3/20.	wmk.
'//---------------------------------------------------------------

public sub MergeNCenter

'//	Usage.	macro call or
'//			call Merge/NCenter()
'//
'// Entry.	user has selected area to toggle Merge/Center
'//
'//	Exit.	selected cells merged or unmerged
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/3/20.		wmk.	original code
'//
'//	Notes.
'//

'//	constants.

'//	local variables.
rem ----------------------------------------------------------------------
rem define variables
dim oDocument   as object
dim oDispatcher as object
rem ----------------------------------------------------------------------

	'// code.
	ON ERROR GOTO ErrorHandler
	rem get access to the document
	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	rem ----------------------------------------------------------------------
	oDispatcher.executeDispatch(oDocument, ".uno:ToggleMergeCells", "", 0, Array())

NormalExit:
	exit sub
	
ErrorHandler:
	msgBox("MergeNCenter - unprocessed error.")
	GoTo NormalExit

end sub		'// end MergeNCenter	9/3/20
