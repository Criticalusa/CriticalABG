# Natural Language Moment Search

A SwiftUI feature that accepts messy natural language clinical queries and returns Moment Cards with computed doses.

## Files Overview

### Models (`Models/NLSearch/`)
- **ParsedQuery.swift** - Extracted entities from natural language
- **NLMoment.swift** - Protocol + 2 sample moment implementations
- **MomentOutput.swift** - Computed output for display

### Logic (`Logic/`)
- **QueryParser.swift** - Regex entity extraction + synonym expansion
- **NLMomentRegistry.swift** - Moment registry + scoring matcher

### Views (`Views/NLMomentSearch/`)
- **NLMomentSearchView.swift** - Main search interface
- **NLMomentSearchVM.swift** - ViewModel with Combine debounce
- **ParsedChipRow.swift** - Entity chips display
- **NLMomentCard.swift** - Moment result card
- **WeightInputSheet.swift** - Quick weight entry

## Adding to Xcode Project

1. Open `Critical Med.xcworkspace`
2. Right-click on the appropriate group in the Project Navigator
3. Select "Add Files to CriticalX..."
4. Navigate to and select all the new Swift files
5. Ensure "Copy items if needed" is unchecked (files are already in place)
6. Ensure target "CriticalX" is checked
7. Click Add

### Files to Add:
```
Models/NLSearch/
  - ParsedQuery.swift
  - NLMoment.swift
  - MomentOutput.swift

Logic/
  - QueryParser.swift
  - NLMomentRegistry.swift

Views/NLMomentSearch/
  - NLMomentSearchView.swift
  - NLMomentSearchVM.swift
  - ParsedChipRow.swift
  - NLMomentCard.swift
  - WeightInputSheet.swift
```

## Usage

Present the search view from anywhere in the app:

```swift
import SwiftUI

struct SomeView: View {
    @State private var showMomentSearch = false
    
    var body: some View {
        Button("Search Moments") {
            showMomentSearch = true
        }
        .sheet(isPresented: $showMomentSearch) {
            NLMomentSearchView()
        }
    }
}
```

## Extending

### Adding New Drug Synonyms

Edit `QueryParser.swift`:

```swift
private let drugSynonyms: [String: String] = [
    // Add your synonym → canonical name
    "vaso": "vasopressin",
    // ...
]
```

### Adding New Moments

1. Create a struct conforming to `NLMoment` protocol
2. Implement `matchScore()` and `compute()`
3. Register in `NLMomentRegistry.allMoments`

```swift
struct NewMoment: NLMoment {
    let id = "new_moment"
    let title = "New Moment"
    let kind = NLMomentKind.drugDose
    let tags = ["tag1", "tag2"]
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        // Return 0 for no match, higher = better match
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Calculate and return output
    }
}
```

Then in `NLMomentRegistry.swift`:

```swift
private(set) var allMoments: [NLMoment] = [
    PediatricVFEpinephrineMoment(),
    PostROSCNorepinephrineMoment(),
    NewMoment()  // Add here
]
```

## Clinical Disclaimers

All dosing constants are marked with:
```
// TODO: Replace with vetted constants - NOT medical advice
```

This feature is for educational reference only. All calculations must be verified by qualified medical professionals before clinical use.
