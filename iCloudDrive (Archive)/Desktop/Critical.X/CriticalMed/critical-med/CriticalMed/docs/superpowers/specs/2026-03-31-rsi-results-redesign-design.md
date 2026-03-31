# RSI Results View Redesign — Design Spec

**Date:** 2026-03-31
**Scope:** Replace the UI layer of `RSIIResultDesignView.swift` with a single-scroll layout, unified colors, and glassmorphic medication cards. Keep calculation logic and data model untouched.
**File:** `CriticalX/Views/MainView/Home/RSII/RSIIResultDesignView.swift`

---

## 1. Goal

Replace the phase-tab swipe layout with a single continuous scroll of medication cards grouped by phase section dividers. Unify colors with the redesigned input screen using `CriticalDesign.Adaptive` and `navyAccent` (#2E4057) as the primary accent instead of bright blue.

## 2. Scope

**View replacement:** Rewrite all view structs in `RSIIResultDesignView.swift`.

**Untouched:**
- `RSIIValue` (ObservableObject with 51 @Published properties) — ugly but functional
- `rsiCalculation()` extension — same calculation logic, same UserDefaults reads
- `RSIIMainView.swift` — separate patch to fix blue color

## 3. Layout — Top to Bottom

### 3.1 Close Button
- Top-left, 40x40pt
- `xmark` SF Symbol, 16pt bold
- Background: `cardSurface` with subtle border
- Dismisses the full-screen cover via `isPresented` binding

### 3.2 Patient Header Card
- Compact glassmorphic card (not the old two-tone header)
- Left side: Weight display
  - Primary: "85 kg" — Poppins-Bold 28pt, textPrimary
  - Secondary: "187 lbs" — Poppins-Medium 14pt, textSecondary
- Right side: 7P's pill button (NavigationLink to `SevenPsbtnView()`)
  - "7P's" text in small capsule, navyAccent tint
- Background: `cardSurface`, gold stroke (dark) / navyAccent 0.1 stroke (light)
- Corner radius: 18pt

### 3.3 Medication Sections (3 groups, single scroll)

Each group:
1. `RSISectionDivider(title:)` — reuse from RSIIMainView
2. Vertical stack of `RSIMedicationCard` views

**Pre-Treatment (4 drugs):**
- Lidocaine: dose mg + mL (concentration: 20 mg/mL)
- Fentanyl: dose mcg + mL (concentration: 50 mcg/mL)
- Atropine: dose mg + mL (concentration: 0.4 mg/mL)
- Glycopyrrolate: dose mg + mL (concentration: 0.2 mg/mL)

**Induction Agents (4 drugs):**
- Ketamine: dose mg + mL (concentration: 100 mg/mL)
- Etomidate: dose mg + mL (concentration: 2 mg/mL)
- Propofol: dose mg + mL (concentration: 10 mg/mL)
- Midazolam: dose mg + mL (concentration: 5 mg/mL)

**Paralytic Agents (4 drugs):**
- Succinylcholine: dose mg + mL (concentration: 20 mg/mL)
- Rocuronium: dose mg + mL (concentration: 10 mg/mL)
- Vecuronium: dose mg + mL (concentration: 1 mg/mL)
- Cisatracurium: dose mg + mL (concentration: 2 mg/mL)

### 3.4 RSIMedicationCard Layout

```
┌──────────────────────────────────────────┐
│ [3pt colored left border]                │
│  [dot] Drug Name              170 mg     │
│                                1.7 mL    │
│                            (100 mg/mL)   │
└──────────────────────────────────────────┘
```

- Left border: 3pt rounded rectangle, phase color at 0.6 (dark) / 0.4 (light)
- Color dot: 8pt circle, phase color
- Drug name: Poppins-SemiBold 15pt, textPrimary
- Dose: Poppins-Bold 18pt, textPrimary, right-aligned
- mL: Poppins-Medium 13pt, textSecondary, right-aligned
- Concentration: Poppins-Regular 11pt, textTertiary, right-aligned, parenthesized
- Background: `cardSurface`
- Corner radius: 14pt
- Subtle border: phase color 0.1

### 3.5 Floating Weight Pill
- Appears when scroll offset > 120pt (same behavior as current)
- Restyled: capsule with `cardSurface` bg, shows "85 kg" in Poppins-SemiBold 13pt
- Appears at top with slide-down + opacity transition

### 3.6 Bottom Spacer
- `Spacer(minLength: 60)` for safe area clearance

## 4. Phase Colors (toned down from current)

| Phase | Color | Hex |
|-------|-------|-----|
| Pre-Treatment | Muted teal | `Color(red: 0.20, green: 0.55, blue: 0.52)` |
| Induction | Navy accent | `navyAccent` (#2E4057) |
| Paralysis | Muted coral | `Color(red: 0.68, green: 0.35, blue: 0.35)` |

## 5. Color Adaptation

All elements use `CriticalDesign.Adaptive`. No more `RSIColors` static struct.

| Element | Dark | Light |
|---------|------|-------|
| Canvas | `Adaptive.canvas` | `Adaptive.canvas` |
| Cards | `Adaptive.cardSurface` | `Adaptive.cardSurface` |
| Card border | gold gradient | navyAccent 0.08 |
| Close button bg | `cardSurface` | `cardSurface` |
| Header stroke | gold gradient | navyAccent 0.1 |
| Floating pill bg | `cardSurface` | `cardSurface` |

## 6. Animations

| Animation | Trigger | Spec |
|-----------|---------|------|
| Staggered card entrance | onAppear | Each card: opacity 0→1, offset y 15→0, delay increments by 0.05s per card, easeOut 0.4s |
| Floating pill | Scroll > 120pt | `.transition(.move(edge: .top).combined(with: .opacity))`, spring(0.4, 0.8) |
| Close button press | Tap | scaleEffect 0.9, spring |

## 7. Data Flow

```
@Binding var weightEntered: Double  (from RSIIMainView)
@Binding var isPresented: Bool      (dismiss sheet)
@ObservedObject var values: RSIIValue = RSIIValue()

onAppear → rsiCalculation()  (existing extension, reads UserDefaults, populates values)

values.ketamine_mg, values.ketamine_ml, etc. → displayed in cards
```

No changes to data flow. The `rsiCalculation()` extension and all 51 @Published properties stay as-is.

## 8. What's Removed (view structs only)

- `RSIColors` static struct
- `RSIResultBackground` view
- `TwoTonePatientHeader` view
- `PhaseTabButton` view
- `PhaseContentCard` view
- `MedicationRow` view (replaced by `RSIMedicationCard`)

## 9. What's Preserved

- `RSIIValue` ObservableObject (all 51 properties)
- `rsiCalculation()` extension
- UserDefaults settings integration
- NavigationLink to `SevenPsbtnView()`
- `TrackableScrollView` (for floating pill offset tracking)
- All 12 medications with their calculation logic

## 10. New Private Components

1. **`RSIMedicationCard`** — Single medication display card
2. **`RSIResultHeader`** — Compact patient weight header with 7P's link
3. **`RSIFloatingWeightPill`** — Scroll-triggered floating pill (restyled)

## 11. Blue Color Patch (RSIIMainView.swift)

Separate small edit: Replace bright `accentBlue` (#1098F7) with `navyAccent` (#2E4057) in:
- Weight text field foreground color
- Conversion text hint color → use `accentTeal` instead
- Calculate button gradient → navyAccent to darker navy
- Tag pill → navyAccent tint
- Weight toggle active segment → navyAccent

Keep `accentBlue` only where it was already used in the design system (e.g., dose chip borders use drug-specific colors, not accentBlue).
