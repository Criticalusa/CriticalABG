//
//  Analysis.swift
//  CriticalX
//
//  Created by Macbook 7 on 02/02/2022.
//ANALYSIS DONE

import Foundation

extension ABGCalculationsView {
    
    
    func acuteChronic_RespAcidosis (C02: Double, Bicarb: Double) -> String {
        
        var acuteChronic = String()
        
        var changeInBicarb: Double { let bicarb = 24 - Bicarb
            
            if bicarb <= 0 { return bicarb * -1}

            #if DEBUG
            print("bicarb changed \(Bicarb) points\n")
            #endif

            return bicarb
        }
        
        var changeInC02: Double {
            
            let c02vlaue = 40.0
            
            let result = C02 - c02vlaue
            
            //if the result is negative, make it positive and lets see the result change difference
            if result <= 0 { return result * -1}

            #if DEBUG
            print("c02 changed \(result) points\n")
            #endif

            return result
        }



        // Guard against division by zero
        guard changeInC02 > 0 else {
            #if DEBUG
            print("⚠️ WARNING: CO2 change is zero - cannot determine acute vs chronic. Defaulting to 'Undetermined'")
            #endif
            return "Undetermined"
        }
        
        // Acute Resp Acidosis = Change in HCO3- = 0.1 x change in PaCO2
        let acuteChange = changeInC02 * 0.1
        let chronicChange = changeInC02 * 0.35
        let changeRatioAcute = changeInBicarb / changeInC02
        
        
        /*
         Reference is https://www.omicsonline.org/open-access/acidbase-disturbance-a-comprehensive-flowchartbased-diagnostic-approach-2165-7548-1000245.pdf
         */
        
        
        if changeRatioAcute == 0.1 {
            // If the change is 0.1 its an acute process.
            #if DEBUG
            print("The change ratio is \(changeRatioAcute) - this is acute\n")
            #endif
        }

        if changeRatioAcute < 0.1 {
            // If the ratio is less than 0.1 a metabolic acidosis is likely.
            #if DEBUG
            print("The change ratio is \(changeRatioAcute) - which is less than 0.1- a metabolic acidosis is likely\n")
            #endif
        }

        #if DEBUG
        print("In acute Resp Acidosis the change in bicarb should be greater than \(acuteChange.oneDecimalPlace) and < than \(chronicChange.oneDecimalPlace)\n")
        #endif
        
        // If theres an acute process
        // FIXED: Changed logic to properly classify acute (small HCO3 change) vs chronic (large HCO3 change)
        // Acute: Minimal compensation (HCO3 change ≤ acute threshold OR ratio ≤ 0.15)
        // Chronic: Full compensation (HCO3 change ≥ chronic threshold)
        if changeInBicarb <= acuteChange || changeRatioAcute <= 0.15 {
            acuteChronic = "Acute"
            #if DEBUG
            print("This is an acute process. The change in bicarb is \(changeInBicarb) which is ≤ \(acuteChange.oneDecimalPlace) (acute threshold)\n")
            #endif
        }
        // If theres a chronic process
        else if changeInBicarb >= chronicChange || changeRatioAcute >= 0.3 {
            acuteChronic = "Chronic"
            #if DEBUG
            print("This is a chronic process. The bicarb is \(Bicarb.oneDecimalPlace) and seems to have changed more than \(chronicChange.oneDecimalPlace) at \(changeInBicarb)\n")
            #endif
        }
        // In between - subacute/transitional
        else {
            acuteChronic = "Subacute"
            #if DEBUG
            print("This is a subacute/transitional process. HCO3 change \(changeInBicarb) is between acute (\(acuteChange.oneDecimalPlace)) and chronic (\(chronicChange.oneDecimalPlace)) thresholds\n")
            #endif
        }

        #if DEBUG
        print("\(acuteChronic)\n")
        #endif
        return acuteChronic
    }
    
    
    //MARK: - Acute vs Chronic Respiratory ALKALOSIS Detection (Boston Rules)
    /// Determines if respiratory alkalosis is acute or chronic based on HCO₃⁻ response
    /// Reference: Boston Rules / pulmtools.com (2024-2025 validated)
    ///
    /// ACUTE Respiratory Alkalosis:
    ///   - HCO₃⁻ decreases ~2 mEq/L per 10 mmHg drop in PaCO₂ (ratio: 0.2)
    ///   - Occurs within minutes to hours
    ///   - Buffering is primarily via intracellular mechanisms
    ///
    /// CHRONIC Respiratory Alkalosis:
    ///   - HCO₃⁻ decreases ~4-5 mEq/L per 10 mmHg drop in PaCO₂ (ratio: 0.5)
    ///   - Takes 3-5 days for full renal compensation
    ///   - Kidney excretes bicarbonate to compensate
    ///
    func acuteChronic_RespAlkalosis(C02: Double, Bicarb: Double) -> String {
        
        var acuteChronic = String()
        
        // Calculate how much CO2 has dropped below normal (40 mmHg)
        var changeInC02: Double {
            let normalC02 = 40.0
            let result = normalC02 - C02  // Positive when CO2 is low (alkalosis)
            if result <= 0 { return 0 }  // No drop, not respiratory alkalosis
            #if DEBUG
            print("C02 dropped \(result) mmHg below normal\n")
            #endif
            return result
        }
        
        // Calculate how much HCO3 has dropped below normal (24 mEq/L)
        var changeInBicarb: Double {
            let normalBicarb = 24.0
            let result = normalBicarb - Bicarb  // Positive when HCO3 is low
            if result <= 0 { return 0 }  // No drop
            #if DEBUG
            print("Bicarb dropped \(result) mEq/L below normal\n")
            #endif
            return result
        }
        
        // Boston Rules for Respiratory Alkalosis:
        // Acute: HCO₃⁻ ↓ 2 mEq/L per 10 mmHg ↓ PaCO₂ (ratio: 0.2)
        // Chronic: HCO₃⁻ ↓ 4-5 mEq/L per 10 mmHg ↓ PaCO₂ (ratio: 0.5)
        let acuteExpectedChange = changeInC02 * 0.2   // 2 mEq per 10 mmHg
        let chronicExpectedChange = changeInC02 * 0.5  // 5 mEq per 10 mmHg
        
        // Guard against division by zero
        guard changeInC02 > 0 else {
            return "Undetermined"
        }
        
        let actualRatio = changeInBicarb / changeInC02
        
        #if DEBUG
        print("Resp Alkalosis Analysis:")
        print("  - Acute expected HCO3 change: \(acuteExpectedChange.oneDecimalPlace) mEq/L")
        print("  - Chronic expected HCO3 change: \(chronicExpectedChange.oneDecimalPlace) mEq/L")
        print("  - Actual HCO3 change: \(changeInBicarb.oneDecimalPlace) mEq/L")
        print("  - Ratio: \(actualRatio.oneDecimalPlace)\n")
        #endif
        
        // Classification based on HCO3 response
        if changeInBicarb <= acuteExpectedChange || actualRatio <= 0.25 {
            // HCO3 dropped only what we'd expect in acute phase (buffering only)
            acuteChronic = "Acute"
            #if DEBUG
            print("Acute Respiratory Alkalosis: HCO3 dropped \(changeInBicarb.oneDecimalPlace), expected ~\(acuteExpectedChange.oneDecimalPlace) for acute\n")
            #endif
        }
        else if changeInBicarb >= chronicExpectedChange || actualRatio >= 0.4 {
            // HCO3 dropped significantly - renal compensation has occurred
            acuteChronic = "Chronic"
            #if DEBUG
            print("Chronic Respiratory Alkalosis: HCO3 dropped \(changeInBicarb.oneDecimalPlace), expected ~\(chronicExpectedChange.oneDecimalPlace) for chronic\n")
            #endif
        }
        else {
            // In between - transitional phase (12-48 hours typically)
            acuteChronic = "Subacute"
            #if DEBUG
            print("Subacute/Transitional Respiratory Alkalosis: HCO3 dropped \(changeInBicarb.oneDecimalPlace)\n")
            #endif
        }
        
        #if DEBUG
        print("\(acuteChronic) Respiratory Alkalosis\n")
        #endif
        return acuteChronic
    }
    
    
    //MARK: - Analyze the ABG parameters.
    func analyzeGasParameters()  {
        
        let hc03_value = Double(hcOTextField)
        
        // Saying if the pH and C02 arent entered, dont calculate.
        guard let _ = pH_value, let _ = c02_value else {return  } // If properly entered, do this below.
        
        isHiddenCompensationlbl = false
        isHiddenPrimaryDView = false
        
        // Calculated Gas
        let abg = ABG(pH: pH_value!, c02: c02_value!, HC03: hc03_value, Sodium: 155, Chloride: 111, Albumin: nil)
        
        
        
        // Running the change function !
        _ = acuteChronic_RespAcidosis(C02: c02_value ?? 0, Bicarb: hc03_value ?? 0)
        
        // Create the normal values and see if they are abnormal or not.
        var pHCondition = String()
        pushPhcondition = pHCondition
        
        let acidois = 6.0...7.34
        let lowNormalpH = 7.35...7.37
        let highNormalpH = 7.43...7.45
        let alkalosis = 7.46...8.0
        let normalPh = 7.38...7.42
        
        
        var co2Condition = String()
        pushC02condition = co2Condition
        
        let c02Normal  = 35.0...45.9
        let c02High = 46.0...1000
        let c02Low = 0...34.9
        
        
        var hc03Condition = String()
        pushHC03condition = hc03Condition
        
        let hc03Normal = 22.0...26.9
        let hc03High = 27.0...100.0
        let hc03Low = 0...21.9
        
        
        
        let expectedpHString = expected_pH_calc(c02: c02_value!, bicarb: abg.HC03 ?? Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!)
        
        
        //MARK:  Condition for the abnormal pH values.
        // When the pH is normal
        if normalPh.contains(abg.pH ) { pHCondition = "The pH is perfectly normal at \(abg.pH). " + expectedpHString
            // Set the string so it can be pushed to next VC as well.
            pushPhcondition = pHCondition
        }
            
            // When the pH is acidotic
        else if acidois.contains(abg.pH) { pHCondition = "The overall state of the pH is acidotic at \(abg.pH). " + expectedpHString
            // Set the string so it can be pushed to next VC as well.
            pushPhcondition = pHCondition
        }
            
            // When the pH is alkalotic
        else if alkalosis.contains(abg.pH) { pHCondition = "The overall state of the pH is alkalotic at \(abg.pH). " + expectedpHString
            
            // Set the string so it can be pushed to next VC as well.
            pushPhcondition = pHCondition
            
        }
            
            // When the pH is low-normal
        else if lowNormalpH.contains(abg.pH) { pHCondition = "The overall state of the pH is normal. Although it's WNL, theres a low-normal compensation at \(abg.pH). " + expectedpHString
            
            // Set the string so it can be pushed to next VC as well.
            pushPhcondition = pHCondition
            
        }
            
            // When the pH is high-normal
        else if highNormalpH.contains(abg.pH) { pHCondition = "The overall state of the pH is normal. Although it's WNL, theres a high-normal compensation at \(abg.pH). " + expectedpHString
            
        }
            
            // When the pH is WNL
        else { pHCondition = "The pH is within normal limits. " + expectedpHString
            
            // Set the string so it can be pushed to next VC as well.
            pushPhcondition = pHCondition
            
        }
        
        
        
        
        //MARK: Condition for the abnormal c02 values.
        
        //When the c02 is normal
        if c02Normal.contains(abg.c02) { co2Condition = "The C02 is normal at \(abg.c02), "
            // Set the string so it can be pushed to next VC as well.
            pushC02condition = co2Condition
        }
            
            // when the c02 is high
        else if c02High.contains(abg.c02) { co2Condition = "The C02 tension is high ☝🏽 at \(abg.c02) "
            
            // Set the string so it can be pushed to next VC as well.
            pushC02condition = co2Condition
        }
            
            // when the c02 is low
        else if c02Low.contains(abg.c02) { co2Condition = "The C02 tension is low 👇🏽 at \(abg.c02) "
            
            // Set the string so it can be pushed to next VC as well.
            pushC02condition = co2Condition
        }
            
            // Insurance else statement for The c02 is normal default
        else { co2Condition = "The C02 is normal "
            // Set the string so it can be pushed to next VC as well.
            pushC02condition = co2Condition
        }
        
        
        
        //MARK: Condition for the abnormal HC03 values.
        
        // When the bicarb is normal
        if hc03Normal.contains(abg.HC03 ?? Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!) {
            //I first get calculated value of HC03 and check  if textfield text count greater than 0 if replace calculated value with textField value
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
            
                hc03 = Double(hc03Text) ?? 0
            }
            
            hc03Condition = "and the HC03 concentration is normal at \(hc03)"
            
            // Set the string so it can be pushed to next VC as well.
            pushHC03condition = hc03Condition
        }
            
