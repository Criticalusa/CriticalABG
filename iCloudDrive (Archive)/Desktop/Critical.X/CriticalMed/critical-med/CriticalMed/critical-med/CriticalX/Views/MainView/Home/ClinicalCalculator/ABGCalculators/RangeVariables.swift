//
//  RangeVariables.swift
//  CriticalX
//
//  Created by Macbook 7 on 01/02/2022.
//RANGEVARIABLES DONE

import Foundation

//MARK: ABG RANGES
class AbgRangeVariables {
    
    //MARK: - Normal  GAS --> GOOD
    var pH_normalRange: ClosedRange<Double> = 7.35...7.45
    let normalco2: ClosedRange<Double> = 35...45
    let normalBicarb: ClosedRange<Double> = 22...26
    
    //MARK: - Metabolic Acidosis --> GOOD
    let ph_lowRange = ...7.34                         // LOW
    let c02_normalRange: ClosedRange<Double> = 35...45 // Normal
    let bicarb_lowRange: ClosedRange<Double> = 0...21.9 // LOW
    
    //MARK: - Partially Compensated Metabolic ACIDOSIS --> GOOD
    let lowPhRange = 6.0...7.34 // LOW
    let lowC02Range  = 0...34.9 // LOW
    let lowHC03Range = 0...21.9 // LOW
    
    
    //MARK: -Compensated Metabolic Acidosis --> GOOD
    let pH_Low_NormalRange: ClosedRange<Double> = 7.35...7.37 // Normal
    // 0...34 // LOW and  low bicarb 0...23 // LOW
    
 
    //MARK: - Metabolic Alkalosis --> GOOD
    let pH_high = 7.46... // HIGH
    let normal_c02Range: ClosedRange<Double> = 35...45 // NORMAL
    let highBicarb_Range = 26.1... // HIGH
    
    //MARK: - Partially Compensated Metabolic Alkalosis
    let highPh_range = 7.45... // HIGH
    let highC02_range  = 45.1... // HIGH
    let highBicarbOver27 = 26.1... // HIGH
    
    
    //MARK: - Compensated Metabolic Alkalosis
    let compensated_alkalosis_Metabolic_Ph: ClosedRange<Double> = 7.42...7.45 // NORMAL
    let compensated_MetabolicALK_HighC02 = 45.1... // HIGH
    let compensated_MetabolicALK_HighBicarb = 26.1... // HIGH
    
    
    
    //MARK: - Respiratory Acidosis ↓ in pH, ↑ in PaCO2 --> GOOD
    let acidosis_Resp_Ph = ...7.35 // Low
    let acidosis_Resp_co2: PartialRangeFrom<Double>  = 46.0... // HIGH
    let acidosis_Resp_Bicarb: ClosedRange<Double> = 22.0...26.0 // NORMAL
    
    
    
    // MARK: Partially Compensated Respiratory Acidosis --> GOOD
    let partialCompensated_Resp_Acidosis_PH = 6.0...7.34 // LOW
    let partialCompensated_Resp_Acidosis_C02 = 45.1... // HIGH
    let partialCompensated_Resp_Acidosis_Bicarb = 26.1... // HIGH
    
    
    // MARK:  Compensated Respiratory Acidosis -- > GOOD
    let Compensated_Resp_Acidosis_PH = 7.35...7.4 // NORMAL
    let Compensated_Resp_Acidosis_C02 = 45.1... // HIGH
    let Compensated_Resp_Acidosis_Bicarb = 26.1... // HGIH
    
    
    //MARK: - Respiratory Alkalosis // -- > GOOD
    let alkalosis_Resp_Ph = 7.45... // High
    let alkalosis_Resp_co2 = ...34.9 // Low
    let alkalosis_Resp_Bicarb: ClosedRange<Double> = 22...26 // Normal
    
    
    // MARK: Partially Compensated Respiratory Alkalosis --> GOOD
    let partialCompensated_Resp_Alkalosis_PH = 7.46... // High
    let partialCompensated_Resp_Alkalosis_C02:ClosedRange<Double>  = 0...34.9 // Low
    let partialCompensated_Resp_Alkalosis_Bicarb: ClosedRange<Double>  = 0...21.9 // Low
    
    
    // MARK:  Compensated Respiratory Alkalosis
    let Compensated_Resp_Alkalosis_PH = 7.41...7.45 // Normal
    let Compensated_Resp_Alkalosis_C02 = ...34.9 // Low
    let Compensated_Resp_Alkalosis_Bicarb = ...21.9 // Low
    
    
    
    
    
    //MARK: -Mixed Disturbances
    /* Respiratory acidosis with metabolic acidosis
     ↓ in pH, ↑ in PaCO2 ↓ in HCO3,
     Cardiac arrest, Intoxications, Multi-organ failure
     */
    let mixedDisturbance1_pH = ...7.34
    let mixedDisturbance1_c02 = 46...
    let mixedDisturbance1_hc03 = ...21.9
    
    
    
    
    /* Respiratory alkalosis with metabolic alkalosis
     ↑in pH, ↓ in PaCO2 ↑ in  HCO3-,
     Cirrhosis with diuretics, Pregnancy with vomiting, Over ventilation of COPD
     */
    let mixedDisturbance2_pH = 7.46...
    let mixedDisturbance2_c02 = ...34.9
    let mixedDisturbance2_hc03 = 26.1...
    
    
    
    
    /* //MARK: -Respiratory alkalosis with metabolic acidosis
     pH in normal range
     ↓ in PaCO2, ↓ in HCO3
     Sepsis
     Salicylate toxicity, Renal failure with CHF or pneumonia, Advanced liver disease
     */
    
    // FIXME : Make sure that i test this more and add

    let mixedDisturbance3_pH = 7.35...7.45
    let mixedDisturbance3_c02 = 0...35.0
    let mixedDisturbance3_hc03 = 0...22.0
    
    
    
    
    /*//MARK: - Metabolic acidosis with metabolic alkalosis
     pH in normal range, HCO3- normal
     - Uremia or ketoacidosis with vomiting, NG suction, diuretics, etc.
     */
    
    
    
    
    /* //MARK: -Respiratory acidosis with metabolic alkalosis
     pH in normal range, normal or ↑ in PaCO2,, ↑ in  HCO3-
     COPD with diuretics, vomiting, NG suction, Severe hypokalemia
     */
    
    
    let mixedDisturbance4_pH: ClosedRange<Double> = 7.35...7.45
    let mixedDisturbance4_c02 = 45.0...
    let mixedDisturbance4_hc03 = 26.1...
    
    
}
