'// SortAgain.bas
'//--------------------------------------------
'//	SortAgain - sort Import sheet on 2 columns
'//		9/24/20.	23:45
'//--------------------------------------------

public sub sortagain
rem ----------------------------------------------------------------------
rem define variables
dim document   as object
dim dispatcher as object
rem ----------------------------------------------------------------------
rem get access to the document
document   = ThisComponent.CurrentController.Frame
dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")

rem ----------------------------------------------------------------------
dim args1(11) as new com.sun.star.beans.PropertyValue
args1(0).Name = "ByRows"
args1(0).Value = true
args1(1).Name = "HasHeader"
args1(1).Value = false
args1(2).Name = "CaseSensitive"
args1(2).Value = false
args1(3).Name = "NaturalSort"
args1(3).Value = false
args1(4).Name = "IncludeAttribs"
args1(4).Value = true
args1(5).Name = "UserDefIndex"
args1(5).Value = 0
args1(6).Name = "Col1"
args1(6).Value = 6
args1(7).Name = "Ascending1"
args1(7).Value = true
args1(8).Name = "Col2"
args1(8).Value = 10
args1(9).Name = "Ascending2"
args1(9).Value = true
args1(10).Name = "IncludeComments"
args1(10).Value = false
args1(11).Name = "IncludeImages"
args1(11).Value = true

dispatcher.executeDispatch(document, ".uno:DataSort", "", 0, args1())


end sub		'// end SortAgain	9/24/20
