'// AddUpdateMaster1.bas
sub AddUpdateMaster1
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(0) as new com.sun.star.beans.PropertyValue
args1(0).Name = "Name"
args1(0).Value = "UpdateMaster"

dispatcher.executeDispatch(document, ".uno:Add", "", 0, args1())


end sub		'// end AddUpdateMaster1
'/**/
