#!/bin/bash

# ====================================
# CPL STUDY SESSION SCRIPT
# Version 14.3.0 — Focus Stage Refinement
# Subject Tree Logging Stable
# UI Focus Mode Enhancements In Progress
# Last Updated: 2026-04-25
# ====================================

LOGDIR="$HOME/Documents/CPL/00_Admin/01_Execution/logs"
LOGTXT="$LOGDIR/cpl_study_log.txt"
LOGCSV="$LOGDIR/cpl_study_log.csv"

trap 'tput cnorm; echo; echo "Session interrupted."; exit' INT

mkdir -p "$LOGDIR"

########################################
# CREATE CSV IF MISSING
########################################

if [ ! -f "$LOGCSV" ]; then
echo "session,subject_session,date,subject,mode,questions,exam_max_minutes,exam_actual_minutes,score,confidence,mock_passed,session_minutes" >> "$LOGCSV"
fi

########################################
# CONSTANTS
########################################

TIME_PER_QUESTION=1.4

DEFAULT_Q_FULL=35
DEFAULT_Q_MOMENTUM=35
DEFAULT_Q_ENDURANCE=60

WARMUP_MIN=12
TARGET_MIN=25

REVIEW_MIN=12
REVIEW_SHORT_MIN=10
REVIEW_ENDURANCE_MIN=20

EXTEND_MIN=5
BAR_WIDTH=30

########################################

clear

echo "===================================="
echo "         CPL STUDY SESSION"
echo "===================================="
echo

########################################
# SUBJECT
########################################

echo "Select Subject:"
echo "1) Meteorology"
echo "2) Human Performance & Limitations"
echo "3) General Navigation"
echo "4) Communications"
echo "5) Air Law"

echo
echo "0) Show Additional Subjects"

echo
read -r -p "Enter number: " SUBJECT_NUM

case $SUBJECT_NUM in
1) SUBJECT="Meteorology" ;;
2) SUBJECT="Human Performance & Limitations" ;;
3) SUBJECT="General Navigation" ;;
4) SUBJECT="Communications" ;;
5) SUBJECT="Air Law" ;;

0)

echo
echo "Additional Subjects:"
echo
echo "6) Principles of Flight"
echo "7) Instrumentation"
echo "8) Radio Navigation"
echo "9) Airframe, Systems, Electrics, Power Plant"
echo "10) Operational Procedures"
echo "11) Mass & Balance"
echo "12) Performance"
echo "13) Flight Planning & Monitoring"
echo "14) Knowledge, Skills and Attitudes (KSA)"

echo
echo "0) Back to Main Subjects"

echo
read -r -p "Enter number: " SUBJECT_NUM

case $SUBJECT_NUM in

0)
echo
echo "Returning to main subjects..."
sleep 1
exec "$0"
;;

6) SUBJECT="Principles of Flight" ;;
7) SUBJECT="Instrumentation" ;;
8) SUBJECT="Radio Navigation" ;;
9) SUBJECT="Airframe, Systems, Electrics, Power Plant" ;;
10) SUBJECT="Operational Procedures" ;;
11) SUBJECT="Mass & Balance" ;;
12) SUBJECT="Performance" ;;
13) SUBJECT="Flight Planning & Monitoring" ;;
14) SUBJECT="Knowledge, Skills and Attitudes (KSA)" ;;

*)
echo
echo "Invalid selection."
sleep 1
exec "$0"
;;

esac

;;

*) SUBJECT="Unknown" ;;

esac

echo
echo "Selected: $SUBJECT"
sleep 1

clear

echo "===================================="
echo "         CPL STUDY SESSION"
echo "===================================="
echo
echo "Subject: $SUBJECT"
echo
echo

########################################
# MODE
########################################

echo "Select Exam Preparation Mode:"
echo "1) Study + Exam (Full Session)"
echo "2) Study Only (Foundation Session)"
echo "3) Exam Only (Momentum Session)"
echo "4) Exam Only (Endurance Session)"

echo
read -p "Enter number: " SESSION_MODE

case $SESSION_MODE in
1) MODE_NAME="full"; DEFAULT_Q=$DEFAULT_Q_FULL ;;
2) MODE_NAME="foundation" ;;
3) MODE_NAME="momentum"; DEFAULT_Q=$DEFAULT_Q_MOMENTUM ;;
4) MODE_NAME="endurance"; DEFAULT_Q=$DEFAULT_Q_ENDURANCE ;;
*) MODE_NAME="full"; DEFAULT_Q=$DEFAULT_Q_FULL ;;
esac

