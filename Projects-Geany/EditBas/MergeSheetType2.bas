'// MergeSheetType2.bas
'//----------------------------------------------------------------------
'// MergeSheetType2 - Merge Sheet type cells E1-I1 Territory sheet header.
'//		2/14/21.	wmk.	20:00
'//----------------------------------------------------------------------

public sub MergeSheetType2()

'//	Usage.	macro call or
'//			call MergeSheetType()
'//
'// Entry.	user has territory sheet selectd
'//
'//	Exit.	Sheet type cells merged (H1:I1)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/12/20.	wmk.	original code
'//	9/24/20.	wmk.	mod to only use H1-I1 so page fits in landscape
'//						when printing PubTerr formatted sheet
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

	'// select range H1:I1
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$H$1:$I$1"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())

	oDispatcher.executeDispatch(oDocument, ".uno:ToggleMergeCells", "", 0, Array())


NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("MergeSheetType2 - unprocessed error.")
	
end sub		'// end MergeSheetType2		2/14/21
