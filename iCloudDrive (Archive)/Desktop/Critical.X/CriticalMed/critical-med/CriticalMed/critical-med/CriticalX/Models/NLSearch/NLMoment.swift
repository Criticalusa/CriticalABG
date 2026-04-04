//
//  NLMoment.swift
//  CriticalX
//
//  Natural Language Moment Search - Moment Models
//  Defines moments that can be matched to user queries
//
//  NOTE: InputKey and NLMomentKind are defined in ParsedQuery.swift
//

import Foundation

// MARK: - NLMoment Protocol
/// Protocol for all searchable clinical moments
protocol NLMoment {
    var id: String { get }
    var title: String { get }
    var kind: NLMomentKind { get }
    var requiredInputs: Set<InputKey> { get }

    /// Tags derived from indications - used for matching
    var tags: [String] { get }

    /// Drug synonyms/aliases for matching
    var drugAliases: [String] { get }

    /// Scenario synonyms for matching
    var scenarioAliases: [String] { get }

    /// Calculate match score for a parsed query
    func matchScore(_ query: ParsedQuery) -> Int

    /// Compute the moment output with dose/details
    func compute(_ query: ParsedQuery) -> NLMomentOutput
}

// MARK: - Default Implementations

extension NLMoment {
    var tags: [String] { [] }
    var drugAliases: [String] { [] }
    var scenarioAliases: [String] { [] }

    /// Check if patient is explicitly adult (age >= 18 years)
    func isExplicitlyAdult(_ query: ParsedQuery) -> Bool {
        if let age = query.ageYears {
            return age >= 18
        }
        return false
    }

    /// Check if patient is pediatric (age < 18 years)
    func isPediatric(_ query: ParsedQuery) -> Bool {
        if let age = query.ageYears {
            return age < 18
        }
        return false
    }

    /// Default scoring based on drug/scenario/tag matching
    func baseMatchScore(_ query: ParsedQuery) -> Int {
        var score = 0

        // Drug match
        if let drug = query.drug {
            for alias in drugAliases {
                if drug.contains(alias) || alias.contains(drug) {
                    score += 5
                    break
                }
            }
        }

        // Scenario match
        if let scenario = query.scenario {
            for alias in scenarioAliases {
                if scenario.contains(alias) || alias.contains(scenario) {
                    score += 5
                    break
                }
            }
        }

        // Tag matching (from indications)
        // Require word length >= 3 for substring-in-tag matching to avoid
        // false positives from short words like "to", "in", "mg" appearing
        // inside unrelated tags (e.g. "to" matching "refractory").
        let queryWords = query.normalized.components(separatedBy: .whitespacesAndNewlines)
        for tag in tags {
            if queryWords.contains(where: { word in
                word.contains(tag) || (word.count >= 3 && tag.contains(word))
            }) {
                score += 2
            }
        }

        return score
    }
}

// =============================================================================
// MARK: - VENTILATOR TROUBLESHOOTING MOMENTS
// =============================================================================

// MARK: - Ventilator Desaturation (Low SpO2)
struct VentilatorDesaturationMoment: NLMoment {
    let id = "ventilator_desaturation"
    let title = "Ventilator Desaturation"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []

    let tags = ["desaturation", "ventilator", "spo2", "oxygenation", "vent", "hypoxemia"]
    let scenarioAliases = ["desaturation", "ventilator desaturation", "spo2 dropping"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("desaturation") || query.normalized.contains("spo2") {
            score += 4
        }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Ventilator Emergency",
            subhead: "Acute Desaturation",
            doseLine: "FiO2 100%",
            chips: ["DOPE Check", "Increase FiO2", "Increase PEEP", "Emergency"],
            details: [
                "Immediate: Increase FiO2 to 100%",
                "DOPE: Displacement, Obstruction, Pneumothorax, Equipment",
                "Check tube position: Capnography, auscultation, CXR",
                "Check for pneumothorax: Asymmetric breath sounds",
                "Suction if secretions present",
                "Increase PEEP: 5-8 initially, may need 10-15",
                "Consider recruitment maneuver if ARDS",
                "Check ventilator circuit for disconnection"
            ],
            warnings: [
                "Pneumothorax is life-threatening - check immediately",
                "Tube displacement requires immediate reintubation",
                "High PEEP can cause hypotension"
            ],
            needsInput: [],
            clinicalPearls: [
                "DOPE mnemonic for systematic approach",
                "FiO2 100% first, then troubleshoot",
                "Capnography confirms tube position",
                "Asymmetric breath sounds = pneumothorax until proven otherwise"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Ventilator Hypercapnia (High CO2)
struct VentilatorHypercapniaMoment: NLMoment {
    let id = "ventilator_hypercapnia"
    let title = "Ventilator Hypercapnia"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []

    let tags = ["hypercapnia", "ventilator", "co2", "ventilation", "paco2", "etco2"]
    let scenarioAliases = ["hypercapnia", "ventilator hypercapnia", "high co2", "elevated co2"]

    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("hypercapnia") || query.normalized.contains("high co2") {
            score += 4
        }
        return score
    }

    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Ventilator Management",
            subhead: "Hypercapnia / High CO2",
            doseLine: "Increase Minute Ventilation",
            chips: ["Increase RR", "Increase TV", "Check Dead Space", "Settings"],
            details: [
                "Increase respiratory rate: Add 2-4 breaths/min (max 30-35)",
                "Or increase tidal volume: If <6 mL/kg IBW, increase to 6-8 mL/kg",
                "Minute ventilation = TV × RR",
                "Check for increased dead space: Long circuit, HME, tubing",
                "Check for auto-PEEP: May need longer expiratory time (lower RR or shorter I-time)",
                "ARDS: Permissive hypercapnia acceptable (PaCO2 50-60)",
                "Neuro patients: Keep PaCO2 35-40 (avoid hypercapnia)",
                "Check patient-ventilator synchrony"
            ],
            warnings: [
                "Do not exceed 8 mL/kg IBW for tidal volume",
                "High rates may cause auto-PEEP",
                "Neuro patients: Avoid hypercapnia (increases ICP)"
            ],
            needsInput: [],
            clinicalPearls: [
                "Increase rate first (faster response)",
                "Minute ventilation drives CO2 elimination",
                "Dead space increases = need higher minute ventilation",
                "ARDS: Permissive hypercapnia is lung-protective",
                "Check ETCO₂ trend for response"
            ],
            momentId: id,
            tags: tags
        )
    }
}
