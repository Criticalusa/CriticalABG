//
//  ClinicalCalculatorMoments.swift
//  CriticalX
//
//  Evidence-based clinical calculator NLMoments.
//  Every formula here is sourced from the app's validated calculator views.
//  If a moment cannot safely compute, it returns .insufficient confidence
//  with an explanation — never a guess.
//

import Foundation

// =============================================================================
// MARK: - 1. Vent Initial Settings (ARDSNet / Devine IBW)
// =============================================================================

/// Calculates lung-protective ventilator settings from weight.
/// Uses actual body weight as a proxy for IBW when height is unavailable.
///
/// Evidence: ARDSNet ARMA trial (NEJM 2000), Devine formula (1974)
/// Formula: IBW(M) = 50 + 2.3×(inches−60), IBW(F) = 45.5 + 2.3×(inches−60)
/// TV = 6-8 mL/kg IBW
struct VentInitialSettingsMoment: NLMoment {
    let id = "vent_initial_settings"
    let title = "Initial Ventilator Settings"
    let kind: NLMomentKind = .calculator
    let requiredInputs: Set<InputKey> = [.weightKg]
    let intentAffinity: Set<CoPilotIntent> = [.dosing, .calculator, .general]

    let drugAliases: [String] = []
    let scenarioAliases = [
        "vent_initial", "tidal_volume", "lung_protective",
        "ardsnet", "ventilator", "vent_settings"
    ]
    let tags = ["tidal volume", "ventilator", "vent settings", "lung protective",
                "ardsnet", "ibw", "ideal body weight", "peep", "fio2"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        // Boost for explicit vent/tidal terms in raw query
        let lower = query.normalized.lowercased()
        if lower.contains("tidal") || lower.contains("vent set") || lower.contains("lung protect") {
            score += 3
        }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        guard let weight = query.effectiveWeight else {
            return NLMomentOutput(
                headline: "Ventilator Settings",
                subhead: "Initial Lung-Protective Settings",
                doseLine: nil,
                chips: ["ARDSNet Protocol"],
                details: ["Provide patient weight to calculate tidal volume"],
                warnings: [],
                needsInput: [query.weightInputNeeded],
                clinicalPearls: [
                    "Use IDEAL body weight (IBW), not actual weight",
                    "If height available: Male IBW = 50 + 2.3×(in−60), Female IBW = 45.5 + 2.3×(in−60)",
                    "If no height, actual weight is a rough proxy — verify with clinical judgment"
                ],
                momentId: id,
                tags: tags
            )
        }

        // ── Safety bound: weight must be clinically plausible ──
        guard weight >= 30 && weight <= 200 else {
            var output = NLMomentOutput(
                headline: "Ventilator Settings",
                subhead: "Weight Out of Range",
                doseLine: nil,
                chips: [],
                details: ["Weight \(Int(weight)) kg is outside calculable range (30-200 kg).",
                          "Cannot safely compute tidal volume."],
                warnings: ["Verify patient weight before proceeding."],
                momentId: id,
                tags: tags
            )
            output.confidence = .insufficient
            output.confidenceReason = "Weight \(Int(weight)) kg outside safe calculation range"
            return output
        }

        // ── Compute TV range (6-8 mL/kg) ──
        // NOTE: Using actual weight as proxy for IBW. Real IBW requires height.
        let tvLow = weight * 6.0    // mL — lung-protective lower bound
        let tvHigh = weight * 8.0   // mL — lung-protective upper bound
        let tvTarget = weight * 6.0 // mL — ARDSNet target for ARDS

        let usingActualWeight = true // Future: detect height in query for true IBW

        var output = NLMomentOutput(
            headline: "Ventilator Settings",
            subhead: "Lung-Protective Initial Settings",
            doseLine: "TV: \(Int(tvLow))–\(Int(tvHigh)) mL",
            chips: ["6-8 mL/kg IBW", "AC/VC Mode", "ARDSNet"],
            details: [
                "── INITIAL SETTINGS ──",
                "Mode: Assist Control / Volume Control (AC/VC)",
                "Tidal Volume: \(Int(tvLow))–\(Int(tvHigh)) mL (6-8 mL/kg)",
                "  → ARDS target: \(Int(tvTarget)) mL (6 mL/kg)",
                "Rate: 14-18 breaths/min",
                "PEEP: 5 cmH₂O (start), titrate per FiO₂/PEEP table",
                "FiO₂: 100% initially, wean to SpO₂ 92-96%",
                "I:E Ratio: 1:2 (default)",
                "",
                "── PLATEAU PRESSURE ──",
                "Goal: Pplat ≤ 30 cmH₂O",
                "If Pplat > 30: decrease TV by 1 mL/kg increments",
                "Minimum TV: \(Int(weight * 4)) mL (4 mL/kg)",
            ],
            warnings: ["⚠ Using ACTUAL weight (\(Int(weight)) kg) — IBW requires height",
                       "IBW may differ significantly from actual weight in obese patients",
                       "Verify with: Male IBW = 50 + 2.3×(height in − 60)"],
            clinicalPearls: [
                "ARDSNet showed 22% mortality reduction with 6 vs 12 mL/kg",
                "Permissive hypercapnia acceptable (pH > 7.20)",
                "Check plateau pressure within 30 min of initiation",
                "Goal SpO₂ 88-95% in ARDS (avoid hyperoxia)"
            ],
            momentId: id,
            tags: tags
        )
        output.evidenceLevel = .guideline
        output.evidenceSource = "ARDSNet ARMA (NEJM 2000)"
        output.showDisclaimer = true
        if usingActualWeight {
            output.confidence = .caution
            output.confidenceReason = "Using actual weight — IBW requires height for accuracy"
        }
        return output
    }
}

