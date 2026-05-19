#!/bin/bash

# ====================================
# CPL Study System
# Version 15.5-dev
# Last Updated: 2026-05-19
#
# Created by: c7alex359
# Licensed under GNU GPL v3.0
# ====================================

LOGDIR="$HOME/Documents/CPL/00_Admin/01_Execution/logs"
LOGTXT="$LOGDIR/cpl_study_log.txt"
LOGCSV="$LOGDIR/cpl_study_log.csv"

SCRIPT_DIR="$(dirname "$0")"
SUBJECT_DB="$SCRIPT_DIR/config/subjects.db"
ACTIVE_SUBJECTS="$SCRIPT_DIR/config/active_subjects.conf"
PRIMARY_COUNT_FILE="$SCRIPT_DIR/config/primary_subject_count.conf"
COMPLETED_SUBJECTS="$SCRIPT_DIR/config/completed_subjects.conf"

trap 'tput cnorm; echo; echo "Session interrupted."; exit' INT

mkdir -p "$LOGDIR"
touch "$COMPLETED_SUBJECTS"

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

mapfile -t ACTIVE_LINES < "$ACTIVE_SUBJECTS"

if [ -f "$PRIMARY_COUNT_FILE" ]; then
    PRIMARY_SUBJECT_COUNT=$(cat "$PRIMARY_COUNT_FILE")
else
    PRIMARY_SUBJECT_COUNT=5
fi

TOTAL_SUBJECTS=${#ACTIVE_LINES[@]}

echo "Select Subject:"
for ((i=0; i<PRIMARY_SUBJECT_COUNT && i<TOTAL_SUBJECTS; i++)); do

SUBJECT_NAME="${ACTIVE_LINES[$i]}"

echo "$((i + 1))) $SUBJECT_NAME"

done

echo
echo "0) Show Additional Subjects"

echo
read -r -p "Enter number: " SUBJECT_NUM

if [[ "$SUBJECT_NUM" =~ ^[0-9]+$ ]] && \
   [ "$SUBJECT_NUM" -ge 1 ] && \
   [ "$SUBJECT_NUM" -le "$PRIMARY_SUBJECT_COUNT" ]; then

INDEX=$((SUBJECT_NUM - 1))

SUBJECT="${ACTIVE_LINES[$INDEX]}"

fi

case $SUBJECT_NUM in

[1-9]|[1-9][0-9])

if [ "$SUBJECT_NUM" -ge 1 ] && \
   [ "$SUBJECT_NUM" -le "$PRIMARY_SUBJECT_COUNT" ]; then
:
else
echo
echo "Invalid selection."
sleep 1
exec "$0"
fi
;;

0)

echo
echo "Additional Subjects:"
echo
for ((i=PRIMARY_SUBJECT_COUNT; i<TOTAL_SUBJECTS; i++)); do

SUBJECT_NAME="${ACTIVE_LINES[$i]}"

echo "$((i + 1))) $SUBJECT_NAME"

done

echo
echo "0) Back to Main Subjects"

echo
read -r -p "Enter number: " SUBJECT_NUM

if [[ "$SUBJECT_NUM" =~ ^[0-9]+$ ]] && \
   [ "$SUBJECT_NUM" -gt "$PRIMARY_SUBJECT_COUNT" ] && \
   [ "$SUBJECT_NUM" -le "$TOTAL_SUBJECTS" ]; then

INDEX=$((SUBJECT_NUM - 1))

SUBJECT="${ACTIVE_LINES[$INDEX]}"

else

echo
echo "Invalid selection."
sleep 1
exec "$0"

fi

case $SUBJECT_NUM in

0)
echo
echo "Returning to main subjects..."
sleep 1
exec "$0"
;;

esac

;;

*)
echo
echo "Invalid selection."
sleep 1
exec "$0"
;;

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
read -r -p "Enter number: " SESSION_MODE

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

read -r -p "Number of Questions (default $DEFAULT_Q): " QUESTIONS
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

START_TIME=$(date +%s)

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

read -r -t 1 -n 1 -s KEY

# Pause support ONLY for Target Study
if [[ "$PHASE" == "Target Study" ]]; then

if [ "$KEY" = "p" ]; then

echo
echo "Paused. Press 'r' to resume."

while true; do
read -r -n 1 -s KEY
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

END_TIME=$(date +%s)

ELAPSED_SECONDS=$((END_TIME - START_TIME))

ACTUAL_TIMER_MIN=$(( (ELAPSED_SECONDS + 29) / 60 ))

read -r -p "Press ENTER to continue..."

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

read -r -t 1 -n 1 -s KEY

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

