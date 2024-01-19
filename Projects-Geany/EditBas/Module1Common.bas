'// Module1Common.bas
'//	3/8/22.	wmk.
'// Module-wide vars and constants.
'// See SearchToUntitled, SetCurrSheet (future), GetCurrSheet(future),
'//  SetPrevSheet (future), GetPrevSheet (future).
'// Modification History.
'// ---------------------
'// ??			wmk.	original code.
'// 7/10/21.	wmk.	goTerrODSdoc, goNewWorkdoc added.
'// 12/23/21.	wmk.	csTerrBase, csTerrDataPath added for multihost
'//				 support when base path changes.
'// 3/8/22.		wmk.	csCounty and csState constants added.

'//	constants.
'// Note. for county/state support set csCounty = "/<two-char county>"
'//                                set csState = "/<two-char state>"
'// if state is FL and county is SC, set both to empty strings.
'//
'const csTerrBase = "/media/ubuntu/Windows/Users/Bill/Territories/TerrData/"
const csTerrBase = "/home/vncwmk3"
const csCounty = ""
const csState = ""
const csTerrDataPath = "/home/vncwmk3/Territories"&csCounty&csState&"/TerrData"
const csBTerrDataPath = "/home/vncwmk3/Territories"&csCounty&csState&"/BTerrData"

'// variables.

public gbKillProcess	As Boolean	'// kill process flag
public gsNewSheet	As String		'// name of new sheet
public gsCurrSheet	As String		'// name of current sheet (future)
public gsPrevSheet	As String		'// name of last sheet (future)
public gsPubTerrSheet	As String	'// name of _PubTerr sheet
public gsSearchSheet	As String	'// name of _Search sheet
public goCurrDocument	As Object	'// current Document prior to SaveAs
public goTerrODSdoc		As Object	'// territory ODS workbook document
public goNewWorkdoc		As Object	'// new workbook document (CopyToNewWork)