// =============================================================================
// MARK: - 2. tPA Dosing (AHA/ASA Stroke Guidelines)
// =============================================================================

/// Calculates alteplase dosing for acute ischemic stroke.
/// Evidence: AHA/ASA Guidelines (2019), NINDS trial
/// Formula: 0.9 mg/kg (max 90 mg), 10% bolus IV over 1 min, 90% infusion over 60 min
struct TPADosingMoment: NLMoment {
    let id = "tpa_stroke_dosing"
    let title = "tPA Dosing — Acute Ischemic Stroke"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    let intentAffinity: Set<CoPilotIntent> = [.dosing, .general]

    let drugAliases = ["alteplase", "tpa", "activase"]
    let scenarioAliases = [
        "tpa_stroke", "stroke", "ischemic_stroke", "code_stroke",
        "thrombolytic", "acute_stroke"
    ]
    let tags = ["tpa", "alteplase", "stroke", "thrombolytic", "ischemic",
                "code stroke", "door to needle"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        let lower = query.normalized.lowercased()
        if lower.contains("stroke") { score += 3 }
        if lower.contains("tpa") || lower.contains("alteplase") { score += 2 }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        guard let weight = query.effectiveWeight else {
            return NLMomentOutput(
                headline: "Stroke — tPA",
                subhead: "Alteplase Dosing",
                doseLine: nil,
                chips: ["0.9 mg/kg", "Max 90 mg", "Time-Critical"],
                details: ["Provide patient weight to calculate tPA dose"],
                warnings: ["ISCHEMIC STROKE ONLY — CT must exclude hemorrhage"],
                needsInput: [query.weightInputNeeded],
                clinicalPearls: [
                    "Door-to-needle goal: < 60 minutes",
                    "Time window: ≤ 3 hours (up to 4.5 hr in select patients)",
                    "BP must be < 185/110 before administration"
                ],
                momentId: id,
                tags: tags
            )
        }

        // ── Safety bounds ──
        guard weight >= 30 && weight <= 200 else {
            var output = NLMomentOutput(
                headline: "Stroke — tPA",
                subhead: "Weight Out of Range",
                doseLine: nil,
                details: ["Weight \(Int(weight)) kg outside calculable range (30-200 kg)."],
                warnings: ["Cannot safely compute tPA dose. Verify weight."],
                momentId: id,
                tags: tags
            )
            output.confidence = .insufficient
            output.confidenceReason = "Weight \(Int(weight)) kg outside safe range"
            return output
        }

        // ── Compute dose ──
        let totalDose = min(weight * 0.9, 90.0)      // max 90 mg
        let bolusDose = min(totalDose * 0.10, 9.0)    // 10% bolus, max 9 mg
        let infusionDose = totalDose - bolusDose       // remaining 90%

        var output = NLMomentOutput(
            headline: "Stroke — tPA",
            subhead: "Alteplase (0.9 mg/kg)",
            doseLine: String(format: "%.1f mg total", totalDose),
            chips: ["IV Only", "Max 90 mg", "AHA/ASA"],
            details: [
                "── DOSE BREAKDOWN ──",
                String(format: "Total Dose: %.1f mg (0.9 mg/kg × %d kg)", totalDose, Int(weight)),
                String(format: "Bolus: %.1f mg IV push over 1 minute (10%%)", bolusDose),
                String(format: "Infusion: %.1f mg IV over 60 minutes (90%%)", infusionDose),
                "",
                "── TIME WINDOW ──",
                "Standard: ≤ 3 hours from symptom onset",
                "Extended: Up to 4.5 hours in select patients",
                "  (Age < 80, no diabetes + prior stroke, NIHSS ≤ 25)",
                "",
                "── PRE-TREATMENT ──",
                "CT/MRI: Must exclude hemorrhage",
                "BP: Must be < 185/110 mmHg before administration",
                "Labs: Glucose, platelets, INR (do not delay for labs if low suspicion)",
            ],
            warnings: [
                "ISCHEMIC STROKE ONLY — contraindicated in hemorrhagic stroke",
                "No anticoagulants or antiplatelets for 24 hours post-tPA",
                "Neuro checks q15 min during infusion, q30 min × 6 hr, then q1 hr × 16 hr",
                "If neuro deterioration: STOP infusion, emergent CT, consider cryoprecipitate"
            ],
            clinicalPearls: [
                "Door-to-needle goal: < 60 minutes (ideal < 45 min)",
                "Repeat head CT at 24 hours before starting anticoagulation",
                "BP goal post-tPA: < 180/105 for 24 hours",
                "Do NOT give aspirin, heparin, or warfarin for 24 hours"
            ],
            momentId: id,
            tags: tags
        )
        output.evidenceLevel = .guideline
        output.evidenceSource = "AHA/ASA 2019, NINDS Trial"
        output.showDisclaimer = true
        output.maxDose = "90 mg"
        return output
    }
}

