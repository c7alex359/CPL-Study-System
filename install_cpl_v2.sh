#!/usr/bin/env bash

# ==========================================
# CPL Study System Installer
# Version 2.2
# Linux + macOS Compatible
#
# Created by: c7alex359
# Licensed under GNU GPL v3.0
# ==========================================

echo
echo "=========================================="
echo "     CPL STUDY SYSTEM INSTALLER v2.2"
echo "=========================================="
echo

########################################
# Detect OS
########################################

OS_TYPE="$(uname)"

echo "Detected system: $OS_TYPE"

########################################
# Define Install Paths
########################################

BASE="$HOME/Documents/CPL/00_Admin/01_Execution"
LOGDIR="$BASE/logs"
ROOT="$HOME/Documents/CPL"

########################################
# Determine shell config file
########################################

if [ "$OS_TYPE" = "Darwin" ]; then

    SHELL_CONFIG="$HOME/.zshrc"
    echo "macOS detected → using ~/.zshrc"

else

    if [ -f "$HOME/.alias" ]; then
        SHELL_CONFIG="$HOME/.alias"
    else
        SHELL_CONFIG="$HOME/.bashrc"
    fi

    echo "Linux detected → using $SHELL_CONFIG"

fi

########################################
# Check nano availability
########################################

if ! command -v nano >/dev/null 2>&1; then

    echo
    echo "ERROR: nano is not installed."
    echo "Please install nano before continuing."
    echo
    exit 1

fi

########################################
# Create directory structure
########################################

echo
echo "Creating admin directory structure..."

mkdir -p "$LOGDIR"
mkdir -p "$BASE/config"

########################################
# Create Subject Directory Structure
########################################

echo
echo "Creating subject directories..."

mkdir -p "$ROOT/010_Air_Law"
mkdir -p "$ROOT/021_Airframes"
mkdir -p "$ROOT/022_Instrumentation"
mkdir -p "$ROOT/031_Mass_&_Balance"
mkdir -p "$ROOT/032_Performance"
mkdir -p "$ROOT/033_Flight_Planning_&_Monitoring"
mkdir -p "$ROOT/040_Human_Performance_&_Limitations"
mkdir -p "$ROOT/050_Meteorology"
mkdir -p "$ROOT/061_General_Navigation"
mkdir -p "$ROOT/062_Radio_Navigation"
mkdir -p "$ROOT/070_Operational_Procedures"
mkdir -p "$ROOT/081_Principles_of_Flight"
mkdir -p "$ROOT/090_Communications"
mkdir -p "$ROOT/100_KSA"

########################################
# Install main script
########################################

echo
echo "Installing CPL Study script..."

cp cpl_study_v15.sh "$BASE/"
cp config/subjects.db "$BASE/config/"
mapfile -t SUBJECT_LINES < "$BASE/config/subjects.db"

chmod +x "$BASE/cpl_study_v15.sh"

########################################
# Create logs if missing
########################################

echo
echo "Creating log files..."

touch "$LOGDIR/cpl_study_log.txt"
touch "$LOGDIR/cpl_study_log.csv"

########################################
# Add alias
########################################

ALIAS_LINE="alias cpl-study='$BASE/cpl_study_v15.sh'"

# Remove old CPL alias if present
sed -i '/alias cpl-study=/d' "$SHELL_CONFIG"

# Add fresh alias
echo "$ALIAS_LINE" >> "$SHELL_CONFIG"

echo "Alias updated in $SHELL_CONFIG"

########################################
# Interactive Focus Selection
########################################

echo
echo "=========================================="
echo " SUBJECT PRIORITIZATION SETUP"
echo "=========================================="
echo
echo "Select up to 5 focus subjects."
echo "These will appear in the main startup menu."
echo

for i in "${!SUBJECT_LINES[@]}"; do

SUBJECT_NAME=$(echo "${SUBJECT_LINES[$i]}" | cut -d'|' -f1)

echo "$((i + 1))) $SUBJECT_NAME"

done

echo
read -r -p "Enter focus subjects (example: 8 9 13): " FOCUS_SELECTION

PRIMARY_COUNT=$(echo "$FOCUS_SELECTION" | wc -w)
echo "$PRIMARY_COUNT" > "$BASE/config/primary_subject_count.conf"

ACTIVE_FILE="$BASE/config/active_subjects.conf"

> "$ACTIVE_FILE"

for NUM in $FOCUS_SELECTION; do

INDEX=$((NUM - 1))

SUBJECT_NAME=$(echo "${SUBJECT_LINES[$INDEX]}" | cut -d'|' -f1)

echo "$SUBJECT_NAME" >> "$ACTIVE_FILE"

done

for LINE in "${SUBJECT_LINES[@]}"; do

SUBJECT_NAME=$(echo "$LINE" | cut -d'|' -f1)

FOUND=0

for NUM in $FOCUS_SELECTION; do

INDEX=$((NUM - 1))
FOCUS_NAME=$(echo "${SUBJECT_LINES[$INDEX]}" | cut -d'|' -f1)

if [ "$SUBJECT_NAME" = "$FOCUS_NAME" ]; then
FOUND=1
break
fi

done

if [ "$FOUND" -eq 0 ]; then
echo "$SUBJECT_NAME" >> "$ACTIVE_FILE"
fi

done

########################################
# Finish
########################################

echo
echo "=========================================="
echo " INSTALLATION COMPLETE"
echo "=========================================="
echo

echo "Next steps:"

if [ "$OS_TYPE" = "Darwin" ]; then
    echo "Run: source ~/.zshrc"
else
    echo "Run: source ~/.bashrc"
fi

echo
echo "Then start the system with:"
echo
echo "cpl-study"
echo
