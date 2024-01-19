'// SaveDiffoDS.bas
sub SaveDiffODS
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(1) as new com.sun.star.beans.PropertyValue
args1(0).Name = "URL"
'args1(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Territories/Projects-Geany/DoTerrsWithCalc/ProcessQTerrs12.ods"
args1(0).Value = "file://" & csProjPath & "/ProcessQTerrs12.ods"
args1(1).Name = "FilterName"
args1(1).Value = "calc8"

dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, args1())


end sub		'// end SaveDifODS		10/30/22.
'/**/
