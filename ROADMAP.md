==================================================
CPL Study System — Development Roadmap
==================================================

Created by:
c7alex359

Stable Release:
v14.3.2

Current Development Branch:
v15.4-dev

Stable Release Status:
Production Stable — Multi-Log System Verified

Development Branch Status:
Stable Development Branch —
Configuration-Driven Runtime Architecture Verified

Installer Status:
Cross-user deployment validated
through clean-user installation testing

Current Development Focus:

- Completion workflow orchestration
- Subject progression management
- Post-session settings integration
- Runtime UX refinement

==================================================
v15.x ARCHITECTURAL TRANSITION
==================================================

Focus:

Transition from hardcoded subject handling
toward configuration-driven runtime behavior.

Core Targets:

v15.0
- Subject metadata registry
- Dynamic subject menu rendering
- Installer-based primary subject selection
- Config persistence layer

v15.1
- Internal refactoring and abstraction cleanup
- Runtime configuration validation
- Menu rendering helpers
- Reduced duplicated logic

v15.2
- Runtime subject reordering
- Passed-subject workflow management
- Dynamic priority adjustment
- Personalized progression flows

==================================================
COMPLETED PHASES
==================================================

Phase 1 — Usability Refinement
--------------------------------
Status: Completed

Achievements:

✔ Multi-line Notes via nano
✔ User instructions before editor launch
✔ Extended launch delay (3 → 5 sec)
✔ Latest entry at top of TXT log
✔ Reduced scrolling requirements
✔ Formatting preservation implemented
✔ Structured indentation restored
✔ Nano width-awareness enabled
✔ Multi-line CSV-safe logging
✔ Stable totals calculation verified

Result:

TXT logfile now supports structured,
readable, multi-line learning notes.


--------------------------------------------------

Phase 2 — Packaging & Deployment
--------------------------------
Status: Completed

Achievements:

✔ Installer script created
✔ Cross-platform compatibility added
✔ Linux tested (secondary user validation)
✔ macOS compatibility prepared
✔ Release packaging implemented
✔ Versioned distribution workflow established

Result:

System is now portable and externally deployable.


==================================================
CURRENT DEVELOPMENT PHASE
==================================================

Phase 3 — Study Management System
--------------------------------
Status: Completed

Sub-Phase 3A — Multi-Mode Session Engine
----------------------------------------
Status: Completed


Primary Objectives:

- Introduce structured session mode selection
- Replace linear workflow with mode-driven execution
- Implement dynamic exam configuration
- Support performance-paced exam simulation
- Preserve existing workflow stability

Planned Session Modes:

1) Study + Exam (Full Session)
   - Warm-up
   - Target Study
   - Exam (interruptible)
   - Error Review
   - Notes

2) Study Only (Foundation Session)
   - Warm-up
   - Target Study
   - Error Review
   - Notes

3) Exam Only (Momentum Session)
   - Variable question count
   - Dynamic maximum exam time
   - Early completion support
   - Short review phase
   - Notes

4) Exam Only (Endurance Session)
   - Extended question sets
   - Dynamic maximum exam time
   - Early completion support
   - Full review phase
   - Notes


Key Feature Additions:

✔ Mode selection interface
✔ Question-count-driven exam timing
✔ Dynamic maximum exam time calculation
✔ Interruptible exam timer (press 'q' to finish early)
✔ Actual exam time tracking
✔ Mode-aware session logging
✔ Question count logging
✔ Maximum vs Actual exam duration tracking


Logging Enhancements:

New CSV fields to be introduced:

- mode
- questions
- exam_max_minutes
- exam_actual_minutes

These additions enable:

- Speed tracking
- Efficiency analysis
- Performance pacing awareness
- Long-term trend visibility


Expected Outcome:

Flexible session workflows supporting:

- Deep learning cycles
- Rapid reinforcement sessions
- Realistic pacing simulations
- Mental endurance development

Recent Milestones Achieved:

✔ Multi-mode session architecture deployed
✔ Interruptible exam timer implemented
✔ Dynamic question-based timing active
✔ Mode-aware logging enabled
✔ Totals engine restored (v12.5 lineage)
✔ Review-phase interaction controls added
✔ CSV compatibility maintained
✔ TXT logging stability restored
✔ CSV architecture stabilized (v14.0.0)
✔ Notes removed from CSV (TXT-only notes model)
✔ Historical CSV rebuilt from TXT source
✔ Subject-level TXT logs implemented
✔ Subject-level CSV logs implemented
✔ Historical subject logs rebuilt
✔ Multi-subject directory logging active
✔ Focus-mode UI clearing implemented
✔ Cursor safety trap added (Ctrl+C recovery)
✔ Subject CSV write reliability verified
✔ Subject TXT chronological integrity stabilized
✔ Cursor visibility restored across session transitions
✔ Nano readability timing refined
✔ Multi-session runtime validation completed
✔ Version 14.3.2 declared operationally stable
----------------------------------------