// =============================================================================
// MARK: - 3. P/F Ratio & ARDS Classification (Berlin Definition)
// =============================================================================

/// Interprets P/F ratio and classifies ARDS severity.
/// Evidence: Berlin Definition (JAMA 2012)
/// Formula: P/F = PaO2 / FiO2 (as decimal)
///
/// NOTE: This moment uses the scenario to trigger, not numeric extraction from query.
/// Full ABG numeric parsing is a separate, more complex moment.
struct PFRatioMoment: NLMoment {
    let id = "pf_ratio_ards"
    let title = "P/F Ratio & ARDS Classification"
    let kind: NLMomentKind = .calculator
    let requiredInputs: Set<InputKey> = []
    let intentAffinity: Set<CoPilotIntent> = [.calculator, .dosing, .general]

    let drugAliases: [String] = []
    let scenarioAliases = [
        "pf_ratio", "ards", "ards_classification", "berlin_criteria",
        "oxygenation_index"
    ]
    let tags = ["pf ratio", "ards", "oxygenation", "berlin", "pao2",
                "fio2", "hypoxemia", "respiratory failure"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        let lower = query.normalized.lowercased()
        if lower.contains("pf") || lower.contains("p/f") || lower.contains("p f") { score += 3 }
        if lower.contains("ards") { score += 3 }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Attempt to extract PaO2 and FiO2 from query
        // Pattern: "pf ratio fio2 60 pao2 90" or "pao2 90 fio2 0.6"
        let lower = query.normalized.lowercased()
        let pao2 = extractNumber(after: ["pao2", "pa02", "po2"], in: lower)
        let fio2Raw = extractNumber(after: ["fio2", "fi02"], in: lower)

        // Convert FiO2: if > 1, treat as percentage
        let fio2: Double? = {
            guard let raw = fio2Raw else { return nil }
            if raw > 1 && raw <= 100 { return raw / 100.0 }
            if raw > 0 && raw <= 1 { return raw }
            return nil
        }()

        if let pao2 = pao2, let fio2 = fio2, fio2 > 0 {
            // ── Can compute P/F ratio ──
            let pfRatio = pao2 / fio2

            guard pao2 >= 20 && pao2 <= 600 && fio2 >= 0.21 && fio2 <= 1.0 else {
                var output = NLMomentOutput(
                    headline: "P/F Ratio",
                    subhead: "Values Out of Range",
                    doseLine: nil,
                    details: ["PaO₂ valid range: 20-600 mmHg, FiO₂: 21-100%"],
                    warnings: ["Cannot compute — verify input values."],
                    momentId: id,
                    tags: tags
                )
                output.confidence = .insufficient
                output.confidenceReason = "Input values outside physiologic range"
                return output
            }

            let (severity, color) = classifyARDS(pfRatio)

            var output = NLMomentOutput(
                headline: "P/F Ratio",
                subhead: "ARDS Classification (Berlin)",
                doseLine: String(format: "P/F = %.0f — %@", pfRatio, severity),
                chips: [String(format: "PaO₂ %.0f", pao2),
                        String(format: "FiO₂ %.0f%%", fio2 * 100),
                        color],
                details: [
                    "── BERLIN DEFINITION ARDS ──",
                    "Severe:   P/F < 100 (PEEP ≥ 5)",
                    "Moderate: P/F 100-200 (PEEP ≥ 5)",
                    "Mild:     P/F 200-300 (PEEP ≥ 5)",
                    "Normal:   P/F > 300",
                    "",
                    "── ARDS CRITERIA (all required) ──",
                    "1. Acute onset (within 1 week of known insult)",
                    "2. Bilateral opacities on CXR/CT (not effusions/atelectasis)",
                    "3. Not fully explained by cardiac failure / fluid overload",
                    "4. P/F ratio with PEEP ≥ 5 cmH₂O",
                ],
                warnings: pfRatio < 100
                    ? ["SEVERE hypoxemia — consider prone positioning, neuromuscular blockade"]
                    : [],
                clinicalPearls: [
                    "P/F must be measured on PEEP ≥ 5 cmH₂O for Berlin classification",
                    "Severe ARDS: consider prone positioning (16+ hr/day)",
                    "Target TV 6 mL/kg IBW, Pplat ≤ 30",
                    "SpO₂ goal 88-95% (avoid hyperoxia)"
                ],
                momentId: id,
                tags: tags
            )
            output.evidenceLevel = .guideline
            output.evidenceSource = "Berlin Definition (JAMA 2012)"
            return output
        }

        // ── Cannot compute — provide reference ──
        var output = NLMomentOutput(
            headline: "P/F Ratio",
            subhead: "ARDS Classification Reference",
            doseLine: nil,
            chips: ["Formula: PaO₂ ÷ FiO₂", "Berlin 2012"],
            details: [
                "── P/F RATIO = PaO₂ ÷ FiO₂ ──",
                "Example: PaO₂ 90 on FiO₂ 60% → 90 ÷ 0.6 = 150 (Moderate ARDS)",
                "",
                "── BERLIN DEFINITION ARDS ──",
                "Severe:   P/F < 100 (PEEP ≥ 5)",
                "Moderate: P/F 100-200 (PEEP ≥ 5)",
                "Mild:     P/F 200-300 (PEEP ≥ 5)",
                "Normal:   P/F > 300",
                "",
                "Try: \"pf ratio pao2 90 fio2 60\" to calculate"
            ],
            clinicalPearls: [
                "FiO₂ can be entered as percentage (60) or decimal (0.6)",
                "Must be measured on PEEP ≥ 5 cmH₂O"
            ],
            momentId: id,
            tags: tags
        )
        output.evidenceLevel = .guideline
        output.evidenceSource = "Berlin Definition (JAMA 2012)"
        output.confidence = .insufficient
        output.confidenceReason = "Provide PaO₂ and FiO₂ to calculate"
        return output
    }

