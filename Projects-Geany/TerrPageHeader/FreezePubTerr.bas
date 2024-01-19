'// FreezePubTerr.bas
'//---------------------------------------------------------------
'// FreezePubTerr - Open Terrxxx_PubTerr.ods for territory xxx.
'//		6/14/22.	wmk.	00:25
'//---------------------------------------------------------------

public sub FreezePubTerr( psTerrID As String, poNewDoc AS Object )

'//	Usage.	call FreezePubTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open Terrxxx_PubTerr.xlsx
'//
'// Entry.	Territories/.../TerrData/Terrxxx/Terrxxx_PubTerr.xlsx
'//				contains territory records for territory xxx.
'//
'//	Exit.	Terrxxx_PubTerr.ods opened in new spreadsheet (visible)
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'// 6/13/22.	wmk.	changed from OpenPubTerr; change to open .xlsx file;
'//				 FilterName = 'Calc MS Excel 2007 365'
'// Legacy mods.
'//	11/18/21.	wmk.	original code.
'// 11/24/21.	wmk.	use global csTerrBase.
'// 12/24/21.	wmk.	change to use csTerrDataPath for multihost.
'//
'//	Notes. Once the user has opened the spreadsheet, the user should
'// be able to run all the Territories macros and process the territory.
'// This sub bypasses the step of opening PubTerrxxx.csv, but proves the
'// concept that by using uno:loadComponentFromURL, one can load additional
'// sheets for processing, then close them at will..
'//

'//	constants.
'const csTerrBase = "defined above"
'const csTerrDataPath = "defined above"

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
	sBasePath = "/Terr"
	sTargPath = sBasePath & sTerrID

'// open Terrxxx_PubTerr.ods
    sFullTargPath = csTerrDataPath & sBasePath & sTerrID _ 
		& sBasePath & sTerrID & "_PubTerr.xlsx"
dim oTestDoc2	as Object
'	oTestDoc2 = ThisComponent
dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
   Args2(1).name = "FilterName"
'   Args2(1).Value = "calc8"
   Args2(1).Value = "Calc MS Excel 2007 365"
   Args2(0).name = "Hidden"
   Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())
dim oThisFrame as Object
dim oThisFrame2 as Object    
'	oThisFrame = ThisComponent.CurrentController.Frame
	oThisFrame = oTestDoc2.CurrentController.Frame

'// Freeze rows and columns on PubTerr.xlsx.
	FreezeFrame(oThisFrame)
	
    poNewDoc = oTestDoc2
    oThisFrame2 = oTestDoc2.CurrentController.Frame
    

'XRay oTestDoc2

if 1 = 1 then
	GoTo NormalExit
endif

'// at this point, focus is on oTestDoc2; preserve as goTerrODSDoc so
'// can be picked up by MoveTo
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("FreezePubTerr - unprocessed error")
	GoTo NormalExit

end sub		'// end FreezePubTerr	6/13/21.
'/**/
