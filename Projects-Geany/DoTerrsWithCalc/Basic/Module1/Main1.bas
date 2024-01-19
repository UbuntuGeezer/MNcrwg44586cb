'// Main1.bas
'//---------------------------------------------------------------
'// Main1 - Run Main via function call.
'//		8/12/23.		wmk.	13:44
'//---------------------------------------------------------------
public function Main1() AS Void

'// Main1 - Run Main via function call.
'//
'// Usage.	Main1()
'//
'//	Entry.	ThisComponent.Sheets(0) contains territory list to process.
'// 		 it will either be "TerrList" or "autoload" (see Notes.)
'//
'//	Exit.	Main run with timestamps placed in sheet.
'//
'// Modification History.
'// ---------------------
'// 2/1/23.		wmk.	autoload support.
'// 8/12/23.	wmk.	edited for MNcrwg44586; csCodeBase module var
'//				 introduced.
'// Legacy mods.
'// 9/4/21.		wmk.	orignal code.
'// 11/11/21.	wmk.	timestamps added.
'//
'// Notes. ThisComponent.Sheet(0) is always a list of territories to process.
'// The original sheet was "TerrList". The code never knew the name of the
'// sheet.

'// constants.

const COL_STARTTIME = 6			'// timestamp columns, row
const COL_ENDTIME = 7
const ROW_TIME = 4

'// local variables.

dim oDoc		As Object	'// component
dim oSheet		As Object	'// sheet
dim oCellTime	As Object	'// timestamp cell

'// code.

	ON ERROR GOTO ErrorHandler
	oDoc = ThisComponent
	oSheet = oDoc.Sheets(0)

	'// record start time.
		oCellTime = oSheet.getCellByPosition(COL_STARTTIME,ROW_TIME)
		oCellTime.SetValue(NOW()) 
	Main()
	'// record end time.
		oCellTime = oSheet.getCellByPosition(COL_ENDTIME,ROW_TIME)
		oCellTime.SetValue(NOW()) 

NormalReturn:
	Exit Function
	
ErrorHandler:
	msgbox("Unprocessed error in Main1..")
	GOTO NormalReturn
		
end Function	'// end Main1	8/12/23.
'/**/