    private func classifyARDS(_ pf: Double) -> (String, String) {
        switch pf {
        case ..<100:  return ("Severe ARDS", "🔴 Severe")
        case ..<200:  return ("Moderate ARDS", "🟠 Moderate")
        case ..<300:  return ("Mild ARDS", "🟡 Mild")
        default:      return ("Normal Oxygenation", "🟢 Normal")
        }
    }

    /// Extracts a number appearing after any of the given keywords in the string
    private func extractNumber(after keywords: [String], in text: String) -> Double? {
        for keyword in keywords {
            guard let range = text.range(of: keyword) else { continue }
            let after = text[range.upperBound...]
            let trimmed = after.trimmingCharacters(in: .whitespaces)
            // Match first number (with optional decimal)
            let pattern = #"^[\s:=]?(\d+\.?\d*)"#
            guard let match = trimmed.range(of: pattern, options: .regularExpression) else { continue }
            let numStr = trimmed[match]
                .trimmingCharacters(in: CharacterSet.decimalDigits.inverted.union(.init(charactersIn: ".")))
            // Clean: remove leading non-digits
            let cleaned = String(numStr).replacingOccurrences(of: #"^[^0-9]+"#, with: "", options: .regularExpression)
            if let val = Double(cleaned), val > 0 { return val }
        }
        return nil
    }
}

// =============================================================================
// MARK: - 4. Shock Index
// =============================================================================

/// Calculates Shock Index = HR / SBP.
/// Evidence: Allgöwer & Burri (1967), validated in trauma and hemorrhage literature
struct ShockIndexMoment: NLMoment {
    let id = "shock_index"
    let title = "Shock Index"
    let kind: NLMomentKind = .calculator
    let requiredInputs: Set<InputKey> = []
    let intentAffinity: Set<CoPilotIntent> = [.calculator, .differential, .general]

