//
//  EFastExaminationView.swift
//  CriticalX
//
//  Premium Light Theme - E-FAST Examination
//  Extended Focused Assessment with Sonography in Trauma
//

import SwiftUI

// MARK: - E-FAST Media Item
struct EFASTMediaItem: Identifiable {
    let id = UUID()
    let name: String
    let title: String
    let isNormal: Bool
    let isGif: Bool
    
    // Convenience initializers
    static func gif(_ name: String, title: String, isNormal: Bool) -> EFASTMediaItem {
        EFASTMediaItem(name: name, title: title, isNormal: isNormal, isGif: true)
    }
    
    static func image(_ name: String, title: String, isNormal: Bool = true) -> EFASTMediaItem {
        EFASTMediaItem(name: name, title: title, isNormal: isNormal, isGif: false)
    }
}

// Legacy alias for compatibility
typealias EFASTGifItem = EFASTMediaItem

// MARK: - E-FAST View Model
struct EFASTWindow: Identifiable {
    let id = UUID()
    let number: Int
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let description: String
    let media: [EFASTMediaItem]
    
    // Convenience for accessing gifs (backwards compatibility)
    var gifs: [EFASTMediaItem] { media }
}

// MARK: - E-FAST Examination View
struct EFastExaminationView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var isAppearing = false
    @State private var selectedWindow: EFASTWindow?
    @State private var pearlsExpanded = false
    
    // Brand colors
    private let cardBlue = CriticalDesign.Colors.cardBlue
    private let gold = Color(red: 0.96, green: 0.71, blue: 0.0)
    
    // Adaptive text colors
    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.04, green: 0.09, blue: 0.16)
    }
    private var textSecondary: Color {
        colorScheme == .dark ? Color.white.opacity(0.8) : Color(red: 0.11, green: 0.21, blue: 0.34)
    }
    private var textTertiary: Color {
        colorScheme == .dark ? Color.white.opacity(0.7) : Color(red: 0.24, green: 0.35, blue: 0.50)
    }
    private var textMuted: Color {
        colorScheme == .dark ? Color.white.opacity(0.5) : Color(red: 0.42, green: 0.49, blue: 0.54)
    }
    
    // E-FAST Windows Data
    private let acousticWindows: [EFASTWindow] = [
        EFASTWindow(
            number: 1,
            title: "RUQ - Morrison's Pouch",
            subtitle: "Right Upper Quadrant",
            icon: "Liver",
            color: Color(red: 0.02, green: 0.59, blue: 0.53),
            description: "Assess hepatorenal space for free fluid between liver and right kidney.",
            media: [
                .image("RUQ", title: "Probe Position"),
                .image("RUQAnatomyFast", title: "RUQ Anatomy"),
                .gif("SweepThroughRUQ", title: "RUQ Sweep Through", isNormal: true),
                .gif("Pathology-RUQ", title: "Free Fluid Morrison's", isNormal: false),
                .image("Pathology_RUQ_FreeFluidImage", title: "Hemoperitoneum", isNormal: false),
                .gif("Pathology_RUQ_ParaglottcFreeFluid", title: "Paracolic Gutter", isNormal: false)
            ]
        ),
        EFASTWindow(
            number: 2,
            title: "Anterior Thoracic",
            subtitle: "Bilateral Lung Fields",
            icon: "icon-lungs",
            color: Color(red: 0.23, green: 0.51, blue: 0.96),
            description: "Evaluate for pneumothorax by identifying lung sliding and comet-tail artifacts.",
            media: [
                .gif("A-BLines_Thorax", title: "A-Lines vs B-Lines", isNormal: true),
                .gif("LungSlidingNormalVsPTX", title: "Normal vs PTX", isNormal: false),
                .gif("LungPointSign", title: "Lung Point Sign", isNormal: false)
            ]
        ),
        EFASTWindow(
            number: 3,
            title: "LUQ - Splenorenal",
            subtitle: "Left Upper Quadrant",
            icon: "Kidneys",
            color: Color(red: 0.95, green: 0.6, blue: 0.2),
            description: "Assess splenorenal recess and space between spleen and left kidney.",
            media: [
                .image("LUQProbePosition", title: "Probe Position"),
                .image("LUQ_ProbeAnatomy", title: "LUQ Anatomy"),
                .gif("LUQ_SweepThrough", title: "LUQ Sweep Through", isNormal: true),
                .gif("LUQ_PosFast1", title: "LUQ Hemoperitoneum", isNormal: false),
                .image("Pathology_LUQ_Image", title: "Perisplenic Fluid", isNormal: false),
                .gif("LUQ_PosFast2", title: "Paracolic Gutter", isNormal: false)
            ]
        ),
        EFASTWindow(
            number: 4,
            title: "Subxiphoid Cardiac",
            subtitle: "Four-Chamber View",
            icon: "icons-heart",
            color: Color(red: 0.75, green: 0.22, blue: 0.27),
            description: "Evaluate for pericardial effusion and gross cardiac activity.",
            media: [
                .image("SubxyphoidImgAnatomy", title: "Cardiac Anatomy"),
                .gif("Cardiac-SubxiphoidGIF_ANNOTATED", title: "Subxiphoid View", isNormal: true),
                .gif("Cardiac_LG_Effusion_GIF", title: "Cardiac Tamponade", isNormal: false),
                .image("SubXiphoid_EffusionImg", title: "RV Collapse", isNormal: false),
                .gif("PLAX_EffusionGIF_Annotated", title: "PLAX Effusion", isNormal: false)
            ]
        ),
        EFASTWindow(
            number: 5,
            title: "Pelvic View",
            subtitle: "Suprapubic Window",
            icon: "icon-bladder",
            color: Color(red: 0.55, green: 0.35, blue: 0.75),
            description: "Assess rectovesical/rectouterine pouch for dependent free fluid.",
            media: [
                .image("PelvicProbe", title: "Probe Position"),
                .gif("Pelvic_NormalMale", title: "Normal Male", isNormal: true),
                .gif("Pelvic-NormalFemale", title: "Normal Female", isNormal: true),
                .gif("Pelvic_PosFast1", title: "Positive - Male", isNormal: false),
                .gif("Pelvic_Pos_Fast_Female", title: "Positive - Female", isNormal: false)
            ]
        )
    ]
    
    var body: some View {
        ZStack {
            // Animated Premium Light Background
            EFASTAnimatedBackground(colorScheme: colorScheme)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Close Button
                    HStack {
                        Spacer()
                        PremiumLightCloseButton {
                            dismiss()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Two-Tone Header Card
                    headerCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    // Overview Card
                    overviewCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 25)
                    
                    // Section Divider
                    sectionDivider(title: "ACOUSTIC WINDOWS")
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 30)
                    
                    // Five Acoustic Windows
                    acousticWindowsSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 35)

                    // Systematic Approach
                    sectionDivider(title: "CLINICAL WORKFLOW")
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 37)

                    systematicApproachCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 38)

                    // When to Repeat / Escalate
                    repeatAndEscalateCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 39)

                    // Putting It Together
                    puttingItTogetherCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 39)

                    // Critical Pearls
                    criticalPearlsCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
        .sheet(item: $selectedWindow) { window in
            EFASTWindowDetailView(window: window)
        }
    }
    
    // MARK: - Two-Tone Header Card
    private var headerCard: some View {
        VStack(spacing: 0) {
            // Top Section - Navy with ultrasound icon
            HStack(spacing: 16) {
                // Frosted icon container
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 72, height: 72)
                    
                    Image("icon-ultrasound 1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("E-FAST")
                        .font(.custom("Poppins-Bold", size: 28))
                        .foregroundColor(.white)
                    
                    Text("Extended Focused Assessment with Sonography in Trauma")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(gold)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .padding(20)
            .background(cardBlue)
            
            // Bottom Section - Stats bar
            HStack(spacing: 0) {
                // Views count
                VStack(spacing: 4) {
                    Text("5")
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(cardBlue)
                    
                    Text("Views")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(textMuted)
                }
                .frame(maxWidth: .infinity)
                
                // Divider
                Rectangle()
                    .fill(cardBlue.opacity(0.15))
                    .frame(width: 1, height: 40)
                
                // Purpose
                VStack(spacing: 4) {
                    Text("Trauma")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(Color(red: 0.02, green: 0.59, blue: 0.44))
                    
                    Text("Assessment")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(textMuted)
                }
                .frame(maxWidth: .infinity)
                
                // Divider
                Rectangle()
                    .fill(cardBlue.opacity(0.15))
                    .frame(width: 1, height: 40)
                
                // Time
                VStack(spacing: 4) {
                    Text("<5")
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                    
                    Text("Minutes")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(textMuted)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 16)
            .background(colorScheme == .dark ? Color(red: 0.12, green: 0.18, blue: 0.28) : Color.white)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [gold, gold.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: cardBlue.opacity(colorScheme == .dark ? 0.4 : 0.2), radius: 12, x: 0, y: 6)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Overview Card
    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with accent line
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(CriticalDesign.Colors.accentBlue)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.accentBlue.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentBlue)
                }
                
                Text("What is E-FAST?")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            Text("The E-FAST examination is a rapid bedside ultrasound protocol used to identify life-threatening conditions in trauma patients. It extends the traditional FAST exam by adding thoracic views to assess for pneumothorax and hemothorax.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(textTertiary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
            
            // Key indications
            VStack(alignment: .leading, spacing: 8) {
                Text("Key Indications:")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(textSecondary)
                
                HStack(spacing: 8) {
                    indicationBadge("Blunt Trauma")
                    indicationBadge("Penetrating Trauma")
                }
                HStack(spacing: 8) {
                    indicationBadge("Hypotension")
                    indicationBadge("Unknown Source")
                }
            }
        }
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
    
    private func indicationBadge(_ text: String) -> some View {
        Text(text)
            .font(.custom("Poppins-Medium", size: 11))
            .foregroundColor(colorScheme == .dark ? .white : cardBlue)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(colorScheme == .dark ? gold.opacity(0.2) : cardBlue.opacity(0.1))
            )
            .overlay(
                Capsule()
                    .stroke(colorScheme == .dark ? gold.opacity(0.3) : cardBlue.opacity(0.2), lineWidth: 1)
            )
    }
    
    // MARK: - Section Divider
    private func sectionDivider(title: String) -> some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, textMuted.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            
            Text(title)
                .font(.custom("Poppins-SemiBold", size: 11))
                .foregroundColor(textMuted)
                .tracking(2)
            
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [textMuted.opacity(0.3), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Acoustic Windows Section
    private var acousticWindowsSection: some View {
        VStack(spacing: 12) {
            ForEach(Array(acousticWindows.enumerated()), id: \.element.id) { index, window in
                EFASTWindowCard(
                    window: window,
                    colorScheme: colorScheme,
                    textPrimary: textPrimary,
                    textTertiary: textTertiary
                ) {
                    selectedWindow = window
                }
                .staggeredAppear(index: index, isAppearing: isAppearing, baseDelay: 0.3, staggerDelay: 0.08)
            }
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Critical Pearls Card
    private var criticalPearlsCard: some View {
        let pearls = [
            CriticalPearlItem(
                header: "Positive FAST ≠ Immediate OR",
                content: "Hemodynamically stable patients may be managed non-operatively with serial exams and CT imaging."
            ),
            CriticalPearlItem(
                header: "Negative FAST ≠ No Injury",
                content: "Sensitivity varies (73-88%). Solid organ injuries without hemoperitoneum may be missed. CT remains gold standard."
            ),
            CriticalPearlItem(
                header: "E > FAST",
                content: "The 'E' (Extended) adds thoracic views for pneumothorax—don't forget to check for lung sliding bilaterally."
            ),
            CriticalPearlItem(
                header: "Repeat if Uncertain",
                content: "Serial FAST exams increase sensitivity. Free fluid may take time to accumulate."
            )
        ]
        
        return TwoToneCriticalPearlsCard(
            items: pearls,
            isExpanded: $pearlsExpanded,
            initialDisplayCount: 3
        )
    }

    // MARK: - Systematic Approach Card
    private var systematicApproachCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(CriticalDesign.Colors.accentTeal)
                    .frame(width: 4, height: 44)

                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.accentTeal.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: "list.number")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentTeal)
                }

                Text("Systematic Approach")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)

                Spacer()
            }

            Text("Complete all 5 views in under 3 minutes. Follow this sequence:")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(textTertiary)
                .lineSpacing(5)

            VStack(alignment: .leading, spacing: 10) {
                approachStep(number: "1", text: "RUQ (Morrison's Pouch)", detail: "Highest sensitivity — start here")
                approachStep(number: "2", text: "LUQ (Splenorenal)", detail: "Most technically difficult — get it while you're positioned")
                approachStep(number: "3", text: "Subxiphoid Cardiac", detail: "Rule out pericardial effusion and tamponade")
                approachStep(number: "4", text: "Pelvic View", detail: "Most dependent space — scan before the Foley")
                approachStep(number: "5", text: "Bilateral Thoracic", detail: "Extend the FAST — check for pneumothorax both sides")
            }

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundColor(gold)
                Text("If time is critical, prioritize RUQ + Subxiphoid + Pelvic. These three views catch the majority of life-threatening findings.")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(textTertiary)
                    .italic()
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(gold.opacity(0.08))
            )
        }
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    private func approachStep(number: String, text: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(CriticalDesign.Colors.accentTeal.opacity(0.15))
                    .frame(width: 28, height: 28)
                Text(number)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(CriticalDesign.Colors.accentTeal)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(text)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(textPrimary)
                Text(detail)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(textTertiary)
            }
        }
    }

    // MARK: - When to Repeat / Escalate Card
    private var repeatAndEscalateCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(CriticalDesign.Colors.accentOrange)
                    .frame(width: 4, height: 44)

                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.accentOrange.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentOrange)
                }

                Text("When to Repeat & Escalate")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)

                Spacer()
            }

            Text("A single negative eFAST does not clear the patient. Serial exams increase sensitivity significantly.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(textTertiary)
                .lineSpacing(5)

            VStack(alignment: .leading, spacing: 12) {
                escalateRow(
                    icon: "clock.arrow.circlepath",
                    color: CriticalDesign.Colors.accentBlue,
                    title: "Repeat at 30 min, 1 hr, 4 hr",
                    detail: "For negative initial scan with ongoing clinical concern. Free fluid may take time to accumulate to detectable levels."
                )

                escalateRow(
                    icon: "ct.scan",
                    color: CriticalDesign.Colors.accentPurple,
                    title: "Escalate to CT if:",
                    detail: "High mechanism of injury, worsening vitals, persistent pain, or clinical suspicion despite negative FAST. CT sensitivity far exceeds FAST."
                )

                escalateRow(
                    icon: "phone.fill",
                    color: .red,
                    title: "Call Surgery if:",
                    detail: "Positive FAST with hemodynamic instability, worsening serial exams, or new free fluid on repeat scan."
                )

                escalateRow(
                    icon: "exclamationmark.shield.fill",
                    color: CriticalDesign.Colors.accentOrange,
                    title: "Remember:",
                    detail: "FAST sensitivity is 73-88%. It requires 200-500 mL of free fluid to be reliably detected. A negative scan does NOT rule out injury."
                )
            }
        }
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(CriticalDesign.Colors.accentOrange.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    private func escalateRow(icon: String, color: Color, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(textPrimary)
                Text(detail)
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(textTertiary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Putting It Together Card
    private var puttingItTogetherCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(CriticalDesign.Colors.accentPurple)
                    .frame(width: 4, height: 44)

                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.accentPurple.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: "puzzlepiece.extension.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentPurple)
                }

                Text("Putting It Together")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)

                Spacer()
            }

            Text("After completing all 5 views, integrate your findings:")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(textTertiary)
                .lineSpacing(5)

            VStack(alignment: .leading, spacing: 12) {
                integrationRow(
                    finding: "Free fluid in RUQ or LUQ",
                    meaning: "Hemoperitoneum — assess hemodynamic status to determine CT vs OR"
                )
                integrationRow(
                    finding: "Free fluid in pelvis only",
                    meaning: "May be early accumulation or physiologic (females). Repeat exam and correlate."
                )
                integrationRow(
                    finding: "Pericardial effusion",
                    meaning: "Evaluate for tamponade physiology (RV collapse, JVD, hypotension). Consider pericardiocentesis."
                )
                integrationRow(
                    finding: "Absent lung sliding",
                    meaning: "Pneumothorax at that intercostal space. Correlate with clinical status — if tension physiology, decompress immediately."
                )
                integrationRow(
                    finding: "Multiple positive windows",
                    meaning: "Significant hemorrhage. High likelihood of OR. Activate massive transfusion protocol."
                )
                integrationRow(
                    finding: "All windows negative",
                    meaning: "Reassuring but not definitive. Clinical judgment prevails. Serial exams or CT if suspicion remains."
                )
            }
        }
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    private func integrationRow(finding: String, meaning: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(finding)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(CriticalDesign.Colors.accentPurple)
            Text(meaning)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(textTertiary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(CriticalDesign.Colors.accentPurple.opacity(0.05))
        )
    }
}

