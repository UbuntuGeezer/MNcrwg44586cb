'// KillAutoRecalc.bas
'//---------------------------------------------------------------
'// KillAutoRecalc - Turn off autorecalc.
'//		8/28/20.	wmk.
'//---------------------------------------------------------------

public sub KillAutoRecalc ()

'//	Usage.	macro call or
'//			call KillAutoRecalc( &lt;parameters&gt; )
'//
'//		&lt;parameters description&gt;
'//
'// Entry.	user has open spreadhseet
'//
'//	Exit.	AutoCalc turned off
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	8/28/20.		wmk.	original code
'//
'//	Notes. Autocalc is turned off to avoid hanging LibreCalc when
'//	moving through large amounts of records that have many calculated
'// fields (e.g. territory with 4 hyperlinks per record and thousands
'// of records.
'//

'//	constants.

'//	local variables.
dim document   as object
dim dispatcher as object

	'// code.
	document   = ThisComponent.CurrentController.Frame
	dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

	'// set arguments for AutomaticCalculation property control
	dim args1(0) as new com.sun.star.beans.PropertyValue
	args1(0).Name = "AutomaticCalculation"
	args1(0).Value = false

	dispatcher.executeDispatch(document, ".uno:AutomaticCalculation", _
								"", 0, args1())


end sub		'// end KillAutoRecalc		8/28/20