    let drugAliases: [String] = []
    let scenarioAliases = ["shock_index"]
    let tags = ["shock index", "shock", "triage", "hemorrhage", "hemodynamics",
                "hr", "sbp", "heart rate", "blood pressure"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        let lower = query.normalized.lowercased()
        if lower.contains("shock index") { score += 5 }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Try to extract HR and SBP from query
        let lower = query.normalized.lowercased()
        let hr = extractVital(keywords: ["hr", "heart rate", "pulse"], in: lower, min: 20, max: 300)
        let sbp = query.sbp.map { Double($0) } ?? extractVital(keywords: ["sbp", "systolic", "bp"], in: lower, min: 40, max: 300)

        if let hr = hr, let sbp = sbp, sbp > 0 {
            let si = hr / sbp
            let (category, interpretation) = classifySI(si)

            var output = NLMomentOutput(
                headline: "Hemodynamic Assessment",
                subhead: "Shock Index",
                doseLine: String(format: "SI = %.2f — %@", si, category),
                chips: [String(format: "HR %d", Int(hr)),
                        String(format: "SBP %d", Int(sbp))],
                details: [
                    "── SHOCK INDEX = HR ÷ SBP ──",
                    "",
                    interpretation,
                    "",
                    "── REFERENCE ──",
                    "< 0.5:  Hyperdynamic",
                    "0.5-0.7: Normal",
                    "0.7-1.0: Elevated — occult hypoperfusion",
                    "> 1.0:  Circulatory shock",
                    "> 1.4:  Severe shock — increased mortality",
                ],
                warnings: si > 1.0
                    ? ["Shock Index > 1.0 — consider aggressive resuscitation, MTP activation"]
                    : [],
                clinicalPearls: [
                    "More sensitive than HR or BP alone for occult shock",
                    "Useful for identifying need for massive transfusion",
                    "May be unreliable in patients on beta-blockers or pacemakers"
                ],
                momentId: id,
                tags: tags
            )
            output.evidenceLevel = .peerReviewed
            output.evidenceSource = "Allgöwer & Burri 1967"
            return output
        }

        // ── Reference card if no vitals ──
        var output = NLMomentOutput(
            headline: "Hemodynamic Assessment",
            subhead: "Shock Index Reference",
            doseLine: nil,
            chips: ["Formula: HR ÷ SBP"],
            details: [
                "── SHOCK INDEX = HR ÷ SBP ──",
                "Example: HR 120, SBP 85 → SI = 1.41 (Severe)",
                "",
                "< 0.5:  Hyperdynamic",
                "0.5-0.7: Normal",
                "0.7-1.0: Elevated — occult hypoperfusion",
                "> 1.0:  Circulatory shock",
                "> 1.4:  Severe shock — increased mortality",
                "",
                "Try: \"shock index hr 120 sbp 85\" to calculate"
            ],
            clinicalPearls: [
                "Normal vitals can mask shock — SI unmasks it",
                "HR 100 + SBP 90 = SI 1.11 (already in shock range)"
            ],
            momentId: id,
            tags: tags
        )
        output.evidenceLevel = .peerReviewed
        output.evidenceSource = "Allgöwer & Burri 1967"
        output.confidence = .insufficient
        output.confidenceReason = "Provide HR and SBP to calculate"
        return output
    }

    private func classifySI(_ si: Double) -> (String, String) {
        switch si {
        case ..<0.5:  return ("Hyperdynamic", "Hyperdynamic state — consider early sepsis, anxiety, pain")
        case ..<0.7:  return ("Normal", "Normal hemodynamic status — stable")
        case ..<1.0:  return ("Elevated", "Elevated — occult hypoperfusion, early hypovolemia possible")
        case ..<1.4:  return ("Shock", "Circulatory shock — significant hemodynamic compromise")
        default:      return ("Severe Shock", "Severe shock — high mortality risk, aggressive resuscitation needed")
        }
    }

    private func extractVital(keywords: [String], in text: String, min: Double, max: Double) -> Double? {
        for keyword in keywords {
            guard let range = text.range(of: keyword) else { continue }
            let after = String(text[range.upperBound...]).trimmingCharacters(in: .whitespaces)
            let pattern = #"^[\s:=]?(\d+)"#
            guard let match = after.range(of: pattern, options: .regularExpression) else { continue }
            let numStr = after[match].filter { $0.isNumber }
            if let val = Double(numStr), val >= min, val <= max { return val }
        }
        return nil
    }
}

// =============================================================================
// MARK: - 5. RSBI (Rapid Shallow Breathing Index)
// =============================================================================

/// Calculates RSBI = RR / TV(L) for extubation readiness.
/// Evidence: Yang & Tobin (NEJM 1991) — 97% sensitivity at threshold ≤ 105
struct RSBIMoment: NLMoment {
    let id = "rsbi_calculator"
    let title = "RSBI — Extubation Readiness"
    let kind: NLMomentKind = .calculator
    let requiredInputs: Set<InputKey> = []
    let intentAffinity: Set<CoPilotIntent> = [.calculator, .general]

