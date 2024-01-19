README - Experiments-Make project documentation.<br>
5/12.	wmk.
###Modification History.
<pre><code>5/12/23.    wmk.   original document.
</code></pre>
<h3 id="IX">Documentation Sections.</h3>
<pre><code><a href="#1.0">link</a> 1.0 Project Description - overall project description.
<a href="#2.0">link</a> 2.0 Dependencies - project dependencies.
<a href="#3.0">link</a> 3.0 Project Build - step-by-step build instructions.
<a href="#4.0">link</a> 4.0 Significant Notes - important stuff not documented elsewhere.
</code></pre>
<h3 id="1.0">1.0 Project Description.</h3>
Experiments-Make is a sandbox for playing with \*make utility options and
error processing. Discoveries here may be incorporated into "production" \*make
recipes and makefiles
<br><a href="#IX">Index</a>
<h3 id="2.0">2.0 Dependencies.</h3>
<h3 id="3.0">3.0 Project Build.</h3>
<h3 id="4.0">4.0 Significant Notes.</h3>
PPidTOsh.sh is a shell that gets the process ID of the running shell, along
with the information about the parent process ID. The intent is to incorporate
this sequence into the error handling for any shell that invokes \*make so
that there is "traceback" information through the \*make sequence. This traceback
information is on file \*TEMP_PATH/BuildLog.txt.

By incorporating this code into shells that invoke \*make, \*make may be run
in --silent mode, eliminating the overwhelming volume of messages from a complex
\*make process.

<br>**trap.**<br>
\*trap is a \*bash provision for defining and activating handlers when the shell
recieves signals or other conditions. The signal specifiers recognized by \*trap
are EXIT (0), ERR, DEBUG and RETURN. The command line parameters following the
options are pairs of < ARG > < SIGNAL > where ARG is a command to be read and
executed whenever the shell receives the specified SIGNAL. 

DEBUG<br>
The ARG command will be executed prior to each command encountered by \*bash. If
the command is a compound command (such as IF or CASE) only the first command
will be set as the \*previous\_command. A good use of DEBUG is for error handling
in scripts like \*make sequences, where some additional traceback information
might be useful in resolving a \*make failure.

Example: trap 'previous\_command=$current\_command;current\_command=$BASH\_COMMAND' DEBUG
<pre><code>
	the two statements previous\_command= and current\_command= will both be
	 executed before bash processes the current\_command
	
	anywhere in the command sequence that follows, the command sequence:
	 cmd=$previous\_command ret=$?
	 if [ $ret -ne 0 ];then echo "$cmd FAILED with error $ret";fi
	 will either issue the message, or not, depencding on how \*previous\_command
	 terminated
</code></pre>

ERR<br>
The ARG command will be executed following any command that would cause the
shell to exit with the -e option. (This is regardless of whether the \*bash
-e option is included in the shell invocation). This allows the user to
perform any cleanup before advancing to the next shell command or exiting
(-e option included).

Example: trap 'echo "error trapped.. errcode = $?"' ERR
<pre><code>
	the "echo" statement will be executed whenever an error is encountered
	 in the shell; if the shell was called without the \*bash -e option,
	 the shell will continue excution, otherwise the shell will exit following
	 processing of the "echo" command
</code></pre>
<br><a href="#IX">Index</a>
