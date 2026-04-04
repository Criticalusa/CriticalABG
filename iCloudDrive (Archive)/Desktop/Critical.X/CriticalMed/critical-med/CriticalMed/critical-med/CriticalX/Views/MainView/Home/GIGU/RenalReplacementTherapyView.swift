//
//  RenalReplacementTherapyView.swift
//  CriticalX
//
//  Premium Light Theme - Comprehensive RRT Education
//  Following ECMOView design patterns
//

import SwiftUI

// MARK: - RRT Modality Type
enum RRTModalityType: String, CaseIterable {
    case intermittent = "Intermittent"
    case continuous = "Continuous"
    case hybrid = "Hybrid"
    case peritoneal = "Peritoneal"
    
    var color: Color {
        switch self {
        case .intermittent: return Color(red: 0.20, green: 0.45, blue: 0.70)
        case .continuous: return Color(red: 0.35, green: 0.55, blue: 0.50)
        case .hybrid: return Color(red: 0.55, green: 0.45, blue: 0.60)
        case .peritoneal: return Color(red: 0.70, green: 0.50, blue: 0.35)
        }
    }
}

// MARK: - RRT Modality Model
struct RRTModality: Identifiable {
    let id = UUID()
    let abbreviation: String
    let name: String
    let type: RRTModalityType
    let mechanism: String
    let duration: String
    let keyFeature: String
    let icon: String
    
    // Detailed content
    let overview: String
    let mechanismDetail: String
    let indications: [String]
    let contraindications: [String]
    let accessRequirements: String
    let typicalSettings: String
    let advantages: [String]
    let disadvantages: [String]
    let clinicalPearls: [String]
}

