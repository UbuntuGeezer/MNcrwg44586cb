'// wmktest1.bas
sub wmktest1


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
oFolderPicker.setdisplaydirectory("file://" & csTerrDataPath)
oFolderPicker.execute
sDirectory = oFolderPicker.getDisplayDirectory()
msgbox("sDirectory = '" & sDirectory & "'")

end sub	'// wmktest1
'/**/
