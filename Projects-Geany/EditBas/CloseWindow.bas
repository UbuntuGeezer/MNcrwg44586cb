'// CloseWindow.bas
'//---------------------------------------------------------------
'// CloseWindow - Close current window.
'//		10/16/20.	wmk.
'//---------------------------------------------------------------

public sub CloseWindow()

'//	Usage.	macro call or
'//			call CloseWindow()
'//
'// Entry.	user in workbook wishes to be closed
'//
'//	Exit.	user reverts to next window as determined by UNO sequencing
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	10/16/20.		wmk.	original code
'//
'//	Notes.

'//	constants.

'//	local variables.

	'// code.
	ON ERROR GOTO ErrorHandler
	ThisComponent.close(true)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CloseWindow - unprocessed error")
	GoTo NormalExit
	
end sub		'// end CloseWindow		10/16/20
