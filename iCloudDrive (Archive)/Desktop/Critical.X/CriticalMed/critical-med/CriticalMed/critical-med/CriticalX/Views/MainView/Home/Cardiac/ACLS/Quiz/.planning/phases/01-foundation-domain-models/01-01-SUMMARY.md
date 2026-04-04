---
phase: 01-foundation-domain-models
plan: 01
subsystem: core-models
requires: []
provides: [Question, AnswerChoice, VitalsData]
affects: [01-02, 01-03, 01-04, 01-05, 01-06]
tags: [foundation, models, codable]
tech-stack:
  added: [Swift Package Manager, XCTest]
  patterns: [Codable structs, Identifiable, Sendable, factory methods]
key-decisions:
  - Used String placeholders for format/difficulty (defined in Plan 01-03)
  - VitalsData nested inside Question for cohesion
  - Denormalized isCorrect on AnswerChoice for convenience
key-files:
  - Sources/ACLSCore/Models/Question.swift
  - Sources/ACLSCore/Models/AnswerChoice.swift
  - Package.swift
---

# Phase 01 Plan 01: Project Setup & Question Model Summary

**Created Swift package foundation with comprehensive Question and AnswerChoice domain models.**

## Accomplishments

- Created ACLSCore Swift package with iOS 15+/macOS 12+ support
- Implemented Question struct with 18 properties covering clinical scenarios
- Implemented AnswerChoice struct with correct/incorrect tracking
- Created nested VitalsData struct with MAP calculation
- Added convenience factory methods (`.correct()`, `.incorrect()`)
- All models conform to Codable, Identifiable, Hashable, Sendable
- Added 6 unit tests verifying Codable round-trip and computed properties

## Files Created/Modified

- `Package.swift` - Swift package manifest (iOS 15+, macOS 12+, no dependencies)
- `Sources/ACLSCore/ACLSCore.swift` - Module entry point with documentation
- `Sources/ACLSCore/Models/Question.swift` - Core question model with VitalsData
- `Sources/ACLSCore/Models/AnswerChoice.swift` - Answer choice model
- `Tests/ACLSCoreTests/ACLSCoreTests.swift` - Unit tests for models

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| String placeholders for format/difficulty | These enums defined in Plan 01-03; avoids circular dependencies |
| VitalsData nested in Question | Conceptually belongs to Question, keeps related types together |
| Denormalized isCorrect on AnswerChoice | Convenience for UI display without needing to check Question.correctAnswerIDs |
| Set<UUID> for correctAnswerIDs | Natural representation for multi-select, efficient contains() |

## Issues Encountered

None.

## Next Step

Ready for 01-02-PLAN.md (Explanation & Reference Models)