            // If the bicarb  is calculated high
        else if hc03High.contains(abg.HC03 ?? Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!) {
            //I first get calculated value of HC03 and check  if textfield text count greater than 0 if replace calculated value with textField value
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            hc03Condition = "and the HC03 concentration is elevated ☝🏽 at \(hc03)"
            
            // Set the string so it can be pushed to next VC as well.
            pushHC03condition = hc03Condition
        }
            
            // When the bicarb is low
        else if hc03Low.contains(abg.HC03 ?? Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!) {
            //I first get calculated value of HC03 and check  if textfield text count greater than 0 if replace calculated value with textField value
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            hc03Condition = "and the HC03 concentration is low 👇🏽 at \(hc03)"
            
            // Set the string so it can be pushed to next VC as well.
            pushHC03condition = hc03Condition
        }
            
            
            // Insurance else statement - When then bicarb is normal
        else { hc03Condition = "and the HC03 concentration is normal."
            
            // Set the string so it can be pushed to next VC as well.
            pushHC03condition = hc03Condition
        }
        
        
        
        //Calculate the bicarb
        bicarbCalc()
        
        // Display up/ Down aarows
        DisplayArrows()
        
        
        // Shows / Hides buttons and textlabels initially once  the button is pressed
        isHiddenTheoryButton = false // Keep this on screen
        isHiddenDeltaButton = true
        anionGaplbl = NSMutableAttributedString("")
        isHiddenCompensationlbl = false
        
        
        // Calculate the expected pH
        _ = expected_pH_calc(c02: abg.c02, bicarb: abg.HC03 ?? Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0)
        
