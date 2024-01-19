'// CopyToPubTerr.bas - Copy current worksheet to end of Terrxxx_PubTerr.ods.
'//--------------------------------------------------------------------------
'// CopyToPubTerr.bas - Copy current worksheet to end of Terrxxx_PubTerr.ods.
'//		11/24/21.	wmk.	04:36
'//--------------------------------------------------------------------------

public sub CopyToPubTerr( psTerrID as String)

'//	Usage.	call CopyToPubTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open Terrxxx_PubTerr.ods
'//
'// Entry.	Territories/.../TerrData/Terrxxx/Terrxxx_PubTerr.ods
'//				contains territory records for territory xxx.
'//
'//	Exit.	Terrxxx_PubTerr.ods opened in new spreadsheet (visible)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/18/21.	wmk.	original code.
'// 11/24/21.	wmk.	use global csTerrBase.
'//

'//	constants.
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/"

'//	local variables.
dim oDoc			As Object	'// generic document object
dim sTerrID			As String	'// passed territory ID
dim sDocName 		as String	'// target document name

'// UNO variables.
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------

	'// code.
	ON ERROR GOTO ErrorHandler
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	sTerrID = psTerrID
	sDocName = "Terr" & sTerrID & "_PubTerr"

rem ----------------------------------------------------------------------
dim args1(2) as new com.sun.star.beans.PropertyValue
args1(0).Name = "DocName"
'args1(0).Value = "Untitled 1"
args1(0).Value = sDocName
args1(1).Name = "Index"
args1(1).Value = 32767
args1(2).Name = "Copy"
args1(2).Value = true

dispatcher.executeDispatch(document, ".uno:Move", "", 0, args1())

NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("CopyToPubTerr - unprocessed error")
	GoTo NormalExit


end sub		'// end CopyToPubTerr	11/24/21.	04:36
