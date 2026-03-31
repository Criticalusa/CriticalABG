//
//  RSIIResultDesignView.swift
//  CriticalX
//
//  Single-scroll glassmorphic results layout
//

import SwiftUI

// MARK: - RSI Values Observable
class RSIIValue: ObservableObject {
    @Published var lidocineLabel: String = ""
    @Published var atropineLabel: String = ""
    @Published var atropineMLsLabel: String = ""
    @Published var lidocaineMLsLabel: String = ""
    @Published var fentanylLabel: String = ""
    @Published var fentanylMLsLabel: String = ""
    @Published var rocDefasiculatingLabel: String = ""
    @Published var rocDefasiculatingMLsLabel: String = ""
    @Published var vecDefasiculatingLabel: String = ""
    @Published var vecDefasiculatingMLsLabel: String = ""
    @Published var glycopyrolateLabel: String = ""
    @Published var glycopyrolateMLsLabel: String = ""
    @Published var propofolLabel: String = ""
    @Published var propofolMLsLabel: String = ""
    @Published var etomidateLabel: String = ""
    @Published var etomidateMLsLabel: String = ""
    @Published var versedLabel: String = ""
    @Published var versedMLsLabel: String = ""
    @Published var ketamineLabel: String = ""
    @Published var ketamineMLsLabel: String = ""
    @Published var succsLabel: String = ""
    @Published var succsMLsLabel: String = ""
    @Published var vecuroniumLabel: String = ""
    @Published var vecuroniumMLsLabel: String = ""
    @Published var rocuroniumLabel: String = ""
    @Published var rocuroniumMLsLabel: String = ""
    @Published var cisatricuriumLabel: String = ""
    @Published var cisatricuriumMLsLabel: String = ""
    @Published var unitLidocaineLabel: String = ""
    @Published var unitAtropineLabel: String = ""
    @Published var unitFentanylLabel: String = ""
    @Published var unitGlycopyrolateLabel: String = ""
    @Published var unitEtomidateLabel: String = ""
    @Published var unitKetamineLabel: String = ""
    @Published var unitVersedLabel: String = ""
    @Published var unitPropofolLabel: String = ""
    @Published var unitSuccinylcholineLabel: String = ""
    @Published var unitVecuroniumLabel: String = ""
    @Published var unitRocuroniumLabel: String = ""
    @Published var unitCisatricuriumLabel: String = ""
    @Published var unitVecDefascLabel: String = ""
    @Published var unitRocDefascLabel: String = ""
}

// MARK: - Phase Colors
private let preTreatmentColor = Color(red: 0.20, green: 0.55, blue: 0.52)  // muted teal
private let inductionColor    = Color(red: 0.18, green: 0.25, blue: 0.34)  // navyAccent
private let paralysisColor    = Color(red: 0.68, green: 0.35, blue: 0.35)  // muted coral

// MARK: - RSI Medication Card
private struct RSIMedicationCard: View {
    @Environment(\.colorScheme) var colorScheme

    let name: String
    let dosage: String
    let mlDosage: String
    let concentration: String
    let phaseColor: Color
    let animationIndex: Int

    @State private var isAppearing = false

    var body: some View {
        ZStack(alignment: .leading) {
            // Card background
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(phaseColor.opacity(0.1), lineWidth: 1)
                )

            HStack(spacing: 12) {
                // Color dot + name
                HStack(spacing: 8) {
                    Circle()
                        .fill(phaseColor)
                        .frame(width: 8, height: 8)

                    Text(name)
                        .font(.custom("Poppins-SemiBold", size: 15))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .lineLimit(1)
                }

                Spacer(minLength: 8)

                // Dose column
                VStack(alignment: .trailing, spacing: 2) {
                    Text(dosage + " mg")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .lineLimit(1)

                    Text(mlDosage)
                        .font(.custom("Poppins-Medium", size: 13))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .lineLimit(1)

                    Text("(" + concentration + ")")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .lineLimit(1)
                }
            }
            .padding(.vertical, 14)
            .padding(.leading, 20)
            .padding(.trailing, 16)

            // Left border accent
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .fill(phaseColor)
                .frame(width: 3)
                .padding(.vertical, 10)
                .frame(maxHeight: .infinity, alignment: .leading)
        }
        .shadow(
            color: colorScheme == .dark
                ? CriticalDesign.Colors.darkCanvas.opacity(0.4)
                : Color.black.opacity(0.04),
            radius: 8,
            x: 0,
            y: 3
        )
        .opacity(isAppearing ? 1 : 0)
        .offset(y: isAppearing ? 0 : 15)
        .onAppear {
            withAnimation(
                .easeOut(duration: 0.4)
                .delay(Double(animationIndex) * 0.05)
            ) {
                isAppearing = true
            }
        }
    }
}

