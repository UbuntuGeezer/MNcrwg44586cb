'// Module1Hdr.bas
'//--------------------------------------------
'// Module1 - Module1 for ProcessQTerrs12.ods (MNcrwg44586).
'//		8/21/23.
'//--------------------------------------------
'//
'// Modification History.
'// ---------------------
'// 8/12/23.	wmk.	modified for use with MNcrwg44586.
'// 8/21/23.	wmk.	ensure <name>. bas and end of / ** / in place.
'// Legacy mods.
'// 10/30/22.	wmk.	mod to use fsGetUser to get *USER environment variable;
'//				 use code to replace path constants with module-wide string
'//				 variables; Main modified to set path strings; gbKillCycle
'//				 and gbKillAll module-wide flags added.
'// Legacy mods.
'// 11/11/21.	wmk.	original code.
'// 12/23/21.	wmk.	provide for multihost path differences; module-wide constants
'//				 csTerrBase, csTerrDataPath implemented.
'// 4/14/22.	wmk.	csfolderbase added; csTerrBase and csTerrDataPath modified
'//				 to use csfolderbase.
'// 5/3/22.		wmk.	csCongTerrPath set for /FL/SARA/86777.
'//
'// Notes. As of 8/12/23 this workbook is unique to the
'// TerritoriesCB/MNcrwg44586/Projects-Geany/DoTerrsWithCalc project. This code
'// is maintained under the \*Chromebook branch of the TerritoriesCB repository. 
'//
'// This workbook is dependent upon internal macros and macros in both the
'// MNcrwg44586 and Territories libraries. To ensure library integrity during
'// "export" operations, make certain that the *Libraries-Project* is on the
'// *Chromebook* branch before exporting or importing libraries. This will
'// guarantee that the Chromebook system does not import or export the library
'// version belonging to the original host (HP Pavilion) system.
'//
'// The Main macro is responsible for invoking the fsGetUser function and setting
'// the module-wide path variables corresponding to the Chromebook system.
'//

'// module-wide variables.
public gbKillCycle	As String	'// kill this territory cycle flag
public gbKillAll	As String	'// terminate processing flag
public gsUser		As String	'// *USER environment var

dim csfolderbase 	As String	'// = "/home/vncwmk3" OR "/media/ubuntu/Windows/Users/Bill"
dim csCongTerrPath	As String	'// = "/MN/CRWG/44586"
dim csTerrBase		As String	'// = csfolderbase & "/Territories" & csCongTerrPath
dim csCodeBase		As String	'// = csfolderbase & "/GitHub/TerritoriesCB/MNcrwg44586"
dim csURLBase		As String	'// = csTerrBase & "/TerrData/Terr"

'const csCongTerrPath = "/state/county/congno"
'#const csCongTerrPath = ""
dim csTerrDataPath	As String	'// = csTerrBase & "/TerrData"
dim csTrackingPath	As String	'// = csTerrBase & "/RawData/Tracking"
dim csProjPath		As String	'// = csTerrBase & "/Projects-Geany/DoTerrsWithCalc"

'// end Module1Hdr		8/12/23.
'/**/
