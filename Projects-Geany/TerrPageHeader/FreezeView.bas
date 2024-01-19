'// FreezeView.bas
'//---------------------------------------------------------------
'// FreezeView - Freeze rows A1..A5 to keep headings in place.
'//		8/28/20.	wmk.
'//---------------------------------------------------------------

public sub FreezeView()

'//	Usage.	macro call or
'//			call FreezeView()
'//
'// Entry.	user has active sheet
'//
'//	Exit.	active sheet has Freeze Rows and Columns starting at $A$6
'//			so headings remain when scrolling
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	8/28/20.		wmk.	original code
'//
'//	Notes. Coded by recording macro to do same.

'//	constants.

'//	local variables.
dim document   as object
dim dispatcher as object

	'// code.
	'// get access to the document
	document   = ThisComponent.CurrentController.Frame
	dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// set up arguments for uno:GoToCell interface
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "ToPoint"
	args1(0).Value = "$A$6"

	dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args1())

	'// Freeze panes at row/column $A$6
	dispatcher.executeDispatch(document, ".uno:FreezePanes", "", 0, Array())

end sub		'// end FreezeView		8/28/20
'/**/
