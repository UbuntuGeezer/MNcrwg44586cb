#	<source> = file with block delimited by "procbodyhere" "endprocbody"
# procbodyhere.
awk '/procbodyhere/,/endprocbody/{print}' $P1 > $P2
