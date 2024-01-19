'// SetBridgeHeadings.bas
'//---------------------------------------------------------------
'// SetBridgeHeadings - Set Admin-Bridge sheet headings.
'//		11/22/20.	wmk.	07:30
'//---------------------------------------------------------------

public sub SetBridgeHeadings()

'//	Usage.	macro call or
'//			call SetBridgeHeadings()
'//
'// Entry.	user has Admin-Bridge sheet selected
'//
'//	Exit.	Column headings will be set as follows:
'//	"OwningParcel","UnitAddress","Resident1","Resident2","Phone1","Phone2",
'//	"RefUSA","SubTerritory","CongTerrID","DoNotCall","RSO","Foreign",
'// "RecordDate", "SitusAddress","PropUse","DelPending"
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/21/20.	wmk.	original code
'// 9/23/20.	wmk.	"PropUse" heading added
'//	10/23/20.	wmk.	Column adjustments; "Unit" replaces Resident1,
'//						"Resident1" replaces Resident2
'// 11/22/20.	wmk.	"Phone2" changed to "H" for homestead
'//
'//	Notes.

'//	constants.

'//	local variables.
dim sColHeadings(15) As String		'// column headings array

	'// code.
	ON ERROR GOTO ErrorHandler
	sColHeadings(0) = "OwningParcel"
	sColHeadings(1) = "UnitAddress"
	sColHeadings(2) = "Unit"
	sColHeadings(3) = "Resident1"
	sColHeadings(4) = "Phone1"
	sColHeadings(5) = "H"
	sColHeadings(6) = "RefUSA"
	sColHeadings(7) = "SubTerritory"
	sColHeadings(8) = "CongTerrID"
	sColHeadings(9) = "DoNotCall"
	sColHeadings(10) = "RSO"
	sColHeadings(11) = "Foreign"
	sColHeadings(12) = "RecordDate"
	sColHeadings(13) = "SitusAddress"
	sColHeadings(14) = "PropUse"
	sColHeadings(15) = "DelPending"
	SetColHeadings(sColHeadings)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetBridgeHeadings - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetBridgeHeadings	11/22/20