    let drugAliases: [String] = []
    let scenarioAliases = ["rsbi", "extubation", "extubation_readiness"]
    let tags = ["rsbi", "rapid shallow breathing", "extubation", "weaning",
                "breathing trial", "ventilator liberation"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        let lower = query.normalized.lowercased()
        if lower.contains("rsbi") { score += 5 }
        if lower.contains("extubat") { score += 2 }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Reference-only — RSBI requires RR and TV measured at bedside during SBT
        var output = NLMomentOutput(
            headline: "Ventilator Liberation",
            subhead: "RSBI — Rapid Shallow Breathing Index",
            doseLine: nil,
            chips: ["Formula: RR ÷ TV(L)", "Threshold ≤ 105"],
            details: [
                "── RSBI = Respiratory Rate ÷ Tidal Volume (in Liters) ──",
                "",
                "Measure during spontaneous breathing trial (SBT):",
                "  • CPAP 0-5 or T-piece for 30-120 minutes",
                "  • Record spontaneous RR and exhaled TV",
                "",
                "── INTERPRETATION ──",
                "RSBI ≤ 105: Favorable for extubation (97% sensitive)",
                "RSBI > 105: Unfavorable — likely extubation failure",
                "",
                "── EXAMPLE ──",
                "RR 22, TV 400 mL → 22 ÷ 0.4 = 55 → Favorable",
                "RR 32, TV 250 mL → 32 ÷ 0.25 = 128 → Unfavorable",
            ],
            warnings: [
                "RSBI must be measured during SPONTANEOUS breathing, NOT on full vent support",
                "RSBI alone does not determine extubation — clinical assessment required"
            ],
            clinicalPearls: [
                "97% sensitivity — good at ruling OUT failure (low RSBI = likely success)",
                "Lower specificity — high RSBI doesn't guarantee failure",
                "Also assess: cuff leak, mental status, secretion burden, cough strength",
                "Pre-SBT readiness: FiO₂ ≤ 40%, PEEP ≤ 8, hemodynamically stable"
            ],
            momentId: id,
            tags: tags
        )
        output.evidenceLevel = .peerReviewed
        output.evidenceSource = "Yang & Tobin (NEJM 1991)"
        output.confidence = .insufficient
        output.confidenceReason = "RSBI requires bedside measurement during SBT"
        return output
    }
}

// =============================================================================
// MARK: - 6. FeNa (Fractional Excretion of Sodium)
// =============================================================================

/// Reference card for FeNa interpretation.
/// Formula: FeNa = (UNa × PCr) / (PNa × UCr) × 100
/// Evidence: Espinel (JAMA 1976), standard nephrology reference
struct FeNaMoment: NLMoment {
    let id = "fena_calculator"
    let title = "FeNa — Fractional Excretion of Sodium"
    let kind: NLMomentKind = .calculator
    let requiredInputs: Set<InputKey> = []
    let intentAffinity: Set<CoPilotIntent> = [.calculator, .labInterpret, .general]

    let drugAliases: [String] = []
    let scenarioAliases = ["fena", "fractional_excretion", "prerenal"]
    let tags = ["fena", "fractional excretion", "sodium", "prerenal",
                "aki", "acute kidney", "renal failure", "atn"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        let lower = query.normalized.lowercased()
        if lower.contains("fena") || lower.contains("fractional") { score += 5 }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        var output = NLMomentOutput(
            headline: "Renal Assessment",
            subhead: "FeNa — Fractional Excretion of Sodium",
            doseLine: nil,
            chips: ["Formula: (UNa×PCr)/(PNa×UCr)×100"],
            details: [
                "── FeNa = (Urine Na × Plasma Cr) / (Plasma Na × Urine Cr) × 100 ──",
                "",
                "── INTERPRETATION ──",
                "< 1%:   Pre-Renal AKI (kidneys retaining sodium appropriately)",
                "1-2%:   Indeterminate — clinical correlation required",
                "> 2%:   Intrinsic Renal (ATN — tubular damage)",
                "",
                "── EXAMPLE ──",
                "UNa 10, PCr 2.0, PNa 140, UCr 100",
                "FeNa = (10 × 2.0) / (140 × 100) × 100 = 0.14% → Pre-renal",
            ],
            warnings: [
                "UNRELIABLE on diuretics — use FeUrea instead",
                "Unreliable in: contrast nephropathy, rhabdomyolysis, early obstruction",
                "May show < 1% in: acute GN, hepatorenal syndrome, early pigment nephropathy"
            ],
            clinicalPearls: [
                "FeNa < 1% + rising creatinine = fluid-responsive pre-renal AKI",
                "If on diuretics: FeUrea < 35% suggests pre-renal",
                "Always interpret in clinical context — not a standalone diagnostic",
                "Requires SPOT urine and serum samples drawn simultaneously"
            ],
            momentId: id,
            tags: tags
        )
        output.evidenceLevel = .peerReviewed
        output.evidenceSource = "Espinel (JAMA 1976)"
        output.confidence = .insufficient
        output.confidenceReason = "Requires lab values — use in-app calculator for computation"
        return output
    }
}

// =============================================================================
// MARK: - 7. Winter's Formula
// =============================================================================

/// Expected PaCO2 in metabolic acidosis.
/// Formula: Expected PaCO₂ = (1.5 × HCO₃⁻) + 8 ± 2
/// Evidence: Albert, Dell, Winters (Ann Intern Med 1967)
struct WintersFormulaMoment: NLMoment {
    let id = "winters_formula"
    let title = "Winter's Formula — Expected pCO2"
    let kind: NLMomentKind = .calculator
    let requiredInputs: Set<InputKey> = []
    let intentAffinity: Set<CoPilotIntent> = [.calculator, .general]

