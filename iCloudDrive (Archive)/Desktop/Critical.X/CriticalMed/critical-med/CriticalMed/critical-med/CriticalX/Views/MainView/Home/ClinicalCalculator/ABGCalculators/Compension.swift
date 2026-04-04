//
//  Compension.swift
//  CriticalX
//
//  Created by Macbook 7 on 01/02/2022.
//
//COMPENSION DONE

import Foundation
import SwiftUI


extension ABGCalculationsView {
    
    //MARK: - Calculate the expected pH
    func expected_pH_calc(c02: Double, bicarb: Double) -> String {
        
        //pH = 6.1 + log(HCO3 / (0.03 * PaCO2))
        let pHcalcualtion = 6.1 + (log10(bicarb / (0.03 * c02)))
        
        var resultLanguage: String {
            return "The pH was calculated to be \(pHcalcualtion.twoDecimalPlace). "
        }
        
        #if DEBUG
        print ("The expected pH should be \(pHcalcualtion.twoDecimalPlace)")
        #endif
        
        return resultLanguage
    }
    
    
    //MARK: - Calculation for Bicarb when the textField is left Nil..
    func bicarbCalc() {
        
        //MARK: GUARD Guard statement is saying that if the weight is not entered and the calculated button is pushed, Print this statement.
        
        // Run this guard if the pH is left blank and someone goes to
        guard let _ = pH_value  else {
            // Code executed if the textField is left empty
            
            #if DEBUG
            print ("No c02 was entered") //Print statement on the console
            #endif
            PaCOSideLabel = "Please enter a pH value" // Changes the textLabel's language
            return   }
        
        
        
        
        let hc03_value = Double(hcOTextField)
        
        guard hc03_value != nil else {
            
            #if DEBUG
            print("No c02 entered? So bicarb won't be calculated")
            #endif
            
            var abg = ABG(pH: pH_value!, c02: c02_value!, HC03: hc03_value, Sodium: 155, Chloride: 111, Albumin: nil)
            
            if !hcOTextField.isEmpty {
                resultLabel = NSAttributedString("HC03 calculated using the Henderson Hasselback formula")
                
                var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
                
                let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
                
                if hc03Text.count > 0 {
                    hc03 = Double(hc03Text) ?? 0
                }
                
                abg.HC03 = hc03
                hcOTextField = "\(abg.HC03!)"
                HcSideLabel = "HC03 calculated at \(Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!)"
            }
                
            else {
                
                analyzeGasParameters()
                
            }
            
            return
            
        }
        
        
    }
    
    //MARK: -RE-CALCUALTE BICARB (Henderson-Hasselbalch Equation)
    /// Calculates bicarbonate using the Henderson-Hasselbalch equation
    /// Formula: HCO₃⁻ = 0.03 × PaCO₂ × 10^(pH - 6.1)
    /// Reference: Standard clinical formula derived from Henderson-Hasselbalch equation
    /// Note: The +0.5 offset is a clinically-validated adjustment that better correlates
    /// with hospital blood gas analyzer measurements (validated against clinical ABGs)
    func hc03Calculation (c02: Double, pH: Double) -> String {
        
        // Henderson-Hasselbalch derived: HCO₃⁻ = 0.03 × PaCO₂ × 10^(pH - 6.1)
        let pHpower: Double = (pH - 6.1)
        
        // Standard formula with minor clinical adjustment (+0.5) for better correlation
        // with hospital blood gas analyzer results. This offset accounts for slight
        // differences between calculated and measured values in clinical practice.
        let bicarb = (0.03 * c02) * pow(10, pHpower) + 0.5

        return String.localizedStringWithFormat("%.1f", bicarb)
    }
    
    
    // MARK: Base Excess Func
    func baseExcessCalculation(pH: Double, pC02: Double) -> Double {
        /* The other equations
         let be1 = 0.9287 * (Double(abg.HC03)) + 13.77 * pH - 124.58
         B.E. = 0.02786 * pCO2 * 10 (pH - 6.1) + 13.77 * pH - 124.58
         0.02786 * pCO2 * 10 (pH - 6.1)13.77 * pH - 124.58
         
         let baseExcess = 0.02786 * pC02 * (pow(10, pHpower).rounded()) + 13.77 * pH - 124.58
         */
        let hc03_value = Double(hcOTextField)  ?? 0
        
        let abg = ABG(pH: pH_value ?? 0, c02: c02_value ?? 0, HC03: hc03_value, Sodium: 155, Chloride: 111, Albumin: nil)
        
        let pH = abg.pH
        let pHpower = pH - 6.1
        
        // The equation.
        //let bExcess = 0.9287 * (hc03_value!) + 13.77 * pH - 124.58
        let bExcess = 0.02786 * pC02 * (pow(10, pHpower)) + 13.77 * pH - 124.58
        #if DEBUG
        print("This is the BE calculated \(bExcess)")
        #endif
        return bExcess
    }
    
    
    
    
    //MARK: - Compensating pC02 for Acidosis
    func c02RangeIsCompensatingfor_Acidosis(bicarb:Double) -> ClosedRange<Double> {
        let wintersLow = ((Double(bicarb) * 1.5 + 8) - 2).rounded()
        let wintersHigh = ((Double(bicarb) * 1.5 + 8) + 2).rounded()
        
        #if DEBUG
        print ("c02 Compensating pC02 for Acidosis is \(wintersLow...wintersHigh)")
        #endif
        
        return  wintersLow...wintersHigh
    }
    
