'// OpenBizTerr.bas
'//---------------------------------------------------------------
'// OpenBizTerr - Open Terrxxx_PubTerr.ods for territory xxx.
'//		5/12/22.	wmk.	17:44
'//---------------------------------------------------------------

public sub OpenBizTerr( psTerrID As String, poNewDoc AS Object )

'//	Usage.	call OpenBizTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open Terrxxx_PubTerr.ods
'//
'// Entry.	Territories/.../BTerrData/Terrxxx/Terrxxx_PubTerr.ods
'//				contains territory records for territory xxx.
'//
'//	Exit.	Terrxxx_PubTerr.ods opened in new spreadsheet (visible)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	11/18/21.	wmk.	original code.
'// 11/24/21.	wmk.	use global csTerrBase
'//
'//	Notes. Once the user has opened the spreadsheet, the user should
'// be able to run all the Territories macros and process the territory.
'// This sub bypasses the step of opening PubTerrxxx.csv, but proves the
'// concept that by using uno:loadComponentFromURL, one can load additional
'// sheets for processing, then close them at will..
'//

'//	constants.
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/"

'//	local variables.
dim oDoc			As Object	'// generic document object
dim sBaseName		As string	'// target base filename
dim sBasePath		As String	'// target base folder
dim sTargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As String	'// target URL
dim oTestDoc		As Object	'// document object

	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent

if 0 = 1 then
xray oTestDoc
endif

	sTerrID = psTerrID
	sBaseName = "PubTerr"
	sBasePath = "Terr"
	sTargPath = sBasePath & sTerrID

'// open Terrxxx_PubTerr.ods
    sFullTargPath = csBTerrDataPath & "/" & sBasePath & sTerrID & "/"_ 
		& sBasePath & sTerrID & "_PubTerr.ods"
dim oTestDoc2	as Object
	oTestDoc2 = ThisComponent
dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
   Args2(1).name = "FilterName"
   Args2(1).Value = "calc8"
   Args2(0).name = "Hidden"
   Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())
dim oThisFrame as Object
dim oThisFrame2 as Object    
	oThisFrame = ThisComponent.CurrentController.Frame
    poNewDoc = oTestDoc2
    oThisFrame2 = oTestDoc2.CurrentController.Frame
    

'XRay oTestDoc2

'// at this point, focus is on oTestDoc2; preserve as goTerrODSDoc so
'// can be picked up by MoveTo
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("OpenBizTerr - unprocessed error")
	GoTo NormalExit

end sub		'// end OpenBizTerr		5/12/22.
'/**/
