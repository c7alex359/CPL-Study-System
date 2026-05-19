==================================================
CPL Study System
CHANGELOG
==================================================

Created by:
c7alex359

Current Stable Version:
v14.3.2

==================================================
Version 15.5-dev
2026-05-17
==================================================

- Introduced post-session workflow orchestration layer
- Added post-session operational navigation menu
- Added Settings menu framework
- Added progression workflow entry points
- Introduced Log Maintenance terminology
- Preserved distraction-free startup workflow philosophy

- Added dynamic focus-subject reordering preview system
- Added runtime-aware subject priority rendering
- Added persistent runtime focus-subject reconfiguration
- Added duplicate-safe focus subject selection handling
- Added dynamic active_subjects.conf rewriting
- Added runtime persistence for primary menu sizing
- Added confirmation-based configuration mutation workflow
- Validated runtime reconfiguration through clean-user deployment testing

- Added completed_subjects.conf persistence foundation
- Added completed subject validation workflow
- Added duplicate-safe completed subject protection
- Added actual elapsed review-time accounting
- Refined explicit four-mode runtime handling symmetry
- Added post-session pacing confirmation step
- Improved completed-subject terminal redraw behavior

- Established architecture foundation for completion tracking
- Established architecture foundation for subject progression UX
- Added visual workflow separation using clear transitions

- Added centralized completion-aware subject rendering
- Added persistent checkmark-based progression indicators
- Established completed_subjects.conf as rendering authority
- Hardened completion-state persistence across subject reordering

- Added post-exam completion summary workflow
- Added remaining-exam progression tracking
- Added visibility-aware completed subject handling
- Added safe move-to-bottom progression ordering
- Added preview-confirmation workflow for visibility mutation

UX Impact:

Major — system workflow now extends beyond
session execution into long-term progression
and operational study management.

Architectural Impact:

Moderate — introduced persistent progression
and orchestration architecture without altering
stable runtime execution behavior.

Operational Status:

Stable development milestone — validated through
live session execution and workflow testing.

Known Development Observations:

- Session timing architecture now uses actual
  elapsed runtime duration rather than configured
  review allocation estimates

- Rapid first-run deployment testing exposed
  a possible session-counter initialization edge case
  during immediate sequential test sessions

==================================================
Version 15.4-dev
2026-05-15
==================================================

- Added dynamic primary subject menu sizing
- Removed final hardcoded primary menu assumptions
- Introduced primary_subject_count.conf runtime layer
- Installer now generates dynamic primary subject counts
- Runtime menu sizing now fully configuration-driven
- Added runtime fallback handling for missing count config
- Validated installer deployment through clean-user testing
- Refined installer alias replacement logic
- Improved installer idempotency during reinstallation
- Verified distribution tarball deployment workflow

Architecture Impact:

Major — completed transition from partially
dynamic subject handling to fully configurable
runtime menu orchestration.

Operational Status:

Stable development milestone — validated through
live runtime execution and clean-user installation
testing.

==================================================
Version 15.3-dev
2026-05-15
==================================================

- Introduced active_subjects.conf runtime configuration layer
- Implemented runtime-configurable subject prioritization
- Added dynamic subject partitioning architecture
- Removed hardcoded subject count assumptions
- Removed hardcoded primary-subject menu assumptions
- Added configurable PRIMARY_SUBJECT_COUNT runtime control
- Separated canonical subject metadata from operational state
- Standardized Communications naming across runtime architecture
- Added installer-driven active subject setup workflow
- Installer now generates personalized active_subjects.conf
- Established fully configuration-driven subject rendering system

Architecture Impact:

Major — runtime architecture generalized into
configuration-driven study workflow engine.

Operational Status:

Stable development milestone — validated through
live study sessions and runtime reordering tests.

==================================================
Version 15.1-dev
2026-05-14
==================================================

- Centralized subject metadata into config/subjects.db
- Replaced hardcoded subject menus with dynamic rendering
- Replaced hardcoded subject selection with dynamic lookup
- Established configuration-driven subject architecture foundation

==================================================
Version 14.3.2 (Stable)
2026-05-09
==================================================

- Introduced GNU GPL v3.0 licensing
- Added project authorship attribution
- Standardized script header formatting
- Standardized read prompts using read -r
- Removed deprecated NOTES_CSV architecture remnants
- Refined public release structure and metadata
- Minor internal cleanup and consistency improvements

