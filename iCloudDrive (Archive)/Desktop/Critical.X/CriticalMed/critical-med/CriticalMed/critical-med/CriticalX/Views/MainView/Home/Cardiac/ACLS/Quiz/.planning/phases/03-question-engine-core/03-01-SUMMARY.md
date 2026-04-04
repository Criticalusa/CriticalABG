---
phase: 03-question-engine-core
plan: 01
type: summary
status: complete
---

# Phase 3: Question Engine Core - Summary

## Overview

Implemented the core question engine with seed-based reproducible randomization and comprehensive filtering capabilities. This phase delivers the foundation for exam generation with filtering by topic, difficulty, format, and user performance history.

## Files Created

### Sources/ACLSCore/Engine/QuestionFilter.swift (~336 lines)
Comprehensive filter criteria for question selection:
- **Content-based filters**: topics, difficulties, formats, tags
- **Performance-based filters**: missedOnly, dueForReview, minimumAttempts, maximumAccuracy, unseenOnly
- **TopicMatchMode enum**: `.any`, `.all`, `.primary` for flexible topic matching
- **Filter combining**: `combined(with:)` merges multiple filters
- **Presets**: `.all`, `.topics()`, `.missedQuestions()`, `.reviewDue()`, `.unseen()`

### Sources/ACLSCore/Engine/SeededRandomGenerator.swift (~176 lines)
Deterministic random number generator for reproducible exam generation:
- **xorshift64 algorithm**: Fast, high-quality randomness
- **Seed-based**: Same seed always produces same sequence
- **Array extensions**:
  - `shuffledWithSeed(using:)` - Reproducible shuffle
  - `randomElements(_:using:)` - Select N random elements
  - `randomElementWithSeed(using:)` - Select single element
  - `weightedRandomElements(_:weight:using:)` - Weighted selection

### Sources/ACLSCore/Engine/QuestionEngine.swift (~506 lines)
Core question retrieval system:
- **Initialization**: Builds TopicIndex and question lookup from questions
- **Core filtering**: `filter(_:)` and `filterIDs(_:)` for question selection
- **Selection with randomization**:
  - `select(count:filter:seed:)` - Random selection with optional seed
  - `select(blueprint:additionalFilter:)` - Blueprint-based selection
- **Performance analysis**:
  - `missedQuestions()` - Questions answered incorrectly
  - `questionsForReview()` - Spaced repetition due
  - `weakestTopics(limit:)` - Topics with lowest accuracy
  - `topicStatistics()` - Full topic performance data
- **Spaced repetition logic**: Intervals based on consecutive correct streak

## Files Modified

### Sources/ACLSCore/Models/ExamBlueprint.swift
Updated to use ACLSTopic instead of String:
- `topicWeights: [ACLSTopic: Double]` (was `[String: Double]`)
- `minimumPerTopic: [ACLSTopic: Int]?` (was `[String: Int]?`)
- `targetQuestions(for:)` now accepts ACLSTopic
- Added `requiredTopics: Set<ACLSTopic>` computed property

### Tests/ACLSCoreTests/ACLSCoreTests.swift
Added ~320 lines of tests covering:
- QuestionFilter creation, presets, and combining
- SeededRandomGenerator reproducibility
- QuestionEngine filtering by topic, difficulty, excluded IDs
- QuestionEngine selection with count and seed
- QuestionEngine performance-based filtering (missed, review)
- ExamBlueprint with ACLSTopic

## Key Design Decisions

### Filter Semantics
- **nil means any**: A nil value for a filter criterion means no restriction
- **Presets for common cases**: Static factory methods for readability
- **Combining filters**: Intersection semantics for multi-filter scenarios

### Spaced Repetition Algorithm
Simple interval-based system:
| Consecutive Correct | Review Interval |
|---------------------|-----------------|
| 0 (last incorrect)  | Immediately     |
| 1                   | 1 day           |
| 2                   | 3 days          |
| 3-4                 | 7 days          |
| 5+                  | 14 days         |

### Reproducible Randomization
- xorshift64 algorithm for fast, high-quality randomness
- Seed stored in ExamBlueprint for exam reproducibility
- Timestamp-based seed when no explicit seed provided

## Test Results

```
Test Suite 'All tests' passed
Executed 129 tests, with 0 failures (0 unexpected) in 0.013 seconds
```

New tests added:
- testQuestionFilterAllReturnsEverything
- testQuestionFilterTopicPreset
- testQuestionFilterDifficultyPreset
- testQuestionFilterMultipleTopics
- testQuestionFilterMissedQuestions
- testQuestionFilterExcluding
- testQuestionFilterCombining
- testQuestionFilterCodable
- testSeededRandomGeneratorReproducibility
- testSeededRandomGeneratorDifferentSeeds
- testArrayShuffledWithSeedReproducible
- testArrayRandomElementsWithSeed
- testQuestionEngineFilterAll
- testQuestionEngineFilterByTopic
- testQuestionEngineFilterByDifficulty
- testQuestionEngineFilterByExcludedIDs
- testQuestionEngineSelectRespectCount
- testQuestionEngineSelectWithSeedReproducible
- testQuestionEngineMissedQuestions
- testQuestionEngineQuestionsForTopic
- testQuestionEngineQuestionByID
- testQuestionEngineWeakestTopics
- testExamBlueprintWithACLSTopic
- testExamBlueprintTargetQuestions
- testExamBlueprintRequiredTopics
- testExamBlueprintWithACLSTopicWeightsCodable

## Verification Checklist

- [x] `swift build` succeeds without errors
- [x] `swift test` passes all 129 tests
- [x] Seed-based randomization is reproducible
- [x] All filter types work correctly
- [x] Performance-based filtering uses UserAnswer data
- [x] ExamBlueprint uses ACLSTopic

## Success Criteria Met

- [x] Questions can be filtered by any combination of criteria
- [x] Same seed always produces same question selection
- [x] "Missed previously" filter uses UserAnswer.lastAnsweredCorrectly
- [x] "Due for review" filter uses spaced repetition logic
- [x] ExamBlueprint can generate filtered question sets

## Next Steps

Phase 3 is complete. The Question Engine Core provides the foundation for:
- **Phase 4**: Exam management (ExamManager, exam session handling)
- **Phase 5**: Progress tracking and analytics

The engine is ready to power exam generation, study sessions, and adaptive learning features.
