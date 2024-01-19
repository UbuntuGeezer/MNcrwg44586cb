#!/bin/bash
# DoSed.sh - Run *sed* to create BuildStreetNames.sql (and MakeBuildStreetNames).
#	12/19/22.	wmk.
P1=$1		# territory ID
sed "s?xxx?$P1?g" BuildStreetNames.psq > BuildStreetNames.sql
sed "s?xxx?$P1?g" MakeBuildStreetNames.tmp > MakeBuildStreetNames
# end DoSed.sh
