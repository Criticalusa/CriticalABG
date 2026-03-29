//
//  LearnTabView.swift
//  CriticalX
//
//  Learn Tab — replaces Favorites with organized educational content + collections
//  Sections: Reference Materials → Specialty Tools → Learning Pathways → Procedures → My Favorites
//

import SwiftUI

struct LearnTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedFilter = "All"

    private let filters = ["All", "Reference", "Tools", "Pathways", "Favorites"]

    // MARK: - Adaptive Colors
    private var canvas: Color {
        colorScheme == .dark ? CriticalDesign.Colors.darkCanvas : Color.white
    }
    private var cardBg: Color {
        colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white
    }
    private var textPrimary: Color {
        CriticalDesign.Adaptive.textPrimary(for: colorScheme)
    }
    private var textSecondary: Color {
        CriticalDesign.Adaptive.textSecondary(for: colorScheme)
    }
    private var textTertiary: Color {
        CriticalDesign.Adaptive.textTertiary(for: colorScheme)
    }
    private var brandAccent: Color {
        CriticalDesign.Adaptive.brandAccent(for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                canvas.ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {

                        // ── HEADER ──
                        HStack(spacing: 10) {
                            Image("NanoBanana/assessment/assessment_medical_book_3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 42, height: 42)

                            Text("Learn")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(textPrimary)

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 16)

                        // ── FILTER PILLS ──
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(filters, id: \.self) { filter in
                                    Button {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedFilter = filter
                                        }
                                    } label: {
                                        Text(filter)
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundColor(selectedFilter == filter
                                                ? (colorScheme == .dark ? CriticalDesign.Colors.cardBlue : .white)
                                                : textSecondary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                Capsule().fill(
                                                    selectedFilter == filter
                                                        ? brandAccent
                                                        : (colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemGray6))
                                                )
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.bottom, 8)

                        // ── SECTIONS ──
                        if selectedFilter == "All" || selectedFilter == "Reference" {
                            referenceMaterialsSection
                        }

                        if selectedFilter == "All" || selectedFilter == "Tools" {
                            specialtyToolsSection
                        }

                        if selectedFilter == "All" || selectedFilter == "Pathways" {
                            learningPathwaysSection
                        }

                        if selectedFilter == "All" || selectedFilter == "Pathways" {
                            proceduresSection
                        }

                        if selectedFilter == "All" || selectedFilter == "Favorites" {
                            myFavoritesSection
                        }

                        Spacer().frame(height: 120)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(CriticalDesign.Colors.cardBlue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Learn")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - ═══════════════════════════════════════════════════════════════
// MARK: REFERENCE MATERIALS
// MARK: ═══════════════════════════════════════════════════════════════

extension LearnTabView {

    private var referenceMaterialsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(emoji: "📚", title: "Reference Materials", count: 8)

            learnRow(
                image: "NanoBanana/home/home_cardiac",
                title: "EKG Library",
                desc: "All rhythms & interpretations",
                destination: AnyView(CriticalEKGView().goldNavigationTitle("EKG Library", image: "NanoBanana/home/home_cardiac"))
            )

            learnRow(
                image: "NanoBanana/home/home_procedures_and_imaging",
                title: "Chest X-Ray",
                desc: "Systematic interpretation guide",
                destination: AnyView(Procedure_ImagingMainView().goldNavigationTitle("Procedures", image: "NanoBanana/home/home_procedures_and_imaging"))
            )

            learnRow(
                image: "NanoBanana/home/home_lab_values",
                title: "Lab Values",
                desc: "Normal ranges & critical values",
                destination: AnyView(LabValueMainView().goldNavigationTitle("Lab Values", image: "NanoBanana/home/home_lab_values"))
            )

            learnRow(
                image: "NanoBanana/home/home_lab_interpretation",
                title: "Lab Interpretation",
                desc: "CBC, BMP, LFT, coags analysis",
                destination: AnyView(LabInterpreterCoordinatorView().goldNavigationTitle("Lab Interpretation", image: "NanoBanana/home/home_lab_interpretation"))
            )

            learnRow(
                image: "NanoBanana/home/home_neuro",
                title: "Neuro Assessments",
                desc: "GCS, NIHSS, pupil scales",
                destination: AnyView(NeuroMainPageView().goldNavigationTitle("Neuro", image: "NanoBanana/home/home_neuro"))
            )

            learnRow(
                image: "NanoBanana/home/home_clinical_references",
                title: "Critical References",
                desc: "Quick reference guides & tables",
                destination: AnyView(CriticalRefrencesView().goldNavigationTitle("References", image: "NanoBanana/home/home_clinical_references"))
            )

            learnRow(
                image: "NanoBanana/home/home_fetal_monitoring",
                title: "Obstetrics",
                desc: "OB emergencies, fetal monitoring, meds",
                destination: AnyView(ObstetricsMainView().goldNavigationTitle("Obstetrics", image: "NanoBanana/home/home_fetal_monitoring"))
            )

            learnRow(
                image: "NanoBanana/home/home_gi_gu",
                title: "GI / GU",
                desc: "GI bleeding, AKI, renal, electrolytes",
                destination: AnyView(GIGUMainView().goldNavigationTitle("GI / GU", image: "NanoBanana/home/home_gi_gu"))
            )
        }
    }
}

// MARK: - ═══════════════════════════════════════════════════════════════
// MARK: SPECIALTY TOOLS
// MARK: ═══════════════════════════════════════════════════════════════

extension LearnTabView {

    private var specialtyToolsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(emoji: "🔧", title: "Specialty Tools", count: 4)

            learnRow(
                image: "NanoBanana/home/home_calculators",
                title: "Unit Converter",
                desc: "Medical unit conversions",
                destination: AnyView(ConversionCalculatorHubView().goldNavigationTitle("Unit Converter", image: "NanoBanana/home/home_calculators"))
            )

            learnRow(
                image: "NanoBanana/home/home_blood_and_fluids",
                title: "IV Compatibility",
                desc: "Y-site drug compatibility checker",
                destination: AnyView(IVCompatibilityView().goldNavigationTitle("IV Compatibility", image: "NanoBanana/home/home_blood_and_fluids"))
            )

            learnRow(
                image: "NanoBanana/home/home_antibiotics_masterclass",
                title: "Antibiotics Masterclass",
                desc: "ICU antibiotic decision-making",
                destination: AnyView(AntibioticsMasterclassView().goldNavigationTitle("Antibiotics", image: "NanoBanana/home/home_antibiotics_masterclass"))
            )

            learnRow(
                image: "NanoBanana/home/home_common_acronyms",
                title: "Abbreviations",
                desc: "Common medical acronyms",
                destination: AnyView(AbbreviateionMain().goldNavigationTitle("Abbreviations", image: "NanoBanana/home/home_common_acronyms"))
            )
        }
    }
}

// MARK: - ═══════════════════════════════════════════════════════════════
// MARK: LEARNING PATHWAYS
// MARK: ═══════════════════════════════════════════════════════════════

extension LearnTabView {

    private var learningPathwaysSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🎓")
                    .font(.system(size: 18))
                Text("Learning Pathways")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    pathwayCard(
                        image: "NanoBanana/home/home_cardiac",
                        title: "EKG Mastery",
                        lessons: "Rhythms & Interpretation",
                        progress: 0.0,
                        destination: AnyView(CriticalEKGView().goldNavigationTitle("EKG Mastery", image: "NanoBanana/home/home_cardiac"))
                    )

                    pathwayCard(
                        image: "NanoBanana/home/home_ventilator_management",
                        title: "Vent Management",
                        lessons: "Modes, Settings & Optimization",
                        progress: 0.0,
                        destination: AnyView(VentManagemnetTableView().goldNavigationTitle("Vent Management", image: "NanoBanana/home/home_ventilator_management"))
                    )

                    pathwayCard(
                        image: "NanoBanana/home/home_acls_test_prep",
                        title: "ACLS Prep",
                        lessons: "Certification Practice",
                        progress: 0.0,
                        isPremium: true,
                        destination: AnyView(ACLSQuizMainView().goldNavigationTitle("ACLS Prep", image: "NanoBanana/home/home_acls_test_prep"))
                    )
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func pathwayCard(image: String, title: String, lessons: String, progress: CGFloat, isPremium: Bool = false, destination: AnyView) -> some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    CatalogThumbnailImage(name: image, size: 50, cornerRadius: 10)
                    Spacer()
                    if isPremium {
                        HStack(spacing: 4) {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 10, weight: .semibold))
                            Text("PRO")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(CriticalDesign.Colors.goldDeep)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule().fill(
                                LinearGradient(
                                    colors: [CriticalDesign.Colors.goldLight.opacity(0.3), CriticalDesign.Colors.goldDeep.opacity(0.15)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                        )
                    }
                }
                .padding(.bottom, 12)

                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(textPrimary)
                    .padding(.bottom, 4)

                Text(lessons)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(textTertiary)
                    .padding(.bottom, 12)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
                            .frame(height: 4)

                        if progress > 0 {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(brandAccent)
                                .frame(width: geo.size.width * progress, height: 4)
                        }
                    }
                }
                .frame(height: 4)
            }
            .padding(20)
            .frame(width: 200)
            .background(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                    } else {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.15 : 0.08), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ═══════════════════════════════════════════════════════════════
