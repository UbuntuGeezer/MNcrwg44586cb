'// YellowTab.bas
'//---------------------------------------------------------------
'// YellowTab - Change current worksheet tab color to Yello.
'//		10/12/20.	wmk.
'//---------------------------------------------------------------

public sub YellowTab()

'//	Usage.	macro call or
'//			call YellowTab()
'//
'// Entry.	user has worksheet selected
'//
'//	Exit.	worksheet tab color changed to YELLOW
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/2/20.		wmk.	original code; cloned from macro recording
'//
'//	Notes.
'//

'//	constants.
const YELLOW=16776960			'// YELLOW color value

'//	local variables.
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object

	'// code.
	ON ERROR GOTO ErrorHandler
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "TabBgColor"
args1(0).Value = YELLOW

dispatcher.executeDispatch(document, ".uno:SetTabBgColor", "", 0, args1())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("YellowTab - unprocessed error")
	GoTo NormalExit
	
end sub		'// end YellowTab	10/12/20
