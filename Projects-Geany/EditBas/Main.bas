'// Main.bas
Sub Main
'// use as generic Territories libarary testing macro; invoke with ctrl-9

'// copy current sheet to end and unprotect.
CopyToEnd()
UnprotectSheet()

if true then
  GoTo EndRun
endif
dim sSitus	As String
dim sNumber	As String
dim sStreet	As String
dim sUnit	As String
dim sFile	As String
dim sURL	As String

GenHLinkM()
if true then
 GoTo EndRun
endif

sFile = "BIPhone3"
sSitus = "415 Andros"
sURL = sGenPhoneURL(sSitus, "Venice")
WriteHTML(sFile, sURL)     

sFile = "BIPhone4"
sSitus = "416 Andros"
sURL = sGenPhoneURL(sSitus, "Venice")
WriteHTML(sFile, sURL)     

sFile = "BIPhone5"
sSitus = "417 Andros"
sURL = sGenPhoneURL(sSitus, "Venice")
WriteHTML(sFile, sURL)     

sFile = "BIPhone6"
sSitus = "418 Andros"
sURL = sGenPhoneURL(sSitus, "Venice")
WriteHTML(sFile, sURL)     

sFile = "BIPhone7"
sSitus = "419 Andros"
sURL = sGenPhoneURL(sSitus, "Venice")
WriteHTML(sFile, sURL)     

sFile = "BIPhone8"
sSitus = "420 Andros"
sURL = sGenPhoneURL(sSitus, "Venice")
WriteHTML(sFile, sURL)     

sFile = "BIPhone9"
sSitus = "421 Andros"
sURL = sGenPhoneURL(sSitus, "Venice")
WriteHTML(sFile, sURL)     

sFile = "BIPhone10"
sSitus = "422 Andros"
sURL = sGenPhoneURL(sSitus, "Venice")
WriteHTML(sFile, sURL)     

EndRun:

End Sub	'// end Main
