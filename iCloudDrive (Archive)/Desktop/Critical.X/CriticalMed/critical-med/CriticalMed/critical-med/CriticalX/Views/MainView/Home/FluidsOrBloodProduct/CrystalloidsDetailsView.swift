//
//  CrystalloidsDetailsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 20/12/2021.
//

import SwiftUI

struct CrystalloidsDetailsView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        let indication = Text("INDICATIONS: ")
            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            .font(.system(size: 16).weight(.bold))
        
        let advantages = Text("ADVANTAGES: ")
            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            .font(.system(size: 16).weight(.bold))
        
        let disAdvantages = Text("DISADVANTAGES: ")
            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            .font(.system(size: 16).weight(.bold))
        
        let composition = Text("COMPOSITION: ")
            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            .font(.system(size: 16).weight(.bold))
        
        let overview = Text("OVERVIEW: ")
            .foregroundColor(Color.red)
            .font(.system(size: 16).weight(.bold))
        
        
        VStack(spacing: 0){
            Text("Crystalloids")
                .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .leading)
                .font(.system(size: 24).weight(.bold))
                .foregroundColor(Color.white)
                .padding(.top, 30)
                .padding(.leading, 15)
            
            VStack(alignment: .leading, spacing: 0){
                
                Text("D5W (5% Dextrose in Water)")
                    .font(.system(size: 14).weight(.bold))
                    .foregroundColor(Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)))
                    .padding(.top, 20)
                
                Text("\(indication)\nUsed as a KVO maintenance fluid. Provides water with a small amount of glucose. Ineffective for expanding the plasma volume.\n\n\(advantages)\nProvides free water when the serum sodium Na and CL levels are elevated.\n\n\(disAdvantages)\nExcess D5W can dilute electrolytes and plasma proteins resulting in hyponatremia and cellular edema.\n\n\(composition)\nOsmolarity: 252 mOsm/L; 50g Dextrose/L; 200 calories/L.")
                    .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                    .lineSpacing(2.0)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .padding(.bottom, 25)
                    .padding(.top, 20)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(CriticalDesign.Adaptive.canvas(for: colorScheme))
            .cornerRadius(8)
            .shadow(color: CriticalDesign.Adaptive.textPrimary(for: colorScheme), radius: 2, x: 0, y: 1)
            .padding(.top, 15)
            
            VStack(alignment: .leading, spacing: 0){
                
                Text("0.45% NS (0.45% Hypotonic Saline)")
                    .font(.system(size: 14).weight(.bold))
                    .foregroundColor(Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)))
                    .padding(.top, 20)
                
                Text("\(indication)\nFluid volume replacement. Treatment of hypertonic extracellular dehydration or hypovolemia in cases where the intake of fluids and electrolytes by normal routes is not possible.\n\n\(advantages)\nRehydration or the use of maintenance fluids without the side effects of excessive hypernatremia or hyperchloremia.\n\n\(disAdvantages)\nInterstitial and intracellular edema could result from hyponatremia.\n\n\(composition)\nSodium 77 mEq/L; Chloride 77 mEq/L; Osmolality: 154 mOsm/L.")
                    .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                    .lineSpacing(2.0)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .padding(.bottom, 25)
                    .padding(.top, 20)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(CriticalDesign.Adaptive.canvas(for: colorScheme))
            .cornerRadius(8)
            .shadow(color: CriticalDesign.Adaptive.textPrimary(for: colorScheme), radius: 2, x: 0, y: 1)
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 0){
                
                Text("0.9% NS (0.9% Normal Saline)")
                    .font(.system(size: 14).weight(.bold))
                    .foregroundColor(Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)))
                    .padding(.top, 20)
                
                Text("\(indication)\nReplacement, Treatment of metabolic alkalosis, A priming fluid for hemodialysis, to begin and end blood transfusions. Small volumes of 0.9% NaCl (preservative-free or bacteriostatic) are used to reconstitute or dilute other medications.\n\n\(advantages)\nResembles extracellular fluid. Reduces edema by osmotic effects. Helps maintain water distribution, fluid and electrolyte balance, acid-base equilibrium, and osmotic pressure.\n\n\(disAdvantages)\nDilutes RBC's and plasma proteins. Hyperchloremic Metabolic Acidosis.\n\n\(composition)\nOsmolarity: 308 mOsm/L; Na 154 mEq/L; Chloride 154 mEq/L.")
                    .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                    .lineSpacing(2.0)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .padding(.bottom, 25)
                    .padding(.top, 20)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(CriticalDesign.Adaptive.canvas(for: colorScheme))
            .cornerRadius(8)
            .shadow(color: CriticalDesign.Adaptive.textPrimary(for: colorScheme), radius: 2, x: 0, y: 1)
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 0){
                
                Text("PlasmaLyte (pH 7.4)")
                    .font(.system(size: 14).weight(.bold))
                    .foregroundColor(Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)))
                    .padding(.top, 20)
                
                Text("\(overview)\nPlasmaLyte is a multi-formulated family of balanced crystalloids which closely mimics human plasma for its electrolytes, osmolality, and pH content.\n\nPlasmaLyte is unique unlike other crystalloids because it also contains additional ions act as a buffer and contain anions such as acetate, gluconate and even lactate that are converted to bicarbonate, CO2, and water.\n\nThe recommended infusion rate is usually  500 ml to 3 liters/ 24 h. Roughly 40 mL/kg/24h in adults, the\nelderly and adolescents.\n\n\(indication)\nHemorrhagic Shock, mild-moderate acidosis, fluid replacement (e.g., after burns, head injury, fracture, infection, intraoperative, etc.)\n\n\(advantages)\nCorrects acid-base balance issues such as acidosis which addressing volume and electrolyte deficiencies.\n\n\(disAdvantages)\nFluid overload, peripheral/pulmonary edema, weight gain, and increased / worsening intracranial pressure. Contraindicated in those with Hyperkalemia, Hypochlorhydria, Metabolic or respiratory alkalosis, heart blocks, renal failure.\n\nMay cause hypocalcemia (contents contain no calcium) - due to an increase in plasma pH, its alkalinizing effect may lower the concentration of ionized (not protein-bound) calcium.\n\n\(composition)\npH: 7.4, Osmolarity: 295 mOsm/l (approx.), Na+: 140 mEq/L , K+: 5.0 mEq/L, Mg: 3.0 mEq/L, Cl-: 98 mEq/L, Sodium Acetate trihydrate (CH3COO-): 27 mEq/L , Sodium Gluconate (C6H11O7-): 23 mEq/L.")
                    .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                    .lineSpacing(2.0)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .padding(.bottom, 25)
                    .padding(.top, 20)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(CriticalDesign.Adaptive.canvas(for: colorScheme))
            .cornerRadius(8)
            .shadow(color: CriticalDesign.Adaptive.textPrimary(for: colorScheme), radius: 2, x: 0, y: 1)
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 0){
                
                Text("3% Saline (3% Hypertonic Saline)")
                    .font(.system(size: 14).weight(.bold))
                    .foregroundColor(Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)))
                    .padding(.top, 20)
                
                Text("\(indication)\nTo increase the serum sodium and plasma volume. Moderate inflammatory response in patients who are in shock.\n\n\(advantages)\nIt takes less fluid to resuscitate. Improves cardiac output and blood flow. It is as effective as mannitol in patients with increased intracranial pressure.\n\n\(disAdvantages)\nIf administered too fast, the patient could become hypokalemic and the Na could increase approximately 2-3 mmol/L. Seizures and dysrhythmias could result.\n\n\(composition)\nOsmolarity: 1026 mOsm/L; Na 512 mEq/L; Chloride 513 mEq/L.")
                    .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                    .lineSpacing(2.0)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .padding(.bottom, 25)
                    .padding(.top, 20)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(CriticalDesign.Adaptive.canvas(for: colorScheme))
            .cornerRadius(8)
            .shadow(color: CriticalDesign.Adaptive.textPrimary(for: colorScheme), radius: 2, x: 0, y: 1)
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 0){
                
                Text("Ringers Lactate")
                    .font(.system(size: 14).weight(.bold))
                    .foregroundColor(Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)))
                    .padding(.top, 20)
                
                Text("\(indication)\nFluid volume replacement for hemorrhagic shock. Contains the same components as the interstitial fluid- which tends to shift to the vasculature during hemorrhage.\n\n\(advantages)\nPotassium and calcium promote myocardial contractility. The fluid is isotonic. Electrolytes are balanced and lactate is converted to glucose and carbonic acid.\n\n\(disAdvantages)\nDilutes the plasma proteins in red blood cells.\n\n\(composition)\nSodium  130 mEq/L, Chloride: 109 mEq/L, Potassium: 4 mEq/L, Calcium: 3 mEq/L, Lactate: 27 mEq/L, pH: 6.5, Osmolarity: 275 mOsm/liter.")
                    .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                    .lineSpacing(2.0)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    .padding(.bottom, 25)
                    .padding(.top, 20)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(CriticalDesign.Adaptive.canvas(for: colorScheme))
            .cornerRadius(8)
            .shadow(color: CriticalDesign.Adaptive.textPrimary(for: colorScheme), radius: 2, x: 0, y: 1)
            .padding(.top, 10)

        }
    }
}

struct CrystalloidsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CrystalloidsDetailsView()
    }
}
