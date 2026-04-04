//
//  AirwayPressureDeatilView.swift
//  CriticalX
//
//  APRV (Airway Pressure Release Ventilation) Detail View
//  Comprehensive clinical teaching with neumorphic design
//

import SwiftUI

struct AirwayPressureDeatilView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showFlowWaveformInfo = false
    @State private var selectedImageName: String? = nil
    @State private var selectedImageTitle: String = ""
    
    var body: some View {
        ZStack {
            CriticalDesign.Colors.canvas.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.xl) {
                    headerSection
                    overviewCard
                    whyAPRVWorksSection
                    terminologySection
                    mentalModelSection
                    settingsSection
                    oxygenationVentilationSection
                    tLowWaveformSection
                    weaningSection
                    advantagesSection
                    warningCard
                    brandNamesCard
                    brandingCard
                    
                    Spacer(minLength: CriticalDesign.Spacing.xl)
                }
                .padding(.vertical, CriticalDesign.Spacing.lg)
            }
        }
        .fullScreenCover(item: $selectedImageName) { imageName in
            ImageFullScreenView(imageName: imageName, title: selectedImageTitle)
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            HStack {
                Spacer()
                CriticalFavoriteButton(title: "APRV", type: "VentMode")
            }
            .padding(.horizontal, CriticalDesign.Spacing.lg)
            
            GradientEdgeFadeImage(imageName: "icon-aprv", size: 150)
            
            VStack(spacing: 4) {
                Text("APRV")
                    .font(.custom("Poppins-Bold", size: 30))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                
                Text("Airway Pressure Release Ventilation")
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
        }
    }
    
    // MARK: - Overview Card
    private var overviewCard: some View {
        Text(CriticalDesign.markdownToAttributedString("""
        APRV is a mode designed for **recruiting collapsed lung** and keeping it open.

        Think of it as breathing on CPAP with intermittent releases. The CPAP is there to keep the lungs open and maintain oxygenation. The releases periodically clear carbon dioxide from the lungs.

        The patient can breathe spontaneously throughout the cycle, which preserves diaphragm function, improves V/Q matching, and may reduce sedation needs. It's primarily used in **severe ARDS**, pulmonary contusions, and bilateral pneumonia.
        """))
            .font(.custom("Poppins-Regular", size: 15))
            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            .lineSpacing(6)
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
            .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    // MARK: - Why APRV Works Section
    private var whyAPRVWorksSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Why APRV Works", icon: "lightbulb.fill", color: CriticalDesign.Colors.accentOrange)
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text(CriticalDesign.markdownToAttributedString("""
                Modern lung-protective ventilation teaches us two things: **lower tidal volumes** prevent overdistension, and **higher PEEP** prevents collapse. APRV takes the second concept and runs with it.

                Severely injured lungs — like those in ARDS — have a high **shunt fraction**. Flooded or collapsed alveoli are perfused, but gas can't reach the alveolar-capillary membrane. Positive pressure can reduce this shunt by recruiting, reopening, and stabilizing vulnerable alveoli.

                **Here's the insight:**

                Imagine putting an ARDS patient on CPAP of 35 cm H₂O at 100% FiO₂. Oxygenation would improve because the continuous positive pressure opens alveoli. But ventilation would fail — the patient can't maintain their own minute ventilation, and CO₂ would rise.

                So instead of pushing more air in on top of high pressure, we **suddenly decompress the airways** by dropping pressure to zero. Air rushes out, carrying CO₂ with it. Then we quickly repressurize — short enough to prevent alveolar collapse, but long enough to clear the gas.

                That's APRV. It's elegant once you see it.
                """))
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineSpacing(6)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    // MARK: - Terminology Section
    private var terminologySection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "APRV Terminology", icon: "text.book.closed.fill", color: CriticalDesign.Colors.cardBlue)
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.lg) {
                termDefinition(
                    term: "P-High",
                    definition: "The \"CPAP\" level. It's the pressure applied during most of the respiratory cycle — the pressure needed to keep alveoli open. A higher P-High means a higher mean airway pressure and better oxygenation. As the patient improves, you'll need less."
                )
                
                termDefinition(
                    term: "T-High",
                    definition: "Time spent at P-High. It's the time between releases. A longer T-High increases mean airway pressure (improving oxygenation) but means fewer releases per minute (which can raise PaCO₂)."
                )
                
                termDefinition(
                    term: "P-Low",
                    definition: "The release pressure — what the vent drops to during releases. Generally set at zero. The airways act as a natural flow resistor, so end-expiratory pressure rarely reaches true zero. Setting P-Low at zero creates the highest pressure gradient for gas release."
                )
                
                termDefinition(
                    term: "T-Low",
                    definition: "Time spent at P-Low. It's short — usually 0.4–0.8 seconds. Just enough for gas to escape, but short enough to prevent alveolar collapse. Adjusting T-Low using the expiratory flow waveform is the key skill."
                )
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    private func termDefinition(term: String, definition: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(term)
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(CriticalDesign.Colors.cardBlue)
            
            Text(definition)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: - Mental Model Section
    private var mentalModelSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "How to Think About APRV", icon: "brain.head.profile", color: CriticalDesign.Colors.accentPurple)
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text(CriticalDesign.markdownToAttributedString("""
                Forget the traditional inspiration/expiration model.

                In APRV, you're maintaining a **high baseline pressure (P-High)** for most of the breath cycle **(T-High)**. This is where recruitment happens.

                Then, you briefly drop to a **low pressure (P-Low)** for a short time **(T-Low)**. This is where CO₂ is released.

                **The key insight:**

                • **P-High** = Your "CPAP" level. This is where the lungs sit most of the time.

                • **T-High** = How long you stay at P-High. Usually 4–6 seconds.

                • **P-Low** = The release pressure. Often set to 0 or close to it.

                • **T-Low** = How long the release lasts. Very short — usually 0.4–0.8 seconds.

                The release is so brief that the lungs don't fully deflate. That's intentional. You want to prevent derecruitment.
                """))
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineSpacing(6)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Initial APRV Settings", icon: "slider.horizontal.3", color: CriticalDesign.Colors.accentGreen)
            
            VStack(spacing: CriticalDesign.Spacing.sm) {
                settingRow(param: "FiO₂", value: "100%", note: "Start high, wean as tolerated.")
                settingRow(param: "P-High", value: "30–35 cm H₂O", note: "Set for recruitment. Often equals or slightly exceeds prior plateau pressure.")
                settingRow(param: "P-Low", value: "0 cm H₂O", note: "Creates maximum release gradient.")
                settingRow(param: "T-High", value: "4 seconds", note: "Time between releases. Adjust for oxygenation.")
                settingRow(param: "T-Low", value: "0.8 seconds", note: "Adjusted so peak expiratory flow drops by ~50%. This is key.")
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    private func settingRow(param: String, value: String, note: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(param)
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Colors.cardBlue)
                    .frame(width: 90, alignment: .leading)
                
                Text(value)
                    .font(.custom("Poppins-Medium", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            Text(note)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Oxygenation & Ventilation Section
    private var oxygenationVentilationSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Oxygenation vs. Ventilation", icon: "arrow.left.arrow.right", color: CriticalDesign.Colors.accentPurple)
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.lg) {
                // Oxygenation
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    HStack {
                        Image(systemName: "lungs.fill")
                            .foregroundColor(.blue)
                        Text("Oxygenation")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(.blue)
                    }
                    
                    Text(CriticalDesign.markdownToAttributedString("""
                    Oxygenation in APRV is governed by the **mean airway pressure** and **FiO₂**.

                    Because there are no distending tidal volumes, APRV lets you ventilate with a higher mean airway pressure without excessively high peak pressures.

                    **To improve oxygenation:**
                    • Raise **P-High** (more recruitment pressure).
                    • Prolong **T-High** (more time at recruitment).
                    • Raise **P-Low** (less of a drop, but limits ventilation).
                    • Increase **FiO₂**.
                    """))
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .lineSpacing(5)
                }
                
                Divider()
                
                // Ventilation
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    HStack {
                        Image(systemName: "wind")
                            .foregroundColor(.green)
                        Text("Ventilation (CO₂ Clearance)")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(.green)
                    }
                    
                    Text(CriticalDesign.markdownToAttributedString("""
                    Ventilation is determined by the **frequency of releases**, the **time at T-Low**, and the **gradient** from P-High to P-Low.

                    The number of releases per minute is mainly controlled by T-High — shorter T-High means more releases and lower PaCO₂.

                    **To blow off more CO₂:**
                    • Shorten **T-High** (more releases per minute).
                    • Lengthen **T-Low** (more gas escapes per release).

                    **But remember:** Shortening T-High reduces mean airway pressure. Lengthening T-Low allows more derecruitment. It's a balance.
                    """))
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .lineSpacing(5)
                }
                
                Divider()
                
                // Release Volume
                VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                    HStack {
                        Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                            .foregroundColor(.orange)
                        Text("Release Volume & Compliance")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(.orange)
                    }
                    
                    Text(CriticalDesign.markdownToAttributedString("""
                    The patient's **lung compliance** determines how much gas is released.

                    If compliance is 20 mL/cm H₂O and you drop from P-High of 30 to P-Low of 0, the release volume will be about **600 mL**.

                    As compliance improves — either from resolution of the injury or better recruitment — the same pressure drop produces **larger release volumes**. This is one way to know the patient is improving.
                    """))
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .lineSpacing(5)
                }
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    // MARK: - T-Low Waveform Section
    private var tLowWaveformSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Setting T-Low: The Flow Waveform", icon: "waveform.path.ecg", color: .red)
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text(CriticalDesign.markdownToAttributedString("""
                This is the **most important skill** in APRV management. The T-Low is adjusted by watching the **expiratory flow waveform** on the ventilator.

                **The target:** Let expiratory flow drop to about **50% of its peak value**, then repressurize to P-High.

                This is the sweet spot — enough time for ventilation, but short enough to maintain recruitment.
                """))
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineSpacing(5)
                
                // Placeholder for waveform images
                VStack(spacing: CriticalDesign.Spacing.md) {
                    // Image 1 placeholder
                    waveformImagePlaceholder(
                        title: "Correct T-Low Setting",
                        description: "Flow drops to ~50% of peak before repressurization. Optimal balance.",
                        imageName: "aprv_waveform_correct"
                    )
                    
                    // Image 2 placeholder
                    waveformImagePlaceholder(
                        title: "T-Low Too Long",
                        description: "Flow returns to baseline. Derecruitment is occurring.",
                        imageName: "aprv_waveform_toolong"
                    )
                }
                
                Text(CriticalDesign.markdownToAttributedString("""
                **Adjustments by patient type:**

                • **COPD patients:** May need longer T-Low, letting flow fall to ~75% — they empty slower.

                • **Very stiff lungs:** May need shorter T-Low, only ~25% drop — they want to collapse faster.

                • **Most patients:** Aim for the 50% mark.

                **Critical rule:** Never let expiratory flow return to baseline. That's too long, and you'll lose recruitment.
                """))
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineSpacing(5)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    private func waveformImagePlaceholder(title: String, description: String, imageName: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Try to load the image, otherwise show placeholder
            if UIImage(named: imageName) != nil {
                ZStack(alignment: .topTrailing) {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 150)
                        .cornerRadius(CriticalDesign.Radius.md)
                    
                    // Tap to enlarge indicator
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(6)
                        .padding(8)
                }
                .onTapGesture {
                    selectedImageTitle = title
                    selectedImageName = imageName
                }
            } else {
                // Placeholder when image not yet added
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 120)
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "waveform.path.ecg.rectangle")
                                .font(.system(size: 30))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            Text("Add image: \(imageName)")
                                .font(.custom("Poppins-Regular", size: 11))
                                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        }
                    )
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Text(description)
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
                
                Spacer()
                
                if UIImage(named: imageName) != nil {
                    Text("Tap to enlarge")
                        .font(.custom("Poppins-Medium", size: 10))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                }
            }
        }
        .padding(CriticalDesign.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(Color.white.opacity(0.5))
        )
    }
    
    // MARK: - Weaning Section
    private var weaningSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Weaning APRV: Drop & Spread", icon: "arrow.down.right.circle.fill", color: CriticalDesign.Colors.accentTeal)
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                Text(CriticalDesign.markdownToAttributedString("""
                Weaning from APRV is straightforward. Remember — this is just glorified CPAP.

                The patient can breathe spontaneously at P-High, and even if tidal volumes are small, they contribute to ventilation and V/Q matching.

                **The "Drop and Spread" Method:**

                As the patient's compliance and gas exchange improve, they'll need less P-High and fewer releases per minute.

                • **Drop** the P-High by 1–2 cm H₂O increments.

                • **Spread** the T-High (extend the time between releases).

                **Transition to Pressure Support:**

                Once T-High reaches **8–10 seconds** and P-High is **less than 15 cm H₂O**, the patient can switch to pressure support ventilation.

                Add a small amount of PS (5–10 cm) to make up for removing the intermittent releases.
                """))
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineSpacing(5)
                
                // Example transition
                VStack(alignment: .leading, spacing: 8) {
                    Text("Example Transition:")
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(CriticalDesign.Colors.cardBlue)
                    
                    HStack(spacing: CriticalDesign.Spacing.md) {
                        // APRV Settings
                        VStack(alignment: .leading, spacing: 4) {
                            Text("APRV")
                                .font(.custom("Poppins-Bold", size: 13))
                                .foregroundColor(.orange)
                            Text("P-High: 15")
                                .font(.custom("Poppins-Regular", size: 12))
                            Text("T-High: 10 sec")
                                .font(.custom("Poppins-Regular", size: 12))
                        }
                        .padding(CriticalDesign.Spacing.sm)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(CriticalDesign.Radius.sm)
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        
                        // PSV Settings
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PSV")
                                .font(.custom("Poppins-Bold", size: 13))
                                .foregroundColor(.green)
                            Text("CPAP: 12")
                                .font(.custom("Poppins-Regular", size: 12))
                            Text("PS: 8")
                                .font(.custom("Poppins-Regular", size: 12))
                        }
                        .padding(CriticalDesign.Spacing.sm)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(CriticalDesign.Radius.sm)
                    }
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                }
                .padding(CriticalDesign.Spacing.md)
                .background(Color.white.opacity(0.5))
                .cornerRadius(CriticalDesign.Radius.md)
                
                Text(CriticalDesign.markdownToAttributedString("""
                Once on PSV, lower the CPAP as oxygenation improves and adjust the PS to maintain comfortable spontaneous breathing.

                **Note:** Don't use PS at a P-High more than 20, even if the vent allows it — this can lead to excessive distending pressures.
                """))
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .lineSpacing(5)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    // MARK: - Advantages Section
    private var advantagesSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Potential Benefits", icon: "hand.thumbsup.fill", color: CriticalDesign.Colors.accentGreen)
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                benefitRow(text: "Sustained recruitment of collapsed alveoli.")
                benefitRow(text: "Allows spontaneous breathing — preserves diaphragm function.")
                benefitRow(text: "May improve V/Q matching in posterior lung regions.")
                benefitRow(text: "Can reduce sedation needs in some patients.")
                benefitRow(text: "Alternative for refractory hypoxemia when conventional ventilation fails.")
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    private func benefitRow(text: String) -> some View {
        HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(CriticalDesign.Colors.accentGreen)
            
            Text(text)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
    }
    
    // MARK: - Warning Card
    private var warningCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text("Important Cautions")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(.red)
            }
            
            Text(CriticalDesign.markdownToAttributedString("""
            APRV requires **experience to use well**. It's not a set-it-and-forget-it mode.

            **Potential problems:**

            • **Air trapping** — If T-Low is too short or the patient has obstructive disease, they may not empty adequately.

            • **Hemodynamic compromise** — High mean airway pressure can reduce venous return.

            • **Learning curve** — The adjustments are different from conventional modes. It takes time to get comfortable.

            **When to avoid:**

            • Obstructive lung disease (COPD, asthma).

            • Hemodynamic instability or RV failure.

            • Lack of familiarity with the mode.
            """))
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .lineSpacing(6)
        }
        .padding(CriticalDesign.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(Color.red.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                        .stroke(Color.red.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    // MARK: - Brand Names Card
    private var brandNamesCard: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            sectionHeader(title: "Ventilator Brand Names", icon: "building.2.fill", color: CriticalDesign.Colors.secondary)
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                Text("Same concept, different names:")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                VStack(spacing: 8) {
                    brandRow(brand: "Dräger", modeName: "APRV™")
                    brandRow(brand: "Servo (Getinge)", modeName: "Bi-Vent™")
                    brandRow(brand: "Puritan Bennett", modeName: "BiLevel™")
                    brandRow(brand: "Hamilton", modeName: "DuoPAP / APVcmv")
                }
                
                Text("Despite the various names, it's all essentially the same mode. The terminology (P-High, T-High, etc.) may also vary slightly by manufacturer.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .padding(.top, 4)
            }
            .padding(CriticalDesign.Spacing.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                    .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                    .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
            )
        }
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
    
    private func brandRow(brand: String, modeName: String) -> some View {
        HStack {
            Text(brand)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                .frame(width: 140, alignment: .leading)
            
            Text("→")
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            
            Text(modeName)
                .font(.custom("Poppins-Bold", size: 14))
                .foregroundColor(CriticalDesign.Colors.cardBlue)
        }
    }
    
    // MARK: - Helpers
    private func sectionHeader(title: String, icon: String, color: Color) -> some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
            
            Text(title)
                .font(.custom("Poppins-Bold", size: 18))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
    }
    
    // MARK: - Branding Card
    private var brandingCard: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            Image("logo_bw")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("The Clinical Takeaway")
                    .font(.custom("Poppins-Bold", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text("APRV is high pressure with brief releases. Think of it as CPAP that clears CO₂. It's a rescue mode for severe hypoxemia when conventional ventilation isn't working.")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(CriticalDesign.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.lg)
                .fill(colorScheme == .dark ? AnyShapeStyle(CriticalDesign.Colors.cardBlue) : AnyShapeStyle(LinearGradient(colors: [Color.white.opacity(0.8), CriticalDesign.Colors.canvas], startPoint: .topLeading, endPoint: .bottomTrailing)))
                .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
                .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
        )
        .padding(.horizontal, CriticalDesign.Spacing.lg)
    }
}

struct AirwayPressureDeatilView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        AirwayPressureDeatilView()
        }
    }
}

// MARK: - String Extension for Identifiable
extension String: Identifiable {
    public var id: String { self }
}

// MARK: - Full Screen Image View
struct ImageFullScreenView: View {
    let imageName: String
    let title: String
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(.white)
                        
                        Text("Pinch to zoom")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding()
                .background(Color.black.opacity(0.8))
                
                // Image
                GeometryReader { geo in
                    ScrollView([.horizontal, .vertical], showsIndicators: false) {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width * scale, height: geo.size.height * scale)
                            .scaleEffect(scale)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        let delta = value / lastScale
                                        lastScale = value
                                        scale = min(max(scale * delta, 1), 4)
                                    }
                                    .onEnded { _ in
                                        lastScale = 1.0
                                    }
                            )
                            .gesture(
                                TapGesture(count: 2)
                                    .onEnded {
                                        withAnimation(.spring()) {
                                            scale = scale > 1 ? 1 : 2
                                        }
                                    }
                            )
                    }
                }
            }
        }
    }
}