--------------------------------------------------

Version 14.3.1 — Operational Stabilization 
& Logging Reliability
--------------------------------------------------

Release Date:
2026-04-28

Summary:

This version consolidates stability across the
multi-subject logging architecture and finalizes
operational behavior following live runtime testing.

Focus was placed on resolving edge cases in subject
log generation, preserving chronological integrity,
and validating long-session stability.

Key Improvements:

- Resolved subject CSV write failure
- Stabilized subject TXT log ordering behavior
- Verified subject session continuity
- Reinforced centralized logging reliability
- Improved nano launch readability (+1 second delay)
- Restored cursor visibility during input phases
- Preserved compatibility with existing logs
- Verified multi-review extension behavior

Operational Validation:

- Full-session runtime verified
- Momentum-session runtime verified
- Subject logging confirmed functional
- Multi-log architecture validated under live usage
- No arithmetic regressions detected

Architecture Impact:

Moderate — operational stabilization
of multi-log system behavior.

Operational Status:

Stable — declared production-ready
following successful live study sessions.

--------------------------------------------------

Version 14.2.2 — Focus Mode UI & Cursor Safety
--------------------------------------------------

Release Date:
2026-04-24

Summary:

Introduced distraction-free terminal behavior
during timed phases and added cursor recovery
safety to prevent terminal corruption after
unexpected interruption.

Key Improvements:

- Added automatic screen clearing between
  subject and mode transitions

- Introduced cursor hiding during timers
  (tput civis)

- Implemented Ctrl+C recovery trap to restore
  cursor visibility automatically

- Preserved compatibility with all timer and
  logging systems

Architecture Impact:

Low — UX refinement only.

Operational Status:

Stable — verified during live execution.

--------------------------------------------------

Version 14.2.1 — Secondary Menu Stability Refinement
--------------------------------------------------

Release Date:
2026-04-23

Summary:

Refined secondary subject menu return logic
to prevent unintended subject selection
when navigating back to primary subjects.

Key Improvements:

- Stabilized return path from additional
  subject menu

- Eliminated "Selected: Unknown" behavior

- Improved user navigation reliability

Architecture Impact:

Low — control flow correction.

Operational Status:

Stable — verified in live usage.

--------------------------------------------------

Version 14.2.0 — Subject-Level Logging System
--------------------------------------------------

Release Date:
2026-04-24

Summary:

Introduced decentralized subject-level logging
alongside the primary system log. Each subject
now maintains independent TXT and CSV logs,
allowing focused subject-specific review and
structured knowledge consolidation.

Key Improvements:

- Added subject-specific TXT logs
  stored inside subject directories

- Added subject-specific CSV logs
  tracking subject session progression

- Implemented automatic subject log
  creation if missing

- Added rebuild utilities to generate
  subject logs from historical master logs

- Preserved centralized master logging
  architecture

Architecture Impact:

High — multi-log system expansion.

Operational Status:

Major workflow milestone — verified functional.

--------------------------------------------------

Version 14.1.1 — Secondary Menu Return Fix
--------------------------------------------------

Release Date:
2026-04-23

Summary:

Resolved navigation issue in secondary
subject menu where entering "0" to return
to the main subject list resulted in
"Selected: Unknown".

Key Improvements:

- Implemented controlled script restart
  when exiting secondary subject menu
- Improved user navigation reliability
- Prevented unintended subject selection
  during menu return

Architecture Impact:

Minor — control flow stability improvement.

Operational Status:

Stable — verified through live testing.
--------------------------------------------------

Version 14.1.0 — Expandable Subject Interface
--------------------------------------------------

Release Date:
2026-04-23

Summary:

Introduced expandable subject menu enabling
full 14-subject syllabus support while
preserving clean primary subject focus.

Added safe return capability from secondary
subject menu to prevent accidental selection
errors and improve usability during real
study sessions.

Key Improvements:

- Added secondary subject expansion menu
  (0 → Show Additional Subjects)

- Implemented full subject set (6–14)

- Added "Back to Main Subjects" navigation
  with controlled script restart behavior

- Improved user flow reliability during
  subject selection

- Maintained compatibility with logging,
  session counting, and totals system

Architecture Impact:

Moderate — interface scalability achieved.

Operational Status:

Stable — verified in live CLI execution.

--------------------------------------------------

Version 14.0.1 — Study Mode UX Refinement
--------------------------------------------------

Release Date:
2026-04-23

