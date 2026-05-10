#!/bin/bash

BASE="$HOME/Documents/CPL"
TXT="$BASE/00_Admin/01_Execution/logs/cpl_study_log.txt"

########################################
# SUBJECT MAP
########################################

declare -A DIR_MAP
declare -A CODE_MAP

DIR_MAP["Meteorology"]="050_Meteorology"
CODE_MAP["Meteorology"]="met"

DIR_MAP["Human Performance & Limitations"]="040_Human_Performance_&_Limitations"
CODE_MAP["Human Performance & Limitations"]="human"

DIR_MAP["Human Performance"]="040_Human_Performance_&_Limitations"
CODE_MAP["Human Performance"]="human"

DIR_MAP["General Navigation"]="061_General_Navigation"
CODE_MAP["General Navigation"]="gnav"

DIR_MAP["Communications"]="090_Communication"
CODE_MAP["Communications"]="com"

DIR_MAP["Air Law"]="010_Air_Law"
CODE_MAP["Air Law"]="alaw"

DIR_MAP["Principles of Flight"]="081_Principles_of_Flight"
CODE_MAP["Principles of Flight"]="pof"

DIR_MAP["Instrumentation"]="022_Instrumentation"
CODE_MAP["Instrumentation"]="inst"

DIR_MAP["Radio Navigation"]="062_Radio_Navigation"
CODE_MAP["Radio Navigation"]="rnav"

DIR_MAP["Airframe, Systems, Electrics, Power Plant"]="021_Airframes"
CODE_MAP["Airframe, Systems, Electrics, Power Plant"]="asepp"

DIR_MAP["Operational Procedures"]="070_Operational_Procedures"
CODE_MAP["Operational Procedures"]="ops"

DIR_MAP["Mass & Balance"]="031_Mass_&_Balance"
CODE_MAP["Mass & Balance"]="mb"

DIR_MAP["Performance"]="032_Performance"
CODE_MAP["Performance"]="perf"

DIR_MAP["Flight Planning & Monitoring"]="033_Flight_Planning_&_Monitoring"
CODE_MAP["Flight Planning & Monitoring"]="flpm"

DIR_MAP["Knowledge, Skills and Attitudes (KSA)"]="100_KSA"
CODE_MAP["Knowledge, Skills and Attitudes (KSA)"]="ksa"

########################################
# CLEAR OLD SUBJECT TXT FILES
########################################

for CODE in met human gnav com alaw pof inst rnav asepp ops mb perf flpm ksa
do
find "$BASE" -name "${CODE}_study_log.txt" -delete
done

########################################
# PROCESS MASTER TXT
########################################

CURRENT_BLOCK=""
CURRENT_SUBJECT=""
GLOBAL_SESSION=""

while IFS= read -r LINE
do

# Detect new session
if [[ "$LINE" == "====================================" ]]; then

# Write previous block
if [ -n "$CURRENT_BLOCK" ] && [ -n "$CURRENT_SUBJECT" ]; then

DIR="${DIR_MAP[$CURRENT_SUBJECT]}"
CODE="${CODE_MAP[$CURRENT_SUBJECT]}"

TARGET="$BASE/$DIR/${CODE}_study_log.txt"

echo "$CURRENT_BLOCK" >> "$TARGET"

fi

CURRENT_BLOCK="===================================="$'\n'
CURRENT_SUBJECT=""
GLOBAL_SESSION=""

continue

fi

########################################
# Capture Global Session #
########################################

if [[ "$LINE" == Session* ]]; then

GLOBAL_SESSION=$(echo "$LINE" | sed 's/Session #: //')

continue

fi

########################################
# Capture Subject
########################################

if [[ "$LINE" == Subject:* ]]; then

CURRENT_SUBJECT=$(echo "$LINE" | sed 's/Subject: //')

continue

fi

########################################
# Capture Subject Session #
########################################

if [[ "$LINE" == "Subject Session"* ]]; then

CURRENT_BLOCK+="$LINE"$'\n'

# Insert Global Session underneath

if [ -n "$GLOBAL_SESSION" ]; then
CURRENT_BLOCK+="Global Session #: $GLOBAL_SESSION"$'\n'
CURRENT_BLOCK+=$'\n'
fi

continue

fi

########################################
# Append all remaining lines
########################################

CURRENT_BLOCK+="$LINE"$'\n'

done < "$TXT"

########################################
# Write final block
########################################

if [ -n "$CURRENT_BLOCK" ] && [ -n "$CURRENT_SUBJECT" ]; then

DIR="${DIR_MAP[$CURRENT_SUBJECT]}"
CODE="${CODE_MAP[$CURRENT_SUBJECT]}"

TARGET="$BASE/$DIR/${CODE}_study_log.txt"

echo "$CURRENT_BLOCK" >> "$TARGET"

fi

echo
echo "Subject TXT rebuild (with global context repositioned) complete."
