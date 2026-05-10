#!/bin/bash

BASE="$HOME/Documents/CPL"
CSV="$BASE/00_Admin/01_Execution/logs/cpl_study_log.csv"

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
# HEADER
########################################

HEADER="subject_session,date,mode,questions,exam_max_minutes,exam_actual_minutes,score,confidence,mock_passed,session_minutes,subject_total_minutes"

########################################
# BUILD SUBJECT CSV FILES
########################################

tail -n +2 "$CSV" | while IFS=',' read -r \
g s date subj mode q max act score conf mock minutes
do

DIR="${DIR_MAP[$subj]}"
CODE="${CODE_MAP[$subj]}"

[ -z "$DIR" ] && continue

TARGET="$BASE/$DIR/${CODE}_study_log.csv"

mkdir -p "$BASE/$DIR"

if [ ! -f "$TARGET" ]; then
echo "$HEADER" > "$TARGET"
fi

########################################
# Compute running subject total
########################################

RUN_TOTAL=$(awk -F',' -v subj="$subj" -v ss="$s" '
$4==subj && $2<=ss {sum+=$NF}
END {print sum}
' "$CSV")

########################################
# Append row
########################################

echo "$s,$date,$mode,$q,$max,$act,$score,$conf,$mock,$minutes,$RUN_TOTAL" >> "$TARGET"

done

echo
echo "Subject CSV rebuild complete."
