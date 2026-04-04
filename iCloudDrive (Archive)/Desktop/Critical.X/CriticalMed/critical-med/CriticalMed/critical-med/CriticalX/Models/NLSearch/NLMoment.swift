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
// MARK: - VASOPRESSOR MOMENTS
// =============================================================================

// MARK: - Norepinephrine (Septic Shock / Post-ROSC)
struct NorepinephrineShockMoment: NLMoment {
    let id = "adult_norepinephrine_shock"
    let title = "Norepinephrine Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["norepinephrine", "levophed", "levo", "norepi"]
    let scenarioAliases = ["shock", "sepsis", "septic", "post_rosc", "rosc", "hypotension", "vasopressor"]
    let tags = ["septic shock", "distributive shock", "hypotension", "map", "vasopressor", 
                "post cardiac arrest", "rosc", "first line", "central line"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var chips: [String] = ["IV Infusion", "Central Line"]
        var details: [String] = []
        var warnings: [String] = []
        var needsInput: [InputKey] = []
        var doseLine: String?
        
        if let weight = query.weightKg {
            // Standard concentration: 8 mg in 250 mL = 32 mcg/mL (or 4mg/250mL = 16 mcg/mL)
            let concentration = 16.0 // mcg/mL
            let startDose = 0.05 // mcg/kg/min
            let startRate = (startDose * weight * 60) / concentration
            
            // Show calculated mL/hr as primary (changes with weight)
            doseLine = String(format: "%.1f mL/hr", startRate)
            chips.append(String(format: "%.2f mcg/kg/min", startDose))
            chips.append("16 mcg/mL")
            chips.append(String(format: "%.0f kg", weight))
            
            // Show titration rates
            let midRate = (0.1 * weight * 60) / concentration
            let highRate = (0.3 * weight * 60) / concentration
            
            details = [
                "Titrate to MAP ≥65 mmHg",
                String(format: "At 0.1 mcg/kg/min: %.1f mL/hr", midRate),
                String(format: "At 0.3 mcg/kg/min: %.1f mL/hr", highRate),
                "Max: 0.5 mcg/kg/min → add vasopressin"
            ]
            warnings = [
                "Extravasation causes tissue necrosis",
                "Central line preferred"
            ]
        } else {
            needsInput = [.weightKg]
            warnings = ["Weight required for dose calculation"]
        }
        
        return NLMomentOutput(
            headline: "Septic Shock / Post-ROSC",
            subhead: "Norepinephrine Infusion",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: warnings,
            needsInput: needsInput,
            clinicalPearls: [
                "First-line vasopressor for septic shock",
                "Ensure adequate fluid resuscitation first",
                "Add vasopressin as 2nd agent if refractory"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Epinephrine Infusion (Cardiogenic Shock)
struct EpinephrineInfusionMoment: NLMoment {
    let id = "adult_epinephrine_infusion"
    let title = "Epinephrine Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["epinephrine", "epi", "adrenalin", "adrenaline"]
    let scenarioAliases = ["cardiogenic", "shock", "bradycardia", "infusion"]
    let tags = ["cardiogenic shock", "bradycardia", "anaphylaxis", "inotrope", 
                "chronotrope", "second line", "beta agonist"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        // Boost if specifically asking for infusion
        if query.normalized.contains("infusion") || query.normalized.contains("drip") {
            score += 3
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var chips: [String] = ["IV Infusion"]
        var details: [String] = []
        var warnings: [String] = []
        var needsInput: [InputKey] = []
        var doseLine: String?
        
        if let weight = query.weightKg {
            // Standard: 4 mg in 250 mL = 16 mcg/mL
            let startDose = 0.05 // mcg/kg/min
            let concentration = 16.0 // mcg/mL
            let startRateMLhr = (startDose * weight * 60) / concentration
            
            // Show calculated mL/hr as primary (changes with weight)
            doseLine = String(format: "%.1f mL/hr", startRateMLhr)
            chips.append(String(format: "%.2f mcg/kg/min", startDose))
            chips.append("16 mcg/mL")
            chips.append(String(format: "%.0f kg", weight))
            
            let midRate = (0.1 * weight * 60) / concentration
            let highRate = (0.2 * weight * 60) / concentration
            
            details = [
                String(format: "At 0.1 mcg/kg/min: %.1f mL/hr", midRate),
                String(format: "At 0.2 mcg/kg/min: %.1f mL/hr", highRate),
                "Range: 0.01-0.5 mcg/kg/min",
                "Titrate to heart rate and MAP"
            ]
            warnings = [
                "Causes tachyarrhythmias",
                "Increases myocardial oxygen demand"
            ]
        } else {
            needsInput = [.weightKg]
        }
        
        return NLMomentOutput(
            headline: "Cardiogenic Shock",
            subhead: "Epinephrine Infusion",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: warnings,
            needsInput: needsInput,
            clinicalPearls: [
                "Consider in cardiogenic shock unresponsive to dobutamine",
                "Has both alpha and beta effects",
                "May need norepinephrine adjunct"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Vasopressin (Septic Shock Adjunct)
struct VasopressinMoment: NLMoment {
    let id = "adult_vasopressin"
    let title = "Vasopressin Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["vasopressin", "pitressin", "adh"]
    let scenarioAliases = ["shock", "septic", "refractory", "adjunct"]
    let tags = ["septic shock", "refractory shock", "second line", "catecholamine sparing",
                "adjunct", "diabetes insipidus", "variceal bleeding"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Fixed dose - not weight-based
        return NLMomentOutput(
            headline: "Refractory Septic Shock",
            subhead: "Vasopressin Infusion",
            doseLine: "0.03 units/min",
            chips: ["IV Infusion", "Fixed Dose", "Not Titrated"],
            details: [
                "Fixed dose: 0.03-0.04 units/min",
                "Add to norepinephrine (catecholamine sparing)",
                "Do NOT titrate like other vasopressors"
            ],
            warnings: [
                "Not first-line for septic shock",
                "Can cause splanchnic/digital ischemia"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Phenylephrine (with full calculation)
struct PhenylephrineMoment: NLMoment {
    let id = "adult_phenylephrine"
    let title = "Phenylephrine Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["phenylephrine", "neosynephrine", "neo"]
    let scenarioAliases = ["hypotension", "reflex bradycardia", "spinal", "vasopressor"]
    let tags = ["hypotension", "spinal anesthesia", "pure alpha", "reflex bradycardia",
                "aortic stenosis", "hocm", "vasopressor", "drip", "infusion"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var doseLine: String?
        var needsInput: [InputKey] = []
        var chips: [String] = ["IV Infusion"]
        var details: [String] = []
        
        if let weight = query.weightKg {
            // Standard concentration: 10 mg in 250 mL = 40 mcg/mL
            let startDose = 0.5 // mcg/kg/min
            let concentration = 40.0 // mcg/mL
            let startRateMLhr = (startDose * weight * 60) / concentration
            
            // Show calculated mL/hr as primary (changes with weight)
            doseLine = String(format: "%.1f mL/hr", startRateMLhr)
            chips.append(String(format: "%.1f mcg/kg/min", startDose))
            chips.append("40 mcg/mL")
            chips.append(String(format: "%.0f kg", weight))
            
            let midRate = (1.0 * weight * 60) / concentration
            let highRate = (2.0 * weight * 60) / concentration
            
            details = [
                String(format: "At 1 mcg/kg/min: %.1f mL/hr", midRate),
                String(format: "At 2 mcg/kg/min: %.1f mL/hr", highRate),
                "Range: 0.5-5 mcg/kg/min",
                "Pure alpha-1 agonist (no beta effect)"
            ]
        } else {
            needsInput = [.weightKg]
            details = [
                "Pure alpha-1 agonist (no beta effect)",
                "Range: 0.5-5 mcg/kg/min"
            ]
        }
        
        return NLMomentOutput(
            headline: "Hypotension (Pure Alpha)",
            subhead: "Phenylephrine Infusion",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: [
                "Causes reflex bradycardia",
                "Avoid in bradycardia",
                "Reduces cardiac output"
            ],
            needsInput: needsInput,
            clinicalPearls: [
                "Good for spinal-induced hypotension",
                "Pure vasoconstriction without inotropy",
                "May increase afterload in cardiac patients"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Dopamine Infusion
struct DopamineMoment: NLMoment {
    let id = "adult_dopamine"
    let title = "Dopamine Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["dopamine", "intropin"]
    let scenarioAliases = ["shock", "bradycardia", "hypotension", "vasopressor"]
    let tags = ["shock", "bradycardia", "hypotension", "vasopressor", "inotrope", 
                "chronotrope", "drip", "infusion"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var doseLine: String?
        var needsInput: [InputKey] = []
        var chips: [String] = ["IV Infusion"]
        var details: [String] = []
        
        if let weight = query.weightKg {
            // Standard concentration: 400 mg in 250 mL = 1600 mcg/mL
            let startDose = 5.0 // mcg/kg/min
            let concentration = 1600.0 // mcg/mL
            let startRateMLhr = (startDose * weight * 60) / concentration
            
            // Show calculated mL/hr as the primary display (changes with weight)
            doseLine = String(format: "%.1f mL/hr", startRateMLhr)
            chips.append(String(format: "%.0f mcg/kg/min", startDose))
            chips.append("1600 mcg/mL")
            chips.append(String(format: "%.0f kg", weight))
            
            // Show rates at different doses
            let lowRate = (2.0 * weight * 60) / concentration
            let highRate = (10.0 * weight * 60) / concentration
            
            details = [
                String(format: "At 2 mcg/kg/min: %.1f mL/hr (renal)", lowRate),
                String(format: "At 5 mcg/kg/min: %.1f mL/hr (beta)", startRateMLhr),
                String(format: "At 10 mcg/kg/min: %.1f mL/hr (alpha)", highRate),
                "2-5: Dopaminergic | 5-10: Beta | 10-20: Alpha"
            ]
        } else {
            needsInput = [.weightKg]
            details = ["Range: 2-20 mcg/kg/min"]
        }
        
        return NLMomentOutput(
            headline: "Shock / Bradycardia",
            subhead: "Dopamine Infusion",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: [
                "Arrhythmogenic at high doses",
                "Consider norepinephrine for septic shock"
            ],
            needsInput: needsInput,
            clinicalPearls: [
                "Less preferred for septic shock (use norepinephrine)",
                "Good for symptomatic bradycardia",
                "Monitor for tachyarrhythmias"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Dobutamine Infusion
struct DobutamineMoment: NLMoment {
    let id = "adult_dobutamine"
    let title = "Dobutamine Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["dobutamine", "dobutrex"]
    let scenarioAliases = ["cardiogenic", "shock", "low output", "inotrope"]
    let tags = ["cardiogenic shock", "low cardiac output", "inotrope", "heart failure",
                "drip", "infusion"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var doseLine: String?
        var needsInput: [InputKey] = []
        var chips: [String] = ["IV Infusion"]
        var details: [String] = []
        
        if let weight = query.weightKg {
            // Standard concentration: 250 mg in 250 mL = 1000 mcg/mL
            let startDose = 2.5 // mcg/kg/min
            let concentration = 1000.0 // mcg/mL
            let startRateMLhr = (startDose * weight * 60) / concentration
            
            // Show calculated mL/hr as primary (changes with weight)
            doseLine = String(format: "%.1f mL/hr", startRateMLhr)
            chips.append(String(format: "%.1f mcg/kg/min", startDose))
            chips.append("1000 mcg/mL")
            chips.append(String(format: "%.0f kg", weight))
            
            let midRate = (5.0 * weight * 60) / concentration
            let highRate = (10.0 * weight * 60) / concentration
            
            details = [
                String(format: "At 5 mcg/kg/min: %.1f mL/hr", midRate),
                String(format: "At 10 mcg/kg/min: %.1f mL/hr", highRate),
                "Range: 2.5-20 mcg/kg/min",
                "Titrate to cardiac output"
            ]
        } else {
            needsInput = [.weightKg]
            details = ["Range: 2.5-20 mcg/kg/min"]
        }
        
        return NLMomentOutput(
            headline: "Cardiogenic Shock / Low Output",
            subhead: "Dobutamine Infusion",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: [
                "May cause hypotension (vasodilation)",
                "Arrhythmogenic",
                "Not a vasopressor - may need norepinephrine"
            ],
            needsInput: needsInput,
            clinicalPearls: [
                "Pure inotrope - increases cardiac output",
                "Often paired with norepinephrine for cardiogenic shock",
                "Monitor for tachycardia and arrhythmias"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// =============================================================================
// MARK: - CARDIAC ARREST MOMENTS
// =============================================================================

// MARK: - Adult Cardiac Arrest Epinephrine
struct AdultCardiacArrestEpiMoment: NLMoment {
    let id = "adult_cardiac_arrest_epi"
    let title = "Adult Cardiac Arrest Epinephrine"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["epinephrine", "epi", "adrenalin"]
    let scenarioAliases = ["cardiac_arrest", "code", "vf", "vfib", "vt", "pvt", "asystole", "pea", "acls"]
    let tags = ["cardiac arrest", "code", "vf", "vfib", "ventricular fibrillation", 
                "pulseless vt", "asystole", "pea", "acls", "cpr"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        // Adult context boost (or no age specified)
        if query.ageYears == nil || (query.ageYears ?? 0) >= 18 {
            score += 2
        }
        // Reduce score if pediatric
        if let age = query.ageYears, age < 18 {
            score -= 5
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Adult Cardiac Arrest",
            subhead: "Epinephrine Push",
            doseLine: "1 mg",
            chips: ["IV/IO Push", "1:10,000", "Repeat q3-5 min"],
            details: [
                "Give immediately for non-shockable rhythms",
                "Give after 2nd shock for shockable rhythms",
                "Flush with 20 mL saline, elevate arm"
            ],
            warnings: [
                "Same dose for all adult patients",
                "No max dose in cardiac arrest"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Pediatric Cardiac Arrest Epinephrine
struct PediatricVFEpinephrineMoment: NLMoment {
    let id = "peds_vf_epinephrine"
    let title = "Pediatric VF/pVT Epinephrine"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["epinephrine", "epi", "adrenalin"]
    let scenarioAliases = ["vf_pvt", "vf", "vfib", "pvt", "cardiac_arrest", "code", "pals", "pediatric"]
    let tags = ["pediatric", "cardiac arrest", "code", "vf", "vfib", "pulseless vt",
                "asystole", "pea", "pals", "child", "infant"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.isPediatricIntent {
            score += 8
        } else if let age = query.ageYears, age < 18 {
            score += 5
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        var warnings: [String] = []
        var needsInput: [InputKey] = []
        var doseLine: String?
        var details: [String] = []
        var chips: [String] = ["IV/IO Push", "Repeat q3-5 min"]
        
        if let weightKg = query.weightKg {
            let result = PediatricDosingEngine.epinephrineCardiacArrest(weightKg: weightKg)
            doseLine = result.doseLine
            chips.append(result.concentrationLabel)
            chips.append(result.volumeLine)
            details = result.details
            warnings = result.warnings
        } else {
            needsInput.append(.weightKg)
            warnings.append("Weight required for dose calculation")
        }
        
        return NLMomentOutput(
            headline: "Pediatric Cardiac Arrest",
            subhead: "Epinephrine Push",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: warnings,
            needsInput: needsInput,
            clinicalPearls: [
                "Ensure high-quality CPR with minimal interruptions",
                "Consider reversible causes (H's and T's)",
                "Use 1:10,000 concentration for IV/IO"
            ],
            momentId: id,
            tags: tags,
            repeatInterval: "3-5 min",
            maxDose: "1 mg"
        )
    }
}

// MARK: - Pediatric Amiodarone (VF/pVT)
struct PediatricAmiodaroneVFMoment: NLMoment {
    let id = "peds_amiodarone_vf"
    let title = "Pediatric Amiodarone VF/pVT"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["amiodarone", "amio", "cordarone", "pacerone"]
    let scenarioAliases = ["vf", "vfib", "pvt", "vt", "cardiac_arrest", "refractory", "pals", "pediatric"]
    let tags = ["pediatric", "vf", "pulseless vt", "refractory", "antiarrhythmic", "cardiac arrest", "pals"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.isPediatricIntent {
            score += 8
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        var doseLine: String?
        var chips: [String] = ["IV/IO Push", "First Dose", "Slow Push over 2-3 min"]
        var details: [String] = []
        var warnings: [String] = ["May cause hypotension", "Dilute in D5W if time permits"]
        var needsInput: [InputKey] = []
        
        if let weightKg = query.weightKg {
            let result = PediatricDosingEngine.amiodaroneVF(weightKg: weightKg)
            doseLine = result.doseLine
            chips.append(result.concentrationLabel)
            chips.append(result.volumeLine)
            details = result.details
            warnings = result.warnings + ["May cause hypotension", "Dilute in D5W if time permits"]
        } else {
            needsInput = [.weightKg]
            details = ["Give after 3rd shock if VF/pVT persists", "Second dose 5 mg/kg if needed"]
        }
        
        return NLMomentOutput(
            headline: "Pediatric Shock-Refractory VF/pVT",
            subhead: "Amiodarone",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: warnings,
            needsInput: needsInput,
            clinicalPearls: [
                "PALS: 5 mg/kg IV/IO (max 300 mg)",
                "Give after 3rd shock",
                "Second dose 5 mg/kg if VF/pVT continues"
            ],
            momentId: id,
            tags: tags,
            maxDose: "300 mg"
        )
    }
}

// MARK: - Amiodarone (VF/pVT) — Adult
struct AmiodaroneVFMoment: NLMoment {
    let id = "adult_amiodarone_vf"
    let title = "Amiodarone for VF/pVT"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["amiodarone", "amio", "cordarone", "pacerone"]
    let scenarioAliases = ["vf", "vfib", "pvt", "vt", "cardiac_arrest", "refractory"]
    let tags = ["ventricular fibrillation", "vf", "pulseless vt", "refractory", 
                "antiarrhythmic", "cardiac arrest", "shock refractory"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.isPediatricIntent {
            score -= 8
        }
        if query.ageYears == nil || (query.ageYears ?? 0) >= 18 {
            score += 1
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Shock-Refractory VF/pVT",
            subhead: "Amiodarone",
            doseLine: "300 mg",
            chips: ["IV/IO Push", "First Dose", "Slow Push over 2-3 min"],
            details: [
                "First dose: 300 mg IV/IO push",
                "Second dose: 150 mg (if VF/pVT continues)",
                "Give after 3rd shock"
            ],
            warnings: [
                "May cause hypotension",
                "Dilute in D5W if time permits"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// =============================================================================
// MARK: - EMERGENCY PUSH MOMENTS
// =============================================================================

// MARK: - Anaphylaxis Epinephrine
struct AnaphylaxisEpinephrineMoment: NLMoment {
    let id = "anaphylaxis_epi"
    let title = "Anaphylaxis Epinephrine"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["epinephrine", "epi", "adrenalin", "epipen"]
    let scenarioAliases = ["anaphylaxis", "allergic", "allergy", "anaphylactic"]
    let tags = ["anaphylaxis", "allergic reaction", "severe allergy", "angioedema",
                "urticaria", "stridor", "hypotension", "im injection"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        // Strong boost for anaphylaxis keywords
        if query.normalized.contains("anaphyla") || query.normalized.contains("allerg") {
            score += 5
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        let isAdult = (query.ageYears ?? 18) >= 12
        let dose = isAdult ? "0.3-0.5 mg" : "0.01 mg/kg (max 0.3 mg)"
        
        var chips = ["IM", "1:1,000 (1 mg/mL)", "Anterolateral Thigh"]
        var details = [
            "Repeat every 5-15 min if needed",
            "May give IV 0.1 mg if refractory shock",
            "Position: legs elevated if hypotensive"
        ]
        
        if !isAdult {
            chips.append("Pediatric: 0.01 mg/kg")
            if let weight = query.weightKg {
                let pedsDose = min(0.01 * weight, 0.3)
                details.insert("Calculated: \(String(format: "%.2f", pedsDose)) mg", at: 0)
            }
        }
        
        return NLMomentOutput(
            headline: "Anaphylaxis",
            subhead: "Epinephrine IM",
            doseLine: dose,
            chips: chips,
            details: details,
            warnings: [
                "IM preferred over SubQ (faster absorption)",
                "Do not delay for IV access"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Adenosine (SVT)
struct AdenosineSVTMoment: NLMoment {
    let id = "adenosine_svt"
    let title = "Adenosine for SVT"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["adenosine", "adenocard"]
    let scenarioAliases = ["svt", "tachycardia", "narrow_complex", "psvt", "avnrt", "avrt"]
    let tags = ["svt", "supraventricular tachycardia", "narrow complex", "regular",
                "avnrt", "avrt", "wpw", "reentry"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("svt") || query.normalized.contains("tachycardia") {
            score += 3
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        let isAdult = (query.ageYears ?? 18) >= 18
        
        if isAdult {
            return NLMomentOutput(
                headline: "Stable SVT",
                subhead: "Adenosine",
                doseLine: "6 mg → 12 mg",
                chips: ["Rapid IV Push", "Large Bore IV", "Proximal to Heart"],
                details: [
                    "First dose: 6 mg rapid IV push",
                    "Second dose: 12 mg if no response (1-2 min)",
                    "Third dose: 12 mg if still no response",
                    "Follow immediately with 20 mL saline flush"
                ],
                warnings: [
                    "Contraindicated in WPW with atrial fibrillation",
                    "Warn patient: transient chest discomfort, flushing"
                ],
                momentId: id,
                tags: tags
            )
        } else {
            var doseLine = "0.1 mg/kg"
            if let weight = query.weightKg {
                let firstDose = min(0.1 * weight, 6.0)
                let secondDose = min(0.2 * weight, 12.0)
                doseLine = String(format: "%.1f mg → %.1f mg", firstDose, secondDose)
            }
            
            return NLMomentOutput(
                headline: "Pediatric SVT",
                subhead: "Adenosine",
                doseLine: doseLine,
                chips: ["Rapid IV Push", "Max 6 mg → 12 mg"],
                details: [
                    "First dose: 0.1 mg/kg (max 6 mg)",
                    "Second dose: 0.2 mg/kg (max 12 mg)",
                    "Follow with rapid saline flush"
                ],
                warnings: [
                    "Use proximal IV site",
                    "Record rhythm strip during administration"
                ],
                needsInput: query.weightKg == nil ? [.weightKg] : [],
                momentId: id,
                tags: tags
            )
        }
    }
}

// MARK: - Atropine (Bradycardia)
struct AtropineBradycardiaMoment: NLMoment {
    let id = "atropine_bradycardia"
    let title = "Atropine for Bradycardia"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["atropine"]
    let scenarioAliases = ["bradycardia", "brady", "symptomatic", "slow_heart"]
    let tags = ["bradycardia", "symptomatic", "heart block", "av block",
                "sinus bradycardia", "anticholinergic"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Symptomatic Bradycardia",
            subhead: "Atropine",
            doseLine: "0.5-1 mg",
            chips: ["IV Push", "Repeat q3-5 min", "Max 3 mg"],
            details: [
                "First-line for symptomatic bradycardia",
                "May repeat 0.5 mg every 3-5 min",
                "Total max: 3 mg (0.04 mg/kg)"
            ],
            warnings: [
                "Ineffective in infranodal block (Mobitz II, 3rd degree)",
                "Consider pacing if atropine fails"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Naloxone (Opioid Overdose)
struct NaloxoneMoment: NLMoment {
    let id = "naloxone_overdose"
    let title = "Naloxone for Opioid Overdose"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["naloxone", "narcan"]
    let scenarioAliases = ["overdose", "od", "opioid", "opiate", "narcotic", "heroin", "fentanyl"]
    let tags = ["opioid overdose", "narcotic reversal", "respiratory depression",
                "heroin", "fentanyl", "morphine", "oxycodone"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Opioid Overdose",
            subhead: "Naloxone",
            doseLine: "0.4-2 mg",
            chips: ["IV/IM/IN", "Repeat q2-3 min", "Max 10 mg"],
            details: [
                "IV preferred if access available",
                "Intranasal: 4 mg (2 mg each nostril)",
                "May repeat every 2-3 min as needed"
            ],
            warnings: [
                "May precipitate acute withdrawal",
                "Short half-life - patient may re-sedate",
                "Observe for at least 2 hours after last dose"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - D50W (Hypoglycemia)
struct DextroseHypoglycemiaMoment: NLMoment {
    let id = "dextrose_hypoglycemia"
    let title = "Dextrose for Hypoglycemia"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["dextrose", "d50", "d50w", "d10", "glucose"]
    let scenarioAliases = ["hypoglycemia", "low_sugar", "glucose", "altered"]
    let tags = ["hypoglycemia", "low blood sugar", "altered mental status",
                "diabetes", "insulin overdose", "seizure"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        let isAdult = (query.ageYears ?? 18) >= 18
        
        if isAdult {
            return NLMomentOutput(
                headline: "Hypoglycemia",
                subhead: "D50W",
                doseLine: "25-50 g (50-100 mL)",
                chips: ["IV Push", "Large Bore IV", "Recheck BG in 15 min"],
                details: [
                    "1 amp D50W = 25 g dextrose in 50 mL",
                    "May repeat if BG still low",
                    "Follow with carbohydrate snack if able to eat"
                ],
                warnings: [
                    "Vesicant - confirm IV patency",
                    "Use D10W if central line not available"
                ],
                momentId: id,
                tags: tags
            )
        } else {
            var doseLine = "2-4 mL/kg D10W"
            if let weight = query.weightKg {
                let volume = 2.0 * weight
                doseLine = String(format: "%.0f-%.0f mL D10W", volume, volume * 2)
            }
            
            return NLMomentOutput(
                headline: "Pediatric Hypoglycemia",
                subhead: "D10W",
                doseLine: doseLine,
                chips: ["IV Push", "D10W Preferred", "2-4 mL/kg"],
                details: [
                    "D10W preferred in pediatrics (less hypertonic)",
                    "D25W for older children",
                    "Never give D50W to neonates"
                ],
                warnings: [
                    "D50W can cause brain injury in neonates"
                ],
                needsInput: query.weightKg == nil ? [.weightKg] : [],
                momentId: id,
                tags: tags
            )
        }
    }
}

// =============================================================================
// MARK: - RSI / SEDATION MOMENTS
// =============================================================================

// MARK: - Rocuronium (RSI)
struct RocuroniumRSIMoment: NLMoment {
    let id = "rocuronium_rsi"
    let title = "Rocuronium for RSI"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["rocuronium", "zemuron", "roc"]
    let scenarioAliases = ["rsi", "intubation", "paralytic", "nmbr", "rapid_sequence"]
    let tags = ["rsi", "rapid sequence", "intubation", "paralytic", "neuromuscular blocker",
                "sugammadex reversible"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var doseLine: String?
        var details: [String] = []
        var needsInput: [InputKey] = []
        
        if let weight = query.weightKg {
            let dose = 1.2 * weight
            doseLine = String(format: "%.0f mg", dose)
            details = [
                "RSI dose: 1.2 mg/kg (ideal body weight)",
                "Onset: 45-60 seconds",
                "Duration: 45-70 minutes"
            ]
        } else {
            needsInput = [.weightKg]
        }
        
        return NLMomentOutput(
            headline: "Rapid Sequence Intubation",
            subhead: "Rocuronium",
            doseLine: doseLine,
            chips: ["IV Push", "1.2 mg/kg", "Reversible with Sugammadex"],
            details: details,
            warnings: [
                "Ensure ability to ventilate before giving",
                "Have sugammadex available"
            ],
            needsInput: needsInput,
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Succinylcholine (RSI)
struct SuccinylcholineRSIMoment: NLMoment {
    let id = "succinylcholine_rsi"
    let title = "Succinylcholine for RSI"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["succinylcholine", "sux", "anectine", "scoline"]
    let scenarioAliases = ["rsi", "intubation", "paralytic", "rapid_sequence"]
    let tags = ["rsi", "rapid sequence", "intubation", "paralytic", "depolarizing",
                "fastest onset"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var doseLine: String?
        var details: [String] = []
        var needsInput: [InputKey] = []
        
        if let weight = query.weightKg {
            let dose = 1.5 * weight
            doseLine = String(format: "%.0f mg", dose)
            details = [
                "RSI dose: 1.5 mg/kg (total body weight)",
                "Onset: 30-45 seconds (fastest)",
                "Duration: 5-10 minutes"
            ]
        } else {
            needsInput = [.weightKg]
        }
        
        return NLMomentOutput(
            headline: "Rapid Sequence Intubation",
            subhead: "Succinylcholine",
            doseLine: doseLine,
            chips: ["IV Push", "1.5 mg/kg", "Fastest Onset"],
            details: details,
            warnings: [
                "Contraindicated: burns >24h, crush injuries, hyperkalemia, myopathy",
                "Can cause malignant hyperthermia in susceptible patients",
                "Causes transient hyperkalemia (~0.5 mEq/L)"
            ],
            needsInput: needsInput,
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Etomidate (Induction)
struct EtomidateMoment: NLMoment {
    let id = "etomidate_induction"
    let title = "Etomidate for Induction"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["etomidate", "amidate"]
    let scenarioAliases = ["rsi", "induction", "intubation", "sedation"]
    let tags = ["induction", "rsi", "hemodynamically neutral", "sedation",
                "hypotensive patient"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        var doseLine: String?
        var needsInput: [InputKey] = []
        
        if let weight = query.weightKg {
            let dose = 0.3 * weight
            doseLine = String(format: "%.0f mg", dose)
        } else {
            needsInput = [.weightKg]
        }
        
        return NLMomentOutput(
            headline: "RSI Induction",
            subhead: "Etomidate",
            doseLine: doseLine,
            chips: ["IV Push", "0.3 mg/kg", "Hemodynamically Neutral"],
            details: [
                "Dose: 0.3 mg/kg IV",
                "Onset: 15-30 seconds",
                "Duration: 3-5 minutes",
                "Good choice for hypotensive patients"
            ],
            warnings: [
                "Causes transient adrenal suppression",
                "May lower seizure threshold"
            ],
            needsInput: needsInput,
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Ketamine (Induction/Sedation)
struct KetamineMoment: NLMoment {
    let id = "ketamine_induction"
    let title = "Ketamine"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["ketamine", "ketalar"]
    let scenarioAliases = ["rsi", "induction", "sedation", "dissociative", "asthma"]
    let tags = ["induction", "dissociative", "bronchodilation", "asthma",
                "procedural sedation", "hemodynamically supportive"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        var doseLine: String?
        var needsInput: [InputKey] = []
        
        if let weight = query.weightKg {
            let dose = 1.5 * weight
            doseLine = String(format: "%.0f mg", dose)
        } else {
            needsInput = [.weightKg]
        }
        
        return NLMomentOutput(
            headline: "RSI Induction / Procedural Sedation",
            subhead: "Ketamine",
            doseLine: doseLine,
            chips: ["IV Push", "1-2 mg/kg", "Dissociative"],
            details: [
                "RSI: 1-2 mg/kg IV",
                "Procedural sedation: 1-1.5 mg/kg IV",
                "IM: 4-5 mg/kg",
                "Causes bronchodilation - good for asthma"
            ],
            warnings: [
                "Relative contraindication: severe hypertension",
                "May cause emergence delirium",
                "Causes hypersalivation"
            ],
            needsInput: needsInput,
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Propofol
struct PropofolMoment: NLMoment {
    let id = "propofol_induction"
    let title = "Propofol"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["propofol", "diprivan"]
    let scenarioAliases = ["induction", "sedation", "intubation"]
    let tags = ["induction", "sedation", "hypnotic", "antiemetic", "status epilepticus"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        var doseLine: String?
        var needsInput: [InputKey] = []
        
        if let weight = query.weightKg {
            let dose = 1.5 * weight // Conservative starting dose
            doseLine = String(format: "%.0f mg", dose)
        } else {
            needsInput = [.weightKg]
        }
        
        return NLMomentOutput(
            headline: "Induction / Sedation",
            subhead: "Propofol",
            doseLine: doseLine,
            chips: ["IV Push", "1-2.5 mg/kg", "Short Acting"],
            details: [
                "Induction: 1-2.5 mg/kg IV (reduce in elderly/sick)",
                "Infusion: 25-75 mcg/kg/min",
                "Onset: 15-30 seconds"
            ],
            warnings: [
                "Causes significant hypotension",
                "Use lower doses in hypotensive/elderly patients",
                "Propofol infusion syndrome risk with prolonged use"
            ],
            needsInput: needsInput,
            momentId: id,
            tags: tags
        )
    }
}

// =============================================================================
// MARK: - ARRHYTHMIA MOMENTS
// =============================================================================

// MARK: - AFib / AFib with RVR
struct AFibMoment: NLMoment {
    let id = "afib_management"
    let title = "Atrial Fibrillation"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["diltiazem", "cardizem", "metoprolol", "lopressor", "amiodarone"]
    let scenarioAliases = ["afib", "afib_rvr", "aflutter", "atrial", "rvr", "rate control"]
    let tags = ["afib", "atrial fibrillation", "rvr", "rapid ventricular response", 
                "rate control", "irregularly irregular", "arrhythmia", "aflutter", "flutter"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        // Boost for arrhythmia keywords
        let arrhythmiaTerms = ["afib", "aflutter", "rvr", "irregular", "atrial"]
        for term in arrhythmiaTerms {
            if query.normalized.contains(term) { score += 3 }
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var chips: [String] = ["Rate Control First"]
        var details: [String] = []
        var needsInput: [InputKey] = []
        var doseLine: String?
        
        let isRVR = query.normalized.contains("rvr") || 
                    query.normalized.contains("rapid") ||
                    query.normalized.contains("fast")
        
        if let weight = query.weightKg {
            // Diltiazem bolus calculation
            let diltiazemBolus = 0.25 * weight
            doseLine = String(format: "Diltiazem %.0f mg", diltiazemBolus)
            chips.append("IV over 2 min")
            
            details = [
                "Diltiazem: 0.25 mg/kg IV bolus over 2 min",
                "May repeat 0.35 mg/kg in 15 min if needed",
                "Drip: 5-15 mg/hr after rate controlled",
                "Alternative: Metoprolol 5 mg IV q5min (max 15 mg)"
            ]
        } else {
            needsInput = [.weightKg]
            details = [
                "Diltiazem: 0.25 mg/kg IV bolus",
                "Metoprolol: 5 mg IV q5min (max 15 mg)"
            ]
        }
        
        return NLMomentOutput(
            headline: isRVR ? "AFib with RVR" : "Atrial Fibrillation",
            subhead: "Rate Control",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: [
                "Avoid rate control agents in WPW + AFib",
                "Check for hypotension before CCB/BB",
                "Consider anticoagulation if >48h or unknown duration"
            ],
            needsInput: needsInput,
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Torsades / Polymorphic VT
struct TorsadesMoment: NLMoment {
    let id = "torsades_management"
    let title = "Torsades de Pointes"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["magnesium", "mag"]
    let scenarioAliases = ["torsades", "polymorphic", "long_qt", "tdp"]
    let tags = ["torsades", "polymorphic vt", "long qt", "magnesium", "twisting",
                "arrhythmia", "wide complex", "qt prolongation"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("torsade") || query.normalized.contains("polymorphic") {
            score += 5
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Polymorphic VT / Long QT",
            subhead: "Torsades de Pointes",
            doseLine: "Magnesium 2g IV",
            chips: ["IV Push", "Over 2-5 min", "May repeat"],
            details: [
                "First line: Magnesium 2g IV over 2-5 min",
                "May give faster if pulseless",
                "Repeat x1 in 15 min if needed",
                "If pulseless: DEFIBRILLATE (not synchronized)"
            ],
            warnings: [
                "Do NOT give amiodarone (prolongs QT)",
                "Overdrive pace if refractory",
                "Stop all QT-prolonging drugs"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Wide Complex Tachycardia / VT with Pulse
struct VTachWithPulseMoment: NLMoment {
    let id = "vtach_pulse_management"
    let title = "VT with Pulse"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["amiodarone", "lidocaine", "procainamide"]
    let scenarioAliases = ["vtach_pulse", "wide_complex", "monomorphic", "vt"]
    let tags = ["vt with pulse", "wide complex tachycardia", "monomorphic vt", 
                "arrhythmia", "antiarrhythmic", "cardioversion"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("wide") || query.normalized.contains("vtach") {
            score += 3
        }
        if query.normalized.contains("pulse") || query.normalized.contains("stable") {
            score += 2
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        let isUnstable = query.normalized.contains("unstable") || 
                         query.normalized.contains("hypotensive")
        
        if isUnstable {
            return NLMomentOutput(
                headline: "Unstable VT with Pulse",
                subhead: "Synchronized Cardioversion",
                doseLine: "100-200 J",
                chips: ["Synchronized", "Sedate if Awake", "Biphasic"],
                details: [
                    "Synchronized cardioversion is first line if unstable",
                    "Sedate if time permits (etomidate, midazolam)",
                    "Start at 100J biphasic, increase if ineffective"
                ],
                warnings: [
                    "Ensure SYNCHRONIZED mode",
                    "Have pads/pacing ready",
                    "Push SYNC before each shock"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        return NLMomentOutput(
            headline: "Stable VT with Pulse",
            subhead: "Antiarrhythmic Therapy",
            doseLine: "Amiodarone 150 mg",
            chips: ["IV over 10 min", "Then 1 mg/min x 6h"],
            details: [
                "Amiodarone 150 mg IV over 10 min",
                "Then 1 mg/min x 6 hours, then 0.5 mg/min x 18h",
                "Alternative: Lidocaine 1-1.5 mg/kg IV",
                "Cardioversion if drugs fail"
            ],
            warnings: [
                "Have defibrillator ready",
                "If patient decompensates → immediate cardioversion"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// =============================================================================
// MARK: - SEDATION INFUSION MOMENTS
// =============================================================================

// MARK: - Propofol Infusion (ICU Sedation)
struct PropofolInfusionMoment: NLMoment {
    let id = "propofol_infusion"
    let title = "Propofol Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["propofol", "diprivan"]
    let scenarioAliases = ["sedation", "icu", "ventilator", "intubated", "agitation"]
    let tags = ["sedation", "icu sedation", "propofol", "drip", "infusion", "ventilator",
                "rass", "intubated"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("sedation") || query.normalized.contains("drip") {
            score += 3
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var doseLine: String?
        var needsInput: [InputKey] = []
        var chips: [String] = ["IV Infusion"]
        var details: [String] = []
        
        if let weight = query.weightKg {
            // Propofol 10 mg/mL (1%)
            let startDose = 25.0 // mcg/kg/min
            let startRateMLhr = (startDose * weight * 60) / 10000
            
            // Show calculated mL/hr as primary (changes with weight)
            doseLine = String(format: "%.1f mL/hr", startRateMLhr)
            chips.append(String(format: "%.0f mcg/kg/min", startDose))
            chips.append("10 mg/mL")
            chips.append(String(format: "%.0f kg", weight))
            
            let midRate = (50.0 * weight * 60) / 10000
            let highRate = (75.0 * weight * 60) / 10000
            
            details = [
                String(format: "At 50 mcg/kg/min: %.1f mL/hr", midRate),
                String(format: "At 75 mcg/kg/min: %.1f mL/hr", highRate),
                "Range: 5-80 mcg/kg/min",
                "Target RASS: -2 to 0"
            ]
        } else {
            needsInput = [.weightKg]
            details = ["Range: 5-80 mcg/kg/min"]
        }
        
        return NLMomentOutput(
            headline: "ICU Sedation",
            subhead: "Propofol Infusion",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: [
                "Propofol infusion syndrome risk >48h",
                "Check triglycerides q48h",
                "Causes hypotension"
            ],
            needsInput: needsInput,
            clinicalPearls: [
                "Daily sedation awakening trials",
                "Caloric content: 1.1 kcal/mL",
                "Fast offset - good for neuro exams"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Dexmedetomidine (Precedex) Infusion
struct DexmedetomidineInfusionMoment: NLMoment {
    let id = "dexmedetomidine_infusion"
    let title = "Dexmedetomidine Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["dexmedetomidine", "precedex", "dex"]
    let scenarioAliases = ["sedation", "icu", "delirium", "extubation", "agitation"]
    let tags = ["sedation", "icu sedation", "precedex", "delirium", "drip", "infusion",
                "cooperative sedation", "extubation"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("sedation") || query.normalized.contains("delirium") {
            score += 3
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var doseLine: String?
        var needsInput: [InputKey] = []
        var chips: [String] = ["IV Infusion"]
        var details: [String] = []
        
        if let weight = query.weightKg {
            // Standard: 200 mcg in 50 mL = 4 mcg/mL
            let startDose = 0.4 // mcg/kg/hr
            let concentration = 4.0 // mcg/mL
            let startRateMLhr = (startDose * weight) / concentration
            
            // Show calculated mL/hr as primary (changes with weight)
            doseLine = String(format: "%.1f mL/hr", startRateMLhr)
            chips.append(String(format: "%.1f mcg/kg/hr", startDose))
            chips.append("4 mcg/mL")
            chips.append(String(format: "%.0f kg", weight))
            
            let midRate = (0.7 * weight) / concentration
            let highRate = (1.0 * weight) / concentration
            
            details = [
                String(format: "At 0.7 mcg/kg/hr: %.1f mL/hr", midRate),
                String(format: "At 1.0 mcg/kg/hr: %.1f mL/hr", highRate),
                "Range: 0.2-1.5 mcg/kg/hr",
                "No respiratory depression"
            ]
        } else {
            needsInput = [.weightKg]
            details = ["Range: 0.2-1.5 mcg/kg/hr"]
        }
        
        return NLMomentOutput(
            headline: "ICU Sedation / Delirium",
            subhead: "Dexmedetomidine",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: [
                "Causes bradycardia and hypotension",
                "Avoid loading dose if unstable",
                "Not for deep sedation"
            ],
            needsInput: needsInput,
            clinicalPearls: [
                "Reduces delirium incidence",
                "Patients arousable - good for neuro exams",
                "Can use during extubation"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Fentanyl Infusion
struct FentanylInfusionMoment: NLMoment {
    let id = "fentanyl_infusion"
    let title = "Fentanyl Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["fentanyl", "sublimaze"]
    let scenarioAliases = ["sedation", "pain", "analgesia", "icu", "ventilator"]
    let tags = ["sedation", "analgesia", "pain", "opioid", "drip", "infusion", "icu"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("pain") || query.normalized.contains("analgesia") {
            score += 3
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "ICU Analgesia",
            subhead: "Fentanyl Infusion",
            doseLine: "25-100 mcg/hr",
            chips: ["IV Infusion", "Titrate to Pain Score"],
            details: [
                "Range: 25-200 mcg/hr",
                "Bolus: 25-100 mcg IV PRN",
                "Standard concentration: 10 mcg/mL",
                "Analgesia-first sedation approach"
            ],
            warnings: [
                "Respiratory depression",
                "Accumulates in renal failure",
                "Tolerance develops with prolonged use"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Cisatracurium Infusion (Paralytic)
struct CisatracuriumInfusionMoment: NLMoment {
    let id = "cisatracurium_infusion"
    let title = "Cisatracurium Infusion"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = [.weightKg]
    
    let drugAliases = ["cisatracurium", "nimbex"]
    let scenarioAliases = ["paralytic", "ards", "ventilator", "dyssynchrony", "nmba"]
    let tags = ["paralytic", "nmba", "neuromuscular blockade", "ards", "drip", "infusion",
                "ventilator dyssynchrony", "train of four"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("paralytic") || query.normalized.contains("nmba") {
            score += 5
        }
        if query.normalized.contains("ards") || query.normalized.contains("dyssynchrony") {
            score += 3
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        // Check if pediatric - redirect to pediatric medication section
        if isPediatric(query) {
            return NLMomentOutput(
                headline: "Pediatric Patient",
                subhead: "Use Pediatric Medication Section",
                doseLine: nil,
                chips: ["Pediatric", "Age < 18"],
                details: [
                    "This is an adult dosing moment.",
                    "For pediatric patients, please use the Pediatric Medication section in the app.",
                    "Pediatric dosing requires weight-based calculations specific to age and weight ranges."
                ],
                warnings: [
                    "Do not use adult weight-based dosing for pediatric patients"
                ],
                needsInput: [],
                clinicalPearls: [
                    "Navigate to: Pediatrics → Medication Section",
                    "Pediatric dosing is weight and age-specific",
                    "Use PALS guidelines for pediatric cardiac arrest"
                ],
                momentId: id,
                tags: tags
            )
        }
        
        var doseLine: String?
        var needsInput: [InputKey] = []
        var chips: [String] = ["IV Infusion", "Monitor TOF"]
        var details: [String] = []
        
        if let weight = query.weightKg {
            // Standard: 200 mg in 200 mL = 1 mg/mL = 1000 mcg/mL
            let startDose = 2.0 // mcg/kg/min
            let concentration = 1000.0 // mcg/mL
            let startRateMLhr = (startDose * weight * 60) / concentration
            
            // Show calculated mL/hr as primary (changes with weight)
            doseLine = String(format: "%.1f mL/hr", startRateMLhr)
            chips.append(String(format: "%.0f mcg/kg/min", startDose))
            chips.append("1 mg/mL")
            chips.append(String(format: "%.0f kg", weight))
            
            let lowRate = (1.0 * weight * 60) / concentration
            let highRate = (3.0 * weight * 60) / concentration
            
            details = [
                String(format: "At 1 mcg/kg/min: %.1f mL/hr", lowRate),
                String(format: "At 3 mcg/kg/min: %.1f mL/hr", highRate),
                "Target TOF: 1-2/4",
                "Bolus: 0.1-0.2 mg/kg IV"
            ]
        } else {
            needsInput = [.weightKg]
            details = ["Range: 1-3 mcg/kg/min"]
        }
        
        return NLMomentOutput(
            headline: "ARDS / Vent Dyssynchrony",
            subhead: "Cisatracurium Infusion",
            doseLine: doseLine,
            chips: chips,
            details: details,
            warnings: [
                "MUST sedate adequately BEFORE paralyzing",
                "Eye care q4h",
                "DVT prophylaxis critical"
            ],
            needsInput: needsInput,
            clinicalPearls: [
                "Organ-independent metabolism (Hofmann)",
                "Safe in renal/hepatic failure",
                "Daily TOF monitoring required"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// =============================================================================
// MARK: - ACLS 2025 GUIDELINES MOMENTS
// =============================================================================

// MARK: - ACLS 2025 Master Summary Moment
struct ACLS2025MasterMoment: NLMoment {
    let id = "acls_2025_master"
    let title = "ACLS 2025 Guidelines - Master Summary"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["acls 2025", "aha guidelines", "cardiac arrest", "resuscitation", "cpr", 
                "2025 update", "guidelines", "acls protocol"]
    let scenarioAliases = ["acls", "cardiac arrest", "code", "resuscitation", "cpr"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        if query.normalized.contains("2025") || query.normalized.contains("acls") {
            score += 5
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "ACLS 2025 Guidelines",
            subhead: "Comprehensive Overview",
            doseLine: nil,
            chips: ["2025 Update", "AHA Guidelines", "Protocol"],
            details: [
                "Vascular Access: IV first-line, IO if IV fails",
                "Epinephrine: After initial defib fails (shockable), ASAP (non-shockable)",
                "DSD/VCD: Usefulness not established after 3+ shocks",
                "Mechanical CPR: Not routine, only when manual unsafe",
                "Head-up CPR: Not recommended outside trials",
                "AF Cardioversion: ≥200J biphasic initial",
                "Bradycardia: Transvenous pacing for refractory",
                "Post-ROSC: MAP ≥65, temp control ≥36h, SpO2 90-98%",
                "Airway: Defer advanced airway if interrupts CPR"
            ],
            warnings: [],
            needsInput: [],
            clinicalPearls: [
                "Key change: IV first-line for vascular access",
                "Epinephrine timing differs for shockable vs non-shockable",
                "DSD/VCD not established after multiple shocks",
                "Post-ROSC targets: MAP ≥65 (not SBP >90)"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Defibrillation Moment 2025
struct DefibrillationMoment2025: NLMoment {
    let id = "defibrillation_2025"
    let title = "Defibrillation 2025 (VF/pVT)"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["defibrillation", "vf", "vfib", "pvt", "ventricular fibrillation", 
                "pulseless vt", "shock", "2025"]
    let scenarioAliases = ["vf", "vfib", "pvt", "ventricular fibrillation", "pulseless vt"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "VF/pVT Defibrillation",
            subhead: "2025 Guidelines",
            doseLine: "120-200 J biphasic",
            chips: ["Immediate Defibrillation", "Standard Energy", "2025 Update"],
            details: [
                "Immediate defibrillation for VF/pVT",
                "Standard biphasic: 120-200J",
                "After 3+ shocks: DSD and VCD have uncertain usefulness",
                "DSD/VCD not established as standard practice"
            ],
            warnings: [
                "Do not delay defibrillation for vascular access",
                "DSD/VCD after 3+ shocks is not routinely recommended"
            ],
            needsInput: [],
            clinicalPearls: [
                "Key 2025 change: DSD/VCD uncertainty after 3+ shocks",
                "Continue standard defibrillation protocol",
                "Consider escalating energy if initial shocks fail"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Vascular Access Moment 2025
struct VascularAccessMoment2025: NLMoment {
    let id = "vascular_access_2025"
    let title = "Vascular Access 2025"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["vascular access", "iv", "io", "intraosseous", "access", "2025"]
    let scenarioAliases = ["vascular access", "iv access", "io access"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Vascular Access",
            subhead: "2025 Guidelines",
            doseLine: "IV First-Line",
            chips: ["IV Preferred", "IO Alternative", "2025 Update"],
            details: [
                "IV access is first-line for medication administration",
                "If IV unsuccessful or delayed: use IO access",
                "IO provides reliable medication delivery",
                "Do not delay critical interventions for access"
            ],
            warnings: [],
            needsInput: [],
            clinicalPearls: [
                "Key 2025 change: IV first-line, IO if IV fails",
                "IO is acceptable alternative, not last resort",
                "Both routes deliver medications effectively"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Epinephrine Moment 2025
struct EpinephrineMoment2025: NLMoment {
    let id = "epinephrine_2025"
    let title = "Epinephrine 2025 (Cardiac Arrest)"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["epinephrine", "epi", "adrenalin"]
    let scenarioAliases = ["cardiac arrest", "vf", "vfib", "pvt", "asystole", "pea", "code"]
    let tags = ["epinephrine", "cardiac arrest", "vasopressor", "2025", "timing"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Cardiac Arrest",
            subhead: "Epinephrine 2025",
            doseLine: "1 mg IV/IO",
            chips: ["q3-5 min", "1:10,000", "2025 Update"],
            details: [
                "Shockable rhythms (VF/pVT): Give after initial defibrillation attempts fail",
                "Non-shockable rhythms (asystole/PEA): Give as soon as possible",
                "Standard dose: 1 mg IV/IO q3-5 min",
                "Flush with 20 mL saline, elevate arm"
            ],
            warnings: [
                "Timing differs for shockable vs non-shockable rhythms",
                "Same dose for all adult patients"
            ],
            needsInput: [],
            clinicalPearls: [
                "Key 2025 change: Timing based on rhythm type",
                "Shockable: after defib fails",
                "Non-shockable: ASAP"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Antiarrhythmic Moment 2025
struct AntiarrhythmicMoment2025: NLMoment {
    let id = "antiarrhythmic_2025"
    let title = "Antiarrhythmics 2025 (VF/pVT)"
    let kind: NLMomentKind = .drugDosing
    let requiredInputs: Set<InputKey> = []
    
    let drugAliases = ["amiodarone", "lidocaine", "cordarone"]
    let scenarioAliases = ["vf", "vfib", "pvt", "refractory", "shock refractory"]
    let tags = ["antiarrhythmic", "amiodarone", "lidocaine", "refractory vf", "2025"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Shock-Refractory VF/pVT",
            subhead: "Antiarrhythmics 2025",
            doseLine: "Amiodarone 300 mg or Lidocaine",
            chips: ["IV/IO", "After 3rd Shock", "2025 Update"],
            details: [
                "Amiodarone 300 mg IV/IO first dose",
                "Or Lidocaine 1-1.5 mg/kg IV/IO",
                "Second dose Amiodarone: 150 mg if VF/pVT continues",
                "Benefit of other antiarrhythmics remains uncertain"
            ],
            warnings: [
                "Give after 3rd shock",
                "Uncertain benefit of other antiarrhythmic medications"
            ],
            needsInput: [],
            clinicalPearls: [
                "Amiodarone or lidocaine may be considered",
                "Other antiarrhythmics have uncertain benefit",
                "Continue high-quality CPR"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - CPR Adjuncts Moment 2025
struct CPRAdjunctsMoment2025: NLMoment {
    let id = "cpr_adjuncts_2025"
    let title = "CPR Adjuncts 2025"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["cpr", "mechanical cpr", "head up cpr", "adjuncts", "2025"]
    let scenarioAliases = ["cpr", "mechanical cpr", "head up"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "CPR Adjuncts",
            subhead: "2025 Guidelines",
            doseLine: nil,
            chips: ["Not Routine", "2025 Update"],
            details: [
                "Mechanical CPR: Not recommended for routine use",
                "Mechanical CPR may be considered when manual CPR is unsafe or not feasible",
                "Examples: during transport, prolonged resuscitation",
                "Head-up CPR: Not recommended outside of clinical trials",
                "Standard supine CPR remains standard of care"
            ],
            warnings: [
                "Do not use mechanical CPR routinely",
                "Head-up CPR only in clinical trials"
            ],
            needsInput: [],
            clinicalPearls: [
                "Key 2025 change: Mechanical CPR not routine",
                "Head-up CPR not recommended outside trials",
                "High-quality manual CPR remains standard"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Airway Management Moment 2025
struct AirwayManagementMoment2025: NLMoment {
    let id = "airway_management_2025"
    let title = "Advanced Airway 2025"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["airway", "intubation", "eti", "sga", "capnography", "2025"]
    let scenarioAliases = ["airway", "intubation", "eti", "sga"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Advanced Airway Management",
            subhead: "2025 Guidelines",
            doseLine: nil,
            chips: ["ETI Experience", "SGA Acceptable", "Capnography", "2025 Update"],
            details: [
                "Endotracheal intubation (ETI): Should be performed by experienced providers",
                "If ETI interrupts high-quality CPR: Consider deferring advanced airway",
                "Supraglottic airways (SGA): Acceptable alternatives to ETI",
                "SGA especially useful if intubation delayed or unsuccessful",
                "Continuous waveform capnography: Recommended to confirm ETI placement"
            ],
            warnings: [
                "Do not interrupt CPR for airway if inexperienced",
                "Capnography essential for confirming placement"
            ],
            needsInput: [],
            clinicalPearls: [
                "Key 2025 change: Defer airway if interrupts CPR",
                "SGA is acceptable alternative",
                "Capnography for confirmation and monitoring"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Termination of Resuscitation Moment 2025
struct TORMoment2025: NLMoment {
    let id = "tor_2025"
    let title = "Termination of Resuscitation 2025"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["termination", "tor", "resuscitation", "bls", "als", "2025"]
    let scenarioAliases = ["termination", "tor", "stop resuscitation"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Termination of Resuscitation",
            subhead: "2025 Guidelines",
            doseLine: nil,
            chips: ["BLS Rules", "ALS Rules", "Universal Rules", "2025 Update"],
            details: [
                "BLS Termination: May terminate if no ROSC after full BLS protocol, no shockable rhythm, no obvious reversible causes",
                "ALS Termination: May consider termination if no ROSC after full ACLS protocol, no shockable rhythm, no reversible causes",
                "Universal Termination: Consider if unwitnessed arrest, no bystander CPR, no shockable rhythm, no ROSC after full protocol"
            ],
            warnings: [
                "Follow local protocols and regulations",
                "Consider family wishes and clinical context"
            ],
            needsInput: [],
            clinicalPearls: [
                "BLS and ALS have different termination criteria",
                "Universal rules apply to all providers",
                "Consider reversible causes before termination"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Wide Complex Tachycardia Moment 2025
struct WideComplexTachyMoment2025: NLMoment {
    let id = "wct_2025"
    let title = "Wide Complex Tachycardia 2025"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["wct", "wide complex", "vt", "ventricular tachycardia", "cardioversion", "2025"]
    let scenarioAliases = ["wct", "wide complex", "vt", "ventricular tachycardia"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Wide Complex Tachycardia",
            subhead: "2025 Guidelines",
            doseLine: "Synchronized Cardioversion",
            chips: ["Unstable: Cardioversion", "Stable: Consider Adenosine", "2025 Update"],
            details: [
                "Unstable WCT: Synchronized cardioversion recommended (100-200J)",
                "Stable, regular, monomorphic WCT: Adenosine may be considered",
                "Do NOT give verapamil or diltiazem for WCT",
                "Sedate if conscious before cardioversion"
            ],
            warnings: [
                "Never give verapamil/diltiazem for WCT",
                "Ensure synchronized mode for cardioversion",
                "Adenosine only for stable, regular, monomorphic WCT"
            ],
            needsInput: [],
            clinicalPearls: [
                "Key 2025 change: Adenosine may be considered for stable WCT",
                "Synchronized cardioversion for unstable",
                "Avoid CCBs in WCT"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Narrow Complex Tachycardia Moment 2025
struct NarrowComplexTachyMoment2025: NLMoment {
    let id = "nct_2025"
    let title = "Narrow Complex Tachycardia 2025"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["nct", "narrow complex", "svt", "supraventricular", "adenosine", "2025"]
    let scenarioAliases = ["nct", "narrow complex", "svt", "supraventricular"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Narrow Complex Tachycardia",
            subhead: "2025 Guidelines",
            doseLine: "Vagal Maneuvers → Adenosine",
            chips: ["Stable: Vagal/Adenosine", "Unstable: Cardioversion", "2025 Update"],
            details: [
                "Stable NCT: Vagal maneuvers and adenosine remain first-line",
                "Adenosine: 6 mg → 12 mg rapid IV push",
                "Avoid calcium channel blockers in patients with reduced EF or systolic heart failure",
                "Unstable NCT: Synchronized cardioversion (100-200J)"
            ],
            warnings: [
                "Avoid CCBs in reduced EF/systolic heart failure",
                "Contraindicated in WPW with AFib"
            ],
            needsInput: [],
            clinicalPearls: [
                "Key 2025 change: CCB caution in heart failure",
                "Vagal maneuvers and adenosine first-line",
                "Cardioversion for unstable"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Atrial Fibrillation/Flutter Moment 2025
struct AFibFlutterMoment2025: NLMoment {
    let id = "afib_flutter_2025"
    let title = "Atrial Fibrillation/Flutter 2025"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["afib", "aflutter", "atrial fibrillation", "atrial flutter", "cardioversion", "2025"]
    let scenarioAliases = ["afib", "aflutter", "atrial fibrillation", "atrial flutter"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Atrial Fibrillation/Flutter",
            subhead: "Cardioversion 2025",
            doseLine: "≥200 J biphasic",
            chips: ["Initial Energy", "Avoid in Preexcitation", "2025 Update"],
            details: [
                "Cardioversion energy: Start at ≥200 J biphasic (increased from 50J)",
                "Atrial Flutter: Initial 200 J may be reasonable",
                "Double synchronized cardioversion has uncertain usefulness",
                "Avoid cardioversion in preexcitation (WPW) - use antiarrhythmics instead",
                "Avoid digoxin, CCBs, BBs, IV amiodarone in preexcitation"
            ],
            warnings: [
                "Key 2025 change: ≥200J initial (was 50J)",
                "Do not use rate control agents in WPW + AFib",
                "Double cardioversion uncertain benefit"
            ],
            needsInput: [],
            clinicalPearls: [
                "Significant energy increase: ≥200J initial",
                "Preexcitation requires special consideration",
                "Rate control first in stable patients"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Bradycardia Moment 2025
struct BradycardiaMoment2025: NLMoment {
    let id = "bradycardia_2025"
    let title = "Bradycardia 2025"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["bradycardia", "brady", "pacing", "transvenous", "2025"]
    let scenarioAliases = ["bradycardia", "brady", "slow heart"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Symptomatic Bradycardia",
            subhead: "2025 Guidelines",
            doseLine: "Atropine → Pacing",
            chips: ["Atropine First", "Transvenous Pacing", "2025 Update"],
            details: [
                "First-line: Atropine 0.5-1 mg IV (may repeat q3-5min, max 3mg)",
                "If no response: Transcutaneous pacing",
                "For refractory symptomatic bradycardia: Temporary transvenous pacing may be considered",
                "Reversible causes: Ischemia, hypoxemia, hypothyroidism, infections, medications, electrolyte abnormalities"
            ],
            warnings: [
                "Atropine ineffective in infranodal block",
                "Consider pacing if atropine fails"
            ],
            needsInput: [],
            clinicalPearls: [
                "Key 2025 change: Transvenous pacing for refractory",
                "Treat reversible causes",
                "Consider permanent pacing if indicated"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Post-ROSC Care Moment 2025
struct PostROSCMoment2025: NLMoment {
    let id = "post_rosc_2025"
    let title = "Post-ROSC Care 2025"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["post rosc", "rosc", "post arrest", "temperature", "map", "spo2", "2025"]
    let scenarioAliases = ["post rosc", "rosc", "post arrest"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        return baseMatchScore(query)
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Post-ROSC Care",
            subhead: "2025 Guidelines",
            doseLine: nil,
            chips: ["MAP ≥65", "SpO2 90-98%", "Temp Control ≥36h", "2025 Update"],
            details: [
                "Hemodynamic target: MAP ≥65 mmHg (changed from SBP >90)",
                "Oxygenation: Target SpO2 90-98% (avoid hyperoxia)",
                "Temperature control: Maintain for at least 36 hours post-ROSC",
                "Glucose: Avoid hypoglycemia (<70) and hyperglycemia (>180)",
                "12-lead EKG: Obtain immediately, cath lab if STEMI",
                "Labs: Lactate, troponin, ABG"
            ],
            warnings: [
                "Key 2025 change: MAP ≥65 (not SBP >90)",
                "Avoid both hypoxia and hyperoxia",
                "Maintain temperature control ≥36 hours"
            ],
            needsInput: [],
            clinicalPearls: [
                "MAP target changed from SBP >90 to MAP ≥65",
                "SpO2 90-98% (narrower range)",
                "Extended temperature control duration"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// =============================================================================
// MARK: - VENTILATOR TROUBLESHOOTING MOMENTS
// =============================================================================

// MARK: - Low SpO2 / Hypoxemia Moment
struct LowSpO2Moment: NLMoment {
    let id = "low_spo2_hypoxemia"
    let title = "Low SpO2 / Hypoxemia"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["low spo2", "hypoxemia", "desaturation", "oxygenation", "ventilator", 
                "spo2", "hypoxia", "oxygen", "vent", "respiratory"]
    let scenarioAliases = ["low spo2", "hypoxemia", "desaturation", "low oxygen", "hypoxia"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        let hypoxemiaTerms = ["low spo2", "hypoxemia", "desaturation", "low oxygen", "hypoxia", "spo2"]
        for term in hypoxemiaTerms {
            if query.normalized.contains(term) {
                score += 5
            }
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Ventilator Troubleshooting",
            subhead: "Low SpO2 / Hypoxemia",
            doseLine: nil,
            chips: ["Check DOPE", "Increase FiO2", "Increase PEEP", "Ventilator Settings"],
            details: [
                "DOPE mnemonic: Displacement (tube), Obstruction, Pneumothorax, Equipment failure",
                "Immediate: Increase FiO2 to 100%",
                "Increase PEEP: Start at 5-8, may need 10-15 for ARDS",
                "Check tube position: CXR, capnography, auscultation",
                "Check for pneumothorax: Asymmetric breath sounds, tracheal deviation",
                "Consider recruitment maneuvers if ARDS",
                "Check for secretions: Suction if needed",
                "Verify ventilator circuit integrity"
            ],
            warnings: [
                "Rule out pneumothorax immediately (life-threatening)",
                "Check tube position before adjusting settings",
                "High PEEP can cause hypotension"
            ],
            needsInput: [],
            clinicalPearls: [
                "DOPE mnemonic for rapid assessment",
                "FiO2 first, then PEEP",
                "ARDS: May need PEEP 10-15 cmH₂O",
                "Check tube position with CXR and capnography",
                "Consider prone positioning for severe ARDS"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - High CO2 / Hypercapnia Moment
struct HighCO2Moment: NLMoment {
    let id = "high_co2_hypercapnia"
    let title = "High CO2 / Hypercapnia"
    let kind: NLMomentKind = .protocol
    let requiredInputs: Set<InputKey> = []
    
    let tags = ["high co2", "hypercapnia", "elevated co2", "ventilator", "ventilation",
                "paco2", "etco2", "co2", "respiratory acidosis", "vent"]
    let scenarioAliases = ["high co2", "hypercapnia", "elevated co2", "high pco2", "respiratory acidosis"]
    
    func matchScore(_ query: ParsedQuery) -> Int {
        var score = baseMatchScore(query)
        let hypercapniaTerms = ["high co2", "hypercapnia", "elevated co2", "high pco2", "respiratory acidosis"]
        for term in hypercapniaTerms {
            if query.normalized.contains(term) {
                score += 5
            }
        }
        return score
    }
    
    func compute(_ query: ParsedQuery) -> NLMomentOutput {
        return NLMomentOutput(
            headline: "Ventilator Troubleshooting",
            subhead: "High CO2 / Hypercapnia",
            doseLine: nil,
            chips: ["Increase Rate", "Increase TV", "Check Dead Space", "Ventilator Settings"],
            details: [
                "Increase minute ventilation: Increase respiratory rate or tidal volume",
                "Respiratory rate: Increase by 2-4 breaths/min (max 30-35)",
                "Tidal volume: Increase if <6 mL/kg IBW (max 8 mL/kg IBW)",
                "Check for increased dead space: Circuit length, HME, tubing",
                "Check for auto-PEEP: May need longer expiratory time",
                "Consider permissive hypercapnia in ARDS (PaCO2 50-60 acceptable)",
                "Check for patient-ventilator dyssynchrony",
                "Verify ETCO₂ matches PaCO₂ (capnography)"
            ],
            warnings: [
                "Do not exceed 8 mL/kg IBW for tidal volume",
                "High rates (>30) may cause auto-PEEP",
                "Permissive hypercapnia OK in ARDS, not in ICP elevation"
            ],
            needsInput: [],
            clinicalPearls: [
                "Minute ventilation = TV × RR",
                "Increase rate first (faster response)",
                "Check dead space if sudden increase",
                "ARDS: Permissive hypercapnia acceptable",
                "Neuro patients: Keep PaCO2 35-40 (avoid hypercapnia)"
            ],
            momentId: id,
            tags: tags
        )
    }
}

// MARK: - Ventilator Desaturation (Low SpO2) - Alternative
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

// MARK: - Ventilator Hypercapnia (High CO2) - Alternative
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

// =============================================================================
// MARK: - MOMENT REGISTRY UPDATE
// =============================================================================

// NOTE: This file contains the moment definitions.
// The NLMomentRegistry.swift file needs to be updated to include all these moments.
