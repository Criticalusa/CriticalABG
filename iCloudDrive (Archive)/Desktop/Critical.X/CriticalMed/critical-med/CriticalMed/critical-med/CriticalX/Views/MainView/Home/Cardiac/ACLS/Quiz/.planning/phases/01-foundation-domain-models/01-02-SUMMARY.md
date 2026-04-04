---
phase: 01-foundation-domain-models
plan: 02
subsystem: core-models
requires: [01-01]
provides: [Explanation, Reference, ReferenceSource]
affects: [01-04, 01-05, 02-*, 03-*]
tags: [foundation, models, codable, educational-content]
tech-stack:
  added: []
  patterns: [custom Codable for associated values, computed properties, factory methods]
key-decisions:
  - Custom Codable implementation for ReferenceSource enum with associated values
  - Reference includes formattedCitation computed property for display
  - Explanation tracks "richness" as educational content metric
key-files:
  - Sources/ACLSCore/Models/Explanation.swift
  - Sources/ACLSCore/Models/Reference.swift
---

# Phase 01 Plan 02: Explanation & Reference Models Summary

**Created comprehensive educational content models for explanations and guideline citations.**

## Accomplishments

- Implemented Explanation struct with educational content properties:
  - correctRationale and incorrectRationales (per-answer UUID mapping)
  - keyPoint, commonPitfalls, clinicalPearl, mnemonicTip
  - relatedTopics for cross-referencing
  - `richness` computed property counting educational elements
- Implemented ReferenceSource enum with:
  - Simple cases: .aha, .erc, .ilcor
  - Associated value cases: .textbook(name:), .journal(name:), .other(description:)
  - Custom Codable implementation handling associated values
  - displayName and abbreviation computed properties
- Implemented Reference struct with:
  - Full citation metadata (title, section, page, year, URL)
  - formattedCitation computed property for display
  - `aha2025ACLS(section:page:)` factory method
- Added 7 new unit tests (13 total now passing)
- All models conform to Codable, Identifiable, Hashable, Sendable

## Files Created/Modified

- `Sources/ACLSCore/Models/Explanation.swift` - Educational explanation model
- `Sources/ACLSCore/Models/Reference.swift` - Citation model with ReferenceSource enum
- `Tests/ACLSCoreTests/ACLSCoreTests.swift` - Added tests for new models

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Custom Codable for ReferenceSource | Swift enums with associated values don't auto-synthesize Codable; manual implementation ensures clean JSON |
| `richness` property on Explanation | Quantifies educational value for content quality metrics |
| formattedCitation as computed property | Avoids storing redundant data, always reflects current values |
| Factory method for AHA 2025 | Reduces boilerplate for the most common reference type |

## Issues Encountered

None.

## Next Step

Ready for 01-03-PLAN.md (Difficulty, QuestionFormat, Tag Enums)