// MARK: - RRT Modalities Data
extension RRTModality {
    static let allModalities: [RRTModality] = [
        // IHD - Intermittent Hemodialysis
        RRTModality(
            abbreviation: "IHD",
            name: "Intermittent Hemodialysis",
            type: .intermittent,
            mechanism: "Diffusion",
            duration: "3-4 h, 3x/week",
            keyFeature: "High efficiency, rapid clearance",
            icon: "clock.arrow.2.circlepath",
            overview: "This is standard dialysis—3-4 hours, a few times a week. Blood flows fast (300-400 mL/min), dialysate flows fast, and you clear a lot quickly. It's efficient but causes rapid shifts, so it's not ideal for unstable patients.",
            mechanismDetail: "IHD uses diffusion—small molecules like urea, creatinine, and potassium move from blood to dialysate across a concentration gradient. The high flow rates clear toxins fast, but that speed is exactly why patients get hypotensive.",
            indications: [
                "Stable patients with AKI or ESKD",
                "Severe hyperkalemia needing rapid correction",
                "Toxic alcohols (methanol, ethylene glycol)",
                "Severe acidosis in stable patients"
            ],
            contraindications: [
                "Hemodynamic instability—hypotension is common",
                "Critically ill ICU patients",
                "Cerebral edema or high ICP (risk of DDS)",
                "Active bleeding with coagulopathy"
            ],
            accessRequirements: "AV fistula or graft for chronic patients. Temporary dialysis catheter (vascath) for acute. Right IJ preferred. Must have good flow.",
            typicalSettings: "Blood flow: 300-400 mL/min\nDialysate flow: 500 mL/min (30 L/h)\nDuration: 3-4 hours, 3x/week\nUrea clearance: ~150 mL/min\nEfficiency: HIGH",
            advantages: [
                "Fastest solute clearance",
                "Clears potassium quickly",
                "Short sessions (3-4 hours)",
                "Usually no anticoagulation needed",
                "Lower cost than CRRT",
                "Patient mobile between sessions"
            ],
            disadvantages: [
                "Hypotension is common—rapid shifts",
                "Not for unstable ICU patients",
                "Risk of dialysis disequilibrium syndrome",
                "Toxins with high volume of distribution can rebound"
            ],
            clinicalPearls: [
                "You usually don't need anticoagulation for IHD—that's a key difference from CRRT.",
                "Dialysis disequilibrium: If BUN is very high (>100), rapid clearance causes brain swelling. Start slow.",
                "IHD is great for toxic alcohols (small, low volume of distribution). Lithium can rebound after dialysis.",
                "Give dialyzed medications AFTER the session, not before. Check each drug.",
                "If they drop their pressure during IHD, they probably need CRRT instead."
            ]
        ),
        
        // CRRT Overview
        RRTModality(
            abbreviation: "CRRT",
            name: "Continuous Renal Replacement Therapy",
            type: .continuous,
            mechanism: "Various",
            duration: "24h/filter",
            keyFeature: "Hemodynamic stability",
            icon: "infinity.circle.fill",
            overview: "This is dialysis for unstable patients. It runs 24 hours a day, slower and gentler than IHD. Blood flows at 150-200 mL/min—less efficient per hour, but it's continuous so you clear plenty over time.",
            mechanismDetail: "CRRT can use convection (CVVH), diffusion (CVVHD), or both (CVVHDF). The continuous, slow approach avoids the rapid shifts that cause hypotension in IHD. That's the whole point—hemodynamic stability.",
            indications: [
                "Hemodynamically unstable patients",
                "Septic shock with AKI",
                "Multiorgan failure",
                "Cerebral edema (no DDS risk)",
                "Severe fluid overload needing slow removal",
                "High volume of distribution toxins"
            ],
            contraindications: [
                "Goals of care discussion ongoing",
                "Futile resuscitation",
                "No vascular access available",
                "Stable patients who can tolerate IHD"
            ],
            accessRequirements: "Vascath only—you can't use a fistula for CRRT. Right IJ preferred. Femoral is an option but higher infection risk. The patient will be immobile.",
            typicalSettings: "Blood flow: 150-200 mL/min\nDialysate flow: ~1 L/h (CVVHDF)\nEffluent dose: 20-25 mL/kg/hr\nUrea clearance: ~30 mL/min\nAnticoagulation: Regional citrate or heparin",
            advantages: [
                "Hemodynamically stable—the main reason to use it",
                "Gentle, gradual fluid removal",
                "No dialysis disequilibrium",
                "Can run continuously",
                "Good for unstable ICU patients"
            ],
            disadvantages: [
                "ICU only—patient can't move",
                "High nursing workload",
                "Anticoagulation required (filter clots = blood loss)",
                "More expensive than IHD",
                "Slower toxin clearance",
                "Therapy interruptions reduce actual dose"
            ],
            clinicalPearls: [
                "You need anticoagulation for CRRT. If the filter clots, you lose about 150 mL of blood. Citrate is preferred if bleeding risk.",
                "CRRT isn't better than IHD—outcomes are the same. You use CRRT because the patient can't tolerate IHD.",
                "Actual delivered dose is 15-20% lower than prescribed. Downtime for scans, procedures, and filter changes adds up.",
                "With citrate, watch the ionized calcium. Citrate toxicity = low iCa with normal total calcium.",
                "Drug dosing is complicated. Many drugs get cleared. Consult pharmacy for complex patients."
            ]
        ),
        
        // CVVH
        RRTModality(
            abbreviation: "CVVH",
            name: "Continuous Veno-Venous Hemofiltration",
            type: .continuous,
            mechanism: "Convection",
            duration: "24/7 continuous",
            keyFeature: "Middle molecule clearance",
            icon: "arrow.up.arrow.down.circle.fill",
            overview: "CVVH uses convection—plasma water gets pushed through a membrane, dragging solutes with it. Good for clearing middle-sized molecules like cytokines. You add replacement fluid to maintain volume.",
            mechanismDetail: "This is 'solvent drag'—bulk flow of water pulls solutes through the membrane. It clears both small molecules and middle molecules (up to 30-40 kDa), which diffusion doesn't do as well.",
            indications: [
                "Sepsis (theoretical cytokine clearance)",
                "Middle-molecular-weight toxins",
                "Unstable AKI patients"
            ],
            contraindications: [
                "Same as CRRT generally"
            ],
            accessRequirements: "Vascath only. Can't use a fistula.",
            typicalSettings: "Blood flow: 150-200 mL/min\nUltrafiltration rate: 25-35 mL/kg/hr\nDialysate: None (pure hemofiltration)\nReplacement fluid: Pre or post-dilution\nAnticoagulation: Required",
            advantages: [
                "Clears middle molecules better than diffusion",
                "May remove inflammatory mediators",
                "Hemodynamically gentle"
            ],
            disadvantages: [
                "Less efficient for small molecules than CVVHD",
                "Uses lots of replacement fluid (expensive)",
                "Post-dilution increases clotting risk"
            ],
            clinicalPearls: [
                "Pre-dilution = less clotting but 15% less efficient. Post-dilution = more efficient but more clotting.",
                "Cytokine removal sounds great in theory, but there's no proven mortality benefit in sepsis.",
                "High-volume hemofiltration (>35 mL/kg/hr) doesn't improve outcomes. Don't go higher just because.",
                "Phosphorus gets cleared well—watch for hypophosphatemia and replace."
            ]
        ),
        
        // CVVHD
        RRTModality(
            abbreviation: "CVVHD",
            name: "Continuous Veno-Venous Hemodialysis",
            type: .continuous,
            mechanism: "Diffusion",
            duration: "24/7 continuous",
            keyFeature: "Small molecule clearance",
            icon: "arrow.left.arrow.right.circle.fill",
            overview: "CVVHD uses diffusion—dialysate flows opposite to blood, and small molecules move down their concentration gradient. Best for clearing urea, creatinine, and potassium.",
            mechanismDetail: "Diffusion works best for small molecules. Larger molecules don't cross the membrane as efficiently, so if you want middle molecule clearance, you need convection.",
            indications: [
                "AKI needing small molecule clearance",
                "Hyperkalemia requiring continuous control",
                "Uremia in unstable patients"
            ],
            contraindications: [
                "Same as CRRT generally"
            ],
            accessRequirements: "Vascath only. Can't use a fistula.",
            typicalSettings: "Blood flow: 150-200 mL/min\nDialysate flow: 20-25 mL/kg/hr (~1-1.5 L/h)\nNo replacement fluid needed\nAnticoagulation: Required",
            advantages: [
                "Good small molecule clearance",
                "No replacement fluid needed (simpler, cheaper)",
                "Easy to set up",
                "Works well for uremia and hyperkalemia"
            ],
            disadvantages: [
                "Less middle molecule clearance",
                "Still needs anticoagulation"
            ],
            clinicalPearls: [
                "CVVHD is often the simplest CRRT mode to start with.",
                "For most AKI patients, this provides adequate clearance.",
                "If they get hypokalemic, you can add potassium to the dialysate.",
                "Bicarbonate dialysate is standard. Lactate-based is an alternative."
            ]
        ),
        
        // CVVHDF
        RRTModality(
            abbreviation: "CVVHDF",
            name: "Continuous Veno-Venous Hemodiafiltration",
            type: .continuous,
            mechanism: "Convection + Diffusion",
            duration: "24/7 continuous",
            keyFeature: "Combined clearance",
            icon: "arrow.triangle.2.circlepath.circle.fill",
            overview: "CVVHDF combines both mechanisms—convection and diffusion. You get small molecule clearance AND middle molecule clearance. This is the default at many institutions.",
            mechanismDetail: "Diffusion clears small molecules, convection clears middle molecules. CVVHDF does both. It's the most versatile CRRT mode, though more complex to set up.",
            indications: [
                "Severe AKI needing maximum clearance",
                "Sepsis when you want both cytokine and uremic toxin removal",
                "Complex poisonings"
            ],
            contraindications: [
                "Same as CRRT generally"
            ],
            accessRequirements: "Vascath only. Can't use a fistula.",
            typicalSettings: "Blood flow: 150-200 mL/min\nDialysate flow: ~1 L/h\nReplacement flow: 10-15 mL/kg/hr\nTotal effluent: 20-30 mL/kg/hr\nAnticoagulation: Required",
            advantages: [
                "Maximum solute clearance",
                "Clears both small and middle molecules",
                "Most flexible—can adjust the ratio"
            ],
            disadvantages: [
                "Most complex setup",
                "Highest cost",
                "More nursing attention required",
                "No proven outcome advantage over simpler modes"
            ],
            clinicalPearls: [
                "Many institutions use CVVHDF as the default CRRT mode.",
                "Total effluent = dialysate + replacement + net ultrafiltration.",
                "No RCT shows CVVHDF is better than CVVH or CVVHD. Pick what you're comfortable with.",
                "A common approach: split 50% dialysate, 50% replacement.",
                "Higher doses (>25 mL/kg/hr) don't improve mortality. Don't chase numbers."
            ]
        ),
        
        // SLED/PIRRT
        RRTModality(
            abbreviation: "SLED",
            name: "Sustained Low-Efficiency Dialysis",
            type: .hybrid,
            mechanism: "Diffusion",
            duration: "6-12 h daily",
            keyFeature: "Hybrid: IHD + CRRT benefits",
            icon: "dial.medium.fill",
            overview: "SLED is a hybrid—slower than IHD, not quite CRRT. You run it 6-12 hours daily with lower flow rates. Hemodynamically gentler than IHD, less resource-intensive than CRRT. A good middle ground.",
            mechanismDetail: "Uses diffusion like IHD, but slower rates over longer duration. This gives you hemodynamic stability without needing 24-hour CRRT. It's gaining popularity because outcomes are similar to CRRT.",
            indications: [
                "ICU patients who don't tolerate IHD",
                "Borderline hemodynamic stability",
                "Resource-limited settings",
                "Transitioning off CRRT before discharge",
                "When you don't want continuous anticoagulation"
            ],
            contraindications: [
                "Severe hemodynamic instability (use CRRT)",
                "Severe cerebral edema"
            ],
            accessRequirements: "Can use fistula or vascath. Same machines as IHD with modified settings.",
            typicalSettings: "Blood flow: 100-150 mL/min\nDialysate flow: 100-200 mL/min (6-12 L/h)\nDuration: 6-12 hours daily\nUrea clearance: ~80 mL/min\nAnticoagulation: Usually not needed",
            advantages: [
                "Hemodynamically stable like CRRT",
                "More efficient than CRRT",
                "Usually no anticoagulation needed",
                "Less resource-intensive than CRRT",
                "Can use fistula or vascath",
                "Patient can move during the day"
            ],
            disadvantages: [
                "Not continuous",
                "Not available everywhere",
                "Drug pharmacokinetics unclear",
                "If filter clots, you lose blood"
            ],
            clinicalPearls: [
                "You usually don't need anticoagulation for SLED—a big advantage over CRRT.",
                "Outcomes are similar to CRRT. SLED is becoming more popular as ICUs realize this.",
                "Often done overnight so the patient is free for procedures during the day.",
                "Drug dosing is tricky and not well-studied. Ask pharmacy for complex patients.",
                "Good option for ICU patients with hyperkalemia who can't tolerate IHD but don't need full CRRT."
            ]
        ),
        
        // Peritoneal Dialysis
        RRTModality(
            abbreviation: "PD",
            name: "Peritoneal Dialysis",
            type: .peritoneal,
            mechanism: "Diffusion + Osmosis",
            duration: "Continuous or cycler",
            keyFeature: "No vascular access",
            icon: "drop.degreesign.fill",
            overview: "PD uses the peritoneum as a natural dialysis membrane. You put dialysate in the belly, let it dwell, then drain it. No vascular access needed—that's the big advantage.",
            mechanismDetail: "Diffusion clears solutes across the peritoneum. Glucose in the dialysate creates an osmotic gradient to pull off water. Higher dextrose = more fluid removal.",
            indications: [
                "Home dialysis for ESKD",
                "Pediatric patients",
                "No vascular access available",
                "Patient preference for independence",
                "Acute PD in resource-limited settings"
            ],
            contraindications: [
                "Recent abdominal surgery",
                "Active peritonitis",
                "Abdominal adhesions or hernia",
                "Severe respiratory compromise (fluid pushes up on diaphragm)"
            ],
            accessRequirements: "Tenckhoff catheter placed surgically or percutaneously. Ideally let it heal 2 weeks before using.",
            typicalSettings: "CAPD: 4 exchanges/day, 2L each, 4-6 hour dwells\nAPD: Cycler overnight, 8-10 hours\nDextrose: 1.5%, 2.5%, or 4.25%",
            advantages: [
                "Done at home—patient independence",
                "No vascular access needed",
                "Hemodynamically gentle",
                "Preserves residual kidney function longer"
            ],
            disadvantages: [
                "Risk of peritonitis",
                "Less efficient than hemodialysis",
                "Protein losses in dialysate",
                "Glucose load affects diabetes control"
            ],
            clinicalPearls: [
                "PD is rarely used acutely in modern ICUs, but it works.",
                "Peritonitis = cloudy dialysate + abdominal pain. WBC >100/μL in fluid is diagnostic.",
                "Higher dextrose pulls more fluid, but makes blood sugar harder to control.",
                "Often the preferred modality for young, active ESKD patients who want independence.",
                "Icodextrin is an alternative osmotic agent when the membrane stops working well."
            ]
        )
    ]
}

