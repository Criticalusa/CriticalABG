# RSI Calculator Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace RSIIMainView with a polished version featuring live dose previews, micro-animations, glassmorphic cards, and full light/dark adaptive support.

**Architecture:** Single-file replacement of `RSIIMainView.swift`. Six new private structs added within the file (RSIConicRingIcon, RSIWeightToggle, RSIDoseChip, RSIDosePreviewStrip, RSIShimmerButtonStyle, RSIQuickRefCard). All existing integrations (GlobalPatientContext, RecentlyUsedTracker, IconTabBar, CriticalFavoriteButton) preserved unchanged.

**Tech Stack:** SwiftUI, CriticalDesignSystem (`CriticalDesign.Adaptive`), Poppins custom font, SF Symbols

**Spec:** `docs/superpowers/specs/2026-03-31-rsi-calculator-redesign-design.md`

---

## File Map

| File | Action | Responsibility |
|------|--------|---------------|
| `CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift` | **Replace** | All RSI input view code — hero, weight input, dose preview, calculate, quick ref |

No new files. No modifications to any other file.

---

### Task 1: Scaffold — Strip Old, Add New Structure

**Files:**
- Modify: `CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift` (full file)

- [ ] **Step 1: Replace `RSILightBackground` with `RSIConicRingIcon`**

Delete lines 10-57 (`RSILightBackground` struct). Replace with the conic ring hero component:

```swift
// MARK: - Conic Ring Hero Icon
struct RSIConicRingIcon: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var ringAngle: Double = 0
    @State private var showPulse = true

    private var ringGradient: AngularGradient {
        AngularGradient(
            colors: colorScheme == .dark
                ? [CriticalDesign.Colors.goldMid, CriticalDesign.Colors.goldDeep, CriticalDesign.Colors.goldMid]
                : [Color(red: 0.06, green: 0.60, blue: 0.97), Color(red: 0.18, green: 0.25, blue: 0.34), Color(red: 0.06, green: 0.60, blue: 0.97)],
            center: .center
        )
    }

    private var iconGradient: LinearGradient {
        LinearGradient(
            colors: colorScheme == .dark
                ? [CriticalDesign.Colors.goldMid, CriticalDesign.Colors.goldDeep]
                : [Color(red: 0.06, green: 0.60, blue: 0.97), Color(red: 0.18, green: 0.25, blue: 0.34)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        ZStack {
            // Pulse rings (appear on load, fade after 4s)
            if showPulse {
                Circle()
                    .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldMid.opacity(0.4) : Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.4), lineWidth: 2)
                    .frame(width: 100, height: 100)
                    .scaleEffect(showPulse ? 1.4 : 0.8)
                    .opacity(showPulse ? 0 : 1)
                    .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: showPulse)

                Circle()
                    .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldMid.opacity(0.3) : Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.3), lineWidth: 2)
                    .frame(width: 100, height: 100)
                    .scaleEffect(showPulse ? 1.4 : 0.8)
                    .opacity(showPulse ? 0 : 1)
                    .animation(.easeOut(duration: 2).repeatForever(autoreverses: false).delay(1), value: showPulse)
            }

            // Glow backdrop
            Circle()
                .fill(Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.12))
                .frame(width: 100, height: 100)
                .blur(radius: 20)

            // Inner filled circle
            Circle()
                .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
                .frame(width: 80, height: 80)

            // Border stroke
            Circle()
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.goldGradient
                        : LinearGradient(colors: [Color.white], startPoint: .top, endPoint: .bottom),
                    lineWidth: 1.5
                )
                .frame(width: 80, height: 80)

            // Spinning conic ring
            Circle()
                .stroke(ringGradient, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 70, height: 70)
                .rotationEffect(.degrees(ringAngle))

            // Lungs icon
            Image(systemName: "lungs.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(iconGradient)
        }
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.5) : Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        .onAppear {
            withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                ringAngle = 360
            }
            // Auto-hide pulse rings after 4 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showPulse = false
                }
            }
        }
    }
}
```

- [ ] **Step 2: Verify file compiles**