read -r -p "Press ENTER to continue..."

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

SESSION_MINUTES=$((EXAM_ACTUAL_MIN + ACTUAL_TIMER_MIN))

elif [ "$MODE_NAME" = "endurance" ]; then

run_timer $REVIEW_ENDURANCE_MIN "Endurance Review"

SESSION_MINUTES=$((EXAM_ACTUAL_MIN + ACTUAL_TIMER_MIN))

elif [ "$MODE_NAME" = "full" ]; then

run_timer $REVIEW_MIN "Error Review"

SESSION_MINUTES=$((WARMUP_MIN + TARGET_MIN + EXAM_ACTUAL_MIN + ACTUAL_TIMER_MIN))

elif [ "$MODE_NAME" = "foundation" ]; then

run_timer $REVIEW_MIN "Review New Insights"

SESSION_MINUTES=$((WARMUP_MIN + TARGET_MIN + ACTUAL_TIMER_MIN))

else

echo
echo "Unknown session mode."
exit 1

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

read -r -p "Enter Exam Score (%): " SCORE
read -r -p "Confidence Level (low/medium/high): " CONF
read -r -p "Mock exam passed? (y/n): " MOCK

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

rm -f "$TMP_NOTES"

DATE=$(date "+%Y-%m-%d")

########################################
# SUBJECT LOG PATH MAPPING
########################################

SUBJECT_ENTRY=$(grep "^${SUBJECT}|" "$SUBJECT_DB")

if [ -n "$SUBJECT_ENTRY" ]; then

SUBJECT_FOLDER=$(echo "$SUBJECT_ENTRY" | cut -d'|' -f2)
SUBJECT_CODE=$(echo "$SUBJECT_ENTRY" | cut -d'|' -f3)

SUBJECT_DIR="$HOME/Documents/CPL/$SUBJECT_FOLDER"

else

SUBJECT_DIR=""
SUBJECT_CODE="unknown"

fi

SUBJECT_LOG_TXT="$SUBJECT_DIR/${SUBJECT_CODE}_study_log.txt"
SUBJECT_LOG_CSV="$SUBJECT_DIR/${SUBJECT_CODE}_study_log.csv"

########################################
# CREATE SUBJECT CSV IF MISSING
########################################

if [ -n "$SUBJECT_DIR" ]; then

if [ ! -f "$SUBJECT_LOG_CSV" ]; then

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
echo "Global Session #: $GLOBAL_FMT"
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
# WRITE TO SUBJECT TXT LOG (Newest First)
########################################

if [ -n "$SUBJECT_LOG_TXT" ]; then

if [ -f "$SUBJECT_LOG_TXT" ]; then

# Insert new entry at TOP (newest-first)
cat "$TMP_ENTRY" "$SUBJECT_LOG_TXT" > "$SUBJECT_LOG_TXT.new"
mv "$SUBJECT_LOG_TXT.new" "$SUBJECT_LOG_TXT"

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

read -r -p "Press ENTER to continue..."

########################################
# POST-SESSION OPTIONS
########################################

echo
echo "What would you like to do?"
echo
echo "r) Return to main menu"
echo "c) Change settings"
echo "l) View latest log entry"
echo "e) Log completed exam subjects"
echo "q) Quit"
echo

read -r -n 1 -p "Selection: " FINAL_CHOICE
echo

case "$FINAL_CHOICE" in

r)
exec "$0"
;;

c)
clear
echo
echo "===================================="
echo "         SETTINGS MENU"
echo "===================================="
echo
echo "1) Change focus subjects"
echo "2) Change timer settings"
echo "3) Log maintenance"
echo
read -r -p "Enter selection: " SETTINGS_CHOICE
case "$SETTINGS_CHOICE" in

1)
clear
echo
echo "===================================="
echo "     CHANGE FOCUS SUBJECTS"
echo "===================================="
echo

echo "Current Subject Priority:"
echo

for ((i=0; i<TOTAL_SUBJECTS; i++)); do

    SUBJECT_NAME="${ACTIVE_LINES[$i]}"

    echo "$((i + 1))) $SUBJECT_NAME"

done

echo
echo "Enter subjects in desired focus order."
echo
echo "Example:"
echo "1 3 5 7"
echo
echo "The number of selected subjects defines"
echo "the primary startup menu size."
echo

read -r -p "Enter focus subjects: " NEW_FOCUS
read -ra FOCUS_ARRAY <<< "$NEW_FOCUS"

NEW_ACTIVE=()
REMAINING=()
USED_NUMBERS=()

for NUM in "${FOCUS_ARRAY[@]}"; do

