'// SaveXlsx.bas
'//---------------------------------------------------------------
'// SaveXlsx - Save .ods file as .xlsx.
'//		12/23/21.	wmk.	23:13
'//---------------------------------------------------------------

public sub SaveXlsx()

'//	Usage.	macro call or
'//			call SaveXlsx
'//
'//		psSourceName = source filename to save (e.g. 'Terr241_PubTerr.ods')
'//
'// Entry.	Current Sheet name contains Terr id as chars 5-8
'//
'//	Exit.	Current Sheet saved as .xls in folder ~TerrData/Terrxxx
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	7/2/20.		wmk.	original code.
'// 7/12/21.	WMK.	time stamp comments added.
'// 12/23/21.	wmk.	modified to use csTerrBase, csTerrDataPath module-wide
'//				 constants for multihost support.
'//
'//	Notes. &lt;Insert notes here&gt;
'//

'//	constants.
'const csTerrBase = "defined above"
'const csTerrDataPath = "defined above"

'//	local variables.
dim oDoc		As Object	'// current document
dim sFile		As String	'// file path value to pass to SaveAs
dim sTerrID		As String	'// territory ID to plug in file path
dim sTitle		As String	'// sheet title

rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------

	'// code.
	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	sTitle = oDoc.getTitle()
	sTerrID = mid(sTitle,5,3)
	
	sFile = "file://" &amp; csTerrDataPath
	sFile = sFile &amp; "/Terr" + sTerrID + "/" + "Terr" + sTerrID + "_PubTerr.xlsx"
	
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
rem dispatcher.executeDispatch(document, ".uno:OpenFromCalc", "", 0, Array())

rem ----------------------------------------------------------------------
dim args2(1) as new com.sun.star.beans.PropertyValue
args2(0).Name = "URL"
'// args2(0).Value = "file:///media/ubuntu/Windows/Users/Bill/Territories" _
'//   || "/TerrData/Terr241/Terr241_PubTerr.xlsx"
args2(0).Value = sFile
args2(1).Name = "FilterName"
args2(1).Value = "Calc MS Excel 2007 XML"

dispatcher.executeDispatch(document, ".uno:SaveAs", "", 0, args2())

if 0 = 1 then
msgbox("Terr" + sTerrID + "_PubTerr.xlsx created successfully",0,"SaveXlsx")
endif

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SaveXlsx - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SaveXlsx	12/23/21.	23:13