Run: Xcode build (Cmd+B) or `xcodebuild` in terminal.
Expected: Build succeeds. `RSILightBackground` is no longer referenced in `RSIIMainView.body` (we'll update that reference in Task 3).

- [ ] **Step 3: Commit**

```bash
git add "CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift"
git commit -m "feat(RSI): replace RSILightBackground with RSIConicRingIcon"
```

---

### Task 2: Add New Sub-Components — Toggle, Chips, Shimmer Button, Ref Card

**Files:**
- Modify: `CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift`

- [ ] **Step 1: Add RSIWeightToggle below RSIConicRingIcon**

```swift
// MARK: - kg/lbs Toggle
struct RSIWeightToggle: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isKg: Bool
    let haptic = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        HStack(spacing: 0) {
            toggleSegment(label: "kg", isActive: isKg) {
                guard !isKg else { return }
                haptic.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isKg = true
                }
            }
            toggleSegment(label: "lbs", isActive: !isKg) {
                guard isKg else { return }
                haptic.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isKg = false
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.gray.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.06) : Color.gray.opacity(0.1), lineWidth: 1)
        )
    }

    private func toggleSegment(label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Text(label)
            .font(.custom("Poppins-SemiBold", size: 12))
            .foregroundColor(isActive ? .white : (colorScheme == .dark ? Color.white.opacity(0.4) : Color.gray))
            .padding(.horizontal, 14)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(isActive ? Color(red: 0.06, green: 0.60, blue: 0.97) : Color.clear)
            )
            .onTapGesture(perform: action)
    }
}
```

- [ ] **Step 2: Add RSIDoseChip**

```swift
// MARK: - Dose Preview Chip
struct RSIDoseChip: View {
    @Environment(\.colorScheme) var colorScheme
    let drugName: String
    let dose: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(drugName)
                .font(.custom("Poppins-SemiBold", size: 10))
                .foregroundColor(color)
                .textCase(.uppercase)
                .tracking(0.5)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(dose)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                Text("mg")
                    .font(.custom("Poppins-Regular", size: 10))
                    .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.04) : Color.white.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.06) : Color.gray.opacity(0.12), lineWidth: 1)
        )
    }
}
```

- [ ] **Step 3: Add RSIDosePreviewStrip**

```swift
// MARK: - Live Dose Preview Strip
struct RSIDosePreviewStrip: View {
    let weightKg: Double?

    private var doseData: [(name: String, dose: String, color: Color)] {
        guard let w = weightKg, w > 0 else {
            return [
                ("Ketamine", "—", Color(red: 0.40, green: 0.84, blue: 0.72)),
                ("Etomidate", "—", Color(red: 0.06, green: 0.60, blue: 0.97)),
                ("Succ", "—", Color(red: 0.85, green: 0.34, blue: 0.17)),
                ("Roc", "—", Color(red: 0.92, green: 0.32, blue: 0.38))
            ]
        }
        return [
            ("Ketamine", String(format: "%.0f", w * 2.0), Color(red: 0.40, green: 0.84, blue: 0.72)),
            ("Etomidate", String(format: "%.1f", w * 0.3), Color(red: 0.06, green: 0.60, blue: 0.97)),
            ("Succ", String(format: "%.1f", w * 1.5), Color(red: 0.85, green: 0.34, blue: 0.17)),
            ("Roc", String(format: "%.0f", w * 1.2), Color(red: 0.92, green: 0.32, blue: 0.38))
        ]
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(doseData.enumerated()), id: \.offset) { index, item in
                    RSIDoseChip(drugName: item.name, dose: item.dose, color: item.color)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .opacity
                        ))
                }
            }
            .padding(.horizontal, 2)
        }
    }
}
```

- [ ] **Step 4: Add RSIShimmerButtonStyle**

```swift
// MARK: - Shimmer Button Style
struct RSIShimmerButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    @State private var shimmerOffset: CGFloat = -1

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.06, green: 0.60, blue: 0.97), Color(red: 0.04, green: 0.50, blue: 0.84)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0.3),
                            .init(color: Color.white.opacity(0.15), location: 0.5),
                            .init(color: .clear, location: 0.7)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width)
                    .offset(x: shimmerOffset * geo.size.width)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: false)) {
                            shimmerOffset = 1
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            )
            .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.5) : Color(red: 0.06, green: 0.60, blue: 0.97).opacity(0.3), radius: 10, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}
```

- [ ] **Step 5: Add RSIQuickRefCard**

```swift
// MARK: - Quick Reference Card
struct RSIQuickRefCard: View {
    @Environment(\.colorScheme) var colorScheme
    let phase: String
    let drug: String
    let dose: String
    let onset: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)
                Text(phase)
                    .font(.custom("Poppins-SemiBold", size: 9))
                    .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.4) : Color.gray)
                    .textCase(.uppercase)
                    .tracking(1)
            }

            Text(drug)
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

            Text(dose)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))

            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.system(size: 9))
                Text(onset)
                    .font(.custom("Poppins-Regular", size: 10))
            }
            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.6))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.06) : Color.gray.opacity(0.08), lineWidth: 1)
        )
    }
}
```

- [ ] **Step 6: Verify build**

Run: Xcode build (Cmd+B).
Expected: Build succeeds. The new structs exist but aren't used yet.

- [ ] **Step 7: Commit**

```bash
git add "CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift"
git commit -m "feat(RSI): add sub-components — toggle, dose chips, shimmer button, ref cards"
```

---

### Task 3: Rewrite RSIIMainView — State, Colors, and New Properties

**Files:**
- Modify: `CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift`

- [ ] **Step 1: Update state properties in RSIIMainView**

Replace the existing state/color block (lines 105-144 in original) with:

```swift
struct RSIIMainView: View {

    // MARK: - Environment
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Global Patient Context
    @ObservedObject private var patientContext = GlobalPatientContext.shared

    // MARK: - Brand Colors
    private var textPrimary: Color { CriticalDesign.Adaptive.textPrimary(for: colorScheme) }
    private var textSecondary: Color { CriticalDesign.Adaptive.textSecondary(for: colorScheme) }
    private var textTertiary: Color { CriticalDesign.Adaptive.textTertiary(for: colorScheme) }
    private var textMuted: Color { colorScheme == .dark ? Color.white.opacity(0.5) : Color(red: 0.42, green: 0.49, blue: 0.54) }

    // Accent Colors
    private let accentBlue = Color(red: 0.06, green: 0.60, blue: 0.97)
    private let navyAccent = Color(red: 0.18, green: 0.25, blue: 0.34)
    private let accentGreen = Color(red: 0.40, green: 0.84, blue: 0.72)
    private let accentOrange = Color(red: 0.85, green: 0.34, blue: 0.17)
    private let accentRed = Color(red: 0.92, green: 0.32, blue: 0.38)
    private let accentTeal = Color(red: 0.08, green: 0.72, blue: 0.65)

    // MARK: - State Properties
    @State private var weightField: String = ""
    @State private var isKg: Bool = true
    @State private var isAppearing = false
    @State private var showingResultSheet = false
    @State private var showingPopup = false
    @State private var weight: Double = 0
    @State private var showCheckmark = false

    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case weight
    }

    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    private let successHaptic = UINotificationFeedbackGenerator()
```

Note: Added `isKg` state and `accentTeal`. Removed `terracotta`, `goldColor` (unused in new design).

- [ ] **Step 2: Update computed properties**

Replace `liveConversionText` with a version that handles kg/lbs:

```swift
    // MARK: - Live Conversion
    private var liveConversionText: String {
        if let val = Double(weightField), val > 0 {
            if isKg {
                return "≈ \(String(format: "%.0f", val * 2.2)) lbs"
            } else {
                return "≈ \(String(format: "%.1f", val / 2.2)) kg"
            }
        }
        return "—"
    }

    // MARK: - Weight in kg (always kg for dose calculations)
    private var weightInKg: Double? {
        guard let val = Double(weightField), val > 0 else { return nil }
        return isKg ? val : val / 2.2
    }
```

- [ ] **Step 3: Keep infoSections array unchanged**

The `infoSections` array (lines 156-204 in original) stays exactly as-is. No changes needed.

- [ ] **Step 4: Commit**

```bash
git add "CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift"
git commit -m "feat(RSI): update state properties — add kg/lbs toggle state, weightInKg computed"
```

---

### Task 4: Rewrite the Body and Section Views

**Files:**
- Modify: `CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift`

- [ ] **Step 1: Replace the `body` property**

```swift
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)

                    // Hero with conic ring
                    heroSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 25)

                    // Info Tabs
                    IconTabBar(sections: infoSections)
                        .padding(.horizontal, 20)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 30)

                    // Weight Input
                    weightInputSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 35)

                    // Calculate Button
                    calculateButton
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)

                    // Quick Reference Grid
                    quickReferenceGrid
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 45)

                    Spacer(minLength: 100)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }
            }
            .dismissKeyboardOnScroll()

            // Checkmark overlay
            if showCheckmark {
                RSICheckmarkView(color: accentGreen)
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
            // Load global patient weight if available
            if let globalWeight = patientContext.weightKg, globalWeight > 0, weightField.isEmpty {
                weightField = String(format: "%.0f", globalWeight)
            }
            // Sync unit preference
            isKg = patientContext.weightUnit == .kg
        }
        .onChange(of: patientContext.weightKg) { newWeight in
            if let kg = newWeight, kg > 0 {
                let formatted = isKg ? String(format: "%.0f", kg) : String(format: "%.0f", kg * 2.2)
                if weightField != formatted {
                    weightField = formatted
                }
            }
        }
        .fullScreenCover(isPresented: $showingResultSheet) {
            RSIIResultDesignView(weightEntered: $weight, isPresented: $showingResultSheet)
        }
        .fullScreenCover(isPresented: $showingPopup) {
            HoldOnPopupView(title: "Hold On!", message: "Please enter a valid patient weight to calculate RSI medications.")
                .background(BackgroundClearView())
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                CriticalFavoriteButton(title: "RSI", type: "Cal")
            }
        }
    }
```

- [ ] **Step 2: Replace `headerSection`**

```swift
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Button(action: {
                haptic.impactOccurred()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    weightField = ""
                    focusedField = nil
                }
            }) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(textSecondary)
                    .frame(width: 48, height: 48)
            }
            .buttonStyle(CriticalNeumorphicIconButtonStyle())

            Spacer()

            NavigationLink {
                SettingView(showingPopup: .constant(false))
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "gear")
                        .font(.system(size: 14, weight: .medium))
                    Text("Settings")
                        .font(.custom("Poppins-Medium", size: 13))
                }
                .foregroundColor(textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.5))
                )
                .overlay(
                    Capsule()
                        .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldGradient : LinearGradient(colors: [Color.clear], startPoint: .top, endPoint: .bottom), lineWidth: colorScheme == .dark ? 1 : 0)
                )
                .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.4) : Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
            }
        }
    }
```

- [ ] **Step 3: Replace `heroSection` with conic ring version**

```swift
    // MARK: - Hero Section
    private var heroSection: some View {
        VStack(spacing: 16) {
            RSIConicRingIcon()

            Text("Rapid Sequence Intubation")
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(textPrimary)

            // Tag pill
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 10))
                Text("Weight-Based Dosing")
                    .font(.custom("Poppins-Medium", size: 11))
            }
            .foregroundColor(accentTeal)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [accentBlue.opacity(colorScheme == .dark ? 0.15 : 0.1), accentTeal.opacity(colorScheme == .dark ? 0.15 : 0.1)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .overlay(
                Capsule()
                    .stroke(accentTeal.opacity(colorScheme == .dark ? 0.2 : 0.15), lineWidth: 1)
            )
        }
        .padding(.bottom, 8)
    }
```

- [ ] **Step 4: Commit**

```bash
git add "CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift"
git commit -m "feat(RSI): rewrite body, header, and hero with conic ring"
```

---

### Task 5: Rewrite Weight Input Section with Toggle and Dose Preview

**Files:**
- Modify: `CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift`

- [ ] **Step 1: Replace `weightInputSection`**

```swift
    // MARK: - Weight Input Section
    private var weightInputSection: some View {
        VStack(spacing: 16) {
            RSISectionDivider(title: "Patient Data")

            // Glassmorphic weight card
            VStack(spacing: 16) {
                // Header: label + toggle
                HStack {
                    Text("PATIENT WEIGHT")
                        .font(.custom("Poppins-SemiBold", size: 12))
                        .foregroundColor(textMuted)
                        .tracking(1.5)

                    Spacer()

                    RSIWeightToggle(isKg: $isKg)
                }

                // Weight input
                HStack(alignment: .firstTextBaseline) {
                    TextField(isKg ? "85" : "187", text: $weightField)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(textPrimary)
                        .multilineTextAlignment(.leading)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .weight)

                    Text(isKg ? "kg" : "lbs")
                        .font(.custom("Poppins-Medium", size: 18))
                        .foregroundColor(textSecondary)

                    Spacer()
                }

                // Live conversion
                Text(liveConversionText)
                    .font(.custom("Poppins-Medium", size: 13))
                    .foregroundColor(accentTeal)

                // Live dose preview
                RSIDosePreviewStrip(weightKg: weightInKg)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.goldGradient
                            : LinearGradient(colors: [accentBlue.opacity(0.15)], startPoint: .top, endPoint: .bottom),
                        lineWidth: 1
                    )
            )
            .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.4) : Color.black.opacity(0.04), radius: 12, x: 0, y: 6)

            // Helper text
            HStack(spacing: 6) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 11))
                    .foregroundColor(accentGreen)

                Text("Use actual body weight for accurate medication dosing")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(accentGreen)

                Spacer()
            }
        }
    }
```

- [ ] **Step 2: Handle kg/lbs toggle conversion logic**

Add an `onChange` for `isKg` inside the body (after the existing `onChange(of: patientContext.weightKg)`):

```swift
        .onChange(of: isKg) { newIsKg in
            // Convert displayed value when toggling units
            if let val = Double(weightField), val > 0 {
                if newIsKg {
                    // Was lbs, now kg
                    weightField = String(format: "%.0f", val / 2.2)
                } else {
                    // Was kg, now lbs
                    weightField = String(format: "%.0f", val * 2.2)
                }
            }
            patientContext.weightUnit = newIsKg ? .kg : .lbs
        }
```

- [ ] **Step 3: Commit**

```bash
git add "CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift"
git commit -m "feat(RSI): glassmorphic weight card with toggle and live dose preview"
```

---

### Task 6: Rewrite Calculate Button and Quick Reference Grid

**Files:**
- Modify: `CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift`

- [ ] **Step 1: Replace `calculateButton`**

```swift
    // MARK: - Calculate Button
    private var calculateButton: some View {
        Button(action: {
            haptic.impactOccurred()
            focusedField = nil
            validateAndCalculate()
        }) {
            HStack(spacing: 10) {
                Text("Calculate Medications")
                    .font(.custom("Poppins-Bold", size: 18))

                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20))
            }
        }
        .buttonStyle(RSIShimmerButtonStyle())
    }
```

- [ ] **Step 2: Replace `quickReferenceCard` with `quickReferenceGrid`**

```swift
    // MARK: - Quick Reference Grid
    private var quickReferenceGrid: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(navyAccent)

                Text("Quick Reference")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)

                Spacer()
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                RSIQuickRefCard(
                    phase: "Induction",
                    drug: "Ketamine",
                    dose: "1-2 mg/kg IV",
                    onset: "45-60 sec onset",
                    color: accentGreen
                )
                RSIQuickRefCard(
                    phase: "Induction",
                    drug: "Etomidate",
                    dose: "0.3 mg/kg IV",
                    onset: "30-60 sec onset",
                    color: accentBlue
                )
                RSIQuickRefCard(
                    phase: "Paralytic",
                    drug: "Succinylcholine",
                    dose: "1.5 mg/kg IV",
                    onset: "45-60 sec onset",
                    color: accentOrange
                )
                RSIQuickRefCard(
                    phase: "Paralytic",
                    drug: "Rocuronium",
                    dose: "1.2 mg/kg IV",
                    onset: "60-90 sec onset",
                    color: accentRed
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    colorScheme == .dark
                        ? CriticalDesign.Colors.goldGradient
                        : LinearGradient(colors: [navyAccent.opacity(0.1)], startPoint: .top, endPoint: .bottom),
                    lineWidth: 1
                )
        )
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.4) : Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
    }
```

- [ ] **Step 3: Update `validateAndCalculate` to use `weightInKg`**

```swift
    // MARK: - Validation
    private func validateAndCalculate() {
        guard !weightField.isEmpty else {
            showingPopup = true
            return
        }

        guard let weightKg = weightInKg, weightKg > 0 else {
            showingPopup = true
            return
        }

        weight = weightKg

        // Update global patient context
        patientContext.weightKg = weightKg

        // Show checkmark animation
        withAnimation(.spring()) {
            showCheckmark = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation { showCheckmark = false }
            showingResultSheet = true

            // Track RSI calculation in recents
            let etomDose = String(format: "%.1f", weightKg * 0.3)
            let rocDose = String(format: "%.0f", weightKg * 1.2)
            RecentlyUsedTracker.shared.trackCalculation(
                title: "RSI — \(Int(weightKg))kg patient",
                icon: "syringe.fill",
                detail: "Etom \(etomDose)mg · Roc \(rocDose)mg"
            )
        }
    }
```

- [ ] **Step 4: Remove old `doseItem` helper function**

Delete the old `doseItem(drug:dose:color:)` function — it's no longer used. The `RSIQuickRefCard` struct replaces it.

- [ ] **Step 5: Verify build compiles**

Run: Xcode build (Cmd+B).
Expected: Build succeeds with zero errors. All references resolved.

- [ ] **Step 6: Commit**

```bash
git add "CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift"
git commit -m "feat(RSI): shimmer calculate button, 2x2 quick ref grid, updated validation"
```

---

### Task 7: Final Cleanup and Verify

**Files:**
- Modify: `CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift`

- [ ] **Step 1: Verify RSICheckmarkView and RSICheckmarkShape are preserved**

These structs (originally at the bottom of the file) should remain unchanged. Confirm they are present and unmodified:
- `RSICheckmarkView` — takes `color: Color`, animates a checkmark overlay
- `RSICheckmarkShape` — custom `Shape` that draws the checkmark path

- [ ] **Step 2: Verify the Preview provider is intact**

```swift
// MARK: - Preview
#Preview {
    NavigationView {
        RSIIMainView()
    }
}
```

- [ ] **Step 3: Run full build**

Run: Xcode build (Cmd+B) or:
```bash
cd "/Users/jadiebarringeriii/iCloudDrive (Archive)/Desktop/Critical.X/CriticalMed/critical-med/CriticalMed" && xcodebuild -scheme CriticalX -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build 2>&1 | tail -5
```
Expected: `** BUILD SUCCEEDED **`

- [ ] **Step 4: Run in simulator and verify**

Launch in simulator. Verify:
1. Hero icon spins with conic gradient ring
2. Pulse rings appear and fade after ~4 seconds
3. Tag pill shows "Weight-Based Dosing" below title
4. IconTabBar works (When to Use / Key Points / Clinical Use)
5. Section divider "Patient Data" displays
6. Weight card is glassmorphic with gold stroke (dark) / blue stroke (light)
7. kg/lbs toggle slides with spring animation
8. Typing weight shows live conversion and dose preview chips
9. Calculate button has shimmer sweep
10. Quick reference shows 2x2 grid with onset times
11. Calculate → checkmark → results sheet works
12. Reset button clears weight
13. Settings link navigates
14. Favorite button in toolbar works
15. Light mode and dark mode both look correct

- [ ] **Step 5: Final commit**

```bash
git add "CriticalX/Views/MainView/Home/RSII/RSIIMainView.swift"
git commit -m "feat(RSI): complete redesign — conic ring, live doses, shimmer, glassmorphic cards"
```

---

## Summary

| Task | Description | Estimated Steps |
|------|-------------|----------------|
| 1 | Scaffold — RSIConicRingIcon | 3 |
| 2 | Sub-components — toggle, chips, shimmer, ref cards | 7 |
| 3 | State properties and computed values | 4 |
| 4 | Body, header, hero rewrite | 4 |
| 5 | Weight input with toggle and dose preview | 3 |
| 6 | Calculate button, quick ref grid, validation | 6 |
| 7 | Cleanup and verify | 5 |
| **Total** | | **32 steps** |
