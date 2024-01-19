'// WrapLong.bas - subroutine and function header template.
'//---------------------------------------------------------------
'// WrapLong - &lt;sub description&gt;.
'//		1/1/21.	wmk.
'//---------------------------------------------------------------

public sub WrapLong()

'//	Usage.	macro call or
'//			call WrapLong( &lt;parameters&gt; )
'//
'//		&lt;parameters description&gt;
'//
'// Entry.	&lt;entry conditions&gt;
'//
'//	Exit.	&lt;exit conditions&gt;
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	1/1/21.		wmk.	original code
'//
'//	Notes. &lt;Insert notes here&gt;
'//

'//	constants.

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
dispatcher.executeDispatch(document, ".uno:CommonAlignTop", "", 0, Array())

rem ----------------------------------------------------------------------
dim args2(0) as new com.sun.star.beans.PropertyValue
args2(0).Name = "WrapText"
args2(0).Value = true

dispatcher.executeDispatch(document, ".uno:WrapText", "", 0, args2())

	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("WrapLong - unprocessed error")
	GoTo NormalExit
	
end sub		'// end WrapLong