Summary:

This version refines Study Mode usability by
introducing controlled pause capability during
Target Study phases and improving terminology
alignment for reflective learning workflows.

These changes improve interruption resilience
during study sessions while preserving strict
timing discipline for exam environments.

Key Improvements:

- Added pause functionality:
  p → pause Target Study phase
  r → resume Target Study phase
- Pause limited strictly to Target Study phases
- Preserved uninterrupted behavior in Exam Mode
- Renamed Foundation Mode review phase:
  "Error Review" → "Review New Insights"
- Renamed Foundation Mode header:
  "SESSION PERFORMANCE" → "SESSION NOTES"
- Preserved Full Session terminology consistency
- Maintained complete compatibility with logging
  and totals calculation systems

Architecture Impact:

Low — behavioral UX refinement only.

Operational Status:

Stable usability refinement — verified functional.

--------------------------------------------------

Version 14.0.0 — CSV Architecture Stabilization
--------------------------------------------------

Release Date:
2026-04-22

Summary:

This version introduces a structural redesign of
the CSV logging architecture by removing free-form
notes from CSV storage and relocating them exclusively
to the TXT logfile. This resolves long-standing data
integrity risks caused by comma-separated notes and
establishes a stable, maintainable logging model.

This release represents a major architectural milestone
and marks the transition from mixed-format logging to
clean structured data storage.

Key Improvements:

- Removed Notes field from CSV structure
- Established TXT logfile as exclusive notes repository
- Standardized CSV to numeric-only session metadata
- Rebuilt historical CSV data from authoritative TXT logs
- Unified subject naming consistency across legacy data
- Stabilized totals calculation reliability
- Eliminated CSV corruption risk from free-form text
- Introduced clean 12-column CSV schema
- Improved long-term maintainability and data safety

Architecture Impact:

High — foundational data model stabilization.

Operational Status:

Major stabilization release — new production baseline.
--------------------------------------------------

Version 13.6.2 — Totals Engine Restoration & Review Control
-----------------------------------------------------------

Release Date:
2026-04-20

Summary:

This version restores the proven totals
calculation engine from Version 12.5.1
and introduces controlled review-phase
interaction features.

Key Improvements:

- Restored subject total calculations
- Restored overall total calculations
- Reinstated stable time-format logic (xh ym)
- Added numeric countdown before timed phases
- Added Review controls:
  q → quit review early
  e → extend review by +10 minutes
- Restored nano line numbering (-l)
- Preserved CSV compatibility with mixed-format history
- Stabilized session arithmetic continuity

Operational Status:

Stabilization release — candidate production baseline.


--------------------------------------------------

Version 13.6.1 — Logging Repair & UX Restoration
------------------------------------------------

Release Date:
2026-04-20

Summary:

This version restores TXT logfile integrity,
reintroduces original nano usability behavior,
and corrects rounding and logging defects
identified during live testing.

Key Improvements:

- Restored TXT logfile writing stability
- Reintroduced Mode metadata into TXT entries
- Corrected exam-time rounding behavior
- Restored original nano launch instructions
- Fixed early-timer visual artifacts
- Maintained compatibility with historical CSV data

Operational Status:

Corrective release — transitional stability.



--------------------------------------------------

Version 13.6.0 — Metadata Logging & Accurate Timing
---------------------------------------------------

Release Date:
2026-04-20

Summary:

This version introduces extended session metadata
logging and ensures session totals use actual
exam duration rather than maximum allocated time.

Key Improvements:

- Added logging of session mode
- Added logging of question count
- Added logging of maximum exam time
- Added logging of actual exam time
- Ensured totals use actual exam time only
- Preserved nano Notes editor behavior
- Maintained progress-bar timer visualization
- Maintained backward compatibility with existing logs

Operational Status:

Stable — Pending validation during real study sessions.



--------------------------------------------------

Version 13.5.0 — Interruptible Exam Timer
---------------------------------------------------

Release Date:
2026-04-19

Summary:

Introduced interruptible exam functionality,
allowing early completion during timed exams.

Key Improvements:

- Added 'q' key support to finish exam early
- Recorded actual exam time used
- Maintained visual progress-bar timer
- Preserved workflow stability across all modes

Operational Status:

Stable functional upgrade.



--------------------------------------------------

Version 13.4.0 — Endurance Mode Implementation
---------------------------------------------------

Release Date:
2026-04-19

Summary:

