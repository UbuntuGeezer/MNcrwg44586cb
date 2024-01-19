#!/bin/bash
# testerr.sh - test error handling by *bash.
#	5/20/23.	wmk.
#
# Notes. testerr is  shell to test the behavior of *bash when the -e option
# is included in the invocation. -e flags bash to exit a shell when an
# error occurs, as opposed to continuing execution and allowing the shell
# to handle the error.
trap 'echo "trapped error; errcode = $? ..."' ERR
echo "entering testerr..."
badcmd
echo " still in testerr after bad command"
# end testerr.sh
