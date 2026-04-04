//
//  AnionGapAndDELTAGap.swift
//  CriticalX
//
//  Created by Macbook 7 on 01/02/2022.
//ANIONGAP DONE

import Foundation
import SwiftUI

extension ABGCalculationsView {
    
    
    func changeTheTextAttributes(text: String, subStrings: String) -> NSAttributedString {
        
        //Lets apply special text attributes
        let changedText = text
        
        // Setting the attriubte to the string
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: changedText)
        
        // Change the color of a word in the string
        attributedText.apply(color: UIColor(Color.red), subString: subStrings)
        
        let customFont = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        
        // Change the font of the string
        attributedText.apply(font: customFont!, subString: subStrings)
        
        return attributedText
    }
    

    // MARK: CALCULATING THE ANION GAP AND LIMITS
     func determineAnionGap() {

        let Na = Double(sodiumTextField)

        let CL = Double(chlorideTextField)

         _ = Double(hcOTextField)

        let Albumin = Double (albuminTextField)

        // Setting this to the struct
         _ = AbgRangeVariables()

        //I first get calculated value of HC03 and check  if textfield text count greater than 0 if replace calculated value with textField value
        var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0

        let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)

        if hc03Text.count > 0 {
            hc03 = Double(hc03Text)!
        }

        //MARK: - Anion Gap Calculation only with Na and Cl REGULAR
        // If the Na and Cl are both filled in, Run the formula
        if Na != nil && CL != nil {

            // Show the arrows
            DisplayArrows()

            let AnionGap = Na! - (CL! + hc03)

            _ = 24.0

//            var anionGapCorrection = Double()
//
//            anionGapCorrection = AnionGap

            let deltaGap = AnionGap - 12

            let deltaBicarb = 24 - hc03

            let _: ClosedRange<Double> = 1.4...1.8


            //Delta Ratio is (Delta Ratio)=ΔAG/ΔHCO3- or (ΔΔ or Delta Gap)=ΔAG-ΔHCO3-

            var deltaRatio: Double {
                return deltaGap / deltaBicarb
            }


            var deltaRatioExplanation = String()


            if deltaRatio < 0.4 {

                deltaRatioExplanation = "hyperchloremic normal anion gap acidosis."

                print("Delta ratio is < 0.4")

            }


            if (deltaRatio > 0.4) && (deltaRatio < 0.8) {

                deltaRatioExplanation = "a combined high and normal anion gap acidosis (HAGMA/NAGMA) exists. Also, note that the acidosis can also be attributed to renal failure as well."

                print("Delta ratio is 0.4 - 0.8")

            }


            if deltaRatio >= 0.8 && (deltaRatio < 1.0) {

                deltaRatioExplanation = "uncomplicated high Anion Gap metabolic acidosis"



                print("Delta ratio between 0.8-1")
            }

            if (deltaRatio >= 1.0) && (deltaRatio <= 1.5) {

                deltaRatioExplanation = "Purely high Anion Gap acidosis. Likely from a lactic acidosis, but could also be from DKA as well."

                print("Delta ratio is 1 -2")

            }

            if deltaRatio >= 1.6 {
                deltaRatioExplanation = "High Anion Gap Acidosis with either a concurrent Metabolic Alkalosis or pre-existing Respiratory Acidosis. "

                print("Delta ratio is > 1.6")
            }


            // Switch on AG
            let compensated_acidosis_Metabolic_Ph: ClosedRange<Double> = 7.35...7.39

            switch AnionGap {

            case -100...0:

                if pH_value! < 7.35 || compensated_acidosis_Metabolic_Ph.contains(pH_value!) && hc03 < 22
                {

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let newDeltaRatio = "\(deltaRatio.oneDecimalPlace)"
                    let  anionGapString = "Negative Anion Gap at \(AnionGap.oneDecimalPlace) . This is most likely a lab error, however, this could also result from multiple myeloma, bromide and iodide toxicities as well.\n\nThe ∆ delta gap ratio is \(deltaRatio.oneDecimalPlace) which suggests a " + deltaRatioExplanation
                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)
                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.red), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: (UIColor(Color.BlueYonder)), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)

                    //3
                    attributedText.apply(color: (UIColor(Color.pink)), subString: newDeltaRatio)
                    attributedText.apply(font:newFont, subString: newDeltaRatio)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Negative Anion Gap")
                    attributedText.apply(color: (UIColor(Color.paoloVeronese_green)), subString: "Negative Anion Gap")

                    //4 set the textLabel
                    anionGaplbl = attributedText



                    print("Negative Anion Gap, no alb \(AnionGap.oneDecimalPlace).")
                    //disorderLabel.animate(text: "NAGMA", duration: 1, completion: nil)

                    analyzeBtnText = "Negative Anion Gap"
                    //anionGapLabel.textColor = #colorLiteral(red: 0.9100000262, green: 0.5500000119, blue: 0.5699999928, alpha: 1)

                    isHiddenDeltaButton = false
                    deltaButtonText = "Lab Error? AG- \(AnionGap.oneDecimalPlace)"
                }

                else {



                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let  anionGapString = "Negative Anion Gap at \(AnionGap.oneDecimalPlace) . This is most likely a lab error, however, this could also result from multiple myeloma, bromide and iodide toxicities as well."
                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)
                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)



                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Negative Anion Gap")
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "Negative Anion Gap")

                    //4 set the textLabel
                    anionGaplbl = attributedText


                    print("Negative Anion Gap \(AnionGap.oneDecimalPlace).")
                    //disorderLabel.animate(text: "NAGMA", duration: 1, completion: nil)

                    analyzeBtnText = "Negative Anion Gap"
                    isHiddenDeltaButton = false
                    deltaButtonText = "Lab Error? AG- \(AnionGap.oneDecimalPlace)"
                }

            case 0...4:
                // 0-6 before
                if pH_value! < 7.35 || compensated_acidosis_Metabolic_Ph.contains(pH_value!) && hc03 < 22
                {

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let newDeltaRatio = "\(deltaRatio.oneDecimalPlace)"
                    let  anionGapString = "Non-Anion Gap Metabolic Acidosis at \(AnionGap.oneDecimalPlace)\n\nThe ∆ delta gap ratio is \(deltaRatio.oneDecimalPlace) which suggests a " + deltaRatioExplanation
                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)
                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newDeltaRatio)
                    attributedText.apply(font:newFont, subString: newDeltaRatio)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Non-Anion Gap Metabolic Acidosis")
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "Non-Anion Gap Metabolic Acidosis")

                    //4 set the textLabel
                    anionGaplbl = attributedText



                    print("Non-Anion Gap Metabolic Acidosis \(AnionGap.oneDecimalPlace).")


                    //disorderLabel.animate(text: "NAGMA", duration: 1, completion: nil)

                    analyzeBtnText = "Non-Anion Gap Metabolic Acidosis"
                    isHiddenDeltaButton = false
                    deltaButtonText = "Non-AG Metabolic Acidosis - \(AnionGap.oneDecimalPlace)"
                }

                else {


                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let newDeltaRatio = "\(deltaRatio.oneDecimalPlace)"

                    let  anionGapString = "Non-Anion Gap Metabolic Acidosis \(AnionGap.oneDecimalPlace)\n\nThe ∆ delta gap ratio is \(deltaRatio.oneDecimalPlace)"

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newDeltaRatio)
                    attributedText.apply(font:newFont, subString: newDeltaRatio)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Non-Anion Gap Metabolic Acidosis")
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "Non-Anion Gap Metabolic Acidosis")

                    //4 set the textLabel
                    anionGaplbl = attributedText


                    //disorderLabel.animate(text: "NAGMA", duration: 1, completion: nil)

                    analyzeBtnText = "Non-Anion Gap Metabolic Acidosis"
                    isHiddenDeltaButton = false
                    deltaButtonText = "Non-AG Metabolic Acidosis - \(AnionGap.oneDecimalPlace)"
                    print("Non-Anion Gap Metabolic Acidosis \(AnionGap.oneDecimalPlace).")

                }
            case 4...12:
                // 6-12 before

                // String parameter to make addition notes if there are certain parameters.
                var metaAcid = String()

                // If theres a metabolic acidosis, we are gonna let people know theres a bicarb wasting.
                if (main_DisorderTitle_Label.contains("Acute Metabolic Acidosis")) {

                    metaAcid = "\nCheck urine anion gap to help find the cause of the HC03 wasting."


                    // We dont calculate the deltaRatio

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"

                    let  anionGapString =   "Normal Anion Gap - \(AnionGap.oneDecimalPlace) " + metaAcid


                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)


                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Normal Anion Gap")
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: "Normal Anion Gap")

                    //4 set the textLabel
                    anionGaplbl = attributedText



                    isHiddenDeltaButton = false
                    deltaButtonText = "Anion Gap - \(AnionGap.oneDecimalPlace)"

                    //anionGapLabel.textColor = #colorLiteral(red: 0.6802619696, green: 0.9382658601, blue: 0.7976928353, alpha: 1)

                    analyzeBtnText = "Normal Anion Gap - \(AnionGap.oneDecimalPlace)"
                    print("Metabolic Acidosis with normal Anion Gap present, check the urine gap")
                    print("Normal Gap \(AnionGap.oneDecimalPlace).")

                } else {

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"

                    let  anionGapString = "Normal Anion Gap - \(AnionGap.oneDecimalPlace) " + metaAcid


                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)


                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Normal Anion Gap")
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: "Normal Anion Gap")

                    //4 set the textLabel
                    anionGaplbl = attributedText

                    isHiddenDeltaButton = false
                    deltaButtonText = "Anion Gap - \(AnionGap.oneDecimalPlace)"
                    print("Normal Gap \(AnionGap.oneDecimalPlace).")
                    analyzeBtnText = "Normal Anion Gap - \(AnionGap.oneDecimalPlace)"
                }

            case 12...100:

                // We are only displaying the delta gap and explanation only in metabolic acidosis.
                if pH_value! < 7.35 || compensated_acidosis_Metabolic_Ph.contains(pH_value!) && hc03 < 22 {



                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let newDeltaRatio = "\(deltaRatio.oneDecimalPlace)"

                    let  anionGapString = "High Anion Gap Metabolic Acidosis (HAGMA)\nThe Anion Gap was calculated at \(AnionGap.oneDecimalPlace)\n\n The ∆ delta gap ratio is \(deltaRatio.oneDecimalPlace) which suggests a " + deltaRatioExplanation

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newDeltaRatio)
                    attributedText.apply(font:newFont, subString: newDeltaRatio)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "High Anion Gap Metabolic Acidosis (HAGMA)")
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: "High Anion Gap Metabolic Acidosis (HAGMA)")

                    //4 set the textLabel
                    anionGaplbl = attributedText
                    // Animate the disorder
                    //disorderLabel.animate(text: "High Anion Gap Metabolic Acidosis", duration: 1, completion: nil)

                    print("High Anion Gap Metabolic Acidosis. The Anion Gap is calculated at \(AnionGap.oneDecimalPlace). ")

                    print("\(deltaRatio) - deltaRatio" + deltaRatioExplanation) // calls the delta gap becayse the Anion Gap is high.

                    print("This is high AG over 12-100")
                    analyzeBtnText = "High Anion Gap Metabolic Acidosis"

                    //UnHide DeltaGap Button
                    isHiddenDeltaButton = false
                   deltaButtonText = "HAGMA"
                }

                else {
                    // anionGapLabel.text = "High Anion Gap Metabolic Acidosis (HAGMA)\nThe Anion Gap was calculated at \(AnionGap.oneDecimalPlace)"

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let  anionGapString = "High Anion Gap Metabolic Acidosis (HAGMA)\nThe Anion Gap was calculated at \(AnionGap.oneDecimalPlace)"
                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)
                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)


                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "High Anion Gap Metabolic Acidosis (HAGMA)")
                    attributedText.apply(color:UIColor(Color.BlueYonder), subString: "High Anion Gap Metabolic Acidosis (HAGMA)")

                    // Animate the disorder
                    //disorderLabel.animate(text: "High Anion Gap Metabolic Acidosis", duration: 1, completion: nil)

                    print("Positive Anion Gap Metabolic Acidosis. The Anion Gap is calculated at \(AnionGap.oneDecimalPlace). ")
                    print("\(deltaRatio) deltaRatio second one" + deltaRatioExplanation) // calls the delta gap becayse the Anion Gap is high.
                    analyzeBtnText = "High Anion Gap Metabolic Acidosis"

                    //UnHide DeltaGap Button
                    isHiddenDeltaButton = false
                    deltaButtonText = "HAGMA"
                }
            default: break

            }
        }


        //MARK: - AG Calculation Corrected for Albumin

        if Na != nil && CL != nil && Albumin != nil {

            let AnionGap = Na! - (CL! + hc03)

            var anionGapCorrection = Double()

            let AnionGapCorrectedAlbumin = AnionGap + 2.5 * (4 - Albumin!)

            anionGapCorrection = AnionGapCorrectedAlbumin

            let deltaGap = AnionGap - 12

            let deltaBicarb = 24 - hc03

            print("Albumin was entered and corrected AG is \(AnionGapCorrectedAlbumin)")


            let _: ClosedRange<Double> = 1.4...1.8
            //Delta Ratio is (Delta Ratio)=ΔAG/ΔHCO3- or (ΔΔ or Delta Gap)=ΔAG-ΔHCO3-

            var deltaRatio: Double {

                return deltaGap / deltaBicarb
            }

            var deltaRatioExplanation = String()


            if deltaRatio < 0.4 {
                deltaRatioExplanation = "hyperchloremic normal anion gap acidosis."

                print("Delta ratio is < 0.4")

            }

            if (deltaRatio > 0.4) && (deltaRatio < 1.0) {
                deltaRatioExplanation = "high AG and normal AG acidosis."

                print("Delta ratio is 0.4 - 1")

            }


            if (deltaRatio >= 1.0) && (deltaRatio <= 1.5) {

                deltaRatioExplanation = "pure Anion Gap Acidosis, lactic acidosis or DKA."

                print("Delta ratio is 1 -2")

            }

            if deltaRatio >= 1.6 {


            deltaRatioExplanation = "High Anion Gap Acidosis with either a concurrent Metabolic Alkalosis or pre-existing Respiratory Acidosis."

                print("Delta ratio is > 2")
            }


            // Switch on Anion Gap
            let compensated_acidosis_Metabolic_Ph: ClosedRange<Double> = 7.35...7.39

            switch anionGapCorrection {

            case -100...0:
                if pH_value! < 7.35 || compensated_acidosis_Metabolic_Ph.contains(pH_value!) && hc03 < 22
                {


                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let correctedAG = "\(anionGapCorrection.oneDecimalPlace)"
                    let newDeltaRatio = "\(deltaRatio.oneDecimalPlace)"

                    let  anionGapString = "Negative Anion Gap. The Anion Gap is \(AnionGap.oneDecimalPlace)\nCorrected for albumin was \(anionGapCorrection.oneDecimalPlace)\n This is most likely a lab error, however, this could also result from multiple myeloma, bromide and iodide toxicities as well.\n\nThe ∆ delta gap ratio is \(deltaRatio.oneDecimalPlace) which suggests a " + deltaRatioExplanation

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: correctedAG)
                    attributedText.apply(font:newFont, subString: correctedAG)


                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newDeltaRatio)
                    attributedText.apply(font:newFont, subString: newDeltaRatio)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Negative Anion Gap.")
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: "Negative Anion Gap.")

                    //4 set the textLabel
                    anionGaplbl = attributedText



                    print("Negative Anion Gap \(anionGapCorrection.oneDecimalPlace).")
                    //disorderLabel.animate(text: "NAGMA", duration: 1, completion: nil)

                    analyzeBtnText = "Negative Anion Gap"
                    isHiddenDeltaButton = false
                    deltaButtonText = "Lab Error? AG- \(anionGapCorrection.oneDecimalPlace)"
                    

                }

                else {
                    print("Negative Anion Gap \(anionGapCorrection.oneDecimalPlace).")
                    //disorderLabel.animate(text: "NAGMA", duration: 1, completion: nil)

                    analyzeBtnText = "Negative Anion Gap"
                    isHiddenDeltaButton = false
                    deltaButtonText = "Lab Error? AG- \(anionGapCorrection.oneDecimalPlace)"
                   



                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let correctedAG = "\(anionGapCorrection.oneDecimalPlace)"

                    let  anionGapString = "Negative Anion Gap. The Anion Gap is \(AnionGap.oneDecimalPlace)\nCorrected for albumin was \(anionGapCorrection.oneDecimalPlace)\n This is most likely a lab error, however, this could also result from Multiple myeloma, bromide and iodide toxicities as well."

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)


                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: correctedAG)
                    attributedText.apply(font:newFont, subString: correctedAG)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Negative Anion Gap.")
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "Negative Anion Gap.")

                    //4 set the textLabel
                    anionGaplbl = attributedText

                }
            case 0...4:
                // 0-6 before

                if pH_value! < 7.35 || compensated_acidosis_Metabolic_Ph.contains(pH_value!) && hc03 < 22
                {


                    //disorderLabel.animate(text: "NAGMA", duration: 1, completion: nil)
                    analyzeBtnText = "Non-Anion Gap Metabolic Acidosis"
                    isHiddenDeltaButton = false
                    deltaButtonText = "Non AG Metabolic Acidosis - \(anionGapCorrection.oneDecimalPlace)"
                   

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let correctedAG = "\(anionGapCorrection.oneDecimalPlace)"
                    let newDeltaRatio = "\(deltaRatio.oneDecimalPlace)"

                    let  anionGapString = "Non-Anion Gap Metabolic Acidosis. The Anion Gap is \(AnionGap.oneDecimalPlace)\nCorrected for albumin is \(anionGapCorrection.oneDecimalPlace) \n\nThe ∆ delta gap ratio is \(deltaRatio.oneDecimalPlace) which suggests a " + deltaRatioExplanation

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newDeltaRatio)
                    attributedText.apply(font:newFont, subString: newDeltaRatio)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: correctedAG)
                    attributedText.apply(font:newFont, subString: correctedAG)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Non-Anion Gap Metabolic Acidosis.")
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "Non-Anion Gap Metabolic Acidosis.")

                    //4 set the textLabel
                    anionGaplbl = attributedText


                    print("Non Anion Gap Metabolic Acidosis \(AnionGap.oneDecimalPlace).")

                }

                else {
                    analyzeBtnText = "Non-Anion Gap Metabolic Acidosis"
                    isHiddenDeltaButton = false
                    deltaButtonText = "Non-AG Metabolic Acidosis - \(anionGapCorrection.oneDecimalPlace)"


                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let correctedAG = "\(anionGapCorrection.oneDecimalPlace)"
                    let newDeltaRatio = "\(deltaRatio.oneDecimalPlace)"

                    let  anionGapString =  "Non-Anion Gap Metabolic Acidosis. The Anion Gap is \(AnionGap.oneDecimalPlace)\nCorrected for albumin is \(anionGapCorrection.oneDecimalPlace)\n\nThe ∆ delta gap ratio is \(deltaRatio.oneDecimalPlace) which suggests a " + deltaRatioExplanation

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newDeltaRatio)
                    attributedText.apply(font:newFont, subString: newDeltaRatio)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: correctedAG)
                    attributedText.apply(font:newFont, subString: correctedAG)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Non-Anion Gap Metabolic Acidosis.")
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "Non-Anion Gap Metabolic Acidosis.")

                    //4 set the textLabel
                    anionGaplbl = attributedText


                    print("Non-Anion Gap Metabolic Acidosis \(AnionGap.oneDecimalPlace).")

                }


            case 4...12:
                var metaAcid = String()
                // If theres a metabolic acidosis we say check the urine gap as well.
                if (main_DisorderTitle_Label.contains("Metabolic Acidosis")) {

                    metaAcid = "\nCheck urine anion gap to help find the cause of the HC03 wasting."

                    print("Metabolic Acidosis with normal Anion Gap present, check the urine gap")

                    anionGaplbl = NSMutableAttributedString(string: "Normal Anion Gap at \(AnionGap.oneDecimalPlace) \nCorrected for for albumin was \(anionGapCorrection.oneDecimalPlace) " + metaAcid)


                    isHiddenDeltaButton = false
                    deltaButtonText = "Anion Gap - \(anionGapCorrection.oneDecimalPlace)"
                    //anionGapLabel.textColor = #colorLiteral(red: 0.6802619696, green: 0.9382658601, blue: 0.7976928353, alpha: 1)
                    analyzeBtnText = "Normal Anion Gap"

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let correctedAG = "\(anionGapCorrection.oneDecimalPlace)"

                    let  anionGapString =  "Normal Anion Gap at \(AnionGap.oneDecimalPlace) \nCorrected for for albumin was \(anionGapCorrection.oneDecimalPlace) " + metaAcid

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)


                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: correctedAG)
                    attributedText.apply(font:newFont, subString: correctedAG)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Normal Anion Gap")
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: "Normal Anion Gap")

                    //4 set the textLabel
                    anionGaplbl = attributedText


                    print("Normal Gap \(AnionGap.oneDecimalPlace).")


                }

                else {

                    // We dont calculate the deltaRatio

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let correctedAG = "\(anionGapCorrection.oneDecimalPlace)"

                    let  anionGapString =  "Normal Anion Gap at \(AnionGap.oneDecimalPlace) \nCorrected for for albumin was \(anionGapCorrection.oneDecimalPlace) " + metaAcid

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)


                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: correctedAG)
                    attributedText.apply(font:newFont, subString: correctedAG)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "Normal Anion Gap")
                    attributedText.apply(color:UIColor(Color.BlueYonder), subString: "Normal Anion Gap")

                    //4 set the textLabel
                    anionGaplbl = attributedText



                    isHiddenDeltaButton = false
                    deltaButtonText = "Anion Gap - \(anionGapCorrection.oneDecimalPlace)"
                    print("Normal Gap \(AnionGap.oneDecimalPlace).")
                    //anionGapLabel.textColor = #colorLiteral(red: 0.6802619696, green: 0.9382658601, blue: 0.7976928353, alpha: 1)
                    analyzeBtnText = "Normal Anion Gap"
                }

            case 12...100:

                if pH_value! < 7.35 || compensated_acidosis_Metabolic_Ph.contains(pH_value!) && hc03 < 22
                {

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let correctedAG = "\(anionGapCorrection.oneDecimalPlace)"
                    let newDeltaRatio = "\(deltaRatio.oneDecimalPlace)"

                    let  anionGapString = "High Anion Gap Metabolic Acidosis (HAGMA)\nThe Anion Gap was \(AnionGap.oneDecimalPlace) \nCorrected for albumin was \(anionGapCorrection.oneDecimalPlace)\n\nThe ∆ delta gap ratio is \(deltaRatio.oneDecimalPlace) which suggests a " + deltaRatioExplanation

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newDeltaRatio)
                    attributedText.apply(font:newFont, subString: newDeltaRatio)

                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: correctedAG)
                    attributedText.apply(font:newFont, subString: correctedAG)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "High Anion Gap Metabolic Acidosis (HAGMA)")
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "High Anion Gap Metabolic Acidosis (HAGMA)")

                    //4 set the textLabel
                    anionGaplbl = attributedText



                    print("Positive Anion Gap Metabolic Acidosis. The Anion Gap is calculated at \(anionGapCorrection.oneDecimalPlace). ")
                    print("\(deltaRatio) deltaRatio") // calls the delta gap because the Anion Gap is high.
                    analyzeBtnText = "High Anion Gap Metabolic Acidosis"
                    //UnHide DeltaGap Button
                    isHiddenDeltaButton = false
                    deltaButtonText = "HAGMA"
                }

                else {

                    // We calculated it without including the deltaRatio.

                    // Here we have to create a string form of the new numbers calculated so i can be converted into an attributed text. Then pass it below.
                    let newAnioGap = "\(AnionGap.oneDecimalPlace)"
                    let correctedAG = "\(anionGapCorrection.oneDecimalPlace)"

                    let  anionGapString = "High Anion Gap Metabolic Acidosis (HAGMA)\nThe Anion Gap was \(AnionGap.oneDecimalPlace) \nCorrected for albumin was \(anionGapCorrection.oneDecimalPlace)"

                    let attributedText = NSMutableAttributedString.getAttributedString(fromString: anionGapString)

                    let newFont = UIFont.boldSystemFont(ofSize: 16)

                    // 1 Apply the attributes
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: newAnioGap)
                    attributedText.apply(font: newFont, subString: newAnioGap)

                    //2
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: deltaRatioExplanation)
                    attributedText.apply(font:newFont, subString: deltaRatioExplanation)


                    //3
                    attributedText.apply(color: UIColor(Color.BlueYonder), subString: correctedAG)
                    attributedText.apply(font:newFont, subString: correctedAG)

                    // 4 Underlines and highlights the string
                    attributedText.underLine(subString: "High Anion Gap Metabolic Acidosis (HAGMA)")
                    attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "High Anion Gap Metabolic Acidosis (HAGMA)")

                    //4 set the textLabel
                    anionGaplbl = attributedText


                    print("Positive Anion Gap Metabolic Acidosis. The Anion Gap is calculated at \(anionGapCorrection.oneDecimalPlace). ")


                    print("\(deltaRatio) deltaRatio") // calls the delta gap becayse the Anion Gap is high.

                    analyzeBtnText = "High Anion Gap Metabolic Acidosis"

                    //UnHide DeltaGap Button
                    isHiddenDeltaButton = false
                    deltaButtonText = "HAGMA"
                }

            default: break

            }
        }

    }

    //MARK: -  Arrow Display
     func DisplayArrows() {
        // First run the bicarb calculation based off c02 and pH an then see if there's a manual input in the textField, if so use that.
        bicarbCalc()

        // Hides the display images
        imageChange = ""
        imageChangePaC = ""
        imageChangeHC = ""


        //MARK: GUARD Guard statement saying that if the weight is not entered and the calculated button is pushed, Print this statement.

        // if we enter a C02 befor the pH, execute this guard statement first.
        guard let _  = pH_value else {
            // Code executed if the textField is left empty

            print ("Enter a pH to proceed") //Print statement on the console

            PaCOSideLabel = "Please enter a pH value" // Changes the textLabel's language

            return   }

        //initialize the class
        let abgRanges = AbgRangeVariables()

        // Initialize the bicarb value
        let hc03_value = Double(hcOTextField) ?? 0
 
        let naValue = Double(sodiumTextField) ?? 0

        let clValue = Double(chlorideTextField) ?? 0

        let albuminValue = Double(albuminTextField) ?? 0

        // Set the ABG struct to gasRanges
        var gasRanges = ABG(pH: pH_value ?? 0, c02: c02_value ?? 0, HC03: hc03_value, Sodium: naValue, Chloride: clValue, Albumin: albuminValue)



        if abgRanges.pH_normalRange.contains(gasRanges.pH)
        {
            imageChange = "Perfect"
            phSideLabel  = "pH is WNL"
        }

        if abgRanges.pH_Low_NormalRange.contains(gasRanges.pH)
        {
            imageChange = "Perfect"
            phSideLabel  = "pH is low-normal"
        }

        if abgRanges.compensated_alkalosis_Metabolic_Ph.contains(gasRanges.pH)
        {
            imageChange = "Perfect"
            phSideLabel  = "pH is high-normal"
        }

        if abgRanges.normalco2.contains(gasRanges.c02)
        {
            imageChangePaC = "Perfect"
            PaCOSideLabel  = "Normal PaC02"
        }


        if abgRanges.normalBicarb.contains(gasRanges.HC03!)
        {
            // We check to see if the HC03 textField is filled in first, and use that number. If not we calculate the bicarb and evaluate that number to see its condition.
            var hc03 = Double(hc03Calculation(c02: c02_value!, pH: pH_value!))!

            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)

            if hc03Text.count > 0 {  hc03 = Double(hc03Text) ?? 0 }

            gasRanges.HC03! = hc03
            imageChangeHC = "Perfect"
            HcSideLabel = "Normal Bicarbonate"
        }

        if abgRanges.ph_lowRange.contains(gasRanges.pH)
        {
            imageChange = "DownArrow"
            phSideLabel  = "pH \(gasRanges.pH) (Acidemia < 7.35)"
        }

        if gasRanges.c02 < 35.0
        {
            imageChangePaC = "DownArrow"
        }

        if gasRanges.HC03! < 22.0  {

            // We check to see if the HC03 textField is filled in first, and use that number. If not we calculate the bicarb and evaluate that number to see its condition.
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0

            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)

            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }

            gasRanges.HC03! = hc03
            HcSideLabel = "👇🏽 HC03"
            imageChangeHC = "DownArrow"
        }


        if gasRanges.pH > 7.45 {
            imageChange = "UpArrow"
            phSideLabel  = "pH \(gasRanges.pH) (Alkalemia > 7.45)"
        }


        if gasRanges.c02 > 45.0 {
            imageChangePaC = "UpArrow"
        }


        if gasRanges.HC03! > 26.0 {
            // We check to see if the HC03 textField is filled in first, and use that number. If not we calculate the bicarb and evaluate that number to see its condition.
            var hc03 = Double(hc03Calculation(c02: c02_value ?? 0, pH: pH_value ?? 0)) ?? 0

            let hc03Text = hcOTextField.trimmingCharacters(in: .whitespaces)

            if hc03Text.count > 0 {
                hc03 = Double(hc03Text) ?? 0
            }

            gasRanges.HC03! = hc03
            HcSideLabel = "☝🏽 HC03"
            imageChangeHC = "UpArrow"
        }

        // When the bicarb is low
        if (gasRanges.HC03! < 1.0) {
           imageChangeHC = "close_red"
        }

        // When the c02 is super low
        if ( gasRanges.c02 < 2.0) {

            imageChangeHC = "close_red"
        }

        // When the pH is too low
        if (gasRanges.pH < 6.0)  {

            imageChange = "close_red"

            resultLabel = NSAttributedString(string: "A pH of \(gasRanges.pH) is unrealistic, re-check your value.")

        }
    }
}

