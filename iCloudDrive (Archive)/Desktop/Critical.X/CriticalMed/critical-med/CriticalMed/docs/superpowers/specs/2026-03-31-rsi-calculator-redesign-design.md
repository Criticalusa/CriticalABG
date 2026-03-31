# RSI Calculator Redesign — Design Spec

**Date:** 2026-03-31
**Scope:** Replace `RSIIMainView.swift` with an upgraded version featuring live dose previews, micro-animations, glassmorphic styling, and full light/dark adaptive support.
**File:** `CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift`

---

## 1. Goal

Make the RSI calculator the most elegant, clinically useful screen in CriticalMed. Add real-time dose feedback, micro-animations that convey life and polish, and a premium glassmorphic aesthetic — while preserving all existing clinical content and integrations.

## 2. Scope

**Single file replacement:** `RSIIMainView.swift` (and its local helper views: `RSILightBackground`, `RSISectionDivider`, `RSICheckmarkView`, `RSICheckmarkShape`).

**No new files.** All new components are private structs within the same file.

**Untouched:**
- `RSIIResultDesignView.swift` (results sheet)
- `RSIIDataModel.swift` (data model)
- Settings views (`SettingView`, `PretreatmentSettingView`, etc.)
- `RSIIView.swift` (legacy view)
- All shared components (`IconTabBar`, `CriticalFavoriteButton`, neumorphic styles)

## 3. Layout — Top to Bottom

### 3.1 Header Bar
- Reset button (left) — `arrow.counterclockwise.circle.fill`, neumorphic icon style
- Settings link (right) — gear icon + "Settings" text in capsule, NavigationLink to `SettingView`
- Same as current, cleaner spacing (no extra Spacer)

### 3.2 Hero Section — Conic Ring Icon
- **Spinning conic-gradient ring** around lungs icon
  - Outer: `AngularGradient` (blue → teal in light, goldMid → goldDeep in dark) on a Circle stroke (4pt)
  - Rotation: `@State private var ringAngle: Double = 0`, animated with `.linear(duration: 6).repeatForever(autoreverses: false)`
  - Inner: 80pt circle with `cardSurface` fill, 1.5pt stroke
  - Icon: `lungs.fill` at 28pt, gradient foreground matching ring
- **Pulse rings on appear** — two concentric circles that scale 0.8→1.4 with opacity fade, 2s infinite, 1s stagger between them. Disappear after 4 seconds (set opacity to 0).
- Title: "Rapid Sequence Intubation" — Poppins-Bold 26pt
- Subtitle tag pill: "Weight-Based Dosing" — 11pt, capsule background with blue/teal gradient tint, border

### 3.3 IconTabBar (existing component, no changes)
- 3 sections: "When to Use", "Key Points", "Clinical Use"
- Passed via `infoSections` array (same content as current)
- Padding: `.padding(.horizontal, 20)`

### 3.4 Section Divider — "Patient Data"
- Existing `RSISectionDivider` component, no changes

### 3.5 Weight Input Card (glassmorphic)

**Card container:**
- Background: `CriticalDesign.Adaptive.cardSurface(for: colorScheme)`
- Corner radius: 24pt continuous
- Border: gold gradient (dark) / subtle accent 0.15 (light), 1pt
- Shadow: darkCanvas 0.4 / black 0.04, radius 12
- Padding: 24pt internal

**Header row:**
- Left: "Patient Weight" label — Poppins-SemiBold 12pt, uppercase, tracking 1.5, `textMuted` color
- Right: **kg/lbs toggle**
  - Two-segment capsule (background: white 0.06 dark / gray 0.08 light)
  - Active segment: blue fill with white text, rounded, slides with `spring(0.35, 0.7)`
  - Inactive: muted text
  - On tap: converts weight value bidirectionally, updates `patientContext.weightUnit`, haptic feedback

