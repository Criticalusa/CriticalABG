//
//  NLMomentRegistry.swift
//  CriticalX
//
//  Natural Language Moment Search - Moment Registry
//  Central registry of all searchable clinical moments
//

import Foundation

// MARK: - NLMomentRegistry
/// Central registry for all clinical moments that can be matched to queries
class NLMomentRegistry {
    
    // MARK: - Singleton
    static let shared = NLMomentRegistry()
    
    // MARK: - Properties
    private var moments: [NLMoment] = []
    
    /// Minimum score threshold for a moment to be considered a match
    private let minimumMatchScore = 3
    
    // MARK: - Initialization
    private init() {
        registerAllMoments()
    }
    
    // MARK: - Registration
    
    /// Register a single moment
    func register(_ moment: NLMoment) {
        moments.append(moment)
    }
    
    /// Clear and re-register all moments
    func reset() {
        moments.removeAll()
        registerAllMoments()
    }
    
    // MARK: - Matching
    
    /// Match a parsed query against all registered moments
    /// Returns moments sorted by match score (highest first)
    func match(_ query: ParsedQuery) -> [NLMomentOutput] {
        // Skip if query is essentially empty
        guard !query.normalized.isEmpty,
              query.drug != nil || query.scenario != nil || !query.normalized.trimmingCharacters(in: .whitespaces).isEmpty else {
            return []
        }
        
        // Score all moments
        let scoredMoments = moments.compactMap { moment -> (moment: NLMoment, score: Int)? in
            let score = moment.matchScore(query)
            guard score >= minimumMatchScore else { return nil }
            return (moment: moment, score: score)
        }
        
        // Sort by score (highest first) and limit results
        let sorted = scoredMoments
            .sorted { $0.score > $1.score }
            .prefix(5) // Limit to top 5 matches
        
        // Compute outputs
        return sorted.map { $0.moment.compute(query) }
    }
    
    /// Get all registered moment titles (for debugging/reference)
    var allMomentTitles: [String] {
        moments.map { $0.title }
    }
    
    /// Get moment count
    var momentCount: Int {
        moments.count
    }
    
    // ==========================================================================
    // MARK: - MOMENT REGISTRATION (Extension Point - Add More Moments Here)
    // ==========================================================================
    
    private func registerAllMoments() {
        // -----------------------------------------------------------------
        // VASOPRESSORS / INOTROPES
        // -----------------------------------------------------------------
        register(NorepinephrineShockMoment())
        register(EpinephrineInfusionMoment())
        register(VasopressinMoment())
        register(PhenylephrineMoment())
        register(DopamineMoment())
        register(DobutamineMoment())
        
        // -----------------------------------------------------------------
        // CARDIAC ARREST
        // -----------------------------------------------------------------
        register(AdultCardiacArrestEpiMoment())
        register(PediatricVFEpinephrineMoment())
        register(PediatricAmiodaroneVFMoment())
        register(AmiodaroneVFMoment())
        
        // -----------------------------------------------------------------
        // ARRHYTHMIAS
        // -----------------------------------------------------------------
        register(AFibMoment())
        register(TorsadesMoment())
        register(VTachWithPulseMoment())
        register(AdenosineSVTMoment())
        register(AtropineBradycardiaMoment())
        
        // -----------------------------------------------------------------
        // EMERGENCY PUSH DRUGS
        // -----------------------------------------------------------------
        register(AnaphylaxisEpinephrineMoment())
        register(NaloxoneMoment())
        register(DextroseHypoglycemiaMoment())
        
        // -----------------------------------------------------------------
        // RSI / INTUBATION (Paralytic Tag)
        // -----------------------------------------------------------------
        register(RocuroniumRSIMoment())
        register(SuccinylcholineRSIMoment())
        register(EtomidateMoment())
        register(KetamineMoment())
        register(PropofolMoment())
        
        // -----------------------------------------------------------------
        // ICU SEDATION / ANALGESIA (Sedation Tag)
        // -----------------------------------------------------------------
        register(PropofolInfusionMoment())
        register(DexmedetomidineInfusionMoment())
        register(FentanylInfusionMoment())
        
        // -----------------------------------------------------------------
        // PARALYTIC INFUSIONS (Paralytic Tag)
        // -----------------------------------------------------------------
        register(CisatracuriumInfusionMoment())
        
        // -----------------------------------------------------------------
        // ACLS 2025 GUIDELINES
        // -----------------------------------------------------------------
        register(ACLS2025MasterMoment())
        register(DefibrillationMoment2025())
        register(VascularAccessMoment2025())
        register(EpinephrineMoment2025())
        register(AntiarrhythmicMoment2025())
        register(CPRAdjunctsMoment2025())
        register(AirwayManagementMoment2025())
        register(TORMoment2025())
        register(WideComplexTachyMoment2025())
        register(NarrowComplexTachyMoment2025())
        register(AFibFlutterMoment2025())
        register(BradycardiaMoment2025())
        register(PostROSCMoment2025())
        
        // -----------------------------------------------------------------
        // VENTILATOR TROUBLESHOOTING
        // -----------------------------------------------------------------
        register(LowSpO2Moment())
        register(HighCO2Moment())
        register(VentilatorDesaturationMoment())
        register(VentilatorHypercapniaMoment())
        
        // -----------------------------------------------------------------
        // EKG INTERPRETATION
        // -----------------------------------------------------------------
        register(EKGInterpretationNLMoment())

        // -----------------------------------------------------------------
        // UNIT CONVERSIONS
        // -----------------------------------------------------------------
        register(WeightMassConversionMoment())
        register(TemperatureConversionMoment())
        register(VolumeConversionMoment())
        register(LengthConversionMoment())

        // TODO: Add more moments here as needed:
        // - Antibiotics (sepsis empiric coverage)
        // - Electrolyte corrections (potassium, magnesium, calcium)
        // - Blood product dosing
        // - Anticoagulants/reversal agents
        // - Pain management
        // - Seizure management
        // - Hypertensive emergency
    }
}

// MARK: - Query Matching Statistics

extension NLMomentRegistry {
    
    /// Get detailed match information for debugging
    func matchWithDetails(_ query: ParsedQuery) -> [(title: String, score: Int, output: NLMomentOutput)] {
        let scoredMoments = moments.compactMap { moment -> (title: String, score: Int, output: NLMomentOutput)? in
            let score = moment.matchScore(query)
            guard score > 0 else { return nil }
            return (title: moment.title, score: score, output: moment.compute(query))
        }
        
        return scoredMoments.sorted { $0.score > $1.score }
    }
}