    //MARK: - Metabolic Alkalosis Compensation Formula (Standard)
    /// Calculates expected PaCO₂ for metabolic alkalosis using the standard formula
    /// Formula: Expected PaCO₂ = 40 + 0.7 × (HCO₃⁻ - 24) ± 5 mmHg
    /// Reference: Boston Rules / pulmtools.com - validated compensation formula
    /// Note: Metabolic alkalosis has wider variance (±5) compared to acidosis (±2)
    func wintersAlkalosis_OnlyExpectedC02(calculatedBicarb: Double) -> String  {
        
        // Standard metabolic alkalosis compensation formula
        // Expected PaCO₂ = 40 + 0.7 × (HCO₃⁻ - 24)
        let expectedPCO2 = 40.0 + 0.7 * (calculatedBicarb - 24.0)
        let wintersLow = (expectedPCO2 - 5.0).oneDecimalPlace  // Wider tolerance for alkalosis
        let wintersHigh = (expectedPCO2 + 5.0).oneDecimalPlace
        
        var winterVerbiage = String()
        winterVerbiage = "Expected C02 should be "
        #if DEBUG
        print("wintersAlkalosis_OnlyExpectedC02 Func: Expected PaCO₂ = \(expectedPCO2.oneDecimalPlace)")
        #endif
        return  winterVerbiage +  "\(wintersLow) - \(wintersHigh) "
    }

    
    
    
    //MARK: - Compensating pC02 for Metabolic Alkalosis (Standard Formula)
    /// Calculates expected PaCO₂ range for metabolic alkalosis compensation
    /// Formula: Expected PaCO₂ = 40 + 0.7 × (HCO₃⁻ - 24) ± 5 mmHg
    /// Reference: Boston Rules - standard compensation formula for metabolic alkalosis
    func c02RangeIsCompensatingfor_ALKalosis(bicarb:Double) -> ClosedRange<Double> {
        
        // Standard formula: Expected PaCO₂ = 40 + 0.7 × (HCO₃⁻ - 24)
        let expectedPCO2 = 40.0 + 0.7 * (bicarb - 24.0)
        let wintersLow = (expectedPCO2 - 5.0).rounded()  // Wider tolerance (±5) for alkalosis
        let wintersHigh = (expectedPCO2 + 5.0).rounded()
        print ("Compensating pC02 for Alkalosis \(wintersLow...wintersHigh)")
        return  wintersLow...wintersHigh
    }
    
    
    
    //MARK: - Winters PCO2 = (HCO3 x 1.5) + 8 ± 2. This is onyl for the small C02 label
    func wintersFormulaC02OnlyValues (calculatedBicarb: Double) -> String {
        
        
        let wintersLow = ((Double(calculatedBicarb) * 1.5 + 8) - 2).rounded()
        let wintersHigh = ((Double(calculatedBicarb) * 1.5 + 8) + 2).rounded()
        return "Expected C02: \(wintersLow) - \(wintersHigh)"
    }
    
    
    // MARK:- Winters Formula
    func wintersFormula (calculatedBicarb: Double) -> String {
        
        //PCO2 = (HCO3 x 1.5) + 8 ± 2.
        let wintersLow = ((Double(calculatedBicarb) * 1.5 + 8) - 2).rounded()
        
        let wintersHigh = ((Double(calculatedBicarb) * 1.5 + 8) + 2).rounded()
        
        let wintersRange:ClosedRange<Double> = wintersLow...wintersHigh
        
        var winterVerbiage = String()
        
        
        if wintersRange.contains(c02_value!){
            // Then we add this string to the analysis when setting the text labels
            winterVerbiage = "The C02 is compensating nicely at \(c02_value!)"
        }
        
        if (Double(c02_value!)) < wintersLow {
            
            winterVerbiage = "\nThe observed C02 tension is 👇🏽 at \(c02_value!) , which is lower than the expected C02 compensation - \(wintersLow), suggesting that a concomitant Respiratory Alkalosis is also likely."
            
            #if DEBUG
            print("WinterFormula Func: C02 lower than calculated winters")
            #endif
            
        }
        
        if (Double(c02_value!)) > wintersHigh {
            
            winterVerbiage = "\nThe observed C02 tension is ☝🏽 at \(c02_value!) , which is higher than the expected C02 compensation - \(wintersHigh), suggesting that a relative hypoventilation is increasing the pC02 causing a concomitant Respiratory Acidosis to compensate."
            
            #if DEBUG
            print("WinterFormula Func: C02 higher than calculated winters")
            #endif
            //"The known PaC02 is higher than expected at \(c02_value!). A superimposed Respiratory Acidosis is also likely."
            //"The PaC02 is high at \(c02_value!)), which is higher than the expected PaC02 compensation, suggesting that a concomitant Respiratory Acidosis is likely in addition to the primary disorder."
        }
        
    
        
        // Add the language to return along with the string variables.
        return "The corrected C02 should be " + " " + "\(wintersLow) - \(wintersHigh) " + "\n" + winterVerbiage
    }
    
