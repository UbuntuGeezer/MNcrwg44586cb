'// DkLimeTab.bas
'//---------------------------------------------------------------
'// DkLimeTab - Change current worksheet tab color to DkLime.
'//		2/12/21.	wmk.	17:45
'//---------------------------------------------------------------

public sub DkLimeTab()

'//	Usage.	macro call or
'//			call DkLimeTab()
'//
'// Entry.	user has worksheet selected
'//
'//	Exit.	worksheet tab color changed to YELLOW
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	2/6/20.		wmk.	original code; cloned from YellowTab
'// 2/12/21.	wmk.	DKLIME const corrected
'//
'//	Notes.
'//

'//	constants.
const YELLOW=16776960			'// YELLOW color value
const DKLIME=6207774			'// DK LIME color value

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
args1(0).Value = DKLIME

dispatcher.executeDispatch(document, ".uno:SetTabBgColor", "", 0, args1())
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("DkLimeTab - unprocessed error")
	GoTo NormalExit
	
end sub		'// end DkLimeTab	2/12/21
