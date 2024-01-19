# preamble1.s/sh - preamble to *sed edit LastDwnldDate.psq > LastDwnldDate.sql.
#
# P1 = db-path
# P2 = db-name
# P3 = db-table
#
sed "s?<db-path>?$P1?g;s?<db-name>?$P2?g;s?<db-table>?$P3?g" \
 LastDwnldDate.psq > LastDwnldDate.sql
# end preamble1.sh
