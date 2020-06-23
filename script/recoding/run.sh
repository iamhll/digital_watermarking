#!/bin/bash
#-------------------------------------------------------------------------------
  #
  #  Filename      : run.sh
  #  Author        : Huang Leilei
  #  Created       : 2020-06-22
  #  Description   : run x265 automatically
  #
#-------------------------------------------------------------------------------

#--- PARAMETER -------------------------
# directory or file name
NAME_DIR_SEQ="../embedding_paper/dump_with_lcu_01_embedded"
NAME_LOG_RLT="dump.log"
NAME_LOG_JOB="jobs.log"
NAME_DIR_DMP="dump_paper_with_lcu_01_embedded"

# sequence
#  name              frame fps width height depth
LIST_AVAILABLE=(
  "BasketballPass"   501   60  416   240    8
  "BQSquare"         601   60  416   240    8
  "BlowingBubbles"   501   60  416   240    8
  "RaceHorses"       300   60  416   240    8
  "BasketballDrill"  501   60  832   480    8
  "BQMall"           601   60  832   480    8
  "PartyScene"       501   60  832   480    8
  "RaceHorsesC"      300   60  832   480    8
  "FourPeople"       600   60  1280  720    8
  "Johnny"           600   60  1280  720    8
  "KristenAndSara"   600   60  1280  720    8
  "Kimono"           240   60  1920  1080   8
  "ParkScene"        240   60  1920  1080   8
  "Cactus"           500   60  1920  1080   8
  "BasketballDrive"  501   60  1920  1080   8
  "BQTerrace"        601   60  1920  1080   8
  "Traffic"          150   60  2560  1600   8
  "PeopleOnStreet"   150   60  2560  1600   8
)
LIST_SEQ=(
  #"BasketballPass"   20    60  416   240    8
  #"BQSquare"         20    60  416   240    8
  "BlowingBubbles"   20    60  416   240    8
  #"RaceHorses"       20    60  416   240    8
  #"BasketballDrill"  20    60  832   480    8
  #"BQMall"           20    60  832   480    8
  #"PartyScene"       20    60  832   480    8
  #"RaceHorsesC"      20    60  832   480    8
  #"FourPeople"       20    60  1280  720    8
  #"Johnny"           20    60  1280  720    8
  #"KristenAndSara"   20    60  1280  720    8
  #"Kimono"           20    60  1920  1080   8
  #"ParkScene"        20    60  1920  1080   8
  #"Cactus"           20    60  1920  1080   8
  #"BasketballDrive"  20    60  1920  1080   8
  #"BQTerrace"        20    60  1920  1080   8
  #"Traffic"          20    60  2560  1600   8
  #"PeopleOnStreet"   20    60  2560  1600   8
)

# encoder
LIST_QP=($(seq 22 5 37))
SIZE_GOP=1


#--- MAIN BODY -------------------------
#--- INIT ---
# update and copy x265
#cd ../../src/x265_3.0/build/linux/8bit/
#make
#cd -
#cp ../../src/x265_3.0/build/linux/8bit/x265 .

