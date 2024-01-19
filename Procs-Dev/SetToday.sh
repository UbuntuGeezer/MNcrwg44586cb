#!/bin/bash
# SetToday.sh - 9/3/23. Set TODAY environment var.
date +%Y-%m-%d|mawk 'BEGIN {print "#!/bin/bash"}{print "export TODAY=" $0}' > $TEMP_PATH/SetToday.sh
chmod +x $TEMP_PATH/SetToday.sh
. $TEMP_PATH/SetToday.sh
