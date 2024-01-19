'// ParseUnit.bas - Parse bridge table unit field.
'//---------------------------------------------------------------
'// ParseUnit - Parse bridge table unit field.
'//		2/9/21.	wmk.
'//---------------------------------------------------------------

public sub ParseUnit( psUnitStr As String, psSCUnit As String,_
			psBldUnit As String, psBldg As String, psBldNum As String )

'//	Usage.	macro call or
'//			call ParseUnit(sUnitStr, sSCUnit, sBldUnit, sBldg, sBldNum)
'//
'//		sUnitStr = full unit string, likely from SC data
'//					&lt;unit-string&gt; ::= NULL | &lt;unit-spec&gt;
'//					&lt;unit-spec&gt; ::= &lt;unit&gt; | &lt;unit&gt; &lt;unit-suffx&gt;
'//					&lt;unit&gt; ::= &lt;n&gt;[&lt;n&gt;*] | &lt;a&gt; | &lt;a&gt;-&lt;n&gt;[&lt;n&gt;*]
'//						| &lt;n&gt;[&lt;n&gt;*]/&lt;a&gt;[&lt;a&gt;*]
'//					&lt;unit-sufx&gt; ::= &lt;bldg&gt; | BLD &lt;bldg&gt;
'//
'// Entry,
'//
'//	Exit.	sSCUnit = SC unit extracted from &lt;exit conditions&gt;
'//
'// Calls. Crack
'//
'//	Modification history.
'//	---------------------
'// 2/9/21.		wmk.	original code
'//
'// Method. Crack up to 3 fields, space-separated
'//			Crack field1 for "/"
'//				if present, cracked portion is SCUnit, remaining is BldUnit
'//				otherwise is SCUnit and BldUnit is empty
'//			sBldg is returned (field2) "BLD" or similar string
'//			sBldNum is returned (field3)
'//
'//	Notes. For all UnitStr fields, space is the only recognized delimiter.
'// The SC data has NO STANDARDS, so this is at best guesswork. ParseUnit
'// will parse at most 3 fields, assuming the first to be the unit and
'// any subsequent fields "BLD" or "BLDG" followed by a building designator.
'//

'//	constants.

'//	local variables.
'psUnitStr - passed full unit string
'psSCUnit - [returned] SC unit from string nnn/a
'psBldUnit - [returned] building physical unit from string nnn/a
'psBldg - [returned] "BLD" or "BLDG" or ""
'psBldNum - [returned] building number field
dim sUnitStr	As String	'// copy of passed full unit string for parsing
dim sSCUnit		As String	'// returned SC unit
dim sBldUnit	As String	'// returned physical unit
dim sBldg		AS String	'// returned BLD or similar string
dim sBldNum		As String	'// returned building number field

	'// code.
	ON ERROR GOTO ErrorHandler

	'// initialize returned string vars.
	sScUnit = ""
	sBldUnit = ""
	sBldg = ""
	sBldNum = ""
	sUnitStr = trim(psUnitStr)
	if len(sUnitStr) = 0 then
	   goto NormalExit
	endif

dim sField1		As String	'// 1st cracked field
dim sField2		As String	'// 2nd cracked field
dim sField3		As String	'// 3rd cracked field
dim sSep		As String	'// Crack found separator
	
	'// Crack up to 3 fields on space.
	sUnitStr = trim(psUnitStr)
	sField1 = ""
	sField2 = ""
	sField3 = ""
	Crack(sUnitStr, " ", sField1, sSep)
	if len(sSep) &gt; 0 then
	   Crack(sUnitStr, " ", sField2, sSep)
	   sField3 = sUnitStr
	endif
	
	Crack(sField1, "/", sSCUnit, sSep)
	sBldUnit = sField1
	
NormalExit:
'psSCUnit - [returned] SC unit from string nnn/a
'psBldUnit - [returned] building physical unit from string nnn/a
'psBldg - [returned] "BLD" or "BLDG" or ""
'psBldNum - [returned] building number field
	psSCUnit = sSCUnit
	psBldUnit = sBldUnit
	psBldg = sBldg
	psBldNum = sBldNum
	exit sub
	
ErrorHandler:
	msgbox("ParseUnit - unprocessed error")
	GoTo NormalExit
	
end sub		'// end ParseUnit	2/9/21.
