//
//  GIBleedingView.swift
//  CriticalX
//
//  Premium Light Theme - GI Bleeding Education
//  Following ECMOView design patterns
//

import SwiftUI

// MARK: - GI Bleeding View
struct GIBleedingView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var showAllPearls = false
    
    // Accent color
    private let accentColor = Color(red: 0.70, green: 0.40, blue: 0.35) // Terracotta
    
    // MARK: - Formatted Content
    private var overviewContent: AttributedString {
        ContentFormatter.format("""
        The Big Picture:
        GI bleeding can look dramatic, but your approach is simple: stabilize first, diagnose second. The source doesn't matter until the patient is resuscitated.

        Upper vs Lower:
        Upper GI bleeds (above the ligament of Treitz) are more common and more dangerous. Lower bleeds often stop on their own—80% resolve spontaneously.

        Your First Moves:
        Two large-bore IVs, type and screen, volume. Don't chase the hemoglobin—transfuse to 7, not 10. Call GI early.
        """, headings: ["The Big Picture:", "Upper vs Lower:", "Your First Moves:"], isDarkMode: colorScheme == .dark)
    }

    private var ugibContent: AttributedString {
        ContentFormatter.format("""
        What You'll See:
        Coffee-ground emesis or hematemesis. Melena (black, tarry stools). Tachycardia and hypotension if significant blood loss.

        Common Culprits:
        Peptic ulcers are #1. Varices if they have liver disease. Mallory-Weiss tears after retching. Malignancy is less common but important.

        What To Do:
        Start fluids and blood if needed. Give IV PPI—80mg bolus, then 8mg/hr drip. Hold anticoagulants. Get the scope within 24 hours, sooner if unstable.

        Don't Worry About:
        Exact risk scores at 3am. Get the patient stable, start the PPI, and let GI decide on timing. That's enough.
        """, headings: ["What You'll See:", "Common Culprits:", "What To Do:", "Don't Worry About:"], isDarkMode: colorScheme == .dark)
    }

    private var lgibContent: AttributedString {
        ContentFormatter.format("""
        Different Animal:
        Lower GI bleeds are usually less urgent. Bright red blood per rectum, maroon stools. Most stop on their own.

        Common Causes:
        Diverticulosis is #1 in older patients. Hemorrhoids in younger. Malignancy, ischemic colitis, and angiodysplasia are in the mix.

        The Workup:
        If stable, colonoscopy after bowel prep. If actively bleeding, CT angiography can localize the source. Tagged RBC scan for slow, intermittent bleeding.

        Key Point:
        Don't assume bright red blood = lower GI bleed. A brisk upper bleed can present with hematochezia. Check the BUN:Cr ratio—>20 suggests upper.
        """, headings: ["Different Animal:", "Common Causes:", "The Workup:", "Key Point:"], isDarkMode: colorScheme == .dark)
    }

    private var transfusionContent: AttributedString {
        ContentFormatter.format("""
        Less Is More:
        Transfuse when hemoglobin drops below 7. Restrictive transfusion improves outcomes—this is well-established, not controversial.

        When To Be More Liberal:
        Active coronary disease, hemodynamic instability despite resuscitation, or truly massive hemorrhage. Then aim for 8-9.

        Varices Are Special:
        Over-transfusion increases portal pressure and makes bleeding worse. Keep Hgb 7-8. Only give FFP/platelets if actually coagulopathic.

        Massive Transfusion Protocol:
        1:1:1 ratio (red cells, plasma, platelets). Consider TXA within 3 hours of bleeding. Keep the patient warm.
        """, headings: ["Less Is More:", "When To Be More Liberal:", "Varices Are Special:", "Massive Transfusion Protocol:"], isDarkMode: colorScheme == .dark)
    }

    private var varicesContent: AttributedString {
        ContentFormatter.format("""
        This Is An Emergency:
        Variceal bleeding is different—these patients can exsanguinate rapidly. Protect the airway early if massive hematemesis or encephalopathy.

        The Variceal Bundle:
        Octreotide (50 mcg bolus, then 50 mcg/hr) reduces portal pressure. IV PPI. Ceftriaxone 1g daily—antibiotics reduce mortality in variceal bleeds.

        Get To The Scope:
        Urgent EGD within 12 hours. Band ligation is first-line. If banding fails and they keep bleeding, TIPS is the rescue.

        After They Survive:
        Beta-blockers for secondary prophylaxis. Repeat banding until the varices are gone. This prevents the next bleed.
        """, headings: ["This Is An Emergency:", "The Variceal Bundle:", "Get To The Scope:", "After They Survive:"], isDarkMode: colorScheme == .dark)
    }

    // Clinical Pearls
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(
            header: "Transfuse to 7:",
            content: "Overtransfusion kills people in GI bleeds. Hgb 7 is the target. In varices, going higher increases portal pressure and rebleeding."
        ),
        CriticalPearlItem(
            header: "Antibiotics Save Lives:",
            content: "Ceftriaxone in variceal bleeding isn't optional—it reduces mortality. Give it. 1g IV daily for 7 days."
        ),
        CriticalPearlItem(
            header: "Skip the NG Lavage:",
            content: "It doesn't change outcomes and delays care. If you're worried it's upper, just assume it is and treat accordingly."
        ),
        CriticalPearlItem(
            header: "PPI Before Scope:",
            content: "High-dose IV PPI before endoscopy reduces rebleeding in ulcers. Give it—you're not committing to anything."
        ),
        CriticalPearlItem(
            header: "Anticoagulant Reversal:",
            content: "Hold the anticoagulant. Warfarin: vitamin K + PCC. Dabigatran: idarucizumab. Factor Xa inhibitors: andexanet alfa if available."
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
                    
                    // MARK: - UGIB Card (Accent)
                    accentCard(
                        title: "Upper GI Bleeding",
                        subtitle: "Proximal to ligament of Treitz",
                        icon: "arrow.up.circle.fill",
                        content: ugibContent,
                        color: Color(red: 0.75, green: 0.30, blue: 0.30)
                    )
                    
                    // MARK: - LGIB Card (Accent)
                    accentCard(
                        title: "Lower GI Bleeding",
                        subtitle: "Distal to ligament of Treitz",
                        icon: "arrow.down.circle.fill",
                        content: lgibContent,
                        color: Color(red: 0.50, green: 0.40, blue: 0.60)
                    )
                    
                    // MARK: - Transfusion Card
                    PremiumLightGlassCard(
                        title: "Transfusion Strategy",
                        icon: "drop.fill",
                        content: transfusionContent
                    )
                    
                    // MARK: - Varices Card (Warning)
                    varicesCard
                    
                    // MARK: - Clinical Pearls
                    TwoToneCriticalPearlsCard(items: pearlItems, isExpanded: $showAllPearls)
                        .padding(.bottom, 40)
                }
            }
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

                Image(systemName: "drop.triangle.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(accentColor)
            }
            .shadow(color: colorScheme == .dark ? Color.clear : accentColor.opacity(0.2), radius: 10, y: 4)
            
            Text("GI Bleeding")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
            
            Text("Upper & Lower GI Hemorrhage")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(accentColor)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 24) {
                quickStat(icon: "arrow.up", value: "UGIB", label: "More Common")
                quickStat(icon: "clock.fill", value: "<24h", label: "EGD Timing")
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
    
    // MARK: - Accent Card
    private func accentCard(title: String, subtitle: String, icon: String, content: AttributedString, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(color)
                    
                    Text(subtitle)
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : Color(red: 0.4, green: 0.4, blue: 0.5))
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            Text(content)
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
                            .fill(
                                LinearGradient(
                                    colors: [color.opacity(0.15), Color.clear],
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
                                    colors: [color.opacity(0.1), Color.white.opacity(0.3), Color.clear],
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
                            color.opacity(0.4),
                            colorScheme == .dark ? color.opacity(0.15) : Color.white.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : color.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Varices Card (Warning style)
    private var varicesCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [Color.red.opacity(0.9), Color.red.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.red.opacity(0.3), radius: 4, y: 2)
                
                Text("Variceal Bleeding")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(Color.red)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            Text(varicesContent)
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
                            .fill(Color.red.opacity(0.08))
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color.red.opacity(0.05))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.0 : 0.08), radius: 20, x: 0, y: 10)
        .shadow(color: colorScheme == .dark ? Color.clear : Color.red.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

// MARK: - Preview
#Preview {
    GIBleedingView()
}
