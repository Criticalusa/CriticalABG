//
//  RoleMedicationContent.swift
//  CriticalX
//
//  Practice Focus-specific medication content
//  Provides tips, warnings, and emphasis based on operational context
//  Stabilize = initial stabilization, transport
//  Monitor = titration, documentation, watching for changes
//  Manage = clinical decisions, treatment adjustments
//

import Foundation
import SwiftUI

// MARK: - Role Medication Content
/// Provides role-specific tips and content for medications
struct RoleMedicationContent {
    
    // MARK: - Text Cleaning Utilities
    
    /// Removes text bullet characters from content when visual bullets are being used
    /// Strips: •, -, *, and leading whitespace after these characters
    static func stripTextBullets(_ text: String) -> String {
        var result = text
        
        // Remove bullet point characters at start of lines
        let bulletPatterns = ["• ", "- ", "* ", "· ", "→ ", "‣ "]
        for pattern in bulletPatterns {
            result = result.replacingOccurrences(of: "\n" + pattern, with: "\n")
            if result.hasPrefix(pattern) {
                result = String(result.dropFirst(pattern.count))
            }
        }
        
        // Also handle bullets without space
        let bulletCharsOnly = ["•", "·", "‣"]
        for char in bulletCharsOnly {
            result = result.replacingOccurrences(of: "\n" + char, with: "\n")
            if result.hasPrefix(char) {
                result = String(result.dropFirst(1)).trimmingCharacters(in: .whitespaces)
            }
        }
        
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Role-Specific Tips by Drug Class
    
    /// Get role-specific tips for a medication class
    static func tips(for drugClass: MedicationClass, role: ClinicalRole) -> [RoleTip] {
        switch drugClass {
        case .vasopressor:
            return vasopressorTips(for: role)
        case .sedative:
            return sedativeTips(for: role)
        case .analgesic:
            return analgesicTips(for: role)
        case .paralytic:
            return paralyticTips(for: role)
        case .antibiotic:
            return antibioticTips(for: role)
        case .antiarrhythmic:
            return antiarrhythmicTips(for: role)
        case .anticoagulant:
            return anticoagulantTips(for: role)
        case .electrolyte:
            return electrolyteTips(for: role)
        case .bronchodilator:
            return bronchodilatorTips(for: role)
        case .steroid:
            return steroidTips(for: role)
        case .reversal:
            return reversalTips(for: role)
        case .induction:
            return inductionTips(for: role)
        case .resuscitation:
            return resuscitationTips(for: role)
        case .diuretic:
            return diureticTips(for: role)
        case .antihypertensive:
            return antihypertensiveTips(for: role)
        case .other:
            return generalTips(for: role)
        }
    }
    
    // MARK: - Vasopressor Tips
    
    private static func vasopressorTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "arrow.up.arrow.down",
                    title: "Titration",
                    content: "Titrate to MAP goal (usually 65+). Document BP q5min during uptitration.",
                    priority: .high
                ),
                RoleTip(
                    icon: "point.topleft.down.curvedto.point.bottomright.up",
                    title: "Line Check",
                    content: "Verify central line placement. Peripheral use is temporary only.",
                    priority: .high
                ),
                RoleTip(
                    icon: "bell.fill",
                    title: "Escalation",
                    content: "Notify MD if requiring >0.2 mcg/kg/min (or >15-20 mcg/min fixed rate) or adding second pressor.",
                    priority: .medium
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "syringe.fill",
                    title: "Push-Dose Option",
                    content: "Push-dose epi: 10-20 mcg q2-5min for bridge to infusion.",
                    priority: .high
                ),
                RoleTip(
                    icon: "car.fill",
                    title: "Transport",
                    content: "Secure IV/IO access. Have push-dose ready for BP drops en route.",
                    priority: .high
                ),
                RoleTip(
                    icon: "arrow.triangle.branch",
                    title: "Reversible Causes",
                    content: "Address tension PTX, hypovolemia before starting pressors.",
                    priority: .medium
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "list.bullet.clipboard",
                    title: "Differential",
                    content: "Consider cardiogenic vs distributive. Echo early if uncertain.",
                    priority: .high
                ),
                RoleTip(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Thresholds",
                    content: "Norepinephrine >0.2 mcg/kg/min (or >20 mcg/min fixed): add vasopressin 0.03 U/min or stress-dose steroids.",
                    priority: .high
                ),
                RoleTip(
                    icon: "arrow.up.right",
                    title: "Escalation",
                    content: "Refractory shock at >0.5 mcg/kg/min: reassess volume, source, consider ECMO consult.",
                    priority: .medium
                )
            ]
        }
    }
    
    // MARK: - Sedative Tips
    
    private static func sedativeTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "gauge",
                    title: "RASS Target",
                    content: "Target RASS 0 to -2 unless deep sedation indicated. Assess q4h.",
                    priority: .high
                ),
                RoleTip(
                    icon: "exclamationmark.triangle",
                    title: "Hypotension Risk",
                    content: "Monitor BP closely with propofol. May need pressor adjustment.",
                    priority: .high
                ),
                RoleTip(
                    icon: "clock",
                    title: "Daily Awakening",
                    content: "Coordinate sedation vacation with RT and MD. Document neuro exam.",
                    priority: .medium
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "lungs.fill",
                    title: "Airway First",
                    content: "Ensure airway is secured before deep sedation. Have BVM ready.",
                    priority: .high
                ),
                RoleTip(
                    icon: "drop.fill",
                    title: "Hypotension",
                    content: "Push-dose epi at bedside. Sedatives drop BP, especially in hypovolemia.",
                    priority: .high
                ),
                RoleTip(
                    icon: "car.fill",
                    title: "Transport",
                    content: "Have paralytic ready if patient bucks vent. Monitor EtCO2.",
                    priority: .medium
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "brain.head.profile",
                    title: "Delirium Risk",
                    content: "Dexmedetomidine preferred for delirium-prone patients. Avoid benzos.",
                    priority: .high
                ),
                RoleTip(
                    icon: "waveform.path.ecg",
                    title: "Propofol Syndrome",
                    content: "Limit propofol to <5mg/kg/hr. Monitor triglycerides, CK, lactate.",
                    priority: .medium
                ),
                RoleTip(
                    icon: "arrow.triangle.branch",
                    title: "Differential",
                    content: "Agitation DDx: pain, hypoxia, full bladder, delirium, withdrawal.",
                    priority: .medium
                )
            ]
        }
    }
    
    // MARK: - Analgesic Tips
    
    private static func analgesicTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "chart.bar",
                    title: "Pain Scale",
                    content: "Use CPOT for intubated patients. Document before and after dosing.",
                    priority: .high
                ),
                RoleTip(
                    icon: "lungs",
                    title: "Respiratory",
                    content: "Monitor RR and SpO2. Have naloxone accessible for over-sedation.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "syringe.fill",
                    title: "Titrate Carefully",
                    content: "Start low, go slow. Fentanyl 25-50mcg increments in elderly.",
                    priority: .high
                ),
                RoleTip(
                    icon: "exclamationmark.triangle",
                    title: "Airway",
                    content: "Ensure airway equipment ready. Narcotics can cause apnea.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "pills",
                    title: "Multimodal",
                    content: "Consider ketamine, acetaminophen, regional blocks to reduce opioid load.",
                    priority: .high
                ),
                RoleTip(
                    icon: "arrow.triangle.branch",
                    title: "Ceiling Effect",
                    content: "If pain uncontrolled at max dose, reassess source, not just dose.",
                    priority: .medium
                )
            ]
        }
    }
    
    // MARK: - Paralytic Tips
    
    private static func paralyticTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "exclamationmark.octagon",
                    title: "Sedation First",
                    content: "NEVER paralyze without adequate sedation. Patient is aware but can't move.",
                    priority: .critical
                ),
                RoleTip(
                    icon: "eye",
                    title: "Eye Care",
                    content: "Tape eyes closed, apply lubricant q4h. Paralysis prevents blinking.",
                    priority: .high
                ),
                RoleTip(
                    icon: "waveform",
                    title: "Train of Four",
                    content: "Monitor TOF if on continuous paralysis. Target 1-2 twitches.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "lungs.fill",
                    title: "BVM Ready",
                    content: "Once paralyzed, patient cannot breathe. Bag until tube confirmed.",
                    priority: .critical
                ),
                RoleTip(
                    icon: "clock",
                    title: "Duration",
                    content: "Succinylcholine: 5-10 min. Rocuronium: 30-60 min. Plan accordingly.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "bolt.fill",
                    title: "Succinylcholine Caution",
                    content: "Avoid in burns >24h, crush injuries, hyperkalemia, neuromuscular disease.",
                    priority: .critical
                ),
                RoleTip(
                    icon: "arrow.uturn.backward",
                    title: "Reversal",
                    content: "Sugammadex 16mg/kg reverses rocuronium immediately if needed.",
                    priority: .high
                )
            ]
        }
    }
    
    // MARK: - Antibiotic Tips
    
    private static func antibioticTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "clock",
                    title: "Time Critical",
                    content: "Sepsis: Give within 1 hour of recognition. Document time given.",
                    priority: .high
                ),
                RoleTip(
                    icon: "drop.triangle",
                    title: "Allergy Check",
                    content: "Verify allergies before administration. Cross-reactivity with PCN.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "clock.arrow.circlepath",
                    title: "Early Administration",
                    content: "If sepsis suspected, don't delay for cultures. Time to antibiotics matters.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "target",
                    title: "Source Control",
                    content: "Antibiotics alone won't fix undrained abscess or necrotic tissue.",
                    priority: .high
                ),
                RoleTip(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Dosing",
                    content: "Consider loading doses in sepsis. Vd is increased.",
                    priority: .medium
                )
            ]
        }
    }
    
    // MARK: - Antiarrhythmic Tips
    
    private static func antiarrhythmicTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "waveform.path.ecg",
                    title: "Monitor",
                    content: "Continuous ECG monitoring required. Watch for QT prolongation.",
                    priority: .high
                ),
                RoleTip(
                    icon: "drop.fill",
                    title: "IV Compatibility",
                    content: "Amiodarone needs dedicated line. Precipitates with many drugs.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "bolt.heart",
                    title: "Unstable = Shock",
                    content: "If unstable tachyarrhythmia, cardiovert don't medicate.",
                    priority: .critical
                ),
                RoleTip(
                    icon: "syringe.fill",
                    title: "Adenosine",
                    content: "Push fast, follow with flush. Have pads on before giving.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "arrow.triangle.branch",
                    title: "Rate vs Rhythm",
                    content: "Decide: rate control vs rhythm control. Address underlying cause.",
                    priority: .high
                ),
                RoleTip(
                    icon: "exclamationmark.triangle",
                    title: "Pro-arrhythmic",
                    content: "All antiarrhythmics can cause arrhythmias. Start low, go slow.",
                    priority: .medium
                )
            ]
        }
    }
    
    // MARK: - Anticoagulant Tips
    
    private static func anticoagulantTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "drop.fill",
                    title: "Bleeding Watch",
                    content: "Monitor for bleeding: gums, IV sites, urine, stool. Document.",
                    priority: .high
                ),
                RoleTip(
                    icon: "clock",
                    title: "Lab Monitoring",
                    content: "Check PTT q6h for heparin. Notify if outside therapeutic range.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "exclamationmark.triangle",
                    title: "Trauma Risk",
                    content: "Anticoagulated patients bleed more. Apply firm pressure, expect more bleeding.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "arrow.uturn.backward",
                    title: "Reversal",
                    content: "Know reversal agents: protamine for heparin, vitamin K/FFP/PCC for warfarin, idarucizumab for dabigatran.",
                    priority: .high
                ),
                RoleTip(
                    icon: "scalemass",
                    title: "Risk/Benefit",
                    content: "Balance bleed risk vs clot risk. Document rationale for anticoagulation intensity.",
                    priority: .medium
                )
            ]
        }
    }
    
    // MARK: - Electrolyte Tips
    
    private static func electrolyteTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "waveform.path.ecg",
                    title: "Cardiac Monitor",
                    content: "K+ replacement requires cardiac monitoring. Watch for arrhythmias.",
                    priority: .high
                ),
                RoleTip(
                    icon: "flame",
                    title: "Peripheral IV",
                    content: "KCl >10 mEq/hr via peripheral causes burning. Dilute appropriately.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "waveform.path.ecg",
                    title: "ECG First",
                    content: "Hyperkalemia: Look for peaked T waves, widened QRS. Give calcium first.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "magnifyingglass",
                    title: "Find the Cause",
                    content: "Replacing electrolytes without addressing cause = refilling a leaky bucket.",
                    priority: .high
                ),
                RoleTip(
                    icon: "arrow.triangle.2.circlepath",
                    title: "Mg Before K",
                    content: "Hypomagnesemia causes refractory hypokalemia. Replete Mg first.",
                    priority: .medium
                )
            ]
        }
    }
    
    // MARK: - Bronchodilator Tips
    
    private static func bronchodilatorTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "lungs.fill",
                    title: "Response",
                    content: "Assess breath sounds before and after treatment. Document improvement.",
                    priority: .high
                ),
                RoleTip(
                    icon: "heart.fill",
                    title: "Heart Rate",
                    content: "Albuterol causes tachycardia. Monitor HR, especially in cardiac patients.",
                    priority: .medium
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "wind",
                    title: "Continuous Nebs",
                    content: "Severe asthma: continuous nebulization. Don't wait between treatments.",
                    priority: .high
                ),
                RoleTip(
                    icon: "syringe.fill",
                    title: "IM Epinephrine",
                    content: "If severe and not responding, IM epi 0.3mg may be needed.",
                    priority: .medium
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "chart.line.downtrend.xyaxis",
                    title: "Silent Chest",
                    content: "No wheezing may mean no airflow. Prepare for intubation.",
                    priority: .critical
                ),
                RoleTip(
                    icon: "pills.fill",
                    title: "Magnesium",
                    content: "Refractory asthma: IV magnesium 2g can help bronchodilation.",
                    priority: .medium
                )
            ]
        }
    }
    
    // MARK: - Steroid Tips
    
    private static func steroidTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "drop.fill",
                    title: "Blood Glucose",
                    content: "Steroids cause hyperglycemia. Monitor glucose closely.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "clock",
                    title: "Onset Delay",
                    content: "Steroids take 4-6 hours to work. Don't expect immediate improvement.",
                    priority: .medium
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "arrow.down.heart",
                    title: "Stress Dose",
                    content: "Chronic steroid users need stress-dose steroids in illness/surgery.",
                    priority: .high
                )
            ]
        }
    }
    
    // MARK: - Reversal Tips
    
    private static func reversalTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "arrow.clockwise",
                    title: "Re-sedation",
                    content: "Naloxone wears off faster than opioids. Watch for re-sedation.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "syringe.fill",
                    title: "Titrate",
                    content: "Goal: respiratory drive, not full alertness. Titrate to RR >12.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "clock.arrow.circlepath",
                    title: "Duration Mismatch",
                    content: "Reversal agent duration < drug duration. Plan for redosing or infusion.",
                    priority: .high
                )
            ]
        }
    }
    
    // MARK: - Induction Tips
    
    private static func inductionTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "lungs.fill",
                    title: "Prepare",
                    content: "Have suction, BVM, ETT, and backup airway ready before induction.",
                    priority: .critical
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "arrow.down.heart",
                    title: "Hemodynamics",
                    content: "Push-dose pressor ready. Most induction agents drop BP.",
                    priority: .high
                ),
                RoleTip(
                    icon: "brain",
                    title: "Ketamine",
                    content: "Ketamine maintains BP - preferred in hypotensive patients.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "exclamationmark.triangle",
                    title: "Aspiration Risk",
                    content: "NPO status, full stomach, pregnancy = RSI. No positive pressure until tube confirmed.",
                    priority: .critical
                )
            ]
        }
    }
    
    // MARK: - Resuscitation Tips
    
    private static func resuscitationTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "clock",
                    title: "Time",
                    content: "Note code start time. Epi q3-5 min. 2025: Vasopressin NOT recommended.",
                    priority: .critical
                ),
                RoleTip(
                    icon: "person.2.fill",
                    title: "Rotate",
                    content: "High-quality CPR requires rotation every 2 minutes.",
                    priority: .high
                ),
                RoleTip(
                    icon: "pills.fill",
                    title: "Medications",
                    content: "2025: Sotalol REMOVED. Routine bicarb NOT recommended. Amiodarone/lidocaine OK.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "hand.raised.fill",
                    title: "Compressions",
                    content: "Push hard (2 in), push fast (100-120/min), full recoil, minimize interruptions.",
                    priority: .critical
                ),
                RoleTip(
                    icon: "bolt.heart",
                    title: "Early Defib",
                    content: "2025: First shock ≥200J. Shockable rhythm = shock immediately. Epi after failed defib.",
                    priority: .critical
                ),
                RoleTip(
                    icon: "lungs.fill",
                    title: "Ventilation",
                    content: "2025: Begin bag-mask + O₂. Continuous waveform capnography for CPR quality.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "arrow.triangle.branch",
                    title: "Reversible Causes",
                    content: "2025: H's/T's no longer explicit in algorithm—consider continuously throughout.",
                    priority: .critical
                ),
                RoleTip(
                    icon: "clock.badge.checkmark",
                    title: "Prognostication",
                    content: "2025: Don't use EtCO₂ alone for termination. Consider duration, rhythm, multiple factors.",
                    priority: .high
                ),
                RoleTip(
                    icon: "thermometer.medium",
                    title: "TTM",
                    content: "2025: Target 32°C–37.5°C (widened from ≤36°C). MAP ≥65 (SBP removed).",
                    priority: .high
                )
            ]
        }
    }
    
    // MARK: - Diuretic Tips
    
    private static func diureticTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "drop.fill",
                    title: "I/O Monitoring",
                    content: "Strict I/O. Foley for accurate output measurement if high doses.",
                    priority: .high
                ),
                RoleTip(
                    icon: "bolt",
                    title: "Electrolytes",
                    content: "Monitor K+, Mg++. Loop diuretics cause significant losses.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "lungs",
                    title: "Flash Pulmonary Edema",
                    content: "Furosemide + nitroglycerin + positioning. Keep upright if possible.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "gauge",
                    title: "Resistance",
                    content: "Diuretic resistance: consider bolus + drip, add thiazide, or ultrafiltration.",
                    priority: .high
                )
            ]
        }
    }
    
    // MARK: - Antihypertensive Tips
    
    private static func antihypertensiveTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "chart.line.downtrend.xyaxis",
                    title: "Target",
                    content: "Clarify BP target with MD. Don't over-shoot - rapid drops cause harm.",
                    priority: .high
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "brain",
                    title: "Stroke Protocol",
                    content: "Permissive hypertension in stroke unless thrombolysis planned.",
                    priority: .high
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "target",
                    title: "End-Organ",
                    content: "Treat based on end-organ damage, not the number. Aortic dissection vs ACS vs stroke = different targets.",
                    priority: .critical
                )
            ]
        }
    }
    
    // MARK: - General Tips
    
    private static func generalTips(for role: ClinicalRole) -> [RoleTip] {
        switch role.medicationFocusStyle {
        case .monitor:
            return [
                RoleTip(
                    icon: "doc.text",
                    title: "Documentation",
                    content: "Document indication, dose, route, time, and patient response.",
                    priority: .medium
                )
            ]
        case .stabilize:
            return [
                RoleTip(
                    icon: "doc.text",
                    title: "Handoff",
                    content: "Report all medications given, times, and response to receiving team.",
                    priority: .medium
                )
            ]
        case .manage:
            return [
                RoleTip(
                    icon: "arrow.triangle.branch",
                    title: "Indication",
                    content: "Document indication and expected outcome for all medication orders.",
                    priority: .medium
                )
            ]
        }
    }
}