echo
echo "Selected Mode: $MODE_NAME"
sleep 1

clear

echo "===================================="
echo "         CPL STUDY SESSION"
echo "===================================="
echo
echo "Subject: $SUBJECT"
echo "Mode: $MODE_NAME"
echo
echo

########################################
# QUESTION INPUT
########################################

if [ "$MODE_NAME" != "foundation" ]; then

read -p "Number of Questions (default $DEFAULT_Q): " QUESTIONS
[ -z "$QUESTIONS" ] && QUESTIONS=$DEFAULT_Q

EXAM_MIN=$(awk "BEGIN {print int($QUESTIONS * $TIME_PER_QUESTION)}")

echo
echo "Questions: $QUESTIONS"
echo "Maximum Exam Time: $EXAM_MIN minutes"

for i in 5 4 3 2 1; do
printf "\rStarting in: %s " "$i"
sleep 1
done
echo

clear

echo "===================================="
echo "         CPL STUDY SESSION"
echo "===================================="
echo
echo "Subject: $SUBJECT"
echo "Mode: $MODE_NAME"
echo

else

QUESTIONS="N/A"
EXAM_MIN=0

fi

########################################
# TIMER FUNCTION
########################################

run_timer() {

MINUTES=$1
PHASE=$2

TOTAL_SECONDS=$((MINUTES * 60))
SECONDS_LEFT=$TOTAL_SECONDS

EXTENDED_MINUTES=0

echo
echo "------------------------------------"
echo "$PHASE Phase"
echo "------------------------------------"

if [[ "$PHASE" == "Target Study" ]]; then
echo "Press 'p' to pause"
fi

if [[ "$PHASE" == *Review* ]]; then
echo "Press 'q' to finish early"
echo "Press 'e' to extend review (+${EXTEND_MIN} min)"
fi

while [ $SECONDS_LEFT -gt 0 ]; do

read -t 1 -n 1 -s KEY

# Pause support ONLY for Target Study
if [[ "$PHASE" == "Target Study" ]]; then

if [ "$KEY" = "p" ]; then

echo
echo "Paused. Press 'r' to resume."

while true; do
read -n 1 -s KEY
[ "$KEY" = "r" ] && break
done

echo "Resuming..."

fi

fi

if [[ "$PHASE" == *Review* ]]; then

if [ "$KEY" = "q" ]; then
echo
echo "Review finished early."
break
fi

if [ "$KEY" = "e" ]; then

SECONDS_LEFT=$((SECONDS_LEFT + EXTEND_MIN*60))
TOTAL_SECONDS=$((TOTAL_SECONDS + EXTEND_MIN*60))

EXTENDED_MINUTES=$((EXTENDED_MINUTES + EXTEND_MIN))

echo
echo "+${EXTEND_MIN} minutes added."

fi

fi

ELAPSED=$((TOTAL_SECONDS - SECONDS_LEFT))

FILLED=$((ELAPSED * BAR_WIDTH / TOTAL_SECONDS))
EMPTY=$((BAR_WIDTH - FILLED))

BAR=$(printf "%${FILLED}s" | tr ' ' '-')
SPACE=$(printf "%${EMPTY}s")

ELAPSED_MIN=$((ELAPSED / 60))
ELAPSED_SEC=$((ELAPSED % 60))

REMAIN_MIN=$((SECONDS_LEFT / 60))
REMAIN_SEC=$((SECONDS_LEFT % 60))

printf "\r[%-30s] %02d:%02d elapsed | %02d:%02d remaining" \
"$BAR$SPACE" \
$ELAPSED_MIN $ELAPSED_SEC \
$REMAIN_MIN $REMAIN_SEC

SECONDS_LEFT=$((SECONDS_LEFT - 1))

done

echo
echo "$PHASE completed."
echo

RETURN_EXTENDED=$EXTENDED_MINUTES

read -p "Press ENTER to continue..."

}

########################################
# EXAM TIMER
########################################