// MARK: PROCEDURES & PROTOCOLS
// MARK: ═══════════════════════════════════════════════════════════════

extension LearnTabView {

    private var proceduresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(emoji: "📖", title: "Procedures & Protocols", count: 3)

            learnRow(
                image: "NanoBanana/airway/airway_equip_laryngoscope_1",
                title: "Intubation Checklist",
                desc: "Step-by-step RSI procedure",
                destination: AnyView(AirWayView().goldNavigationTitle("Airway", image: "NanoBanana/airway/airway_equip_laryngoscope_1"))
            )

            learnRow(
                image: "NanoBanana/home/home_procedures_and_imaging",
                title: "Central Line",
                desc: "Placement procedure guide",
                destination: AnyView(Procedure_ImagingMainView().goldNavigationTitle("Procedures", image: "NanoBanana/home/home_procedures_and_imaging"))
            )

            learnRow(
                image: "NanoBanana/home/home_ultrasound",
                title: "Ultrasound / POCUS",
                desc: "E-FAST, RUSH, cardiac",
                destination: AnyView(UltrasonographyMainView().goldNavigationTitle("Ultrasound", image: "NanoBanana/home/home_ultrasound"))
            )
        }
    }
}

// MARK: - ═══════════════════════════════════════════════════════════════
// MARK: MY FAVORITES (existing favorites migrated here)
// MARK: ═══════════════════════════════════════════════════════════════