// MARK: - Main Results View
struct RSIIResultDesignView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var values: RSIIValue = RSIIValue()
    @Binding var weightEntered: Double
    @Binding var isPresented: Bool
    @State var kgWeightLabel: String = ""
    @State private var scrollViewContentOffset = CGFloat(0)
    @State private var isAppearing = false

    // Derived display strings
    private var weightKg: String {
        let parts = kgWeightLabel.components(separatedBy: " kg")
        return (parts.first ?? "") + " kg"
    }
    private var weightLbs: String {
        let parts = kgWeightLabel.components(separatedBy: "• ")
        return parts.count > 1 ? parts[1] : ""
    }

    var body: some View {
        ZStack(alignment: .top) {
            CriticalDesign.Adaptive.canvas(for: colorScheme)
                .ignoresSafeArea()

            TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                VStack(spacing: 0) {

                    // MARK: Close Button Row
                    HStack {
                        Button {
                            isPresented = false
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
                                    .frame(width: 40, height: 40)
                                    .shadow(
                                        color: colorScheme == .dark
                                            ? CriticalDesign.Colors.darkCanvas.opacity(0.5)
                                            : Color.black.opacity(0.06),
                                        radius: 6,
                                        x: 0,
                                        y: 2
                                    )
                                Image(systemName: "xmark")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            }
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                    // MARK: Patient Header Card
                    HStack(alignment: .center, spacing: 0) {
                        // Weight block
                        VStack(alignment: .leading, spacing: 4) {
                            Text(weightKg)
                                .font(.custom("Poppins-Bold", size: 28))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)

                            Text(weightLbs)
                                .font(.custom("Poppins-Medium", size: 14))
                                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        }

                        Spacer()

                        // 7P's pill
                        NavigationLink(destination: SevenPsbtnView()) {
                            HStack(spacing: 6) {
                                Text("7 P's")
                                    .font(.custom("Poppins-SemiBold", size: 13))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 10, weight: .bold))
                            }
                            .foregroundColor(
                                colorScheme == .dark
                                    ? Color.white.opacity(0.85)
                                    : Color(red: 0.18, green: 0.25, blue: 0.34)
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(
                                        colorScheme == .dark
                                            ? CriticalDesign.Colors.cardBlue
                                            : Color(red: 0.18, green: 0.25, blue: 0.34).opacity(0.08)
                                    )
                                    .overlay(
                                        Capsule()
                                            .stroke(
                                                colorScheme == .dark
                                                    ? CriticalDesign.Colors.goldGradient
                                                    : LinearGradient(
                                                        colors: [Color(red: 0.18, green: 0.25, blue: 0.34).opacity(0.2)],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    ),
                                                lineWidth: 1
                                            )
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(
                                        colorScheme == .dark
                                            ? CriticalDesign.Colors.goldGradient
                                            : LinearGradient(
                                                colors: [Color(red: 0.18, green: 0.25, blue: 0.34).opacity(0.1)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ),
                                        lineWidth: colorScheme == .dark ? 1.5 : 1
                                    )
                            )
                    )
                    .shadow(
                        color: colorScheme == .dark
                            ? CriticalDesign.Colors.darkCanvas.opacity(0.5)
                            : Color.black.opacity(0.06),
                        radius: 16,
                        x: 0,
                        y: 6
                    )
                    .padding(.horizontal, 20)

                    // MARK: Pre-Treatment Section
                    RSISectionDivider(title: "Pre-Treatment")
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 10)

                    VStack(spacing: 10) {
                        RSIMedicationCard(
                            name: "Lidocaine",
                            dosage: values.lidocineLabel,
                            mlDosage: values.lidocaineMLsLabel,
                            concentration: values.unitLidocaineLabel,
                            phaseColor: preTreatmentColor,
                            animationIndex: 0
                        )
                        RSIMedicationCard(
                            name: "Fentanyl",
                            dosage: values.fentanylLabel,
                            mlDosage: values.fentanylMLsLabel,
                            concentration: values.unitFentanylLabel,
                            phaseColor: preTreatmentColor,
                            animationIndex: 1
                        )
                        RSIMedicationCard(
                            name: "Atropine",
                            dosage: values.atropineLabel,
                            mlDosage: values.atropineMLsLabel,
                            concentration: values.unitAtropineLabel,
                            phaseColor: preTreatmentColor,
                            animationIndex: 2
                        )
                        RSIMedicationCard(
                            name: "Glycopyrrolate",
                            dosage: values.glycopyrolateLabel,
                            mlDosage: values.glycopyrolateMLsLabel,
                            concentration: values.unitGlycopyrolateLabel,
                            phaseColor: preTreatmentColor,
                            animationIndex: 3
                        )
                    }
                    .padding(.horizontal, 20)

                    // MARK: Induction Agents Section
                    RSISectionDivider(title: "Induction Agents")
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 10)

                    VStack(spacing: 10) {
                        RSIMedicationCard(
                            name: "Ketamine",
                            dosage: values.ketamineLabel,
                            mlDosage: values.ketamineMLsLabel,
                            concentration: values.unitKetamineLabel,
                            phaseColor: inductionColor,
                            animationIndex: 4
                        )
                        RSIMedicationCard(
                            name: "Etomidate",
                            dosage: values.etomidateLabel,
                            mlDosage: values.etomidateMLsLabel,
                            concentration: values.unitEtomidateLabel,
                            phaseColor: inductionColor,
                            animationIndex: 5
                        )
                        RSIMedicationCard(
                            name: "Propofol",
                            dosage: values.propofolLabel,
                            mlDosage: values.propofolMLsLabel,
                            concentration: values.unitPropofolLabel,
                            phaseColor: inductionColor,
                            animationIndex: 6
                        )
                        RSIMedicationCard(
                            name: "Midazolam",
                            dosage: values.versedLabel,
                            mlDosage: values.versedMLsLabel,
                            concentration: values.unitVersedLabel,
                            phaseColor: inductionColor,
                            animationIndex: 7
                        )
                    }
                    .padding(.horizontal, 20)

                    // MARK: Paralytic Agents Section
                    RSISectionDivider(title: "Paralytic Agents")
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 10)

                    VStack(spacing: 10) {
                        RSIMedicationCard(
                            name: "Succinylcholine",
                            dosage: values.succsLabel,
                            mlDosage: values.succsMLsLabel,
                            concentration: values.unitSuccinylcholineLabel,
                            phaseColor: paralysisColor,
                            animationIndex: 8
                        )
                        RSIMedicationCard(
                            name: "Rocuronium",
                            dosage: values.rocuroniumLabel,
                            mlDosage: values.rocuroniumMLsLabel,
                            concentration: values.unitRocuroniumLabel,
                            phaseColor: paralysisColor,
                            animationIndex: 9
                        )
                        RSIMedicationCard(
                            name: "Vecuronium",
                            dosage: values.vecuroniumLabel,
                            mlDosage: values.vecuroniumMLsLabel,
                            concentration: values.unitVecuroniumLabel,
                            phaseColor: paralysisColor,
                            animationIndex: 10
                        )
                        RSIMedicationCard(
                            name: "Cisatracurium",
                            dosage: values.cisatricuriumLabel,
                            mlDosage: values.cisatricuriumMLsLabel,
                            concentration: values.unitCisatricuriumLabel,
                            phaseColor: paralysisColor,
                            animationIndex: 11
                        )
                    }
                    .padding(.horizontal, 20)

                    Spacer(minLength: 80)
                }
                .padding(.bottom, 30)
            }
            .simultaneousGesture(
                DragGesture().onChanged { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                   to: nil, from: nil, for: nil)
                }
            )

            // MARK: Floating Weight Pill
            if scrollViewContentOffset > 120 {
                floatingWeightPill
                    .padding(.top, 8)
                    .transition(
                        .move(edge: .top).combined(with: .opacity)
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: scrollViewContentOffset > 120)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .dismissKeyboardOnScroll()
        .onAppear {
            rsiCalculation()
        }
    }

    // MARK: - Floating Weight Pill
    private var floatingWeightPill: some View {
        Text(weightKg)
            .font(.custom("Poppins-SemiBold", size: 13))
            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            .padding(.horizontal, 18)
            .padding(.vertical, 9)
            .background(
                Capsule()
                    .fill(CriticalDesign.Adaptive.cardSurface(for: colorScheme))
                    .shadow(
                        color: colorScheme == .dark
                            ? CriticalDesign.Colors.darkCanvas.opacity(0.5)
                            : Color.black.opacity(0.10),
                        radius: 12,
                        x: 0,
                        y: 4
                    )
            )
    }
}

