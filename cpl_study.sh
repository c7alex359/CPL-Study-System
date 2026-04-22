#!/bin/bash

# ====================================
# CPL STUDY SESSION SCRIPT
# Version 13.6.9 — Taking manual control of my script
# Last Updated: 2026-04-21
# ====================================

LOGDIR="$HOME/Documents/CPL/00_Admin/01_Execution/logs"
LOGTXT="$LOGDIR/cpl_study_log.txt"
LOGCSV="$LOGDIR/cpl_study_log.csv"

mkdir -p "$LOGDIR"

########################################
# CREATE CSV IF MISSING
########################################

if [ ! -f "$LOGCSV" ]; then
echo "session,subject_session,date,subject,mode,questions,exam_max_minutes,exam_actual_minutes,score,confidence,mock_passed,notes,session_minutes" >> "$LOGCSV"
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
read -p "Enter number: " SUBJECT_NUM

case $SUBJECT_NUM in
1) SUBJECT="Meteorology" ;;
2) SUBJECT="Human Performance & Limitations" ;;
3) SUBJECT="General Navigation" ;;
4) SUBJECT="Communications" ;;
5) SUBJECT="Air Law" ;;
*) SUBJECT="Unknown" ;;
esac

echo
echo "Selected: $SUBJECT"
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

for i in 4 3 2 1; do
printf "\rStarting in: %s " "$i"
sleep 1
done
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
echo "$PHASE Phase"

if [[ "$PHASE" == *Review* ]]; then
echo "Press 'q' to finish early"
echo "Press 'e' to extend review (+${EXTEND_MIN} min)"
fi

while [ $SECONDS_LEFT -gt 0 ]; do

read -t 1 -n 1 -s KEY

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

run_timer $WARMUP_MIN "Warm-up"
run_timer $TARGET_MIN "Target Study"

fi

if [ "$MODE_NAME" != "foundation" ]; then
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

run_timer $REVIEW_MIN "Error Review"
REVIEW_EXTENDED=$RETURN_EXTENDED

SESSION_MINUTES=$((WARMUP_MIN + TARGET_MIN + REVIEW_MIN + REVIEW_EXTENDED))

fi

########################################
# PERFORMANCE
########################################

echo
echo "===================================="
echo "      SESSION PERFORMANCE"
echo "===================================="

if [ "$MODE_NAME" = "foundation" ]; then

SCORE="N/A"
CONF="study-only"
MOCK="n"

else

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

for i in 5 4 3 2 1; do
printf "\rStarting in: %s " "$i"
sleep 1
done
echo

nano -c -r 100 -l "$TMP_NOTES"

NOTES_TXT=$(cat "$TMP_NOTES")
NOTES_CSV=$(cat "$TMP_NOTES" | tr '\n' ' ')

rm -f "$TMP_NOTES"

DATE=$(date "+%Y-%m-%d")

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

rm -f "$TMP_ENTRY"

########################################
# CSV WRITE
########################################

echo "$GLOBAL_SESSION,$SUBJECT_SESSION,$DATE,$SUBJECT,$MODE_NAME,$QUESTIONS,$EXAM_MIN,$EXAM_ACTUAL_MIN,$SCORE,$CONF,$MOCK,\"$NOTES_CSV\",$SESSION_MINUTES" >> "$LOGCSV"


########################################
# FINAL SUMMARY (Restored UX)
########################################

echo
echo "===================================="
echo "SESSION COMPLETED"
echo "===================================="

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
