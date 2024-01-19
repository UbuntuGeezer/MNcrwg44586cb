'// OpenDiffFile.bas
sub OpenDiffFile
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
dim oExport		As	Object
dim Args(1)		As new com.sun.star.beans.PropertyValue


rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
xray Args
rem ----------------------------------------------------------------------
rem dispatcher.executeDispatch(document, ".uno:OpenFromCalc", "", 0, Array())
'sTargetURL = "file:///media/ubuntu/Windows/Users/Bill/Territories/TerrData/Terr241"_
'   & "/Working-Files/NewTerr241Hdr.csv"
sTargetURL = "file://" & csTerrDataPath & "/Terr241"_
   & "/Working-Files/NewTerr241Hdr.csv"
'   Args(3).name = "Separated By"
'  Args(3).Value = "|"
   Args(1).name = "FilterName"
   Args(1).Value = "Text - txt - csv"
'   Args(2).name = "FilterOptions"
'   Args(2).Value = "9,0,76,1,1/2/2/2/3/2/4/2/5/2/6/2/7/2/8/2/9/2/10/2/11/2/12/2/13/2/14/2/15/2/16/2/17/2/18/2/19/2/20/2/21/2/22/2/23/2/24/2/25/2/26/2/27/2/28/2/29/2/30/2/31/2/32/2/33/2/34/2/35/2/36/2/37/2/38/2/39/2/40/2/41/2/42/2/43/2/44/2/45/2/46/2/47/2/48/2/49/2/50/2"
'   Args(2).Value = "comma-delimited"
   Args(0).name = "Hidden"
   Args(0).value = False

   oExport = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args())
' xray oExport 
' dim Args2()
' Args2=oExport.getArgs()
' dbug = 1 
dispatcher.executeDispatch(document,".unoOpenFromCalc",sTargetURL,0,Array())

end sub		'// end OpenDiffFile
'/**/