**Weight display:**
- TextField: 48pt bold system rounded font, primary text color
  - Placeholder: "85"
  - `.keyboardType(.decimalPad)`
  - `.focused($focusedField, equals: .weight)`
- Unit label: "kg" or "lbs" — Poppins-Medium 18pt, `textSecondary`
- Live conversion: "~187 lbs" or "~85 kg" — Poppins-Medium 13pt, teal/green color

**Live dose preview chips** (horizontal ScrollView):
- 4 chips in a row: Ketamine, Etomidate, Succinylcholine, Rocuronium
- Each chip:
  - Background: white 0.04 dark / white 0.5 light
  - Border: white 0.06 dark / gray 0.12 light
  - Corner radius: 12pt
  - Padding: 10pt horizontal, 10pt vertical
  - Drug name: 10pt bold uppercase, color-coded (green, blue, orange, red)
  - Dose: 16pt bold white/primary + "mg" 10pt muted
- Computed from `weightField`:
  - Ketamine: `weight * 2.0` mg
  - Etomidate: `weight * 0.3` mg
  - Succinylcholine: `weight * 1.5` mg
  - Rocuronium: `weight * 1.2` mg
- Show "—" when weight is empty or invalid
- **Stagger animation:** On weight change, each chip slides in from 10pt right with incremental 0.05s delay, `spring(0.4, 0.75)`

### 3.6 Helper Text
- Lightbulb icon (11pt, accentGreen) + text "Use actual body weight for accurate medication dosing" (Poppins-Regular 12pt, accentGreen)
- Same as current

### 3.7 Calculate Button (shimmer)
- Full-width, 16pt vertical padding
- Background: blue gradient (`accentBlue` to darker blue)
- Corner radius: 14pt continuous
- Text: "Calculate Medications" — Poppins-Bold 18pt white
- Right icon: `arrow.right.circle.fill` 20pt white
- **Shimmer overlay:** LinearGradient (transparent 30% → white 0.15 at 50% → transparent 70%) translating from -100% to +100% on a 3s ease-in-out infinite loop using `GeometryReader` + `offset`
- Shadow: blue 0.3 at radius 10 (dark uses darkCanvas 0.5)
- **Press animation:** `scaleEffect(configuration.isPressed ? 0.96 : 1)` with `spring(0.3, 0.7)` — use `ButtonStyle`

### 3.8 Quick Reference Cards (2x2 grid)
- Section header: "Quick Reference" with doc.text.fill icon (same as current header style)
- **Grid:** `LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10)`
- 4 cards:

| Drug | Phase | Dose | Onset | Color |
|------|-------|------|-------|-------|
| Ketamine | Induction | 1-2 mg/kg IV | 45-60 sec | accentGreen |
| Etomidate | Induction | 0.3 mg/kg IV | 30-60 sec | accentBlue |
| Succinylcholine | Paralytic | 1.5 mg/kg IV | 45-60 sec | accentOrange |
| Rocuronium | Paralytic | 1.2 mg/kg IV | 60-90 sec | accentRed |

- Each card:
  - Background: `cardSurface`
  - Border: white 0.06 dark / gray 0.08 light
  - Corner radius: 14pt
  - Padding: 14pt
  - Phase dot (6pt circle, drug color) + phase label (9pt uppercase)
  - Drug name: 14pt Poppins-SemiBold, near-white/primary
  - Dose: 12pt, tertiary
  - Onset: 10pt, muted, with clock icon

### 3.9 Bottom Spacer
- `Spacer(minLength: 100)` for scroll clearance

## 4. Animations

