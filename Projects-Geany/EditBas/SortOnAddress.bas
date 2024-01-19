'// SortOnAddress.bas
'//---------------------------------------------------------------
'// SortOnAddress - Sort RefUSA Import sheet on FullAddress field.
'//		9/3/20.	wmk.	20:45
'//---------------------------------------------------------------

public sub SortOnAddress()

'//	Usage.	macro call or
'//			call SortOnAddress()
'//
'// Entry.	user has selected row(s) of import data which is to be
'//			sorted in ascending order by FullAddress column
'//
'//	Exit.	selected rows sorted
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	9/3/20.	wmk.	original code
'//
'//	Notes.

'//	constants.
const COL_FULLADDR=9		'// full concatenated address

'//	local variables.

dim oDocument   as object
dim oDispatcher as object

'// code.
	ON ERROR GOTO ErrorHandler
oDocument   = ThisComponent.CurrentController.Frame
oDispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// set up for Sort call to sort all entries by address
	rem ----------------------------------------------------------------------
dim args55(9) as new com.sun.star.beans.PropertyValue
	args55(0).Name = "ByRows"
	args55(0).Value = true
	args55(1).Name = "HasHeader"
	args55(1).Value = false
	args55(2).Name = "CaseSensitive"
	args55(2).Value = false
	args55(3).Name = "NaturalSort"
'	args55(3).Value = false
	args55(3).Value = true				'// set true so 1,11,15 do not appear together
	args55(4).Name = "IncludeAttribs"
	args55(4).Value = true
	args55(5).Name = "UserDefIndex"
	args55(5).Value = 0
	args55(6).Name = "Col1"
	args55(6).Value = COL_FULLADDR + 1		'// plus 1 for $J..
	args55(7).Name = "Ascending1"
	args55(7).Value = true
	args55(8).Name = "IncludeComments"
	args55(8).Value = false
	args55(9).Name = "IncludeImages"
	args55(9).Value = true

	oDispatcher.executeDispatch(oDocument, ".uno:DataSort", "", 0, args55())

NormalExit:
	msgbox("SortOnAddress complete. ")
	exit sub
	
ErrorHandler:	
	msgbox("SortOnAddress - unprocessed error.")
	GoTo NormalExit

end sub		'// end SortOnAddress	9/3/20
