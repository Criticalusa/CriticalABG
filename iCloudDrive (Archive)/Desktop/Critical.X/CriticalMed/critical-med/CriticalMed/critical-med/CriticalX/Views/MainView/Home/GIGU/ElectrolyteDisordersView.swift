//
//  ElectrolyteDisordersView.swift
//  CriticalX
//
//  Premium Light Theme - Electrolyte Disorders Education
//  Following ECMOView design patterns
//

import SwiftUI

// MARK: - Electrolyte Disorder Model
struct ElectrolyteDisorder: Identifiable {
    let id = UUID()
    let name: String
    let abbreviation: String
    let icon: String
    let color: Color
    let overview: String
    let causes: String
    let symptoms: String
    let treatment: String
}

// MARK: - Electrolyte Disorders View
struct ElectrolyteDisordersView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var showAllPearls = false
    @State private var selectedDisorder: ElectrolyteDisorder?
    
    // Accent color
    private let accentColor = Color(red: 0.55, green: 0.45, blue: 0.65) // Soft purple
    
    // Electrolyte disorders
    private let disorders: [ElectrolyteDisorder] = [
        ElectrolyteDisorder(
            name: "Hyperkalemia",
            abbreviation: "↑K+",
            icon: "arrow.up.circle.fill",
            color: Color(red: 0.75, green: 0.30, blue: 0.30),
            overview: "K+ >5.0 is elevated. Above 6.5, you're worried about cardiac arrest. This is the one that can kill quickly.",
            causes: "Kidney failure is #1. Also ACE-I/ARBs, K-sparing diuretics, rhabdo, acidosis, tumor lysis. Check the med list.",
            symptoms: "Weakness, paresthesias, then ECG changes—peaked T waves, wide QRS, sine wave. Then arrest.",
            treatment: "Stabilize the heart first (calcium gluconate), then shift K+ into cells (insulin + glucose), then remove it (kayexalate, dialysis)."
        ),
        ElectrolyteDisorder(
            name: "Hypokalemia",
            abbreviation: "↓K+",
            icon: "arrow.down.circle.fill",
            color: Color(red: 0.85, green: 0.65, blue: 0.15),
            overview: "K+ <3.5 is low. Below 3.0, arrhythmia risk climbs. This is common and usually fixable.",
            causes: "Diuretics, vomiting, diarrhea, refeeding, insulin, alkalosis. Check the mag—low mag makes low K+ hard to fix.",
            symptoms: "Weakness, cramping, U waves on ECG, flattened T waves, prolonged QT. Can cause arrhythmias.",
            treatment: "Replace with KCl—IV for severe (<3.0), PO for mild. Max IV rate 10-20 mEq/h. Always fix the mag first."
        ),
        ElectrolyteDisorder(
            name: "Hypernatremia",
            abbreviation: "↑Na+",
            icon: "drop.fill",
            color: Color(red: 0.20, green: 0.50, blue: 0.70),
            overview: "Na+ >145 means the patient is missing free water. They're dehydrated or can't drink. Rarely from too much sodium.",
            causes: "Dehydration (not drinking, can't drink), diabetes insipidus, sometimes hypertonic saline or tube feeds.",
            symptoms: "Thirst, confusion, lethargy, seizures. If severe and acute, brain hemorrhage.",
            treatment: "Give free water (D5W or half-normal). Correct slowly—no faster than 10 mEq/L per day to avoid cerebral edema."
        ),
        ElectrolyteDisorder(
            name: "Hyponatremia",
            abbreviation: "↓Na+",
            icon: "drop.triangle.fill",
            color: Color(red: 0.35, green: 0.55, blue: 0.50),
            overview: "Na+ <135 is low. This is the most common electrolyte problem you'll see in the hospital.",
            causes: "SIADH, heart failure, cirrhosis, diuretics, drinking too much water, adrenal insufficiency. Figure out the volume status first.",
            symptoms: "Nausea, headache, confusion, seizures. Fix it too fast and you cause osmotic demyelination—that's permanent damage.",
            treatment: "Treat the cause. Fluid restrict if euvolemic. Hypertonic saline if seizing. Correct <8-10 mEq/L per 24h—slow is safe."
        ),
        ElectrolyteDisorder(
            name: "Hypercalcemia",
            abbreviation: "↑Ca++",
            icon: "bolt.circle.fill",
            color: Color(red: 0.70, green: 0.50, blue: 0.35),
            overview: "Corrected Ca >10.5 is high. Above 14 is a crisis. In the hospital, think malignancy first.",
            causes: "Malignancy (#1 in hospital), hyperparathyroidism (#1 outpatient), granulomatous disease. Get a PTH.",
            symptoms: "'Stones, bones, groans, moans'—kidney stones, bone pain, abdominal pain, confusion. Short QT on ECG.",
            treatment: "Volume first—give lots of saline. Then calcitonin for quick drop, bisphosphonates for sustained effect. Dialysis if refractory."
        ),
        ElectrolyteDisorder(
            name: "Hypocalcemia",
            abbreviation: "↓Ca++",
            icon: "bolt.trianglebadge.exclamationmark",
            color: Color(red: 0.55, green: 0.45, blue: 0.65),
            overview: "Corrected Ca <8.5 or ionized Ca <1.1. Can cause tetany, seizures, and cardiac problems.",
            causes: "Hypoparathyroidism, vitamin D deficiency, pancreatitis, massive transfusion (citrate binds calcium), tumor lysis.",
            symptoms: "Tetany, Chvostek sign, Trousseau sign, paresthesias, seizures. Long QT on ECG.",
            treatment: "IV calcium gluconate for acute symptoms (10mL of 10% = 1g). Oral calcium + vitamin D for chronic replacement."
        ),
        ElectrolyteDisorder(
            name: "Hypomagnesemia",
            abbreviation: "↓Mg++",
            icon: "arrow.down.square.fill",
            color: Color(red: 0.40, green: 0.55, blue: 0.50),
            overview: "Mg <1.8 is low. This is the hidden player—low mag makes hypokalemia and hypocalcemia impossible to fix.",
            causes: "Diuretics, alcohol, diarrhea, PPIs (chronic use), refeeding, aminoglycosides, cisplatin. Often coexists with low K+ and Ca++.",
            symptoms: "Often asymptomatic. Severe: tremor, tetany, arrhythmias (Torsades), seizures. Check Mg when K+ won't correct.",
            treatment: "IV magnesium sulfate 2g over 15-30 min for severe. PO mag oxide for mild. Correct before trying to fix K+ or Ca++."
        ),
        ElectrolyteDisorder(
            name: "Hypermagnesemia",
            abbreviation: "↑Mg++",
            icon: "arrow.up.square.fill",
            color: Color(red: 0.50, green: 0.40, blue: 0.35),
            overview: "Mg >2.5. Rare unless you're giving Mg (eclampsia treatment) or the patient has renal failure.",
            causes: "Renal failure + Mg-containing meds (antacids, laxatives). Iatrogenic from eclampsia treatment. Almost never happens with normal kidneys.",
            symptoms: "Progressive: loss of reflexes (first sign), lethargy, respiratory depression, hypotension, bradycardia, cardiac arrest.",
            treatment: "Stop all Mg sources. IV calcium gluconate as antagonist. Dialysis for severe (Mg >8 or symptomatic) with renal failure."
        ),
        ElectrolyteDisorder(
            name: "Hypophosphatemia",
            abbreviation: "↓PO₄",
            icon: "minus.circle.fill",
            color: Color(red: 0.25, green: 0.55, blue: 0.65),
            overview: "Phos <2.5. Often missed but can be severe. Think about it in alcoholics, refeeding, and DKA recovery.",
            causes: "Refeeding syndrome (classic), DKA treatment (insulin shifts PO4 into cells), alcoholism, malnutrition, phosphate binders.",
            symptoms: "Muscle weakness, respiratory failure (can't wean from vent), hemolysis, rhabdomyolysis, confusion. ATP depletion.",
            treatment: "Oral replacement for mild (Phos >1.5). IV potassium phosphate or sodium phosphate for severe (<1.5). Replace slowly—risk of hypocalcemia."
        ),
        ElectrolyteDisorder(
            name: "Hyperphosphatemia",
            abbreviation: "↑PO₄",
            icon: "plus.circle.fill",
            color: Color(red: 0.60, green: 0.45, blue: 0.40),
            overview: "Phos >4.5. Usually from renal failure or massive cell lysis. The danger is calcium-phosphate precipitation.",
            causes: "Renal failure (#1), tumor lysis syndrome, rhabdomyolysis, hypoparathyroidism, excess phosphate intake.",
            symptoms: "Often asymptomatic. High phos binds calcium causing hypocalcemia symptoms. Chronic elevation = vascular calcification.",
            treatment: "Phosphate binders with meals (sevelamer, calcium acetate). Dietary restriction. Dialysis for severe cases or renal failure."
        )
    ]
    
    // MARK: - Formatted Content
    private var overviewContent: AttributedString {
        ContentFormatter.format("""
        Why This Matters:
        Electrolyte problems are everywhere in the ICU. Most are straightforward to manage, but a few can kill quickly if you miss them.

        Your Priority:
        Focus on potassium and calcium first—these are the ones that cause cardiac arrest. Sodium problems are common but rarely emergent unless the patient is seizing.

        The Simple Approach:
        Figure out why it happened. Replacing electrolytes without fixing the cause means you'll be chasing numbers all day.
        """, headings: ["Why This Matters:", "Your Priority:", "The Simple Approach:"], isDarkMode: colorScheme == .dark)
    }

    // Clinical Pearls
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(
            header: "Fix Mag First:",
            content: "If you're replacing potassium or calcium and they won't correct, check the magnesium. You can't fix low K+ or low Ca++ until you fix low Mg."
        ),
        CriticalPearlItem(
            header: "Refeeding = Low Phos:",
            content: "When you start feeding a malnourished patient, phosphorus plummets. This causes respiratory failure and can kill. Check phos daily in refeeding."
        ),
        CriticalPearlItem(
            header: "Repeat The K+:",
            content: "Hemolyzed samples give you falsely high potassium. If the K+ is elevated but the patient looks fine and has no ECG changes, redraw it before panicking."
        ),
        CriticalPearlItem(
            header: "Slow Is Safe:",
            content: "For sodium, slow correction prevents brain damage. No more than 8-10 mEq/L per 24 hours. This is especially critical in chronic hyponatremia."
        ),
        CriticalPearlItem(
            header: "Correct The Calcium:",
            content: "Low albumin means low total calcium, but the ionized (active) calcium is normal. For every 1 g/dL albumin below 4, add 0.8 to measured Ca. Or just check ionized."
        ),
        CriticalPearlItem(
            header: "High Phos in AKI:",
            content: "Phosphorus builds up when the kidneys fail. Give phosphate binders with meals. Dialysis clears it if severe."
        )
    ]
    
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - Close Button
                    HStack {
                        Spacer()
                        PremiumLightCloseButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }
                    
                    // MARK: - Hero Header
                    heroHeader
                    
                    // MARK: - Overview Card
                    PremiumLightGlassCard(
                        title: "Overview",
                        icon: "doc.text.fill",
                        content: overviewContent
                    )
                    
                    // MARK: - Disorder Cards
                    VStack(spacing: 12) {
                        ForEach(disorders) { disorder in
                            disorderCard(disorder: disorder)
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - Clinical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .padding(.bottom, 40)
                }
            }
        }
        .sheet(item: $selectedDisorder) { disorder in
            ElectrolyteDetailSheet(disorder: disorder)
        }
    }
    
    // MARK: - Hero Header
    private var heroHeader: some View {
        VStack(spacing: 16) {
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
                    .stroke(accentColor.opacity(0.5), lineWidth: 2)
                    .frame(width: 140, height: 140)

                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(accentColor)
            }
            .shadow(color: colorScheme == .dark ? Color.clear : accentColor.opacity(0.2), radius: 10, y: 4)
            
            Text("Electrolytes")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
            
            Text("Critical Electrolyte Disorders")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(accentColor)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 24) {
                quickStat(icon: "number", value: "10", label: "Disorders")
                quickStat(icon: "heart.fill", value: "K+/Ca++/Mg", label: "Cardiac Risk")
            }
            .padding(.top, 8)
        }
        .padding(.bottom, 12)
    }
    
    private func quickStat(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(accentColor)

            Text(value)
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))

            Text(label)
                .font(.custom("Poppins-Regular", size: 11))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.5) : Color(red: 0.4, green: 0.4, blue: 0.5))
        }
        .padding(.horizontal, 16)
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
                .stroke(accentColor.opacity(colorScheme == .dark ? 0.4 : 0.3), lineWidth: 1)
        )
    }
    
    // MARK: - Disorder Card
    private func disorderCard(disorder: ElectrolyteDisorder) -> some View {
        Button(action: {
            selectedDisorder = disorder
        }) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 8) {
                            Text(disorder.abbreviation)
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(disorder.color)
                                )
                            
                            Text(disorder.name)
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(disorder.color)
                        }
                        
                        Text(disorder.overview)
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.25, green: 0.25, blue: 0.3))
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(disorder.color.opacity(0.15))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: disorder.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(disorder.color)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
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
                                        colors: [disorder.color.opacity(0.15), Color.clear],
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
                                        colors: [disorder.color.opacity(0.1), Color.white.opacity(0.3), Color.clear],
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
                                disorder.color.opacity(0.4),
                                colorScheme == .dark ? disorder.color.opacity(0.15) : Color.white.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
            .shadow(color: colorScheme == .dark ? Color.clear : disorder.color.opacity(0.1), radius: 10, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Electrolyte Detail Sheet
struct ElectrolyteDetailSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    let disorder: ElectrolyteDisorder
    
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Spacer()
                        PremiumLightCloseButton {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 16)
                    }
                    
                    // Title
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(disorder.color.opacity(0.15))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: disorder.icon)
                                .font(.system(size: 44, weight: .medium))
                                .foregroundColor(disorder.color)
                        }
                        
                        Text(disorder.name)
                            .font(.custom("Poppins-Bold", size: 28))
                            .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
                        
                        Text(disorder.abbreviation)
                            .font(.custom("Poppins-SemiBold", size: 14))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(disorder.color))
                    }
                    .padding(.bottom, 8)
                    
                    // Overview
                    detailCard(title: "Overview", icon: "doc.text.fill", content: disorder.overview)
                    
                    // Causes
                    detailCard(title: "Causes", icon: "arrow.triangle.branch", content: disorder.causes)
                    
                    // Symptoms
                    detailCard(title: "Signs & Symptoms", icon: "waveform.path.ecg", content: disorder.symptoms)
                    
                    // Treatment
                    detailCard(title: "Treatment", icon: "cross.case.fill", content: disorder.treatment)
                    
                    Spacer(minLength: 40)
                }
            }
        }
    }
    
    private func detailCard(title: String, icon: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [disorder.color.opacity(0.9), disorder.color.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.15, green: 0.15, blue: 0.2))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            Text(content)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.7) : Color(red: 0.25, green: 0.25, blue: 0.3))
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
                .stroke(disorder.color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    ElectrolyteDisordersView()
}
