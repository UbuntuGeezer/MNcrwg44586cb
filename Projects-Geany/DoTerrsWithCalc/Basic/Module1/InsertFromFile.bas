'// InsertFromFile.bas
sub InsertFromFile
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
rem dispatcher.executeDispatch(document, ".uno:InsertSheetFromFile", "", 0, Array())


end sub		'// end InsertFromFile
'/**/
