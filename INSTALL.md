==========================================
CPL Study System — Installation Guide

Created by:
c7alex359

==========================================

Supported Platforms:

- Linux (Ubuntu, openSUSE, Debian, Fedora)
- macOS (tested with zsh shell)

Requirements:

- bash
- nano
- terminal access

------------------------------------------

Installation Steps:

1. Open terminal

2. Navigate to this folder:

cd CPL_Study_System_v15.7.6

3. Run installer:
./install_cpl.sh

Installer Setup Workflow:

During installation the system will:

- Create CPL study directory structure
- Generate runtime configuration files
- Ask which subjects should be prioritized
- Create personalized startup menu behavior
- Configure shell alias integration

The installer now supports
configuration-driven subject prioritization.

4. Reload your shell configuration.

Linux:
source ~/.bashrc

(or source ~/.alias if your system uses ~/.alias)

macOS:

source ~/.zshrc

5. Start system:

cpl-study

View study logs anytime with:

cpl-log

------------------------------------------

Runtime Configuration Files:

The installer automatically creates:

config/active_subjects.conf
- Runtime subject ordering

config/primary_subject_count.conf
- Main startup menu size

config/completed_subjects.conf
- Completed-exam persistence

config/hidden_subjects.conf
- Visibility-state persistence

config/timer_mode.conf
- DEFAULT / SPEED pacing mode

config/previous_study_minutes.conf
- Integrated historical study totals

------------------------------------------

If something fails:

Send error message output
to the script author

==================================================
LICENSE
==================================================

This project is licensed under the
GNU General Public License v3.0 (GPLv3).

See LICENSE for full details.