        ////////////////////////// GAS ANALYSIS HAPPENS ////////////////////////////
        //MARK: - NORMAL ABG
        
        if  //Normal pH
            standardABGvaluesAre.pH_normalRange.contains(abg.pH),
            
            // Normal C02 Values
            standardABGvaluesAre.normalco2.contains(abg.c02),
            
            // Normal Bicarb
            standardABGvaluesAre.normalBicarb.contains(abg.HC03 ?? Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!)
            
        {
            
            
            //I first get calculated value of HC03 and check  if textfield text count greater than 0 if replace calculated value with textField value
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
                
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            let normalGasText = "This is a Normal Blood Gas \n\nThere was no acid-base disorder detected. " + expectedpHString + "\n\nHowever, a normal pH and C02 can't fully exclude a mixed metabolic alkalosis/acidosis 😉."
            
        
            
            // Set the result label to the attributed string
            resultLabel = getAttributedStrings_PrimaryResult(text: normalGasText)
            
            // Animate the display label
            main_DisorderTitle_Label = "No acid-base disorder"
            
            // Populate the small bicarbLabel with the calculated Value
            HcSideLabel = "HC03 Calculated at \(Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!)"
            
            let expectedText = "Interpretation: " + "\n" + pHCondition +  "\n\n" + co2Condition + hc03Condition
            //ExpectedC02Label.text = "Interpretation: " + "\n" + pHCondition +  "\n\n" + co2Condition + hc03Condition
            
            // Set the label to the function that changes the attributes that are entered in the text string.
            ExpectedC02Label = getAttributedStrings_PrimaryResult(text: expectedText)
            
            
            
            compensationlbl = "Interpretation"
            //Change buttons = Hide DeltaGap Button
            
            isHiddenDeltaButton = false
            analyzeBtnText = "Normal ABG Study"
            deltaButtonText = "🙌🏽"
            
            determineAnionGap()
            
            DisplayArrows()
            
            //print
            #if DEBUG
            print("With a pH of \(abg.pH), C02 of \(abg.c02), and HC03 at\(hc03))\nThis is a normal blood gas. Be happy, dude! Everything else is compensating nicely")
            #endif
            
        }
            
            
            //MARK: - ACUTE METABOLIC ACIDOSIS
        else if // ph is Low
            standardABGvaluesAre.ph_lowRange.contains(abg.pH),
            
            // c02 is normal
            standardABGvaluesAre.c02_normalRange.contains(abg.c02),
            
            // oR the c02 is in the compensatiory range.
            // || c02RangeIsCompensatingfor_Acidosis(bicarb: abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!).contains(abg.c02),
            //or less than 35
            //|| abg.c02 < 35,
            // Bicarb is low
            standardABGvaluesAre.bicarb_lowRange.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
        {
            
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            
            
            
            // Change buttons
            analyzeBtnText = "Metabolic Acidosis"
            // Setting title for button and unhiding it
            deltaButtonText = "Check Anion Gap ☝🏽"
            isHiddenDeltaButton = false
            anionGaplbl = NSMutableAttributedString(string: "In metabolic acidosis, the anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap.")
            
            //Lets apply special text attributes
            let metabolicAcidosisText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an:\nAcute Metabolic Acidosis."
            
            
            
            // Set the result label to the attributed string
            resultLabel = getAttributedStrings_PrimaryResult(text: metabolicAcidosisText)
            
            // Animate the display label
            main_DisorderTitle_Label = "Acute Metabolic Acidosis"
            
            // resultLabel.animate(text: pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an Acute Metabolic Acidosis.", duration: 2, completion: nil)
            
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"

            // Winters compensation, Acidosis
            //ExpectedC02Label.text = "The corrected C02 should be " + " " + wintersFormula(calculatedBicarb: hc03)
            
            ExpectedC02Label = getAttributedStrings_WintersFormula(text: wintersFormula(calculatedBicarb: hc03))
            
            compensationlbl = "Respiratory Compensation"
            
            //wintersFormula(calculatedBicarb: hc03)
            PaCOSideLabel = wintersFormulaC02OnlyValues(calculatedBicarb: hc03)
            
            //anionGapLabel.text = "In metabolic acidosis, the anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap."
            
            determineAnionGap()
            
            //print
            #if DEBUG
            print("ACute Metabolic Acidosis")
            print (pHCondition + ", C02 of \(abg.c02), and HC03 at \(hc03Low).\nThis patient has an Acute Metabolic Acidosis.\n\nThe base excess was calculated at approx. \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)")
            #endif
            
        }
            
            
            
            
            //MARK: METABOLIC ACIDOSIS - COMPENSATED
        else if standardABGvaluesAre.pH_Low_NormalRange.contains(abg.pH), //|| abg.pH <= 7.37,
            
