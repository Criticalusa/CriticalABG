//
//  HepaticFailureView.swift
//  CriticalX
//
//  Premium Light Theme - Hepatic Failure Education
//  Following ECMOView design patterns
//

import SwiftUI

// MARK: - Hepatic Failure View
struct HepaticFailureView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var showAllPearls = false
    
    // Accent color
    private let accentColor = Color(red: 0.40, green: 0.55, blue: 0.50) // Teal green
    
    // MARK: - Formatted Content
    private var overviewContent: AttributedString {
        ContentFormatter.format("""
        Two Different Problems:
        Acute liver failure (ALF) and decompensated cirrhosis are both 'liver failure,' but they behave differently and need different approaches.

        Acute Liver Failure:
        New liver failure in someone with a previously normal liver. Coagulopathy plus encephalopathy developing within weeks. This can kill quickly—call transplant early.

        Decompensated Cirrhosis:
        The liver has been failing slowly for years. Now it's tipping over—ascites, encephalopathy, variceal bleeding, kidney failure. Manage the complications.
        """, headings: ["Two Different Problems:", "Acute Liver Failure:", "Decompensated Cirrhosis:"], isDarkMode: colorScheme == .dark)
    }

    private var alfContent: AttributedString {
        ContentFormatter.format("""
        Why It Happened:
        Acetaminophen is #1 in the US—always ask about it. Viral hepatitis (Hep B), drug reactions, autoimmune hepatitis, Wilson's in young patients.

        How Fast It Moved:
        Hyperacute (<7 days) is often acetaminophen—paradoxically, these do better. Subacute (weeks) is usually worse. The slower the onset, the worse the prognosis.

        King's College Criteria:
        These help predict who needs a transplant. For acetaminophen: pH <7.30, or grade 3-4 encephalopathy + INR >6.5 + Cr >3.4. Meet criteria? Call transplant now.

        The Bottom Line:
        ALF moves fast. You need to be thinking about transplant from the moment you make the diagnosis.
        """, headings: ["Why It Happened:", "How Fast It Moved:", "King's College Criteria:", "The Bottom Line:"], isDarkMode: colorScheme == .dark)
    }

    private var managementContent: AttributedString {
        ContentFormatter.format("""
        First Priorities:
        ICU for everyone with ALF. Frequent neuro checks—encephalopathy grade drives management. Watch glucose closely—they get hypoglycemic.

        NAC For Everyone:
        N-acetylcysteine helps even in non-acetaminophen ALF. Start it. You're not committing to anything, and it improves outcomes.

        Don't Chase The INR:
        This is counterintuitive, but don't correct the coagulopathy unless they're actively bleeding. INR is your prognostic marker—correcting it blinds you.

        Cerebral Edema:
        The thing that kills ALF patients. Head of bed up, avoid hyperthermia, consider hypertonic saline. If encephalopathy is worsening, think about this.

        Call Transplant Early:
        Don't wait until they're dying. ALF can progress from confused to comatose in hours. The transplant center needs time to evaluate.
        """, headings: ["First Priorities:", "NAC For Everyone:", "Don't Chase The INR:", "Cerebral Edema:", "Call Transplant Early:"], isDarkMode: colorScheme == .dark)
    }

    private var encephalopathyContent: AttributedString {
        ContentFormatter.format("""
        What You're Seeing:
        Grade 1-2: Confused, disoriented, asterixis. Grade 3-4: Obtunded, comatose. In cirrhosis, this is usually ammonia. In ALF, it's cerebral edema.

        Look For The Trigger:
        In cirrhotic patients, something usually pushed them over—GI bleed, infection, constipation, benzos/opioids, dehydration. Find it and fix it.

        Treatment:
        Lactulose: 2-3 soft stools a day. Add rifaximin for recurrent episodes. Don't restrict protein—that's outdated advice.

        ALF Encephalopathy Is Different:
        This isn't ammonia—it's brain swelling. Watch for signs of increased ICP. May need intubation for airway protection before they herniate.
        """, headings: ["What You're Seeing:", "Look For The Trigger:", "Treatment:", "ALF Encephalopathy Is Different:"], isDarkMode: colorScheme == .dark)
    }

    private var hrsContent: AttributedString {
        ContentFormatter.format("""
        What's Happening:
        The kidneys are structurally fine—they're failing because of terrible renal perfusion from portal hypertension. It's a functional problem.

        Type 1 (HRS-AKI):
        Creatinine doubles in two weeks. Often triggered by infection (SBP). Without treatment, most die. This is urgent.

        Type 2 (HRS-CKD):
        Slower decline, usually with refractory ascites. Less immediately life-threatening but still serious.

        The Treatment:
        Albumin + vasoconstrictor. Terlipressin if you have it, otherwise norepinephrine. Midodrine + octreotide is third-line. Transplant is the only real cure.
        """, headings: ["What's Happening:", "Type 1 (HRS-AKI):", "Type 2 (HRS-CKD):", "The Treatment:"], isDarkMode: colorScheme == .dark)
    }

    private var sbpContent: AttributedString {
        ContentFormatter.format("""
        Low Threshold To Tap:
        Any cirrhotic with ascites who has fever, belly pain, or worsening encephalopathy needs a diagnostic tap. SBP can be subtle—don't wait.

        Making The Diagnosis:
        PMN count >250 cells/mm³ on ascitic fluid analysis. Send for culture but don't wait for results to treat.

        Treatment:
        Start antibiotics right after you tap—ceftriaxone 2g daily is easy. Give albumin: 1.5 g/kg day 1, 1 g/kg day 3. The albumin saves lives.

        Preventing The Next One:
        After the first SBP, they need lifelong prophylaxis—norfloxacin or TMP-SMX daily. This dramatically reduces recurrence.
        """, headings: ["Low Threshold To Tap:", "Making The Diagnosis:", "Treatment:", "Preventing The Next One:"], isDarkMode: colorScheme == .dark)
    }

    // Clinical Pearls
    private let pearlItems: [CriticalPearlItem] = [
        CriticalPearlItem(
            header: "NAC Works Broadly:",
            content: "Give NAC to all ALF patients—not just acetaminophen. It improves transplant-free survival even when the cause is unknown."
        ),
        CriticalPearlItem(
            header: "Leave The INR Alone:",
            content: "Correcting coagulopathy in ALF doesn't prevent bleeding and destroys your prognostic marker. Only give FFP for active bleeding."
        ),
        CriticalPearlItem(
            header: "Tap Early, Tap Often:",
            content: "In cirrhotic patients with any change, do a paracentesis. SBP is treatable, but you have to diagnose it first."
        ),
        CriticalPearlItem(
            header: "Don't Forget The Albumin:",
            content: "Albumin with SBP antibiotics reduces mortality and HRS. It's not optional—it's standard of care."
        ),
        CriticalPearlItem(
            header: "Call Transplant Early:",
            content: "ALF progresses fast. By the time you're sure they need a transplant, it might be too late. Make the call early."
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
                    
                    // MARK: - ALF Card (Accent)
                    accentCard(
                        title: "Acute Liver Failure",
                        subtitle: "Coagulopathy + Encephalopathy",
                        icon: "bolt.heart.fill",
                        content: alfContent,
                        color: Color(red: 0.75, green: 0.30, blue: 0.30)
                    )
                    
                    // MARK: - Management Card
                    PremiumLightGlassCard(
                        title: "ICU Management",
                        icon: "cross.case.fill",
                        content: managementContent
                    )
                    
                    // MARK: - Encephalopathy Card
                    accentCard(
                        title: "Hepatic Encephalopathy",
                        subtitle: "Grade I-IV Classification",
                        icon: "brain.head.profile",
                        content: encephalopathyContent,
                        color: Color(red: 0.55, green: 0.45, blue: 0.65)
                    )
                    
                    // MARK: - HRS Card (Warning)
                    hrsCard
                    
                    // MARK: - SBP Card
                    sbpCard
                    
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

                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(accentColor)
            }
            .shadow(color: colorScheme == .dark ? Color.clear : accentColor.opacity(0.2), radius: 10, y: 4)
            
            Text("Hepatic Failure")
                .font(.custom("Poppins-Bold", size: 32))
                .foregroundColor(colorScheme == .dark ? .white : Color(red: 0.1, green: 0.1, blue: 0.15))
            
            Text("Acute & Chronic Liver Failure")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(accentColor)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 24) {
                quickStat(icon: "clock.fill", value: "<26w", label: "ALF Definition")
                quickStat(icon: "staroflife.fill", value: "NAC", label: "Antidote")
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

    // MARK: - HRS Card (Warning style)
    private var hrsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [Color.orange.opacity(0.9), Color.orange.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.orange.opacity(0.3), radius: 4, y: 2)
                
                Text("Hepatorenal Syndrome")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(Color.orange)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            Text(hrsContent)
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

    // MARK: - SBP Card
    private var sbpCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Image(systemName: "allergens")
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
                
                Text("Spontaneous Bacterial Peritonitis")
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(Color.red)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 14)
            
            Text(sbpContent)
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
    HepaticFailureView()
}
