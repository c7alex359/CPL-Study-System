#!/bin/bash

# ====================================
# CPL STUDY SESSION SCRIPT
# Version 13.6.8 — Logging Fully Restored
# Last Updated: 2026-04-22
# ====================================

LOGDIR="$HOME/Documents/CPL/00_Admin/01_Execution/logs"
LOGTXT="$LOGDIR/cpl_study_log.txt"
LOGCSV="$LOGDIR/cpl_study_log.csv"

mkdir -p "$LOGDIR"

########################################
# CREATE CSV IF MISSING
########################################

if [ ! -f "$LOGCSV" ]; then
echo "session,subject_session,date,subject,mode,questions,exam_time,actual_exam_time,score,confidence,mock_passed,notes,session_minutes" >> "$LOGCSV"
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
# QUESTIONS
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
# (Timers unchanged — omitted here for space clarity in explanation)
# They remain exactly as in your v13.6.7
########################################

# --- KEEP YOUR EXISTING TIMER FUNCTIONS HERE ---
# (No changes to run_timer or run_exam_timer)

########################################
# SESSION COUNTS (RESTORED)
########################################

DATE=$(date "+%Y-%m-%d")

GLOBAL_SESSION=$(awk -F',' '
NR>1 {count++}
END {print count+1}
' "$LOGCSV")

SUBJECT_SESSION=$(awk -F',' -v subj="$SUBJECT" '
NR>1 && $4==subj {count++}
END {print count+1}
' "$LOGCSV")

########################################
# TOTALS (already working — kept)
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

SESSION_HOURS=$((SESSION_MINUTES / 60))
SESSION_REMAIN=$((SESSION_MINUTES % 60))

TOTAL_HOURS=$((NEW_TOTAL / 60))
TOTAL_REMAIN=$((NEW_TOTAL % 60))

SUBJECT_HOURS=$((NEW_SUBJECT_TOTAL / 60))
SUBJECT_REMAIN=$((NEW_SUBJECT_TOTAL % 60))

########################################
# TXT ENTRY CREATION (RESTORED)
########################################

TMP_ENTRY="/tmp/cpl_entry_$$.txt"

{
echo
echo "===================================="
echo "Session #: $(printf "%03d" $GLOBAL_SESSION)"
echo "Subject Session #: $(printf "%03d" $SUBJECT_SESSION)"
echo "Date: $DATE"
echo "Subject: $SUBJECT"
echo "Mode: $MODE_NAME"
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
# CSV WRITE (RESTORED)
########################################

echo "$GLOBAL_SESSION,$SUBJECT_SESSION,$DATE,$SUBJECT,$MODE_NAME,$QUESTIONS,$EXAM_MIN,$EXAM_ACTUAL_MIN,$SCORE,$CONF,$MOCK,\"$NOTES_CSV\",$SESSION_MINUTES" >> "$LOGCSV"

########################################
# FINAL SUMMARY
########################################

echo
echo "===================================="
echo "SESSION COMPLETED"
echo "===================================="

echo
echo "Session Time: ${SESSION_HOURS}h ${SESSION_REMAIN}m"
echo "Subject Total Time: ${SUBJECT_HOURS}h ${SUBJECT_REMAIN}m"
echo "Overall Total Time: ${TOTAL_HOURS}h ${TOTAL_REMAIN}m"

echo
echo "Log updated successfully."
echo