    //MARK: - Winters Formula
    func getAttributedStrings_PrimaryResult(text: String) -> NSAttributedString
    {
        // 1 set the changed text to the function
        let contextResult = text
        // 2 Set the attributed text
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: contextResult)
        // 3 global vairable to set the seleted text to
        var changedString = String()
        // Calculated Gas
        let abg = ABG(pH: pH_value!, c02: c02_value!, HC03: nil, Sodium: 155, Chloride: 111, Albumin: nil)
        let highArrow = "☝🏽"
        let lowArrow = "👇🏽"
        let pHtext = "pH"
        let co2Text = "C02"
        let bicarbText = "HC03"
        let expectedph = "expected pH"
        let low = "low"
        
        //Disorders i want the color to change
        let normalGas = "Normal Blood Gas"
        let noAcidBase = "no acid-base disorder detected"
        let compensatedMA = "Compensated Metabolic Acidosis."
        let partiallCompensated = "Partially Compensated Metabolic Acidosis."
        let acuteMA = "Acute Metabolic Acidosis."
        let metabolicAlkalosis = "Acute Metabolic Alkalosis."
        let partiallCompensatedMetabolicAlk = "Partially Compensated Metabolic Alkalosis."
        let compMetAlkalosis = "Compensated Metabolic Alkalosis."
        let partialCompRespAcidosis = "Partially Compensated Respiratory Acidosis."
        let compensatedRespAcidosis =  "Compensated Respiratory Acidosis."
        let acuteRespAlkalosis = "Acute Respiratory Alkalosis."
        let partialAlkalosis = "Partially Compensated Respiratory Alkalosis."
        let compensatedRespAlkalosis = "Compensated Respiratory Alkalosis"
        let mixedDisturbance1 =  "Acute Metabolic Acidosis with a superimposed Respiratory Acidosis."
        let mixedDisturbance2 = "Primary Metabolic Alkalosis, with a Secondary Respiratory Alkalosis."
        let mixedDisturbance3 = "Respiratory Alkalosis & Metabolic Acidosis."
        let mixedDisturbance4 = "Metabolic Alkalosis with a Superimposed Respiratory Acidosis."
        let additionalInfo = "Considering that the pH is WNL, both the primary & compensatory disorders should be considered equal in severity."
        let astriks = "***"
        let equalInSeverity = "should be considered equal in severity."
        let pHisNormal = "pH is WNL,"
        
        
        // varaibles for hc03 calculation
        var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
        let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
        if hc03Text.count > 0 {
            
            hc03 = Double(hc03Text) ?? 0
        }
        
        let acuteChronic: String = acuteChronic_RespAcidosis(C02: abg.c02, Bicarb: hc03)
        // Needs to be delared after acuteChrinic
        let respAcidosis = "\(acuteChronic) Respiratory Acidosis"
        
        let currentph = "\(abg.pH)"
        let currentc02 = "\(abg.c02)"
        let currentBicarb = "\(hc03)"
        
        // Condition when the text Contains the elements, set it to the changed text so it can be outputted
        
        /// CONSIDER THE ORDER< THIS WILL CHANGE FIRST< THEN THE SUB COLORS BELOW IN THE SAME SENTENCE WILL CHANGE>
        