// MARK: - E-FAST Window Card
struct EFASTWindowCard: View {
    let window: EFASTWindow
    let colorScheme: ColorScheme
    let textPrimary: Color
    let textTertiary: Color
    let action: () -> Void
    
    private let cardBlue = CriticalDesign.Colors.cardBlue
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // Vertical accent line
                RoundedRectangle(cornerRadius: 2)
                    .fill(window.color)
                    .frame(width: 4, height: 70)
                
                // Number badge
                ZStack {
                    Circle()
                        .fill(window.color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Text("\(window.number)")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(window.color)
                }
                
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(window.color.opacity(0.12))
                        .frame(width: 48, height: 48)
                    
                    Image(window.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(window.title)
                        .font(.custom("Poppins-SemiBold", size: 15))
                        .foregroundColor(textPrimary)
                        .lineLimit(1)
                    
                    Text(window.subtitle)
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(textTertiary)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(textTertiary.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                Group {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(cardBlue)
                    } else {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color.white.opacity(0.92))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(
                        colorScheme == .dark ? window.color.opacity(0.3) : Color.white.opacity(0.8),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - E-FAST Animated Background
struct EFASTAnimatedBackground: View {
    let colorScheme: ColorScheme
    @State private var animate = false
    
    // Light mode orbs
    private let navyOrb = Color(red: 0.11, green: 0.21, blue: 0.34).opacity(0.04)
    private let goldOrb = Color(red: 0.79, green: 0.64, blue: 0.15).opacity(0.03)
    private let tealOrb = Color(red: 0.02, green: 0.59, blue: 0.53).opacity(0.03)
    
    // Dark mode orbs
    private let darkGoldOrb = CriticalDesign.Colors.gold.opacity(0.08)
    private let darkBlueOrb = CriticalDesign.Colors.accentTeal.opacity(0.06)
    
    var body: some View {
        ZStack {
            // Base gradient
            if colorScheme == .dark {
                LinearGradient(
                    colors: [
                        CriticalDesign.Colors.cardBlue,
                        Color(red: 0.06, green: 0.10, blue: 0.18),
                        CriticalDesign.Colors.cardBlue.opacity(0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.97, blue: 0.98),
                        Color(red: 0.93, green: 0.94, blue: 0.98),
                        Color(red: 0.96, green: 0.97, blue: 0.98)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            // Animated orbs
            GeometryReader { geo in
                Circle()
                    .fill(colorScheme == .dark ? darkGoldOrb : navyOrb)
                    .frame(width: 300, height: 300)
                    .blur(radius: 100)
                    .offset(
                        x: animate ? geo.size.width * 0.6 : geo.size.width * 0.1,
                        y: animate ? geo.size.height * 0.2 : geo.size.height * 0.4
                    )
                
                Circle()
                    .fill(colorScheme == .dark ? darkBlueOrb : goldOrb)
                    .frame(width: 250, height: 250)
                    .blur(radius: 80)
                    .offset(
                        x: animate ? geo.size.width * 0.1 : geo.size.width * 0.5,
                        y: animate ? geo.size.height * 0.6 : geo.size.height * 0.3
                    )
                
                Circle()
                    .fill(tealOrb)
                    .frame(width: 200, height: 200)
                    .blur(radius: 70)
                    .offset(
                        x: animate ? geo.size.width * 0.7 : geo.size.width * 0.3,
                        y: animate ? geo.size.height * 0.8 : geo.size.height * 0.5
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 12).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - E-FAST Window Detail View
struct EFASTWindowDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    let window: EFASTWindow
    @State private var isAppearing = false
    @State private var selectedGif: EFASTMediaItem?
    
    private let cardBlue = CriticalDesign.Colors.cardBlue
    private let gold = Color(red: 0.96, green: 0.71, blue: 0.0)
    
    private var textPrimary: Color {
        colorScheme == .dark ? .white : Color(red: 0.04, green: 0.09, blue: 0.16)
    }
    private var textSecondary: Color {
        colorScheme == .dark ? Color.white.opacity(0.8) : Color(red: 0.11, green: 0.21, blue: 0.34)
    }
    private var textTertiary: Color {
        colorScheme == .dark ? Color.white.opacity(0.7) : Color(red: 0.24, green: 0.35, blue: 0.50)
    }
    private var textMuted: Color {
        colorScheme == .dark ? Color.white.opacity(0.5) : Color(red: 0.42, green: 0.49, blue: 0.54)
    }
    
    var body: some View {
        ZStack {
            EFASTAnimatedBackground(colorScheme: colorScheme)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Close button
                    HStack {
                        Spacer()
                        PremiumLightCloseButton {
                            dismiss()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    // GIF Gallery Section
                    if !window.gifs.isEmpty {
                        gifGallerySection
                            .opacity(isAppearing ? 1 : 0)
                            .offset(y: isAppearing ? 0 : 22)
                    }
                    
                    // Description Card
                    descriptionCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 25)
                    
                    // Landmarks Card
                    landmarksCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 28)
                    
                    // Technique Card
                    techniqueCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 30)
                    
                    // Findings Card
                    findingsCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 35)
                    
                    // Clinical Decision Card
                    clinicalDecisionCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 38)
                    
                    // Pitfalls Card
                    pitfallsCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 40)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
        .fullScreenCover(item: $selectedGif) { item in
            EFASTFullScreenMediaView(media: item, windowColor: window.color)
        }
    }
    
    // MARK: - Image Gallery Section
    private var gifGallerySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(window.color)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(window.color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(window.color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Image Gallery")
                        .font(.custom("Poppins-SemiBold", size: 18))
                        .foregroundColor(textPrimary)
                    
                    Text("Tap any image to enlarge")
                        .font(.custom("Poppins-Regular", size: 11))
                        .foregroundColor(textMuted)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            // Media Cards - horizontal scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(window.media) { item in
                        EFASTMediaCard(
                            media: item,
                            windowColor: window.color,
                            colorScheme: colorScheme,
                            textPrimary: textPrimary,
                            textMuted: textMuted
                        ) {
                            selectedGif = item
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
            }
        }
    }
    
    // MARK: - Landmarks Section
    private var landmarksCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(CriticalDesign.Colors.accentPurple)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.accentPurple.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "scope")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentPurple)
                }
                
                Text("Landmarks to Identify")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(getLandmarks(), id: \.self) { landmark in
                    HStack(alignment: .top, spacing: 10) {
                        Circle()
                            .fill(CriticalDesign.Colors.accentPurple)
                            .frame(width: 6, height: 6)
                            .offset(y: 6)
                        
                        Text(landmark)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(textTertiary)
                    }
                }
            }
        }
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Clinical Decision Card
    private var clinicalDecisionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(CriticalDesign.Colors.accentOrange)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.accentOrange.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "arrow.triangle.branch")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentOrange)
                }
                
