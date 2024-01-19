'// test.bas
sub test

Dim FileNo As Integer
Dim CurrentLine As String
dim x,y,z as integer
dim s as object
dim oFolderPicker as object
dim NextFile as string
dim url as string
dim newworkbook as object
Dim Args(2) As new com.sun.star.beans.PropertyValue
dim sExport as string
dim oExport as object

oFolderPicker = createUnoService("com.sun.star.ui.dialogs.FolderPicker")
oFolderPicker.setdisplaydirectory("c:\")
oFolderPicker.execute

NextFile = dir(oFolderPicker.getdirectory & "/*.txt",0)

x = 0
y = 0
while NextFile <> ""

   x = x + 1
   NextFile = Dir
   
wend
   
NextFile = dir(oFolderPicker.getdirectory & "/*.txt",0)
   
while NextFile <> ""
   com.sun.star.beans.PropertyValue
   y = y +1
   
   thiscomponent.currentcontroller.statusindicator.start "Loading " & y &  " of the total " & x & " files ......",0
   
   url = oFolderPicker.getdirectory & "/" & left(NextFile,len(NextFile)-3) & "ods"
   
   MkDir oFolderPicker.getdirectory & "/Temporary/"
   
   FileCopy oFolderPicker.getdirectory & "/" & NextFile, oFolderPicker.getdirectory & "/Temporary/" & left(NextFile,len(NextFile)-3) & "csv"
   
   sExport = ConvertToURL(oFolderPicker.getdirectory & "/Temporary/" & left(NextFile,len(NextFile)-3) & "csv")
   
   Args(1).name = "FilterName"
   Args(1).Value = "Text - txt - csv (StarCalc)"
   Args(2).name = "FilterOptions"
   Args(2).Value = "9,0,76,1,1/2/2/2/3/2/4/2/5/2/6/2/7/2/8/2/9/2/10/2/11/2/12/2/13/2/14/2/15/2/16/2/17/2/18/2/19/2/20/2/21/2/22/2/23/2/24/2/25/2/26/2/27/2/28/2/29/2/30/2/31/2/32/2/33/2/34/2/35/2/36/2/37/2/38/2/39/2/40/2/41/2/42/2/43/2/44/2/45/2/46/2/47/2/48/2/49/2/50/2"
   Args(0).name = "Hidden"
   Args(0).value = True

   oExport = StarDesktop.loadComponentFromURL(sExport, "_blank", 0, Args())
   
   oExport.sheets(0).getcellrangebyposition(0,0,256,0).columns.OptimalWidth = true
   
   Args(0).Name = "CharacterSet"
    Args(0).Value = "UTF-8"
   
   oExport.storeasurl(url,Array())
                                                                                                                                                                                                                                                                                                                                  
   oExport.close(true)
   
   NextFile = Dir
   
wend

RmDir oFolderPicker.getdirectory & "/Temporary/"

thiscomponent.currentcontroller.statusindicator.Reset

msgbox "complete"

end sub		'// end test
'/**/
