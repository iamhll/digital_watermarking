#!/bin/bash
#-------------------------------------------------------------------------------
  #
  #  Filename       : runListCheck.sh
  #  Author         : Huang Leilei
  #  Created        : 2019-05-27
  #  Description    : a script-based check list
  #
#-------------------------------------------------------------------------------
  #
  #  Modified       : 2019-05-27 by HLL
  #  Description    : grep of code makers moved to update_list.sh
  #
#-------------------------------------------------------------------------------

#*** SUB FUNCTION **************************************************************
  # run
  run() {
    timeBgn=$(date +%s)
    echo "running $1..."
    chmod a+x ./common/???_$1/$1_all.sh
    ./common/???_$1/$1_all.sh
    timeEnd=$(date +%s)
    printf "  elapsed %d s\n" $((timeEnd - timeBgn))
  }


#*** MAIN BODY *****************************************************************
  # sub-item
  run "dos2unix"
  run "delete_blank_end"

  # removing empty directories
  cd ../
    echo "removing empty directories..."
    dirEmpty=$(find . -type d -empty)
    while [ "$dirEmpty" != "" ]
    do
      for dirCur in $dirEmpty
      do
        echo "  $dirCur"
      done
      echo "  ---"
      rm -rf $dirEmpty
      dirEmpty=$(find . -type d -empty)
    done
  cd - > /dev/null
  echo ""

  date
  echo ""