                Text("Clinical Decision")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                decisionRow(
                    condition: "Positive FAST + Unstable",
                    action: "→ Emergent OR",
                    color: CriticalDesign.Colors.accentRed
                )
                
                decisionRow(
                    condition: "Positive FAST + Stable",
                    action: "→ CT Imaging",
                    color: CriticalDesign.Colors.accentBlue
                )
                
                decisionRow(
                    condition: "Negative FAST + Stable",
                    action: "→ Serial Exams / Observe",
                    color: CriticalDesign.Colors.accentGreen
                )
            }
        }
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(CriticalDesign.Colors.accentOrange.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    private func decisionRow(condition: String, action: String, color: Color) -> some View {
        HStack {
            Text(condition)
                .font(.custom("Poppins-Medium", size: 13))
                .foregroundColor(textSecondary)
            
            Spacer()
            
            Text(action)
                .font(.custom("Poppins-SemiBold", size: 13))
                .foregroundColor(color)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(color.opacity(colorScheme == .dark ? 0.15 : 0.08))
        )
    }
    
    // MARK: - Pitfalls Card
    private var pitfallsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(CriticalDesign.Colors.accentRed)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.accentRed.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                }
                
                Text("Pitfalls & Pearls")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(getPitfalls(), id: \.self) { pitfall in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(CriticalDesign.Colors.gold)
                            .offset(y: 4)
                        
                        Text(pitfall)
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(textTertiary)
                            .lineSpacing(4)
                    }
                }
            }
        }
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(CriticalDesign.Colors.accentRed.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            // Icon container with glow
            ZStack {
                Circle()
                    .fill(window.color.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark
                            ? cardBlue.opacity(0.9)
                            : Color.white.opacity(0.9))
                        .frame(width: 80, height: 80)
                    Circle()
                        .stroke(window.color.opacity(0.5), lineWidth: 2)
                        .frame(width: 80, height: 80)

                    Image(window.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .shadow(color: window.color.opacity(0.3), radius: 12, x: 0, y: 6)
            }
            
            // Number badge
            Text("View \(window.number)")
                .font(.custom("Poppins-SemiBold", size: 12))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(window.color)
                )
            
            // Title
            Text(window.title)
                .font(.custom("Poppins-Bold", size: 24))
                .foregroundColor(textPrimary)
                .multilineTextAlignment(.center)
            
            Text(window.subtitle)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(window.color)
        }
        .padding(.horizontal, 16)
    }
    
    private var descriptionCard: some View {
        contentCard(
            title: "Overview",
            icon: "doc.text.fill",
            iconColor: CriticalDesign.Colors.accentBlue,
            content: getOverviewContent()
        )
    }
    
    private var techniqueCard: some View {
        contentCard(
            title: "Technique",
            icon: "hand.point.up.left.fill",
            iconColor: CriticalDesign.Colors.accentTeal,
            content: getTechniqueContent()
        )
    }
    
    private var findingsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(CriticalDesign.Colors.accentGreen)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CriticalDesign.Colors.accentGreen.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "eye.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(CriticalDesign.Colors.accentGreen)
                }
                
                Text("What to Look For")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            // Normal findings
            findingRow(
                title: "Normal",
                description: getNormalFindings(),
                color: CriticalDesign.Colors.accentGreen
            )
            
            // Abnormal findings
            findingRow(
                title: "Abnormal",
                description: getAbnormalFindings(),
                color: CriticalDesign.Colors.accentRed
            )
        }
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
    
    private func contentCard(title: String, icon: String, iconColor: Color, content: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(iconColor)
                    .frame(width: 4, height: 44)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(textPrimary)
                
                Spacer()
            }
            
            Text(content)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(textTertiary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(cardBlue)
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.06), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 16)
    }
    
    private func findingRow(title: String, description: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .foregroundColor(color)
            }
            
            Text(description)
                .font(.custom("Poppins-Regular", size: 13))
                .foregroundColor(textTertiary)
                .lineSpacing(4)
                .padding(.leading, 16)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(color.opacity(colorScheme == .dark ? 0.12 : 0.06))
        )
    }
    
    // MARK: - Content Helpers
    private func getOverviewContent() -> String {
        switch window.number {
        case 1:
            return "The RUQ is the most sensitive region for detecting free fluid in the abdomen. Morrison's pouch (hepatorenal recess) is the most dependent area in the supine patient and where blood first accumulates.\n\nThis view also evaluates the right pleural space above the diaphragm for hemothorax and the inferior liver tip for lacerations."
        case 2:
            return "The thoracic views assess for pneumothorax by identifying lung sliding and artifact patterns. In a normal lung, the visceral and parietal pleura slide against each other with respiration.\n\nThe 'E' in E-FAST specifically refers to these bilateral thoracic views, extending the traditional FAST exam to include evaluation for pneumothorax and hemothorax."
        case 3:
            return "The LUQ (perisplenic/splenorenal) view is technically more challenging than the RUQ due to the smaller acoustic window provided by the spleen and interference from stomach gas.\n\nThe phrenicocolic ligament restricts blood flow to the paracolic gutter, causing it to preferentially collect in the perisplenic space."
        case 4:
            return "The subxiphoid cardiac view is essential for identifying pericardial effusion and cardiac tamponade. It uses the liver as an acoustic window to visualize all four cardiac chambers.\n\nIn cardiac arrest, this view can differentiate true asystole from fine VF and identify potentially reversible causes."
        case 5:
            return "The pelvic view evaluates the most dependent areas of the pelvis: the rectovesical pouch in males and the pouch of Douglas (rectouterine pouch) in females.\n\nA full bladder provides the best acoustic window. Consider scanning before Foley placement if possible."
        default:
            return window.description
        }
    }
    
    private func getTechniqueContent() -> String {
        switch window.number {
        case 1:
            return "Probe Position: Right mid-axillary line, 8th-11th intercostal space.\n\nProbe Indicator: Pointing cephalad (towards the head).\n\nFan through the field from anterior to posterior to visualize Morrison's pouch. Follow the inferior liver edge to the tip. If rib shadows obstruct, slide the probe between ribs.\n\nTo see pleural fluid, aim above the diaphragm. Have patient inspire deeply if diaphragm is difficult to visualize."
        case 2:
            return "Probe Position: Anterior chest, 2nd-4th intercostal space, mid-clavicular line.\n\nProbe Indicator: Pointing cephalad.\n\nIdentify two ribs with acoustic shadowing and the pleural line between them. Look for:\n• Lung sliding: Shimmering movement at pleural line\n• A-lines: Horizontal reverberation artifacts\n• Comet-tail artifacts: Vertical bright lines from pleura\n\nUse M-mode to confirm: Normal = 'seashore sign'; PTX = 'barcode/stratosphere sign'."
        case 3:
            return "Probe Position: Left posterior axillary line, 6th-9th intercostal space. Often MORE POSTERIOR and SUPERIOR than expected.\n\nProbe Indicator: Pointing cephalad.\n\nThis view is harder to obtain than RUQ. The spleen is smaller and the acoustic window is limited by the stomach. Fan anterior-to-posterior through the splenorenal interface.\n\nCheck above and below the diaphragm, and follow the inferior splenic pole."
        case 4:
            return "Probe Position: Subxiphoid region, nearly flat against the abdomen.\n\nProbe Indicator: Pointing to patient's LEFT side.\n\nAngle the probe towards the left shoulder, using the liver as an acoustic window. Apply firm pressure and have patient bend knees to relax abdominal muscles.\n\nObtain a four-chamber view. If unsuccessful, try the parasternal long axis (PLAX) as an alternative."
        case 5:
            return "Probe Position: Suprapubic, just above the pubic symphysis.\n\nProbe Indicator: Pointing cephalad for longitudinal, then rotate 90° for transverse.\n\nThe bladder serves as the acoustic window. A full bladder is ideal. Scan in both longitudinal and transverse planes.\n\nLook posterior to the bladder for free fluid collecting in the dependent recesses."
        default:
            return window.description
        }
    }
    
    private func getLandmarks() -> [String] {
        switch window.number {
        case 1:
            return [
                "Liver (hyperechoic, homogeneous)",
                "Right kidney (hypoechoic cortex)",
                "Morrison's pouch (hepatorenal recess)",
                "Diaphragm (bright hyperechoic line)",
                "Inferior liver tip",
                "Right pleural space"
            ]
        case 2:
            return [
                "Two adjacent ribs (with acoustic shadows)",
                "Pleural line (bright line between ribs)",
                "A-lines (horizontal reverberation artifacts)",
                "Lung sliding at pleural interface",
                "Comet-tail artifacts (if present)"
            ]
        case 3:
            return [
                "Spleen (homogeneous, smaller than liver)",
                "Left kidney",
                "Splenorenal recess (Koller's pouch)",
                "Diaphragm",
                "Left pleural space",
                "Inferior splenic pole"
            ]
        case 4:
            return [
                "Liver (acoustic window)",
                "Right ventricle (anterior chamber)",
                "Left ventricle (apex)",
                "Right atrium (near liver)",
                "Left atrium (posterior)",
                "Interventricular septum",
                "Pericardium (bright echogenic line)"
            ]
        case 5:
            return [
                "Urinary bladder (anechoic)",
                "Uterus (females, posterior to bladder)",
                "Prostate (males)",
                "Rectovesical pouch (males)",
                "Pouch of Douglas (females)",
                "Bowel loops"
            ]
        default:
            return ["Identify relevant anatomical structures"]
        }
    }
    
    private func getNormalFindings() -> String {
        switch window.number {
        case 1:
            return "Liver and kidney in close apposition with no anechoic stripe between them. Sharp inferior liver tip. Clear diaphragm with no fluid above or below. Mirror artifact of liver seen above diaphragm (normal)."
        case 2:
            return "Lung sliding present (shimmering at pleural line). A-lines visible as horizontal reverberation artifacts. Comet-tail artifacts may be present. M-mode shows 'seashore sign' with grainy pattern below pleural line."
        case 3:
            return "Spleen and kidney in close apposition separated by thin hyperechoic line. No fluid in splenorenal recess (Koller's pouch). Clear subphrenic and perisplenic spaces. No pleural effusion above diaphragm."
        case 4:
            return "All four chambers visible with normal cardiac motion. No anechoic rim around the heart. Pericardium appears as thin bright line. Normal RV and LV contractility. No RV collapse."
        case 5:
            return "Bladder visible as anechoic structure. No free fluid in rectovesical pouch (males) or pouch of Douglas (females). Normal pelvic anatomy without fluid collections."
        default:
            return "Normal anatomy without evidence of free fluid."
        }
    }
    
    private func getAbnormalFindings() -> String {
        switch window.number {
        case 1:
            return "Anechoic (jet black) stripe in Morrison's pouch indicates hemoperitoneum. Fluid around inferior liver tip or in subphrenic space. Fluid above diaphragm indicates hemothorax. Look for solid organ lacerations appearing as irregular hypoechoic areas."
        case 2:
            return "ABSENT lung sliding = pneumothorax until proven otherwise. M-mode shows 'barcode/stratosphere sign' (parallel horizontal lines). Lung point (transition between sliding and non-sliding) confirms PTX and indicates its extent. B-lines (vertical artifacts) may indicate pulmonary edema."
        case 3:
            return "Anechoic collection in splenorenal recess or perisplenic space. Free fluid above or below the diaphragm. Due to phrenicocolic ligament, blood collects perisplenic rather than flowing to pelvis. Left pleural effusion above diaphragm."
        case 4:
            return "Anechoic rim surrounding the heart indicates pericardial effusion. RV diastolic collapse suggests tamponade physiology. Swinging heart motion in large effusions. Distended IVC without respiratory variation. Absence of cardiac activity = asystole."
        case 5:
            return "Anechoic fluid posterior to bladder in dependent recesses. In males: fluid in rectovesical pouch. In females: fluid in pouch of Douglas (rectouterine pouch). Free fluid appears black and triangular in transverse view."
        default:
            return "Free fluid appearing as anechoic collection in the assessed region."
        }
    }
    
    private func getPitfalls() -> [String] {
        switch window.number {
        case 1:
            return [
                "Perinephric fat can mimic free fluid but appears more echogenic and doesn't change shape with respiration.",
                "Ascites (pre-existing) will appear in this window - correlate with clinical history.",
                "Rib shadows can obscure Morrison's pouch - angle between ribs.",
                "Small amounts of fluid may be missed - sensitivity improves with >200mL.",
                "A negative FAST does NOT rule out solid organ injury."
            ]
        case 2:
            return [
                "Lung pulse (cardiac motion transmitted to pleura) can mimic lung sliding in apneic patients.",
                "Bilateral absence of lung sliding in intubated patients may indicate mainstem intubation.",
                "E-point (ribs) can cause acoustic shadows - scan in intercostal spaces.",
                "B-lines (vertical artifacts) can obscure findings and indicate pulmonary pathology.",
                "Small pneumothoraces may only be visible at the lung apex in supine patients."
            ]
        case 3:
            return [
                "LUQ is technically harder than RUQ - don't give up too quickly. Go more posterior and superior.",
                "Stomach gas interferes with imaging - may need alternative windows.",
                "The spleen is smaller than liver, providing less acoustic window.",
                "Fluid collects perisplenic before going to pelvis due to phrenicocolic ligament.",
                "Left-sided injuries may present later than right-sided."
            ]
        case 4:
            return [
                "Epicardial fat can mimic pericardial effusion but appears more echogenic.",
                "Pericardial effusion vs pleural effusion: pericardial fluid is ANTERIOR to descending aorta.",
                "Obesity and COPD can make subxiphoid view difficult - try PLAX instead.",
                "Small effusions may not cause hemodynamic compromise.",
                "In cardiac arrest, brief pauses for cardiac ultrasound should not delay CPR."
            ]
        case 5:
            return [
                "Empty bladder significantly reduces sensitivity - scan before Foley if possible.",
                "Seminal vesicles can be mistaken for free fluid in males.",
                "Ovarian cysts in females can mimic free fluid.",
                "Small amounts of physiologic fluid are normal in females.",
                "Ascites will appear in this view - correlate with clinical context."
            ]
        default:
            return ["Always correlate findings with clinical picture."]
        }
    }
}

