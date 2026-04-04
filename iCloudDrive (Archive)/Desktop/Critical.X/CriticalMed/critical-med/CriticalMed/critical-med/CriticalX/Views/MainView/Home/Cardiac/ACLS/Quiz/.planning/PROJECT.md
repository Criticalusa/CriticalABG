# ACLS 2025 Test Prep

## What This Is

A production-grade Swift data layer for an iOS ACLS certification test prep app. Provides question bank, exam sessions, study modes, progress tracking, and analytics — all offline-first, JSON-driven, and UI-agnostic. Designed to plug into any SwiftUI or UIKit interface.

## Core Value

Comprehensive, AHA 2025-aligned question bank with verified content that helps users conceptualize and pass the ACLS examination.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Domain models (Question, AnswerChoice, Explanation, Topic, Difficulty, ExamSession, ProgressSnapshot, etc.)
- [ ] Question engine with seed-based randomization, filtering, and scoring logic
- [ ] JSON-first content structure with schema, loader, and validation
- [ ] Local persistence for sessions, per-question performance, and mastery tracking
- [ ] Thin API/service layer for UI integration (getQuestions, startExam, submitAnswer, etc.)
- [ ] ACLSTopic enum covering all ACLS algorithm categories
- [ ] Dosing & calculation utilities (weight conversion, adult standard doses)
- [ ] Unit tests for loader validation, scoring, and deterministic shuffling
- [ ] Research and populate verified question bank (100+ questions across all topics)
- [ ] Algorithm cards for core ACLS algorithms (VF/pVT, PEA/Asystole, Brady, Tachy, Post-ROSC)
- [ ] Flashcards for medication dosing and sequences

### Out of Scope

- Cloud sync / user accounts — local-only for v1, keeps architecture simple
- Spaced repetition algorithm — basic "missed questions" review queue only, no SRS complexity
- UI code — data layer only, UI built separately
- macOS / watchOS / visionOS — iOS only for v1
- PALS (Pediatric) — adult ACLS focus, pediatric could be v2

## Context

**Content Sources**: AHA 2025 ACLS guidelines are the authoritative source. Questions must align with current algorithms, drug dosing, and decision trees. Research phase will gather content from:
- AHA ACLS Provider Manual (2025)
- Online ACLS practice exams and simulations
- Published ACLS study guides

**Architecture Philosophy**: Offline-first with JSON bundles means content can be updated without code changes. The engine is deterministic (seed-based) for reproducible exams and debugging.

**Target Market**: Healthcare professionals (nurses, paramedics, physicians, med students) preparing for ACLS certification or recertification.

## Constraints

- **Tech Stack**: Swift 5.9+, iOS only, no external dependencies beyond Foundation
- **Guidelines**: Must align with AHA 2025 ACLS guidelines specifically
- **Architecture**: Value types (structs) preferred, Codable throughout, modular design
- **Content**: Clinical text editable via JSON, utilities are generic
- **Testing**: XCTest for unit tests, architecture must be testable

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| JSON-first content | Allows content updates without code changes, easier collaboration on questions | — Pending |
| Local persistence only | Simplifies v1, no backend needed, offline-first UX | — Pending |
| Seed-based randomization | Reproducible exams for testing and debugging | — Pending |
| No spaced repetition | Reduces complexity, basic review queue sufficient for v1 | — Pending |
| Partial credit for multi-select | Defined scoring rules for complex question types | — Pending |

---
*Last updated: 2026-01-17 after initialization*
