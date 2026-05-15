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

cd CPL_Study_System_v15-dev

3. Run installer:
./install_cpl_v2.sh

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

------------------------------------------

Runtime Configuration Files:

The installer automatically creates:

config/active_subjects.conf
- Defines active subject ordering

config/primary_subject_count.conf
- Defines primary startup menu size

These files may be edited manually later
for personalized workflow adjustments.

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