Sub-Phase 3B — Dynamic Subject Configuration System
-------------------------------------------

Status: Major Architectural Transition Completed
(v15.0-dev → v15.4-dev)

Delivered:

✔ Centralized subject metadata registry
✔ Dynamic menu generation
✔ Configuration-driven subject rendering
✔ Runtime-configurable subject prioritization
✔ Installer-driven focus subject setup
✔ Dynamic primary subject partitioning
✔ Runtime-configurable menu sizing
✔ Active subject persistence layer
✔ Distribution deployment validation
✔ Clean-user installer validation
✔ Fully configuration-driven startup workflow

Architecture Result:

The CPL Study System transitioned from
hardcoded subject orchestration toward
fully configuration-driven runtime behavior.

Subjects now function primarily as:

- runtime metadata
rather than:
- embedded application logic

Core Runtime Layers:

subjects.db
- Canonical subject registry

active_subjects.conf
- Operational subject ordering

primary_subject_count.conf
- Dynamic startup menu partitioning

Result:

The runtime no longer depends on:
- fixed subject order
- fixed menu sizing
- hardcoded primary subject assumptions

This architecture enables:

- personalized study prioritization
- flexible startup workflows
- dynamic menu rendering
- future subject completion workflows
- scalable runtime extensibility

----------------------------------------

Sub-Phase 3C — Operational Stabilization
----------------------------------------

Status: Completed (v14.3.1)

Primary Objectives:

- Stabilize subject logging behavior
- Eliminate subject CSV write failures
- Preserve chronological TXT integrity
- Verify runtime stability across modes
- Confirm logging reliability under real usage

Delivered:

✔ Stable subject-level logging
✔ Reliable session continuation
✔ Cursor safety behavior validated
✔ Chronological log consistency preserved
✔ Multi-session validation completed

Result:

System transitioned from development
stability testing to production reliability.

----------------------------------------

Sub-Phase 3D — Completion & Progression Workflows
-------------------------------------------

Status: Planned

Primary Objectives:

- Subject completion workflow
- Optional subject hiding
- Completion-state persistence
- Runtime progression messaging
- Post-session settings integration
- Dynamic focus-subject reassignment
- Exam completion milestone UX

Expected Outcome:

Structured long-term progression system
supporting real-world exam completion
workflows and adaptive study prioritization.

==================================================

Phase 4 — Subject System Expansion

Status:
Completed (v14.2.0–14.3.2 stabilization)

Delivered:

- Multi-level subject selection
- Full syllabus accessibility
- Safe navigation recovery behavior
- Subject-level logging system
- Subject-specific TXT logs
- Subject-specific CSV logs
- Subject log rebuild utilities

Next Candidates:

- Subject priority ordering
- Optional subject hiding
- Subject completion tracking

==================================================
UPCOMING DEVELOPMENT PHASES
==================================================

Phase 5 — Reporting System
--------------------------------

Planned Features:

- Subject time summaries
- Daily totals
- Weekly totals
- Monthly totals
- Exam readiness indicators
- Subject workload balance insights

Expected Outcome:

Clear visibility into study progress
and workload distribution.


--------------------------------------------------

Phase 6 — User Workflow Customization
--------------------------------

Planned Features:

- Interactive settings menu
- Subject completion controls
- Dynamic subject hiding/restoration
- Runtime focus reassignment
- Custom timing profiles
- Personalized workflow presets
- User-adjustable startup behavior

Expected Outcome:

User-adaptive workflow initialization.


==================================================
LONG-TERM VISION
==================================================

Primary Goal:

CLI-based structured learning system
for professional-level exam preparation.

System Philosophy:

Build a stable, readable, and reliable
learning environment that supports:

- Timed study cycles
- Performance tracking
- Knowledge reinforcement
- Progressive mastery

Potential Future Extensions:

- Session statistics reporting
- Subject mastery visualization
- Study trend analysis
- Exportable performance summaries

==================================================
DEVELOPMENT PRINCIPLES
==================================================

Core Rules:

✔ Stability before complexity
✔ Preserve historical data
✔ Maintain readability
✔ Prefer incremental refinement
✔ Test before release
✔ Document before packaging

The system should remain:

- terminal-native
- lightweight
- offline-first
- dependency-light
- Bash-compatible

Configuration-driven behavior should
improve flexibility without introducing
unnecessary complexity or framework dependence.

==========================================
OPEN SOURCE DEVELOPMENT
==========================================

- Public GitHub repository maintenance
- Cross-distribution compatibility testing
- Improved installation portability
- Expanded session analytics and reporting
- Documentation and usability refinements

==================================================
LICENSE
==================================================

This project is licensed under the
GNU General Public License v3.0 (GPLv3).

See LICENSE for full details.
