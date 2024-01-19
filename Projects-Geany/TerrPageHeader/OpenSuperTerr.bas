'// OpenSuperTerr.bas
'//---------------------------------------------------------------
'// OpenSuperTerr - Open Terrxxx_PubTerr.ods for territory xxx.
'//		11/25/21.	wmk.	07:12
'//---------------------------------------------------------------

public sub OpenSuperTerr( psTerrID As String, poNewDoc AS Object )

'//	Usage.	call OpenSuperTerr( sTerrID )
'//
'//		sTerrID = territory ID for which to open Terrxxx_SuperTerr.xlsx
'//
'// Entry.	Territories/.../TerrData/Terrxxx/Terrxxx_SuperTerr.xlsx
'//
'//	Modification history.
'//	---------------------
'//	11/23/21.	wmk.	original code.
'// 11/24/21.	wmk.	use global csTerrBase; ReadOnly to prevent loss
'//						of Search sheet on copy.
'// 11/25/21.	wmk.	remove ReadOnly as sheet loss was different issue;
'//						cannot move/copy from ReadOnly sheet.
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
dim sBasePath		As String	'// target base folder
dim sTargPath		As String	'// target access path
dim sTargFile		As string	'// target filename to open
dim sTerrID			As String	'// local territory ID
dim sFullTargPath	As String	'// full target path
dim sTargetURL		As String	'// target URL
dim oTestDoc		As Object	'// document object
dim oTestDoc2		As Object	'// super territory
	'// code.
	ON ERROR GOTO ErrorHandler
	oTestDoc = ThisComponent

if 0 = 1 then
xray oTestDoc
endif

'// use loadComponent to load super territory as workbook object.
	sTerrID = psTerrID
	sBasePath = "Terr"
	sTargPath = sBasePath & sTerrID

'// open Terrxxx_PubTerr.ods
    sFullTargPath = csTerrBase & sBasePath & sTerrID & "/"_ 
		& sBasePath & sTerrID & "_SuperTerr.xlsx"

dim Args2(1) 	As new com.sun.star.beans.PropertyValue 
	sTargetURL = convertToURL(sFullTargPath)
   Args2(1).name = "FilterName"
   Args2(1).Value = "Calc MS Excel 2007 XML"
   Args2(0).name = "Hidden"
   Args2(0).value = False
    oTestDoc2 = StarDesktop.loadComponentFromURL(sTargetURL, "_blank", 0, Args2())
    poNewDoc = oTestDoc2

'XRay oTestDoc2

if 1 = 1 then
	GoTo NormalExit
endif

'// at this point, focus is on oTestDoc2; preserve as goTerrODSDoc so
'// can be picked up by MoveTo
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("OpenSuperTerr - unprocessed error")
	GoTo NormalExit

end sub		'// end OpenSuperTerr	11/25/21. 07:13