run_exam_timer() {

TOTAL_SECONDS=$((EXAM_MIN * 60))
SECONDS_LEFT=$TOTAL_SECONDS

START_TIME=$(date +%s)

echo
echo "Exam Mode Phase"
echo "Press 'q' to finish early."

while [ $SECONDS_LEFT -gt 0 ]; do

read -t 1 -n 1 -s KEY

if [ "$KEY" = "q" ]; then
echo
echo "Exam finished early."
break
fi

ELAPSED=$((TOTAL_SECONDS - SECONDS_LEFT))

FILLED=$((ELAPSED * BAR_WIDTH / TOTAL_SECONDS))
EMPTY=$((BAR_WIDTH - FILLED))

BAR=$(printf "%${FILLED}s" | tr ' ' '-')
SPACE=$(printf "%${EMPTY}s")

ELAPSED_MIN=$((ELAPSED / 60))
ELAPSED_SEC=$((ELAPSED % 60))

REMAIN_MIN=$((SECONDS_LEFT / 60))
REMAIN_SEC=$((SECONDS_LEFT % 60))

printf "\r[%-30s] %02d:%02d elapsed | %02d:%02d remaining" \
"$BAR$SPACE" \
$ELAPSED_MIN $ELAPSED_SEC \
$REMAIN_MIN $REMAIN_SEC

SECONDS_LEFT=$((SECONDS_LEFT - 1))

done

END_TIME=$(date +%s)

ELAPSED_SECONDS=$((END_TIME - START_TIME))

EXAM_ACTUAL_MIN=$(( (ELAPSED_SECONDS + 29) / 60 ))

echo
echo "Actual Exam Time Used: $EXAM_ACTUAL_MIN minutes"

read -p "Press ENTER to continue..."

}

########################################
# RUN MODES
########################################

if [ "$MODE_NAME" = "foundation" ] || \
   [ "$MODE_NAME" = "full" ]; then

tput civis

run_timer $WARMUP_MIN "Warm-up"
run_timer $TARGET_MIN "Target Study"

fi

if [ "$MODE_NAME" != "foundation" ]; then

tput civis

run_exam_timer
else
EXAM_ACTUAL_MIN=0
fi

########################################
# REVIEW
########################################

if [ "$MODE_NAME" = "momentum" ]; then

run_timer $REVIEW_SHORT_MIN "Quick Review"
REVIEW_EXTENDED=$RETURN_EXTENDED

SESSION_MINUTES=$((EXAM_ACTUAL_MIN + REVIEW_SHORT_MIN + REVIEW_EXTENDED))

elif [ "$MODE_NAME" = "endurance" ]; then

run_timer $REVIEW_ENDURANCE_MIN "Endurance Review"
REVIEW_EXTENDED=$RETURN_EXTENDED

SESSION_MINUTES=$((EXAM_ACTUAL_MIN + REVIEW_ENDURANCE_MIN + REVIEW_EXTENDED))

elif [ "$MODE_NAME" = "full" ]; then

run_timer $REVIEW_MIN "Error Review"
REVIEW_EXTENDED=$RETURN_EXTENDED

SESSION_MINUTES=$((WARMUP_MIN + TARGET_MIN + EXAM_ACTUAL_MIN + REVIEW_MIN + REVIEW_EXTENDED))

else

run_timer $REVIEW_MIN "Review New Insights"
REVIEW_EXTENDED=$RETURN_EXTENDED

SESSION_MINUTES=$((WARMUP_MIN + TARGET_MIN + REVIEW_MIN + REVIEW_EXTENDED))

fi

########################################
# PERFORMANCE
########################################

echo
echo "===================================="

if [ "$MODE_NAME" = "foundation" ]; then
echo "         SESSION NOTES"
else
echo "      SESSION PERFORMANCE"
fi

echo "===================================="

if [ "$MODE_NAME" = "foundation" ]; then

SCORE="N/A"
CONF="study-only"
MOCK="n"

else

tput cnorm

read -p "Enter Exam Score (%): " SCORE
read -p "Confidence Level (low/medium/high): " CONF
read -p "Mock exam passed? (y/n): " MOCK

fi

########################################
# NOTES (Restored v12.5.1 Instructions)
########################################

TMP_NOTES="/tmp/cpl_notes_$$.txt"

echo
echo "Opening notes editor..."
echo
echo "Use:"
echo "CTRL + O → Save notes"
echo "CTRL + X → Exit editor"
echo
echo "Keep notes concise and structured."
echo "Short bullet-style entries recommended."
echo

for i in 6 5 4 3 2 1; do
printf "\rStarting in: %s " "$i"
sleep 1
done
echo

tput cnorm
nano -c -r 100 -l "$TMP_NOTES"

NOTES_TXT=$(cat "$TMP_NOTES")
NOTES_CSV=$(cat "$TMP_NOTES" | tr '\n' ' ')

rm -f "$TMP_NOTES"