extension LearnTabView {

    private var myFavoritesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("⭐")
                    .font(.system(size: 18))
                Text("My Favorites")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(textPrimary)
                Spacer()
                Text("Edit")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(brandAccent)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            // Embed the existing FavoriteMainView
            FavoriteMainView(searchText: .constant(""), selectedCategory: .constant(nil), embedded: true)
                .frame(minHeight: 300)
                .padding(.horizontal, 20)
        }
    }
}

// MARK: - ═══════════════════════════════════════════════════════════════
// MARK: SHARED COMPONENTS
// MARK: ═══════════════════════════════════════════════════════════════

extension LearnTabView {

    private func sectionHeader(emoji: String, title: String, count: Int) -> some View {
        HStack(spacing: 8) {
            Text(emoji)
                .font(.system(size: 18))
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(textPrimary)
            Spacer()
            Text("\(count)")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(textTertiary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private func learnRow(image: String, title: String, desc: String, destination: AnyView) -> some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 12) {
                CatalogThumbnailImage(name: image, size: 44, cornerRadius: 8)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(textPrimary)
                    Text(desc)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(textTertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(CriticalDesign.Colors.cardBlue)
                    } else {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.95), CriticalDesign.Colors.canvas],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.15 : 0.08), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 20)
    }
}

// MARK: - Previews

#Preview("Learn Tab — Dark") {
    LearnTabView()
        .preferredColorScheme(.dark)
}

#Preview("Learn Tab — Light") {
    LearnTabView()
        .preferredColorScheme(.light)
}