# prepare directory
mkdir -p $NAME_DIR_DMP
rm -rf $NAME_DIR_DMP/*
rm -rf $NAME_LOG_RLT
printf "%-51s %-51s %-51s\n" "I frame" "P frame" "B frame" >> $NAME_LOG_RLT
for i in $(seq 1 3)
do
    printf "%-13s \t %-7s \t %-7s \t %-7s    "  "bitrate(kb/s)" "psnr(Y)" "psnr(U)" "psnr(V)" >> $NAME_LOG_RLT
done
printf "\n" >> $NAME_LOG_RLT

# note down the current time
timeBgnAll=$(date +%s)

#--- LOOP SEQUENCE ---
cntSeq=0
numSeq=${#LIST_SEQ[*]}
while [ $cntSeq -lt $numSeq ]
do
  # extract parameter
  NAME_SEQ=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  NUMB_FRA=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  DATA_FPS=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  SIZE_FRA_X=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  SIZE_FRA_Y=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  DATA_PXL_WD=${LIST_SEQ[$cntSeq]}; cntSeq=$((cntSeq + 1))
  #FILE_SEQ="$NAME_DIR_SEQ/$NAME_SEQ/$NAME_SEQ"

  # log
  echo ""
  echo "processing $FILE_SEQ ..."

  # note down the current time
  timeBgnCur=$(date +%s)

  #--- LOOP QP (ENCODE) ---
  cntQp=0
  numQp=${#LIST_QP[*]}
  while [ $cntQp -lt $numQp ]
  do
    # extract parameter
    DATA_QP=${LIST_QP[ $((cntQp + 0)) ]}
    FILE_SEQ=$NAME_DIR_SEQ/${NAME_SEQ}_${DATA_QP}/x265
    PREF_DMP=$NAME_DIR_DMP/${NAME_SEQ}_${DATA_QP}/

    # update counter
    cntQp=$((cntQp + 1))

    # log
    echo "    qp $DATA_QP launched ..."

    # make directory
    mkdir $NAME_DIR_DMP/${NAME_SEQ}_${DATA_QP}

    # encode
    # core
    ./x265                                             \
      --input           $FILE_SEQ.yuv                  \
      --fps             $DATA_FPS                      \
      --input-res       ${SIZE_FRA_X}x${SIZE_FRA_Y}    \
      --input-depth     $DATA_PXL_WD                   \
      --frames          $NUMB_FRA                      \
      --keyint          $SIZE_GOP                      \
      --qp              $DATA_QP                       \
      --ipratio         1                              \
      --pbratio         1                              \
      --output          ${PREF_DMP}x265.h265           \
      --output-depth    $DATA_PXL_WD                   \
      --recon           ${PREF_DMP}x265.yuv            \
      --recon-depth     $DATA_PXL_WD                   \
      --psnr                                           \
      --tune            psnr                           \
      --log-level       full                           \
      --no-progress                                    \
      --frame-threads                1                 \
      --no-wpp                                         \
      --no-pmode                                       \
      --no-pme                                         \
    >& "${PREF_DMP}x265.log" &
  done

  # wait
  numJob=1
  while [ $numJob -ne 0 ]
  do
    sleep 1
    timeEnd=$(date +%s)
    printf "    delta time: %d min %d s; run time: %d min %d s (jobs: %d)        \r"    \
      $(((timeEnd-timeBgnCur) / 60                        ))                            \
      $(((timeEnd-timeBgnCur) - (timeEnd-timeBgnCur)/60*60))                            \
      $(((timeEnd-timeBgnAll) / 60                        ))                            \
      $(((timeEnd-timeBgnAll) - (timeEnd-timeBgnAll)/60*60))                            \
      $(jobs | wc -l)
    jobs > $NAME_LOG_JOB
    numJob=$(cat $NAME_LOG_JOB | wc -l)
    grep 127 $NAME_LOG_JOB
  done
  rm $NAME_LOG_JOB
  timeEnd=$(date +%s)
  printf "    delta time: %d min %d s; run time: %d min %d s                   \n"    \
    $(((timeEnd-timeBgnCur) / 60                        ))                            \
    $(((timeEnd-timeBgnCur) - (timeEnd-timeBgnCur)/60*60))                            \
    $(((timeEnd-timeBgnAll) / 60                        ))                            \
    $(((timeEnd-timeBgnAll) - (timeEnd-timeBgnAll)/60*60))

  #--- LOOP QP (CHECK) ---
  cntQp=0
  numQp=${#LIST_QP[*]}
  while [ $cntQp -lt $numQp ]
  do
    # extract parameter
    DATA_QP=${LIST_QP[ $((cntQp + 0)) ]}
    PREF_DMP="$NAME_DIR_DMP/${NAME_SEQ}_${DATA_QP}/"

    # update counter
    cntQp=$((cntQp + 1))

    # grep
    cat "${PREF_DMP}x265.log"    \
      | perl -e 'while (<>) {
                   if (/kb\/s: ([\d\.]+)/) {
                     printf "%-13.2f \t ", $1
                   }
                   if (/Y:([\d\.]+) U:([\d\.]+) V:([\d\.]+)/) {
                     printf "%-7.3f \t %-7.3f \t %-7.3f    ", $1, $2, $3
                   }
                   if (/error/) {
                     printf "%-94s", ""
                   }
                 }'       \
    >> $NAME_LOG_RLT
    echo $DUMP_PREFIX >> $NAME_LOG_RLT
  done
done