// MARK: - Preview
struct RSIIResultDesignView_Previews: PreviewProvider {
    static var previews: some View {
        RSIIResultDesignView(weightEntered: .constant(70), isPresented: .constant(true))
    }
}

// MARK: - Calculations Extension
extension RSIIResultDesignView {

    func rsiCalculation() {
        var Parameters: NSMutableDictionary!

        if ((UserDefaults.standard.object(forKey:"parameters")) != nil) {
            Parameters = NSMutableDictionary.init(dictionary: (UserDefaults.standard.object(forKey:"parameters") as? NSDictionary)!)
            UserDefaults.standard.synchronize()
        } else {
            Parameters = ["atropine": 0.02, "lidocaine": 1, "fentanyl_min": 1, "fentanyl_max": 2, "vecDefasiculating": 0.01, "rocDefasiculating_min": 0.06, "rocDefasiculating_max": 0.12, "glycopyrolate_min": 0.1, "glycopyrolate_max": 0.2, "etomidate": 0.3, "ketamine": 1.0, "ketamineMax": 2.0, "propofol_min": 1, "propofol_max": 2, "versed_min": 0.1, "versed_max": 0.2, "cisatricurium": 0.2, "vecuronium": 0.1, "rocuronium_min": 0.6, "rocuronium_max": 1.2, "succs_min": 1, "succs_max": 1.5, "lidocaine_mgMl": 20, "mgPerML_atropine": 0.1, "mgPerML_fentanyl": 50.0, "mgPerML_vecDefasc": 1.0, "mgPerML_rocDefasc": 10.0, "hello": 0.2, "ml_etomidate": 2.0, "ml_ketamine": 100.0, "ml_versed": 5.0, "ml_propofol": 10.0, "ml_succs": 10.0, "ml_vec": 1.0, "ml_roc": 10.0, "ml_cis": 10.0]

            UserDefaults.standard.set(Parameters, forKey: "parameters")
            UserDefaults.standard.synchronize()
        }

        kgWeightLabel = "\(weightEntered) kg • \((weightEntered * 2.2).rounded()) lbs"

        // Calculation closures
        let doseRange1 = { (initialDose: Double, range1: Double) -> String in
            return "\((self.weightEntered * range1).oneDecimalPlace)"
        }

        let doseRange2 = { (initialDose: Double, FollowingDose: Double, range1: Double, range2: Double) -> String in
            return "\((self.weightEntered * range1).oneDecimalPlace)-\((self.weightEntered * range2).oneDecimalPlace)"
        }

        let doseRange2_mL = { (initialDose: Double, FollowingDose: Double, range1: Double, range2: Double, permL: Double) -> String in
            return "\(Double((self.weightEntered * range1) / permL).oneDecimalPlace)–\(Double((self.weightEntered * range2) / permL).oneDecimalPlace) mL"
        }

        func mL1_DoseCalculation(FinalDose: Double, PermL: Double) -> String {
            return "\(Double(FinalDose / PermL).oneDecimalPlace) mL"
        }

        // Pre-treatment
        let atropine = doseRange1(weightEntered, Parameters.object(forKey: "atropine") as? Double ?? 0)
        let lidocaine = doseRange1(weightEntered, Parameters.object(forKey: "lidocaine") as? Double ?? 0)
        let fentanyl = doseRange2(weightEntered, weightEntered, Parameters.object(forKey: "fentanyl_min") as? Double ?? 0, Parameters.object(forKey: "fentanyl_max") as? Double ?? 0)
        let glycopyrolate = doseRange2(weightEntered, weightEntered, Parameters.object(forKey: "glycopyrolate_min") as? Double ?? 0, Parameters.object(forKey: "glycopyrolate_max") as? Double ?? 0)

        values.atropineLabel = atropine
        values.atropineMLsLabel = mL1_DoseCalculation(FinalDose: atropine.safeDouble ?? 0, PermL: Parameters.object(forKey: "mgPerML_atropine") as? Double ?? 0.1)
        values.lidocineLabel = lidocaine
        values.lidocaineMLsLabel = mL1_DoseCalculation(FinalDose: lidocaine.safeDouble ?? 0, PermL: Parameters.object(forKey: "lidocaine_mgMl") as? Double ?? 20)
        values.fentanylLabel = fentanyl
        values.fentanylMLsLabel = doseRange2_mL(weightEntered, weightEntered, Parameters.object(forKey: "fentanyl_min") as? Double ?? 0, Parameters.object(forKey: "fentanyl_max") as? Double ?? 0, Parameters.object(forKey: "mgPerML_fentanyl") as? Double ?? 50)
        values.glycopyrolateLabel = glycopyrolate
        values.glycopyrolateMLsLabel = doseRange2_mL(weightEntered, weightEntered, Parameters.object(forKey: "glycopyrolate_min") as? Double ?? 0, Parameters.object(forKey: "glycopyrolate_max") as? Double ?? 0, Parameters.object(forKey: "hello") as? Double ?? 0.2)

        // Induction
        let etomidate = doseRange1(weightEntered, Parameters.object(forKey: "etomidate") as? Double ?? 0)
        let ketamine = doseRange2(weightEntered, weightEntered, Parameters.object(forKey: "ketamine") as? Double ?? 0, Parameters.object(forKey: "ketamineMax") as? Double ?? 0)
        let propofol = doseRange2(weightEntered, weightEntered, Parameters.object(forKey: "propofol_min") as? Double ?? 0, Parameters.object(forKey: "propofol_max") as? Double ?? 0)
        let versed = doseRange2(weightEntered, weightEntered, Parameters.object(forKey: "versed_min") as? Double ?? 0, Parameters.object(forKey: "versed_max") as? Double ?? 0)

        values.etomidateLabel = etomidate
        values.etomidateMLsLabel = mL1_DoseCalculation(FinalDose: etomidate.safeDouble ?? 0, PermL: Parameters.object(forKey: "ml_etomidate") as? Double ?? 2.0)
        values.ketamineLabel = ketamine
        values.ketamineMLsLabel = doseRange2_mL(weightEntered, weightEntered, Parameters.object(forKey: "ketamine") as? Double ?? 0, Parameters.object(forKey: "ketamineMax") as? Double ?? 0, Parameters.object(forKey: "ml_ketamine") as? Double ?? 100)
        values.propofolLabel = propofol
        values.propofolMLsLabel = doseRange2_mL(weightEntered, weightEntered, Parameters.object(forKey: "propofol_min") as? Double ?? 0, Parameters.object(forKey: "propofol_max") as? Double ?? 0, 10)
        values.versedLabel = versed
        values.versedMLsLabel = doseRange2_mL(weightEntered, weightEntered, Parameters.object(forKey: "versed_min") as? Double ?? 0, Parameters.object(forKey: "versed_max") as? Double ?? 0, Parameters.object(forKey: "ml_versed") as? Double ?? 5)

        // Neuromuscular
        let cisatricurium = doseRange1(weightEntered, Parameters.object(forKey: "cisatricurium") as? Double ?? 0)
        let vecuronium = doseRange1(weightEntered, Parameters.object(forKey: "vecuronium") as? Double ?? 0)
        let rocuronium = doseRange2(weightEntered, weightEntered, Parameters.object(forKey: "rocDefasiculating_min") as? Double ?? 0, Parameters.object(forKey: "rocDefasiculating_max") as? Double ?? 0)
        let succs = doseRange2(weightEntered, weightEntered, Parameters.object(forKey: "succs_min") as? Double ?? 0, Parameters.object(forKey: "succs_max") as? Double ?? 0)

        values.cisatricuriumLabel = cisatricurium
        values.cisatricuriumMLsLabel = mL1_DoseCalculation(FinalDose: cisatricurium.safeDouble ?? 0, PermL: 10)
        values.vecuroniumLabel = vecuronium
        values.vecuroniumMLsLabel = mL1_DoseCalculation(FinalDose: vecuronium.safeDouble ?? 0, PermL: 1)
        values.rocuroniumLabel = rocuronium
        values.rocuroniumMLsLabel = doseRange2_mL(weightEntered, weightEntered, Parameters.object(forKey: "rocDefasiculating_min") as? Double ?? 0, Parameters.object(forKey: "rocDefasiculating_max") as? Double ?? 0, 10)
        values.succsLabel = succs
        values.succsMLsLabel = doseRange2_mL(weightEntered, weightEntered, Parameters.object(forKey: "succs_min") as? Double ?? 0, Parameters.object(forKey: "succs_max") as? Double ?? 0, 20)

        // Unit Labels
        values.unitLidocaineLabel = "\(Parameters.object(forKey: "lidocaine") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "lidocaine_mgMl") as? Double ?? 0) mg/mL"
        values.unitAtropineLabel = "\(Parameters.object(forKey: "atropine") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "mgPerML_atropine") as? Double ?? 0) mg/mL"
        values.unitFentanylLabel = "\(Parameters.object(forKey: "fentanyl_min") as? Double ?? 0)-\(Parameters.object(forKey: "fentanyl_max") as? Double ?? 0) mcg/kg | \(Parameters.object(forKey: "mgPerML_fentanyl") as? Double ?? 0) mcg/mL"
        values.unitGlycopyrolateLabel = "\(Parameters.object(forKey: "glycopyrolate_min") as? Double ?? 0)-\(Parameters.object(forKey: "glycopyrolate_max") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "hello") as? Double ?? 0) mg/mL"
        values.unitEtomidateLabel = "\(Parameters.object(forKey: "etomidate") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "ml_etomidate") as? Double ?? 0) mg/mL"
        values.unitKetamineLabel = "\(Parameters.object(forKey: "ketamine") as? Double ?? 0)-\(Parameters.object(forKey: "ketamineMax") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "ml_ketamine") as? Double ?? 0) mg/mL"
        values.unitVersedLabel = "\(Parameters.object(forKey: "versed_min") as? Double ?? 0)-\(Parameters.object(forKey: "versed_max") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "ml_versed") as? Double ?? 0) mg/mL"
        values.unitPropofolLabel = "\(Parameters.object(forKey: "propofol_min") as? Double ?? 0)-\(Parameters.object(forKey: "propofol_max") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "ml_propofol") as? Double ?? 0) mg/mL"
        values.unitSuccinylcholineLabel = "\(Parameters.object(forKey: "succs_min") as? Double ?? 0)-\(Parameters.object(forKey: "succs_max") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "ml_succs") as? Double ?? 0) mg/mL"
        values.unitVecuroniumLabel = "\(Parameters.object(forKey: "vecuronium") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "ml_vec") as? Double ?? 0) mg/mL"
        values.unitRocuroniumLabel = "\(Parameters.object(forKey: "rocuronium_min") as? Double ?? 0)-\(Parameters.object(forKey: "rocuronium_max") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "ml_roc") as? Double ?? 0) mg/mL"
        values.unitCisatricuriumLabel = "\(Parameters.object(forKey: "cisatricurium") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "ml_cis") as? Double ?? 0) mg/mL"
        values.unitVecDefascLabel = "\(Parameters.object(forKey: "vecDefasiculating") as? Double ?? 0) mg/kg | \(Parameters.object(forKey: "mgPerML_vecDefasc") as? Double ?? 0) mg/mL"
    }
}
