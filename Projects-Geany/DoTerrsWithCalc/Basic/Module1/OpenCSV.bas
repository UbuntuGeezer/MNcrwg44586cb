'// OpenCSV.bas
sub OpenCSV
rem ----------------------------------------------------------------------
rem define variables
dim document   as object

'sFullTargPath = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr40/Working-Files/QTerr240.ods"
sFullTargPath = csTerrDataPath & "/Terr240/Working-Files/QTerr240.ods"
	TargetURL = convertToURL(sFullTargPath)
'    Empty() = Array()
'dim Args(1)	As new com.sun.star.beans.PropertyValue 
'   Args(1).name = "FilterName"
 '  Args(1).Value = "Text - txt - csv"
  ' Args(0).name = "Hidden"
   'Args(0).value = False
    'oTestDoc = StarDesktop.loadComponentFromURL(TargetURL, "_blank", 0, Args())

	TargetURL = convertToURL(sFullTargPath)
	document = ThisComponent.CurrentController.Frame
'    Empty() = Array()
dim Args(2)	As new com.sun.star.beans.PropertyValue 
   Args(0).name = "URL"
   Args(0).value = TargetURL
   Args(1).name = "FilterName"
   Args(1).Value = "calc8"
   Args(2).name = "Hidden"
   Args(2).value = False
'   oTestDoc = StarDesktop.loadComponentFromURL(TargetURL, "_blank", 0, Args())
dispatcher.executeDispatch(document,".uno:OpenFromCalc","",0,Args())
rem ----------------------------------------------------------------------
rem dispatcher.executeDispatch(document, ".uno:OpenFromCalc", "", 0, Array())


end sub		'// end OpenCSV
'/**/