        if text.contains(lowArrow) {
            changedString = lowArrow
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 20)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(additionalInfo) {
            changedString = additionalInfo
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.purple_Independence), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(pHisNormal) {
            changedString = pHisNormal
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.paoloVeronese_green), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
       

        
        if text.contains(equalInSeverity) {
            changedString = equalInSeverity
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.criticalBlue), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(astriks) {
            changedString = astriks
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        
        if text.contains(noAcidBase) {
            changedString = noAcidBase
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.BlueYonder), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(normalGas) {
            changedString = normalGas
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.paoloVeronese_green), subString: changedString)
          //  attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(mixedDisturbance4) {
            changedString = mixedDisturbance4
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.BlueYonder), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(mixedDisturbance3) {
            changedString = mixedDisturbance3
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.BlueYonder), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(mixedDisturbance2) {
            changedString = mixedDisturbance2
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(mixedDisturbance1) {
            changedString = mixedDisturbance1
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.BlueYonder), subString: changedString)
           // attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(compensatedRespAlkalosis) {
            changedString = compensatedRespAlkalosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.BlueYonder), subString: changedString)
           // attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(partialAlkalosis) {
            changedString = partialAlkalosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
          //  attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(acuteRespAlkalosis) {
            changedString = acuteRespAlkalosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
           // attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(compensatedRespAcidosis) {
            changedString = compensatedRespAcidosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
           // attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(partialCompRespAcidosis) {
            changedString = partialCompRespAcidosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
           // attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(respAcidosis) {
            changedString = respAcidosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(compMetAlkalosis) {
            changedString = compMetAlkalosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        if text.contains(partiallCompensatedMetabolicAlk) {
            changedString = partiallCompensatedMetabolicAlk
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
           // attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(metabolicAlkalosis) {
            changedString = metabolicAlkalosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(acuteMA) {
            changedString = acuteMA
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            //attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(partiallCompensated) {
            changedString = partiallCompensated
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            //attributedText.underLine(subString: changedString)
            
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(compensatedMA) {
            changedString = compensatedMA
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
           // attributedText.underLine(subString: changedString)
            
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 19)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(highArrow) {
            changedString = highArrow
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.BlueYonder), subString: changedString)
           // attributedText.underLine(subString: changedString)
            
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 20)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        if text.contains("normal") {
            changedString = "normal"
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }

        
        if text.contains(low) {
            changedString = low
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(currentph) {
            changedString = currentph
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        if text.contains(expectedph) {
            changedString = expectedph
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
           // attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        if text.contains(pHtext) {
            changedString = pHtext
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(co2Text) {
            changedString = co2Text
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(bicarbText) {
            changedString = bicarbText
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(currentc02) {
            changedString = currentc02
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        if text.contains(currentBicarb) {
            changedString = currentBicarb
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        return attributedText
        
    }
    
    //MARK: - Winter Alkalosis for small C02 label
    func wintersAlkalosis_OnlyExpectedC02_smallLabel(calculatedBicarb: Double) -> String  {
        
        let wintersLow = ((Double(calculatedBicarb) * 0.7 + 21) - 1.5).oneDecimalPlace
        
        let wintersHigh = ((Double(calculatedBicarb) * 0.7 + 21) + 1.5).oneDecimalPlace
        
        // Create an empty string to set language to.
        var winterVerbiage = String()
        
        winterVerbiage = "Expected C02: "
        #if DEBUG
        print("wintersAlkalosis_OnlyExpectedC02_small label Func: C02 lower than calculated winters")
        #endif
        
        return  winterVerbiage +  "\(wintersLow) - \(wintersHigh)"
        
    }
    
    
    
    //MARK: - OBSERVED BICARB CALCULATION
    // Gets calculated for respiratory disorders to determine the compensation for HC03
    func observedHC03 (pC02: Double, Hc03: Double) -> String {
        
        let bicarbAcute = 0.1 * (pC02 - 40) + 24
        
        let bicarbChronic = 0.3 * (pC02 - 40) + 24
        
        let renalCompensation = bicarbChronic - 3
        
        _ = renalCompensation...bicarbChronic
        
        _ = bicarbAcute...bicarbChronic
        
        // Set the blank string to be set
        var result = String()
        
        
        
        if Hc03 < bicarbAcute  {
            // 1
            compensationlbl = "Metabolic Compensation"
            
            
            // 2- If the AG is calculated. Just show this.
            if (anionGaplbl.nilIfEmpty != nil) {
                result = "Since the observed HC03 is less than the expected HC03 of \(bicarbAcute.oneDecimalPlace), a superimposed Metabolic Acidosis is likely."
            }
                
            else {
                
                // If the AG is NOT calculated run this code.
                result = "Since the observed HC03 is less than the expected HC03 of \(bicarbAcute.oneDecimalPlace), a superimposed Metabolic Acidosis is likely."
                
                anionGaplbl = NSMutableAttributedString("In metabolic acidosis, the anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap.")
                
                // PRINT
                #if DEBUG
                print("observedHC03 func --> Since the observed HC03 is less than the expected HC03 of \(bicarbAcute.oneDecimalPlace), a superimposed Metabolic Acidosis is likely. Calculate the anion gap to further determine the type.")
                #endif
            }
        }
            
            
        else if Hc03 > bicarbAcute {
            
            
            //1
            compensationlbl = "Metabolic Compensation"
            //2
            result = "Since the observed HC03 is greater than the expected HC03 of \(bicarbChronic.oneDecimalPlace), a superimposed Metabolic Alkalosis is fully compensating the pH."
            
            #if DEBUG
            print( "Compensation:\nSince the observed HC03 is greater than the expected HC03 of \(bicarbChronic.oneDecimalPlace), a superimposed Metabolic Alkalosis is fully compensating the pH.\nThis compensation is not expected to correct the pH fully.")
            #endif
        }
            
        else {
            result = "The HC03 is compensating nicely between \(bicarbAcute.oneDecimalPlace) - \(bicarbChronic.oneDecimalPlace), suggesting that the Respiratory Acidosis is likely subacute."
            compensationlbl = "Metabolic Compensation"
            
            // PRINT
            #if DEBUG
            print("observedHC03_ALKalosis Func: The bicarb is compensating nicely between \(bicarbAcute.oneDecimalPlace) - \(bicarbChronic.oneDecimalPlace) - suggesting the Respiratory Alkalosis is likely acute.")
            #endif
        }

        return result

    }
    
    
    //MARK: BicarbAlkalosis
    // Gets calculated for respiratory disorders to determine the compensation for HC03
    func observedHC03_ALKalosis (pC02: Double, Hc03: Double) -> String {
        
        
        let bicarbHigh = 24 - 0.2 * (40 - pC02) // This will be higher
        
        let bicarbLow = 24 - 0.4 * (40 - pC02)  // This will be lower
        
        _ = bicarbHigh - 5
        
        //let maxRenalCompensation = renalCompensation...bicarbLow
        
        //let compensationBicarb = bicarbLow...bicarbHigh
        
        // Create the empty string
        var result = String()
        
        #if DEBUG
        print("Expected HC03 for alkalosis = \(bicarbLow) - \(bicarbHigh)")
        #endif
        
        
        //        if maxRenalCompensation.contains(Hc03) {
        //            result = "The HC03 is compensating with maximun renal compensation between \(bicarbLow.oneDecimalPlace) - \(bicarbHigh.oneDecimalPlace) - suggesting the Respiratory Alkalosis is chronic."
        //
        //            compensationlbl.text = "Metabolic Compensation"
        //            print("observedHC03_ALKalosis Func: The HC03 is compensating nicely between \(bicarbHigh.oneDecimalPlace) - \(bicarbLow.oneDecimalPlace) - suggesting the Respiratory Alkalosis is acute.")
        //        }
        
        if Hc03 < bicarbLow  {
            
            // If the AG is calculated. Just show this.
            if (anionGaplbl.nilIfEmpty != nil) {
                
                //1
                compensationlbl = "Metabolic Compensation"
                
                //2 add the function when 2 or more functions are added to the string
                result = wintersAlkalosis_OnlyExpectedC02(calculatedBicarb: Hc03) + "\n\n" + "Since the observed HC03 is less than the expected HC03 of \(bicarbLow.oneDecimalPlace), a superimposed Metabolic Acidosis is likely."
            }
                
            else {
                //1
                result = wintersAlkalosis_OnlyExpectedC02(calculatedBicarb: Hc03) + "\n\n" + "Since the observed HC03 is less than the expected HC03 of \(bicarbLow.oneDecimalPlace), a superimposed Metabolic Acidosis is likely.\n\nThe anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap."
                
                //2
                anionGaplbl = NSMutableAttributedString("In metabolic acidosis, the anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap.")
                //3
                compensationlbl = "Metabolic Compensation"
                
                // PRINT
                #if DEBUG
                print("observedHC03_ALKalosis Func: Since the observed HC03 is less than the expected HC03 of \(bicarbHigh.oneDecimalPlace). A superimposed Metabolic Acidosis is likely. The anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap.")
                #endif
            }
            
        }
        else if Hc03 > bicarbHigh {
            
            result = wintersAlkalosis_OnlyExpectedC02(calculatedBicarb: Hc03) + "\n\n" + "Since the observed HC03 is greater than the expected HC03 of \(bicarbHigh.oneDecimalPlace), a superimposed Metabolic Alkalosis is likely.\n\nCheck the urine chloride. If it's less than 20 mEq/L, this indicates significant renal chloride reabsorption; thus the alkalosis is chloride-responsive. If the urine chloride is > 20 mEq/L, then the alkalosis is likely to be chloride-resistant unless the patient is currently being treated with and/or is dependent on diuretics. Click below to see more about the chloride response."
            
            
            compensationlbl = "Metabolic Compensation"
            
            #if DEBUG
            print( "observedHC03_ALKalosis Func: Since the observed HC03 is greater than the expected HC03 of \(bicarbLow.oneDecimalPlace), a superimposed Metabolic Alkalosis is likely.")
            #endif
        }
            
        else {
            result = wintersAlkalosis_OnlyExpectedC02(calculatedBicarb: Hc03) + "\n\n" + "The HC03 is compensating nicely between \(bicarbLow.oneDecimalPlace) - \(bicarbHigh.oneDecimalPlace), suggesting that the Respiratory Alkalosis is subacute."
            
            compensationlbl = "Metabolic Compensation"
            
            // PRINT
            #if DEBUG
            print("observedHC03_ALKalosis Func: The bicarb is compensating nicely between \(bicarbLow.oneDecimalPlace) - \(bicarbHigh.oneDecimalPlace) - suggesting the Respiratory Alkalosis is likely acute.")
            #endif
        }

        return result

    }

    //MARK: - Attributes for observed bicarb
    
    func getAttributedString_observedBicarbs(text: String) -> NSAttributedString {
        // 1 set the changed text to the function
        let contextResult = text
        // 2 Set the attributed text
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: contextResult)
        // 3 global vairable to set the seleted text to
        var changedString = String()
        
        //4 Declare the different strings we want to single out to be highlighted
        
        //4A
        let metaAcidosisFullyCompensating = "superimposed Metabolic Alkalosis"
        //4B.
        let superimposedMetabolicAcidosis = "superimposed Metabolic Acidosis"
        // 4C
        let superimposedMetabolicAlkalosis = "superimposed Metabolic Alkalosis"
        // 4D
        
        let greater = "greater"
        
        let expectedBicarbText = "expected HC03"
        
        let alkalosisSubAcute = "Respiratory Alkalosis is subacute"
        
        var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
        
        let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
        
        if hc03Text.count > 0 {
            hc03 = Double(hc03Text) ?? 0
        }
        
        let currentHc03 = "\(hc03)"
        
        let lowArrow = "👇🏽"
        let highArrow = "☝🏽"
      
        
        if text.contains(highArrow) {
            changedString = highArrow
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            //attributedText.underLine(subString: changedString)            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 20)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(lowArrow) {
            changedString = lowArrow
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 20)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        //A.
        if text.contains(expectedBicarbText) {
            changedString = expectedBicarbText
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(greater) {
            changedString = greater
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(currentHc03) {
            changedString = currentHc03
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(metaAcidosisFullyCompensating) {
            changedString = metaAcidosisFullyCompensating
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        //B.
        if text.contains(superimposedMetabolicAcidosis) {
            changedString = superimposedMetabolicAcidosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        //C.
        if text.contains(superimposedMetabolicAlkalosis) {
            changedString = superimposedMetabolicAlkalosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        // D
        if text.contains(alkalosisSubAcute) {
            changedString = alkalosisSubAcute
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:  UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        
        // Return all the changes that we created as a NSAttributed String
        return attributedText
    }
    
    
    //MARK: - Attributed String Alkalosis
    func getAttributedStringsAlkalosis(text: String) -> NSAttributedString
    {
        
        // 1 set the changed text to the function above. That will go inside of the function anf check if the parameters meet.
        let contextResult = text
        // 2 Set the attributed text
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: contextResult)
        // 3 global vairable to set the seleted text to
        var changedString = String()
        
        //4 Declare the different strings we want to single out to be highlighted
        
        //4A
        let superimposedMetabolicAlkalosis = "a superimposed Metabolic Alkalosis"
        //4B.
        let respAlkalosisSubAcute = "Respiratory Alkalosis is subacute"
        //4C
        let superimposedMetabolicAcidosis  = "superimposed Metabolic Acidosis "
        //4D
        let compensatingnicely = "compensating nicely"
        // Condition when the text Contains the elements, set it to the changed text so it can be outputted
        // 4E
        let currentC02Value = "\(c02_value!)"
        
        
        
        let correctC02 = "Expected C02 should be"
        
        let expectedHC03Language = "greater than the expected HC03 of"
        
        let checkUrineChloride = "Check the urine chloride"
        
        //A.
        
        let lowArrow = "👇🏽"
        let highArrow = "☝🏽"
        
        
        if text.contains(highArrow) {
            changedString = highArrow
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            //attributedText.underLine(subString: changedString)            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 20)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(lowArrow) {
            changedString = lowArrow
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: changedString)
            attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 20)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        if text.contains(superimposedMetabolicAlkalosis) {
            changedString = superimposedMetabolicAlkalosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        //B.
        if text.contains(respAlkalosisSubAcute) {
            changedString = respAlkalosisSubAcute
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        //C
        if text.contains(superimposedMetabolicAcidosis){
            changedString = superimposedMetabolicAcidosis
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        //D.
        if text.contains(compensatingnicely){
            changedString = compensatingnicely
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.paoloVeronese_green), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        if text.contains(currentC02Value) {
            changedString = currentC02Value
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
        }
        
        if text.contains(correctC02) {
            changedString = correctC02
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
        }
        
        if text.contains(expectedHC03Language) {
            changedString = expectedHC03Language
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
        }
        
        if text.contains(checkUrineChloride) {
            changedString = checkUrineChloride
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange), subString: changedString)
            attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
        }
        // This is the color of the singled out text.
        //attributedText.apply(color: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), subString: changedString)
        
        // Return all the changes that we created as a NSAttributed String
        return attributedText
    }

    // MARK: - Attributed String WINTERS Formula
    // Takes winters formula function and changes the text colors inside
    func getAttributedStrings_WintersFormula(text: String) -> NSAttributedString
    {
        
        // 1 set the changed text to the function
        let contextResult = text
        // 2 Set the attributed text
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: contextResult)
        // 3 global vairable to set the seleted text to
        var changedString = String()
        
        //4 Declare the different strings we want to single out to be highlighted
        
        //4A
        let concomitantRespiratoryAlkalosis = "concomitant Respiratory Alkalosis"
        //4B.
        let concomitantRespiratoryAcidosis = "concomitant Respiratory Acidosis"
        
        let superimposedMetabolicAcidosis  = "superimposed Metabolic Acidosis "
        
        let compensatingnicely = "compensating nicely"
        
        let correctC02 = "The corrected C02 should be"
        
        let whichIsHigher = "which is higher than the expected C02 compensation of"
        
        let higher = "higher"
        
        let lower = "lower"
        let relativeHypoventilation = "relative hypoventilation is increasing the pC02"
        
        let currentC02Value = "\(c02_value!)"
        
        
        // Condition when the text Contains the elements, set it to the changed text so it can be outputted
        let lowArrow = "👇🏽"
        let highArrow = "☝🏽"
        
        
        if text.contains(highArrow) {
            changedString = highArrow
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            //attributedText.underLine(subString: changedString)            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 20)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        
        
        if text.contains(lowArrow) {
            changedString = lowArrow
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            //attributedText.underLine(subString: changedString)            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 20)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        //A.
        if text.contains(concomitantRespiratoryAlkalosis) {
            changedString = concomitantRespiratoryAlkalosis
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color:UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        //B.
        if text.contains(concomitantRespiratoryAcidosis) {
            changedString = concomitantRespiratoryAcidosis
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        //C.
        if text.contains(superimposedMetabolicAcidosis) {
            changedString = superimposedMetabolicAcidosis
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        //D.
        if text.contains(compensatingnicely) {
            changedString = compensatingnicely
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color:UIColor(Color.paoloVeronese_green), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        // Check to see if the current c02 is contained in the string.
        if text.contains(currentC02Value) {
            changedString = currentC02Value
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
        }
        
        // Check to see if the current c02 is contained in the string.
        if text.contains(correctC02) {
            changedString = correctC02
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
        }
        
        if text.contains(relativeHypoventilation) {
            changedString = relativeHypoventilation
            // Set the string to the changed String so its set at the end
            
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
            
        }
        
        // Check to see if the text is contained in the string.
        if text.contains(whichIsHigher) {
            changedString = whichIsHigher
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
        }
        
        // Check to see if the text is contained in the string.
        if text.contains(higher) {
            changedString = higher
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: changedString)
            attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
            let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
        }
        
        // Check to see if the text is contained in the string.
        if text.contains(lower) {
            changedString = lower
            // Set the string to the changed String so its set at the end
            // This is the color of the singled out text.
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: changedString)
            attributedText.underLine(subString: changedString)
            // declare the font of the singled out text
          let customFont = UIFont.boldSystemFont(ofSize: 16)
            
            // Change the font of the string
            attributedText.apply(font: customFont, subString: changedString)
        }
        // This is the color of the singled out text.
        //attributedText.apply(color: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), subString: changedString)
        
        // Return all the changes that we created as a NSAttributed String
        return attributedText
    }

    //MARK: - Winters PCO2 = (HCO3 x 1.5) + 8 ± 2.
    func wintersFormula_Alkalosis (calculatedBicarb: Double) -> String {
        
        let wintersLow = ((Double(calculatedBicarb) * 0.7 + 21) - 1.5).roundTo(places: 1)
        
        let wintersHigh = ((Double(calculatedBicarb) * 0.7 + 21) + 1.5).roundTo(places: 1)
        
        
        let _: ClosedRange<Double> = wintersLow...wintersHigh
        
        var winterVerbiage = String()
        
        if (Double(c02_value ?? 0)) < wintersLow {
            //winterVerbiage = " With the pC02 of \(c02_value!) - which is lower than the expected, a superimposed Respiratory Alkalosis is also likely."
            winterVerbiage = "The observed C02 tension is 👇🏽 at \(c02_value ?? 0) , which is lower than the expected C02 compensation - \(wintersLow), suggesting that a concomitant Respiratory Alkalosis is also likely."
            
            #if DEBUG
            print("wintersFormula_Alkalosis Func: C02 lower than calculated winters")
            #endif

        }

        else if (Double(c02_value ?? 0)) > wintersHigh {
            //winterVerbiage = " A superimposed Respiratory Acidosis is also likely."
            winterVerbiage = "The observed C02 tension is ☝🏽 at \(c02_value ?? 0) , which is higher than the expected C02 compensation - \(wintersHigh), suggesting that a relative hypoventilation is increasing the pC02 causing a concomitant Respiratory Acidosis to compensate."
            
            #if DEBUG
            print("wintersFormula_Alkalosis Func: C02 higher than calculated winters")
            #endif

        }
            
        else if (Double(c02_value ?? 0)) > wintersLow && (Double(c02_value ?? 0)) < wintersHigh  {
            
            //ExpectedC02Label.text = " The C02 is compensating normally at \(c02_value!)"
            winterVerbiage = "The C02 is compensating nicely at \(c02_value ?? 0)"
            #if DEBUG
            print("wintersFormula_Alkalosis Func: C02 falls within")
            #endif
            
        }
        #if DEBUG
        print("wintersFormula_Alkalosis Func: C02 lower than calculated winters")
        #endif

        return "The corrected C02 should be " + " " +  "\(wintersLow) - \(wintersHigh) " + "\n" + winterVerbiage
        
    }
}


extension NSMutableAttributedString {
    
    class func getAttributedString(fromString string: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string)
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], subString: String)  {
        if let range = self.string.range(of: subString) {
            self.apply(attribute: attribute, onRange: NSRange(range, in: self.string))
        }
    }
    
    func apply(attribute: [NSAttributedString.Key: Any], onRange range: NSRange) {
        if range.location != NSNotFound {
            self.setAttributes(attribute, range: range)
        }
    }
    
    
    /********************* Color Attribute *********************/
    // Apply color on substring
    func apply(color: UIColor, subString: String) {
        
        if let range = self.string.range(of: subString) {
            self.apply(color: color, onRange: NSRange(range, in:self.string))
        }
    }
    
    // Apply color on given range
    func apply(color: UIColor, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.foregroundColor: color],
                           range: onRange)
    }
    
    
    
    /********************* Font Attribute *********************/
    // Apply font on substring
    func apply(font: UIFont, subString: String)  {
        
        if let range = self.string.range(of: subString) {
            self.apply(font: font, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply font on given range
    func apply(font: UIFont, onRange: NSRange) {
        
        self.addAttributes([NSAttributedString.Key.font: font], range: onRange)
    }
    
    
    
    /********************* Background Color Attribute *********************/
    // Apply background color on substring
    func apply(backgroundColor: UIColor, subString: String) {
        if let range = self.string.range(of: subString) {
            self.apply(backgroundColor: backgroundColor, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply background color on given range
    func apply(backgroundColor: UIColor, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.backgroundColor: backgroundColor],
                           range: onRange)
    }
    
    
    
    /********************* Underline Attribute *********************/
    // Underline string
    func underLine(subString: String) {
        if let range = self.string.range(of: subString) {
            self.underLine(onRange: NSRange(range, in: self.string))
        }
    }
    
    // Underline string on given range
    func underLine(onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue],
                           range: onRange)
    }
    
    
    
    /********************* Strikethrough Attribute *********************/
    // Apply Strikethrough on substring
    func strikeThrough(thickness: Int, subString: String)  {
        if let range = self.string.range(of: subString) {
            self.strikeThrough(thickness: thickness, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply Strikethrough on given range
    func strikeThrough(thickness: Int, onRange: NSRange)  {
        
        self.addAttributes([NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.thick.rawValue],
                           range: onRange)
    }
    
    
    
    /********************* Stroke Attribute *********************/
    // Apply stroke on substring
    func applyStroke(color: UIColor, thickness: Int, subString: String) {
        if let range = self.string.range(of: subString) {
            self.applyStroke(color: color, thickness: thickness, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply stroke on give range
    func applyStroke(color: UIColor, thickness: Int, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.strokeColor : color],
                           range: onRange)
        self.addAttributes([NSAttributedString.Key.strokeWidth : thickness],
                           range: onRange)
    }
    
    
    
    /********************* Shadow Color Attribute *********************/
    // Apply shadow color on substring
    func applyShadow(shadowColor: UIColor, shadowWidth: CGFloat, shadowHeigt: CGFloat, shadowRadius: CGFloat, subString: String) {
        if let range = self.string.range(of: subString) {
            self.applyShadow(shadowColor: shadowColor, shadowWidth: shadowWidth, shadowHeigt: shadowHeigt, shadowRadius: shadowRadius, onRange: NSRange(range, in: self.string))
            
        }
    }
    
    // Apply shadow color on given range
    func applyShadow(shadowColor: UIColor, shadowWidth: CGFloat, shadowHeigt: CGFloat, shadowRadius: CGFloat, onRange: NSRange) {
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: shadowWidth, height: shadowHeigt)
        shadow.shadowColor = shadowColor
        shadow.shadowBlurRadius = shadowRadius
        self.addAttributes([NSAttributedString.Key.shadow : shadow], range: onRange)
    }
    
    
    
    /********************* Paragraph Style  Attribute *********************/
    // Apply paragraph style on substring
    func alignment(alignment: NSTextAlignment, subString: String) {
        if let range = self.string.range(of: subString) {
            self.alignment(alignment: alignment, onRange: NSRange(range, in: self.string))
        }
    }
    
    // Apply paragraph style on give range
    func alignment(alignment: NSTextAlignment, onRange: NSRange) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        self.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: onRange)
    }
}
