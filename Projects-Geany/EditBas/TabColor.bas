'// TabColor.bas
'//---------------------------------------------------------------
'// TabColor - Change current worksheet tab color.
'//		10/15/20.	wmk.
'//---------------------------------------------------------------

public sub TabColor(plColor As long)

'//	Usage.	macro call or
'//			call TabColor()
'//
'// Entry.	user has worksheet selected
'//
'//	Exit.	worksheet tab color changed to passed color
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/15/20.		wmk.	original code; adapted from YellowTab
'//
'//	Notes.	color constants are store here; sheet CellColor.ods in
'//	Intermediate-csvs folder allows quick grab of color values


'//	constants.
const YELLOW=16776960			'// YELLOW color value
const DKLIME=620774				'// DARKLIME color value

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
args1(0).Value = plColor

dispatcher.executeDispatch(document, ".uno:SetTabBgColor", "", 0, args1())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("TabColor - unprocessed error")
	GoTo NormalExit
	
end sub		'// end TabColor	10/15/20