if [[ ! "$NUM" =~ ^[0-9]+$ ]]; then
    continue
fi

DUPLICATE=0

for USED in "${USED_NUMBERS[@]}"; do

    if [ "$NUM" = "$USED" ]; then
        DUPLICATE=1
        break
    fi

done

if [ "$DUPLICATE" -eq 1 ]; then
    continue
fi

INDEX=$((NUM - 1))

if [ "$INDEX" -ge 0 ] && \
   [ "$INDEX" -lt "$TOTAL_SUBJECTS" ]; then

    NEW_ACTIVE+=("${ACTIVE_LINES[$INDEX]}")
    USED_NUMBERS+=("$NUM")

fi

done

for SUBJECT_NAME in "${ACTIVE_LINES[@]}"; do

FOUND=0

for SELECTED in "${NEW_ACTIVE[@]}"; do

    if [ "$SUBJECT_NAME" = "$SELECTED" ]; then
        FOUND=1
        break
    fi

done

if [ "$FOUND" -eq 0 ]; then
    REMAINING+=("$SUBJECT_NAME")
fi

done

if [ "${#NEW_ACTIVE[@]}" -eq 0 ]; then

echo
echo "No valid subjects selected."
echo

read -r -p "Press ENTER to continue..."
exec "$0"

fi

FINAL_ACTIVE=("${NEW_ACTIVE[@]}" "${REMAINING[@]}")

echo
echo "New Subject Priority:"
echo

for ((i=0; i<TOTAL_SUBJECTS; i++)); do

    echo "$((i + 1))) ${FINAL_ACTIVE[$i]}"

done
echo

echo
read -r -p "Confirm new subject priority? (y/n): " CONFIRM_SUBJECTS

if [ "$CONFIRM_SUBJECTS" = "y" ]; then

    printf "%s\n" "${FINAL_ACTIVE[@]}" > "$ACTIVE_SUBJECTS"

    echo "${#NEW_ACTIVE[@]}" > "$PRIMARY_COUNT_FILE"

    echo
    echo "Focus subjects updated successfully."
    echo
    echo "Primary startup menu now displays:"
    echo "${#NEW_ACTIVE[@]} subjects."
    echo

else

    echo
    echo "Changes discarded."
    echo

fi

read -r -p "Press ENTER to continue..."
exec "$0"
;;

*)

exec "$0"
;;

esac
;;

l)
less "$LOGTXT"
exec "$0"
;;

e)

clear

echo
echo "===================================="
echo "    COMPLETED EXAM SUBJECTS"
echo "===================================="
echo

NEW_COMPLETIONS=()

while true; do

clear

echo
echo "===================================="
echo "    COMPLETED EXAM SUBJECTS"
echo "===================================="
echo

echo "Current Active Subjects:"
echo

for ((i=0; i<TOTAL_SUBJECTS; i++)); do
    echo "$((i + 1))) ${ACTIVE_LINES[$i]}"
done

echo
read -r -p "Enter completed subject number: " COMPLETE_NUM

if [[ ! "$COMPLETE_NUM" =~ ^[0-9]+$ ]]; then
    echo
    echo "Invalid selection."
    echo
    continue
fi

INDEX=$((COMPLETE_NUM - 1))

if [ "$INDEX" -lt 0 ] || \
   [ "$INDEX" -ge "$TOTAL_SUBJECTS" ]; then

    echo
    echo "Invalid selection."
    echo
    continue

fi

COMPLETED_SUBJECT="${ACTIVE_LINES[$INDEX]}"

if grep -q "^${COMPLETED_SUBJECT}|" "$COMPLETED_SUBJECTS"; then

    echo
    echo "$COMPLETED_SUBJECT already logged as completed."
    echo
    continue

fi

echo
read -r -p "Enter final score achieved: " FINAL_SCORE

if [[ ! "$FINAL_SCORE" =~ ^[0-9]+$ ]] || \
   [ "$FINAL_SCORE" -lt 75 ] || \
   [ "$FINAL_SCORE" -gt 100 ]; then

    echo
    echo "Score must be between 75 and 100."
    echo
    continue

fi

echo "${COMPLETED_SUBJECT}|${FINAL_SCORE}" >> "$COMPLETED_SUBJECTS"

NEW_COMPLETIONS+=("${COMPLETED_SUBJECT}|${FINAL_SCORE}")

echo
echo "$COMPLETED_SUBJECT recorded successfully."
echo

read -r -p "Add another completed subject? (y/n): " ADD_ANOTHER

[ "$ADD_ANOTHER" != "y" ] && break

done

read -r -p "Press ENTER to continue..."
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
