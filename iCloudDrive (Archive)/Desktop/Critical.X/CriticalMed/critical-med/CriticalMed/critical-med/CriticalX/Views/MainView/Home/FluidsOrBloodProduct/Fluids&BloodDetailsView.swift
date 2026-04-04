//
//  Fluids&BloodDetailsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 20/12/2021.
//  Updated: Premium Light Theme with Glass Cards
//

import SwiftUI

// MARK: - Main View
struct Fluids_BloodDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var isAppearing = false
    @State private var selectedTab = 0
    @State private var showAllPearls = false

    // MARK: - Scroll Animation State
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollY: CGFloat? = nil

    private let animationStartOffset: CGFloat = 40
    private let animationEndOffset: CGFloat = 140

    private var collapseProgress: CGFloat {
        guard scrollOffset > animationStartOffset else { return 0 }
        guard scrollOffset < animationEndOffset else { return 1 }
        return (scrollOffset - animationStartOffset) / (animationEndOffset - animationStartOffset)
    }

    private var headerVisibility: CGFloat {
        1 - collapseProgress
    }

    // Tab categories
    private let tabs = ["Blood Types", "Crystalloids", "Colloids", "Blood Products"]

    // Accent colors
    private let bloodRed = Color(red: 0.85, green: 0.2, blue: 0.25)
    private let fluidBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    private let crystalTeal = Color(red: 0.18, green: 0.62, blue: 0.67)
    private let colloidPurple = Color(red: 0.58, green: 0.44, blue: 0.86)

    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15)
    }
    private var textSecondary: Color {
        colorScheme == .dark ? Color.white.opacity(0.7) : Color(red: 0.4, green: 0.4, blue: 0.45)
    }

    // Critical Pearls
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(header: "Type O- for emergencies:", content: "When ABO/Rh unknown, use O-negative packed RBCs as universal donor."),
        CriticalPearlItem(header: "Crystalloid rule:", content: "Replace blood loss 3:1 with crystalloids due to redistribution into interstitial space."),
        CriticalPearlItem(header: "Massive transfusion:", content: "Use 1:1:1 ratio of PRBC:FFP:Platelets for hemorrhagic shock."),
        CriticalPearlItem(header: "Citrate toxicity:", content: "Watch for hypocalcemia with rapid transfusions - citrate binds calcium."),
        CriticalPearlItem(header: "TACO vs TRALI:", content: "TACO = volume overload (diuretics help). TRALI = lung injury (supportive care only)."),
        CriticalPearlItem(header: "Warm blood products:", content: "Rapid infusion of cold products causes hypothermia and coagulopathy.")
    ]

    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Close button
                    HStack {
                        Spacer()
                        PremiumLightCloseButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }

                    // Header with scroll collapse animation
                    headerSection
                        .opacity(isAppearing ? headerVisibility : 0)
                        .scaleEffect(1 - (collapseProgress * 0.1), anchor: .top)
                        .offset(y: isAppearing ? -collapseProgress * 20 : 20)
                        .animation(.easeOut(duration: 0.15), value: collapseProgress)

                    // Tab Selector
                    tabSelector
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 30)

                    // Content based on selected tab
                    Group {
                        switch selectedTab {
                        case 0:
                            bloodTypesContent
                        case 1:
                            crystalloidsContent
                        case 2:
                            colloidsContent
                        case 3:
                            bloodProductsContent
                        default:
                            EmptyView()
                        }
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 40)

                    // Critical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 50)

                    Spacer(minLength: 60)
                }
                .padding(.top, 20)
                // Scroll tracking overlay
                .overlay(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                if initialScrollY == nil {
                                    initialScrollY = geo.frame(in: .global).minY
                                }
                            }
                            .onChange(of: geo.frame(in: .global).minY) { newValue in
                                if initialScrollY == nil {
                                    initialScrollY = newValue
                                }
                                let offset = (initialScrollY ?? newValue) - newValue
                                scrollOffset = max(0, offset)
                            }
                    }
                )
            }

            // Collapsed header overlay - appears when scrolled
            if collapseProgress > 0.3 {
                VStack {
                    HStack {
                        Image(systemName: "ivfluid.bag.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(fluidBlue)

                        Text("Fluids & Blood")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(textPrimary)

                        Spacer()

                        PremiumLightCloseButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        Group {
                            if colorScheme == .dark {
                                CriticalDesign.Colors.cardBlue
                            } else {
                                Color(.systemBackground).opacity(0.85)
                            }
                        }
                    )

                    Spacer()
                }
                .opacity(collapseProgress)
                .animation(.easeOut(duration: 0.15), value: collapseProgress)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(fluidBlue.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)

                ZStack {
                    if colorScheme == .dark {
                        Circle()
                            .fill(CriticalDesign.Colors.cardBlue)
                            .frame(width: 80, height: 80)
                    } else {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 80, height: 80)
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 80, height: 80)
                    }
                    Circle()
                        .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        .frame(width: 80, height: 80)

                    Image(systemName: "ivfluid.bag.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [fluidBlue, fluidBlue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }

            Text("Fluids & Blood Products")
                .font(.custom("Poppins-Bold", size: 26))
                .foregroundColor(textPrimary)
                .multilineTextAlignment(.center)

            Text("IV THERAPY REFERENCE")
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(fluidBlue)
                .tracking(2)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(fluidBlue.opacity(0.12))
                )
        }
        .padding(.bottom, 8)
    }

    // MARK: - Tab Selector
    private var tabSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    tabButton(title: tabs[index], index: index)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func tabButton(title: String, index: Int) -> some View {
        let isSelected = selectedTab == index
        let colors: [Color] = [bloodRed, crystalTeal, colloidPurple, fluidBlue]
        let accentColor = colors[index]

        return Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedTab = index
            }
        }) {
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(isSelected ? .white : textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background {
                    if isSelected {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [accentColor, accentColor.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: accentColor.opacity(0.3), radius: 6, y: 3)
                    } else {
                        Capsule()
                            .fill(colorScheme == .dark
                                ? AnyShapeStyle(CriticalDesign.Colors.cardBlue)
                                : AnyShapeStyle(.ultraThinMaterial))
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(colorScheme == .dark ? 0.15 : 0.5), lineWidth: 1)
                            )
                    }
                }
        }
    }

    // MARK: - Blood Types Content
    private var bloodTypesContent: some View {
        VStack(spacing: 16) {
            // Overview Card
            fluidCard(
                title: "ABO Blood Types",
                subtitle: "Overview",
                icon: "drop.fill",
                accentColor: bloodRed,
                content: """
                Blood types are identified by antigens on the surface of RBCs. The major types are grouped by A, B, AB, O antigens and Rh factor (+) or (-).

                Cross-matching is performed to determine compatibility between donor and recipient blood.
                """
            )

            // Individual Blood Types
            bloodTypeCard(type: "Type A", antigen: "A antigen", antibodies: "Anti-B antibodies", color: bloodRed)
            bloodTypeCard(type: "Type B", antigen: "B antigen", antibodies: "Anti-A antibodies", color: bloodRed)
            bloodTypeCard(type: "Type AB", antigen: "A and B antigens", antibodies: "No antibodies (Universal Recipient)", color: bloodRed)
            bloodTypeCard(type: "Type O", antigen: "No antigens", antibodies: "Anti-A and Anti-B antibodies (Universal Donor)", color: bloodRed)

            // Rh Factor Card
            fluidCard(
                title: "Rh Factor",
                subtitle: "Key Point",
                icon: "plus.circle.fill",
                accentColor: bloodRed,
                content: """
                Red Blood Cells may also have the Rh antigen called the 'Rh factor'.

                Rh positive (+): Rh antigen IS present on the RBC.
                Rh negative (-): Rh antigen is NOT present.

                Rh-negative individuals can develop antibodies if exposed to Rh-positive blood.
                """
            )
        }
        .padding(.horizontal, 16)
    }

    private func bloodTypeCard(type: String, antigen: String, antibodies: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Circle()
                    .fill(color)
                    .frame(width: 12, height: 12)

                Text(type)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(textPrimary)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text("Antigen:")
                        .font(.custom("Poppins-SemiBold", size: 13))
                        .foregroundColor(color)
                    Text(antigen)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(textSecondary)
                }

                HStack(alignment: .top, spacing: 8) {
                    Text("Plasma:")
                        .font(.custom("Poppins-SemiBold", size: 13))
                        .foregroundColor(color)
                    Text(antibodies)
                        .font(.custom("Poppins-Regular", size: 13))
                        .foregroundColor(textSecondary)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white.opacity(0.5))
                        )
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(color.opacity(colorScheme == .dark ? 0.25 : 0.2), lineWidth: 1)
        )
    }

    // MARK: - Crystalloids Content
    private var crystalloidsContent: some View {
        VStack(spacing: 16) {
            fluidCard(
                title: "D5W",
                subtitle: "5% Dextrose in Water",
                icon: "drop.triangle.fill",
                accentColor: crystalTeal,
                content: """
                OVERVIEW:
                Hypotonic crystalloid providing free water and minimal calories. Once dextrose is metabolized, becomes essentially free water distributed throughout total body water.

                INDICATIONS:
                KVO maintenance fluid. Hypernatremia correction. Drug dilution vehicle. NOT for volume resuscitation.

                ADVANTAGES:
                Provides free water when serum sodium/chloride elevated. Good for diluting medications. No electrolyte load.

                DISADVANTAGES:
                Ineffective for plasma volume expansion (only 8% remains intravascular). Can cause hyponatremia, cerebral edema. Contraindicated in head injury.

                COMPOSITION:
                Tonicity: Hypotonic (isotonic in bag, hypotonic in body)
                Osmolarity: 252 mOsm/L
                Dextrose: 50 g/L
                Calories: 170 kcal/L
                pH: 4.0
                Na/K/Cl/Ca: 0 mEq/L
                """,
                customImage: "NanoBanana/blood/blood_crystalloids_general"
            )

            fluidCard(
                title: "0.45% NS",
                subtitle: "Half Normal Saline",
                icon: "drop.triangle.fill",
                accentColor: crystalTeal,
                content: """
                OVERVIEW:
                Hypotonic crystalloid providing free water plus sodium. Commonly used for maintenance fluids and gradual rehydration.

                INDICATIONS:
                Maintenance fluid therapy. Hypertonic dehydration. Gradual free water replacement. DKA fluid replacement (after initial NS bolus).

                ADVANTAGES:
                Provides free water without extreme dilution. Good maintenance fluid. Less hyperchloremia risk than NS.

                DISADVANTAGES:
                Can cause hyponatremia with excessive use. Not for acute resuscitation. Risk of cerebral edema in certain patients.

                COMPOSITION:
                Tonicity: Hypotonic
                Osmolarity: 154 mOsm/L
                Na: 77 mEq/L
                Cl: 77 mEq/L
                pH: 5.0
                Calories: 0 kcal/L
                """,
                customImage: "NanoBanana/blood/blood_crystalloids_general"
            )

            fluidCard(
                title: "0.9% NS",
                subtitle: "Normal Saline",
                icon: "drop.triangle.fill",
                accentColor: crystalTeal,
                content: """
                OVERVIEW:
                Isotonic crystalloid and most commonly used IV fluid. Only crystalloid compatible with blood products. Distributes primarily to extracellular space.

                INDICATIONS:
                Volume resuscitation. Metabolic alkalosis (high Cl content). Blood transfusion vehicle. Hypochloremia. Hyponatremia.

                ADVANTAGES:
                Isotonic - no cell swelling/shrinking. Compatible with most medications. Only fluid for blood administration.

                DISADVANTAGES:
                Large volumes cause hyperchloremic metabolic acidosis (high Cl). Not physiologic (higher Na/Cl than plasma). Only 25% stays intravascular.

                COMPOSITION:
                Tonicity: Isotonic
                Osmolarity: 308 mOsm/L
                Na: 154 mEq/L
                Cl: 154 mEq/L
                pH: 5.0
                Calories: 0 kcal/L
                K/Ca/Mg: 0 mEq/L
                """,
                customImage: "NanoBanana/blood/blood_crystalloids_general"
            )

            fluidCard(
                title: "Lactated Ringer's",
                subtitle: "Ringer's Lactate (LR)",
                icon: "drop.triangle.fill",
                accentColor: crystalTeal,
                content: """
                OVERVIEW:
                Isotonic balanced crystalloid most similar to plasma composition. Lactate metabolized by liver to bicarbonate. Preferred resuscitation fluid in trauma.

                INDICATIONS:
                Hemorrhagic shock. Burns. Surgical fluid replacement. Trauma resuscitation. Dehydration.

                ADVANTAGES:
                Physiologic composition. Less acidosis than NS. Potassium/calcium support cardiac function. Lactate provides buffer.

                DISADVANTAGES:
                NOT compatible with blood (Ca causes clotting). Avoid in hyperkalemia, liver failure (can't metabolize lactate), head injury. Slightly hypotonic.

                COMPOSITION:
                Tonicity: Isotonic (slightly hypotonic)
                Osmolarity: 273 mOsm/L
                Na: 130 mEq/L
                Cl: 109 mEq/L
                K: 4 mEq/L
                Ca: 2.7 mEq/L
                Lactate: 28 mEq/L
                pH: 6.5
                Calories: 9 kcal/L
                """,
                customImage: "NanoBanana/blood/blood_crystalloids_general"
            )

            fluidCard(
                title: "PlasmaLyte",
                subtitle: "Balanced Crystalloid (pH 7.4)",
                icon: "drop.triangle.fill",
                accentColor: crystalTeal,
                content: """
                OVERVIEW:
                Isotonic balanced crystalloid most closely mimicking human plasma. Contains acetate and gluconate (metabolized to bicarbonate). No calcium - compatible with blood.

                INDICATIONS:
                Hemorrhagic shock. Sepsis resuscitation. Surgical replacement. Burns. Acidosis correction. Preferred over NS in many ICU settings.

                ADVANTAGES:
                Most physiologic pH (7.4). No hyperchloremic acidosis. Compatible with blood products (no calcium). Contains magnesium.

                DISADVANTAGES:
                More expensive than NS/LR. Fluid overload risk. Contraindicated in severe alkalosis, hyperkalemia.

                COMPOSITION:
                Tonicity: Isotonic
                Osmolarity: 294 mOsm/L
                Na: 140 mEq/L
                K: 5 mEq/L
                Mg: 3 mEq/L
                Cl: 98 mEq/L
                Acetate: 27 mEq/L
                Gluconate: 23 mEq/L
                pH: 7.4
                Calories: 0 kcal/L
                """,
                customImage: "NanoBanana/blood/blood_crystalloids_general"
            )

            fluidCard(
                title: "3% Saline",
                subtitle: "Hypertonic Saline",
                icon: "drop.triangle.fill",
                accentColor: crystalTeal,
                content: """
                OVERVIEW:
                Hypertonic crystalloid that draws fluid from intracellular/interstitial space into intravascular space. Requires central line for continuous infusion.

                INDICATIONS:
                Severe symptomatic hyponatremia (seizures, coma). Elevated ICP/cerebral edema. Traumatic brain injury. Hypovolemic shock (small volume resuscitation).

                ADVANTAGES:
                Rapid sodium correction. Reduces cerebral edema. Less volume needed for resuscitation. Improves cardiac output.

                DISADVANTAGES:
                Central pontine myelinolysis if Na corrected too fast (limit 8-10 mEq/24h). Hypernatremia. Fluid overload. Hypokalemia. Check Na q2-4h during infusion.

                COMPOSITION:
                Tonicity: Hypertonic
                Osmolarity: 1026 mOsm/L
                Na: 513 mEq/L
                Cl: 513 mEq/L
                pH: 5.0

                DOSING:
                Hyponatremia: 100-150 mL bolus over 10 min (can repeat x2)
                ICP: 250 mL bolus or 30-50 mL/hr continuous
                Goal: Raise Na 4-6 mEq/L acutely, max 8-10 mEq/24h
                """,
                customImage: "NanoBanana/blood/blood_crystalloids_general"
            )

            fluidCard(
                title: "D5 0.45% NS",
                subtitle: "Dextrose in Half Normal Saline",
                icon: "drop.triangle.fill",
                accentColor: crystalTeal,
                content: """
                OVERVIEW:
                Common maintenance fluid combining free water, sodium, and dextrose. Provides daily water, sodium, and minimal calories for NPO patients.

                INDICATIONS:
                Maintenance IV fluids. Post-operative hydration. NPO patients requiring basic metabolic support.

                ADVANTAGES:
                Balanced maintenance fluid. Provides some calories. Prevents starvation ketosis. Good for most maintenance needs.

                DISADVANTAGES:
                Not for resuscitation. Can cause hyponatremia if given too fast. Not enough calories for prolonged NPO.

                COMPOSITION:
                Tonicity: Isotonic in bag, hypotonic once dextrose metabolized
                Osmolarity: 406 mOsm/L
                Na: 77 mEq/L
                Cl: 77 mEq/L
                Dextrose: 50 g/L
                Calories: 170 kcal/L
                pH: 4.0

                DOSING:
                Maintenance: 100-125 mL/hr or 4-2-1 rule based on weight
                """,
                customImage: "NanoBanana/blood/blood_crystalloids_general"
            )

            fluidCard(
                title: "D5 0.9% NS",
                subtitle: "Dextrose in Normal Saline",
                icon: "drop.triangle.fill",
                accentColor: crystalTeal,
                content: """
                OVERVIEW:
                Hypertonic fluid combining isotonic saline with dextrose. Useful when both sodium and calories needed.

                INDICATIONS:
                Addisonian crisis. Hypoglycemia with hypovolemia. Post-surgical patients needing Na and glucose.

                ADVANTAGES:
                Provides sodium, chloride, and calories. Prevents hypoglycemia in diabetics on insulin.

                DISADVANTAGES:
                Hypertonic - can cause fluid shifts. Risk of hypernatremia with large volumes. High chloride load.

                COMPOSITION:
                Tonicity: Hypertonic
                Osmolarity: 560 mOsm/L
                Na: 154 mEq/L
                Cl: 154 mEq/L
                Dextrose: 50 g/L
                Calories: 170 kcal/L
                pH: 4.0
                """,
                customImage: "NanoBanana/blood/blood_crystalloids_general"
            )
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Colloids Content
    private var colloidsContent: some View {
        VStack(spacing: 16) {
            fluidCard(
                title: "Albumin 5%",
                subtitle: "Human Serum Albumin (Iso-oncotic)",
                icon: "testtube.2",
                accentColor: colloidPurple,
                content: """
                OVERVIEW:
                Natural colloid derived from pooled human plasma. Responsible for 70-80% of plasma oncotic pressure. Heat-treated to inactivate viruses. Does NOT require crossmatching.

                INDICATIONS:
                Hypovolemic shock. Burns (after 24h). Hepatorenal syndrome. Large volume paracentesis (>5L). Hypoalbuminemia with edema.

                ADVANTAGES:
                Stays intravascular longer than crystalloids (half-life 16-24h). No coagulation effects. No disease transmission. Expands plasma volume 1:1.

                DISADVANTAGES:
                Expensive. May worsen pulmonary edema. Avoid in severe anemia, heart failure. No survival benefit over crystalloids in most studies (SAFE trial).

                COMPOSITION:
                Albumin: 50 g/L (5 g/dL)
                Osmolarity: 300 mOsm/L
                Na: 130-160 mEq/L
                Volume: 250-500 mL bottles
                Oncotic Pressure: 20 mmHg (iso-oncotic)
                Half-life: 16-24 hours

                DOSING:
                Shock: 25 g (500 mL) rapid infusion, repeat as needed
                Paracentesis: 6-8 g per liter removed (if >5L drained)
                """,
                customImage: "NanoBanana/blood/blood_albumin"
            )

            fluidCard(
                title: "Albumin 25%",
                subtitle: "Concentrated Human Albumin (Hyper-oncotic)",
                icon: "testtube.2",
                accentColor: colloidPurple,
                content: """
                OVERVIEW:
                Concentrated albumin that draws 3-4x its volume of interstitial fluid into intravascular space within 15-30 minutes. Used when volume expansion needed without fluid administration.

                INDICATIONS:
                Hypoalbuminemia with hypovolemia. Diuretic-resistant edema (with furosemide). Ascites mobilization. ARDS with low oncotic pressure.

                ADVANTAGES:
                Minimal volume administration. Powerful oncotic effect. Mobilizes third-space fluid. Rare allergic reactions.

                DISADVANTAGES:
                Can cause pulmonary edema if patient is hypervolemic. Expensive. Infuse slowly (<2-4 mL/min) to avoid hypotension.

                COMPOSITION:
                Albumin: 250 g/L (25 g/dL)
                Osmolarity: 1500 mOsm/L
                Na: 130-160 mEq/L
                Volume: 50-100 mL vials
                Oncotic Pressure: 100 mmHg (hyper-oncotic)
                Volume Expansion: 3.5-4x administered volume

                DOSING:
                Adults: 25-100 g (100-400 mL) over 30-120 min
                Max rate: 2-4 mL/min
                """,
                customImage: "NanoBanana/blood/blood_albumin"
            )

            fluidCard(
                title: "Dextran 40",
                subtitle: "Low Molecular Weight Dextran",
                icon: "testtube.2",
                accentColor: colloidPurple,
                content: """
                OVERVIEW:
                Synthetic branched polysaccharide colloid. Improves microcirculation by reducing blood viscosity and preventing RBC aggregation. Rarely used today.

                INDICATIONS:
                DVT/PE prophylaxis in high-risk surgery. Improve microcirculation in shock. Vascular surgery (graft patency).

                ADVANTAGES:
                Volume expands 1-2x administered volume. Antiplatelet effect improves microcirculation. Prevents RBC sludging.

                DISADVANTAGES:
                Anaphylaxis risk (0.03%). Interferes with blood typing/crossmatch. Coagulopathy with >1.5 L/day. Acute renal failure risk. Interferes with glucose assays.

                COMPOSITION:
                MW: 40,000 Daltons
                Available in NS or D5W
                Volume: 500 mL bottles
                Duration: 4-6 hours intravascular

                DOSING:
                Initial: 500-1000 mL rapidly
                Maintenance: 500 mL/day x 2-3 days
                Max: 20 mL/kg/day (first 24h), then 10 mL/kg/day
                """
            )

            fluidCard(
                title: "Dextran 70",
                subtitle: "High Molecular Weight Dextran",
                icon: "testtube.2",
                accentColor: colloidPurple,
                content: """
                OVERVIEW:
                Higher molecular weight dextran with longer intravascular duration. Greater volume expansion but more side effects than Dextran 40.

                INDICATIONS:
                Hypovolemic shock when blood not available. Plasma volume expansion.

                ADVANTAGES:
                Volume expands 1.5x administered volume. Longer duration than Dextran 40 (12+ hours).

                DISADVANTAGES:
                Higher anaphylaxis risk than Dextran 40. Greater interference with coagulation. Renal impairment risk. Interferes with crossmatching.

                COMPOSITION:
                MW: 70,000 Daltons
                Available in NS or D5W
                Volume: 500 mL bottles
                Duration: 12+ hours intravascular

                DOSING:
                Max: 20 mL/kg in first 24h
                Then: 10 mL/kg/day thereafter
                Do not exceed 5 consecutive days
                """
            )

            fluidCard(
                title: "Hetastarch (Hespan)",
                subtitle: "6% Hydroxyethyl Starch (HES)",
                icon: "testtube.2",
                accentColor: colloidPurple,
                content: """
                OVERVIEW:
                Synthetic colloid derived from amylopectin (corn starch). FDA black box warning: increased mortality and renal injury in critically ill, especially sepsis. Use restricted.

                INDICATIONS:
                Hypovolemia when crystalloid inadequate. NOT recommended in sepsis, critical illness, or renal impairment.

                ADVANTAGES:
                Volume expands 1-1.5x administered volume. Lower cost than albumin. Duration 24-36 hours.

                DISADVANTAGES:
                BLACK BOX WARNING: Increased mortality, renal failure in critically ill. Coagulopathy (decreased Factor VIII, vWF). Pruritus (delayed, may last months). Hyperamylasemia.

                COMPOSITION:
                HES: 60 g/L (6%)
                MW: 450,000 Daltons
                Na: 154 mEq/L
                Cl: 154 mEq/L
                Osmolarity: 310 mOsm/L
                Volume: 500 mL bags

                DOSING:
                Max: 20 mL/kg/day (1500 mL/day for 70 kg)
                Infuse over 30-60 min
                Discontinue at first sign of coagulopathy
                """
            )

            fluidCard(
                title: "Plasmanate",
                subtitle: "Plasma Protein Fraction 5%",
                icon: "testtube.2",
                accentColor: colloidPurple,
                content: """
                OVERVIEW:
                Human plasma-derived colloid containing 83-90% albumin plus alpha/beta globulins. Heat-treated for viral inactivation. Similar to 5% albumin but with additional proteins.

                INDICATIONS:
                Hypovolemic shock. Burns. Hypoproteinemia. Pediatric dehydration shock. ARDS.

                ADVANTAGES:
                No crossmatch needed. Low viral transmission risk. Compatible with blood products. Contains additional plasma proteins.

                DISADVANTAGES:
                Hypotension if infused >10 mL/min (prekallikrein activator). Human product - theoretical infection risk. Expensive.

                COMPOSITION:
                Total Protein: 50 g/L (5%)
                Albumin: 83-90% of protein (44 g/L)
                Alpha/Beta Globulins: 10-17%
                Na: 130-160 mEq/L
                K: <2 mEq/L
                Osmolarity: 290 mOsm/L
                pH: 7.0
                Volume: 250-500 mL bottles

                DOSING:
                Adults: 250-500 mL at 5-8 mL/min (max 10 mL/min)
                Peds: 10-15 mL/kg
                """
            )

            fluidCard(
                title: "Voluven",
                subtitle: "6% HES 130/0.4 (Balanced)",
                icon: "testtube.2",
                accentColor: colloidPurple,
                content: """
                OVERVIEW:
                Third-generation balanced HES solution. Lower molecular weight and substitution ratio than older HES products. Still carries FDA black box warning.

                INDICATIONS:
                Perioperative volume replacement. Hypovolemia (non-septic). Same restrictions as other HES products.

                ADVANTAGES:
                Less coagulopathy than older HES. Shorter tissue accumulation. Balanced electrolyte solution base.

                DISADVANTAGES:
                BLACK BOX WARNING applies. Avoid in sepsis, burns, critical illness, renal impairment. Pruritus. Coagulopathy at high doses.

                COMPOSITION:
                HES: 60 g/L (6%)
                MW: 130,000 Daltons (lower than Hespan)
                Na: 137 mEq/L
                Cl: 110 mEq/L
                K: 4 mEq/L
                Ca: 2.5 mEq/L
                Acetate: 34 mEq/L
                Osmolarity: 286 mOsm/L
                pH: 5.7-6.5

                DOSING:
                Max: 50 mL/kg/day
                Shorter duration use preferred
                """
            )
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Blood Products Content
    private var bloodProductsContent: some View {
        VStack(spacing: 16) {
            fluidCard(
                title: "Packed Red Blood Cells",
                subtitle: "PRBCs / pRBCs",
                icon: "drop.fill",
                accentColor: fluidBlue,
                content: """
                OVERVIEW:
                RBCs separated from whole blood with most plasma removed. Primary product for treating anemia and acute blood loss. Requires ABO/Rh compatibility and crossmatch.

                INDICATIONS:
                Symptomatic anemia. Acute hemorrhage. Hgb <7 g/dL (general). Hgb <8 g/dL (cardiac disease). Massive transfusion protocol.

                ADVANTAGES:
                Increases O2-carrying capacity. Less volume than whole blood. Longer shelf life than whole blood.

                DISADVANTAGES:
                No clotting factors or functional platelets. Requires crossmatch. Risk of TACO, TRALI, hemolytic reactions. Citrate load causes hypocalcemia.

                COMPOSITION:
                Hematocrit: 55-80%
                Volume: 250-350 mL/unit
                Anticoagulant: CPDA-1 or AS-1/AS-3
                Storage: 1-6°C for 35-42 days
                Expected Response: ↑ Hgb 1 g/dL, ↑ Hct 3% per unit

                DOSING:
                Adults: 1-2 units, reassess
                Peds: 10-15 mL/kg
                Infusion: 2-4 hours per unit (within 4h of spike)
                Emergency: Can infuse rapidly via pressure bag
                """,
                customImage: "NanoBanana/blood/blood_packed_red_blood_cells_prbcs"
            )

            fluidCard(
                title: "Fresh Frozen Plasma",
                subtitle: "FFP",
                icon: "snowflake",
                accentColor: fluidBlue,
                content: """
                OVERVIEW:
                Plasma separated and frozen within 8 hours of collection. Contains ALL clotting factors, fibrinogen, albumin, and immunoglobulins. ABO compatible preferred.

                INDICATIONS:
                Coagulopathy with bleeding (INR >1.5-2.0). Warfarin reversal (with Vitamin K). Massive transfusion (1:1:1 ratio). TTP (plasma exchange). DIC. Liver failure with bleeding.

                ADVANTAGES:
                Contains all clotting factors. Replaces multiple factor deficiencies. Can use group AB as universal donor.

                DISADVANTAGES:
                No crossmatch needed but ABO compatible preferred. Must thaw before use (30-45 min). TRALI risk (highest of all products). Volume overload risk.

                COMPOSITION:
                Volume: 200-250 mL/unit
                All clotting factors: ~1 IU/mL
                Fibrinogen: 200-400 mg/unit
                Storage (frozen): -18°C for 1 year
                Storage (thawed): 1-6°C for 24h (5 days if relabeled)
                Expected Response: ↑ clotting factors 2-3% per mL/kg

                DOSING:
                Adults: 10-20 mL/kg (usually 2-4 units)
                Massive transfusion: 1:1 ratio with PRBCs
                Infusion: 200-300 mL/hr
                """,
                customImage: "NanoBanana/blood/blood_fresh_frozen_plasma_ffp"
            )

            fluidCard(
                title: "Platelets",
                subtitle: "Platelet Concentrate / Apheresis Platelets",
                icon: "circle.grid.3x3.fill",
                accentColor: fluidBlue,
                content: """
                OVERVIEW:
                Essential for hemostasis. Available as pooled random donor (4-6 units) or single donor apheresis. ABO compatible preferred. Rh matching important for Rh-negative females.

                INDICATIONS:
                Thrombocytopenia with bleeding. Prophylaxis: <10K (stable), <20K (fever/sepsis), <50K (procedures), <100K (neurosurgery/eye surgery). Platelet dysfunction.

                ADVANTAGES:
                Rapidly increases platelet count. Single donor reduces alloimmunization.

                DISADVANTAGES:
                Short shelf life (5 days). Must store at room temp with agitation. Highest bacterial contamination risk. Contraindicated in TTP, HIT, ITP (unless life-threatening).

                COMPOSITION:
                Volume: 50-70 mL per random unit, 200-400 mL apheresis
                Platelet count: 5.5 x 10¹⁰ per random unit
                Storage: 20-24°C with continuous agitation
                Shelf life: 5 days (bacterial growth risk)
                Expected Response: ↑ 5,000-10,000/µL per unit (pool of 6 = ↑ 30-60K)

                DOSING:
                Adults: 1 apheresis unit OR pool of 4-6 random units
                Peds: 5-10 mL/kg
                Infusion: 30-60 minutes
                Check 1-hour post-transfusion count
                """,
                customImage: "NanoBanana/blood/blood_platelets"
            )

            fluidCard(
                title: "Cryoprecipitate",
                subtitle: "Cryo / Cryoprecipitated AHF",
                icon: "snowflake",
                accentColor: fluidBlue,
                content: """
                OVERVIEW:
                Cold-precipitated proteins from FFP. Concentrated source of fibrinogen, Factor VIII, Factor XIII, vWF, and fibronectin. Pool of 5-10 units typically given.

                INDICATIONS:
                Hypofibrinogenemia (<100-150 mg/dL). DIC with low fibrinogen. Massive transfusion. Von Willebrand disease (if DDAVP/vWF concentrate unavailable). Factor XIII deficiency. Uremic bleeding (fibronectin).

                ADVANTAGES:
                Concentrated fibrinogen in small volume. No crossmatch required (ABO compatible preferred).

                DISADVANTAGES:
                Limited availability. Not for hemophilia A (use factor concentrates). Thawing required.

                COMPOSITION:
                Volume: 10-15 mL per unit
                Fibrinogen: ≥150 mg per unit (usually 200-300 mg)
                Factor VIII: ≥80 IU per unit
                Factor XIII: 50-75 IU per unit
                vWF: 100-150 IU per unit
                Storage (frozen): -18°C for 1 year
                Storage (thawed/pooled): 4-6 hours at room temp
                Expected Response: ↑ fibrinogen 5-10 mg/dL per unit

                DOSING:
                Adults: Pool of 10 units (raises fibrinogen ~70 mg/dL)
                Peds: 1-2 units/10 kg
                Target fibrinogen: >100-150 mg/dL (>200 for neuro)
                """,
                customImage: "NanoBanana/blood/blood_cryoprecipitate"
            )

            fluidCard(
                title: "Whole Blood",
                subtitle: "WB / Low-Titer O Whole Blood",
                icon: "drop.fill",
                accentColor: fluidBlue,
                content: """
                OVERVIEW:
                Complete blood product containing RBCs, plasma, platelets (if fresh), and WBCs. Resurgence in trauma for hemorrhagic shock. Low-titer group O used for emergency universal transfusion.

                INDICATIONS:
                Hemorrhagic shock (trauma, surgery). Massive transfusion. Exchange transfusion (neonates). Military/prehospital settings.

                ADVANTAGES:
                Physiologic resuscitation (all components). Simpler logistics than component therapy. Better outcomes in trauma (some studies). Less citrate load per RBC dose.

                DISADVANTAGES:
                Limited availability. Short shelf life for functional platelets (<14 days). Requires ABO-identical or low-titer O-negative. Higher volume per RBC dose than PRBCs.

                COMPOSITION:
                Volume: 450-500 mL per unit
                Hematocrit: 35-40%
                Contains: RBCs, plasma, platelets (if <14 days), WBCs
                Storage: 1-6°C for 21-35 days (CPDA-1)
                Functional platelets: Only in "fresh" WB (<14 days)

                DOSING:
                Adults: 1-2 units, reassess
                Massive hemorrhage: Continue until bleeding controlled
                Infusion: Can give rapidly in emergency (pressure bag)
                """,
                customImage: "NanoBanana/blood/blood_whole_blood"
            )

            fluidCard(
                title: "Washed Red Blood Cells",
                subtitle: "Washed RBCs",
                icon: "drop.fill",
                accentColor: fluidBlue,
                content: """
                OVERVIEW:
                PRBCs washed with saline to remove >99% plasma proteins, WBCs, and platelets. Used for patients with severe allergic/anaphylactic transfusion reactions.

                INDICATIONS:
                IgA deficiency with anti-IgA antibodies. Severe/recurrent allergic transfusion reactions. Complement-dependent autoimmune hemolytic anemia. Paroxysmal nocturnal hemoglobinuria.

                ADVANTAGES:
                Removes plasma proteins causing reactions. Removes potassium (good for renal failure). Reduces allergic reactions.

                DISADVANTAGES:
                Short shelf life after washing (24 hours). 10-20% RBC loss during washing. Time-consuming preparation. Expensive.

                COMPOSITION:
                Volume: ~180-200 mL per unit
                Hematocrit: 70-80%
                Plasma removed: >99%
                WBCs removed: >85%
                Storage (after washing): 1-6°C for only 24 hours
                Expected Response: ↑ Hgb 0.8-1 g/dL per unit (slightly less than PRBC)

                DOSING:
                Same as PRBCs: 1-2 units
                Must be used within 24h of washing
                """
            )

            fluidCard(
                title: "Leukoreduced Blood",
                subtitle: "Leukocyte-Reduced / Filtered RBCs",
                icon: "drop.fill",
                accentColor: fluidBlue,
                content: """
                OVERVIEW:
                PRBCs filtered to remove >99.9% WBCs (<5 x 10⁶ residual). Standard of care in many institutions. Reduces febrile reactions and CMV transmission.

                INDICATIONS:
                CMV-negative recipients (transplant, immunocompromised). History of febrile non-hemolytic reactions. Chronic transfusion patients. All transfusions (universal leukoreduction in many centers).

                ADVANTAGES:
                Reduces febrile reactions. Decreases HLA alloimmunization. CMV-safe (WBC-associated virus). Reduces immunomodulation.

                DISADVANTAGES:
                Slightly more expensive. Filter can slow infusion. Does not prevent allergic reactions (plasma proteins).

                COMPOSITION:
                Volume: ~250-350 mL per unit
                Residual WBCs: <5 x 10⁶ (vs 10⁹ in standard PRBC)
                Hematocrit: 55-65%
                Storage: Same as standard PRBCs (35-42 days)
                CMV transmission risk: <1% (considered CMV-safe)

                DOSING:
                Same as PRBCs: 10-15 mL/kg peds, 1-2 units adult
                """
            )

            fluidCard(
                title: "Irradiated Blood Products",
                subtitle: "Irradiated RBCs/Platelets",
                icon: "bolt.fill",
                accentColor: fluidBlue,
                content: """
                OVERVIEW:
                Blood products exposed to gamma or X-ray irradiation (25-50 Gy) to inactivate donor lymphocytes. Prevents transfusion-associated graft-versus-host disease (TA-GVHD).

                INDICATIONS:
                Immunocompromised (stem cell/bone marrow transplant). Congenital immunodeficiency. Hodgkin lymphoma. Intrauterine transfusions. Directed donations from relatives. HLA-matched platelets.

                ADVANTAGES:
                Prevents fatal TA-GVHD. No change to RBC/platelet function.

                DISADVANTAGES:
                Increases potassium leak from RBCs. Shortened shelf life for RBCs (28 days from irradiation). Requires special processing.

                COMPOSITION:
                Irradiation dose: 25-50 Gy
                K+ release: Accelerated (use fresh or wash for neonates)
                RBC shelf life: 28 days from irradiation (or original expiration if sooner)
                Platelet shelf life: Unchanged (5 days total)

                DOSING:
                Same as non-irradiated products
                For neonates: Use <7 days old or wash to reduce K+
                """
            )
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Fluid Card Component
    private func fluidCard(title: String, subtitle: String, icon: String, accentColor: Color, content: String, customImage: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 12) {
                if let customImage = customImage, UIImage(named: customImage) != nil {
                    CatalogThumbnailImage(name: customImage, size: 80, cornerRadius: 12)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor, accentColor.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)

                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .shadow(color: accentColor.opacity(0.3), radius: 4, y: 2)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Poppins-SemiBold", size: 17))
                        .foregroundColor(textPrimary)

                    Text(subtitle)
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(accentColor)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)

            // Content
            Text(formatFluidContent(content))
                .lineSpacing(6)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.1), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [accentColor.opacity(0.08), Color.white.opacity(0.3), Color.clear],
                                    startPoint: .top,
                                    endPoint: .center
                                )
                            )
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            accentColor.opacity(0.3),
                            colorScheme == .dark ? accentColor.opacity(0.12) : Color.white.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : accentColor.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    // MARK: - Content Formatter
    private func formatFluidContent(_ content: String) -> AttributedString {
        let headings = ["OVERVIEW:", "INDICATIONS:", "ADVANTAGES:", "DISADVANTAGES:", "COMPOSITION:", "DOSING:", "Note:"]
        return ContentFormatter.format(content, headings: headings, baseFontSize: 14, isDarkMode: colorScheme == .dark)
    }
}

// MARK: - Preview
struct Fluids_BloodDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Fluids_BloodDetailsView()
    }
}