DATE=$(date "+%Y-%m-%d")

########################################
# SUBJECT LOG PATH MAPPING
########################################

case "$SUBJECT" in

"Meteorology")
SUBJECT_DIR="$HOME/Documents/CPL/050_Meteorology"
SUBJECT_CODE="met"
;;

"Human Performance & Limitations")
SUBJECT_DIR="$HOME/Documents/CPL/040_Human_Performance_&_Limitations"
SUBJECT_CODE="human"
;;

"General Navigation")
SUBJECT_DIR="$HOME/Documents/CPL/061_General_Navigation"
SUBJECT_CODE="gnav"
;;

"Communications")
SUBJECT_DIR="$HOME/Documents/CPL/090_Communication"
SUBJECT_CODE="com"
;;

"Air Law")
SUBJECT_DIR="$HOME/Documents/CPL/010_Air_Law"
SUBJECT_CODE="alaw"
;;

"Principles of Flight")
SUBJECT_DIR="$HOME/Documents/CPL/081_Principles_of_Flight"
SUBJECT_CODE="pof"
;;

"Instrumentation")
SUBJECT_DIR="$HOME/Documents/CPL/022_Instrumentation"
SUBJECT_CODE="inst"
;;

"Radio Navigation")
SUBJECT_DIR="$HOME/Documents/CPL/062_Radio_Navigation"
SUBJECT_CODE="rnav"
;;

"Airframe, Systems, Electrics, Power Plant")
SUBJECT_DIR="$HOME/Documents/CPL/021_Airframes"
SUBJECT_CODE="asepp"
;;

"Operational Procedures")
SUBJECT_DIR="$HOME/Documents/CPL/070_Operational_Procedures"
SUBJECT_CODE="ops"
;;

"Mass & Balance")
SUBJECT_DIR="$HOME/Documents/CPL/031_Mass_&_Balance"
SUBJECT_CODE="mb"
;;

"Performance")
SUBJECT_DIR="$HOME/Documents/CPL/032_Performance"
SUBJECT_CODE="perf"
;;

"Flight Planning & Monitoring")
SUBJECT_DIR="$HOME/Documents/CPL/033_Flight_Planning_&_Monitoring"
SUBJECT_CODE="flpm"
;;

"Knowledge, Skills and Attitudes (KSA)")
SUBJECT_DIR="$HOME/Documents/CPL/100_KSA"
SUBJECT_CODE="ksa"
;;

*)
SUBJECT_DIR=""
SUBJECT_CODE="unknown"
;;

esac

SUBJECT_LOG_TXT="$SUBJECT_DIR/${SUBJECT_CODE}_study_log.txt"
SUBJECT_LOG_CSV="$SUBJECT_DIR/${SUBJECT_CODE}_study_log.csv"

########################################
# CREATE SUBJECT CSV IF MISSING
########################################

if [ -n "$SUBJECT_DIR" ]; then

if [ -n "$SUBJECT_DIR" ]; then

echo "subject_session,date,mode,questions,exam_max_minutes,exam_actual_minutes,score,confidence,mock_passed,session_minutes,subject_total_minutes" >> "$SUBJECT_LOG_CSV"

fi

fi
########################################
# SESSION COUNTS
########################################

