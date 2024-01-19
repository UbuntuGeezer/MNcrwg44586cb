'// Format10zs.bas
'//-----------------------------------------------------------------------
'//	Format10zs - Set column NumberFormat to "0000000000".
'//		9/19/20.	wmk.
'//-----------------------------------------------------------------------

sub format10zs
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
args1(0).Name = "ToPoint"
args1(0).Value = "$A$8"

dispatcher.executeDispatch(document, ".uno:GoToCell", "", 0, args1())

rem ----------------------------------------------------------------------
dim args2(0) as new com.sun.star.beans.PropertyValue
args2(0).Name = "NumberFormatValue"
args2(0).Value = 121

dispatcher.executeDispatch(document, ".uno:NumberFormatValue", "", 0, args2())


end sub