            // Low C02
            standardABGvaluesAre.normalco2.contains(abg.c02),
            // || c02RangeIsCompensatingfor_Acidosis(bicarb: abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!).contains(abg.c02),
            
            // Bicarb is low.
            standardABGvaluesAre.lowHC03Range.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
            
        {
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            
            // Setting title for button and unhiding it
            deltaButtonText = "Check Anion Gap ☝🏽"
            isHiddenDeltaButton = false
            anionGaplbl = NSMutableAttributedString("In a metabolic acidosis, the anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap.")
           
            
            let additionalInfo: String
            additionalInfo = "\n\n*** Considering that the pH is WNL, both the primary & compensatory disorders should be considered equal in severity."
            
            // Diplay the disorder.
            let compensated_metabolicAcidosisText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a: Compensated Metabolic Acidosis." + additionalInfo
            
            
            
            // Set the result label to the attributed string
            resultLabel = getAttributedStrings_PrimaryResult(text: compensated_metabolicAcidosisText)
            
            // Animate the display label
            main_DisorderTitle_Label = "Compensated Metabolic Acidosis"
            analyzeBtnText = "Compensated Metabolic Acidosis"
            
            // Animates the result label.
            // resultLabel.animate(text: pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a Compensated Metabolic Acidosis.", duration: 2, completion: nil)
            
            baseExcessSmallLabel = "BE:  \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            compensationlbl = "Respiratory Compensation"
            
            // Winters compensation, Acidosis
          
            
            ExpectedC02Label = getAttributedStrings_WintersFormula(text: wintersFormula(calculatedBicarb: hc03))
            
            //ExpectedC02Label.text = "The corrected C02 should be " + "" + wintersFormula(calculatedBicarb: hc03)
            
            PaCOSideLabel = wintersFormulaC02OnlyValues(calculatedBicarb: hc03)
            
            // print
            #if DEBUG
            print("Compensated Metabolic Acidosis")
            print(pHCondition + ", C02 of \(abg.c02), and HC03 at \(hc03).\nThis patient has a Compensated Metabolic Acidosis.\n\nThe base excess was calculated at approx. \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)")
            #endif
            
            determineAnionGap()
            
            DisplayArrows()
            
        }
            
            
            //MARK: METABOLIC ACIDOSIS - PARTIALLY COMPENSATED
        else if standardABGvaluesAre.lowPhRange.contains(abg.pH),
            standardABGvaluesAre.lowC02Range.contains(abg.c02), // ||
                //c02RangeIsCompensatingfor_Acidosis(bicarb: abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!).contains(abg.c02),
            standardABGvaluesAre.lowHC03Range.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
            
        {
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
            let hc03Text = "Compensated Metabolic Acidosis".trimmingCharacters(in: .whitespaces)
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            
            
            // Setting title for button and unhiding it
            deltaButtonText = "Check Anion Gap ☝🏽"
            isHiddenDeltaButton = false
            anionGaplbl = NSMutableAttributedString("In metabolic acidosis, the anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap.")
            
            //Lets apply special text attributes
            let changedText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nPartially Compensated Metabolic Acidosis."
            
            
            // Set the result label to the attributed string
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            analyzeBtnText = "Partially Compensated Metabolic Acidosis"
            
            // Animate the display label
            main_DisorderTitle_Label = "Partially Compensated Metabolic Acidosis"
            
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            compensationlbl = "Respiratory Compensation"
            
            // Winters compensation, Acidosis
            ExpectedC02Label = getAttributedStrings_WintersFormula(text: wintersFormula(calculatedBicarb: hc03))
            
            // ExpectedC02Label.text = "The corrected C02 should be " + "" + wintersFormula_Alkalosis(calculatedBicarb: hc03)
            
            PaCOSideLabel = wintersFormulaC02OnlyValues(calculatedBicarb: hc03)
            
            // print
            #if DEBUG
            print("Partially Compensated Metabolic Acidosis")
            print(pHCondition + ", C02 of \(abg.c02), and HC03 at \(hc03).\nThis patient has a Compensated Metabolic Acidosis.\nThe base excess was calculated at approx. \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)")
            #endif
            
            determineAnionGap()
            
        }
            
            
            //MARK: - METABOLIC ALKALOSIS
        else if standardABGvaluesAre.pH_high.contains(abg.pH) || abg.pH == 7.45,
            standardABGvaluesAre.normal_c02Range.contains(abg.c02),// ||
            //c02RangeIsCompensatingfor_ALKalosis(bicarb: abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!).contains(abg.c02),
            standardABGvaluesAre.highBicarb_Range.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
        {
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            anionGaplbl = NSMutableAttributedString("The etiology of metabolic alkalosis can't be determined solely from the ABG. See the potential causes below.")
            
            
            //Lets apply special text attributes
            let changedText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an:\nAcute Metabolic Alkalosis."
            
            
            // Set the result label to the attributed string
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            
            
            // Animate the display label
            main_DisorderTitle_Label = "Acute Metabolic Alkalosis"
            baseExcessSmallLabel = "BE:  \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            analyzeBtnText = "Acute Metabolic Alkalosis"
            
            // Animate the result label
            // resultLabel.animate(text: pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an Acute Metabolic Alkalosis.", duration: 2, completion: nil)
            
            compensationlbl = "Respiratory Compensation"
            
            // Winters compensation Alkalosis
            ExpectedC02Label = getAttributedStrings_WintersFormula(text: wintersFormula_Alkalosis(calculatedBicarb: hc03))
            
            //ExpectedC02Label.text = "The corrected C02 should be " + "" + wintersFormula_Alkalosis(calculatedBicarb: hc03)
            
            PaCOSideLabel  = wintersAlkalosis_OnlyExpectedC02_smallLabel(calculatedBicarb: hc03)
            
            determineAnionGap()
            
            #if DEBUG
            print("Acute Metabolic Alkalosis")
            print(pHCondition + ", C02 of \(abg.c02), and HC03 at \(hc03).\nThis patient has an Acute Metabolic Alkalosis.\nThe base excess was calculated at approx. \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)")
            #endif
        }
            
            
            
            //MARK:  METABOLIC ALKALOSIS - PARTIALLY COMPENSATED
            // pH High, C02- High, HC03 - high
        else if standardABGvaluesAre.highPh_range.contains(abg.pH), // || abg.pH >= 7.42,
            
            standardABGvaluesAre.highC02_range.contains(abg.c02), // ||
            //c02RangeIsCompensatingfor_ALKalosis(bicarb: abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!).contains(abg.c02),
            
