'// PickACell.bas
'//---------------------------------------------------------------
'// PickACell - Select any cell to bring sheet into focus.
'//		10/12/20.	wmk.	21:45
'//---------------------------------------------------------------

public sub PickACell()

'//	Usage.	macro call or
'//			call PickACell()
'//
'// Entry.	user in a spreadsheet with data in column "A", starting
'//			in cell $A$6
'//
'//	Exit.	cell $A$6 selected just to anchor Frame objects
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/12/20.	wmk.	original code

'// local variables.
dim oDocument   as object
dim oDispatcher as object

'//	code.
	ON ERROR GOTO ErrorHandler

	oDocument   = ThisComponent.CurrentController.Frame
	oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// move to cell $A$6
dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$A$6"

	oDispatcher.executeDispatch(oDocument, ".uno:GoToCell", "", 0, args1())


NormalExit:
	exit sub

ErrorHandler:
	msgbox("PickACell - unprocessed error")
	GoTo NormalExit
	
end sub		'// end PickACell	10/11/20
