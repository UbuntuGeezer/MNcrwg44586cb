if [ $? -eq 0 ];then
 cat tarname.txt
 if ! test -f $TEMP_PATH/foundlist.txt;then
  touch $TEMP_PATH/foundlist.txt
 fi
 cat $TEMP_PATH/foundlist.txt $TEMP_PATH/tarname.txt > $TEMP_PATH/buffer.txt
 mv $TEMP_PATH/buffer.txt $TEMP_PATH/foundlist.txt
fi
# end tarsrch.4.sh