// MARK: - Full Screen Media Viewer (handles both GIFs and images)
struct EFASTFullScreenMediaView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    let media: EFASTMediaItem
    let windowColor: Color
    
    var body: some View {
        ZStack {
            // Dark background
            Color.black.ignoresSafeArea()
            
            // Media Content with Zoom
            ZoomableScrollView {
                if media.isGif {
                    GifImage(media.name)
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image(media.name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            
            // Overlay UI
            VStack {
                // Top bar with close button and title
                HStack {
                    // Title and status
                    VStack(alignment: .leading, spacing: 4) {
                        Text(media.title)
                            .font(.custom("Poppins-SemiBold", size: 16))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 6) {
                            Circle()
                                .fill(media.isNormal ? Color.green : Color.red)
                                .frame(width: 8, height: 8)
                            
                            Text(media.isNormal ? "Normal Finding" : "Pathological Finding")
                                .font(.custom("Poppins-Regular", size: 12))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    Spacer()
                    
                    // Close Button - Large and prominent
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 44, height: 44)
                            
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.8), Color.black.opacity(0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
                
                Spacer()
                
                // Bottom hint
                HStack {
                    Image(systemName: "hand.pinch")
                        .font(.system(size: 14))
                    Text("Pinch to zoom")
                        .font(.custom("Poppins-Regular", size: 12))
                }
                .foregroundColor(.white.opacity(0.5))
                .padding(.bottom, 30)
            }
        }
    }
}

// Legacy alias
typealias EFASTFullScreenGifView = EFASTFullScreenMediaView

// MARK: - Media Card Component (News-style card layout)
struct EFASTMediaCard: View {
    let media: EFASTMediaItem
    let windowColor: Color
    let colorScheme: ColorScheme
    let textPrimary: Color
    let textMuted: Color
    let action: () -> Void
    
    private let cardBlue = CriticalDesign.Colors.cardBlue
    private let cardWidth: CGFloat = 200
    private let imageHeight: CGFloat = 140
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                // Image Container - Fixed size with dark background
                ZStack {
                    // Dark navy background for consistent look
                    Rectangle()
                        .fill(Color(red: 0.08, green: 0.10, blue: 0.14))
                        .frame(width: cardWidth, height: imageHeight)
                    
                    // Media Preview - GIF or Image (FILL to ensure consistent sizing)
                    if media.isGif {
                        GifImage(media.name, contentMode: .fill)
                            .frame(width: cardWidth, height: imageHeight)
                            .clipped()
                    } else {
                        Image(media.name)
                            .resizable()
                            .scaledToFill()
                            .frame(width: cardWidth, height: imageHeight)
                            .clipped()
                    }
                    
                    // Gradient overlay for depth
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0),
                            Color.black.opacity(0.15)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    // Play button overlay for GIFs
                    if media.isGif {
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.5))
                                .frame(width: 44, height: 44)
                            
                            Circle()
                                .stroke(Color.white.opacity(0.6), lineWidth: 1.5)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "play.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .offset(x: 2)
                        }
                    }
                }
                .frame(width: cardWidth, height: imageHeight)
                .clipped()
                
                // Text Content Area
                VStack(alignment: .leading, spacing: 6) {
                    // Title
                    Text(media.title)
                        .font(.custom("Poppins-SemiBold", size: 14))
                        .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Status indicator
                    HStack(spacing: 6) {
                        Circle()
                            .fill(media.isNormal ? Color.green : Color(red: 0.9, green: 0.3, blue: 0.3))
                            .frame(width: 8, height: 8)
                        
                        Text(media.isNormal ? "Normal Finding" : "Pathological Finding")
                            .font(.custom("Poppins-Regular", size: 11))
                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.6) : Color(red: 0.4, green: 0.4, blue: 0.45))
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(width: cardWidth, alignment: .leading)
                .background(
                    colorScheme == .dark
                        ? Color(red: 0.15, green: 0.15, blue: 0.18)
                        : Color.white
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        colorScheme == .dark
                            ? Color.white.opacity(0.08)
                            : Color.black.opacity(0.06),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark
                    ? Color.black.opacity(0.4)
                    : Color.black.opacity(0.12),
                radius: 16,
                x: 0,
                y: 8
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// Legacy aliases for compatibility
typealias EFASTMediaThumbnail = EFASTMediaCard
typealias EFASTGifThumbnail = EFASTMediaCard

// Scale effect for button press
private struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    EFastExaminationView()
}