// MARK: - Role Tip Model
/// Individual tip for a role
struct RoleTip: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let content: String
    let priority: TipPriority
    
    enum TipPriority: Int, Comparable {
        case low = 0
        case medium = 1
        case high = 2
        case critical = 3
        
        static func < (lhs: TipPriority, rhs: TipPriority) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        var color: Color {
            switch self {
            case .low: return .gray
            case .medium: return .blue
            case .high: return .orange
            case .critical: return .red
            }
        }
        
        var icon: String {
            switch self {
            case .low: return "info.circle"
            case .medium: return "exclamationmark.circle"
            case .high: return "exclamationmark.triangle"
            case .critical: return "exclamationmark.octagon.fill"
            }
        }
    }
}

// MARK: - Drug Class Detection
/// Maps medication names to drug classes
/// IMPORTANT: Prefer using classifyFromDrugClassField() which uses the actual medication data
struct DrugClassifier {
    
    /// Classify a medication using its actual DrugClass field from ClinicalPharmacologyDataModel
    /// This is the preferred method as it uses the actual medication data
    static func classifyFromDrugClassField(_ drugClassField: String) -> MedicationClass {
        let lowercased = drugClassField.lowercased()
        
        // Check for vasopressor keywords
        if lowercased.contains("vasopressor") || lowercased.contains("catecholamine") ||
           lowercased.contains("sympathomimetic") || lowercased.contains("alpha-1 agonist") ||
           lowercased.contains("alpha agonist") {
            return .vasopressor
        }
        
        // Check for sedative keywords
        if lowercased.contains("sedative") || lowercased.contains("hypnotic") ||
           lowercased.contains("benzodiazepine") || lowercased.contains("gaba agonist") {
            return .sedative
        }
        
        // Check for analgesic keywords
        if lowercased.contains("opioid") || lowercased.contains("analgesic") ||
           lowercased.contains("narcotic") || lowercased.contains("pain") {
            return .analgesic
        }
        
        // Check for paralytic keywords
        if lowercased.contains("neuromuscular") || lowercased.contains("paralytic") ||
           lowercased.contains("muscle relaxant") || lowercased.contains("blocking agent") {
            return .paralytic
        }
        
        // Check for antibiotic keywords
        if lowercased.contains("antibiotic") || lowercased.contains("antimicrobial") ||
           lowercased.contains("cephalosporin") || lowercased.contains("penicillin") ||
           lowercased.contains("carbapenem") || lowercased.contains("fluoroquinolone") ||
           lowercased.contains("glycopeptide") || lowercased.contains("lipopeptide") ||
           lowercased.contains("macrolide") {
            return .antibiotic
        }
        
        // Check for antiarrhythmic keywords
        if lowercased.contains("antiarrhythmic") || lowercased.contains("class i") ||
           lowercased.contains("class ii") || lowercased.contains("class iii") ||
           lowercased.contains("class iv") {
            return .antiarrhythmic
        }
        
        // Check for anticoagulant keywords
        if lowercased.contains("anticoagulant") || lowercased.contains("thrombin") ||
           lowercased.contains("heparin") || lowercased.contains("factor xa") {
            return .anticoagulant
        }
        
        // Check for electrolyte keywords
        if lowercased.contains("electrolyte") || lowercased.contains("mineral") ||
           lowercased.contains("calcium") || lowercased.contains("potassium") ||
           lowercased.contains("magnesium") || lowercased.contains("sodium") {
            return .electrolyte
        }
        
        // Check for bronchodilator keywords
        if lowercased.contains("bronchodilator") || lowercased.contains("β2") ||
           lowercased.contains("beta-2") || lowercased.contains("beta2") ||
           lowercased.contains("saba") || lowercased.contains("laba") {
            return .bronchodilator
        }
        
        // Check for steroid keywords
        if lowercased.contains("steroid") || lowercased.contains("corticosteroid") ||
           lowercased.contains("glucocorticoid") {
            return .steroid
        }
        
        // Check for reversal agent keywords
        if lowercased.contains("reversal") || lowercased.contains("antagonist") ||
           lowercased.contains("antidote") {
            return .reversal
        }
        
        // Check for induction keywords
        if lowercased.contains("induction") || lowercased.contains("anesthetic") ||
           lowercased.contains("dissociative") {
            return .induction
        }
        
        // Check for resuscitation keywords
        if lowercased.contains("resuscitation") || lowercased.contains("anticholinergic") {
            return .resuscitation
        }
        
        // Check for diuretic keywords
        if lowercased.contains("diuretic") || lowercased.contains("loop diuretic") {
            return .diuretic
        }
        
        // Check for antihypertensive keywords
        if lowercased.contains("antihypertensive") || lowercased.contains("calcium channel blocker") ||
           lowercased.contains("beta blocker") || lowercased.contains("β blocker") {
            return .antihypertensive
        }
        
        return .other
    }
    
