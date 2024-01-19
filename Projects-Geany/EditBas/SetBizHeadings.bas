'// SetBizHeadings.bas
'//---------------------------------------------------------------
'// SetBizHeadings - Set Admin-Bridge sheet headings.
'//		9/25/21.	wmk.	21:47
'//---------------------------------------------------------------

public sub SetBizHeadings()

'//	Usage.	macro call or
'//			call SetBizHeadings()
'//
'// Entry.	user has Biz-Bridge sheet selected
'//
'//	Exit.	Column headings will be set as follows:
'//	"Company Name", "UnitAddress","Owner","Contact Phone","Biz Desc",
'// "OGender", "OTitle","Territory","DoNotCall","RecordDate","SunbizDoc",
'// "DelPending"
'//
'// Calls. SetColHeadings.
'//
'//	Modification history.
'//	---------------------
'// 9/25/21.	wmk.	adapted from SetBridgeHeadings; headings changed
'//						to match Biz Bridge records format
'// Legacy mods.
'//	9/21/20.	wmk.	original code
'// 9/23/20.	wmk.	"PropUse" heading added
'//	10/23/20.	wmk.	Column adjustments; "Unit" replaces Resident1,
'//						"Resident1" replaces Resident2
'// 11/22/20.	wmk.	"Phone2" changed to "H" for homestead
'//
'//	Notes.

'//	constants.

'//	local variables.
dim sColHeadings(11) As String		'// column headings array

	'// code.
	ON ERROR GOTO ErrorHandler
	sColHeadings(0) = "Company Name"	'// 2.18
	sColHeadings(1) = "UnitAddress"		'// 1.45
	sColHeadings(2) = "Owner"			'// 1.30
	sColHeadings(3) = "Contact Phone"	'// 1.17
	sColHeadings(4) = "Biz Desc"		'// 2.53
	sColHeadings(5) = "OGender"			'// 0.99
	sColHeadings(6) = "OTitle"			'// 0.99
	sColHeadings(7) = "Terr"			'// 0.45
	sColHeadings(8) = "DNC"				'// 0.50
	sColHeadings(9) = "RecordDate"		'// 0.79
	sColHeadings(10) = "SunBizDoc"		'// 0.85
	sColHeadings(11) = "Del"			'// 0.46
	SetColHeadings(sColHeadings)
	
NormalExit:
	exit sub
	
ErrorHandler:
	msgbox("SetBizHeadings - unprocessed error")
	GoTo NormalExit
	
end sub		'// end SetBizHeadings	9/25/21.	21:47