Introduced dedicated Endurance Session mode
for extended exam simulation workflows.

Key Improvements:

- Added Endurance Session mode
- Implemented extended review phase
- Enabled dynamic exam configuration
- Preserved compatibility with existing workflow

Operational Status:

Stable mode expansion.



--------------------------------------------------

Version 13.3.0 — Momentum Mode Separation
---------------------------------------------------

Release Date:
2026-04-19

Summary:

Introduced Momentum Session mode
for short reinforcement exam workflows.

Key Improvements:

- Added Momentum Session mode
- Implemented short review phase
- Enabled fast-session capability
- Preserved timer and logging stability

Operational Status:

Stable feature expansion.



--------------------------------------------------

Version 13.2.0 — Dynamic Question Timing
---------------------------------------------------

Release Date:
2026-04-19

Summary:

Introduced dynamic exam duration calculation
based on configurable question count.

Key Improvements:

- Added configurable question input
- Implemented time-per-question calculation
- Enabled variable-length exam simulation

Operational Status:

Stable timing enhancement.



--------------------------------------------------

Version 13.1.0 — Mode Execution Branching
---------------------------------------------------

Release Date:
2026-04-19

Summary:

Implemented structured branching logic
for multi-mode session execution.

Key Improvements:

- Added execution routing per session mode
- Stabilized workflow transitions
- Maintained compatibility with existing features

Operational Status:

Stable internal architecture update.



--------------------------------------------------

Version 13.0.0 — Multi-Mode Session Engine
---------------------------------------------------

Release Date:
2026-04-19

Summary:

Introduced structured session mode
selection replacing the previous
linear workflow design.

Key Improvements:

- Added session mode selection menu
- Introduced Full Session workflow
- Introduced Foundation Session workflow
- Established mode-driven execution framework

Operational Status:

Major architecture upgrade.



==================================================
PREVIOUS STABLE RELEASES
==================================================


Version 12.5.1 — Indented Notes Restoration
---------------------------------------------

Release Date:
2026-04-18

Summary:

This version restores visual indentation of notes inside
the TXT logfile while preserving multi-line formatting
introduced in Version 12.5.

Key Improvements:

- Restored structured indentation for Notes section
- Preserved original multi-line formatting from nano
- Increased nano launch delay (3 → 5 seconds)
- Added improved spatial awareness inside nano editor
- Enabled clearer separation between notes and totals
- Maintained CSV safety and numeric integrity
- Preserved existing subject selection system
- Maintained full backward compatibility

Usability Impact:

This update significantly improves readability of
structured study notes, allowing aligned lists and
logical spacing to remain visually intact.

Operational Status:

Stable usability refinement release.



--------------------------------------------------

Version 12.4 — Nano Notes & Top-Entry Logging
---------------------------------------------------

Release Date:
2026-04-17

Key Features:

- Integrated multi-line Notes Editor using nano
- Added user guidance before editor launch:
  ("Ctrl+O to save, Ctrl+X to exit")
- Improved usability for detailed session reflection
- Implemented newest-first logging in TXT file
- Eliminated scrolling requirement to view latest session
- Preserved CSV compatibility with safe newline handling
- Maintained backward compatibility with existing logs

Structural Changes:

- TXT log writing method changed from append to prepend
- Introduced temporary entry handling for safe log insertion
- Updated script header with version tracking metadata

Operational Status:

Stable production version.



--------------------------------------------------

Installer Package — Version 1.1
---------------------------------------------------

Release Date:
2026-04-17

Key Features:

- Created first distributable CPL Study System package
- Added cross-platform installer (Linux + macOS compatible)
- Automatic OS detection using uname
- Automatic shell configuration detection:
  Linux → ~/.bashrc or ~/.alias
  macOS → ~/.zshrc
- Automatic directory creation during installation
- Automatic creation of log files
- Alias creation handled automatically
- nano availability check added

Purpose:

Enable external testing and simplified installation
on new machines.

Operational Status:

First external testing release.



==================================================
Future Versions (Conceptual)
==================================================

Version 14.0 — Subject Configuration System

Planned Features:

- subjects.cfg file
- Active subject filtering
- Passed subject marking
- Optional hiding of completed subjects
- Visual progress indicators

Architecture Impact:

High — structural redesign.


==================================================
LICENSE
==================================================

This project is licensed under the
GNU General Public License v3.0 (GPLv3).

See LICENSE for full details.