GLOBAL_SESSION=$(awk -F',' '
NR>1 {count++}
END {print count+1}
' "$LOGCSV")

SUBJECT_SESSION=$(awk -F',' -v subj="$SUBJECT" '
NR>1 && $4==subj {count++}
END {print count+1}
' "$LOGCSV")

########################################
# TOTALS
########################################

TOTAL_MINUTES=$(awk -F',' '
NR>1 {
if ($NF ~ /^[0-9]+$/)
sum+=$NF
}
END {print sum}
' "$LOGCSV")

SUBJECT_TOTAL_MINUTES=$(awk -F',' -v subj="$SUBJECT" '
NR>1 && $4==subj {
if ($NF ~ /^[0-9]+$/)
sum+=$NF
}
END {print sum}
' "$LOGCSV")

NEW_TOTAL=$((TOTAL_MINUTES + SESSION_MINUTES))
NEW_SUBJECT_TOTAL=$((SUBJECT_TOTAL_MINUTES + SESSION_MINUTES))

########################################
# FORMAT TIMES
########################################

SESSION_HOURS=$((SESSION_MINUTES / 60))
SESSION_REMAIN=$((SESSION_MINUTES % 60))

TOTAL_HOURS=$((NEW_TOTAL / 60))
TOTAL_REMAIN=$((NEW_TOTAL % 60))

SUBJECT_HOURS=$((NEW_SUBJECT_TOTAL / 60))
SUBJECT_REMAIN=$((NEW_SUBJECT_TOTAL % 60))

GLOBAL_FMT=$(printf "%03d" "$GLOBAL_SESSION")
SUBJECT_FMT=$(printf "%03d" "$SUBJECT_SESSION")

########################################
# CREATE ENTRY (Indented Notes Restored)
########################################

TMP_ENTRY="/tmp/cpl_entry_$$.txt"

{
echo
echo "===================================="
echo "Session #: $GLOBAL_FMT"
echo "Subject Session #: $SUBJECT_FMT"
echo "Date: $DATE"
echo "Subject: $SUBJECT"

if [ "$EXAM_ACTUAL_MIN" -gt 0 ]; then
echo "Mode: $MODE_NAME"
echo "Questions: $QUESTIONS"
echo "Exam Time Used: $EXAM_ACTUAL_MIN minutes"
fi

echo
echo "Score: $SCORE"
echo "Confidence: $CONF"
echo "Mock Passed: $MOCK"

echo "Notes:"
echo

echo "$NOTES_TXT" | sed 's/^/       /'

echo
echo "Session Time: ${SESSION_HOURS}h ${SESSION_REMAIN}m"
echo "Subject Total Time: ${SUBJECT_HOURS}h ${SUBJECT_REMAIN}m"
echo "Overall Total Time: ${TOTAL_HOURS}h ${TOTAL_REMAIN}m"
echo
} > "$TMP_ENTRY"

if [ -f "$LOGTXT" ]; then
cat "$TMP_ENTRY" "$LOGTXT" > "$LOGTXT.new"
mv "$LOGTXT.new" "$LOGTXT"
else
mv "$TMP_ENTRY" "$LOGTXT"
fi

########################################
# WRITE TO SUBJECT TXT LOG
########################################

if [ -n "$SUBJECT_LOG_TXT" ]; then

if [ -f "$SUBJECT_LOG_TXT" ]; then

# Append (oldest-first chronological)
cat "$TMP_ENTRY" >> "$SUBJECT_LOG_TXT"

else

# Create new subject log
cat "$TMP_ENTRY" > "$SUBJECT_LOG_TXT"

fi

fi

rm -f "$TMP_ENTRY"

########################################
# CSV WRITE
########################################

echo "$GLOBAL_SESSION,$SUBJECT_SESSION,$DATE,$SUBJECT,$MODE_NAME,$QUESTIONS,$EXAM_MIN,$EXAM_ACTUAL_MIN,$SCORE,$CONF,$MOCK,$SESSION_MINUTES" >> "$LOGCSV"

########################################
# SUBJECT CSV WRITE (FIX)
########################################

if [ -n "$SUBJECT_LOG_CSV" ]; then

echo "$SUBJECT_SESSION,$DATE,$MODE_NAME,$QUESTIONS,$EXAM_MIN,$EXAM_ACTUAL_MIN,$SCORE,$CONF,$MOCK,$SESSION_MINUTES,$NEW_SUBJECT_TOTAL" >> "$SUBJECT_LOG_CSV"

fi

########################################
# FINAL SUMMARY (Restored UX)
########################################

echo
echo "===================================="
echo "✓ SESSION COMPLETED"
echo "===================================="
echo

SESSION_HOURS=$((SESSION_MINUTES / 60))
SESSION_REMAIN=$((SESSION_MINUTES % 60))

echo
echo "Session Time: ${SESSION_HOURS}h ${SESSION_REMAIN}m"
echo "Subject Total Time: ${SUBJECT_HOURS}h ${SUBJECT_REMAIN}m"
echo "Overall Total Time: ${TOTAL_HOURS}h ${TOTAL_REMAIN}m"
echo

echo
echo "Log updated successfully."
echo

tput cnorm

########################################
# POST-SESSION OPTIONS
########################################

echo
echo "What would you like to do?"
echo
echo "r) Return to main menu"
echo "l) View latest log entry"
echo "q) Quit"
echo

read -n 1 -p "Selection: " FINAL_CHOICE
echo

case "$FINAL_CHOICE" in

r)
exec "$0"
;;

l)
less "$LOGTXT"
exec "$0"
;;

q)
echo
echo "Session closed."
exit
;;

*)
exec "$0"
;;

esac
