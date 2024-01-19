#	<source> = file with block delimited by "procbodyhere" "endprocbody"
# procbodyhere.
mawk '/procbodyhere/,/endprocbody/{print}END {print "# endprocbody."}' $P1 > $P2
# endprocbody.
