//
//  AntibioticsMasterclassView.swift
//  CriticalX
//
//  Created on 2026-01-10.
//  ICU Antibiotics Masterclass - Comprehensive Teaching Module
//

import SwiftUI

struct AntibioticsMasterclassView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedSection: MasterclassSection = .overview
    @State private var expandedCards: Set<String> = []
    
    enum MasterclassSection: String, CaseIterable {
        case overview = "Overview"
        case targets = "Targets"
        case classes = "Classes"
        case empiric = "Empiric Tx"
        case dangers = "Dangers"
        case reference = "Reference"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: CriticalDesign.Spacing.lg) {
                // MARK: - Header
                headerSection
                
                // MARK: - Section Selector
                sectionSelector
                
                // MARK: - Content based on selection
                contentSection
                
                // MARK: - Branding Card
                brandingCard
                    .padding(.top, CriticalDesign.Spacing.md)
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .background(CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { GlobalPatientContext.shared.showFloatingButton = false }
        .onDisappear { GlobalPatientContext.shared.showFloatingButton = true }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.sm) {
            GradientEdgeFadeImage(imageName: "icon-abx", size: 120)
            
            Text("ICU Antibiotics")
                .font(.custom("Poppins-Bold", size: 28))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("A Masterclass for Real Clinical Decision-Making")
                .font(.custom("SF-Pro-Rounded-Semibold", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }
    
    // MARK: - Section Selector
    private var sectionSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                ForEach(MasterclassSection.allCases, id: \.self) { section in
                    sectionPill(section)
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    @available(iOS 13.0, *)
    private func sectionPill(_ section: MasterclassSection) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedSection = section
            }
        }) {
            Text(section.rawValue)
                .font(.custom("SF-Pro-Rounded-Semibold", size: 13))
                .foregroundColor(selectedSection == section ? .white : (colorScheme == .dark ? .white.opacity(0.9) : CriticalDesign.Colors.cardBlue))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Group {
                        if selectedSection == section {
                            LinearGradient(
                                colors: [CriticalDesign.Colors.cardBlue, CriticalDesign.Colors.cardBlue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else if colorScheme == .dark {
                            CriticalDesign.Colors.cardBlue.opacity(0.4)
                        } else {
                            LinearGradient(
                                colors: [Color.white, Color(UIColor.systemGray6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                    }
                )
                .clipShape(Capsule())
                .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
                .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.8), radius: 4, x: -2, y: -2)
        }
    }
    
    // MARK: - Content Section
    @ViewBuilder
    private var contentSection: some View {
        switch selectedSection {
        case .overview:
            overviewContent
        case .targets:
            targetsContent
        case .classes:
            classesContent
        case .empiric:
            empiricContent
        case .dangers:
            dangersContent
        case .reference:
            referenceContent
        }
    }
    
    // MARK: - Overview Content
    private var overviewContent: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Why This Matters
            contentCard(
                title: "Why This Matters",
                icon: "heart.text.square.fill",
                iconColor: .red,
                content: """
Antibiotics are not background therapy.

In critical care, they are often the **only thing preventing a patient from crashing** while physiology is being rescued.

• **Minutes matter** for coverage.
• **Days matter** for toxicity, resistance, and organ injury.

You don't need perfect microbiology to save a life. You need the right coverage early, the right dose for the patient, and the discipline to narrow fast once reality appears.
""",
                lineSpacing: 6
            )
            
            // The Three Questions
            contentCard(
                title: "The Three Questions",
                icon: "questionmark.circle.fill",
                iconColor: .blue,
                content: """
If you can consistently answer three questions, you will be good at ICU antibiotics:

• **1. What am I trying to cover right now?**

• **2. What am I missing?**

• **3. When can I safely narrow?**

That's the whole game.
""",
                lineSpacing: 6
            )
            
            // The Mental Model
            contentCard(
                title: "The Mental Model",
                icon: "brain.head.profile",
                iconColor: .purple,
                content: """
Every serious bacterial infection lives in **four boxes**:

• **1. MRSA / Resistant Gram-Positives**  
  Skin, lines, valves, lungs.

• **2. Gram-Negative Rods (Including Pseudomonas)**  
  Urine, gut, hospital flora.

• **3. Anaerobes**  
  Bowel, pelvis, necrotic tissue.

• **4. Atypicals (Pneumonia Only)**  
  Legionella, Mycoplasma, Chlamydia.

Every antibiotic answers one question: **Which boxes does this drug cover — and which does it leave empty?**
""",
                lineSpacing: 6
            )
            
            // What Changes Management
            contentCard(
                title: "What Actually Changes Management",
                icon: "arrow.triangle.branch",
                iconColor: .orange,
                content: """
Three things matter more than the drug list:

**1. Source**
• Lung — MRSA + gram-negatives.
• Gut — gram-negatives + anaerobes.
• Line/valve — MRSA.
• Urine — Enterobacterales ± Pseudomonas.

**2. Setting**
• Community — narrower.
• Hospital — broader.
• ICU — assume resistance until proven otherwise.

**3. Kidneys**  
Many ICU antibiotics accumulate when renal function falls.

**Two rules save you:**
• Loading doses are usually safe (even in renal failure).
• Maintenance must be adjusted frequently as kidney function changes.
""",
                lineSpacing: 6
            )
        }
    }
    
    // MARK: - Targets Content
    private var targetsContent: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Gram-Positive
            contentCard(
                title: "Gram-Positive Organisms",
                icon: "circle.fill",
                iconColor: .purple,
                content: """
**Thick peptidoglycan cell wall.**

**Common pathogens**  
• Staphylococcus (including MRSA)  
• Streptococcus  
• Enterococcus  

**Typical infections**  
• Skin and soft tissue  
• Endocarditis  
• Pneumonia  
• Line infections  

**Key drugs**  
• Cefazolin (MSSA)  
• Vancomycin (MRSA)  
• Linezolid (MRSA/VRE)  
• Daptomycin (MRSA/VRE — NOT lungs)
""",
                lineSpacing: 6
            )
            
            // Gram-Negative
            contentCard(
                title: "Gram-Negative Organisms",
                icon: "circle.fill",
                iconColor: .red,
                content: """
**Outer membrane + efflux** — relatively more resistant.

**Common pathogens**  
• E. coli, Klebsiella, Pseudomonas, Enterobacter  

**Typical infections**  
• UTI / pyelonephritis  
• Intra-abdominal sepsis  
• Hospital-acquired pneumonia  

**Key drugs**  
• Ceftriaxone (no Pseudomonas)  
• Cefepime (includes Pseudomonas)  
• Piperacillin–Tazobactam  
• Meropenem (ESBL coverage)  
• Gentamicin  
• Fluoroquinolones
""",
                lineSpacing: 6
            )
            
            // Anaerobes
            contentCard(
                title: "Anaerobes",
                icon: "circle.fill",
                iconColor: .brown,
                content: """
**Thrive in low-oxygen sites.**

**Where you find them**  
• Abscesses  
• Bowel perforations  
• Necrotic tissue  
• Aspiration pneumonia  

**Key drugs**  
• Metronidazole (the specialist)  
• Piperacillin–Tazobactam  
• Meropenem  
• Ampicillin–Sulbactam  

**Classic combination**  
• Ceftriaxone + Metronidazole for intra-abdominal.
""",
                lineSpacing: 6
            )
            
            // ESBL Explained
            contentCard(
                title: "ESBL — What It Actually Means",
                icon: "shield.slash.fill",
                iconColor: .orange,
                content: """
**ESBL = Extended-Spectrum Beta-Lactamase**  
A bacterial enzyme that **destroys most beta-lactam antibiotics** before they can work.

**ESBL bacteria chew up**  
• Ceftriaxone  
• Cefepime  
• Zosyn (often unreliable)  

**Carbapenems survive that attack.**

**The classic trap**  
"The bug looks sensitive… but the patient isn't getting better." That's ESBL hiding behind lab numbers.

**When ESBL is suspected**  
• Do NOT trust cefepime, Zosyn, or ceftriaxone.  
• DO use **meropenem**.
""",
                lineSpacing: 6
            )
        }
    }
    
    // MARK: - Classes Content
    private var classesContent: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Beta-Lactams
            expandableCard(
                id: "betalactams",
                title: "Beta-Lactams",
                subtitle: "Penicillins & Cephalosporins",
                icon: "pills.fill",
                iconColor: .blue,
                content: """
**Time-dependent killers** — efficacy driven by time above MIC. Extended/continuous infusions preferred in shock.

**Penicillins:**

• **Ampicillin-Sulbactam (Unasyn)** — aspiration, ENT; no Pseudomonas.

• **Piperacillin-Tazobactam (Zosyn)** — broad including Pseudomonas + anaerobes.

**Cephalosporins:**

• **Cefazolin (1st gen)** — MSSA, skin, surgical prophylaxis.

• **Ceftriaxone (3rd gen)** — community GN, CAP, meningitis; no Pseudomonas.

• **Cefepime (4th gen)** — Pseudomonas; no anaerobes; neurotoxicity in renal failure.

**Carbapenems:**

• **Meropenem** — broadest spectrum; ESBL + Pseudomonas + anaerobes; seizure risk in renal failure.
""",
                lineSpacing: 6
            )
            
            // Aminoglycosides
            expandableCard(
                id: "aminoglycosides",
                title: "Aminoglycosides",
                subtitle: "Gentamicin",
                icon: "syringe.fill",
                iconColor: .green,
                content: """
**Concentration-dependent killers** — efficacy tied to Cmax/MIC. Give full once-daily doses.

**Gentamicin:**

• Potent gram-negative activity.

• Excellent for synergy (with beta-lactams).

• Use for: open fractures, severe sepsis add-on.

**Dangers:**

• Nephrotoxicity (usually reversible).

• Ototoxicity (may be permanent).

**Dosing:**

5 mg/kg IV q24h. Monitor troughs <1 mcg/mL.
""",
                lineSpacing: 6
            )
            
            // Glycopeptides
            expandableCard(
                id: "glycopeptides",
                title: "Glycopeptides",
                subtitle: "Vancomycin",
                icon: "cross.vial.fill",
                iconColor: .red,
                content: """
**Vancomycin:**

• MRSA and serious gram-positive infections.

• IV for systemic; PO for C. difficile colitis ONLY.

**Dosing:**

• Load: 20 mg/kg (max 2.5 g).

• Maintenance: per renal function and TDM (AUC-guided).

**Dangers:**

• Nephrotoxicity (especially with Zosyn).

• Red man syndrome (if infused too fast).

**Remember:** Dose carefully, monitor exposure, de-escalate early.
""",
                lineSpacing: 6
            )
            
            // Lipopeptides
            expandableCard(
                id: "lipopeptides",
                title: "Lipopeptides",
                subtitle: "Daptomycin",
                icon: "bolt.fill",
                iconColor: .orange,
                content: """
**Daptomycin (Cubicin):**

• MRSA/VRE bacteremia, endocarditis, deep infections.

• **NOT FOR PNEUMONIA** — inactivated by lung surfactant.

**Dosing:**

5-10 mg/kg IV q24-48h (extend interval if CrCl <30).

**Dangers:**

• Myopathy/rhabdomyolysis — monitor CPK.

• Avoid or hold statins.

**Two Unbreakable Rules:**

1. Never use it for pneumonia.

2. Always respect the muscles and kidneys.
""",
                lineSpacing: 6
            )
            
            // Oxazolidinones
            expandableCard(
                id: "oxazolidinones",
                title: "Oxazolidinones",
                subtitle: "Linezolid",
                icon: "capsule.fill",
                iconColor: .purple,
                content: """
**Linezolid (Zyvox):**

• MRSA/VRE including respiratory infections.

• Excellent oral bioavailability (100%).

**Dosing:**

600 mg IV/PO q12h.

**Dangers:**

• Thrombocytopenia (courses >7-10 days).

• Serotonin syndrome (with SSRIs/SNRIs/MAOIs).

• Lactic acidosis and neuropathy (prolonged therapy).

**Use deliberately, monitor closely, and don't let it run longer than it has to.**
""",
                lineSpacing: 6
            )
            
            // Fluoroquinolones
            expandableCard(
                id: "fluoroquinolones",
                title: "Fluoroquinolones",
                subtitle: "Levofloxacin & Ciprofloxacin",
                icon: "atom",
                iconColor: .teal,
                content: """
**Levofloxacin (Respiratory FQ):**

• CAP — covers Strep pneumo + atypicals.

• Some Pseudomonas coverage.

• Use for severe PCN allergy.

**Ciprofloxacin (Gram-Negative FQ):**

• Stronger gram-negative including Pseudomonas.

• Pyelonephritis, intra-abdominal (+ metro).

• Weaker against Strep pneumo — don't use for CAP.

**Black Box Warnings:**

• Tendinopathy/tendon rupture.

• QT prolongation.

• Aortic dissection/aneurysm.

• CNS effects.

• Peripheral neuropathy.
""",
                lineSpacing: 6
            )
            
            // Nitroimidazoles
            expandableCard(
                id: "nitroimidazoles",
                title: "Nitroimidazoles",
                subtitle: "Metronidazole",
                icon: "cross.circle.fill",
                iconColor: .brown,
                content: """
**Metronidazole (Flagyl):**

• The anaerobe assassin.

• Also covers protozoa.

**Classic Uses:**

• Intra-abdominal (with ceftriaxone).

• C. difficile (PO only — IV doesn't reach colon).

• Pelvic infections.

• Brain abscess.

**Warnings:**

• Disulfiram-like reaction with alcohol.

• Peripheral neuropathy with prolonged use.

**Dosing:**

500 mg IV/PO q6-8h.
""",
                lineSpacing: 6
            )
        }
    }
    
    // MARK: - Empiric Content
    private var empiricContent: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Undifferentiated Sepsis
            contentCard(
                title: "Undifferentiated Septic Shock",
                icon: "waveform.path.ecg",
                iconColor: .red,
                content: """
**Pick ONE gram-negative backbone**  
• Cefepime  
• Piperacillin–Tazobactam  
• Meropenem (if ESBL/MDR risk)  

**Add MRSA if any risk**  
• Vancomycin  
• Linezolid (lungs, kidneys fragile)  
• Daptomycin (blood/valves only)  

**Go straight to meropenem if**  
• Prior ESBL  
• Recent broad antibiotics or ICU GN infections  
• Severe abdominal catastrophe  
• Rapidly worsening GN bacteremia  
• Failure on cefepime/Zosyn
""",
                lineSpacing: 6
            )
            
            // Pneumonia
            contentCard(
                title: "Pneumonia",
                icon: "lungs.fill",
                iconColor: .blue,
                content: """
**Community-acquired (CAP)**  
• Ceftriaxone + doxycycline or azithromycin  
• OR respiratory fluoroquinolone (levofloxacin)  
• Add MRSA only if risk factors  

**Hospital-acquired / VAP**  
• Cefepime or Zosyn (or meropenem if MDR risk)  
• Plus vancomycin or linezolid  

**Never use daptomycin for pneumonia** — surfactant inactivates it.
""",
                lineSpacing: 6
            )
            
            // Intra-Abdominal
            contentCard(
                title: "Intra-Abdominal Sepsis",
                icon: "cross.case.fill",
                iconColor: .orange,
                content: """
**Standard options**  
• Ceftriaxone + Metronidazole  
• Piperacillin–Tazobactam (single agent)  
• Meropenem (if ESBL or critically ill)  

**Key principle**  
If not improving → **drain or OR**, not "stronger antibiotics."

**Source control vs antibiotics**  
Antibiotics cannot overcome:  
• An undrained abscess  
• A perforated bowel without surgery  
• Necrotic tissue without debridement
""",
                lineSpacing: 6
            )
            
            // UTI / Pyelonephritis
            contentCard(
                title: "UTI / Pyelonephritis",
                icon: "drop.fill",
                iconColor: .yellow,
                content: """
**Uncomplicated lower UTI**  
• Nitrofurantoin (not for pyelonephritis or sepsis)  

**Pyelonephritis / urosepsis**  
• Ceftriaxone  
• Ciprofloxacin  
• Cefepime or Zosyn (if recent healthcare or MDR risk)  

**Important:** Stone + infection = urgent decompression.
""",
                lineSpacing: 6
            )
            
            // Skin & Necrotizing
            contentCard(
                title: "Skin & Necrotizing Infections",
                icon: "bandage.fill",
                iconColor: .pink,
                content: """
**Non-purulent cellulitis**  
• Cefazolin  

**MRSA risk or purulence**  
• Vancomycin  
• Linezolid  
• Daptomycin  

**Necrotizing infection**  
• Broad regimen: Meropenem or Zosyn  
• Plus MRSA agent  
• Plus clindamycin (toxin suppression)  
• Plus **SURGERY**
""",
                lineSpacing: 6
            )
            
            // Bacteremia / Endocarditis
            contentCard(
                title: "Bacteremia / Endocarditis",
                icon: "heart.fill",
                iconColor: .red,
                content: """
**MRSA bacteremia**  
• Vancomycin (dose properly)  
• Daptomycin if vanc fails or kidneys bad  
• Avoid linezolid for high-burden bacteremia  

**VRE**  
• Linezolid  
• High-dose daptomycin  

**Persistent bacteremia**  
Think **source**, not "stronger drug."
""",
                lineSpacing: 6
            )
        }
    }
    
    // MARK: - Dangers Content
    private var dangersContent: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Danger Pairs — structured for readability
            contentCard(
                title: "High-Yield Danger Pairs",
                icon: "exclamationmark.triangle.fill",
                iconColor: .red,
                content: """
• **Cefepime + renal failure (no dose adjustment)**  
  Encephalopathy and seizure risk. Adjust dose or switch.

• **Vancomycin + Piperacillin–Tazobactam**  
  Significantly higher AKI risk. Avoid or limit duration if alternatives exist.

• **Daptomycin for pneumonia**  
  Ineffective — inactivated by surfactant. Do not use.

• **Linezolid + SSRI / SNRI / MAOI**  
  Serotonin syndrome risk. Screen medication list before starting.
""",
                lineSpacing: 8
            )
            
            // Red Flags — structured for readability
            contentCard(
                title: "Red Flags You Must Recognize",
                icon: "flag.fill",
                iconColor: .orange,
                content: """
• **Cefepime or meropenem + AKI**  
  Watch for encephalopathy.

• **Vancomycin + Zosyn**  
  Watch for rising creatinine.

• **Linezolid**  
  Falling platelets, rising lactate.

• **Daptomycin**  
  Muscle pain, high CPK, eosinophilic pneumonia.

• **Persistent bacteremia**  
  Think source control, not "stronger drug."
""",
                lineSpacing: 8
            )
            
            // Stewardship Loop
            contentCard(
                title: "The 24-72 Hour Stewardship Loop",
                icon: "clock.arrow.circlepath",
                iconColor: .blue,
                content: """
**At 24 hours**
• Cultures drawn?
• GPC vs GNR?
• Source controlled?
• Still septic?

**At 48–72 hours**
• Stop MRSA coverage if ruled out.
• De-escalate carbapenems / Zosyn / cefepime.
• Define syndrome.
• Set duration.

**Failure pattern**  
Broad therapy started correctly but never narrowed → AKI, C. diff, resistance.
""",
                lineSpacing: 6
            )
            
            // Daily Checklist
            contentCard(
                title: "Daily Stewardship Checklist",
                icon: "checklist",
                iconColor: .green,
                content: """
• **"Does this patient still need MRSA/VRE coverage?"**  
  Consider stopping vanc/linezolid/dapto once ruled out.

• **"Can I narrow based on cultures or risk profile?"**  
  Step down from carbapenem/Zosyn/cefepime when possible.

• **"Have kidneys or CPK changed?"**  
  Watch SCr with vanc/aminoglycosides/Zosyn; CPK with daptomycin; CBC with linezolid.
""",
                lineSpacing: 8
            )
        }
    }
    
    // MARK: - Reference Content
    private var referenceContent: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            // Quick Reference Table
            contentCard(
                title: "ICU Antibiotic Cheat Codes",
                icon: "tablecells.fill",
                iconColor: .blue,
                content: """
• **Ceftriaxone** — Community GN, CAP, meningitis; no Pseudomonas.

• **Cefepime** — Pseudomonas; renal failure → neurotoxicity.

• **Zosyn** — Broad GN + anaerobes; AKI risk with vanc.

• **Meropenem** — ESBL + Pseudomonas + anaerobes; renal → seizures.

• **Vancomycin** — MRSA; AUC-guided dosing.

• **Linezolid** — MRSA/VRE lungs; platelets, serotonin, lactate.

• **Daptomycin** — MRSA/VRE blood; NOT lungs; monitor CPK.

• **Gentamicin** — GN punch; nephro/ototoxic.
""",
                lineSpacing: 6
            )
            
            // PK/PD
            contentCard(
                title: "PK/PD That Actually Matters",
                icon: "chart.line.uptrend.xyaxis",
                iconColor: .purple,
                content: """
**Time-dependent killers (β-lactams)**  
Penicillins, cephalosporins, carbapenems.  
• Work when levels stay above MIC.  
• Extended or continuous infusion helps in shock.  

**Concentration-dependent killers**  
Aminoglycosides, daptomycin.  
• Work when peak >> MIC.  
• Avoid small repeated doses.  

**Renal-cleared and dose-critical**  
Cefepime, Zosyn, gentamicin, vancomycin, daptomycin, meropenem.  
• Must adjust in AKI/CKD/CRRT.
""",
                lineSpacing: 6
            )
            
            // Final Truth
            contentCard(
                title: "The Clinical Takeaway",
                icon: "star.fill",
                iconColor: .yellow,
                content: """
ICU antibiotics are not about memorizing drugs. They are about:

• **Covering the right biology early**
• **Dosing to physiology**
• **Controlling the source**
• **Narrowing fast**

If you do those four things well, you will be aggressive and safe — and that's what real critical care looks like.
""",
                lineSpacing: 6
            )
            
            // Link to Drug Reference
            NavigationLink(destination: ClinicalPharmacologyView(isCardView: .constant(true))) {
                HStack {
                    Image(systemName: "pills.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("View All Antibiotics")
                            .font(.custom("SF-Pro-Rounded-Semibold", size: 16))
                            .foregroundColor(.white)
                        Text("Full drug details in Clinical Pharmacology")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [CriticalDesign.Colors.cardBlue, CriticalDesign.Colors.cardBlue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: CriticalDesign.Colors.cardBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    // MARK: - Content Card
    @available(iOS 13.0, *)
    private func contentCard(title: String, icon: String, iconColor: Color, content: String, lineSpacing: CGFloat = 4) -> some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            HStack(spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.custom("SF-Pro-Rounded-Semibold", size: 18))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }

            if let attributedContent = try? AttributedString(markdown: content) {
                Text(attributedContent)
                    .font(.custom("SF-Pro-Text-Regular", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(lineSpacing)
            } else {
                Text(content)
                    .font(.custom("SF-Pro-Text-Regular", size: 15))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    .lineSpacing(lineSpacing)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [CriticalDesign.Colors.gold.opacity(0.5), CriticalDesign.Colors.gold.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                } else {
                    LinearGradient(
                        colors: [Color.white, Color(UIColor.systemGray6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
        )
        .cornerRadius(16)
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
        .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
        .overlay(
            Group {
                if colorScheme == .light {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            }
        )
    }
    
    // MARK: - Expandable Card
    @available(iOS 13.0, *)
    private func expandableCard(id: String, title: String, subtitle: String, icon: String, iconColor: Color, content: String, lineSpacing: CGFloat = 6) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    if expandedCards.contains(id) {
                        expandedCards.remove(id)
                    } else {
                        expandedCards.insert(id)
                    }
                }
            }) {
                HStack(spacing: CriticalDesign.Spacing.sm) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(iconColor)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.custom("SF-Pro-Rounded-Semibold", size: 18))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                    }

                    Spacer()

                    Image(systemName: expandedCards.contains(id) ? "chevron.up" : "chevron.down")
                        .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                        .font(.caption)
                }
                .padding()
            }

            if expandedCards.contains(id) {
                Divider()
                    .padding(.horizontal)

                if let attributedContent = try? AttributedString(markdown: content) {
                    Text(attributedContent)
                        .font(.custom("SF-Pro-Text-Regular", size: 15))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .lineSpacing(lineSpacing)
                        .padding()
                } else {
                    Text(content)
                        .font(.custom("SF-Pro-Text-Regular", size: 15))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .lineSpacing(lineSpacing)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [CriticalDesign.Colors.gold.opacity(0.5), CriticalDesign.Colors.gold.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                } else {
                    LinearGradient(
                        colors: [Color.white, Color(UIColor.systemGray6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
        )
        .cornerRadius(16)
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
        .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
        .overlay(
            Group {
                if colorScheme == .light {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            }
        )
    }
    
    // MARK: - Branding Card
    private var brandingCard: some View {
        HStack(alignment: .center, spacing: CriticalDesign.Spacing.md) {
            Image("LogoMonogram")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("ICU Antibiotics Masterclass")
                    .font(.custom("SF-Pro-Rounded-Semibold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))

                Text("Evidence-based • Clinical Decision Support")
                    .font(.caption)
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            
            Spacer()
        }
        .padding()
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(CriticalDesign.Colors.cardBlue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [CriticalDesign.Colors.gold.opacity(0.6), CriticalDesign.Colors.goldMid.opacity(0.4), CriticalDesign.Colors.gold.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                } else {
                    LinearGradient(
                        colors: [Color.white, Color(UIColor.systemGray6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
            }
        )
        .cornerRadius(16)
        .shadow(color: colorScheme == .dark ? CriticalDesign.Colors.darkCanvas.opacity(0.3) : Color.black.opacity(0.12), radius: 10, x: 5, y: 5)
        .shadow(color: colorScheme == .dark ? Color.clear : Color.white.opacity(0.95), radius: 10, x: -5, y: -5)
        .overlay(
            Group {
                if colorScheme == .light {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(hex: "D9A64D"),
                                    Color(hex: "F2CC73"),
                                    Color(hex: "D9A64D")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                }
            }
        )
    }
}

// MARK: - Preview
struct AntibioticsMasterclassView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AntibioticsMasterclassView()
            }
            .preferredColorScheme(.light)
            NavigationView {
                AntibioticsMasterclassView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