| Animation | Trigger | Implementation |
|-----------|---------|---------------|
| Staggered fade-in | `onAppear` | Each section: `opacity(isAppearing ? 1 : 0).offset(y: isAppearing ? 0 : N)` where N increases 20→45. Single `withAnimation(.easeOut(duration: 0.6))` |
| Conic ring spin | `onAppear` | `@State ringAngle` from 0 to 360, `.rotationEffect(.degrees(ringAngle))`, `.linear(duration: 6).repeatForever(autoreverses: false)` |
| Pulse rings | `onAppear` | Two Circle overlays, scale 0.8→1.4 + opacity 1→0, 2s infinite, stagger 1s. Auto-hide after 4s. |
| kg/lbs toggle slide | Tap | Capsule indicator position animated with `spring(0.35, 0.7)`, haptic |
| Dose chip stagger | Weight change | `.transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .opacity))` with staggered delays |
| Shimmer button | Always | Overlay gradient offset animated -width → +width, 3s ease-in-out infinite |
| Button press | Press | ButtonStyle with `scaleEffect(0.96)`, spring |
| Checkmark | Post-validate | Existing `RSICheckmarkView` — unchanged |

## 5. Color Adaptation

All new elements use `CriticalDesign.Adaptive` functions with `@Environment(\.colorScheme)`.

| Element | Dark Mode | Light Mode |
|---------|-----------|------------|
| Canvas | `Adaptive.canvas` (#0F1219) | `Adaptive.canvas` (#E4E9F0) |
| Card surface | `Adaptive.cardSurface` (#121826) | `Adaptive.cardSurface` (#EDF1F5) |
| Card stroke | Gold gradient | Accent color 0.15 |
| Text primary | `Adaptive.textPrimary` (white) | `Adaptive.textPrimary` (dark) |
| Conic ring | goldMid → goldDeep | accentBlue → navyAccent |
| Dose chip bg | white 0.04 | white 0.5 |
| Dose chip border | white 0.06 | gray 0.12 |
| Quick ref card bg | `cardSurface` | `cardSurface` |
| Button shadow | darkCanvas 0.5 | blue 0.3 |
| Tag pill bg | blue/teal 0.15 | blue/teal 0.1 |
| Tag pill border | teal 0.2 | blue 0.15 |

## 6. Data Flow

```
GlobalPatientContext.shared
    ├── onAppear → loads weightKg into weightField (if available)
    ├── onChange(of: patientContext.weightKg) → syncs external changes
    ├── kg/lbs toggle → reads/writes patientContext.weightUnit
    └── validateAndCalculate() → writes weightKg back

weightField (String, @State)
    ├── Live conversion: Double(weightField) * 2.2 → lbs display
    ├── Live dose chips: Double(weightField) * [2.0, 0.3, 1.5, 1.2] → mg values
    └── On calculate: validated → weight @State → showingResultSheet

RecentlyUsedTracker.shared.trackCalculation() → unchanged
```

## 7. What's Removed

- `RSILightBackground` — the floating orb background. Replaced by `CriticalDesign.Adaptive.canvas` (simpler, matches rest of app).

## 8. What's Preserved

- All clinical content (infoSections array, drug names, doses)
- Settings NavigationLink
- CriticalFavoriteButton in toolbar
- HoldOnPopupView for validation errors
- RSICheckmarkView + RSICheckmarkShape animations
- RSIIResultDesignView full-screen cover
- RecentlyUsedTracker integration
- GlobalPatientContext two-way sync
- dismissKeyboardOnScroll modifier
- RSISectionDivider component

## 9. New Private Components (within RSIIMainView.swift)

1. **`RSIConicRingIcon`** — Hero icon with spinning gradient ring + pulse rings
2. **`RSIWeightToggle`** — kg/lbs animated capsule toggle
3. **`RSIDoseChip`** — Single dose preview chip (drug name, dose, unit)
4. **`RSIDosePreviewStrip`** — Horizontal scroll of 4 dose chips with stagger
5. **`RSIShimmerButton`** — ButtonStyle with shimmer overlay + spring press
6. **`RSIQuickRefCard`** — Single reference card (phase, drug, dose, onset)

## 10. Mockup Reference

Visual mockup: `.superpowers/brainstorm/24939-1774977578/content/rsi-redesign-concepts.html`
(Open with `http://localhost:60098` when brainstorm server is running)