    let drugAliases: [String] = []
    let scenarioAliases = ["winters_formula", "expected_pco2", "respiratory_compensation"]
    let tags = ["winters", "winter formula", "expected pco2", "metabolic acidosis",
                "compensation", "acid base", "abg"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        let lower = query.normalized.lowercased()
        if lower.contains("winter") { score += 5 }
        if lower.contains("expected") && lower.contains("pco2") { score += 3 }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Try to extract HCO3 from query
        let lower = query.normalized.lowercased()
        let bicarb = extractNumber(keywords: ["hco3", "bicarb", "bicarbonate"], in: lower, min: 1, max: 60)

        if let bicarb = bicarb {
            let expected = (1.5 * bicarb) + 8
            let low = expected - 2
            let high = expected + 2

            var output = NLMomentOutput(
                headline: "Acid-Base",
                subhead: "Winter's Formula",
                doseLine: String(format: "Expected pCO₂: %.0f–%.0f mmHg", low, high),
                chips: [String(format: "HCO₃⁻ %.0f", bicarb), "Metabolic Acidosis Only"],
                details: [
                    "── WINTER'S FORMULA ──",
                    String(format: "Expected pCO₂ = (1.5 × %.0f) + 8 ± 2", bicarb),
                    String(format: "= %.0f ± 2 = %.0f to %.0f mmHg", expected, low, high),
                    "",
                    "── INTERPRETATION ──",
                    String(format: "If measured pCO₂ is %.0f–%.0f: Appropriate compensation", low, high),
                    String(format: "If measured pCO₂ > %.0f: Concurrent respiratory acidosis", high),
                    String(format: "If measured pCO₂ < %.0f: Concurrent respiratory alkalosis", low),
                ],
                warnings: [
                    "Applies ONLY to metabolic acidosis — do not use for metabolic alkalosis",
                    "Full respiratory compensation takes 12-24 hours"
                ],
                clinicalPearls: [
                    "pCO₂ above expected → respiratory failure, sedation, COPD, airway issue",
                    "pCO₂ below expected → sepsis, salicylate toxicity, anxiety, liver failure",
                    "Quick check: pCO₂ should ≈ last 2 digits of pH (e.g., pH 7.28 → pCO₂ ~28)"
                ],
                momentId: id,
                tags: tags
            )
            output.evidenceLevel = .peerReviewed
            output.evidenceSource = "Albert, Dell, Winters (1967)"
            return output
        }

        // ── Reference card ──
        var output = NLMomentOutput(
            headline: "Acid-Base",
            subhead: "Winter's Formula Reference",
            doseLine: nil,
            chips: ["Expected pCO₂ = (1.5 × HCO₃⁻) + 8 ± 2"],
            details: [
                "── WINTER'S FORMULA ──",
                "Expected pCO₂ = (1.5 × HCO₃⁻) + 8 ± 2",
                "",
                "Example: HCO₃⁻ = 12",
                "Expected pCO₂ = (1.5 × 12) + 8 ± 2 = 24-28 mmHg",
                "",
                "Try: \"winters formula hco3 12\" to calculate"
            ],
            momentId: id,
            tags: tags
        )
        output.evidenceLevel = .peerReviewed
        output.evidenceSource = "Albert, Dell, Winters (1967)"
        output.confidence = .insufficient
        output.confidenceReason = "Provide HCO₃⁻ value to calculate"
        return output
    }

    private func extractNumber(keywords: [String], in text: String, min: Double, max: Double) -> Double? {
        for keyword in keywords {
            guard let range = text.range(of: keyword) else { continue }
            let after = String(text[range.upperBound...]).trimmingCharacters(in: .whitespaces)
            let pattern = #"^[\s:=]?(\d+\.?\d*)"#
            guard let match = after.range(of: pattern, options: .regularExpression) else { continue }
            let numStr = after[match].filter { $0.isNumber || $0 == "." }
            if let val = Double(numStr), val >= min, val <= max { return val }
        }
        return nil
    }
}

// =============================================================================
// MARK: - 8. Parkland Formula (Burn Resuscitation)
// =============================================================================

/// Calculates fluid resuscitation for burn patients.
/// Formula: 4 mL × weight(kg) × %TBSA (adult), 3 mL × kg × %TBSA (pediatric)
/// Evidence: Baxter & Shires (Surg Clin North Am 1968), standard of care
struct ParklandBurnMoment: NLMoment {
    let id = "parkland_burn"
    let title = "Parkland Formula — Burn Resuscitation"
    let kind: NLMomentKind = .calculator
    let requiredInputs: Set<InputKey> = [.weightKg]
    let intentAffinity: Set<CoPilotIntent> = [.dosing, .calculator, .general]

