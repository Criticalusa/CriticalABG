---
phase: 01-foundation-domain-models
plan: 05
subsystem: core-models
requires: [01-01, 01-02, 01-03, 01-04]
provides: [ExamBlueprint, DifficultyMix, ExamSession, ExamStatus, SessionAnswer, ExamScore, TopicScore]
affects: [01-06, 02-*, 03-*]
tags: [foundation, models, exam, session, scoring]
tech-stack:
  added: []
  patterns: [lifecycle management, validation with typed errors, computed properties, factory methods]
key-decisions:
  - 84% passing threshold for ACLS exams per AHA guidelines
  - DifficultyMix presets for common exam configurations
  - ExamSession lifecycle with pause/resume support
  - Seed-based deterministic randomization for reproducibility
key-files:
  - Sources/ACLSCore/Models/ExamBlueprint.swift
  - Sources/ACLSCore/Models/ExamSession.swift
---

# Phase 01 Plan 05: Exam Models Summary

**Created comprehensive exam configuration and session tracking models.**

## Accomplishments

- Implemented ExamBlueprint as exam configuration model:
  - Topic weights for question distribution
  - DifficultyMix for difficulty proportions
  - Time limits (optional) and format restrictions
  - Tag-based filtering (require/exclude)
  - Validation with typed ValidationError enum
  - Preset factories: aclsPractice(), quickReview(), advancedPractice()

- Implemented DifficultyMix with:
  - Proportions for easy/medium/hard (sum to 1.0)
  - isValid validation
  - proportion(for:) and targetCount(for:total:) methods
  - Presets: balanced, beginner, advanced, easyOnly, hardOnly

- Implemented ExamSession with:
  - Complete lifecycle: notStarted → inProgress → paused → completed/abandoned
  - Question navigation (next, previous, moveTo by index/ID)
  - Answer recording with timestamp, time spent, and flag support
  - Pause/resume with accurate time tracking
  - currentQuestionID, progress percentage, remaining count

- Implemented SessionAnswer with:
  - selectedAnswerIDs for single/multi-select
  - orderedAnswerIDs for ordered-steps questions
  - answeredAt timestamp and timeSpentSeconds
  - flaggedForReview support

- Implemented ExamScore with:
  - 84% passing threshold (ACLS standard)
  - Topic breakdown via TopicScore
  - Difficulty breakdown
  - Computed: percentage, passed, letterGrade, formattedPercentage
  - simple(correct:incorrect:unanswered:) factory

- Added 14 new unit tests (55 total now passing)

## Files Created/Modified

- `Sources/ACLSCore/Models/ExamBlueprint.swift` - Exam configuration (343 lines)
- `Sources/ACLSCore/Models/ExamSession.swift` - Session tracking (553 lines)
- `Tests/ACLSCoreTests/ACLSCoreTests.swift` - Added comprehensive tests

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| 84% passing threshold | Matches official ACLS certification requirements |
| DifficultyMix presets | Common configurations for quick exam setup |
| Seed-based randomization | Enables reproducible exams for debugging/retakes |
| Pause time tracking | Ensures accurate active time measurement |
| Denormalized blueprintName | Enables history display without blueprint lookup |
| SessionAnswer immutable | Recreated on toggle to maintain Sendable conformance |

## Issues Encountered

None.

## Next Step

Ready for 01-06-PLAN.md (User Tracking Models)