            standardABGvaluesAre.highBicarbOver27.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
        {
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            anionGaplbl = NSMutableAttributedString("The etiology of metabolic alkalosis can't be determined solely from the ABG. See the potential causes below.")
            
            //Lets apply special text attributes
            let changedText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nPartially Compensated Metabolic Alkalosis."
            
            // Set the result label to the attributed string
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            
            // Animate the display label
            main_DisorderTitle_Label = "Partially Compensated Metabolic Alkalosis"
            analyzeBtnText = "Partially Compensated-Metabolic Alkalosis"
            baseExcessSmallLabel = "BE:  \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            // Animate the result label
            //resultLabel.animate(text:   pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a Partially Compensated Metabolic Alkalosis.", duration: 2, completion: nil)
            
            compensationlbl = "Respiratory Compensation"
            
            
            // Winters compensation Alkalosis
            ExpectedC02Label = getAttributedStrings_WintersFormula(text: wintersFormula_Alkalosis(calculatedBicarb: hc03))
            // Previously used
            //ExpectedC02Label.text = "The corrected C02 should be " + "" + wintersFormula_Alkalosis(calculatedBicarb: hc03)
            
            PaCOSideLabel  = wintersAlkalosis_OnlyExpectedC02_smallLabel(calculatedBicarb: hc03)
            
            determineAnionGap()
            
            #if DEBUG
            print("Partially Compensated Metabolic Alkalosis Calculated")
            print(pHCondition + ", C02 of \(abg.c02), and HC03 at \(hc03).\nThis patient has a Partially Compensated Metabolic Alkalosis.\nThe base excess was calculated at approx. \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)")
            #endif
        }
            
            //MARK: METABOLIC ALKALOSIS - COMPENSATED
        else if //1 pH is normal
            standardABGvaluesAre.compensated_alkalosis_Metabolic_Ph.contains(abg.pH),
            //2 c02 is high, normal or is in compensating range
             c02Normal.contains(abg.c02)
                || c02RangeIsCompensatingfor_ALKalosis(bicarb: abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!).contains(abg.c02),
            // 3
            standardABGvaluesAre.compensated_MetabolicALK_HighBicarb.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
        {
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            anionGaplbl = NSMutableAttributedString("The etiology of metabolic alkalosis can't be determined solely from the ABG. See the potential causes below.")
            
            let additionalInfo: String
            additionalInfo = "\n\n*** Considering that the pH is WNL, both the primary & compensatory disorders should be considered equal in severity."
            
            
            //Lets apply special text attributes
            let changedText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nCompensated Metabolic Alkalosis." + additionalInfo
            
            
            // Set the result label to the attributed string
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            
            
            // Animate the display label
            main_DisorderTitle_Label = "Compensated Metabolic Alkalosis"
            analyzeBtnText = "Compensated Metabolic Alkalosis"
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            //resultLabel.animate(text:   pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a Compensated Metabolic Alkalosis.", duration: 2, completion: nil)
            
            // Winters compensation Alkalosis
            ExpectedC02Label = NSAttributedString(attributedString: getAttributedStrings_WintersFormula(text: wintersFormula_Alkalosis(calculatedBicarb: hc03)))
            
            //ExpectedC02Label.text = "The corrected C02 should be " + "" + wintersFormula_Alkalosis(calculatedBicarb: hc03)
            
            PaCOSideLabel  = wintersAlkalosis_OnlyExpectedC02_smallLabel(calculatedBicarb: hc03)
            
            determineAnionGap()
            
            
            #if DEBUG
            print(" Compensated Metabolic Alkalosis Calculated")
            print(pHCondition + ", C02 of \(abg.c02), and HC03 at \(hc03).\nThis patient has a Compensated Metabolic Alkalosis.\nThe base excess was calculated at approx. \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)")
            #endif
        }
            
            
            
            //MARK: - RESP ACIDOSIS- ACUTE
            // Low pH, High C02, Normal Bicarb
            
        else if standardABGvaluesAre.acidosis_Resp_Ph.contains(abg.pH),
            
            standardABGvaluesAre.acidosis_Resp_co2.contains(abg.c02) || abg.c02 >= 45,
            
            standardABGvaluesAre.acidosis_Resp_Bicarb.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
            //|| abg.HC03! > 26.0
            // Trying to see if the bicarb is in compensating range then its respiratory.
            // abgRange.acidosis_Resp_Bicarb.contains(Double(observedHC03(pC02:c02_value!, Hc03: hc03))!)
        {
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            // Here we set the function to determine the acute or chronic process and add it to the string output for analysis
            let acuteChronic: String = acuteChronic_RespAcidosis(C02: abg.c02, Bicarb: hc03)
            
            _ = Double(observedHC03(pC02:c02_value!, Hc03: hc03))
            
            
            //Lets apply special text attributes
            let changedText =  pHCondition + "\n\n" + co2Condition + hc03Condition + "\n\n" + "Analysis:\n\(acuteChronic) Respiratory Acidosis "
            
            // Set the result label
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            
            // Expected label set with attributes
            ExpectedC02Label = getAttributedString_observedBicarbs(text: observedHC03(pC02:abg.c02, Hc03: hc03))
            
            //ExpectedC02Label.text = observedHC03(pC02:abg.c02, Hc03: hc03)
            compensationlbl = "Metabolic Compensation"
            
            PaCOSideLabel = wintersFormulaC02OnlyValues(calculatedBicarb: hc03)
            analyzeBtnText = "Check Compensation 👇🏽"
            
            // Animate the display label
            main_DisorderTitle_Label = "\(acuteChronic) Respiratory Acidosis"
            
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            // resultLabel.animate(text:   pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an Acute Respiratory Acidosis " + isSuperimposed, duration: 2, completion: nil)
            
            determineAnionGap()
            
            // Print Statements
            #if DEBUG
            print("\(acuteChronic) Resp ACIDOSIS Calculated\n")
            print( pHCondition + ", C02 of \(abg.c02), and HC03 at \(hc03).\nThis patient has an Acute Respiratory Acidosis.\n\nThe base excess was calculated at approx. \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)\n")
            print(observedHC03(pC02:abg.c02, Hc03: hc03) + "is the observed bicarb\n")
            #endif
        }
            
            
            
            
            
            //MARK: RESP ACIDOSIS - PARTIALLY COMPENSATION
            // Low pH, High C02, High Bicarb
        else if standardABGvaluesAre.partialCompensated_Resp_Acidosis_PH.contains(abg.pH),
            
