'// RmvUpdateMaster1.bas
sub RmvUpdateMaster1
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dispatcher.executeDispatch(document, ".uno:Remove", "", 0, Array())


end sub		'// end RmvUpdateMaster1
'/**/
