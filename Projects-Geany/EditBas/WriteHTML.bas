'// WriteHTML.bas - write HTML file with generated phone query.
'//---------------------------------------------------------------
'// WriteHTML - Write phone query to HTML file.
'//		8/10/20.	wmk. 21:00
'//---------------------------------------------------------------

public sub WriteHTML(psFilename As String, psURL As String)

'//	Usage.	call WriteHTML( sFilename, sURL )
'//
'//		sFileName = filename to write [.html suffix will be added]
'//		sURL = generated URL to write in HTML
'//
'// Entry.	&lt;entry conditions&gt;
'//
'// Exit. The following lines are written to the file &lt;sFileName&gt;.html
'//    &lt;!DOCTYPE html&gt; 
'//    &lt;html&gt; 
'//    &lt;head&gt; 
'//    	&lt;title&gt;Phone Query&lt;/title&gt; 
'//    	&lt;meta http-equiv="refresh"
'//   content="0;url=https://www.truepeoplesearch.com/details?streetaddress=500%20The Esplanade%20307&amp;citystatezip=Venice%2C%20FL&amp;rid=0x0" /&gt;
'//    &lt;/head&gt; 
'//    &lt;body&gt; 
'//    &lt;/body&gt; 
'//    &lt;/html&gt; 
'//
'// Calls.
'//
'//	Modification history.
'//	---------------------
'//	8/9/20.		wmk.	original code
'//	8/10/20.	wmk.	calling sequence modified to accept
'//						filename and url parameters
'//
'//	Notes. The path that the file is written to is cast as
'// an internally known path. Eventually, this should be
'// contained in either an environment variable or public
'// constant in a shared header. See the initial sPath assignment
'//	statement below.
'// See function sGenPhoneURL for documentation on the URL passed
'// in to be written to the .html file.

'//	constants.

'//	local variables.
dim sFileSpec	As String	'// filespec
dim sFile		As String	'// file
dim sURL		As String	'// URL to write
dim sPath		As String	'// file path
dim iHandle		As Integer	'// file handle
	'// code.
	ON ERROR GOTO ErrorHandler
	sPath = "/media/ubuntu/Windows/Users/Bill/Documents/Cong-Files/Territories/Queries-HTML/"
'	sFile = "FirstPhone.html"
	sFile = psFilename
	sURL = psURL
	sFileSpec = sPath + sFile + ".html"
	iHandle = Freefile		'// get free file handle
	Open sFileSpec For Output As #iHandle
	
	'// write HTML statements to file.
	Print #iHandle "&lt;!DOCTYPE html&gt;"
	Print #iHandle "&lt;html&gt;"
	Print #iHandle "&lt;head&gt;"
	Print #iHandle "&lt;title&gt;Phone Query&lt;/title&gt;"
	Print #iHandle "&lt;meta http-equiv=""refresh"""
'	Print #iHandle "content=""0;url=https://www.truepeoplesearch.com/details?streetaddress=500%20The Esplanade%20307&amp;citystatezip=Venice%2C%20FL&amp;rid=0x0"" /&gt;"
    sPageLink = "content=""0;url=" + sURL + """"
    Print #iHandle sPageLink
	Print #iHandle "&lt;/head&gt;"
	Print #iHandle "&lt;body&gt;"
	Print #iHandle "&lt;/body&gt;"
	Print #iHandle "&lt;/html&gt;"
	Close #iHandle
msgBox(" WriteHTML complete. - File = '" + sFile + "'")
  
NormalExit:
  exit Sub
  
ErrorHandler:
  msgBox(" WriteHTML - Unprocessed error.")
  GoTo NormalExit
  
end sub		'// end WriteHTML   8/10/20.
