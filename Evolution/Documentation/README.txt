==================================================
CPL Study System
User Guide
==================================================

Created by:
c7alex359

Current Stable Version:
v14.3.2

==================================================

Purpose:
This script supports structured CPL exam preparation
using timed study phases and structured reflection.

Core Workflow:

1. Select subject
   (primary or additional subjects available)
2. Select session mode
3. Complete study phases:
   - Warm-up
   - Target Study
   - Exam Mode (optional)
   - Error Review
4. Enter performance metrics
5. Record reflection notes
6. Session stored automatically

==========================================

License
--------------------------------

This project is licensed under the
GNU General Public License v3 (GPLv3).

See LICENSE for full details.

==========================================
QUICK START
==========================================

1. Extract package:

tar -xzf CPL_Study_System_v2.0.tar.gz

2. Enter directory:

cd CPL_Study_System_v2.0

3. Run installer:

./install_cpl_v2.sh

4. Reload your shell configuration.

Linux:

source ~/.bashrc

(or source ~/.alias if your system uses ~/.alias)

macOS:

source ~/.zshrc

5. Start system:

cpl-study

==========================================
NOTES EDITOR (NANO)
==========================================

The CPL Study System includes a multi-line
Notes editor powered by nano.

When the Notes editor launches:

- A short delay allows preparation
- Cursor position is displayed
- Approximate writing width is 100 characters
- Multi-line formatting is preserved
- Indentation and alignment are supported

Writing Guidelines:

- Use short structured lines when possible
- Lists and spacing are preserved
- Avoid extremely long lines (>100 characters)

Saving Notes:

Ctrl + O → Save
Enter    → Confirm
Ctrl + X → Exit editor

Formatting Behavior:

All notes are stored:

TXT logfile:
- Preserves spacing
- Preserves indentation
- Displays newest entries at top

CSV logfile:
- Stores structured numeric session data only
- Contains no free-form notes
- Ensures long-term calculation stability
- Includes subject-level CSV tracking

Notes are stored exclusively in the TXT logfile.
This separation prevents CSV corruption caused
by commas or free-form text.

This allows structured note-taking while
maintaining full compatibility with statistics.

Data Storage:

TXT Log:
Readable history of sessions.

CSV Log:
Structured numeric data for totals
and long-term performance tracking.

Key Features:

- Automatic time tracking
- Subject-specific totals
- Overall totals
- Study-only mode support
- Reliable session numbering

Version Control:

Historical versions may be archived separately
for rollback and version tracking.

==========================================
SESSION MODES
==========================================

The CPL Study System supports multiple
session formats designed to simulate
real exam preparation workflows.

Available Modes:

1) Study + Exam (Full Session)

   Includes:

   - Warm-up Phase
   - Target Study Phase
   - Exam Mode
   - Error Review Phase
   - Notes Reflection

   Purpose:

   Structured full learning cycle
   combining knowledge building
   and performance validation.


2) Study Only (Foundation Session)

   Includes:

   - Warm-up Phase
   - Target Study Phase
   - Error Review Phase
   - Notes Reflection

   Purpose:

   Reinforce theoretical understanding
   without exam pressure.


3) Exam Only (Momentum Session)

   Includes:

   - Variable question exam
   - Interruptible timer
   - Short review phase
   - Notes Reflection

   Purpose:

   Fast reinforcement testing
   and rapid performance feedback.


4) Exam Only (Endurance Session)

   Includes:

   - Extended question exam
   - Interruptible timer
   - Full-length review phase
   - Notes Reflection

   Purpose:

   Build exam stamina and
   mental endurance under load.


==========================================
INTERRUPTING EXAM MODE
==========================================

During Exam Mode:

Press:

q

To finish the exam early.

The system will:

- Record actual time used
- Continue to review phase
- Log real performance time

This supports realistic pacing
and performance training.

==========================================
REVIEW PHASE CONTROLS
==========================================

During Review Phase:

Press:

q

To finish the review early.

Press:

e

To extend the review by +5 minutes.

This allows flexible reinforcement time
while preserving accurate session totals.

==========================================
COUNTDOWN BEHAVIOR
==========================================

Before timed phases begin,
a short numeric countdown is displayed.

Example:

Starting in: 4 3 2 1

This provides preparation time
without distracting visual messages.

==========================================
DATA STORAGE ARCHITECTURE
==========================================

The CPL Study System separates structured
data from free-form notes.

TXT Log:
- Contains full session history
- Stores multi-line notes
- Human-readable format

CSV Log:
- Contains structured numeric session data
- Used for totals and performance tracking
- Does not store notes

This architecture improves long-term
data reliability and prevents formatting
errors caused by free-form text.

==========================================
SUBJECT-SPECIFIC LOGS
==========================================

Each subject maintains its own
independent study history.

In addition to the central logs,
the system automatically creates:

Subject TXT Logs:
- Stored inside each subject directory
- Contain full session notes
- Preserve chronological study history
- Allow focused subject review

Subject CSV Logs:
- Track structured subject session data
- Maintain subject session numbering
- Record subject-specific totals
- Support long-term subject tracking

This design allows:

- Focused review of individual subjects
- Reduced distraction from unrelated material
- Clear subject-specific learning continuity
- Structured long-term subject progression

==========================================
SYSTEM STABILITY STATUS
==========================================

Current Version:

v14.3.2

Status:

Operationally stable and verified
through live study execution.

This version represents a
production-ready multi-subject study system
with stable logging and session control.

==================================================
LICENSE
==================================================

This project is licensed under the
GNU General Public License v3.0 (GPLv3).

See LICENSE for full details.
