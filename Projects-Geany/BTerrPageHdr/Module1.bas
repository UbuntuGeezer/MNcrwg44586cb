'// Module1.bas
'//---------------------------------------------------------------
'// Module1 - AddBizTerrHdr support module 1.
'//		5/12/22.	wmk.	17:52
'//---------------------------------------------------------------
'//
'// Module1 Description.
'// -------------------
'//	Module 1 supplies global constants and variables for AddBizTerrHdr.ods.
'// As with all LibreOffice Basic, the global variables are only static
'// while the execution remains within the module. Any transfer of control
'// outside of the module will likely cause the release of the global
'// vars.
'//
'// Modification History.
'// ---------------------
'// 5/12/22.	wmk.	original code; adapted from AddPubTerrHdr code;
'//				 csBTerrDataPath added to constants; gbKillProcess added
'//				 for future *kill* on error handling code.

'// global constants.
'//
'// public constants.
'const csStateCountyCong = ""					'// empty or has leading /
const csStateCountyCong = "/FL/SARA/86777" 
const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories" & csStateCountyCong
'const csTerrBase = "/home/vncwmk3/Territories"
const csTerrDataPath = "/media/ubuntu/Windows/Users/Bill/Territories" & csStateCountyCong &"/TerrData"
'const csTerrDataPath = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData"
const csBTerrDataPath = "/media/ubuntu/Windows/Users/Bill/Territories" & csStateCountyCong &"/BTerrData"
'const csBTerrDataPath = "/media/ubuntu/Windows/Users/Bill/Territories/BTerrData"
const csURLBase = "file:///media/ubuntu/Windows/Users/Bill/Territories" & csStateCountyCong & "/TerrData/Terr"
'const csURLBase = "file:///home/vncwmk3/Territories" & csStateCountyCong & "/TerrData/Terr"
const csProjBase = "/media/ubuntu/Windows/Users/Bill/Territories" & csStateCountyCong & "/Projects-Geany/BTerrPageHdr/"
'const csProjBase = "/home/vncwmk3/Territories" & csStateCountyCong & "/Projects-Geany/BTerrPageHdr"
const csProjPath = "/media/ubuntu/Windows/Users/Bill/Territories" & csStateCountyCong & "/Projects-Geany/BTerrPageHdr"
'const csProjPath = "/home/vncwmk3/Territories" & csStateCountyCong & "/Projects-Geany/BTerrPageHdr"

'// global variables.
public gbKillProcess	As Boolean	'// kill process flag
public gsTerrID		As String	'// territory ID

'// public variables.
'//
'//***** end Module1 header		5/12/22.   17:52
'/**/
