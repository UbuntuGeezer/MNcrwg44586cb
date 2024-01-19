'// MyTest.bas
sub MyTest
dim oServiceManager as Object
'dim oServiceInfo AS New com.sun.star.lang.XServiceinfo
dim oFolderPicker as object
dim oServiceInfo AS Object
oServiceInfo = createUnoService("com.sun.star.lang.XServiceinfo")
oFolderPicker = createUnoService("com.sun.star.ui.dialogs.FolderPicker")
'xray oServiceInfo
xray oFolderPicker
oFolderPicker.setdisplaydirectory("")
oFolderPicker.execute
sDisplayDir = oFolderPicker.GetDisplayDirectory()
msgbox("sDisplayDir = '" & sDisplayDir & "'")
oServiceManager = GetProcessServiceManager()
  MsgBox oServiceManager.Dbg_SupportedInterfaces

end sub		'// end MyTest
'/**/
