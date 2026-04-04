---
phase: 01-foundation-domain-models
plan: 03
subsystem: core-models
requires: [01-01, 01-02]
provides: [Difficulty, QuestionFormat, Tag, TagCategory]
affects: [01-04, 01-05, 01-06, 02-*]
tags: [foundation, models, enums, classification]
tech-stack:
  added: []
  patterns: [CaseIterable enums, String raw values, factory methods, normalization]
key-decisions:
  - Difficulty uses weight-based scoring (1.0/1.5/2.0)
  - QuestionFormat has 5 types with timing suggestions
  - Tag is struct (not enum) for freeform values with normalization
  - TagCategory nested in Tag for grouping
key-files:
  - Sources/ACLSCore/Models/Difficulty.swift
  - Sources/ACLSCore/Models/QuestionFormat.swift
  - Sources/ACLSCore/Models/Tag.swift
---

# Phase 01 Plan 03: Difficulty, QuestionFormat, Tag Enums Summary

**Created classification types for questions and replaced String placeholders in Question.swift.**

## Accomplishments

- Implemented Difficulty enum with:
  - 3 cases: easy, medium, hard
  - weight property for scoring (1.0, 1.5, 2.0)
  - from(weight:) factory method
  - Comparable conformance
- Implemented QuestionFormat enum with:
  - 5 cases: singleChoice, multiSelect, orderedSteps, trueFalse, scenario
  - allowsMultipleAnswers, requiresOrdering properties
  - defaultTimeSeconds (30-180s based on format)
  - minimumChoices per format
- Implemented Tag struct with:
  - TagCategory nested enum (topic, medication, skill, condition, custom)
  - normalized() factory with string sanitization
  - Common tags: highYield, mustKnow, commonMistake
  - Category-specific factories: topic(), medication(), skill(), condition()
  - matches() for flexible comparison
- Updated Question.swift to use new types instead of String placeholders
- Added 14 new unit tests (27 total now passing)

## Files Created/Modified

- `Sources/ACLSCore/Models/Difficulty.swift` - Difficulty enum
- `Sources/ACLSCore/Models/QuestionFormat.swift` - QuestionFormat enum
- `Sources/ACLSCore/Models/Tag.swift` - Tag struct with TagCategory
- `Sources/ACLSCore/Models/Question.swift` - Updated to use new types
- `Tests/ACLSCoreTests/ACLSCoreTests.swift` - Added tests for new types

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Weight-based Difficulty scoring | Enables exam blueprint weighting without additional lookup |
| Difficulty implements Comparable | Allows sorting questions by difficulty |
| QuestionFormat timing suggestions | Provides baseline for exam duration calculations |
| Tag as struct not enum | Allows freeform tagging while maintaining normalization |
| TagCategory nested in Tag | Keeps related types together, avoids namespace pollution |
| Normalization removes special chars | Consistent matching regardless of input formatting |

## Issues Encountered

- Tag normalization for "/" produces removal not replacement (documented in test)

## Next Step

Ready for 01-04-PLAN.md (Clinical Context Models)