// MARK: - Main View
struct RenalReplacementTherapyView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedModality: RRTModality?
    @State private var showComparisonTable = false
    @State private var showAllPearls = false
    
    // MARK: - Formatted Content
    private var overviewContent: AttributedString {
        ContentFormatter.format("""
        The Big Picture:
        RRT replaces kidney function when the kidneys fail. The modality doesn't matter as much as the decision—when to start, and how aggressively to clear.

        The Real Question:
        IHD vs CRRT isn't about which is "better"—outcomes are the same. It's about hemodynamics. Unstable patient? CRRT. Stable patient? IHD. That's the decision.

        What You'll Learn Here:
        Each modality has different mechanisms, settings, and trade-offs. Understanding when to use what helps you feel confident at the bedside.
        """, headings: ["The Big Picture:", "The Real Question:", "What You'll Learn Here:"], isDarkMode: colorScheme == .dark)
    }

    private var indicationsContent: AttributedString {
        ContentFormatter.format("""
        AEIOU - When To Start:
        • A - Acidosis: pH < 7.1 that isn't improving with bicarb
        • E - Electrolytes: Hyperkalemia > 6.5 that won't come down with meds
        • I - Intoxication: Dialyzable poisons (lithium, methanol, ethylene glycol, salicylates)
        • O - Overload: Fluid overload that won't respond to diuretics
        • U - Uremia: Encephalopathy, pericarditis, or uremic bleeding

        These are guidelines, not rules. Sometimes you start RRT before hitting these thresholds if the trajectory is clearly heading there.
        """, headings: ["AEIOU - When To Start:"], isDarkMode: colorScheme == .dark)
    }

    // Clinical Pearls content
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(
            header: "IHD vs CRRT:",
            content: "Stop debating which is better—outcomes are the same. The choice is about hemodynamics. If they're unstable, use CRRT. If stable, IHD is fine."
        ),
        CriticalPearlItem(
            header: "Dose Matters Less Than You Think:",
            content: "20-25 mL/kg/hr is the target. Higher doses don't improve survival. And remember—actual delivered dose is 15-20% lower than prescribed due to downtime."
        ),
        CriticalPearlItem(
            header: "Citrate Over Heparin:",
            content: "Regional citrate is preferred if there's bleeding risk. Watch the ionized calcium—citrate toxicity shows low iCa with normal total calcium. That's your warning sign."
        ),
        CriticalPearlItem(
            header: "Drug Dosing Is Tricky:",
            content: "Small, water-soluble, low protein-binding drugs get cleared by dialysis. When in doubt, check a reference or ask pharmacy. Don't guess."
        ),
        CriticalPearlItem(
            header: "When To Stop:",
            content: "If urine output comes back (>400-500 mL/day) and creatinine is trending down without dialysis, you can stop. You don't need to wean—just stop."
        )
    ]
    
    var body: some View {
        ZStack {
            // Premium light background
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    HStack {
                        Spacer()
                        PremiumLightCloseButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }
                    
                    // MARK: - Title Section (Hero Header)
                    VStack(spacing: 16) {
                        // Icon with glass effect
                        ZStack {
                            if colorScheme == .dark {
                                Circle()
                                    .fill(CriticalDesign.Colors.cardBlue)
                                    .frame(width: 140, height: 140)
                            } else {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 140, height: 140)
                                Circle()
                                    .fill(Color.white.opacity(0.5))
                                    .frame(width: 140, height: 140)
                            }

                            Circle()
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                .frame(width: 140, height: 140)

                            Image(systemName: "drop.circle.fill")
                                .font(.system(size: 60, weight: .medium))
                                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                        }
                        .shadow(color: colorScheme == .dark ? Color.clear : Color.black.opacity(0.1), radius: 10, y: 4)
                        
                        // Title
                        Text("RRT")
                            .font(.custom("Poppins-Bold", size: 32))
                            .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
                        
                        Text("Renal Replacement Therapy")
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.4))
                            .multilineTextAlignment(.center)
                        
                        // Quick stats row
                        HStack(spacing: 24) {
                            quickStat(icon: "number", value: "7", label: "Modalities")
                            quickStat(icon: "cross.case.fill", value: "ICU", label: "Focused")
                        }
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 12)
                    
                    // MARK: - Overview Card
                    PremiumLightGlassCard(
                        title: "Overview",
                        icon: "doc.text.fill",
                        content: overviewContent
                    )
                    
                    // MARK: - Indications Card (Warning style)
                    indicationsCard
                    
                    // MARK: - Comparison Table Button
                    comparisonButton
                    
                    // MARK: - Modalities Section
                    VStack(spacing: 12) {
                        ForEach(RRTModality.allModalities) { modality in
                            modalityCard(modality: modality)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - Calculator Link Card
                    calculatorLinkCard
                    
                    // MARK: - Clinical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .padding(.bottom, 40)
                }
            }
        }
        .sheet(item: $selectedModality) { modality in
            RRTModalityDetailView(modality: modality)
        }
        .sheet(isPresented: $showComparisonTable) {
            RRTComparisonView()
        }
    }
    
    // MARK: - Quick Stat View
    private func quickStat(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))

            Text(value)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))

            Text(label)
                .font(.custom("Poppins-Regular", size: 11))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : Color(red: 0.4, green: 0.4, blue: 0.5))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.5))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.15 : 0.6), lineWidth: 1)
        )
    }
    
    // MARK: - Indications Card (Warning Style)
    private var indicationsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with warning icon
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [
                                Color.orange.opacity(0.9),
                                Color.orange.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.orange.opacity(0.3), radius: 4, y: 2)
                
                Text("When to Consider RRT")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(Color.orange)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            // Content
            Text(indicationsContent)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.orange.opacity(0.08))
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.orange.opacity(0.05))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : Color.orange.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Comparison Button
    private var comparisonButton: some View {
        Button(action: {
            showComparisonTable = true
        }) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.15))
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: "table.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Modality Comparison Table")
                        .font(.custom("Poppins-Bold", size: 17))
                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
                    
                    Text("IHD vs CRRT vs SLED at a glance")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.25, green: 0.25, blue: 0.3))
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.12))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
            }
            .padding(18)
            .background(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.ultraThinMaterial)
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.white.opacity(0.5))
                        }
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.4),
                                colorScheme == .dark
                                    ? Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.15)
                                    : Color.white.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
            .shadow(color: colorScheme == .dark ? Color.clear : Color(red: 0.2, green: 0.5, blue: 0.8).opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
    }

    // MARK: - Modality Card (ECMOView accent card style)
    private func modalityCard(modality: RRTModality) -> some View {
        Button(action: {
            selectedModality = modality
        }) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 8) {
                            Text(modality.abbreviation)
                                .font(.custom("Poppins-Bold", size: 18))
                                .foregroundColor(modality.type.color)
                            
                            Text("•")
                                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : Color(red: 0.4, green: 0.4, blue: 0.5))
                            
                            Text(modality.type.rawValue)
                                .font(.custom("Poppins-Medium", size: 12))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(
                                    Capsule()
                                        .fill(modality.type.color)
                                )
                        }
                        
                        Text(modality.name)
                            .font(.custom("Poppins-Medium", size: 13))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.25, green: 0.25, blue: 0.3))
                        
                        Text("\(modality.mechanism) • \(modality.duration)")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : Color(red: 0.4, green: 0.4, blue: 0.5))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(modality.type.color.opacity(0.15))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: modality.icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(modality.type.color)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
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
                                        colors: [modality.type.color.opacity(0.15), Color.clear],
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
                                        colors: [modality.type.color.opacity(0.1), Color.white.opacity(0.3), Color.clear],
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
                                modality.type.color.opacity(0.4),
                                colorScheme == .dark ? modality.type.color.opacity(0.15) : Color.white.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
            .shadow(color: colorScheme == .dark ? Color.clear : modality.type.color.opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Calculator Link Card
    private var calculatorLinkCard: some View {
        let gold = Color(red: 0.96, green: 0.71, blue: 0.0)
        
        return NavigationLink(destination: CRRTDosingView()) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(gold.opacity(0.15))
                        .frame(width: 52, height: 52)
                    
                    Image(systemName: "function")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(gold)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("CRRT Dosing Calculator")
                        .font(.custom("Poppins-Bold", size: 17))
                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
                    
                    Text("Calculate effluent dose based on weight")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.25, green: 0.25, blue: 0.3))
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(gold.opacity(0.12))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(gold)
                }
            }
            .padding(18)
            .background(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.ultraThinMaterial)
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.white.opacity(0.5))
                        }
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [gold.opacity(0.5), gold.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
            .shadow(color: gold.opacity(colorScheme == .dark ? 0.0 : 0.15), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    RenalReplacementTherapyView()
}
