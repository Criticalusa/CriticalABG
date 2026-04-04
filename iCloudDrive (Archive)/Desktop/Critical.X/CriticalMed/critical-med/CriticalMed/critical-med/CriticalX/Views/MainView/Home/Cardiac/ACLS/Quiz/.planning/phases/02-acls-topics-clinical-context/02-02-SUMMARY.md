---
phase: 02-acls-topics-clinical-context
plan: 02
type: summary
---

# Summary: Clinical Topic Mapping

## Completed
Plan 02-02 executed successfully. All 3 tasks completed.

## Changes Made

### New Files
- `Sources/ACLSCore/Models/ClinicalTopicMapping.swift` (660 lines)

### Modified Files
- `Tests/ACLSCoreTests/ACLSCoreTests.swift` (+204 lines)

## Implementation Details

### TopicRelevance Struct

Represents the relevance of a topic to a clinical scenario:
- `topic: ACLSTopic` - The relevant topic
- `relevanceScore: Double` - Score from 0.0 to 1.0
- `reason: String` - Why this topic is relevant
- `isPrimary: Bool` - Whether this is the primary focus

Scoring guide:
- 1.0: Primary algorithm match (e.g., VF → vfPulselessVT)
- 0.9: Core supporting skill (e.g., BLS during arrest)
- 0.7: Secondary supporting topic
- 0.4: Tangentially related

Conforms to: Codable, Hashable, Sendable, Comparable

### ClinicalContext Extensions

New computed properties:
- `primarySuggestedTopic: ACLSTopic?` - The most likely primary topic
- `suggestedTopics: [ACLSTopic]` - All relevant topics in order
- `rankedTopics: [TopicRelevance]` - Topics with scores and reasons
- `topTopics(limit: Int) -> [TopicRelevance]` - Top N most relevant

Inference logic based on:
- **Rhythm**: VF→vfPulselessVT, asystole→peaAsystole, blocks→bradycardia, SVT→tachycardiaStable
- **Hemodynamics**: Pulseless→blsCPR, hypotension→hsAndTs
- **Airway**: Compromised→airwayManagement, hypoxia→hsAndTs
- **Medications**: Meds given→pharmacology, current meds→hsAndTs (toxins)

### RhythmType Extensions

- `associatedTopics: [ACLSTopic]` - Topics relevant to this rhythm
- `topicRelevances: [TopicRelevance]` - Scored topic relevances
- `isArrestRhythm: Bool` - Helper for arrest rhythm detection

### ACLSTopic Extensions

- `typicalRhythms: [RhythmType]` - Rhythms seen with this topic
- `isRhythmDependent: Bool` - Whether topic depends on rhythm

## Test Coverage

16 new tests added (103 total passing):
- VF context → vfPulselessVT (1)
- Asystole/PEA context → peaAsystole (2)
- Bradycardia context → bradycardia (1)
- Stable/unstable tachycardia context (2)
- Cardiac arrest includes BLS/CPR (1)
- Airway compromise includes airwayManagement (1)
- Post-ROSC context detection (1)
- TopicRelevance sorting and Codable (2)
- RhythmType.associatedTopics (1)
- ACLSTopic.typicalRhythms and isRhythmDependent (2)
- TopTopics limit (1)
- Medication context → pharmacology (1)

## Decisions Made

- **Scoring scheme**: 1.0 primary, 0.9 core supporting, 0.7 secondary, 0.4 tangential
- **Deduplication**: When multiple sources suggest same topic, keep highest score
- **Primary flag**: Used in Comparable to ensure primary topics sort first
- **Bidirectional mapping**: Both rhythm→topics and topic→rhythms supported

## Verification

```
swift build: Success (no warnings)
swift test: 103 tests, 0 failures
```

## Commits

1. `03da42a` docs(planning): add Phase 02 Plan 02 - Clinical Topic Mapping
2. `8cc6051` feat(core): add ClinicalTopicMapping for clinical-to-topic inference
3. `37c1fe2` test(core): add ClinicalTopicMapping tests