    let drugAliases: [String] = []
    let scenarioAliases = [
        "parkland_burn", "burn", "burn_resuscitation", "tbsa"
    ]
    let tags = ["parkland", "burn", "tbsa", "resuscitation", "fluid",
                "lactated ringers", "rule of nines"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        let lower = query.normalized.lowercased()
        if lower.contains("parkland") { score += 5 }
        if lower.contains("burn") { score += 3 }
        if lower.contains("tbsa") { score += 3 }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        guard let weight = query.effectiveWeight else {
            return NLMomentOutput(
                headline: "Burn Resuscitation",
                subhead: "Parkland Formula",
                doseLine: nil,
                chips: ["4 mL × kg × %TBSA", "LR Only"],
                details: [
                    "Provide patient weight and %TBSA to calculate",
                    "",
                    "── RULE OF 9's (Adult) ──",
                    "Head & Neck: 9%",
                    "Each Arm: 9% (both = 18%)",
                    "Anterior Trunk: 18%",
                    "Posterior Trunk: 18%",
                    "Each Leg: 18% (both = 36%)",
                    "Perineum: 1%"
                ],
                needsInput: [query.weightInputNeeded],
                momentId: id,
                tags: tags
            )
        }

        // Try to extract %TBSA from query
        let lower = query.normalized.lowercased()
        let tbsa = extractTBSA(from: lower)

        guard let tbsa = tbsa, tbsa > 0, tbsa <= 100 else {
            // Have weight but no TBSA — provide formula with weight plugged in
            var output = NLMomentOutput(
                headline: "Burn Resuscitation",
                subhead: "Parkland Formula",
                doseLine: nil,
                chips: ["\(Int(weight)) kg", "Need %TBSA"],
                details: [
                    "── PARKLAND = 4 mL × \(Int(weight)) kg × %TBSA ──",
                    "",
                    "Example calculations for \(Int(weight)) kg:",
                    "  20% TBSA → \(Int(4 * weight * 20)) mL total",
                    "  30% TBSA → \(Int(4 * weight * 30)) mL total",
                    "  40% TBSA → \(Int(4 * weight * 40)) mL total",
                    "  50% TBSA → \(Int(4 * weight * 50)) mL total",
                    "",
                    "Try: \"parkland \(Int(weight))kg 30%\" to calculate",
                    "",
                    "── RULE OF 9's ──",
                    "Head 9% | Each Arm 9% | Each Leg 18%",
                    "Anterior Trunk 18% | Posterior Trunk 18% | Perineum 1%"
                ],
                momentId: id,
                tags: tags
            )
            output.confidence = .insufficient
            output.confidenceReason = "Provide %TBSA to complete calculation"
            output.evidenceLevel = .guideline
            output.evidenceSource = "Baxter & Shires (1968)"
            return output
        }

        // ── Full calculation ──
        let isPeds = query.isPediatricIntent
        let multiplier = isPeds ? 3.0 : 4.0
        let totalFluid = multiplier * weight * tbsa
        let first8hr = totalFluid / 2.0
        let next16hr = totalFluid / 2.0
        let hourlyFirst8 = first8hr / 8.0
        let hourlyNext16 = next16hr / 16.0

        var output = NLMomentOutput(
            headline: "Burn Resuscitation",
            subhead: "Parkland Formula",
            doseLine: String(format: "%.0f mL total (24 hr)", totalFluid),
            chips: ["\(Int(weight)) kg", "\(Int(tbsa))% TBSA", "LR Only"],
            details: [
                "── PARKLAND = \(Int(multiplier)) mL × \(Int(weight)) kg × \(Int(tbsa))% ──",
                String(format: "Total 24-hr fluid: %.0f mL Lactated Ringer's", totalFluid),
                "",
                "── ADMINISTRATION ──",
                String(format: "First 8 hours: %.0f mL (%.0f mL/hr)", first8hr, hourlyFirst8),
                String(format: "Next 16 hours: %.0f mL (%.0f mL/hr)", next16hr, hourlyNext16),
                "",
                "⚠ Time starts from INJURY, not arrival",
            ],
            warnings: [
                "Time zero = time of BURN INJURY, not hospital arrival",
                "Titrate to urine output: 0.5-1 mL/kg/hr (adult), 1-1.5 mL/kg/hr (peds)",
                "Parkland is a STARTING POINT — adjust based on clinical response",
                "Inhalation injury may require 40% additional fluid"
            ],
            clinicalPearls: [
                "Use Lactated Ringer's — avoid normal saline (hyperchloremic acidosis risk)",
                "Avoid colloids in first 24 hours",
                "Monitor for abdominal compartment syndrome with large-volume resuscitation",
                "Consider escharotomy for circumferential burns with compartment syndrome"
            ],
            momentId: id,
            tags: tags
        )
        output.evidenceLevel = .guideline
        output.evidenceSource = "Baxter & Shires (1968), ABA Guidelines"
        output.showDisclaimer = true
        return output
    }

    private func extractTBSA(from text: String) -> Double? {
        // Match patterns like "40%", "40 percent", "40 tbsa", "tbsa 40"
        let patterns = [
            #"(\d+)\s*%"#,
            #"(\d+)\s*percent"#,
            #"(\d+)\s*tbsa"#,
            #"tbsa\s*(\d+)"#,
        ]
        for pattern in patterns {
            guard let match = text.range(of: pattern, options: .regularExpression) else { continue }
            let matched = String(text[match])
            let numStr = matched.filter { $0.isNumber }
            if let val = Double(numStr), val > 0, val <= 100 { return val }
        }
        return nil
    }
}