    /// Classify a medication by looking it up in the database first
    /// Falls back to name-based classification if not found
    static func classifyFromMedication(_ medication: ClinicalPharmacologyDataModel) -> MedicationClass {
        let drugClassField = medication.clinicalPharmaDetails.DrugClass
        if !drugClassField.isEmpty {
            return classifyFromDrugClassField(drugClassField)
        }
        // Fallback to name-based classification
        return classify(medication.title)
    }
    
    /// Common mappings of drug names to their classes (fallback method)
    private static let drugClassMap: [String: MedicationClass] = [
        // Vasopressors
        "norepinephrine": .vasopressor,
        "levophed": .vasopressor,
        "epinephrine": .vasopressor,
        "vasopressin": .vasopressor,
        "pitressin": .vasopressor,
        "dopamine": .vasopressor,
        "phenylephrine": .vasopressor,
        "neo-synephrine": .vasopressor,
        "dobutamine": .vasopressor,
        
        // Sedatives
        "propofol": .sedative,
        "diprivan": .sedative,
        "midazolam": .sedative,
        "versed": .sedative,
        "lorazepam": .sedative,
        "ativan": .sedative,
        "dexmedetomidine": .sedative,
        "precedex": .sedative,
        "diazepam": .sedative,
        "valium": .sedative,
        
        // Induction
        "ketamine": .induction,

        // Analgesics
        "fentanyl": .analgesic,
        "morphine": .analgesic,
        "hydromorphone": .analgesic,
        "dilaudid": .analgesic,
        
        // Paralytics
        "rocuronium": .paralytic,
        "zemuron": .paralytic,
        "vecuronium": .paralytic,
        "norcuron": .paralytic,
        "succinylcholine": .paralytic,
        "anectine": .paralytic,
        "cisatracurium": .paralytic,
        "nimbex": .paralytic,
        
        // Antibiotics
        "vancomycin": .antibiotic,
        "piperacillin": .antibiotic,
        "zosyn": .antibiotic,
        "ceftriaxone": .antibiotic,
        "rocephin": .antibiotic,
        "cefepime": .antibiotic,
        "maxipime": .antibiotic,
        "meropenem": .antibiotic,
        "merrem": .antibiotic,
        "azithromycin": .antibiotic,
        "zithromax": .antibiotic,
        "ciprofloxacin": .antibiotic,
        "cipro": .antibiotic,
        "metronidazole": .antibiotic,
        "flagyl": .antibiotic,
        "ampicillin": .antibiotic,
        "unasyn": .antibiotic,
        "cefazolin": .antibiotic,
        "ancef": .antibiotic,
        "daptomycin": .antibiotic,
        "cubicin": .antibiotic,
        
        // Bronchodilators
        "albuterol": .bronchodilator,
        "proventil": .bronchodilator,
        "ventolin": .bronchodilator,
        "levalbuterol": .bronchodilator,
        "xoponex": .bronchodilator,
        "ipratropium": .bronchodilator,
        "atrovent": .bronchodilator,
        "duoneb": .bronchodilator,
        
        // Antiarrhythmics
        "amiodarone": .antiarrhythmic,
        "cordarone": .antiarrhythmic,
        "adenosine": .antiarrhythmic,
        "adenocard": .antiarrhythmic,
        "lidocaine": .antiarrhythmic,
        "xylocaine": .antiarrhythmic,
        "diltiazem": .antiarrhythmic,
        "cardizem": .antiarrhythmic,
        "metoprolol": .antiarrhythmic,
        "lopressor": .antiarrhythmic,
        "esmolol": .antiarrhythmic,
        "brevibloc": .antiarrhythmic,
        "atenolol": .antiarrhythmic,
        
        // Anticoagulants
        "heparin": .anticoagulant,
        "enoxaparin": .anticoagulant,
        "lovenox": .anticoagulant,
        "warfarin": .anticoagulant,
        "coumadin": .anticoagulant,
        
        // Electrolytes
        "potassium": .electrolyte,
        "magnesium": .electrolyte,
        "calcium chloride": .electrolyte,
        "calcium gluconate": .electrolyte,
        "sodium bicarbonate": .electrolyte,
        
        // Steroids
        "methylprednisolone": .steroid,
        "solumedrol": .steroid,
        "dexamethasone": .steroid,
        "decadron": .steroid,
        "hydrocortisone": .steroid,
        "solu-cortef": .steroid,
        "prednisone": .steroid,
        
        // Reversal Agents
        "naloxone": .reversal,
        "narcan": .reversal,
        "flumazenil": .reversal,
        "romazicon": .reversal,
        "sugammadex": .reversal,
        "bridion": .reversal,
        "neostigmine": .reversal,
        
        // Induction Agents
        "etomidate": .induction,
        "amidate": .induction,
        
        // Resuscitation
        "atropine": .resuscitation,
        
        // Diuretics
        "furosemide": .diuretic,
        "lasix": .diuretic,
        "bumetanide": .diuretic,
        "bumex": .diuretic,
        "torsemide": .diuretic,
        
        // Antihypertensives
        "labetalol": .antihypertensive,
        "trandate": .antihypertensive,
        "hydralazine": .antihypertensive,
        "nicardipine": .antihypertensive,
        "cardene": .antihypertensive,
        "nitroprusside": .antihypertensive,
        "nipride": .antihypertensive,
        "nitroglycerin": .antihypertensive,
        "clevidipine": .antihypertensive,
        "cleviprex": .antihypertensive
    ]
    
    /// Classify a medication by name
    static func classify(_ medicationName: String) -> MedicationClass {
        let lowercased = medicationName.lowercased()
        
        // Direct match
        if let directMatch = drugClassMap[lowercased] {
            return directMatch
        }
        
        // Partial match
        for (drugName, drugClass) in drugClassMap {
            if lowercased.contains(drugName) || drugName.contains(lowercased) {
                return drugClass
            }
        }
        
        return .other
    }
}