            standardABGvaluesAre.partialCompensated_Resp_Acidosis_C02.contains(abg.c02),
            
            standardABGvaluesAre.partialCompensated_Resp_Acidosis_Bicarb.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!) || abg.HC03! > 26.0
        {
            
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
           
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            //Lets apply special text attributes
            let changedText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nPartially Compensated Respiratory Acidosis."
            
            
            // Set the result label
            resultLabel = NSAttributedString(attributedString: getAttributedStrings_PrimaryResult(text: changedText))
            
            
            compensationlbl = "Metabolic Compensation"
            
            // Attributes expected label
            ExpectedC02Label = NSAttributedString(attributedString: getAttributedString_observedBicarbs(text: observedHC03(pC02:abg.c02, Hc03: hc03)))
            
            //ExpectedC02Label.text = observedHC03(pC02:abg.c02, Hc03: hc03)
            
            PaCOSideLabel = wintersFormulaC02OnlyValues(calculatedBicarb: hc03)
            analyzeBtnText = "Check Compensation 👇🏽"
            
            // Animate the display label
            main_DisorderTitle_Label = "Partially Compensated Respiratory Acidosis"
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            //resultLabel.animate(text: pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a Partially Compensated Respiratory Acidosis.", duration: 2, completion: nil)
            
            determineAnionGap()
            
            
            #if DEBUG
            print("PArtially Compensated Resp ACIDOSIS Calculated")
            print(pHCondition + ", C02 of \(abg.c02), and HC03 at \(hc03).\nThis patient has a Partially Compensated Respiratory Acidosis.\nThe base excess was calculated at approx. \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)")
            #endif
        }
            
            
            
            
            //MARK: RESP ACIDOSIS - COMPENSATED
        else if standardABGvaluesAre.Compensated_Resp_Acidosis_PH.contains(abg.pH),
            
            standardABGvaluesAre.Compensated_Resp_Acidosis_C02.contains(abg.c02),
            
            standardABGvaluesAre.Compensated_Resp_Acidosis_Bicarb.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!) || abg.HC03! > 26.0
        {
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            let additionalInfo: String
            additionalInfo = "\n\n*** Considering that the pH is WNL, both the primary & compensatory disorders should be considered equal in severity."
            
            
            
            //Lets apply special text attributes
            let changedText = pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nCompensated Respiratory Acidosis." + additionalInfo
            
            // Set the result label
            resultLabel =  NSAttributedString(attributedString: getAttributedStrings_PrimaryResult(text: changedText))
            
            // Attributes expected label
            ExpectedC02Label = NSAttributedString(attributedString: getAttributedString_observedBicarbs(text: observedHC03(pC02:abg.c02, Hc03: hc03)))
            //ExpectedC02Label.text = observedHC03(pC02:abg.c02, Hc03: hc03)
            
            compensationlbl = "Metabolic Compensation"
            analyzeBtnText = "Check Compensation 👇🏽"
            PaCOSideLabel = wintersFormulaC02OnlyValues(calculatedBicarb: hc03)
            
            // Animate the display label
            main_DisorderTitle_Label = "Compensated Respiratory Acidosis"
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            //resultLabel.animate(text:   pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a Compensated Respiratory Acidosis.", duration: 2, completion: nil)
            
            determineAnionGap()
            
            #if DEBUG
            print("Partially Compensated Respiratory Acidosis ")
            #endif

        }
            //MARK: - ACUTE RESP ALKALOSIS
            // Ph high, C02- normal - hc03 high
            
        else if standardABGvaluesAre.alkalosis_Resp_Ph.contains(abg.pH) || highNormalpH.contains(abg.pH) || lowNormalpH.contains(abg.pH) ,
            standardABGvaluesAre.alkalosis_Resp_co2.contains(abg.c02), // || abg.c02 < 40 ,
            standardABGvaluesAre.alkalosis_Resp_Bicarb.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
            //|| abg.HC03! < 24
        {
            
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            #if DEBUG
            print(hc03)
            #endif
            // Animate the display label
            
            determineAnionGap()
            
            isHiddenPrimaryDView = false
            
            //Lets apply special text attributes
            let changedText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an:\nAcute Respiratory Alkalosis."
            
            
            // Set the result label
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            main_DisorderTitle_Label = "Acute Respiratory Alkalosis"
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            analyzeBtnText = "Acute Respiratory Alkalosis"
            
            // We are doing the compensation for bicarb and also adding The corrected C02 for Winters as well
            ExpectedC02Label = getAttributedStringsAlkalosis(text: observedHC03_ALKalosis(pC02:abg.c02, Hc03: hc03))
            //ExpectedC02Label.text = wintersAlkalosis_OnlyExpectedC02(calculatedBicarb: hc03) + "\n\n" + observedHC03_ALKalosis(pC02:abg.c02, Hc03: hc03)
            compensationlbl = "Compensation"
            PaCOSideLabel  =  wintersAlkalosis_OnlyExpectedC02_smallLabel(calculatedBicarb: hc03)
            
            determineAnionGap()
            
            // resultLabel.animate(text:   pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an Acute Respiratory Alkalosis.", duration: 2, completion: nil)
            
            #if DEBUG
            print("Acute Resp Alkalosis Calculated")
            print(pHCondition + ", C02 of \(abg.c02), and HC03 at \(hc03).\nThis patient has an Acute Respiratory Alkalosis.\nThe base excess was calculated at approx. \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)")
            #endif
        }
            
            
            
            
            //MARK: - RESP  ALKALOSIS - PARTIALLY COMPENSATED
            // Ph high, C02- low - hc03 low
        else if standardABGvaluesAre.partialCompensated_Resp_Alkalosis_PH.contains(abg.pH), // pH is high
            
            standardABGvaluesAre.partialCompensated_Resp_Alkalosis_C02.contains(abg.c02),
            
            standardABGvaluesAre.partialCompensated_Resp_Alkalosis_Bicarb.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!) || abg.HC03! < 22.0
        {
            
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            #if DEBUG
            print(hc03)
            #endif


            //Lets apply special text attributes
            let changedText = pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nPartially Compensated Respiratory Alkalosis."
            
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            analyzeBtnText = "Partially Compensated Respiratory Alkalosis"
            
            // We are doing the compensation for bicarb and also adding The corrected C02 for Winters as well
            
            // Sets the attributed text from the compensation file
            ExpectedC02Label = getAttributedStringsAlkalosis(text: observedHC03_ALKalosis(pC02:abg.c02, Hc03: hc03))
            
            compensationlbl = "Compensation"
            
            PaCOSideLabel  = wintersAlkalosis_OnlyExpectedC02_smallLabel(calculatedBicarb: hc03)
            
            // Animate the display label
            main_DisorderTitle_Label = "Partially Compensated Respiratory Alkalosis"
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            //resultLabel.animate(text: pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a Partially Compensated Respiratory Alkalosis." , duration: 2, completion: nil)
            
            // Run Anion Gap Fn
            determineAnionGap()
            
            #if DEBUG
            print("PArtially Compensated Resp Alkalosis Calculated")
            #endif

        }
            
            //MARK: - RESP  ALKALOSIS -  COMPENSATED
            // Ph normal, C02- high - hc03 high
            
        else if standardABGvaluesAre.pH_Low_NormalRange.contains(abg.pH),
            
            standardABGvaluesAre.Compensated_Resp_Alkalosis_C02.contains(abg.c02),
            
            standardABGvaluesAre.Compensated_Resp_Alkalosis_Bicarb.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
        {
            #if DEBUG
            print(abg.HC03!)
            #endif
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            
            //1
            analyzeBtnText = "Compensated - Respiratory Alkalosis"
            
            //2  Animate the display label
            main_DisorderTitle_Label = "Compensated Respiratory Alkalosis"
            
            //3  We are doing the compensation for bicarb and also adding The corrected C02 for Winters as well
            // Sets the attributed text from the compensation file
            ExpectedC02Label = getAttributedStringsAlkalosis(text: observedHC03_ALKalosis(pC02:abg.c02, Hc03: hc03))
            
            //ExpectedC02Label.text = wintersAlkalosis_OnlyExpectedC02(calculatedBicarb: hc03) + "\n\n" + observedHC03_ALKalosis(pC02:abg.c02, Hc03: hc03)
            
            //4
            compensationlbl = "Compensation"
            
            //5
            PaCOSideLabel  = wintersAlkalosis_OnlyExpectedC02_smallLabel(calculatedBicarb: hc03)
            
            //6
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            //7
            let additionalInfo: String
            additionalInfo = "\n\n*** Considering that the pH is WNL, both the primary & compensatory disorders should be considered equal in severity."
            
            
            //Lets apply special text attributes
            let changedText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nCompensated Respiratory Alkalosis." + additionalInfo
            
            
            // Set the result label from the attribute.
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            
            determineAnionGap()
            
            #if DEBUG
            print("Compensated Resp Alkalosis Calculated")
            #endif
        }
            
            
            
            
            // MARK: Mixed Disturbance 1 : Respiratory acidosis with metabolic acidosis
            // ↓ in pH, ↑ in PaCO2 ↓ in HCO3,
            
        else if standardABGvaluesAre.mixedDisturbance1_pH.contains(abg.pH),
            standardABGvaluesAre.mixedDisturbance1_c02.contains(Int(abg.c02)) ||
                c02RangeIsCompensatingfor_Acidosis(bicarb: abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!).contains(abg.c02),
            standardABGvaluesAre.mixedDisturbance1_hc03.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
        {
            
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            
            // Setting title for button and unhiding it
            deltaButtonText = "Check Anion Gap ☝🏽"
            isHiddenDeltaButton = false
            anionGaplbl = NSMutableAttributedString("In metabolic acidosis, the anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap.")

            
            
            // resultLabel.animate(text: pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an Acute Metabolic Acidosis with a superimposed Respiratory Acidosis.", duration: 2, completion: nil)
            
            ExpectedC02Label = getAttributedStrings_WintersFormula(text: wintersFormula(calculatedBicarb: hc03))
            
            //ExpectedC02Label.text = "The corrected C02 should be " + " " + wintersFormula(calculatedBicarb: hc03)
            
            PaCOSideLabel = wintersFormulaC02OnlyValues(calculatedBicarb: hc03)
            
            //Lets apply special text attributes
            let changedText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an:\nAcute Metabolic Acidosis with a superimposed Respiratory Acidosis."
            
            
            // Set the result label
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            
            //Set the BE
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            compensationlbl = "Compensation"
            deltaButtonText = "Mixed Acidosis"
            isHiddenDeltaButton = false
            analyzeBtnText = "Check Compensation 👇🏽"
            
            // Animate the display label
            main_DisorderTitle_Label = "Metabolic & Respiratory Acidosis"
            
            determineAnionGap()
            
            #if DEBUG
            print("Mixed Disturbance 1 calculated")
            #endif
            
            
            
            
        }
            
            // MARK: Mixed Disturbance 2 : Respiratory acidosis with metabolic acidosis
            // pH High
            // C02 low
            // Bicarb high
        else if standardABGvaluesAre.mixedDisturbance2_pH.contains(abg.pH),
            standardABGvaluesAre.mixedDisturbance2_c02.contains(abg.c02) ||
                c02RangeIsCompensatingfor_ALKalosis(bicarb: abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!).contains(abg.c02),
            standardABGvaluesAre.mixedDisturbance2_hc03.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
            
        {
            var hc03 = Double(hc03Calculation(c02: c02_value  ?? 0, pH: pH_value ?? 0)) ?? 0
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            deltaButtonText = "Mixed Alkalosis"
            isHiddenDeltaButton = false
            compensationlbl = "Compensation"
            analyzeBtnText = "Check Compensation 👇🏽"
            
            //Set the BE
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            
            // Animate the display label
            
            let wintersLow = ((hc03 * 0.7 + 21) - 1.5).rounded()
            let wintersHigh = ((hc03 * 0.7 + 21) + 1.5).rounded()
            let wintersRange:ClosedRange<Double> = wintersLow...wintersHigh
            
            
            //Lets apply special text attributes
            let changedText =  pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nPrimary Metabolic Alkalosis, with a Secondary Respiratory Alkalosis.\n\nThe observed C02 is lower than the expected compensated C02 at \(wintersLow)."
            
            // Set the result label
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            
            determineAnionGap()
            
            
            if (Double(c02_value!)) < wintersLow {
                //resultLabel.text = "Primary Respiratory Alkalosis, Acute, with: Secondary Metabolic Alkalosis.\n\nThe observed C02 is lower than the expected compensated C02 at \(wintersLow)."
                // Set the result label
                resultLabel = NSAttributedString(attributedString: getAttributedStrings_PrimaryResult(text: changedText))
                
                //resultLabel.animate(text:   pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "Primary Metabolic Alkalosis, with a Secondary Respiratory Alkalosis.\n\nThe observed C02 is lower than the expected compensated C02 at \(wintersLow).", duration: 2, completion: nil)
            }
            
            if wintersRange.contains(Double(c02_value!))
            {
                resultLabel = NSAttributedString(string: "This patient has a:\nPrimary Metabolic Alkalosis, with: Appropriately Compensated by Respiratory Acidosis.\n\nThe expected compensated C02 should be between \(wintersLow) - \(wintersHigh)")
                
//                resultLabel.animate(text:   pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "Primary Metabolic Alkalosis, with: Appropriately Compensated by Respiratory Acidosis.\n\nThe expected compensated C02 should be between \(wintersLow) - \(wintersHigh)", duration: 2, completion: nil)
            }
            
            ExpectedC02Label = NSAttributedString(attributedString: getAttributedStringsAlkalosis(text: observedHC03_ALKalosis(pC02:abg.c02, Hc03: hc03)))
            //ExpectedC02Label.text = observedHC03_ALKalosis(pC02:abg.c02, Hc03: hc03)
            
            #if DEBUG
            print("Mixed Disturbance 2 calculated")
            #endif
            main_DisorderTitle_Label = "Mixed Metabolic & Respiratory Alkalosis"
            
            determineAnionGap()
            
            // resultLabel.text = "Primary Metabolic Alkalosis, with: Appropriately Compensated by Respiratory Acidosis"
        }
            
            // MARK: Mixed Disturbance 3 : Respiratory Alkalosis & Metabolic Acidosis
            
        else if // 1 pH is above Normal
            standardABGvaluesAre.mixedDisturbance3_pH.contains(abg.pH),
            // 2 c02 is low
            standardABGvaluesAre.mixedDisturbance3_c02.contains(abg.c02),
            // 3 bicarb is low
            standardABGvaluesAre.mixedDisturbance3_hc03.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
        {
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            
            
            // Setting title for button and unhiding it
            deltaButtonText = "Check Anion Gap ☝🏽"
            isHiddenDeltaButton = false
            anionGaplbl = NSMutableAttributedString("In metabolic acidosis, the anion gap can be helpful in narrowing down the different causes. Enter a Na and CL to calculate the anion gap.")
            
            //Lets apply special text attributes
            let changedText = pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nMixed Primary \nRespiratory Alkalosis & Metabolic Acidosis."
            
            // Set the result label
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            
            
            #if DEBUG
            print("Mixed Disturbance 3 calculated")
            #endif
            
            // Animate the display label
            main_DisorderTitle_Label = "Metabolic Acidosis & Respiratory Alkalosis"
            //main_DisorderTitle_Label.animate(text: "Metabolic Acidosis & Respiratory Alkalosis", duration: 1, completion: nil)
            
            // resultLabel.animate(text: pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has an a primary Respiratory alkalosis with a superimposed Metabolic Acidosis.", duration: 2, completion: nil)
            // resultLabel.text = "A primary Respiratory alkalosis with a Superimposed Metabolic Acidosis is likely\n "
            // Winters compensation, Acidosis
            
            compensationlbl = "Compensation"
            
            determineAnionGap()
            
            //Set the BE
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            ExpectedC02Label =  NSMutableAttributedString(attributedString: getAttributedStrings_WintersFormula(text: wintersFormula(calculatedBicarb: hc03)))
        }
            
            
            
            // MARK: Mixed Disturbance 4 :  Respiratory alkalosis with metabolic acidosis
        else if standardABGvaluesAre.mixedDisturbance4_pH.contains(abg.pH),
            standardABGvaluesAre.mixedDisturbance4_c02.contains(abg.c02),
            standardABGvaluesAre.mixedDisturbance4_hc03.contains(abg.HC03 ?? Double(hc03Calculation(c02: abg.c02, pH: abg.pH))!)
        {
            
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0
            
            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)
            
            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }
            
            // If the Na and Chloride are left blank, run the following code.
            if  (sodiumTextField.count) == 0 &&  (chlorideTextField.count) == 0
            {
                #if DEBUG
                print("AG not calculated")
                #endif
                deltaButtonText = "Mixed Disturbance"
                isHiddenDeltaButton = false
            }
                // Now if they are filled in then run the AG function
            else
            {
                determineAnionGap()
            }
            
            
            analyzeBtnText = "Mixed Disturbance"
            #if DEBUG
            print("Mixed Disturbance 4 calculated")
            #endif
            
            //Set the BE
            baseExcessSmallLabel = "BE: \(baseExcessCalculation(pH: abg.pH, pC02: abg.c02).oneDecimalPlace)"
            
            // Animate the display label
            main_DisorderTitle_Label = "Metabolic Alkalosis & Respiratory Acidosis"
            
            let changedText = pHCondition +  "\n\n" + co2Condition + hc03Condition + "\n\n" + "This patient has a:\nMixed disturbance. The physiologic compensation may not be enough to correct the pH. The pH is likely normal due to a primary \nMetabolic Alkalosis with a Superimposed Respiratory Acidosis. "
            
            resultLabel = getAttributedStrings_PrimaryResult(text: changedText)
            
            // Winters compensation, Acidosis
            ExpectedC02Label =  NSMutableAttributedString(attributedString: getAttributedStrings_WintersFormula(text: wintersFormula(calculatedBicarb: hc03)))
            
            
        }
            
            
            
            
            //ENDING ----- can't calculate the values.
        else {
            
            if standardABGvaluesAre.pH_normalRange.contains(abg.pH) {
                resultLabel =  NSAttributedString("The pH is normal but the pattern of PaC02/HC03 doesn't match the common types of mixed disturbances.")
                main_DisorderTitle_Label = "Oops, 😬 Unanalyzable ABG"
                ExpectedC02Label =  NSMutableAttributedString("Unanalyzable gas, check the data and laboratory errors should be considered.")
                
                //primaryDisorderLbl.text = "Unanalyzable ABG"
                isHiddenCompensationlbl = true
                
            } else {
                main_DisorderTitle_Label = "Oops, Unanalyzable ABG"
                resultLabel = NSMutableAttributedString("Not quite a calculated value. The values don't fit into the common types of acid-base disorders or maybe slightly off. Please re-check the numbers.")
        
                ExpectedC02Label = NSMutableAttributedString("Unanalyzable gas, check the data and laboratory errors should be considered.")
                
                //primaryDisorderLbl.text = "Unanalyzable ABG"
                isHiddenCompensationlbl = true
            }
        }
        
        
    }
}
