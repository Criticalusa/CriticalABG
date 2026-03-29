//
//  ClinicalPharmacologyDataModel.swift
//  CriticalX
//
//  Created by Macbook 4 on 13/12/2021.
//  Updated via Gemini on 2026-01-06.
//

import Foundation
import SwiftUI

struct ClinicalPharmacologyDataModel: Identifiable {
    let id = UUID()
    
    let title: String
    let brandName: String
    let dose: String
    private let _clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView
    
    /// Returns correct medication details using name-based lookup
    /// This fixes index misalignment issues in the static data
    var clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView {
        // Use name-based lookup to get correct details
        if let correctDetails = ClinicalPharamcologyDetailsModelView.findByName(title) {
            return correctDetails
        }
        // Fallback to stored reference if name lookup fails
        return _clinicalPharmaDetails
    }
    
    init() {
        self.title = ""
        self.brandName = ""
        self.dose = ""
        self._clinicalPharmaDetails = ClinicalPharamcologyDetailsModelView()
    }
    
    init(title: String, brandName: String, dose: String, clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView) {
        self.title = title
        self.brandName = brandName
        self.dose = dose
        self._clinicalPharmaDetails = clinicalPharmaDetails
    }
    
}

extension ClinicalPharmacologyDataModel {
    
    // MARK: - Alphabetized Data Source
    static let pharmacologyData = [
        ClinicalPharmacologyDataModel(title: "Adenosine", brandName: "Adenocard", dose: "6 mg, 12 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[0]),
        ClinicalPharmacologyDataModel(title: "Albumin (Human) 5, 25%", brandName: "Plasbumin-5, 25", dose: "12.5-25 g", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[1]),
        ClinicalPharmacologyDataModel(title: "Albuterol", brandName: "Proventil", dose: "2.5 mg nebulized", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[2]),
        ClinicalPharmacologyDataModel(title: "Amiodarone", brandName: "Cordarone ®", dose: "300 mg, 150 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[3]),
        ClinicalPharmacologyDataModel(title: "Ampicillin-Sulbactam", brandName: "Unasyn", dose: "1.5-3 g", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[64]),
        ClinicalPharmacologyDataModel(title: "Angiotensin II", brandName: "Giapreza", dose: "20-80 ng/kg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[77]),
        ClinicalPharmacologyDataModel(title: "Aspirin", brandName: "ASA", dose: "324 mg PO", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[4]),
        ClinicalPharmacologyDataModel(title: "Atenolol", brandName: "Tenormin ®", dose: "5.0 mg IVP", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[5]),
        ClinicalPharmacologyDataModel(title: "Atropine Sulfate", brandName: "AtroPen", dose: "0.5 - 1.0 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[6]),
        ClinicalPharmacologyDataModel(title: "Bumetanide", brandName: "Bumex ®", dose: "0.5-1.0 mg IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[7]),
        ClinicalPharmacologyDataModel(title: "Calcium Salt", brandName: "Ca Chloride, Ca Gluconate", dose: "500 mg -1g, 10%", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[8]),
        ClinicalPharmacologyDataModel(title: "Cefazolin", brandName: "Ancef", dose: "1-2 g", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[65]),
        ClinicalPharmacologyDataModel(title: "Cefepime", brandName: "Maxipime", dose: "1-2 g", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[9]),
        ClinicalPharmacologyDataModel(title: "Ceftriaxone", brandName: "Rocephin", dose: "1-2 g", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[66]),
        ClinicalPharmacologyDataModel(title: "Ciprofloxacin", brandName: "Cipro", dose: "400 mg IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[67]),
        ClinicalPharmacologyDataModel(title: "Cisatracurium", brandName: "Nimbex", dose: "1 to 2 mcg/kg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[10]),
        ClinicalPharmacologyDataModel(title: "Clevidipine", brandName: "Cleviprex", dose: "1-6 mg/hr", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[78]),
        ClinicalPharmacologyDataModel(title: "Daptomycin", brandName: "Cubicin", dose: "4-6 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[11]),
        ClinicalPharmacologyDataModel(title: "Desmopressin", brandName: "DDAVP", dose: "0.3 mcg/kg IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[12]),
        ClinicalPharmacologyDataModel(title: "Dexamethasone", brandName: "Decadron ®", dose: "10 mg IV, IM", clinicalPharmaDetails:  ClinicalPharamcologyDetailsModelView.pharmaDetails[13]),
        ClinicalPharmacologyDataModel(title: "Dexmedetomidine", brandName: "Precedex", dose: "0.2-0.7 mcg/kg/hr", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[72]),
        ClinicalPharmacologyDataModel(title: "Diazepam", brandName: "Valium ®", dose: "5-10 mg, IV/IM", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[14]),
        ClinicalPharmacologyDataModel(title: "Diltiazem", brandName: "Cardizem ®", dose: "0.25 - 0.35 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[15]),
        ClinicalPharmacologyDataModel(title: "Diphenhydramine", brandName: "Benadryl ®", dose: "25-50 mg IVP", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[16]),
        ClinicalPharmacologyDataModel(title: "Dopamine", brandName: "Intropin ®", dose: "2-20 mcg/kg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[17]),
        ClinicalPharmacologyDataModel(title: "Dobutamine", brandName: "Dobutrex", dose: "2.5-20 mcg/kg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[18]),
        ClinicalPharmacologyDataModel(title: "Droperidol", brandName: "Inapsine", dose: "0.625-2.5 mg IV/IM", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[80]),
        ClinicalPharmacologyDataModel(title: "Epinephrine", brandName: "Adrenaline ®", dose: "1.0 mg IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[19]),
        ClinicalPharmacologyDataModel(title: "Eptifibatide", brandName: "Integrilin ®", dose: "180 mcg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[20]),
        ClinicalPharmacologyDataModel(title: "Esmolol", brandName: "Brevibloc", dose: "50-200 mcg/kg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[73]),
        ClinicalPharmacologyDataModel(title: "Etomidate", brandName: "Amidate ®", dose: "0.3 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[21]),
        ClinicalPharmacologyDataModel(title: "Fentanyl Citrate", brandName: "Sublimaze ®", dose: "1-2 mcg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[22]),
        ClinicalPharmacologyDataModel(title: "Fosphenytoin Sodium", brandName: "Cerebyx ®", dose: "15 to 20 mg PE/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[23]),
        ClinicalPharmacologyDataModel(title: "Furosemide", brandName: "Lasix ®", dose: "20 to 80 mg IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[24]),
        ClinicalPharmacologyDataModel(title: "Gentamicin", brandName: "Garamycin", dose: "5 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[68]),
        ClinicalPharmacologyDataModel(title: "Glucagon", brandName: "GlucaGen", dose: "0.5-1.0 mg IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[25]),
        ClinicalPharmacologyDataModel(title: "Haloperidol", brandName: "Haldol ®", dose: "2 to 5 mg IM", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[26]),
        ClinicalPharmacologyDataModel(title: "Heparin", brandName: "Heparin", dose: "80 units/kg bolus", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[79]),
        ClinicalPharmacologyDataModel(title: "Hydralazine", brandName: "Apresoline ®", dose: "5-40 mg IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[27]),
        ClinicalPharmacologyDataModel(title: "Hydromorphone", brandName: "Dilaudid ®", dose: "0.5-2.0 mg ", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[28]),
        ClinicalPharmacologyDataModel(title: "Insulin (Regular)", brandName: "Humulin R, Novolin R", dose: "DKA: 0.1 u/kg/hr; HyperK: 10 u IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[29]),
        ClinicalPharmacologyDataModel(title: "Ipratropium Bromide", brandName: "Atrovent ®", dose: "0.5 mg via nebulizer", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[30]),
        ClinicalPharmacologyDataModel(title: "Ketamine", brandName: "Ketalar ®", dose: "1-2 mg/kg IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[31]),
        ClinicalPharmacologyDataModel(title: "Labetalol", brandName: "Trandate ®", dose: "10-20 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[32]),
        ClinicalPharmacologyDataModel(title: "Levalbuterol", brandName: "Xopenex", dose: "0.63 - 1.25 mg Neb", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[33]),
        ClinicalPharmacologyDataModel(title: "Levetiracetam", brandName: "Keppra ®", dose: "1500-3000 mg IV load", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[34]),
        ClinicalPharmacologyDataModel(title: "Levofloxacin", brandName: "Levaquin", dose: "500-750 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[69]),
        ClinicalPharmacologyDataModel(title: "Levothyroxine", brandName: "Synthroid, T4", dose: "200-400 mcg IV load", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[35]),
        ClinicalPharmacologyDataModel(title: "Lidocaine", brandName: "Xylocaine ®", dose: "1-1.5 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[36]),
        ClinicalPharmacologyDataModel(title: "Linezolid", brandName: "Zyvox", dose: "600 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[37]),
        ClinicalPharmacologyDataModel(title: "Lorazepam", brandName: "Ativan ®", dose: "0.5–2 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[38]),
        ClinicalPharmacologyDataModel(title: "Magnesium Sulfate", brandName: "MgSO4", dose: "2-4 gms", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[39]),
        ClinicalPharmacologyDataModel(title: "Mannitol", brandName: "Osmitrol", dose: "50-100 gms", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[40]),
        ClinicalPharmacologyDataModel(title: "Meropenem", brandName: "Merrem", dose: "1 g", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[41]),
        ClinicalPharmacologyDataModel(title: "Metoclopramide", brandName: "Reglan", dose: "10 mg IV", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[42]),
        ClinicalPharmacologyDataModel(title: "Methylprednisolone", brandName: "Solu-Medrol ®", dose: "125 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[43]),
        ClinicalPharmacologyDataModel(title: "Metronidazole", brandName: "Flagyl", dose: "500 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[70]),
        ClinicalPharmacologyDataModel(title: "Metoprolol", brandName: "Lopressor ®", dose: "5 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[44]),
        ClinicalPharmacologyDataModel(title: "Midazolam", brandName: "Versed ®", dose: "0.05-0.1 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[45]),
        ClinicalPharmacologyDataModel(title: "Milrinone", brandName: "Primacor", dose: "0.375-0.75 mcg/kg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[74]),
        ClinicalPharmacologyDataModel(title: "Morphine Sulfate", brandName: "MSO4 ®", dose: "0.05-0.1 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[46]),
        ClinicalPharmacologyDataModel(title: "Naloxone", brandName: "Narcan ®", dose: "0.4 - 2 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[47]),
        ClinicalPharmacologyDataModel(title: "Nicardipine", brandName: "Cardene", dose: "5-15 mg/hr", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[71]),
        ClinicalPharmacologyDataModel(title: "Nitroglycerine", brandName: "Nitrostat ®", dose: "0.4 mg SL", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[48]),
        ClinicalPharmacologyDataModel(title: "Nitroprusside", brandName: "Nipride", dose: "0.25-10 mcg/kg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[76]),
        ClinicalPharmacologyDataModel(title: "Norepinephrine", brandName: "Levophed", dose: "8-12 mcg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[49]),
        ClinicalPharmacologyDataModel(title: "Octreotide", brandName: "Sandostatin ®", dose: "50-200 mcg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[50]),
        ClinicalPharmacologyDataModel(title: "Ondansetron", brandName: "Zofran ®", dose: "4 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[51]),
        ClinicalPharmacologyDataModel(title: "Olanzapine", brandName: "Zyprexa", dose: "5-10 mg IM", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[81]),
        ClinicalPharmacologyDataModel(title: "Oxytocin", brandName: "Pitocin ®", dose: "0.5-40 mUnit/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[52]),
        ClinicalPharmacologyDataModel(title: "Pantoprazole", brandName: "Protonix ®", dose: "20-80 mg q24", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[53]),
        ClinicalPharmacologyDataModel(title: "Phenylephrine", brandName: "Neo-Synephrine", dose: "50-200 mcg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[17]),
        ClinicalPharmacologyDataModel(title: "Piperacillin-Tazobactam", brandName: "Zosyn", dose: "3.375 - 4.5 g", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[54]),
        ClinicalPharmacologyDataModel(title: "Potassium Chloride", brandName: "KCL ®", dose: "10-80 mEq q24", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[55]),
        ClinicalPharmacologyDataModel(title: "Procainamide", brandName: "Pronestyl ®", dose: "20 mg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[56]),
        ClinicalPharmacologyDataModel(title: "Propofol", brandName: "Diprivan", dose: "5-50 mcg/kg/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[75]),
        ClinicalPharmacologyDataModel(title: "Rocuronium", brandName: "Zemuron ®", dose: "0.6-1.2 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[57]),
        ClinicalPharmacologyDataModel(title: "Sodium Bicarbonate", brandName: "NaHCO3", dose: "1 mEq/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[58]),
        ClinicalPharmacologyDataModel(title: "Succinylcholine", brandName: "Anectine", dose: "1-2 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[59]),
        ClinicalPharmacologyDataModel(title: "Terbutaline", brandName: "Brethine ®", dose: "0.25 mg SQ", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[60]),
        ClinicalPharmacologyDataModel(title: "Thiamine", brandName: "Vitamin B-1", dose: "100 mg / 500 mg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[61]),
        ClinicalPharmacologyDataModel(title: "Tranexamic Acid (TXA)", brandName: "Cyklokapron ®", dose: "1g bolus; 1g drip", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[62]),
        ClinicalPharmacologyDataModel(title: "Vancomycin", brandName: "Vancocin", dose: "15-20 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[63]),
        ClinicalPharmacologyDataModel(title: "Vasopressin", brandName: "Pitressin", dose: "0.03 units/min", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[16]),
        ClinicalPharmacologyDataModel(title: "Vecuronium", brandName: "Norcuron ®", dose: "0.1 mg/kg", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[64]),
        ClinicalPharmacologyDataModel(title: "Ziprasidone", brandName: "Geodon", dose: "10-20 mg IM", clinicalPharmaDetails: ClinicalPharamcologyDetailsModelView.pharmaDetails[82])
    ]
}


struct ClinicalPharamcologyDetailsModelView {
    
    let mainTitle: String
    let brandName: String
    let mechansim: String
    let adverseEffects: String
    let dose: String
    let pregnancyClass: String
    let pregLettercolor: Color
    let DrugClass: String
    let indications: String
    let contraindiction: String
    let onSet: String
    let halfLife: String
    let duration: String
    let absorbtion: String
    let distribution: String
    let metaBolism: String
    let excretion: String
    let pregnancyExplanation: String
    let criticalPearls: String
    
    // MARK: - Computed Route Property
    /// Infers the administration route from absorption data or dose information
    /// Priority: 1) Nebulized (explicit), 2) Absorption field, 3) Dose field, 4) Default IV
    var route: String {
        let absorptionLower = absorbtion.lowercased()
        let doseLower = dose.lowercased()

        // PRIORITY 1: Check for nebulized first (common respiratory meds)
        // This catches albuterol, levalbuterol, ipratropium, etc.
        if doseLower.contains("neb") || doseLower.contains("nebulized") ||
           absorptionLower.contains("nebulized") || absorptionLower.contains("nebulizer") {
            return "NEB"
        }

        // PRIORITY 2: Check absorption field for route info
        if absorptionLower.contains("iv only") || absorptionLower.contains("iv administration") {
            return "IV"
        } else if absorptionLower.contains("oral") && absorptionLower.contains("iv") {
            return "IV / PO"
        } else if absorptionLower.contains("im") || absorptionLower.contains("intramuscular") {
            return "IV / IM"
        } else if absorptionLower.contains("subcutaneous") || absorptionLower.contains("sq") || absorptionLower.contains("subq") {
            return "SQ"
        } else if absorptionLower.contains("inhalation") || absorptionLower.contains("inhaled") {
            return "INH"
        } else if absorptionLower.contains("sublingual") || absorptionLower.contains("sl") {
            return "SL"
        } else if absorptionLower.contains("oral") || absorptionLower.contains("po") {
            return "PO"
        }

        // PRIORITY 3: Check dose field for route hints (but avoid false positives)
        // Only use dose field if absorption didn't give us a clear answer
        if doseLower.contains("ivp") || doseLower.contains("iv push") {
            return "IVP"
        } else if doseLower.contains("sq") || doseLower.contains("subq") || doseLower.contains("subcutaneous") {
            return "SQ"
        } else if doseLower.contains("sl") || doseLower.contains("sublingual") {
            return "SL"
        } else if doseLower.contains("po") || doseLower.contains("oral") {
            return "PO"
        } else if doseLower.contains("iv/im") || doseLower.contains("iv, im") || doseLower.contains("iv,im") ||
                  (doseLower.contains("iv") && doseLower.contains("im") && !doseLower.contains("min")) {
            // Check for IV/IM combination BEFORE checking for just "im"
            // Catches patterns like "IV/IM", "IV, IM", "10 mg IV, IM"
            return "IV / IM"
        } else if doseLower.contains("im") && !doseLower.contains("min") {
            // "im" but not "min" to avoid false positives from "mcg/min"
            return "IM"
        } else if doseLower.contains("mcg/kg/min") || doseLower.contains("mg/hr") || doseLower.contains("units/min") || doseLower.contains("mcg/min") {
            return "IV Infusion"
        }

        // PRIORITY 4: Default for most critical care meds is IV
        return "IV"
    }
    
    /// Returns the SF Symbol icon for the route
    var routeIcon: String {
        switch route {
        case "IV", "IVP", "IV Infusion":
            return "syringe.fill"
        case "IV / IM", "IM":
            return "cross.vial.fill"
        case "IV / PO", "PO":
            return "pills.fill"
        case "SQ":
            return "bandage.fill"
        case "NEB":
            return "aqi.medium"      // Nebulizer icon
        case "INH":
            return "wind"
        case "SL":
            return "mouth.fill"
        default:
            return "syringe.fill"
        }
    }

    /// Returns the color for the route badge
    var routeColor: Color {
        switch route {
        case "IV", "IVP":
            return CriticalDesign.Colors.accentBlue
        case "IV Infusion":
            return CriticalDesign.Colors.accentTeal
        case "IV / IM", "IM":
            return CriticalDesign.Colors.accentPurple
        case "IV / PO":
            return CriticalDesign.Colors.accentGreen
        case "PO":
            return CriticalDesign.Colors.accentGreen
        case "SQ":
            return CriticalDesign.Colors.accentOrange
        case "NEB":
            return CriticalDesign.Colors.accentTeal  // Same teal as INH
        case "INH":
            return CriticalDesign.Colors.accentTeal
        case "SL":
            return Color.pink
        default:
            return CriticalDesign.Colors.accentBlue
        }
    }
    
    init() {
        
        self.mainTitle = ""
        self.brandName = ""
        self.mechansim = ""
        self.adverseEffects = ""
        self.dose = ""
        self.pregnancyClass = ""
        self.pregLettercolor = Color.blue // Default color
        self.DrugClass = ""
        self.indications = ""
        self.contraindiction = ""
        self.onSet = ""
        self.halfLife = ""
        self.duration = ""
        self.absorbtion = ""
        self.distribution = ""
        self.metaBolism = ""
        self.excretion = ""
        self.pregnancyExplanation = ""
        self.criticalPearls = ""
        
    }
    
    init(mainTitle: String, brandName: String, mechansim: String,adverseEffects: String,dose: String,pregnancyClass: String,pregLettercolor: Color,DrugClass: String, indications: String,contraindiction: String, onSet: String, halfLife: String, duration: String, absorbtion: String, distribution: String, metaBolism: String, excretion: String, pregnancyExplanation: String, criticalPearls: String) {
        self.mainTitle = mainTitle
        self.brandName = brandName
        self.mechansim = mechansim
        self.adverseEffects = adverseEffects
        self.dose = dose
        self.pregnancyExplanation = pregnancyExplanation
        self.pregnancyClass = pregnancyClass
        self.pregLettercolor = pregLettercolor
        self.DrugClass = DrugClass
        self.indications = indications
        self.contraindiction = contraindiction
        self.onSet = onSet
        self.halfLife = halfLife
        self.duration = duration
        self.absorbtion = absorbtion
        self.distribution = distribution
        self.metaBolism = metaBolism
        self.excretion = excretion
        self.criticalPearls = criticalPearls
    }
    
    
    
}
enum pregnancyType {
    case A, B, C, D, X, UseWithCaution
}


//Switch on pregnancy ENUM to pass a pregnancy category for SF symbol
func PregnancyLetter(pregCategory: pregnancyType) -> String {
    
    switch pregCategory {
        
    case .A :
        return "a.square"
    case .B :
        return "b.square"
    case .C :
        return "c.square"
    case .D :
        return "d.square"
    case.X :
        return "x.square"
    case.UseWithCaution :
        return "exclamationmark.triangle"
    }
    
    
}

// We switch on pregnancy category and return a color to pass

func PregnancyColor(pregCategory: pregnancyType) -> Color {
    
    switch pregCategory {
        
    case .A :
        return Color.green
    case .B :
        return Color.blue
    case .C :
        return Color.orange
    case .D :
        return Color.red
    case.X :
        return  Color.black
    case.UseWithCaution:
        return Color.red
    }
    
    
}

extension ClinicalPharamcologyDetailsModelView {
    
    // MARK: - Name-Based Lookup (fixes index misalignment issues)
    /// Finds medication details by matching mainTitle or brandName
    /// This bypasses broken index references in pharmacologyData
    /// IMPORTANT: Uses strict matching to avoid "norepinephrine" matching "epinephrine"
    static func findByName(_ name: String) -> ClinicalPharamcologyDetailsModelView? {
        let searchName = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1. EXACT match on mainTitle (highest priority)
        if let exactMatch = pharmaDetails.first(where: { $0.mainTitle.lowercased() == searchName }) {
            return exactMatch
        }
        
        // 2. EXACT match on brandName (without special characters)
        let cleanSearch = searchName.replacingOccurrences(of: "®", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        if let exactBrandMatch = pharmaDetails.first(where: { 
            $0.brandName.lowercased().replacingOccurrences(of: "®", with: "").trimmingCharacters(in: .whitespacesAndNewlines) == cleanSearch 
        }) {
            return exactBrandMatch
        }
        
        // 3. mainTitle STARTS WITH search term (e.g., "norepi" finds "Norepinephrine")
        if let startsWithMatch = pharmaDetails.first(where: { $0.mainTitle.lowercased().hasPrefix(searchName) }) {
            return startsWithMatch
        }
        
        // 4. brandName STARTS WITH search term
        if let brandStartsWithMatch = pharmaDetails.first(where: { 
            $0.brandName.lowercased().replacingOccurrences(of: "®", with: "").trimmingCharacters(in: .whitespacesAndNewlines).hasPrefix(cleanSearch) 
        }) {
            return brandStartsWithMatch
        }
        
        // 5. mainTitle CONTAINS search term (but NOT the reverse - prevents "norepinephrine" matching "epinephrine")
        // Only if search term is at least 4 characters to avoid too-broad matches
        if searchName.count >= 4 {
            if let containsMatch = pharmaDetails.first(where: { $0.mainTitle.lowercased().contains(searchName) }) {
                return containsMatch
            }
        }
        
        // 6. brandName CONTAINS search term
        if searchName.count >= 4 {
            if let brandContainsMatch = pharmaDetails.first(where: { $0.brandName.lowercased().contains(searchName) }) {
                return brandContainsMatch
            }
        }
        
        return nil
    }
    
    static let pharmaDetails = [
        // 0. Adenosine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Adenosine",
            brandName: "Adenocard ®",
            mechansim: "Adenosine is an endogenous nucleoside that temporarily blocks AV node conduction.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of adenosine as the hard reset button for the heart — it briefly stops the AV node, interrupting reentry circuits that cause supraventricular tachycardia (SVT). The effect is ultra-short (10 seconds), so the patient experiences a few seconds of asystole before normal sinus rhythm (hopefully) returns.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to A1 adenosine receptors in the AV node\n"
            + "• Activates potassium channels → Hyperpolarizes AV node cells\n"
            + "• Slows conduction through AV node → Breaks reentry circuit\n"
            + "• Half-life <10 seconds → Effect wears off immediately\n\n"
            + "##The key:## Adenosine only works for reentrant SVT (AVNRT, AVRT). It doesn't work for atrial fibrillation, atrial flutter, or ventricular tachycardia. It's diagnostic as well as therapeutic — if adenosine terminates the rhythm, you know it was SVT.\n\n"
            + "##High-yield point:## Adenosine must be given as a rapid IV push followed immediately by a saline flush. Its half-life is <10 seconds, so if you push it slowly, it gets metabolized before reaching the heart. Expect a brief period of asystole (5-15 seconds) — warn the patient they'll feel like they're dying for a moment.",
            adverseEffects: "##Common:##\n\n"
            + "• Flushing (almost universal)\n"
            + "• Chest pain or tightness (transient)\n"
            + "• Dyspnea (feeling of breathlessness)\n"
            + "• Brief asystole (expected, usually 5-15 seconds)\n"
            + "• Nausea\n"
            + "• Headache\n\n"
            + "##Serious:##\n\n"
            + "• Prolonged asystole (rare, may need temporary pacing)\n"
            + "• Bronchoconstriction (in asthmatics — CONTRAINDICATED)\n"
            + "• Atrial fibrillation (can trigger AF in susceptible patients)\n"
            + "• Hypotension (transient)\n\n"
            + "##The bronchospasm problem:##\n\n"
            + "Adenosine can cause severe bronchospasm in patients with asthma or COPD. This is an absolute contraindication. If the patient has reactive airway disease, use diltiazem or verapamil instead.\n\n"
            + "##Red flags:##\n\n"
            + "• Prolonged asystole >15 seconds (consider pacing)\n"
            + "• Wheezing or severe bronchospasm (stop immediately)\n"
            + "• Rhythm doesn't convert (may not be SVT — consider other diagnoses)",
            dose: "##SVT (paroxysmal supraventricular tachycardia):##\n\n"
            + "• First dose: 6 mg rapid IV push, followed immediately by 20 mL saline flush\n"
            + "• If no response after 1-2 minutes: 12 mg rapid IV push + flush\n"
            + "• If still no response: 12 mg again (max total 30 mg)\n\n"
            + "##Administration (CRITICAL):##\n\n"
            + "• Must use large-bore IV (preferably antecubital)\n"
            + "• Push as rapidly as possible (1-2 seconds)\n"
            + "• Immediately follow with 20 mL saline flush (also rapid)\n"
            + "• Elevate arm after push to speed delivery\n"
            + "• If using central line, reduce dose to 3 mg initially\n\n"
            + "##Why rapid push is critical:## Adenosine has a half-life of <10 seconds. If you push slowly, it gets metabolized before reaching the heart and won't work.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Antiarrhythmic, endogenous nucleoside.\n\n"
            + "First-line for terminating reentrant supraventricular tachycardia (SVT).",
            indications: "##Primary indications:##\n\n"
            + "• Paroxysmal supraventricular tachycardia (PSVT)\n"
            + "• AVNRT (AV nodal reentrant tachycardia)\n"
            + "• AVRT (AV reentrant tachycardia, including WPW)\n"
            + "• Diagnostic tool for wide-complex tachycardia of unknown origin\n\n"
            + "##You'll reach for adenosine when:##\n\n"
            + "• Patient has regular narrow-complex tachycardia (SVT)\n"
            + "• Vagal maneuvers (Valsalva, carotid massage) fail to terminate SVT\n"
            + "• You need to differentiate SVT from atrial flutter or V-tach\n\n"
            + "##Classic scenarios:##\n\n"
            + "• 25-year-old with sudden-onset palpitations, HR 180, regular narrow-complex → Adenosine 6 mg\n"
            + "• SVT refractory to Valsalva maneuver → Adenosine 6 mg IV\n"
            + "• Wide-complex tachycardia of unknown origin → Adenosine to differentiate SVT from V-tach",
            contraindiction: "##Absolute:##\n\n"
            + "• Asthma or reactive airway disease (causes bronchospasm)\n"
            + "• Second- or third-degree AV block (unless pacemaker in place)\n"
            + "• Sick sinus syndrome (unless pacemaker in place)\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Atrial fibrillation or flutter (adenosine can increase ventricular rate)\n"
            + "• Recent MI (can trigger arrhythmias)\n"
            + "• Heart transplant patients (extremely sensitive; use 1-3 mg)\n"
            + "• Caffeine or theophylline use (blocks adenosine receptors → need higher dose)\n"
            + "• Dipyridamole or carbamazepine use (potentiates adenosine → need lower dose)\n\n"
            + "##Critical safety point:## Adenosine is CONTRAINDICATED in asthma and COPD because it causes bronchospasm via A2B receptor activation. If the patient has any history of reactive airway disease, use diltiazem or amiodarone instead.",
            onSet: "15-30 sec",
            halfLife: "Less than 10 sec",
            duration: "1-2 min",
            absorbtion: "N/A (IV only)",
            distribution: "Rapidly taken up by erythrocytes and vascular endothelium",
            metaBolism: "Erythrocytes & vascular endothelial cells (adenosine deaminase)",
            excretion: "Urine (as metabolites)",
            pregnancyExplanation: "Pregnancy Category C (but considered safe in practice). No teratogenic effects reported. Preferred over other antiarrhythmics in pregnancy for SVT.",
            criticalPearls: "##How to use adenosine safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Confirm patient does NOT have asthma or COPD (absolute contraindication)\n"
            + "• Get continuous ECG monitoring and defibrillator ready\n"
            + "• Warn the patient: \"You're going to feel terrible for about 10 seconds — chest pain, can't breathe, sense of impending doom. This is normal.\"\n"
            + "• Ensure large-bore IV in antecubital fossa\n"
            + "• Have crash cart and atropine ready (in case of prolonged asystole)\n\n"
            + "##While it's running:##\n\n"
            + "• Push 6 mg as rapidly as possible (1-2 seconds)\n"
            + "• Immediately follow with 20 mL saline flush (also rapid)\n"
            + "• Elevate arm to speed delivery\n"
            + "• Watch ECG — expect brief asystole, then (hopefully) normal sinus rhythm\n"
            + "• If no conversion after 1-2 minutes → Repeat with 12 mg\n\n"
            + "##Adenosine vs. Diltiazem for SVT:##\n\n"
            + "##Adenosine:##\n\n"
            + "• First-line for SVT\n"
            + "• Ultra-short half-life (<10 sec)\n"
            + "• Terminates reentry circuit\n"
            + "• Must push rapidly with flush\n\n"
            + "##Diltiazem:##\n\n"
            + "• Second-line if adenosine fails\n"
            + "• Longer duration (hours)\n"
            + "• Better for rate control if SVT doesn't convert\n\n"
            + "##Bottom line:## Try adenosine first (unless contraindicated). If it doesn't work, use diltiazem.\n\n"
            + "##Why adenosine sometimes doesn't work:##\n\n"
            + "• Patient on caffeine or theophylline (blocks adenosine receptors)\n"
            + "• IV too distal (drug metabolized before reaching heart)\n"
            + "• Pushed too slowly (half-life is <10 seconds)\n"
            + "• Not SVT (e.g., atrial flutter, atrial fib, V-tach)\n\n"
            + "If adenosine fails twice, the rhythm is probably NOT reentrant SVT. Consider other diagnoses.\n\n"
            + "##Diagnostic use of adenosine:##\n\n"
            + "Adenosine can help differentiate wide-complex tachycardia:\n\n"
            + "• If rhythm converts → Likely SVT with aberrancy\n"
            + "• If rhythm slows but doesn't convert → May be atrial flutter or atrial fib with aberrancy\n"
            + "• If no effect → Likely ventricular tachycardia\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving adenosine to an asthmatic (causes severe bronchospasm)\n"
            + "• Pushing too slowly (drug gets metabolized before reaching heart)\n"
            + "• Not following with rapid saline flush\n"
            + "• Not warning the patient (they panic when they feel the \"impending doom\")\n"
            + "• Using adenosine for atrial fib or flutter (doesn't work)\n\n"
            + "##The takeaway:##\n\n"
            + "Adenosine is the hard reset button for SVT — it briefly stops the AV node, breaking reentry circuits. It has an ultra-short half-life (<10 seconds), so it must be pushed rapidly with a saline flush. Expect brief asystole and severe (but transient) discomfort. Never use in asthmatics. If it doesn't work after 2-3 doses, the rhythm is probably not reentrant SVT."
        ),
        
        // 1. Albumin
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Albumin (Human) 5%, 25%",
            brandName: "Plasbumin-5, 25",
            mechansim: "Albumin works by increasing intravascular oncotic pressure, pulling fluid from interstitial spaces into circulation.",
            adverseEffects: "##Common:## Fluid overload, peripheral edema, nausea, vomiting.\n\n##Serious:## Pulmonary edema (especially with 25%), hypotension (rapid infusion), hypertension (volume overload), tachycardia, allergic/anaphylactic reactions.\n\n##Red Flags:## Worsening dyspnea, crackles on lung exam, sudden drop or spike in BP, urticaria, bronchospasm.",
            dose: "Adults: 12.5-25 g IV.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Colloid, plasma volume expander.",
            indications: "Hypovolemia, septic shock, burns, cirrhosis-related complications.",
            contraindiction: "Absolute: Hypersensitivity to albumin, severe anemia, decompensated heart failure.",
            onSet: "15-30 min",
            halfLife: "5-21 days",
            duration: "Intravascular effects last ~24 hours.",
            absorbtion: "Directly enters the bloodstream.",
            distribution: "Primarily intravascular.",
            metaBolism: "Degraded in the liver.",
            excretion: "Minimal renal excretion.",
            pregnancyExplanation: "Use with caution in pregnancy.",
            criticalPearls: "##How to use Albumin safely:##\n\n"
            + "• 5% Albumin: Best for hypovolemia (trauma, sepsis) — isotonic, expands volume\n"
            + "• 25% Albumin: Best for oncotic pressure support (cirrhosis) — hypertonic, pulls fluid in\n\n"
            + "##When to reach for 5% Albumin:##\n\n"
            + "• Hypovolemic shock (trauma, hemorrhage, burns)\n"
            + "• Septic shock with fluid responsiveness\n"
            + "• Volume replacement when crystalloids aren't enough\n\n"
            + "##When to reach for 25% Albumin:##\n\n"
            + "• Cirrhosis with spontaneous bacterial peritonitis (SBP)\n"
            + "• Large volume paracentesis (>5L)\n"
            + "• Hepatorenal syndrome\n"
            + "• Need oncotic support without volume overload\n\n"
            + "##Key clinical pearls:##\n\n"
            + "• In cirrhosis + SBP: 25% albumin + antibiotics reduces mortality\n"
            + "• After large volume paracentesis: Give 6-8g albumin per liter removed\n"
            + "• Don't use albumin for routine fluid resuscitation (no mortality benefit over crystalloids)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using 25% in hypovolemic patients (can worsen dehydration initially)\n"
            + "• Using 5% when patient is already volume overloaded\n"
            + "• Forgetting albumin in SBP (reduces mortality!)\n\n"
            + "##The takeaway:##\n\n"
            + "Albumin is for specific indications — not routine resuscitation. Use 5% for volume expansion and 25% for oncotic support. Remember the cirrhosis indications: SBP prophylaxis, large volume paracentesis, and hepatorenal syndrome."
        ),
        
        // 2. Albuterol
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Albuterol",
            brandName: "Proventil, Ventolin",
            mechansim: "Albuterol is a short-acting β2-adrenergic agonist (SABA) that relaxes bronchial smooth muscle by increasing cAMP levels.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of albuterol as the rescue inhaler — it's the first-line bronchodilator for asthma and COPD exacerbations. It works fast (3-7 minutes), opens airways quickly, and is the drug you reach for when someone can't breathe. It's a racemic mixture (50% R-isomer, 50% S-isomer), but only the R-isomer is active.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to β2 receptors on bronchial smooth muscle → Activates adenylate cyclase\n"
            + "• Increases cAMP → Relaxes smooth muscle → Bronchodilation\n"
            + "• Also stimulates β2 receptors in other tissues → Can cause tachycardia, tremors, hypokalemia\n"
            + "• Onset: 3-7 minutes (nebulized), 5-15 minutes (MDI)\n\n"
            + "##The key:## Albuterol is first-line for acute bronchospasm (asthma, COPD, anaphylaxis). It's short-acting (15 minutes to 2 hours), so it's used as a rescue medication, not maintenance. For severe exacerbations, give continuous nebulization or back-to-back treatments.\n\n"
            + "##High-yield point:## Albuterol causes transient hypokalemia by shifting K+ into cells (via Na+/K+-ATPase activation). This is usually mild, but can be significant with frequent dosing. Monitor K+ in patients getting frequent treatments.",
            adverseEffects: "##Common:##\n\n"
            + "• Fine muscle tremors (hands, most common)\n"
            + "• Nervousness, anxiety\n"
            + "• Headache\n"
            + "• Palpitations, tachycardia\n"
            + "• Hypokalemia (transient, shifts K+ into cells)\n\n"
            + "##Serious:##\n\n"
            + "• Severe tachycardia (can worsen myocardial ischemia)\n"
            + "• Arrhythmias (especially in patients with heart disease)\n"
            + "• Paradoxical bronchospasm (rare, usually with MDI propellants)\n\n"
            + "##The tachycardia problem:##\n\n"
            + "Albuterol stimulates β2 receptors, but it's not perfectly selective — it can also stimulate β1 receptors in the heart, causing tachycardia. This is usually mild, but can be problematic in patients with coronary artery disease or arrhythmias.\n\n"
            + "##Red flags:##\n\n"
            + "• HR >120 with persistent tachycardia (may need to reduce frequency)\n"
            + "• New arrhythmias (atrial fib, PVCs)\n"
            + "• Chest pain (possible myocardial ischemia)\n"
            + "• K+ <3.0 mEq/L (hypokalemia from frequent dosing)",
            dose: "##Acute Bronchospasm (asthma/COPD):##\n\n"
            + "• Nebulized: 2.5-5 mg every 4-6 hours as needed\n"
            + "• MDI: 2-4 puffs (90-180 mcg) every 4-6 hours as needed\n"
            + "• For severe exacerbations: Continuous nebulization (10-15 mg/hr) or back-to-back treatments\n\n"
            + "##Anaphylaxis (adjunct to epinephrine):##\n\n"
            + "• 2.5-5 mg nebulized (helps with bronchospasm)\n\n"
            + "##Hyperkalemia (temporizing):##\n\n"
            + "• 10-20 mg nebulized (shifts K+ into cells)\n"
            + "• Onset: 15-30 minutes\n"
            + "• Duration: 2-4 hours\n\n"
            + "##Administration:##\n\n"
            + "• Nebulized: Mix with 3-4 mL normal saline\n"
            + "• MDI: Use spacer for better delivery\n"
            + "• For severe exacerbations: Can give continuous nebulization",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Short-acting β2-adrenergic agonist (SABA), bronchodilator.\n\n"
            + "First-line rescue medication for acute bronchospasm in asthma, COPD, and anaphylaxis.",
            indications: "##Primary indications:##\n\n"
            + "• Acute asthma exacerbation\n"
            + "• COPD exacerbation\n"
            + "• Anaphylaxis (adjunct bronchodilator)\n"
            + "• Exercise-induced bronchospasm\n"
            + "• Hyperkalemia (temporizing measure)\n\n"
            + "##You'll reach for albuterol when:##\n\n"
            + "• Patient has wheezing, shortness of breath (asthma/COPD)\n"
            + "• Anaphylaxis patient has bronchospasm\n"
            + "• Need rapid bronchodilation\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Asthma patient, wheezing, SOB → Albuterol 2.5 mg nebulized\n"
            + "• COPD exacerbation, increased dyspnea → Albuterol + ipratropium\n"
            + "• Anaphylaxis, bronchospasm → Epinephrine + albuterol",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity to albuterol\n"
            + "• Severe hypokalemia (albuterol worsens it)\n"
            + "• Symptomatic tachyarrhythmias (can worsen)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Coronary artery disease (tachycardia can cause ischemia)\n"
            + "• Heart failure (tachycardia increases O₂ demand)\n"
            + "• Hyperthyroidism (increased sensitivity to β-agonists)\n"
            + "• Seizure disorder (can lower seizure threshold)\n\n"
            + "##Critical safety point:## Albuterol causes tachycardia and can worsen myocardial ischemia in patients with CAD. Use cautiously in cardiac patients. If tachycardia is excessive (>120 bpm), consider reducing frequency or switching to levalbuterol (more β2-selective).",
            onSet: "3-7 min (nebulized), 5-15 min (MDI)",
            halfLife: "3-8 hrs",
            duration: "15 min - 2 hrs (short-acting)",
            absorbtion: "Rapidly absorbed in lungs (minimal systemic absorption)",
            distribution: "Limited systemic distribution",
            metaBolism: "Liver (extensively metabolized)",
            excretion: "Urine (major)",
            pregnancyExplanation: "Category C (but considered safe in practice). Albuterol is commonly used in pregnancy for asthma. No teratogenic effects reported.",
            criticalPearls: "##How to use albuterol safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Assess severity of bronchospasm (mild, moderate, severe)\n"
            + "• Check heart rate (caution if HR >100 or cardiac disease)\n"
            + "• Check potassium (especially if frequent dosing)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor heart rate (watch for excessive tachycardia)\n"
            + "• Monitor response (improved wheezing, peak flow)\n"
            + "• For severe exacerbations: Give back-to-back treatments or continuous nebulization\n"
            + "• If no response after 3 treatments → Consider intubation\n\n"
            + "##Albuterol vs. Levalbuterol:##\n\n"
            + "##Albuterol:##\n\n"
            + "• Racemic mixture (50% R-isomer, 50% S-isomer)\n"
            + "• More tachycardia and tremors\n"
            + "• Less expensive\n"
            + "• First-line for most patients\n\n"
            + "##Levalbuterol:##\n\n"
            + "• Pure R-isomer (active form)\n"
            + "• Less tachycardia and tremors\n"
            + "• More expensive\n"
            + "• Preferred in cardiac patients or if albuterol causes excessive side effects\n\n"
            + "##Bottom line:## Albuterol is first-line. Use levalbuterol if albuterol causes excessive tachycardia or tremors.\n\n"
            + "##Albuterol for asthma exacerbation:##\n\n"
            + "##For severe asthma exacerbations:##\n\n"
            + "• Give 2.5-5 mg nebulized every 20 minutes × 3 doses\n"
            + "• Or continuous nebulization (10-15 mg/hr)\n"
            + "• Combine with ipratropium (synergistic bronchodilation)\n"
            + "• Add systemic steroids (methylprednisolone 125 mg IV)\n\n"
            + "##Albuterol for hyperkalemia:##\n\n"
            + "##Albuterol shifts## K+ into cells (temporizing measure):\n\n"
            + "• 10-20 mg nebulized\n"
            + "• Onset: 15-30 minutes\n"
            + "• Lowers K+ by 0.5-1.5 mEq/L\n"
            + "• Duration: 2-4 hours\n"
            + "• Use with insulin + dextrose for better effect\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not giving frequently enough in severe exacerbations (need back-to-back or continuous)\n"
            + "• Not combining with ipratropium in severe exacerbations (synergistic)\n"
            + "• Not monitoring heart rate (can cause excessive tachycardia)\n"
            + "• Using as maintenance therapy (should use long-acting β-agonist like salmeterol)\n\n"
            + "##The takeaway:##\n\n"
            + "Albuterol is the first-line rescue bronchodilator for asthma and COPD. It works fast (3-7 minutes) and opens airways quickly. It's short-acting, so use it for acute bronchospasm, not maintenance. It can cause tachycardia and hypokalemia, especially with frequent dosing. For severe exacerbations, give back-to-back treatments or continuous nebulization."
        ),
        
        // 3. Amiodarone
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Amiodarone",
            brandName: "Cordarone",
            mechansim: "Amiodarone is the broadest-spectrum antiarrhythmic — it hits multiple ion channels and receptors.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of amiodarone as the Swiss Army knife of antiarrhythmics. It's primarily a Class III drug (potassium channel blocker), but it also has Class I (sodium channel), Class II (beta-blocker), and Class IV (calcium channel) effects. This makes it effective for almost any arrhythmia, but also gives it a long list of side effects.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks potassium channels → Prolongs action potential and refractory period\n"
            + "• Blocks sodium channels → Slows conduction\n"
            + "• Non-competitive beta-blockade → Slows heart rate\n"
            + "• Blocks calcium channels → Slows AV node conduction\n\n"
            + "##The key:## Amiodarone is the go-to antiarrhythmic for life-threatening ventricular arrhythmias (V-tach, V-fib) and the only antiarrhythmic safe in heart failure. But it has a massively long half-life (40-50 days), so side effects can persist for months after you stop it.\n\n"
            + "##High-yield point:## Amiodarone is the only antiarrhythmic proven safe in heart failure patients. Other antiarrhythmics (Class I, sotalol) can worsen outcomes in HF. It's also the drug of choice for V-fib/pulseless V-tach during cardiac arrest (after defibrillation and epinephrine).",
            adverseEffects: "##Common:##\n\n"
            + "• QT prolongation (usually doesn't cause torsades)\n"
            + "• Bradycardia, AV block\n"
            + "• Hypotension (especially with IV bolus)\n"
            + "• Phlebitis (peripheral IV)\n\n"
            + "##Serious (with chronic use):##\n\n"
            + "• Pulmonary fibrosis (can be fatal)\n"
            + "• Thyroid dysfunction (hypo or hyperthyroidism)\n"
            + "• Hepatotoxicity (elevated LFTs, cirrhosis)\n"
            + "• Corneal deposits (almost everyone, usually harmless)\n"
            + "• Blue-gray skin discoloration (from sun exposure)\n\n"
            + "##The pulmonary toxicity:##\n\n"
            + "This is the scariest one. Amiodarone can cause pulmonary fibrosis, which presents as progressive dyspnea, dry cough, and infiltrates on CXR. It can happen at any time, even after stopping the drug. Monitor with PFTs and chest X-rays.\n\n"
            + "##The thyroid effects:##\n\n"
            + "Amiodarone is 37% iodine by weight, so it messes with thyroid function. It can cause either hypothyroidism (more common) or hyperthyroidism. Monitor TSH and free T4 regularly.\n\n"
            + "##Red flags:##\n\n"
            + "• New dyspnea or dry cough → Check chest X-ray and PFTs (pulmonary toxicity)\n"
            + "• QTc >500 ms → Risk of torsades (though rare with amiodarone)\n"
            + "• Severe bradycardia or AV block → Stop amiodarone, consider pacing\n"
            + "• Abnormal TFTs → Endocrine consult",
            dose: "##Cardiac arrest (V-fib/pulseless V-tach):##\n\n"
            + "• First dose: 300 mg IV push\n"
            + "• Second dose: 150 mg IV push (if V-fib/V-tach persists)\n"
            + "• Give during CPR, after defibrillation and epinephrine\n\n"
            + "##Stable V-tach or A-fib with RVR:##\n\n"
            + "• Loading dose: 150 mg IV over 10 minutes\n"
            + "• Repeat 150 mg every 10 minutes as needed (max 2.2 g in 24 hours)\n"
            + "• Maintenance infusion: 1 mg/min for 6 hours, then 0.5 mg/min for 18 hours\n\n"
            + "##Oral loading (for chronic use):##\n\n"
            + "• 800-1600 mg/day for 1-3 weeks\n"
            + "• Then 600-800 mg/day for 1 month\n"
            + "• Then 200-400 mg/day maintenance\n\n"
            + "##Administration:##\n\n"
            + "• IV: Requires central line or large peripheral vein (causes phlebitis)\n"
            + "• In cardiac arrest: Give as rapid IV push\n"
            + "• For stable arrhythmias: Dilute and give slow infusion\n"
            + "• PO: Take with food to reduce GI upset",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Class III antiarrhythmic (potassium channel blocker), with Class I, II, and IV effects.\n\n"
            + "The broadest-spectrum antiarrhythmic and the only one safe in heart failure.",
            indications: "##Primary indications:##\n\n"
            + "• Cardiac arrest (V-fib, pulseless V-tach) — after defibrillation\n"
            + "• Stable ventricular tachycardia\n"
            + "• Atrial fibrillation (rate or rhythm control)\n"
            + "• Atrial flutter\n"
            + "• Supraventricular tachycardia (refractory)\n\n"
            + "##You'll reach for amiodarone when:##\n\n"
            + "• Patient is in V-fib/V-tach during cardiac arrest (after epi and defib)\n"
            + "• Patient has stable V-tach and cardioversion failed\n"
            + "• A-fib with RVR isn't responding to beta-blockers or calcium channel blockers\n"
            + "• Patient has heart failure and needs an antiarrhythmic (only safe option)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• V-fib arrest, shocked 3 times, gave epi → Give amiodarone 300 mg IV push\n"
            + "• A-fib with RVR, metoprolol didn't work, EF 25% → Amiodarone (safe in heart failure)\n"
            + "• Recurrent V-tach in ICD patient → Start oral amiodarone for suppression",
            contraindiction: "##Absolute:##\n\n"
            + "• Severe sinus bradycardia (HR <50 without pacemaker)\n"
            + "• 2nd or 3rd-degree AV block (unless paced)\n"
            + "• Known amiodarone-induced pulmonary toxicity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• QTc >500 ms (though amiodarone rarely causes torsades)\n"
            + "• Thyroid disease (amiodarone will make it worse)\n"
            + "• Severe liver disease\n"
            + "• Pregnancy (causes fetal hypothyroidism)\n\n"
            + "##Critical safety point:## In cardiac arrest, there are NO contraindications to amiodarone. If the patient is in V-fib or pulseless V-tach, give it. The benefits far outweigh any risks.",
            onSet: "1-2 hrs (IV), several days-weeks (PO)",
            halfLife: "40-50 days (extremely long)",
            duration: "Weeks to months after stopping",
            absorbtion: "Well absorbed orally (~50%)",
            distribution: "Highly lipophilic, accumulates in tissues (fat, liver, lungs)",
            metaBolism: "Liver (CYP3A4)",
            excretion: "Bile, minimal urine",
            pregnancyExplanation: "Category D. Avoid in pregnancy if possible (causes fetal hypothyroidism and developmental abnormalities). Use only if benefits outweigh risks.",
            criticalPearls: "##How to use amiodarone safely:##\n\n"
            + "##For cardiac arrest:##\n\n"
            + "• Give 300 mg IV push after 3rd shock and epinephrine\n"
            + "• Can give 2nd dose of 150 mg if V-fib persists\n"
            + "• Don't delay shocks to give amiodarone\n\n"
            + "##For stable arrhythmias:##\n\n"
            + "• Give loading dose slowly (150 mg over 10 minutes)\n"
            + "• Monitor blood pressure (can cause hypotension)\n"
            + "• Use central line if possible (peripheral causes phlebitis)\n"
            + "• Follow with maintenance infusion\n\n"
            + "##For chronic use:##\n\n"
            + "• Start with high loading doses, then taper to maintenance\n"
            + "• Monitor TFTs (TSH, free T4) every 3-6 months\n"
            + "• Monitor LFTs every 6 months\n"
            + "• Get baseline and annual chest X-ray and PFTs\n"
            + "• Check baseline EKG and QTc\n"
            + "• Warn patient about sun sensitivity (use sunscreen)\n\n"
            + "##Why amiodarone is special:##\n\n"
            + "It's the only antiarrhythmic safe in heart failure. Other antiarrhythmics (Class I drugs like flecainide, or sotalol) can worsen heart failure and increase mortality. If your patient has reduced EF and needs rhythm control, amiodarone is your drug.\n\n"
            + "##The long half-life problem:##\n\n"
            + "Amiodarone has a half-life of 40-50 days, which means it takes 5-6 months to reach steady state and 5-6 months to fully clear after stopping. Side effects can persist for months after discontinuation. This is why loading doses are so high.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not monitoring TFTs, LFTs, and PFTs in chronic users\n"
            + "• Giving amiodarone through small peripheral IV (causes severe phlebitis)\n"
            + "• Using other antiarrhythmics in heart failure patients (amiodarone is the only safe one)\n"
            + "• Delaying defibrillation to give amiodarone in cardiac arrest (shock first)\n\n"
            + "##The takeaway:##\n\n"
            + "Amiodarone is the Swiss Army knife antiarrhythmic — it works for almost any arrhythmia and is the only one safe in heart failure. In cardiac arrest, give it after the 3rd shock. For chronic use, monitor thyroid, liver, and lungs closely. The long half-life means effects and side effects last for months."
        ),
        
        // 4. Aspirin
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Aspirin",
            brandName: "ASA",
            mechansim: "Aspirin irreversibly inhibits cyclooxygenase (COX-1 and COX-2) enzymes, blocking thromboxane A2 production and preventing platelet aggregation.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of aspirin as the platelet deactivator. It permanently disables COX-1 in platelets, preventing them from producing thromboxane A2 (which normally causes platelets to clump together). Since platelets can't make new COX-1 (no nucleus), the effect lasts for the platelet's entire lifespan (~7-10 days). This is why aspirin is so effective for cardiovascular prevention.\n\n"
            + "##How it works:##\n\n"
            + "• Irreversibly acetylates COX-1 → Blocks thromboxane A2 production\n"
            + "• Thromboxane A2 normally promotes platelet aggregation and vasoconstriction\n"
            + "• Platelets can't make new COX-1 → Effect lasts 7-10 days (platelet lifespan)\n"
            + "• Also inhibits COX-2 (anti-inflammatory effect at higher doses)\n\n"
            + "##The key:## For ACS (MI, unstable angina), give aspirin IMMEDIATELY — 324 mg chewed (not swallowed) for rapid absorption. Aspirin is one of the few interventions that improves mortality in acute MI. Chewing bypasses the enteric coating and gets drug into circulation faster.\n\n"
            + "##High-yield point:## Aspirin's antiplatelet effect is irreversible and lasts 7-10 days (until new platelets are made). This is why surgery is typically delayed 7-10 days after stopping aspirin, and why even a single dose matters.",
            adverseEffects: "##Common:##\n\n"
            + "• GI upset, dyspepsia\n"
            + "• Tinnitus (early sign of toxicity)\n"
            + "• Easy bruising\n\n"
            + "##Serious:##\n\n"
            + "• GI bleeding (especially with chronic use)\n"
            + "• Hemorrhagic stroke (rare)\n"
            + "• Reye's syndrome (in children with viral infections)\n"
            + "• Aspirin-exacerbated respiratory disease (AERD/Samter's triad)\n"
            + "• Salicylate toxicity (overdose)\n\n"
            + "##The GI bleeding problem:##\n\n"
            + "Aspirin inhibits prostaglandins that protect gastric mucosa, increasing risk of gastric ulcers and bleeding. Use PPI if chronic aspirin and risk factors (age >65, h/o GI bleed, concurrent anticoagulation/NSAIDs).\n\n"
            + "##Red flags:##\n\n"
            + "• Tinnitus (salicylate toxicity)\n"
            + "• Melena or hematemesis (GI bleeding)\n"
            + "• Confusion + tachypnea (mixed respiratory alkalosis/metabolic acidosis = salicylate toxicity)",
            dose: "##Acute Coronary Syndrome (MI/UA):##\n\n"
            + "• 324 mg PO (chewable) IMMEDIATELY\n"
            + "• Chew, don't swallow — faster absorption\n"
            + "• Then 81 mg daily maintenance\n\n"
            + "##Secondary Prevention:##\n\n"
            + "• 81 mg PO daily (low-dose)\n"
            + "• After ACS, stents, stroke, TIA, PAD\n\n"
            + "##Primary Prevention:##\n\n"
            + "• Generally NOT recommended for most patients\n"
            + "• May consider in high-risk diabetes with discussion\n"
            + "• Bleeding risk often outweighs benefit\n\n"
            + "##Anti-inflammatory/Analgesic:##\n\n"
            + "• 325-650 mg PO every 4-6 hours\n"
            + "• Max: 4 g/day\n\n"
            + "##Kawasaki Disease:##\n\n"
            + "• 80-100 mg/kg/day (anti-inflammatory dose)\n"
            + "• Then 3-5 mg/kg/day (antiplatelet dose)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "NSAID, antiplatelet agent, salicylate.\n\n"
            + "##Irreversible COX## inhibitor with dose-dependent effects: antiplatelet (low dose), analgesic (moderate), anti-inflammatory (high dose).",
            indications: "##Primary indications:##\n\n"
            + "• Acute coronary syndrome (STEMI, NSTEMI, unstable angina)\n"
            + "• Secondary cardiovascular prevention (post-MI, stroke, TIA, stent)\n"
            + "• Kawasaki disease (prevents coronary artery aneurysms)\n"
            + "• Pain and fever (moderate doses)\n\n"
            + "##You'll reach for aspirin when:##\n\n"
            + "• Chest pain concerning for ACS → 324 mg chewed immediately\n"
            + "• Post-PCI with stent placement → 81 mg daily (with P2Y12 inhibitor)\n"
            + "• History of stroke or TIA → 81 mg daily\n\n"
            + "##Classic scenarios:##\n\n"
            + "• 55-year-old with crushing chest pain, diaphoresis → Aspirin 324 mg chewed NOW (+ O2, nitro, morphine, heparin)\n"
            + "• Child with fever, rash, conjunctivitis, lymphadenopathy → Kawasaki → High-dose aspirin\n"
            + "• Post-MI patient for secondary prevention → Aspirin 81 mg + statin + beta-blocker + ACEi",
            contraindiction: "##Absolute:##\n\n"
            + "• Active bleeding (GI, intracranial)\n"
            + "• Hypersensitivity to aspirin or NSAIDs\n"
            + "• Children with viral illness (Reye's syndrome risk)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• History of GI bleeding (use with PPI)\n"
            + "• Severe hepatic impairment\n"
            + "• Asthma with nasal polyps (AERD/Samter's triad)\n"
            + "• Third trimester pregnancy (premature ductus closure)\n"
            + "• Concurrent anticoagulation (increased bleeding)\n\n"
            + "##Critical safety point:## NEVER give aspirin to children with viral infections (chicken pox, influenza) — Reye's syndrome causes potentially fatal liver failure and encephalopathy.",
            onSet: "15-30 min (chewed), 1-2 hrs (swallowed)",
            halfLife: "15-20 min (aspirin itself), but antiplatelet effect lasts 7-10 days",
            duration: "7-10 days (antiplatelet effect = platelet lifespan)",
            absorbtion: "Rapid GI absorption, faster if chewed",
            distribution: "Widely distributed, crosses placenta",
            metaBolism: "Liver (rapidly to salicylic acid)",
            excretion: "Urine (pH dependent — alkaline urine increases excretion)",
            pregnancyExplanation: "Avoid in 3rd trimester (premature closure of ductus arteriosus). Low-dose aspirin (81 mg) may be used for preeclampsia prevention in high-risk pregnancies.",
            criticalPearls: "##How to use aspirin safely:##\n\n"
            + "##For Acute Coronary Syndrome:##\n\n"
            + "• Give 324 mg IMMEDIATELY — don't wait for diagnosis confirmation\n"
            + "• CHEW, don't swallow — bypasses enteric coating, faster absorption\n"
            + "• Aspirin reduces mortality in MI by ~25%\n"
            + "• Continue 81 mg daily for secondary prevention\n\n"
            + "##Reye's Syndrome — the critical warning:##\n\n"
            + "NEVER give aspirin to children with viral infections!\n\n"
            + "• Reye's syndrome = acute encephalopathy + liver failure\n"
            + "• Associated with aspirin use in children with flu or chickenpox\n"
            + "• High mortality rate\n"
            + "• Use acetaminophen or ibuprofen instead for fever in children\n\n"
            + "##Exception:## Kawasaki disease in children REQUIRES aspirin (benefit outweighs risk)\n\n"
            + "##Aspirin resistance:##\n\n"
            + "Some patients don't respond adequately to aspirin:\n\n"
            + "• Non-compliance (most common)\n"
            + "• Drug interactions (NSAIDs can compete at COX-1)\n"
            + "• True biochemical resistance (rare)\n"
            + "• If suspected, ensure compliance before changing therapy\n\n"
            + "##Dual antiplatelet therapy (DAPT):##\n\n"
            + "##Post-PCI with stent:##\n\n"
            + "• Aspirin 81 mg daily + P2Y12 inhibitor (clopidogrel, ticagrelor, prasugrel)\n"
            + "• Duration: 6-12 months typically (longer for ACS, shorter for high bleeding risk)\n"
            + "• Stopping P2Y12 inhibitor early increases stent thrombosis risk\n\n"
            + "##Salicylate toxicity:##\n\n"
            + "##Signs of aspirin overdose:##\n\n"
            + "• Early: Tinnitus, nausea, vomiting, tachypnea\n"
            + "• Late: Altered mental status, hyperthermia, seizures\n"
            + "• Classic ABG: Mixed respiratory alkalosis + metabolic acidosis\n\n"
            + "##Treatment:## Activated charcoal (if recent), IV fluids, alkalinize urine (sodium bicarbonate), hemodialysis in severe cases\n\n"
            + "##Common mistakes:##\n\n"
            + "• Having patient swallow aspirin instead of chewing for ACS (delays absorption)\n"
            + "• Giving aspirin to children with viral illness (Reye's syndrome)\n"
            + "• Not using PPI with chronic aspirin in high-risk patients\n"
            + "• Primary prevention aspirin in low-risk patients (bleeding > benefit)\n\n"
            + "##The takeaway:##\n\n"
            + "Aspirin irreversibly inhibits COX-1, preventing platelet aggregation for 7-10 days. For ACS, give 324 mg chewed immediately — it reduces mortality. Use 81 mg daily for secondary prevention. NEVER give to children with viral infections (Reye's syndrome). Use PPI if chronic aspirin with GI bleeding risk factors."
        ),
        
        // 5. Atenolol
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Atenolol",
            brandName: "Tenormin",
            mechansim: "Atenolol is a selective β1-adrenergic receptor blocker that reduces heart rate and myocardial contractility.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of atenolol as the cardioselective beta-blocker — it primarily blocks β1 receptors (heart) with less effect on β2 receptors (lungs, vasculature). This makes it safer (but not completely safe) in patients with asthma/COPD compared to non-selective beta-blockers like propranolol.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks β1 receptors on heart → Decreases heart rate and contractility\n"
            + "• Decreases renin release from kidneys (β1 mediated)\n"
            + "• Minimal β2 blockade → Less bronchospasm risk\n"
            + "• Reduces myocardial oxygen demand\n\n"
            + "##The key:## Atenolol is renally cleared (unlike metoprolol which is hepatic). This means dose reduction is needed in renal impairment, but it's not affected by liver disease or CYP2D6 interactions.\n\n"
            + "##High-yield point:## Cardioselective beta-blockers (atenolol, metoprolol, bisoprolol) are preferred when beta-blockade is needed in patients with reactive airway disease. However, selectivity is lost at high doses — they can still cause bronchospasm.",
            adverseEffects: "##Common:##\n\n"
            + "• Bradycardia\n"
            + "• Fatigue, dizziness\n"
            + "• Cold extremities\n"
            + "• Hypotension\n\n"
            + "##Serious:##\n\n"
            + "• Symptomatic bradycardia/heart block\n"
            + "• Worsening heart failure (use cautiously, low doses)\n"
            + "• Bronchospasm (at high doses, or in severe asthma)\n"
            + "• Rebound hypertension/tachycardia if stopped abruptly\n\n"
            + "##The withdrawal problem:##\n\n"
            + "Don't stop beta-blockers abruptly. This can cause rebound hypertension and tachycardia, potentially triggering angina or MI. Taper over 1-2 weeks when possible.\n\n"
            + "##Red flags:##\n\n"
            + "• HR <50 with symptoms (hold atenolol)\n"
            + "• New/worsening heart failure symptoms\n"
            + "• Bronchospasm (consider discontinuation)",
            dose: "##Hypertension:##\n\n"
            + "• Start: 25-50 mg PO daily\n"
            + "• Maintenance: 50-100 mg PO daily\n"
            + "• Max: 100 mg/day\n\n"
            + "##Acute rate control (IV):##\n\n"
            + "• 5 mg IV over 5 minutes\n"
            + "• May repeat once after 10 minutes\n"
            + "• Max: 10 mg IV\n\n"
            + "##Post-MI:##\n\n"
            + "• 50-100 mg PO daily (reduces mortality)\n\n"
            + "##Renal dosing:##\n\n"
            + "• CrCl 15-35: 50 mg daily max\n"
            + "• CrCl <15: 25-50 mg every other day\n"
            + "• Dialysis: 25-50 mg after dialysis\n\n"
            + "##Administration:##\n\n"
            + "• Renally cleared — reduce dose in renal impairment\n"
            + "• Don't stop abruptly (taper)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Selective β1-blocker.\n\n"
            + "##Cardioselective## beta-blocker with renal clearance (unlike metoprolol which is hepatically cleared).",
            indications: "##Primary indications:##\n\n"
            + "• Hypertension\n"
            + "• Stable angina\n"
            + "• Post-myocardial infarction (mortality reduction)\n"
            + "• SVT rate control\n"
            + "• Atrial fibrillation rate control\n\n"
            + "##You'll reach for atenolol when:##\n\n"
            + "• Need once-daily beta-blocker for hypertension\n"
            + "• Patient with liver disease (renally cleared)\n"
            + "• Post-MI for secondary prevention\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Hypertensive patient with CKD and liver disease → Atenolol (renally cleared but still reduce dose)\n"
            + "• Post-STEMI, starting beta-blocker for mortality benefit → Atenolol 50 mg daily\n"
            + "• SVT needing rate control → Atenolol 5 mg IV over 5 min",
            contraindiction: "##Absolute:##\n\n"
            + "• Sinus bradycardia (<50 bpm symptomatic)\n"
            + "• 2nd or 3rd degree AV block (without pacemaker)\n"
            + "• Cardiogenic shock\n"
            + "• Acute decompensated heart failure\n"
            + "• Sick sinus syndrome\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Severe asthma (selectivity lost at high doses)\n"
            + "• Peripheral vascular disease (may worsen)\n"
            + "• Diabetes (may mask hypoglycemia symptoms)\n"
            + "• Renal impairment (reduce dose)\n\n"
            + "##Critical safety point:## Don't stop beta-blockers abruptly — rebound hypertension and tachycardia can precipitate angina or MI. Taper over 1-2 weeks when discontinuing.",
            onSet: "5 min (IV), 1-2 hrs (PO)",
            halfLife: "6-9 hrs",
            duration: "12-24 hrs",
            absorbtion: "50% (oral)",
            distribution: "Low protein binding, crosses placenta",
            metaBolism: "Minimal hepatic (renally cleared)",
            excretion: "Urine (40-50% unchanged)",
            pregnancyExplanation: "Use with caution in pregnancy. May cause fetal bradycardia and low birth weight. Generally safer than some other beta-blockers but use lowest effective dose.",
            criticalPearls: "##How to use atenolol safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check heart rate and blood pressure (hold if HR <50 or BP low)\n"
            + "• Check for heart block, decompensated HF\n"
            + "• Check renal function (adjust dose)\n\n"
            + "##While on therapy:##\n\n"
            + "• Monitor HR and BP regularly\n"
            + "• Watch for fatigue, dizziness\n"
            + "• Don't stop abruptly (taper)\n\n"
            + "##Atenolol vs. Metoprolol:##\n\n"
            + "##Atenolol:##\n\n"
            + "• Renally cleared (reduce dose in renal failure)\n"
            + "• Once daily dosing\n"
            + "• Less CNS penetration (less fatigue, depression)\n"
            + "• Not affected by CYP2D6 inhibitors\n\n"
            + "##Metoprolol:##\n\n"
            + "• Hepatically metabolized (reduce in liver failure)\n"
            + "• Twice daily (tartrate) or once daily (succinate)\n"
            + "• More CNS penetration\n"
            + "• Affected by CYP2D6 interactions\n\n"
            + "##Cardioselective ≠ safe in asthma:##\n\n"
            + "Cardioselective beta-blockers (atenolol, metoprolol, bisoprolol) are safer but not completely safe in asthma/COPD:\n\n"
            + "• At low doses, selectivity is preserved\n"
            + "• At higher doses, β2 blockade occurs → Bronchospasm\n"
            + "• Use cautiously, start low, monitor closely\n"
            + "• Avoid in severe/uncontrolled asthma\n\n"
            + "##Beta-blocker withdrawal:##\n\n"
            + "Abrupt discontinuation can cause:\n\n"
            + "• Rebound tachycardia\n"
            + "• Rebound hypertension\n"
            + "• Angina exacerbation\n"
            + "• Myocardial infarction\n\n"
            + "##Prevention:## Taper over 1-2 weeks. If must discontinue urgently (surgery), monitor closely.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Stopping abruptly (rebound effects)\n"
            + "• Not reducing dose in renal failure\n"
            + "• Assuming 'cardioselective' means safe in severe asthma\n"
            + "• Using in acute decompensated heart failure\n\n"
            + "##The takeaway:##\n\n"
            + "Atenolol is a cardioselective β1-blocker that's renally cleared. Use for hypertension, angina, and post-MI. Reduce dose in renal impairment. Don't stop abruptly (rebound hypertension/tachycardia). It's safer in asthma than non-selective beta-blockers, but selectivity is lost at high doses. Monitor heart rate and blood pressure."
        ),
        
        // 6. Atropine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Atropine",
            brandName: "AtroPen",
            mechansim: "Atropine is an anticholinergic that works by blocking muscarinic acetylcholine receptors.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of atropine as the vagus nerve blocker. The vagus nerve slows the heart via acetylcholine, and atropine blocks this signal. No vagal brake = heart speeds up.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks muscarinic receptors in the SA node → Removes vagal tone\n"
            + "• Increases heart rate (chronotropy)\n"
            + "• Increases AV node conduction\n"
            + "• Minimal effect on contractility\n\n"
            + "##The key:## Atropine only works for bradycardia caused by excessive vagal tone. It doesn't help with bradycardia from complete heart block, ischemia, or medications (beta-blockers, calcium channel blockers). In those cases, you need pacing or pressors.\n\n"
            + "##High-yield point:## Atropine is ineffective in heart transplant patients because the transplanted heart is denervated (no vagus nerve connection). It also doesn't work in high-degree AV blocks. For these patients, go straight to pacing or epinephrine/dopamine infusions.",
            adverseEffects: "##Common:##\n\n"
            + "• Dry mouth (anticholinergic)\n"
            + "• Blurred vision (mydriasis, cycloplegia)\n"
            + "• Urinary retention\n"
            + "• Tachycardia (sometimes excessive)\n\n"
            + "##Serious:##\n\n"
            + "• Severe tachycardia or tachydysrhythmias\n"
            + "• Myocardial ischemia (increased O₂ demand from tachycardia)\n"
            + "• Acute angle-closure glaucoma (from mydriasis)\n"
            + "• Delirium or agitation (especially in elderly)\n\n"
            + "##Paradoxical bradycardia:##\n\n"
            + "Low doses of atropine (<0.5 mg) can actually cause transient bradycardia before speeding up the heart. Always give at least 0.5 mg IV.\n\n"
            + "##Red flags:##\n\n"
            + "• Heart rate shoots up to >130 after atropine → Risk of ischemia in CAD patients\n"
            + "• Bradycardia doesn't respond after 3 mg total → Start pacing or pressors\n"
            + "• Patient becomes delirious after atropine → Anticholinergic toxicity",
            dose: "##Symptomatic bradycardia:##\n\n"
            + "• 0.5-1 mg IV push\n"
            + "• Repeat every 3-5 minutes as needed\n"
            + "• Max total dose: 3 mg\n"
            + "• Pediatric: 0.02 mg/kg IV (minimum 0.1 mg, max single dose 0.5 mg)\n\n"
            + "##Cardiac arrest (bradycardic PEA/asystole):##\n\n"
            + "• Atropine is NO LONGER recommended in ACLS 2020 guidelines\n"
            + "• Focus on high-quality CPR and epinephrine instead\n\n"
            + "##Organophosphate/nerve agent poisoning:##\n\n"
            + "• 2-6 mg IV (or IM if no IV access)\n"
            + "• Repeat every 5-10 minutes until secretions dry up\n"
            + "• May need massive doses (>100 mg in severe cases)\n\n"
            + "##Administration:##\n\n"
            + "• Give as rapid IV push (don't dilute or give slow)\n"
            + "• Can give IM or IO if no IV access\n"
            + "• Flush well after giving",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Anticholinergic, muscarinic receptor antagonist, antiarrhythmic.\n\n"
            + "First-line drug for symptomatic bradycardia caused by vagal excess.",
            indications: "##Primary indications:##\n\n"
            + "• Symptomatic bradycardia (HR <50 with hypotension, altered mentation, or chest pain)\n"
            + "• Organophosphate or nerve agent poisoning\n"
            + "• AV block (1st degree or 2nd degree Type I)\n\n"
            + "##You'll reach for atropine when:##\n\n"
            + "• Patient is bradycardic and symptomatic (hypotensive, altered, chest pain)\n"
            + "• Post-intubation bradycardia from vagal stimulation\n"
            + "• Farmer or agricultural worker with excessive salivation, bradycardia, and miosis (organophosphate poisoning)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Inferior MI patient with HR 38, BP 80/50, diaphoretic → Atropine 0.5-1 mg IV\n"
            + "• Vagal response during intubation, HR drops to 40 → Atropine 0.5-1 mg IV\n"
            + "• Farmer exposed to pesticide, salivating profusely, HR 42 → Atropine 2-6 mg IV (organophosphate poisoning)",
            contraindiction: "##Absolute:##\n\n"
            + "• Acute angle-closure glaucoma (atropine causes mydriasis, worsens condition)\n"
            + "• Tachycardia or tachydysrhythmias (don't make it worse)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Coronary artery disease (tachycardia increases O₂ demand)\n"
            + "• 2nd-degree Type II or 3rd-degree AV block (atropine won't help, may worsen)\n"
            + "• Heart transplant patients (no vagus nerve, atropine won't work)\n"
            + "• Myasthenia gravis (can precipitate crisis)\n\n"
            + "##Critical safety point:## Atropine only works for vagally-mediated bradycardia. If the patient has high-degree AV block (2nd-degree Type II or 3rd-degree), atropine won't help and may actually worsen the block by speeding up the atria. Go straight to pacing.",
            onSet: "Immediate (within 1-2 minutes)",
            halfLife: "2-3 hrs",
            duration: "4-6 hrs",
            absorbtion: "Well absorbed (PO, IM, IV)",
            distribution: "Crosses blood-brain barrier and placenta",
            metaBolism: "Hepatic",
            excretion: "Urine (50% unchanged)",
            pregnancyExplanation: "Category C. Use with caution in pregnancy. Generally considered safe for maternal indications (symptomatic bradycardia).",
            criticalPearls: "##For symptomatic bradycardia:##\n\n"
            + "• Give 0.5-1 mg IV push (rapid, don't dilute)\n"
            + "• Wait 3-5 minutes to assess response\n"
            + "• Repeat up to 3 mg total if still bradycardic and symptomatic\n"
            + "• If no response after 3 mg → Start pacing or dopamine/epinephrine infusion\n\n"
            + "##When atropine won't work:##\n\n"
            + "• Heart transplant patients (denervated heart)\n"
            + "• High-degree AV blocks (2nd-degree Type II, 3rd-degree)\n"
            + "• Bradycardia from beta-blockers or calcium channel blockers\n"
            + "• Bradycardia from ischemia or infarction\n"
            + "• In these cases, go straight to transcutaneous pacing or pressors\n\n"
            + "##The dose matters:##\n\n"
            + "• Less than 0.5 mg: Causes paradoxical bradycardia (never do this)\n"
            + "• 0.5-1 mg: Standard dose for symptomatic bradycardia\n"
            + "• 2-6 mg: Organophosphate poisoning (much higher doses needed)\n\n"
            + "##For organophosphate poisoning:##\n\n"
            + "The dose is much higher (2-6 mg to start). You're treating excessive cholinergic activity (salivation, bronchorrhea, bradycardia, miosis). Keep giving atropine until secretions dry up. Some patients need >100 mg.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving less than 0.5 mg (causes paradoxical bradycardia)\n"
            + "• Giving atropine for high-degree AV block (won't work, may worsen)\n"
            + "• Continuing atropine after 3 mg total without considering pacing\n"
            + "• Using atropine in cardiac arrest (no longer recommended per ACLS 2020)\n\n"
            + "##The takeaway:##\n\n"
            + "Atropine is the first-line drug for symptomatic bradycardia caused by excessive vagal tone. Give 0.5-1 mg IV push, repeat every 3-5 minutes up to 3 mg total. If it doesn't work, the problem isn't vagal — start pacing or use pressors. Don't use it for high-degree blocks or in heart transplant patients."
        ),
        
        // 7. Bumetanide
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Bumetanide",
            brandName: "Bumex ®",
            mechansim: "Bumetanide is a loop diuretic that inhibits the Na⁺-K⁺-2Cl⁻ cotransporter in the thick ascending loop of Henle.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of bumetanide as the more potent, cleaner version of furosemide — it's ##40x more potent## (1 mg bumetanide ≈ 40 mg furosemide), has better oral bioavailability (80% vs. 60%), and causes less ototoxicity.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks Na⁺-K⁺-2Cl⁻ cotransporter in the ascending loop of Henle\n"
            + "• Same mechanism as furosemide, but much more potent\n"
            + "• Prevents sodium and chloride reabsorption → Massive diuresis\n\n"
            + "##Key concept:## Bumetanide is the loop diuretic of choice when furosemide isn't working (diuretic resistance), when you need more reliable oral dosing, or when the patient has had ototoxicity with furosemide.\n\n"
            + "##High-yield point:## 1 mg bumetanide = 40 mg furosemide. This is a common conversion error — don't dose bumetanide at the same milligram dose as furosemide, or you'll massively overdiurese the patient.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypokalemia\n"
            + "• Hypomagnesemia\n"
            + "• Hypocalcemia\n"
            + "• Metabolic alkalosis\n"
            + "• Dehydration\n"
            + "• Hypotension\n\n"
            + "##Serious:##\n\n"
            + "• Ototoxicity (less than furosemide, but still possible)\n"
            + "• Severe dehydration and prerenal AKI\n"
            + "• Hypokalemia → Arrhythmias\n"
            + "• Severe hyponatremia\n\n"
            + "##Why bumetanide is \"cleaner\":##\n\n"
            + "• Better oral bioavailability (80% vs. furosemide 60%)\n"
            + "• Less ototoxic than furosemide\n"
            + "• More predictable response\n\n"
            + "##Red flags:##\n\n"
            + "• K⁺ <3.0 mEq/L → Replace potassium before more diuresis\n"
            + "• Creatinine rising → Prerenal AKI from overdiuresis\n"
            + "• Hearing loss or tinnitus → Stop drug",
            dose: "##Acute Edema/CHF:##\n\n"
            + "• 0.5-1 mg IV/PO (start low)\n"
            + "• May repeat in 2-3 hours if needed\n"
            + "• Max: 10 mg/day\n\n"
            + "##Conversion from Furosemide:##\n\n"
            + "• Furosemide 40 mg = Bumetanide 1 mg\n"
            + "• Example: Patient on furosemide 80 mg BID → Switch to bumetanide 2 mg BID\n\n"
            + "##Continuous Infusion (rare):##\n\n"
            + "• Loading dose: 1 mg IV\n"
            + "• Infusion: 0.5-2 mg/hr\n\n"
            + "##Administration:##\n\n"
            + "• IV push over 1-2 minutes\n"
            + "• Onset: 5 min (IV), 30-60 min (PO)\n"
            + "• Duration: 4-6 hours",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "##Loop diuretic.##\n\n"
            + "The more potent alternative to furosemide — use when furosemide resistance develops or for more predictable oral dosing.",
            indications: "##Standard Indications:##\n\n"
            + "• Congestive heart failure (CHF)\n"
            + "• Edema (cardiac, hepatic, renal)\n"
            + "• Volume overload\n"
            + "• Diuretic resistance to furosemide\n\n"
            + "##When to reach for bumetanide:##\n\n"
            + "• Furosemide isn't working (diuretic resistance)\n"
            + "• Patient needs reliable oral diuresis (better bioavailability)\n"
            + "• History of ototoxicity with furosemide\n"
            + "• Need more predictable response\n\n"
            + "##Clinical clues:## Patient on high-dose furosemide (160-240 mg) not responding, or poor oral absorption of furosemide.",
            contraindiction: "##Absolute:##\n\n"
            + "• Anuria (no urine output)\n"
            + "• Severe hypovolemia or dehydration\n\n"
            + "##Caution:##\n\n"
            + "• Sulfa allergy (bumetanide contains sulfonamide moiety)\n"
            + "• Hypokalemia (replace first)\n"
            + "• Hepatic coma (can precipitate encephalopathy)\n"
            + "• Concurrent ototoxic drugs\n\n"
            + "##Important:## If the patient isn't making urine (anuria), no diuretic will work — address the underlying cause first.",
            onSet: "5 min (IV); 30-60 min (PO)",
            halfLife: "60-90 minutes",
            duration: "4-6 hours",
            absorbtion: "##80% oral bioavailability## (vs. furosemide 60%)\n\n"
            + "This is why bumetanide is preferred for oral diuresis.",
            distribution: "Well distributed, highly protein-bound (>95%)",
            metaBolism: "Partial hepatic metabolism",
            excretion: "Renal (45% unchanged) and hepatic",
            pregnancyExplanation: "##Pregnancy Category C:## Use only if benefits outweigh risks. Can cause fetal diuresis.",
            criticalPearls: "##Potent Diuretic##\n\n"
            + "• Approx potency: ##1 mg Bumex = 40 mg Lasix##\n"
            + "• Common error: Dosing bumetanide at same mg as furosemide → Massive overdiuresis\n"
            + "• Always convert carefully\n\n"
            + "##Watch for Electrolyte Depletion##\n\n"
            + "• K⁺ (most common)\n"
            + "• Mg²⁺\n"
            + "• Ca²⁺\n"
            + "• Monitor electrolytes daily, replace as needed\n\n"
            + "##Better Oral Bioavailability:##\n\n"
            + "• 80% (vs. furosemide 60%)\n"
            + "• More predictable oral response\n"
            + "• Use when patient needs reliable outpatient diuresis\n\n"
            + "##Less Ototoxic:##\n\n"
            + "• Lower risk than furosemide\n"
            + "• But still push slowly and avoid excessive doses\n\n"
            + "##When to Switch from Furosemide:##\n\n"
            + "• Diuretic resistance (patient on furosemide 160-240 mg/day not responding)\n"
            + "• Poor oral absorption\n"
            + "• Ototoxicity with furosemide\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Bumetanide is the more potent, cleaner loop diuretic — 40x more potent than furosemide with better oral bioavailability and less ototoxicity. Use it when furosemide isn't working or when you need reliable oral diuresis. Always remember the conversion: 1 mg bumetanide = 40 mg furosemide.\n\n"
            + "##High-yield point:## Bumetanide is the loop diuretic to reach for in diuretic resistance. It has better oral bioavailability (80% vs. 60%) and is less ototoxic. The key conversion: 1 mg bumetanide = 40 mg furosemide."
        ),
        
        // 8. Calcium Salt
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Calcium Salt",
            brandName: "Ca Chloride, Ca Gluconate",
            mechansim: "Calcium is essential for cardiac contractility, nerve conduction, muscle contraction, and blood coagulation.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of calcium as the cardiac membrane stabilizer — in hyperkalemia, it doesn't actually lower potassium, but it stabilizes the myocardial membrane, preventing arrhythmias. It's also the antidote for calcium channel blocker overdose and magnesium toxicity.\n\n"
            + "##How it works:##\n\n"
            + "• Stabilizes cardiac myocyte membranes → Protects against hyperkalemia-induced arrhythmias\n"
            + "• Required for cardiac contractility (positive inotropy)\n"
            + "• Reverses calcium channel blocker toxicity\n"
            + "• Reverses magnesium toxicity (competitive antagonist)\n\n"
            + "##The key:## There are two formulations — calcium chloride and calcium gluconate. Calcium chloride has 3x more elemental calcium, but it's harsh on veins (central line preferred). Calcium gluconate is gentler and can be given peripherally.\n\n"
            + "##High-yield point:## Calcium does NOT lower potassium — it only protects the heart from hyperkalemia. To actually lower potassium, use insulin + dextrose, albuterol, furosemide, or dialysis. Calcium buys you time to fix the potassium.",
            adverseEffects: "##Common:##\n\n"
            + "• Bradycardia\n"
            + "• Hypotension (if pushed too fast)\n"
            + "• Flushing, warmth\n"
            + "• Constipation (chronic use)\n\n"
            + "##Serious:##\n\n"
            + "• Arrhythmias (especially in digoxin toxicity)\n"
            + "• Severe tissue necrosis if extravasated (calcium chloride)\n"
            + "• Hypercalcemia (if overdosed)\n"
            + "• Cardiac arrest (if pushed rapidly in digoxin toxicity)\n\n"
            + "##The extravasation problem:##\n\n"
            + "Calcium chloride is highly caustic and can cause severe tissue necrosis if it extravasates. Always use a central line for calcium chloride. If peripheral access is the only option, use calcium gluconate instead (less caustic).\n\n"
            + "##Red flags:##\n\n"
            + "• Patient on digoxin (calcium can trigger arrhythmias or V-fib)\n"
            + "• Extravasation of calcium chloride (tissue necrosis)\n"
            + "• Bradycardia or hypotension after rapid push",
            dose: "##Hyperkalemia (with ECG changes):##\n\n"
            + "• Calcium chloride: 500 mg - 1 g (5-10 mL of 10%) IV over 2-5 minutes\n"
            + "• Calcium gluconate: 1-3 g (10-30 mL of 10%) IV over 2-5 minutes\n"
            + "• Onset: Immediate (within 1-3 minutes)\n"
            + "• Duration: 30-60 minutes (repeat as needed)\n\n"
            + "##Calcium Channel Blocker Overdose:##\n\n"
            + "• Calcium chloride: 1 g IV bolus, repeat every 10-20 minutes as needed\n"
            + "• May require large doses (10-20 g total)\n\n"
            + "##Magnesium Toxicity:##\n\n"
            + "• Calcium gluconate: 1-2 g IV over 2-5 minutes\n\n"
            + "##Hypocalcemia (symptomatic):##\n\n"
            + "• Calcium gluconate: 1-2 g IV over 10 minutes\n"
            + "• Follow with oral calcium and vitamin D\n\n"
            + "##Administration:##\n\n"
            + "• Push slowly over 2-5 minutes (rapid push causes bradycardia and hypotension)\n"
            + "• Calcium chloride → Central line preferred (caustic to veins)\n"
            + "• Calcium gluconate → Peripheral OK\n"
            + "• Do NOT mix with bicarbonate (precipitates)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Mineral and electrolyte replacement.\n\n"
            + "Used for hyperkalemia (membrane stabilization), hypocalcemia, calcium channel blocker overdose, and magnesium toxicity.",
            indications: "##Primary indications:##\n\n"
            + "• Hyperkalemia with ECG changes (peaked T waves, widened QRS)\n"
            + "• Hypocalcemia (symptomatic: tetany, seizures, prolonged QT)\n"
            + "• Calcium channel blocker overdose (diltiazem, verapamil, amlodipine)\n"
            + "• Magnesium toxicity (respiratory depression, loss of reflexes)\n"
            + "• Hydrofluoric acid burns (topical calcium gluconate gel)\n\n"
            + "##You'll reach for calcium when:##\n\n"
            + "• Hyperkalemic patient has widened QRS or peaked T waves on ECG\n"
            + "• Patient overdosed on calcium channel blocker → hypotension, bradycardia\n"
            + "• Magnesium toxicity with loss of deep tendon reflexes or respiratory depression\n\n"
            + "##Classic scenarios:##\n\n"
            + "• ESRD patient with K+ 7.5, ECG shows peaked T waves → Calcium gluconate 1-2 g IV\n"
            + "• Diltiazem overdose, BP 70/40, HR 40 → Calcium chloride 1 g IV bolus\n"
            + "• Eclampsia patient on mag sulfate drip, loses reflexes → Calcium gluconate 1 g IV",
            contraindiction: "##Absolute:##\n\n"
            + "• Hypercalcemia\n"
            + "• Ventricular fibrillation (calcium can worsen)\n"
            + "• Digoxin toxicity (calcium can trigger fatal arrhythmias)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Renal failure (risk of hypercalcemia)\n"
            + "• Sarcoidosis (increased sensitivity to calcium)\n"
            + "• Concurrent digoxin therapy (calcium potentiates digoxin toxicity)\n\n"
            + "##Critical safety point:## NEVER give calcium to a patient in digoxin toxicity. Calcium enhances digoxin's effects on the heart and can trigger fatal arrhythmias (\"stone heart\"). If the patient has hyperkalemia and is on digoxin, use other methods to lower potassium (insulin + dextrose, albuterol, dialysis) — avoid calcium.",
            onSet: "Immediate (1-3 minutes)",
            halfLife: "Unknown (calcium homeostasis tightly regulated)",
            duration: "30-60 min (hyperkalemia protection)",
            absorbtion: "N/A (IV only for emergencies)",
            distribution: "Extracellular fluid, bone, teeth",
            metaBolism: "None",
            excretion: "Urine (80%), feces (20%)",
            pregnancyExplanation: "Category C. Generally safe in pregnancy for acute indications (hyperkalemia, hypocalcemia). Chronic high-dose use may cause fetal harm.",
            criticalPearls: "##How to use calcium safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check if patient is on digoxin (CONTRAINDICATED in digoxin toxicity)\n"
            + "• Confirm IV access is secure (extravasation of calcium chloride causes tissue necrosis)\n"
            + "• Get ECG for hyperkalemia patients (look for peaked T, widened QRS)\n\n"
            + "##While it's running:##\n\n"
            + "• Push slowly over 2-5 minutes (rapid push causes bradycardia and hypotension)\n"
            + "• Monitor ECG continuously (watch for arrhythmias)\n"
            + "• If using calcium chloride peripherally, watch for signs of extravasation (pain, swelling)\n"
            + "• Duration is 30-60 minutes for hyperkalemia protection — you'll need to repeat or use other therapies\n\n"
            + "##Calcium Chloride vs. Calcium Gluconate:##\n\n"
            + "##Calcium Chloride:##\n\n"
            + "• 3x more elemental calcium than gluconate\n"
            + "• Faster, more potent effect\n"
            + "• Caustic to veins → Central line preferred\n"
            + "• Preferred in cardiac arrest, severe hyperkalemia, CCB overdose\n\n"
            + "##Calcium Gluconate:##\n\n"
            + "• Less elemental calcium (need 3x the dose)\n"
            + "• Gentler on veins → Peripheral OK\n"
            + "• Preferred for routine hypocalcemia, magnesium toxicity\n\n"
            + "##Bottom line:## Use calcium chloride if you need rapid effect and have central access. Use calcium gluconate for peripheral access or less urgent situations.\n\n"
            + "##Calcium for hyperkalemia:##\n\n"
            + "Calcium does NOT lower potassium — it only protects the heart by stabilizing the myocardial membrane. To actually lower potassium:\n\n"
            + "• Insulin + dextrose (shifts K+ into cells)\n"
            + "• Albuterol nebulizer (shifts K+ into cells)\n"
            + "• Furosemide (excretes K+ in urine)\n"
            + "• Sodium polystyrene sulfonate (Kayexalate) — removes K+ from GI tract\n"
            + "• Hemodialysis (definitive, fastest)\n\n"
            + "##Calcium incompatibility:##\n\n"
            + "Do NOT mix calcium with bicarbonate — it forms an insoluble precipitate. If both are needed (e.g., hyperkalemia with acidosis), flush the line between doses.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving calcium to a patient in digoxin toxicity (triggers fatal arrhythmias)\n"
            + "• Pushing too fast (causes bradycardia and hypotension)\n"
            + "• Using calcium chloride peripherally (causes tissue necrosis if extravasates)\n"
            + "• Mixing calcium with bicarbonate (precipitates)\n"
            + "• Thinking calcium lowers potassium (it doesn't — it only protects the heart)\n\n"
            + "##The takeaway:##\n\n"
            + "Calcium is the cardiac membrane stabilizer for hyperkalemia — it doesn't lower potassium, but it protects the heart from arrhythmias while you fix the underlying problem. It's also the antidote for calcium channel blocker overdose and magnesium toxicity. Push slowly, use central line for calcium chloride, and never give it in digoxin toxicity. Calcium buys you time — not a cure."
        ),
        
        // 9. Cefepime - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Cefepime",
            brandName: "Maxipime",
            mechansim: "Cefepime is a 4th-generation cephalosporin that inhibits bacterial cell wall synthesis.\n\n"
            + "It provides broad-spectrum Gram-positive & Gram-negative coverage, including Pseudomonas.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of cefepime as a precision gram-negative sniper.\n\n"
            + "##Very good at:##\n\n"
            + "• Killing hospital gram-negatives\n"
            + "• Including Pseudomonas\n\n"
            + "##Only okay at:##\n\n"
            + "• Streptococcus\n"
            + "• MSSA\n\n"
            + "##Does nothing for:##\n\n"
            + "• MRSA\n"
            + "• Enterococcus\n"
            + "• Anaerobes\n"
            + "• Atypicals\n\n"
            + "##Key concept:## Cefepime lives and dies by the kidneys. If the kidneys slow down, cefepime builds up — and the brain pays the price.",
            adverseEffects: "##Common:## GI upset, Rash.\n\n"
            + "##Serious:## Neurotoxicity (seizures, encephalopathy in renal failure).\n\n"
            + "When cefepime goes wrong##, it doesn't fail quietly. The patient becomes:\n\n"
            + "• Confused\n"
            + "• Tremulous\n"
            + "• Myoclonic\n"
            + "• Or seizing\n\n"
            + "And the CT is normal.\n\n"
            + "That is cefepime neurotoxicity until proven otherwise.##",
            dose: "1-2 g IV q8-12h (adjusted in renal failure).",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "4th-generation cephalosporin.\n\n"
            + "One of the ICU's workhorse antibiotics — strong, predictable, and familiar.",
            indications: "##Standard Indications:##\n\n"
            + "• Hospital-acquired pneumonia (HAP, VAP)\n"
            + "• Febrile neutropenia\n"
            + "• Sepsis\n"
            + "• Pseudomonas infections\n\n"
            + "##Give cefepime when you are worried about:##\n\n"
            + "• Hospital-acquired pneumonia\n"
            + "• Neutropenic fever\n"
            + "• Line infections\n"
            + "• Severe UTIs or bacteremia\n\n"
            + "##Clinical clues:## These patients often look toxic — fever, tachycardia, hypotension, rising WBC or lactate.",
            contraindiction: "##Absolute:## Severe cephalosporin allergy.\n\n"
            + "##Caution:## Renal impairment (high neurotoxicity risk).\n\n"
            + "##What cefepime needs (coverage gaps):##\n\n"
            + "• Metronidazole for anaerobes\n"
            + "• Vancomycin for MRSA\n"
            + "• Something else for Enterococcus",
            onSet: "Rapid onset",
            halfLife: "2 hours",
            duration: "Varies",
            absorbtion: "IV only",
            distribution: "Widely distributed, including CSF (crosses BBB).",
            metaBolism: "Minimal hepatic metabolism.",
            excretion: "Renal (dose adjust for CrCl).",
            pregnancyExplanation: "Use with caution in pregnancy. Benefits should outweigh risks.",
            criticalPearls: "##Covers Pseudomonas!##\n\n"
            + "• Crosses BBB → Can be used for meningitis.\n"
            + "• ##Neurotoxicity risk in renal failure patients.##\n\n"
            + "##How to use safely:##\n\n"
            + "##Before the first dose:##\n\n"
            + "• Check creatinine\n"
            + "• Estimate renal clearance\n\n"
            + "##During therapy:##\n\n"
            + "• Re-check kidney function daily\n"
            + "• Watch mental status\n"
            + "• Watch for myoclonus or agitation\n\n"
            + "If the patient becomes altered:##\n\n"
            + "• Stop cefepime\n"
            + "• Switch agents\n"
            + "• Adjust for renal failure\n"
            + "• Do not wait for levels — this toxicity is clinical.\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Cefepime is a powerful gram-negative and Pseudomonas drug, but it is unforgiving in renal failure. Dose it to the kidneys, watch the brain, and it will serve you well.\n\n"
            + "##High-yield point:## Cefepime neurotoxicity presents as encephalopathy or seizures in patients with renal impairment. It's a clinical diagnosis — don't wait for drug levels."
        ),
        
        // 10. Cisatracurium
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Cisatracurium",
            brandName: "Nimbex",
            mechansim: "Cisatracurium is a non-depolarizing neuromuscular blocking agent that competitively blocks acetylcholine at the motor end plate.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of cisatracurium as the organ-failure-friendly paralytic. Unlike rocuronium and vecuronium, it doesn't rely on liver or kidney function for elimination. It undergoes Hofmann elimination — a spontaneous chemical breakdown in plasma based on temperature and pH. This makes it ideal for patients with renal or hepatic failure.\n\n"
            + "##How it works:##\n\n"
            + "• Competitively blocks nicotinic acetylcholine receptors at neuromuscular junction\n"
            + "• Prevents muscle depolarization → Paralysis\n"
            + "• No fasciculations (unlike succinylcholine)\n"
            + "• Reversed by anticholinesterases (neostigmine) — sugammadex does NOT reverse cisatracurium (only works on steroidal NMBAs like rocuronium/vecuronium)\n"
            + "• Eliminated by Hofmann degradation (pH and temperature dependent)\n\n"
            + "##The key:## Cisatracurium is metabolized by Hofmann elimination (spontaneous degradation in plasma), not by liver or kidneys. This makes it the paralytic of choice in patients with multi-organ failure, renal failure, or hepatic failure.\n\n"
            + "##High-yield point:## Hofmann elimination is pH and temperature dependent. Acidosis and hypothermia prolong the duration of cisatracurium. In critically ill patients with acidosis or hypothermia, cisatracurium may have prolonged effect.",
            adverseEffects: "##Common:##\n\n"
            + "• Minimal histamine release (less than atracurium)\n"
            + "• Flushing (rare)\n\n"
            + "##Serious:##\n\n"
            + "• Bronchospasm (rare, histamine-related)\n"
            + "• Bradycardia (rare)\n"
            + "• Prolonged paralysis (with acidosis, hypothermia)\n"
            + "• Critical illness myopathy (with prolonged use, especially with steroids)\n\n"
            + "##The critical illness myopathy problem:##\n\n"
            + "Prolonged use of neuromuscular blocking agents in the ICU, especially combined with corticosteroids, can cause critical illness myopathy and prolonged weakness. Use for the shortest duration necessary and provide daily sedation interruption to assess.\n\n"
            + "##Red flags:##\n\n"
            + "• Prolonged weakness after stopping (critical illness myopathy)\n"
            + "• Bronchospasm (treat with bronchodilators)\n"
            + "• Unexpectedly prolonged paralysis (check temperature, pH)",
            dose: "##Intubation:##\n\n"
            + "• 0.15-0.2 mg/kg IV\n"
            + "• Onset: 2-3 minutes (slower than rocuronium)\n"
            + "• Not ideal for RSI (slow onset)\n\n"
            + "##Maintenance infusion (ICU paralysis):##\n\n"
            + "• 1-3 mcg/kg/min IV\n"
            + "• Titrate to train-of-four (TOF) monitoring\n"
            + "• Target: 1-2 twitches on TOF\n\n"
            + "##ARDS paralysis (ACURASYS):##\n\n"
            + "• 15 mg IV bolus, then 37.5 mg/hr infusion for 48 hours\n"
            + "• Used in severe ARDS (P/F <150)\n\n"
            + "##Administration:##\n\n"
            + "• Monitor with train-of-four (TOF)\n"
            + "• Always ensure adequate sedation before paralysis\n"
            + "• Limit duration when possible",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Non-depolarizing neuromuscular blocker.\n\n"
            + "Organ-failure-friendly paralytic that undergoes Hofmann elimination.",
            indications: "##Primary indications:##\n\n"
            + "• ICU paralysis (severe ARDS, refractory hypoxemia)\n"
            + "• Facilitate mechanical ventilation\n"
            + "• Surgical paralysis (operating room)\n"
            + "• Intubation (when slower onset acceptable)\n\n"
            + "##You'll reach for cisatracurium when:##\n\n"
            + "• Severe ARDS requiring paralysis (ACURASYS protocol)\n"
            + "• Multi-organ failure requiring paralysis (renal and hepatic failure)\n"
            + "• Need prolonged ICU paralysis\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Severe ARDS, P/F <150, ventilator dyssynchrony → Cisatracurium infusion for 48 hours\n"
            + "• ICU patient with ESRD and liver failure, need paralysis → Cisatracurium (Hofmann elimination)\n"
            + "• OR case in patient with renal failure → Cisatracurium (organ-independent)",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Myasthenia gravis (very sensitive — use cautiously if at all)\n"
            + "• Severe acidosis or hypothermia (prolongs effect)\n"
            + "• Without adequate sedation (paralysis without sedation is torture)\n\n"
            + "##Critical safety point:## NEVER use neuromuscular blockers without adequate sedation. Paralyzed patients can be fully aware and feel pain. Always ensure deep sedation (BIS monitoring or equivalent) before and during paralysis.",
            onSet: "2-3 min (slower than rocuronium)",
            halfLife: "22-29 min",
            duration: "35-55 min (variable with temperature/pH)",
            absorbtion: "N/A (IV only)",
            distribution: "Extracellular fluid",
            metaBolism: "Hofmann elimination (pH/temperature dependent)",
            excretion: "Urine and feces (inactive metabolites)",
            pregnancyExplanation: "Category B. Use in pregnancy if benefits outweigh risks. Crosses placenta minimally.",
            criticalPearls: "##How to use cisatracurium safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• ENSURE ADEQUATE SEDATION (BIS <40, or equivalent deep sedation)\n"
            + "• Check for myasthenia gravis (extreme sensitivity)\n"
            + "• Have train-of-four (TOF) monitor available\n"
            + "• Document indication and plan for daily reassessment\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor sedation continuously (paralysis without sedation is torture)\n"
            + "• Monitor TOF every 4-6 hours (target 1-2 twitches)\n"
            + "• Daily sedation vacation to assess neuromuscular function (if safe)\n"
            + "• Limit duration when possible (critical illness myopathy risk)\n\n"
            + "##Why Hofmann elimination matters:##\n\n"
            + "Cisatracurium undergoes spontaneous degradation in plasma (Hofmann elimination):\n\n"
            + "• Does NOT require liver for metabolism\n"
            + "• Does NOT require kidneys for excretion\n"
            + "• Makes it ideal for multi-organ failure\n"
            + "• BUT: Affected by temperature and pH\n\n"
            + "##Factors that PROLONG effect:##\n\n"
            + "• Hypothermia (slows Hofmann degradation)\n"
            + "• Acidosis (slows Hofmann degradation)\n"
            + "• Both common in critically ill patients\n\n"
            + "##Cisatracurium vs. Rocuronium:##\n\n"
            + "##Cisatracurium:##\n\n"
            + "• Hofmann elimination — organ-independent\n"
            + "• Better for renal/hepatic failure\n"
            + "• Slower onset (2-3 min — not ideal for RSI)\n"
            + "• Less histamine release\n\n"
            + "##Rocuronium:##\n\n"
            + "• Hepatic metabolism, biliary excretion\n"
            + "• Faster onset (45-60 sec — great for RSI)\n"
            + "• Reversible with sugammadex (specific reversal)\n"
            + "• Preferred for RSI when succinylcholine contraindicated\n\n"
            + "##ARDS paralysis (ACURASYS trial):##\n\n"
            + "Early paralysis with cisatracurium in severe ARDS (P/F less than 150) for 48 hours:\n\n"
            + "• May improve oxygenation\n"
            + "• May reduce ventilator-induced lung injury\n"
            + "• May reduce mortality (controversial — ROSE trial didn't replicate)\n"
            + "• Current approach: Consider for severe ARDS with ventilator dyssynchrony\n\n"
            + "##Common mistakes:##\n\n"
            + "• Paralysis without adequate sedation (patient aware and in pain)\n"
            + "• Not monitoring with TOF (overdosing or underdosing)\n"
            + "• Prolonged use without daily reassessment (critical illness myopathy)\n"
            + "• Using for RSI without understanding slower onset\n\n"
            + "##The takeaway:##\n\n"
            + "Cisatracurium is the organ-failure-friendly paralytic. It undergoes Hofmann elimination (pH/temperature dependent), making it ideal for renal and hepatic failure. Use for ICU paralysis (ARDS) and when organ-independent metabolism is needed. Monitor with TOF, ensure deep sedation, and limit duration. Onset is slower (2-3 min) than rocuronium, so it's not first choice for RSI."
        ),
        
        // 11. Daptomycin - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Daptomycin",
            brandName: "Cubicin",
            mechansim: "Lipopeptide antibiotic that disrupts bacterial cell membranes, leading to rapid depolarization.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of daptomycin as a bacterial defibrillator.\n\n"
            + "It sticks into the bacterial membrane and short-circuits it, causing instant cell death.\n\n"
            + "That's why## it's so effective for:\n\n"
            + "• MRSA\n"
            + "• VRE\n"
            + "• Deep bloodstream and heart valve infections\n\n"
            + "##Critical rule:## It doesn't work in the lungs. Pulmonary surfactant shuts daptomycin off. So in pneumonia, it is essentially dead drug.",
            adverseEffects: "##Common:## Myopathy (monitor CK levels).\n\n"
            + "##Serious:## Rhabdomyolysis (avoid with statins!).\n\n"
            + "If dosing or kidneys go wrong##, the patient may develop:\n\n"
            + "• Muscle pain\n"
            + "• Weakness\n"
            + "• Dark urine\n"
            + "• Rising creatine kinase (CPK)\n\n"
            + "That's drug-induced muscle injury, not the infection.##",
            dose: "4-6 mg/kg IV q24h. Adjust for renal function.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Lipopeptide antibiotic.\n\n"
            + "One of the fastest-killing gram-positive drugs we have.",
            indications: "##Standard Indications:##\n\n"
            + "• MRSA & VRE infections\n"
            + "• Skin and soft tissue infections\n"
            + "• Endocarditis\n"
            + "• NOT used for pneumonia\n\n"
            + "##Use daptomycin when:##\n\n"
            + "• MRSA bacteremia won't clear\n"
            + "• VRE is in the blood\n"
            + "• A valve, joint, or device is infected\n"
            + "• Vancomycin is causing AKI",
            contraindiction: "##Absolute:## Pneumonia (inactivated by lung surfactant).\n\n"
            + "##Caution:## Renal failure. Avoid with statins if possible.\n\n"
            + "##Two rules you can't break:##\n\n"
            + "• Never use it for pneumonia\n"
            + "• Always respect the muscles and kidneys",
            onSet: "Rapid onset",
            halfLife: "8-9 hours",
            duration: "Varies",
            absorbtion: "IV only",
            distribution: "Good tissue penetration (except lungs).",
            metaBolism: "Minimal.",
            excretion: "Renal (dose adjust for CrCl).",
            pregnancyExplanation: "Use with caution. Benefits should outweigh risks in serious infections.",
            criticalPearls: "##Dapto = 'Don't use for Pneumo'##\n\n"
            + "• ##Inactivated by lung surfactant!##\n"
            + "• Monitor CK levels due to myopathy risk.\n\n"
            + "##How to use safely:##\n\n"
            + "##Before the first dose:##\n\n"
            + "• Check baseline CPK\n"
            + "• Review statins (hold if you can)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor CPK weekly (more often if renal failure)\n"
            + "• Watch renal function\n"
            + "• Ask about muscle pain\n\n"
            + "##Stop and switch if:##\n\n"
            + "• CPK rises sharply\n"
            + "• The patient is weak\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Daptomycin is a high-power MRSA and VRE killer for bloodstream and deep infections — but it is useless in the lungs and hard on muscle. Use it when you need it, monitor closely, and it will do exactly what you want.\n\n"
            + "##High-yield point:## Daptomycin is calcium-dependent. Always ensure adequate ionized calcium levels for optimal bactericidal activity. Also, the higher the dose (8-10 mg/kg), the better for endocarditis and osteomyelitis."
        ),
        
        // 12. Desmopressin
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Desmopressin",
            brandName: "DDAVP",
            mechansim: "Desmopressin is a synthetic analog of ADH (vasopressin) that promotes water reabsorption and releases von Willebrand factor and factor VIII from endothelium.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of desmopressin as having two distinct uses: the water retainer and the clotting enhancer. For diabetes insipidus, it replaces absent ADH, concentrating urine and retaining water. For bleeding disorders, it releases stored vWF and factor VIII from endothelial cells, temporarily improving clotting.\n\n"
            + "##How it works:##\n\n"
            + "• V2 receptor agonist in kidney collecting ducts → Inserts aquaporins → Water retention\n"
            + "• Releases von Willebrand factor from endothelial stores (Weibel-Palade bodies)\n"
            + "• Increases factor VIII levels (carried by vWF)\n"
            + "• Minimal V1 (vasoconstrictor) effects — doesn't raise BP like vasopressin\n\n"
            + "##The key:## Desmopressin is used for central diabetes insipidus (not nephrogenic — kidneys must respond to ADH), mild hemophilia A (raises factor VIII), von Willebrand disease (releases vWF), and uremic bleeding (improves platelet function).\n\n"
            + "##High-yield point:## Desmopressin causes water retention → Can cause hyponatremia and seizures, especially with repeated doses. Monitor sodium closely, especially in children and elderly. Limit fluid intake during treatment.",
            adverseEffects: "##Common:##\n\n"
            + "• Headache\n"
            + "• Facial flushing\n"
            + "• Nausea\n\n"
            + "##Serious:##\n\n"
            + "• Hyponatremia (water intoxication) — can cause seizures\n"
            + "• Fluid overload\n"
            + "• Thrombosis (rare, with repeated dosing for bleeding)\n\n"
            + "##The hyponatremia problem:##\n\n"
            + "Desmopressin causes water retention. With unrestricted fluid intake, this leads to dilutional hyponatremia, which can cause seizures. Risk is higher in children, elderly, and with repeated doses.\n\n"
            + "##Prevention:##\n\n"
            + "• Restrict fluid intake during treatment\n"
            + "• Monitor serum sodium\n"
            + "• Limit repeated dosing\n\n"
            + "##Red flags:##\n\n"
            + "• Sodium <130 (hyponatremia — hold desmopressin)\n"
            + "• Seizures (severe hyponatremia)\n"
            + "• Peripheral edema (fluid overload)",
            dose: "##Diabetes Insipidus:##\n\n"
            + "• Intranasal: 10-40 mcg daily (divided into 1-3 doses)\n"
            + "• IV/SQ: 0.5-4 mcg daily (divided into 2 doses)\n"
            + "• Titrate to urine output and serum sodium\n\n"
            + "##Bleeding Disorders (Hemophilia A, vWD, uremic bleeding):##\n\n"
            + "• 0.3 mcg/kg IV over 15-30 minutes\n"
            + "• Max: 20-24 mcg\n"
            + "• Effect peaks in 30-60 minutes, lasts 6-12 hours\n"
            + "• May repeat in 12-24 hours if needed\n\n"
            + "##Uremic Bleeding:##\n\n"
            + "• 0.3 mcg/kg IV\n"
            + "• Temporarily improves platelet function in uremic patients\n\n"
            + "##Administration:##\n\n"
            + "• Give IV slowly (over 15-30 minutes) for bleeding disorders\n"
            + "• Restrict fluids during treatment\n"
            + "• Monitor sodium with repeated doses",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Synthetic ADH analog.\n\n"
            + "Used for diabetes insipidus and bleeding disorders (hemophilia A, vWD, uremic bleeding).",
            indications: "##Primary indications:##\n\n"
            + "• Central diabetes insipidus (not nephrogenic)\n"
            + "• Hemophilia A (mild, type 1)\n"
            + "• Von Willebrand disease (type 1)\n"
            + "• Uremic bleeding (improves platelet function)\n"
            + "• Nocturnal enuresis (bedwetting)\n\n"
            + "##You'll reach for desmopressin when:##\n\n"
            + "• Central DI — massive polyuria, low urine osmolality, high serum sodium\n"
            + "• Mild hemophilia A needing minor procedure → Desmopressin to raise factor VIII\n"
            + "• Von Willebrand disease (type 1) with bleeding\n"
            + "• Uremic patient with bleeding (temporary measure)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Post-neurosurgery patient with urine output 500 mL/hr, serum Na 152 → Central DI → Desmopressin\n"
            + "• Mild hemophilia A, need dental extraction → Desmopressin 0.3 mcg/kg before procedure\n"
            + "• Dialysis patient with GI bleeding → Desmopressin 0.3 mcg/kg for uremic platelet dysfunction",
            contraindiction: "##Absolute:##\n\n"
            + "• Type 2B von Willebrand disease (can cause thrombocytopenia)\n"
            + "• Severe hyponatremia\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Moderate hyponatremia\n"
            + "• Fluid overload/CHF\n"
            + "• Nephrogenic DI (won't work — kidneys don't respond to ADH)\n"
            + "• Renal impairment (reduce dose)\n\n"
            + "##Critical safety point:## Desmopressin does NOT work for nephrogenic DI (kidneys must respond to ADH). It also does NOT work for severe hemophilia or type 3 vWD (need factor replacement). It causes hyponatremia — restrict fluids and monitor sodium.",
            onSet: "15-30 min (IV), 1-2 hrs (intranasal)",
            halfLife: "3-4 hrs",
            duration: "6-12 hrs (for bleeding), longer for DI",
            absorbtion: "Variable intranasal (10-20%)",
            distribution: "Crosses into breast milk",
            metaBolism: "Minimal",
            excretion: "Urine (unchanged)",
            pregnancyExplanation: "Category B. Use in pregnancy if benefits outweigh risks. Generally considered safe.",
            criticalPearls: "##How to use desmopressin safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check serum sodium (hold if hyponatremic)\n"
            + "• For bleeding: Confirm diagnosis (hemophilia A, vWD type 1)\n"
            + "• For DI: Confirm central DI (water deprivation test if needed)\n\n"
            + "##While it's running:##\n\n"
            + "• Restrict fluid intake (prevents hyponatremia)\n"
            + "• Monitor sodium (especially with repeated doses)\n"
            + "• Monitor urine output (for DI treatment)\n\n"
            + "##Central vs. Nephrogenic DI:##\n\n"
            + "##Central DI:##\n\n"
            + "• Brain doesn't make enough ADH\n"
            + "• Causes: Head trauma, pituitary surgery, tumors, Sheehan's\n"
            + "• Treatment: Desmopressin (WORKS)\n\n"
            + "##Nephrogenic DI:##\n\n"
            + "• Kidneys don't respond to ADH\n"
            + "• Causes: Lithium, hypercalcemia, chronic kidney disease\n"
            + "• Treatment: Desmopressin does NOT work\n"
            + "• Use thiazide diuretics (paradoxically reduce urine output)\n\n"
            + "##Desmopressin for bleeding disorders:##\n\n"
            + "Desmopressin releases stored vWF and factor VIII:\n\n"
            + "• Dose: 0.3 mcg/kg IV over 15-30 minutes\n"
            + "• Effect: Raises factor VIII and vWF 2-5x\n"
            + "• Peak: 30-60 minutes\n"
            + "• Duration: 6-12 hours\n\n"
            + "##Who responds:##\n\n"
            + "• Mild hemophilia A (type 1) — has some factor VIII to boost\n"
            + "• Von Willebrand disease type 1 — has some vWF to release\n"
            + "• Uremic platelet dysfunction — improves temporarily\n\n"
            + "##Who doesn't respond:##\n\n"
            + "• Severe hemophilia A (no factor VIII stores)\n"
            + "• Type 3 vWD (no vWF stores)\n"
            + "• Type 2B vWD (contraindicated — causes thrombocytopenia)\n\n"
            + "##Tachyphylaxis:##\n\n"
            + "Repeated doses of desmopressin (within 24-48 hours) cause reduced response:\n\n"
            + "• Endothelial stores of vWF/factor VIII become depleted\n"
            + "• Second dose is less effective than first\n"
            + "• If bleeding continues, need factor replacement\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using for nephrogenic DI (won't work)\n"
            + "• Using for type 2B vWD (causes thrombocytopenia)\n"
            + "• Not restricting fluids (hyponatremia)\n"
            + "• Expecting repeated doses to work equally well (tachyphylaxis)\n\n"
            + "##The takeaway:##\n\n"
            + "Desmopressin is synthetic ADH used for central DI and bleeding disorders. For bleeding, give 0.3 mcg/kg IV — it releases vWF and factor VIII. Works for mild hemophilia A, type 1 vWD, and uremic bleeding. Restrict fluids (causes hyponatremia). Doesn't work for nephrogenic DI or severe factor deficiencies. Watch for tachyphylaxis with repeated dosing."
        ),
        
        // 13. Dexamethasone
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Dexamethasone",
            brandName: "Decadron ®",
            mechansim: "Dexamethasone is a potent, long-acting corticosteroid that reduces inflammation by suppressing immune cell activity and stabilizing cell membranes.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of dexamethasone as the brain swelling fighter and airway rescue steroid. It has minimal mineralocorticoid activity (no fluid retention), making it ideal for cerebral edema. It's also first-line for croup, COVID-19 respiratory failure, and bacterial meningitis (given with antibiotics).\n\n"
            + "##How it works:##\n\n"
            + "• Binds to glucocorticoid receptors → Suppresses inflammatory cytokines (IL-1, IL-6, TNF-α)\n"
            + "• Stabilizes cell membranes → Reduces capillary permeability (decreases edema)\n"
            + "• Inhibits phospholipase A2 → Reduces prostaglandin and leukotriene synthesis\n"
            + "• Minimal mineralocorticoid effect → No sodium retention or fluid overload\n\n"
            + "##The key:## Dexamethasone is 25x more potent than hydrocortisone and has a long half-life (36-72 hours). It's the steroid of choice for cerebral edema (brain tumors, meningitis) because it doesn't cause fluid retention. It's also proven to reduce mortality in COVID-19 requiring oxygen.\n\n"
            + "##High-yield point:## Dexamethasone improves survival in severe COVID-19 (requiring oxygen or ventilation) by ~30%. It's also the standard of care for croup (reduces airway edema) and bacterial meningitis (reduces neurologic sequelae when given with antibiotics).",
            adverseEffects: "##Common:##\n\n"
            + "• Hyperglycemia (very common)\n"
            + "• Insomnia, agitation\n"
            + "• Increased appetite\n"
            + "• Mood changes\n\n"
            + "##Serious:##\n\n"
            + "• Adrenal suppression (with prolonged use)\n"
            + "• Immunosuppression (increased infection risk)\n"
            + "• GI bleeding, peptic ulcers\n"
            + "• Avascular necrosis (long-term use)\n"
            + "• Psychosis, mania\n\n"
            + "##The hyperglycemia problem:##\n\n"
            + "Steroids cause insulin resistance, leading to hyperglycemia. Monitor glucose closely, especially in diabetics. May need insulin to control glucose.\n\n"
            + "##Red flags:##\n\n"
            + "• Glucose >300 mg/dL (steroid-induced hyperglycemia)\n"
            + "• New-onset psychosis or agitation\n"
            + "• GI bleeding (black stools, hematemesis)\n"
            + "• Signs of infection (steroids mask fever)",
            dose: "##Cerebral Edema (brain tumor, abscess):##\n\n"
            + "• Loading: 10 mg IV\n"
            + "• Maintenance: 4 mg IV/PO every 6 hours\n\n"
            + "##Bacterial Meningitis:##\n\n"
            + "• 10 mg IV 15-20 minutes before antibiotics\n"
            + "• Continue 4 mg IV every 6 hours for 4 days\n\n"
            + "##COVID-19 (requiring oxygen or ventilation):##\n\n"
            + "• 6 mg PO/IV once daily for 10 days\n\n"
            + "##Croup:##\n\n"
            + "• 0.6 mg/kg PO/IM (max 10 mg)\n"
            + "• Single dose usually sufficient\n\n"
            + "##Nausea/Vomiting (chemotherapy):##\n\n"
            + "• 10-20 mg IV (antiemetic)\n\n"
            + "##Administration:##\n\n"
            + "• Can give IV, PO, or IM\n"
            + "• For meningitis: Give BEFORE antibiotics to reduce inflammation\n"
            + "• For COVID-19: Give once daily for 10 days (or until discharge)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Long-acting corticosteroid.\n\n"
            + "Used for cerebral edema, bacterial meningitis, COVID-19, croup, and nausea/vomiting.",
            indications: "##Primary indications:##\n\n"
            + "• Cerebral edema (brain tumor, abscess, traumatic brain injury)\n"
            + "• Bacterial meningitis (adjunct to antibiotics)\n"
            + "• Severe COVID-19 requiring oxygen or mechanical ventilation\n"
            + "• Croup (laryngotracheobronchitis)\n"
            + "• Nausea/vomiting (chemotherapy, postoperative)\n"
            + "• Spinal cord compression\n"
            + "• Altitude sickness (HACE)\n\n"
            + "##You'll reach for dexamethasone when:##\n\n"
            + "• Brain tumor patient with headache, papilledema (cerebral edema)\n"
            + "• Bacterial meningitis patient needs adjunct therapy\n"
            + "• COVID-19 patient on high-flow oxygen or ventilator\n"
            + "• Child with barky cough and stridor (croup)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Patient with brain metastases, severe headache, papilledema → Dexamethasone 10 mg IV\n"
            + "• Pneumococcal meningitis → Dexamethasone 10 mg IV before ceftriaxone\n"
            + "• COVID-19 patient on 15 L O₂, declining → Dexamethasone 6 mg daily for 10 days",
            contraindiction: "##Absolute:##\n\n"
            + "• Systemic fungal infection (steroids worsen fungal infections)\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Active infection (steroids suppress immune response)\n"
            + "• Diabetes (causes hyperglycemia)\n"
            + "• Peptic ulcer disease (increases GI bleeding risk)\n"
            + "• Psychosis or severe psychiatric illness\n"
            + "• Live vaccines (immunosuppression)\n\n"
            + "##Critical safety point:## Do NOT give dexamethasone for mild COVID-19 (not requiring oxygen). The RECOVERY trial showed benefit only in patients requiring supplemental oxygen or mechanical ventilation. Giving steroids to mild COVID patients may worsen outcomes.",
            onSet: "Rapid (within hours)",
            halfLife: "36-72 hrs",
            duration: "Long-acting (days)",
            absorbtion: "Rapid (oral and IV)",
            distribution: "Widely distributed, crosses BBB",
            metaBolism: "Hepatic",
            excretion: "Urine",
            pregnancyExplanation: "Category C. Use in pregnancy only if benefits outweigh risks. May cause fetal adrenal suppression with prolonged use.",
            criticalPearls: "##How to use dexamethasone safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check for active infection (steroids can worsen)\n"
            + "• Check glucose (especially in diabetics)\n"
            + "• For meningitis: Give dexamethasone BEFORE antibiotics\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor glucose closely (may need insulin)\n"
            + "• Watch for signs of infection (steroids mask fever)\n"
            + "• Monitor mental status (can cause psychosis)\n"
            + "• For cerebral edema: Taper gradually (don't stop abruptly)\n\n"
            + "##Dexamethasone for COVID-19:##\n\n"
            + "##The RECOVERY## trial showed that dexamethasone 6 mg daily for 10 days reduces mortality in:\n\n"
            + "• Patients on mechanical ventilation (mortality reduced from 41% to 29%)\n"
            + "• Patients on supplemental oxygen (mortality reduced from 25% to 23%)\n\n"
            + "##Do NOT use in mild COVID:## No benefit in patients not requiring oxygen. May actually worsen outcomes.\n\n"
            + "##Dexamethasone for bacterial meningitis:##\n\n"
            + "• Give dexamethasone 10 mg IV 15-20 minutes BEFORE antibiotics\n"
            + "• Reduces neurologic sequelae (hearing loss, cognitive impairment)\n"
            + "• Most benefit in pneumococcal meningitis\n"
            + "• Continue for 4 days\n\n"
            + "##Dexamethasone for croup:##\n\n"
            + "• Single dose of 0.6 mg/kg (max 10 mg) PO or IM\n"
            + "• Reduces airway edema, stridor, and need for intubation\n"
            + "• Works within 1-2 hours, lasts 24-48 hours\n\n"
            + "##Dexamethasone vs. Methylprednisolone:##\n\n"
            + "##Dexamethasone:##\n\n"
            + "• 25x more potent than hydrocortisone\n"
            + "• Longer half-life (36-72 hours)\n"
            + "• Minimal mineralocorticoid activity (no fluid retention)\n"
            + "• Preferred for cerebral edema, meningitis, COVID-19\n\n"
            + "##Methylprednisolone:##\n\n"
            + "• 5x more potent than hydrocortisone\n"
            + "• Shorter half-life (12-36 hours)\n"
            + "• Some mineralocorticoid activity\n"
            + "• Preferred for asthma/COPD exacerbations, spinal cord injury\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving dexamethasone for mild COVID-19 (no benefit, may harm)\n"
            + "• Not monitoring glucose (causes severe hyperglycemia)\n"
            + "• Stopping abruptly after prolonged use (adrenal crisis)\n"
            + "• Giving antibiotics before dexamethasone in meningitis (dex should be first)\n\n"
            + "##The takeaway:##\n\n"
            + "Dexamethasone is a potent, long-acting steroid with minimal fluid retention, making it ideal for cerebral edema. It's proven to reduce mortality in severe COVID-19 (requiring oxygen) and reduce neurologic sequelae in bacterial meningitis (give before antibiotics). It's also first-line for croup. Monitor glucose closely and taper gradually after prolonged use."
        ),
        
        // 14. Diazepam
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Diazepam",
            brandName: "Valium ®",
            mechansim: "Diazepam is a long-acting benzodiazepine that enhances the inhibitory effects of GABA (gamma-aminobutyric acid) in the CNS.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of diazepam as the marathon runner of benzos — it has a very long half-life (20-95 hours) and active metabolites that can accumulate. Unlike lorazepam (short-acting, reliable), diazepam provides prolonged sedation and anticonvulsant effects, but this can lead to over-sedation if you're not careful.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to GABA-A receptors → Enhances GABA (inhibitory neurotransmitter)\n"
            + "• Result: CNS depression, sedation, anxiolysis, anticonvulsant effects\n"
            + "• Also causes muscle relaxation (useful for spasms)\n\n"
            + "##The key:## Diazepam is lipophilic (fat-soluble), so it redistributes quickly from the brain to fat tissue. This is why the immediate sedative effect wears off faster than the half-life suggests, but the drug (and its active metabolites) can accumulate over days.\n\n"
            + "##High-yield point:## Diazepam has active metabolites (desmethyldiazepam, oxazepam, temazepam) with half-lives up to 100 hours. This means prolonged sedation is common, especially in the elderly, patients with liver disease, or those on continuous infusions. Lorazepam (no active metabolites) is preferred for ICU sedation.",
            adverseEffects: "##Common:##\n\n"
            + "• Drowsiness, sedation\n"
            + "• Respiratory depression (especially with opioids)\n"
            + "• Hypotension (IV administration)\n"
            + "• Dizziness, ataxia\n\n"
            + "##Serious:##\n\n"
            + "• Severe respiratory depression (if combined with opioids or alcohol)\n"
            + "• Hypotension and bradycardia (rapid IV push)\n"
            + "• Paradoxical agitation (especially in elderly)\n"
            + "• Accumulation of active metabolites → Prolonged sedation\n\n"
            + "##The respiratory depression problem:##\n\n"
            + "Benzodiazepines cause dose-dependent respiratory depression. When combined with opioids (e.g., fentanyl, morphine), the risk of apnea increases dramatically. Always have bag-valve-mask and airway equipment ready.\n\n"
            + "##Red flags:##\n\n"
            + "• Respiratory rate <10, SpO₂ <90% (respiratory depression)\n"
            + "• Prolonged sedation beyond expected duration (active metabolite accumulation)\n"
            + "• Paradoxical agitation or confusion (especially elderly)\n"
            + "• Hypotension after IV push (give slowly over 2-3 minutes)",
            dose: "##Status Epilepticus (seizure termination):##\n\n"
            + "• 5-10 mg IV over 2-3 minutes\n"
            + "• May repeat once after 10-15 minutes if seizure persists\n"
            + "• Max: 30 mg in 8 hours\n\n"
            + "##Alcohol Withdrawal (adjunct to lorazepam):##\n\n"
            + "• 5-10 mg IV/PO every 6-8 hours\n"
            + "• Use symptom-triggered dosing (CIWA-Ar protocol)\n\n"
            + "##Muscle Spasms:##\n\n"
            + "• 5-10 mg IV/IM every 3-4 hours as needed\n\n"
            + "##Anxiety/Sedation:##\n\n"
            + "• 2-10 mg IV/IM (rarely used in ICU; lorazepam preferred)\n\n"
            + "##Administration:##\n\n"
            + "• Give IV push slowly (no faster than 5 mg/min) to avoid hypotension and respiratory depression\n"
            + "• IM absorption is erratic and unpredictable (avoid if possible)\n"
            + "• Do NOT give IM for status epilepticus (use IV lorazepam instead)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.D),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.D),
            DrugClass: "Long-acting benzodiazepine.\n\n"
            + "Used for status epilepticus, alcohol withdrawal, muscle spasms, and anxiety (though lorazepam is preferred for most ICU indications).",
            indications: "##Primary indications:##\n\n"
            + "• Status epilepticus (when lorazepam unavailable)\n"
            + "• Alcohol withdrawal (symptom-triggered dosing)\n"
            + "• Severe muscle spasms or spasticity\n"
            + "• Anxiety (outpatient; not preferred in ICU)\n"
            + "• Sedation for procedures (midazolam preferred)\n\n"
            + "##You'll reach for diazepam when:##\n\n"
            + "• Patient has refractory seizures and lorazepam isn't available\n"
            + "• Alcohol withdrawal patient needs long-acting benzo coverage\n"
            + "• Severe muscle spasms (e.g., tetanus, spinal cord injury)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Patient in alcohol withdrawal with CIWA-Ar score 18, tremulous → Diazepam 10 mg PO\n"
            + "• Seizing patient, lorazepam unavailable → Diazepam 10 mg IV slowly\n"
            + "• Tetanus patient with severe muscle spasms → Diazepam for muscle relaxation",
            contraindiction: "##Absolute:##\n\n"
            + "• Acute narrow-angle glaucoma\n"
            + "• Severe respiratory depression (unless intubated)\n"
            + "• Known hypersensitivity to benzodiazepines\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Shock or severe hypotension (IV push can worsen)\n"
            + "• Coma or severe CNS depression\n"
            + "• Concurrent opioid use (increases respiratory depression risk)\n"
            + "• Hepatic impairment (active metabolites accumulate)\n"
            + "• Elderly patients (increased sensitivity, prolonged effects)\n"
            + "• Myasthenia gravis (can worsen muscle weakness)\n\n"
            + "##Critical safety point:## Diazepam should NOT be first-line for status epilepticus in most modern protocols — lorazepam is preferred because it has a longer duration of anticonvulsant action (12-24 hours vs. 20 minutes for diazepam). Diazepam's anticonvulsant effect wears off quickly due to redistribution, even though the sedative effect persists.",
            onSet: "1-5 min (IV), 15-30 min (PO)",
            halfLife: "20-95 hrs (active metabolites up to 100 hrs)",
            duration: "15-60 min (anticonvulsant), but sedation lasts much longer",
            absorbtion: "Rapid (oral); erratic (IM)",
            distribution: "Highly lipophilic, crosses BBB, redistributes to fat",
            metaBolism: "Liver (CYP2C19, CYP3A4) → Active metabolites",
            excretion: "Urine (metabolites)",
            pregnancyExplanation: "Category D. Benzodiazepines cross the placenta and can cause fetal harm. Use in pregnancy only if benefits outweigh risks. Neonatal withdrawal and \"floppy baby syndrome\" reported.",
            criticalPearls: "##How to use diazepam safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Ensure airway equipment is available (bag-valve-mask, suction)\n"
            + "• Check for concurrent opioid use (increases respiratory depression risk)\n"
            + "• Assess liver function (active metabolites accumulate in hepatic impairment)\n"
            + "• Have flumazenil (reversal agent) available if needed\n\n"
            + "##While it's running:##\n\n"
            + "• Push IV slowly (no faster than 5 mg/min) to avoid hypotension and apnea\n"
            + "• Monitor respiratory rate, SpO₂, and blood pressure continuously\n"
            + "• Watch for prolonged sedation (can last days due to active metabolites)\n"
            + "• If respiratory depression occurs → Support ventilation, consider flumazenil (0.2 mg IV)\n\n"
            + "##Diazepam vs. Lorazepam for seizures:##\n\n"
            + "##Diazepam:##\n\n"
            + "• Faster onset (1-3 minutes)\n"
            + "• Shorter anticonvulsant duration (20 minutes)\n"
            + "• Longer sedative duration (hours to days)\n"
            + "• Active metabolites accumulate\n\n"
            + "##Lorazepam:##\n\n"
            + "• Slightly slower onset (2-5 minutes)\n"
            + "• Longer anticonvulsant duration (12-24 hours)\n"
            + "• Shorter sedative duration\n"
            + "• No active metabolites (preferred in ICU)\n\n"
            + "##Bottom line:## Lorazepam is preferred for status epilepticus because its anticonvulsant effect lasts longer. Diazepam stops the seizure faster, but the effect wears off quickly, requiring a second antiepileptic drug (phenytoin, levetiracetam).\n\n"
            + "##Diazepam vs. Lorazepam for alcohol withdrawal:##\n\n"
            + "##Diazepam:##\n\n"
            + "• Long-acting → Smoother taper, less breakthrough symptoms\n"
            + "• Preferred for outpatient or moderate withdrawal\n\n"
            + "##Lorazepam:##\n\n"
            + "• Shorter-acting → More predictable in liver disease\n"
            + "• Preferred for ICU or severe withdrawal (CIWA-Ar protocol)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using diazepam as first-line for status epilepticus (lorazepam is better)\n"
            + "• Giving IM diazepam (absorption is erratic; use IV or PO)\n"
            + "• Pushing IV too fast (causes hypotension and respiratory depression)\n"
            + "• Not accounting for active metabolites (prolonged sedation, especially in elderly)\n"
            + "• Combining with opioids without airway monitoring (respiratory arrest risk)\n\n"
            + "##The takeaway:##\n\n"
            + "Diazepam is a long-acting benzodiazepine with active metabolites that can accumulate, leading to prolonged sedation. It's used for alcohol withdrawal, muscle spasms, and seizures (when lorazepam isn't available), but lorazepam is preferred in the ICU due to more predictable pharmacokinetics. Push IV slowly, watch for respiratory depression, and remember: the anticonvulsant effect wears off quickly, but the sedation lasts for days."
        ),
        
        // 15. Diltiazem
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Diltiazem",
            brandName: "Cardizem ®",
            mechansim: "Diltiazem is a non-dihydropyridine calcium channel blocker that inhibits calcium influx into cardiac and smooth muscle cells.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of diltiazem as the rate control expert for atrial fibrillation and SVT. It slows conduction through the AV node (negative dromo tropy), slows the heart rate (negative chronotropy), and causes mild vasodilation. Unlike beta-blockers, it doesn't worsen bronchospasm, making it useful in patients with asthma or COPD.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks L-type calcium channels in the heart and blood vessels\n"
            + "• Slows AV node conduction → Slows ventricular response in atrial fib/flutter\n"
            + "• Decreases heart rate (negative chronotropy)\n"
            + "• Causes vasodilation → May lower blood pressure\n\n"
            + "##The key:## Diltiazem is great for rate control in atrial fibrillation, especially in patients who can't tolerate beta-blockers (asthmatics, COPD). It can also terminate SVT by blocking AV node re-entry circuits. But watch out — it can cause hypotension and bradycardia, especially if combined with beta-blockers.\n\n"
            + "##High-yield point:## Diltiazem is contraindicated in WPW (Wolff-Parkinson-White) syndrome with atrial fibrillation. Blocking the AV node can force conduction down the accessory pathway, leading to ventricular fibrillation. If you see a wide-complex irregular tachycardia, think WPW — don't give diltiazem or adenosine.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypotension (vasodilation)\n"
            + "• Bradycardia (AV node blockade)\n"
            + "• Dizziness, headache\n"
            + "• Peripheral edema (chronic use)\n\n"
            + "##Serious:##\n\n"
            + "• Severe hypotension (especially with beta-blockers)\n"
            + "• High-degree AV block (2nd or 3rd degree)\n"
            + "• Heart failure exacerbation (negative inotropy)\n"
            + "• Ventricular fibrillation (if given in WPW with atrial fib)\n\n"
            + "##The hypotension problem:##\n\n"
            + "Diltiazem causes vasodilation and can drop blood pressure, especially if pushed too fast or combined with other antihypertensives. Always push slowly over 2 minutes and have calcium chloride ready as an antidote.\n\n"
            + "##Red flags:##\n\n"
            + "• HR <50 or new AV block (excessive AV node blockade)\n"
            + "• BP <90 systolic (hypotension, consider calcium chloride)\n"
            + "• Wide-complex irregular tachycardia (possible WPW — do NOT give diltiazem)\n"
            + "• Worsening heart failure (negative inotropy)",
            dose: "##Atrial Fibrillation/Flutter (rate control):##\n\n"
            + "• Bolus: 0.25 mg/kg (typically 20 mg) IV over 2 minutes\n"
            + "• If inadequate response: 0.35 mg/kg (typically 25 mg) IV over 2 minutes after 15 minutes\n"
            + "• Infusion: 5-15 mg/hr IV (titrate to heart rate goal 60-110)\n\n"
            + "##SVT (paroxysmal supraventricular tachycardia):##\n\n"
            + "• Bolus: 0.25 mg/kg (typically 20 mg) IV over 2 minutes\n"
            + "• May repeat with 0.35 mg/kg if no response in 15 minutes\n\n"
            + "##Administration:##\n\n"
            + "• Push slowly over 2 minutes (rapid push causes hypotension)\n"
            + "• Have calcium chloride 1 g IV ready as antidote\n"
            + "• Monitor continuous ECG and blood pressure\n"
            + "• For infusions: Use central line preferred (peripheral OK if monitored)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Non-dihydropyridine calcium channel blocker (Class IV antiarrhythmic).\n\n"
            + "First-line for rate control in atrial fibrillation and SVT, especially in patients who can't tolerate beta-blockers.",
            indications: "##Primary indications:##\n\n"
            + "• Atrial fibrillation with rapid ventricular response (rate control)\n"
            + "• Atrial flutter (rate control)\n"
            + "• Paroxysmal supraventricular tachycardia (SVT)\n"
            + "• Hypertension (oral formulations)\n\n"
            + "##You'll reach for diltiazem when:##\n\n"
            + "• Patient has atrial fib with RVR (HR >120) and needs rate control\n"
            + "• SVT doesn't respond to vagal maneuvers or adenosine\n"
            + "• Patient has atrial fib with RVR but can't tolerate beta-blockers (asthma, COPD)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• 65-year-old with new atrial fib, HR 150, BP 130/80 → Diltiazem 20 mg IV (rate control)\n"
            + "• COPD patient with atrial fib, HR 140 → Diltiazem (can't use beta-blocker)\n"
            + "• SVT refractory to adenosine → Diltiazem 20 mg IV over 2 minutes",
            contraindiction: "##Absolute:##\n\n"
            + "• WPW syndrome with atrial fibrillation (can trigger V-fib)\n"
            + "• Sick sinus syndrome (unless pacemaker in place)\n"
            + "• 2nd or 3rd degree AV block (unless pacemaker in place)\n"
            + "• Severe hypotension (SBP <90)\n"
            + "• Cardiogenic shock\n"
            + "• Acute MI with pulmonary congestion (can worsen heart failure)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Heart failure with reduced EF (negative inotropy can worsen)\n"
            + "• Concurrent beta-blocker use (additive effects on HR and BP)\n"
            + "• Hepatic impairment (diltiazem is metabolized by liver)\n"
            + "• Elderly patients (increased sensitivity to hypotension)\n\n"
            + "##Critical safety point:## Never give diltiazem (or any AV-nodal blocker) to a patient with WPW and atrial fibrillation. WPW presents as a wide-complex irregular tachycardia. Blocking the AV node forces conduction down the accessory pathway, which can degenerate into ventricular fibrillation. If you see irregular wide-complex tachycardia, think WPW — give procainamide or cardiovert.",
            onSet: "2-5 min (IV)",
            halfLife: "3.5-9 hrs",
            duration: "1-3 hrs (bolus), longer with infusion",
            absorbtion: "Well absorbed (oral)",
            distribution: "Highly protein bound (70-80%)",
            metaBolism: "Liver (CYP3A4)",
            excretion: "Urine (35%), feces (65%)",
            pregnancyExplanation: "Category C. Use in pregnancy only if benefits outweigh risks. Limited human data; animal studies show potential fetal harm.",
            criticalPearls: "##How to use diltiazem safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check ECG to rule out WPW (delta wave, short PR interval)\n"
            + "• Ensure patient is not in 2nd or 3rd degree AV block\n"
            + "• Check blood pressure (hold if SBP <90)\n"
            + "• Have calcium chloride 1 g IV ready as antidote\n\n"
            + "##While it's running:##\n\n"
            + "• Push bolus slowly over 2 minutes (rapid push causes hypotension)\n"
            + "• Monitor continuous ECG and blood pressure\n"
            + "• Titrate infusion to target heart rate 60-110 bpm\n"
            + "• If hypotension occurs → Give calcium chloride 1 g IV slowly (reverses vasodilation)\n"
            + "• If excessive bradycardia → Hold infusion, consider atropine or pacing\n\n"
            + "##Diltiazem vs. Metoprolol for atrial fib rate control:##\n\n"
            + "##Diltiazem:##\n\n"
            + "• Safe in asthma/COPD (doesn't cause bronchospasm)\n"
            + "• More predictable rate control with infusion\n"
            + "• Can cause more hypotension\n\n"
            + "##Metoprolol:##\n\n"
            + "• Better if patient has heart failure (beta-blockers improve HF outcomes)\n"
            + "• Contraindicated in bronchospasm\n"
            + "• Less hypotension\n\n"
            + "##Bottom line:## Both work well for rate control. Use diltiazem in asthmatics/COPD patients; use metoprolol in heart failure patients.\n\n"
            + "##Diltiazem vs. Adenosine for SVT:##\n\n"
            + "##Adenosine:##\n\n"
            + "• First-line for SVT (faster, terminates re-entry circuit)\n"
            + "• Ultra-short half-life (10 seconds)\n"
            + "• Causes brief asystole (scary but safe)\n\n"
            + "##Diltiazem:##\n\n"
            + "• Second-line for SVT (if adenosine fails)\n"
            + "• Longer duration (hours)\n"
            + "• Better for rate control if SVT doesn't convert\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving diltiazem to a patient with WPW (can trigger V-fib)\n"
            + "• Pushing too fast (causes hypotension and bradycardia)\n"
            + "• Combining with beta-blockers without caution (additive effects)\n"
            + "• Not having calcium chloride ready (needed for hypotension rescue)\n"
            + "• Using in severe heart failure (negative inotropy can worsen)\n\n"
            + "##The takeaway:##\n\n"
            + "Diltiazem is a calcium channel blocker that slows AV node conduction, making it excellent for rate control in atrial fibrillation and SVT. It's especially useful in patients with asthma or COPD who can't tolerate beta-blockers. Push slowly over 2 minutes, keep calcium chloride ready, and never use it in WPW with atrial fibrillation."
        ),
        
        // 16. Diphenhydramine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Diphenhydramine",
            brandName: "Benadryl ®",
            mechansim: "Diphenhydramine is a first-generation antihistamine that blocks H1 receptors, antagonizing the effects of histamine in allergic reactions.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of diphenhydramine as the histamine blocker with anticholinergic side effects. It's the go-to for allergic reactions (urticaria, pruritus) and drug-induced dystonia (from antipsychotics). However, its anticholinergic properties cause significant sedation, dry mouth, and urinary retention — especially problematic in the elderly.\n\n"
            + "##How it works:##\n\n"
            + "• Competitive antagonist at H1 histamine receptors\n"
            + "• Blocks histamine-mediated vasodilation, increased permeability, pruritus\n"
            + "• Crosses blood-brain barrier → Causes sedation\n"
            + "• Anticholinergic effects → Dry mouth, urinary retention, constipation\n\n"
            + "##The key:## Diphenhydramine is second-line for anaphylaxis (after epinephrine), first-line for urticaria and pruritus, and first-line for treating extrapyramidal symptoms (dystonia) from antipsychotics.\n\n"
            + "##High-yield point:## In anaphylaxis, epinephrine is FIRST-LINE. Diphenhydramine is adjunctive only — it helps with urticaria and pruritus but does NOT treat bronchospasm or hypotension. Never give diphenhydramine instead of epinephrine for anaphylaxis.",
            adverseEffects: "##Common:##\n\n"
            + "• Sedation, drowsiness (most common)\n"
            + "• Dry mouth (anticholinergic)\n"
            + "• Blurred vision (anticholinergic)\n"
            + "• Urinary retention (anticholinergic)\n"
            + "• Constipation (anticholinergic)\n\n"
            + "##Serious:##\n\n"
            + "• Paradoxical excitation (especially in children)\n"
            + "• Delirium, confusion (especially in elderly)\n"
            + "• Seizures (in overdose)\n"
            + "• Anticholinergic toxicity (overdose)\n\n"
            + "##The anticholinergic problem:##\n\n"
            + "##First-generation## antihistamines like diphenhydramine have significant anticholinergic effects. In the elderly, this can cause:\n\n"
            + "• Confusion and delirium\n"
            + "• Falls\n"
            + "• Urinary retention\n"
            + "• Constipation/ileus\n\n"
            + "##Avoid or use low doses in elderly patients.\n\n"
            + "##Red flags:##\n\n"
            + "• Confusion/delirium in elderly (stop diphenhydramine)\n"
            + "• Urinary retention (especially in BPH)\n"
            + "• Paradoxical agitation in children",
            dose: "##Allergic Reactions/Urticaria:##\n\n"
            + "• 25-50 mg IV/IM/PO every 6-8 hours\n"
            + "• Max: 400 mg/day\n\n"
            + "##Anaphylaxis (adjunct to epinephrine):##\n\n"
            + "• 50 mg IV (after epinephrine is given)\n"
            + "• Does NOT replace epinephrine\n\n"
            + "##Dystonic Reactions (from antipsychotics):##\n\n"
            + "• 25-50 mg IV/IM\n"
            + "• Rapid onset\n"
            + "• Continue oral for 48-72 hours to prevent recurrence\n\n"
            + "##Pediatric:##\n\n"
            + "• 1-1.25 mg/kg IV/IM/PO every 6-8 hours\n"
            + "• Max: 50 mg per dose\n\n"
            + "##Elderly:##\n\n"
            + "• Start with 25 mg or less\n"
            + "• Avoid if possible (anticholinergic toxicity)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "First-generation antihistamine.\n\n"
            + "H1 blocker with significant anticholinergic effects. Also used for dystonic reactions.",
            indications: "##Primary indications:##\n\n"
            + "• Allergic reactions (urticaria, pruritus)\n"
            + "• Anaphylaxis (adjunct to epinephrine)\n"
            + "• Drug-induced dystonia (from antipsychotics, metoclopramide)\n"
            + "• Nausea/vomiting (motion sickness)\n"
            + "• Insomnia (short-term)\n\n"
            + "##You'll reach for diphenhydramine when:##\n\n"
            + "• Allergic reaction with hives and itching\n"
            + "• Dystonic reaction after haloperidol or metoclopramide\n"
            + "• Pre-medication for blood transfusion\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Drug allergy with urticaria, no anaphylaxis → Diphenhydramine 25-50 mg IV\n"
            + "• Haloperidol given, patient develops torticollis → Diphenhydramine 50 mg IV\n"
            + "• Anaphylaxis from bee sting → Epinephrine FIRST, then diphenhydramine as adjunct",
            contraindiction: "##Absolute:##\n\n"
            + "• Acute asthma attack (anticholinergic effects may worsen)\n"
            + "• Known hypersensitivity\n"
            + "• Neonates/premature infants\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Elderly (high anticholinergic burden)\n"
            + "• BPH (urinary retention risk)\n"
            + "• Narrow-angle glaucoma\n"
            + "• GI obstruction\n"
            + "• Concurrent CNS depressants (additive sedation)\n\n"
            + "##Critical safety point:## Diphenhydramine is on the Beers list of medications to avoid in elderly patients due to anticholinergic effects. Consider second-generation antihistamines (cetirizine, loratadine) when possible.",
            onSet: "Immediate (IV), 30-60 min (PO)",
            halfLife: "2-8 hrs",
            duration: "4-8 hrs",
            absorbtion: "Complete (oral)",
            distribution: "Widely distributed, crosses BBB",
            metaBolism: "Liver (CYP2D6)",
            excretion: "Urine",
            pregnancyExplanation: "Category B. Generally considered safe in pregnancy. Commonly used for nausea in pregnancy (often with pyridoxine).",
            criticalPearls: "##How to use diphenhydramine safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Assess age (avoid or use low doses in elderly)\n"
            + "• Check for BPH (urinary retention risk)\n"
            + "• Consider if patient is on other sedating medications\n\n"
            + "##Diphenhydramine in Anaphylaxis:##\n\n"
            + "EPINEPHRINE IS FIRST-LINE FOR ANAPHYLAXIS!\n\n"
            + "Diphenhydramine is adjunctive only:\n\n"
            + "• Epinephrine treats bronchospasm, hypotension, airway edema\n"
            + "• Diphenhydramine only helps with urticaria and pruritus\n"
            + "• Never give diphenhydramine INSTEAD of epinephrine\n"
            + "• Give diphenhydramine 50 mg IV AFTER epinephrine\n\n"
            + "##Diphenhydramine for Dystonia:##\n\n"
            + "Drug-induced dystonia (from haloperidol, metoclopramide, prochlorperazine):\n\n"
            + "• Dose: 25-50 mg IV\n"
            + "• Response usually within minutes\n"
            + "• Continue oral diphenhydramine for 48-72 hours (prevents recurrence)\n"
            + "• Alternative: Benztropine 1-2 mg IV/IM\n\n"
            + "##Signs of dystonia:##\n\n"
            + "• Torticollis (head turned to one side)\n"
            + "• Oculogyric crisis (eyes rolled up)\n"
            + "• Opisthotonus (arching back)\n"
            + "• Tongue protrusion, difficulty speaking\n\n"
            + "##Anticholinergic toxicity:##\n\n"
            + "Mnemonic: ##Hot as a hare, blind as a bat, dry as a bone, red as a beet, mad as a hatter##\n\n"
            + "• Hyperthermia (no sweating)\n"
            + "• Mydriasis (dilated pupils)\n"
            + "• Dry mucous membranes\n"
            + "• Flushed skin\n"
            + "• Delirium, hallucinations\n"
            + "• Urinary retention\n"
            + "• Tachycardia\n\n"
            + "##Treatment:## Physostigmine (cholinesterase inhibitor) in severe cases\n\n"
            + "##Paradoxical excitation in children:##\n\n"
            + "• Some children become hyperactive and agitated instead of sedated\n"
            + "• More common in young children\n"
            + "• If occurs, use alternative antihistamine\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving diphenhydramine instead of epinephrine for anaphylaxis\n"
            + "• Using in elderly without considering anticholinergic burden\n"
            + "• Not continuing oral medication after treating dystonia (recurrence)\n"
            + "• Not expecting paradoxical excitation in children\n\n"
            + "##The takeaway:##\n\n"
            + "##Diphenhydramine is## a first-generation antihistamine for allergic reactions, anaphylaxis (adjunct), and dystonia. Give 25-50 mg IV/IM/PO. For anaphylaxis, epinephrine is FIRST — diphenhydramine is only adjunctive. For dystonia, give 50 mg IV, then continue oral for 48-72 hours. Avoid or reduce dose in elderly (anticholinergic toxicity). Watch for paradoxical excitation in children."
        ),
        
        // 17. Dopamine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Dopamine",
            brandName: "Intropin ®",
            mechansim: "Dopamine is a dose-dependent catecholamine that hits different receptors depending on how much you give.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of dopamine as the unpredictable pressor — it changes its personality based on the dose. Low doses hit dopamine receptors (renal vasodilation), medium doses hit beta-1 (cardiac stimulation), and high doses hit alpha (vasoconstriction). The problem is that these dose ranges overlap and vary between patients.\n\n"
            + "##Dose-dependent effects:##\n\n"
            + "##Low dose (2-5 mcg/kg/min):##\n\n"
            + "• Dopaminergic receptors → Renal and mesenteric vasodilation\n"
            + "• Historically used for \"renal protection\" (doesn't actually work)\n\n"
            + "##Medium dose (5-10 mcg/kg/min):##\n\n"
            + "• Beta-1 receptors → Increases heart rate and contractility\n"
            + "• Increases cardiac output\n\n"
            + "##High dose (10-20 mcg/kg/min):##\n\n"
            + "• Alpha receptors → Vasoconstriction\n"
            + "• Acts more like norepinephrine\n\n"
            + "##The key:## Dopamine is unpredictable. The dose-response varies between patients, and it causes more arrhythmias than norepinephrine. That's why norepinephrine has replaced dopamine as the first-line vasopressor in most protocols.\n\n"
            + "##High-yield point:## The SOAP II trial showed that dopamine causes more arrhythmias and possibly higher mortality compared to norepinephrine in septic shock. Norepinephrine is now preferred. Low-dose \"renal-dose\" dopamine doesn't protect kidneys — that's outdated dogma.",
            adverseEffects: "##Common:##\n\n"
            + "• Tachycardia (dose-dependent)\n"
            + "• Arrhythmias (atrial fib, V-tach, PVCs)\n"
            + "• Hypertension (at high doses)\n"
            + "• Increased myocardial oxygen demand\n\n"
            + "##Serious:##\n\n"
            + "• Life-threatening arrhythmias (V-tach, V-fib)\n"
            + "• Myocardial ischemia (especially in CAD patients)\n"
            + "• Tissue necrosis (extravasation injury)\n"
            + "• Gangrene (with prolonged high-dose use)\n\n"
            + "##Why dopamine causes more arrhythmias:##\n\n"
            + "Dopamine triggers more catecholamine release than norepinephrine, which increases the risk of atrial and ventricular arrhythmias. This is especially problematic in septic shock patients who are already at high risk.\n\n"
            + "##Red flags:##\n\n"
            + "• New atrial fibrillation or frequent PVCs → Consider switching to norepinephrine\n"
            + "• Worsening tachycardia (HR >120) → Reduce dose or switch agents\n"
            + "• Signs of ischemia (chest pain, ST changes) → Stop dopamine immediately\n"
            + "• Extravasation → Stop infusion, infiltrate phentolamine",
            dose: "##Initial dose:##\n\n"
            + "• 2-5 mcg/kg/min IV infusion\n\n"
            + "##Titration:##\n\n"
            + "• Increase by 2-5 mcg/kg/min every 5-10 minutes\n"
            + "• Target: MAP ≥65 mmHg or desired hemodynamic effect\n\n"
            + "##Typical dosing ranges:##\n\n"
            + "• Low dose: 2-5 mcg/kg/min (dopaminergic effects)\n"
            + "• Medium dose: 5-10 mcg/kg/min (beta-1 effects)\n"
            + "• High dose: 10-20 mcg/kg/min (alpha effects)\n"
            + "• Max: 20 mcg/kg/min (higher doses rarely add benefit)\n\n"
            + "##Administration:##\n\n"
            + "• Requires central line preferred (peripheral OK temporarily)\n"
            + "• Standard concentration: 400-800 mg in 250 mL\n"
            + "• Must calculate dose based on patient weight\n"
            + "• Taper gradually when discontinuing",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Sympathomimetic, catecholamine, dose-dependent vasopressor/inotrope.\n\n"
            + "Largely replaced by norepinephrine in modern sepsis protocols due to higher arrhythmia risk.",
            indications: "##Primary indications:##\n\n"
            + "• Symptomatic bradycardia unresponsive to atropine (second-line)\n"
            + "• Cardiogenic shock (alternative to dobutamine)\n"
            + "• Hypotension (though norepinephrine is preferred)\n\n"
            + "##Historical uses (now outdated):##\n\n"
            + "• Low-dose \"renal protection\" (doesn't work — avoid)\n"
            + "• First-line for septic shock (norepinephrine is better)\n\n"
            + "##You might still reach for dopamine when:##\n\n"
            + "• Bradycardic hypotension unresponsive to atropine\n"
            + "• Cardiogenic shock with need for both inotropy and chronotropy\n"
            + "• Local protocol still uses it (though most have switched to norepinephrine)\n\n"
            + "##Classic scenario:## Post-cardiac arrest patient with persistent bradycardia (HR 45) and hypotension despite atropine → Dopamine 5-10 mcg/kg/min to increase heart rate and blood pressure.",
            contraindiction: "##Absolute:##\n\n"
            + "• Pheochromocytoma (unless alpha-blocked)\n"
            + "• Tachydysrhythmias (atrial fib, V-tach)\n"
            + "• Ventricular fibrillation\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Coronary artery disease (increases O₂ demand)\n"
            + "• Recent myocardial infarction\n"
            + "• Hypovolemia (fill the tank first)\n"
            + "• Concurrent MAO inhibitor use (can cause hypertensive crisis)\n\n"
            + "##Critical safety point:## Dopamine should not be used as first-line for septic shock. Norepinephrine is safer and more effective (SOAP II trial). If you're starting a pressor for sepsis, choose norepinephrine.",
            onSet: "2-5 min",
            halfLife: "2 min",
            duration: "< 10 min",
            absorbtion: "Complete (IV only)",
            distribution: "Widely",
            metaBolism: "Liver, kidney, plasma (MAO, COMT)",
            excretion: "Urine",
            pregnancyExplanation: "Category C. Use with caution in pregnancy. Generally safe for short-term use in maternal hypotension.",
            criticalPearls: "##How to use dopamine safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Ensure adequate volume resuscitation\n"
            + "• Establish central access if possible\n"
            + "• Calculate dose based on actual body weight\n"
            + "• Check for contraindications (especially arrhythmias)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor heart rate and rhythm continuously (arrhythmias are common)\n"
            + "• Watch for new atrial fib, PVCs, or V-tach\n"
            + "• Titrate to MAP goal, but watch for tachycardia\n"
            + "• If HR >120 or new arrhythmias → Consider switching to norepinephrine\n\n"
            + "##When to switch to norepinephrine:##\n\n"
            + "• New or worsening arrhythmias\n"
            + "• Excessive tachycardia (HR >120-130)\n"
            + "• Not achieving MAP goals despite high doses\n"
            + "• Patient has coronary artery disease\n\n"
            + "##The \"renal-dose dopamine\" myth:##\n\n"
            + "Low-dose dopamine (2-5 mcg/kg/min) was historically used for \"renal protection\" in critically ill patients. Multiple studies have shown this doesn't work. It doesn't prevent acute kidney injury, doesn't improve renal function, and doesn't reduce the need for dialysis. Don't use dopamine for renal protection.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using dopamine as first-line for septic shock (use norepinephrine instead)\n"
            + "• Continuing dopamine despite arrhythmias (switch to norepinephrine)\n"
            + "• Using \"renal-dose\" dopamine for kidney protection (doesn't work)\n"
            + "• Not calculating dose based on weight (leads to over/underdosing)\n\n"
            + "##The takeaway:##\n\n"
            + "Dopamine is the unpredictable pressor — dose-dependent effects, high arrhythmia risk, and largely replaced by norepinephrine in modern protocols. It still has a role in bradycardic hypotension and some cases of cardiogenic shock, but it's no longer first-line for sepsis. If you use it, watch the heart rate and rhythm closely, and be ready to switch to norepinephrine."
        ),
        
        // 17a. Vasopressin
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Vasopressin",
            brandName: "Pitressin",
            mechansim: "Vasopressin is a synthetic form of antidiuretic hormone (ADH) that works by stimulating V1 receptors on vascular smooth muscle.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of vasopressin as the non-catecholamine pressor. Unlike norepinephrine, dopamine, and epinephrine, it doesn't work through adrenergic receptors. It directly causes vasoconstriction through a completely different pathway.\n\n"
            + "##How it works:##\n\n"
            + "• Stimulates V1 receptors → Activates phospholipase C → Increases intracellular calcium\n"
            + "• Causes direct vasoconstriction of vascular smooth muscle\n"
            + "• No effect on heart rate or contractility (no chronotropy or inotropy)\n"
            + "• Works even when catecholamine receptors are downregulated\n\n"
            + "##The key:## Vasopressin is used as an adjunct to norepinephrine in septic shock, not as a first-line agent. It's particularly useful when norepinephrine doses are high (>20 mcg/min) because it works through a different mechanism and can help reduce catecholamine requirements.\n\n"
            + "##High-yield point:## In septic shock, endogenous vasopressin levels are paradoxically low. Giving exogenous vasopressin can restore vascular tone through a non-adrenergic pathway. The VASST trial showed vasopressin is safe as an adjunct but doesn't improve mortality compared to norepinephrine alone.",
            adverseEffects: "##Common:##\n\n"
            + "• Ischemia (fingers, toes, gut, kidneys)\n"
            + "• Bradycardia (reflex from increased SVR)\n"
            + "• Decreased cardiac output\n\n"
            + "##Serious:##\n\n"
            + "• Mesenteric ischemia (abdominal pain, rising lactate)\n"
            + "• Cardiac ischemia (chest pain, ST changes)\n"
            + "• Skin necrosis\n"
            + "• Water intoxication/hyponatremia (at high doses)\n\n"
            + "##The ischemia risk:##\n\n"
            + "Vasopressin is a potent vasoconstrictor. It can cause peripheral, mesenteric, and cardiac ischemia. Watch for cold, mottled extremities, abdominal pain, or rising lactate despite adequate MAP.\n\n"
            + "##Red flags:##\n\n"
            + "• New abdominal pain or rising lactate → Mesenteric ischemia\n"
            + "• Bradycardia with hypotension → May need to stop vasopressin\n"
            + "• Worsening peripheral mottling → Reduce or stop\n"
            + "• Chest pain or ST changes → Cardiac ischemia",
            dose: "##Septic shock (adjunct to norepinephrine):##\n\n"
            + "• Fixed dose: 0.03-0.04 units/min IV infusion\n"
            + "• DO NOT titrate (use fixed dose)\n"
            + "• Add when norepinephrine >15-20 mcg/min\n"
            + "• Goal: Reduce norepinephrine requirements\n\n"
            + "##Cardiac arrest (NOTE: REMOVED from AHA 2020 ACLS algorithm):##\n\n"
            + "• 40 units IV push was previously used as alternative to epinephrine\n"
            + "• AHA 2020 guidelines removed vasopressin from cardiac arrest protocol\n"
            + "• Epinephrine is the only vasopressor recommended in ACLS cardiac arrest\n\n"
            + "##Post-cardiac arrest shock:##\n\n"
            + "• 0.03-0.04 units/min IV infusion\n"
            + "• Use as adjunct to norepinephrine\n\n"
            + "##Administration:##\n\n"
            + "• Requires central line preferred\n"
            + "• Standard concentration: 20-40 units in 100 mL\n"
            + "• Give as continuous infusion\n"
            + "• DO NOT give boluses (except in cardiac arrest)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Synthetic vasopressin (ADH analog), non-catecholamine vasopressor.\n\n"
            + "Used as adjunct to norepinephrine in refractory septic shock.",
            indications: "##Primary indications:##\n\n"
            + "• Septic shock (adjunct to norepinephrine when dose >15-20 mcg/min)\n"
            + "• Refractory hypotension despite high-dose catecholamines\n"
            + "• Post-cardiac arrest shock\n"
            + "• Cardiac arrest (alternative to epinephrine)\n\n"
            + "##You'll reach for vasopressin when:##\n\n"
            + "• Norepinephrine dose is >20 mcg/min and still hypotensive\n"
            + "• Patient is on multiple catecholamines (add vasopressin to reduce catecholamine load)\n"
            + "• Refractory shock with suspected adrenergic receptor downregulation\n\n"
            + "##Classic scenario:## Septic patient on norepinephrine 25 mcg/min, MAP 58, lactate 4.0 → Add vasopressin 0.04 units/min to augment BP through non-adrenergic pathway.",
            contraindiction: "##Absolute:##\n\n"
            + "• None in life-threatening shock\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Coronary artery disease (can cause cardiac ischemia)\n"
            + "• Peripheral vascular disease\n"
            + "• Mesenteric ischemia (can worsen)\n"
            + "• Chronic kidney disease\n\n"
            + "##Critical safety point:## Vasopressin is a powerful vasoconstrictor. Always use it as an adjunct to norepinephrine, not as monotherapy. Monitor closely for ischemia.",
            onSet: "Immediate (within minutes)",
            halfLife: "10-20 min",
            duration: "30-60 min",
            absorbtion: "IV only",
            distribution: "Widely distributed",
            metaBolism: "Liver, kidney (vasopressinases)",
            excretion: "Urine",
            pregnancyExplanation: "Category C. Use with caution in pregnancy. Generally safe for maternal shock states.",
            criticalPearls: "##How to use vasopressin safely:##\n\n"
            + "##When to add vasopressin:##\n\n"
            + "• Norepinephrine dose >15-20 mcg/min\n"
            + "• Patient still hypotensive despite adequate fluids\n"
            + "• Consider earlier if on multiple catecholamines\n\n"
            + "##Dosing:##\n\n"
            + "• Fixed dose: 0.03-0.04 units/min\n"
            + "• DO NOT titrate up or down\n"
            + "• This is a \"fixed-dose adjunct\" strategy\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor for ischemia (fingers, toes, gut)\n"
            + "• Titrate norepinephrine down as vasopressin takes effect\n"
            + "• Goal: Reduce catecholamine requirements, not eliminate them\n"
            + "• Watch for new abdominal pain (mesenteric ischemia)\n\n"
            + "##The VASST trial findings:##\n\n"
            + "Vasopressin vs. norepinephrine in septic shock:\n"
            + "• No difference in mortality overall\n"
            + "• May reduce mortality in less severe shock\n"
            + "• Safe when used at low doses (0.03-0.04 units/min)\n"
            + "• Higher doses (>0.04 units/min) increase ischemia risk without benefit\n\n"
            + "##Common mistakes:##\n\n"
            + "• Titrating vasopressin (it should be fixed dose)\n"
            + "• Using vasopressin as first-line (it's an adjunct to norepinephrine)\n"
            + "• Using doses >0.04 units/min (increases ischemia risk)\n"
            + "• Not monitoring for ischemia\n\n"
            + "##The takeaway:##\n\n"
            + "Vasopressin is the non-catecholamine pressor that works through a different pathway. Add it at a fixed dose (0.03-0.04 units/min) when norepinephrine is >15-20 mcg/min. It can help reduce catecholamine requirements through a different mechanism. Watch closely for ischemia, and remember: it's an adjunct, not a replacement for norepinephrine."
        ),
        
        // 17b. Phenylephrine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Phenylephrine",
            brandName: "Neo-Synephrine",
            mechansim: "Phenylephrine is a pure alpha-1 adrenergic agonist that causes vasoconstriction.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of phenylephrine as the pure vasoconstrictor — all squeeze, no squeeze pump. It raises blood pressure by tightening blood vessels without any effect on the heart itself. This makes it predictable but also means it can cause reflex bradycardia.\n\n"
            + "##How it works:##\n\n"
            + "• Stimulates alpha-1 receptors on vascular smooth muscle → Vasoconstriction\n"
            + "• Increases systemic vascular resistance (SVR)\n"
            + "• Raises blood pressure\n"
            + "• NO beta-1 activity → No increase in heart rate or contractility\n"
            + "• Reflex bradycardia common (baroreceptor response to increased BP)\n\n"
            + "##The key:## Phenylephrine is useful when you want to raise blood pressure without increasing heart rate. It's commonly used in the OR for anesthesia-induced hypotension and in patients who can't tolerate tachycardia (recent MI, aortic stenosis).\n\n"
            + "##High-yield point:## Phenylephrine causes reflex bradycardia — the sudden increase in blood pressure triggers baroreceptors, which slow the heart rate. This is why it's preferred in tachycardic patients who need a pressor.",
            adverseEffects: "##Common:##\n\n"
            + "• Reflex bradycardia (baroreceptor response)\n"
            + "• Hypertension (excessive vasoconstriction)\n"
            + "• Decreased cardiac output (from increased afterload)\n\n"
            + "##Serious:##\n\n"
            + "• Severe bradycardia (HR <40)\n"
            + "• Tissue ischemia (fingers, toes, organs)\n"
            + "• Extravasation injury → Tissue necrosis\n"
            + "• Pulmonary edema (from increased afterload in heart failure)\n\n"
            + "##The reflex bradycardia:##\n\n"
            + "When phenylephrine raises BP suddenly, baroreceptors sense the increase and slow the heart rate. This is usually mild but can be severe in some patients.\n\n"
            + "##Red flags:##\n\n"
            + "• Heart rate drops to <50 despite adequate BP\n"
            + "• New chest pain or ST changes (myocardial ischemia from increased afterload)\n"
            + "• Worsening heart failure symptoms (phenylephrine increases afterload)",
            dose: "##Push-dose pressor (peri-intubation/anesthesia):##\n\n"
            + "• 50-200 mcg IV push\n"
            + "• Mix 100 mcg in 10 mL (10 mcg/mL)\n"
            + "• Give 0.5-2 mL for acute hypotension\n"
            + "• Onset: 1-2 minutes\n"
            + "• Duration: 15-20 minutes\n\n"
            + "##Continuous infusion (ICU):##\n\n"
            + "• 0.5-3 mcg/kg/min IV\n"
            + "• Start at 0.5 mcg/kg/min\n"
            + "• Titrate to MAP goal\n"
            + "• Typical range: 40-180 mcg/min for average adult\n\n"
            + "##Administration:##\n\n"
            + "• Can give via peripheral or central line\n"
            + "• For push-dose: Give slowly over 1-2 minutes\n"
            + "• For infusion: Standard concentration varies by institution\n"
            + "• Always have atropine ready for severe bradycardia",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Pure alpha-1 adrenergic agonist, vasopressor.\n\n"
            + "Commonly used for acute hypotension during anesthesia and procedures.",
            indications: "##Primary indications:##\n\n"
            + "• Anesthesia-induced hypotension (most common use)\n"
            + "• Peri-intubation hypotension (push-dose pressor)\n"
            + "• Hypotension with tachycardia (need to avoid increasing HR)\n"
            + "• Shock states where tachycardia is undesirable\n\n"
            + "##You'll reach for phenylephrine when:##\n\n"
            + "• Patient drops BP after induction and you don't want to increase HR\n"
            + "• Tachycardic patient needs blood pressure support\n"
            + "• Recent MI patient with hypotension (avoid tachycardia)\n"
            + "• Aortic stenosis patient with hypotension (maintain preload, avoid tachycardia)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Patient's BP drops to 80/50 after propofol induction → Phenylephrine 100 mcg IV push\n"
            + "• Septic patient with HR 140, BP 75/40 → Phenylephrine infusion (avoid making tachycardia worse)\n"
            + "• Post-MI patient with BP 85/50, HR 110 → Phenylephrine (don't want to increase HR)",
            contraindiction: "##Absolute:##\n\n"
            + "• Severe bradycardia (HR <50 without pacemaker)\n"
            + "• Heart block (2nd or 3rd degree)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Heart failure with reduced ejection fraction (increases afterload)\n"
            + "• Severe aortic stenosis (though sometimes still used)\n"
            + "• Hypertrophic cardiomyopathy\n"
            + "• Peripheral vascular disease\n\n"
            + "##Critical safety point:## Phenylephrine increases afterload significantly. In patients with poor cardiac function, this can reduce cardiac output despite raising blood pressure. Use cautiously in heart failure.",
            onSet: "1-2 min (IV push), immediate (infusion)",
            halfLife: "2-3 hours",
            duration: "15-20 min (IV push), ongoing (infusion)",
            absorbtion: "IV only (oral has low bioavailability)",
            distribution: "Widely distributed",
            metaBolism: "Liver, intestinal wall (MAO, sulfotransferase)",
            excretion: "Urine",
            pregnancyExplanation: "Category C. Use with caution in pregnancy. Generally safe for short-term use in maternal hypotension.",
            criticalPearls: "##How to use phenylephrine safely:##\n\n"
            + "##For push-dose pressor:##\n\n"
            + "• Mix 1 mL of 100 mcg/mL phenylephrine in 10 mL saline (makes 10 mcg/mL)\n"
            + "• Give 0.5-2 mL (50-200 mcg) slowly\n"
            + "• Wait 2-3 minutes to assess effect\n"
            + "• Expect heart rate to drop 5-10 beats\n\n"
            + "##For continuous infusion:##\n\n"
            + "• Start low (0.5 mcg/kg/min)\n"
            + "• Titrate to MAP goal\n"
            + "• Watch heart rate closely\n"
            + "• If HR drops significantly → Consider switching to norepinephrine\n\n"
            + "##When phenylephrine is ideal:##\n\n"
            + "• Anesthesia-induced hypotension (very common)\n"
            + "• Tachycardic patient needs pressor support\n"
            + "• Short-term hypotension during procedures\n"
            + "• Patient with good cardiac function\n\n"
            + "##When to avoid phenylephrine:##\n\n"
            + "• Heart failure with low EF (increases afterload, decreases CO)\n"
            + "• Already bradycardic\n"
            + "• Need both inotropy and vasoconstriction\n\n"
            + "##Phenylephrine vs. Norepinephrine:##\n\n"
            + "##Phenylephrine:##\n"
            + "• Pure alpha (vasoconstriction only)\n"
            + "• Causes reflex bradycardia\n"
            + "• Good for short-term hypotension\n"
            + "• Can decrease cardiac output\n\n"
            + "##Norepinephrine:##\n"
            + "• Alpha + beta-1 (vasoconstriction + inotropy)\n"
            + "• Minimal effect on heart rate\n"
            + "• Better for septic shock\n"
            + "• Maintains cardiac output better\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using phenylephrine in heart failure (increases afterload, worsens CO)\n"
            + "• Not expecting reflex bradycardia\n"
            + "• Using phenylephrine long-term when norepinephrine is better\n"
            + "• Giving too much too fast (can cause severe bradycardia)\n\n"
            + "##The takeaway:##\n\n"
            + "Phenylephrine is the pure vasoconstrictor — it raises BP without affecting the heart directly. It's perfect for anesthesia-induced hypotension and tachycardic patients who need pressor support. Expect reflex bradycardia, and use cautiously in heart failure. For most ICU shock states, norepinephrine is a better choice."
        ),
        
        // 17c. Dobutamine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Dobutamine",
            brandName: "Dobutrex",
            mechansim: "Dobutamine is a synthetic catecholamine that primarily stimulates beta-1 adrenergic receptors.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of dobutamine as the heart squeezer — it makes the heart contract harder and faster without much effect on blood vessels. Unlike pressors that raise blood pressure by vasoconstriction, dobutamine improves cardiac output by increasing contractility.\n\n"
            + "##How it works:##\n\n"
            + "• Stimulates beta-1 receptors → Increases contractility (inotropy)\n"
            + "• Increases heart rate (chronotropy) at higher doses\n"
            + "• Mild beta-2 effects → Slight vasodilation\n"
            + "• Net effect: Increased cardiac output, may slightly decrease SVR\n"
            + "• Blood pressure may stay the same, increase, or even decrease slightly\n\n"
            + "##The key:## Dobutamine is for pump failure, not pipe failure. Use it when the heart isn't squeezing well (low cardiac output), not when blood vessels are dilated (distributive shock). It's the drug of choice for cardiogenic shock.\n\n"
            + "##High-yield point:## Dobutamine can paradoxically lower blood pressure in some patients because it causes vasodilation (beta-2 effects). If BP drops, you may need to add a vasopressor (norepinephrine) while continuing the dobutamine.",
            adverseEffects: "##Common:##\n\n"
            + "• Tachycardia (dose-dependent)\n"
            + "• Arrhythmias (PVCs, atrial fib, V-tach)\n"
            + "• Hypotension (from beta-2 vasodilation)\n"
            + "• Increased myocardial oxygen demand\n\n"
            + "##Serious:##\n\n"
            + "• Myocardial ischemia (increased O₂ demand)\n"
            + "• Life-threatening arrhythmias (V-tach, V-fib)\n"
            + "• Severe hypotension (may need concurrent vasopressor)\n"
            + "• Worsening heart failure (in patients with ischemia)\n\n"
            + "##The tachycardia problem:##\n\n"
            + "Dobutamine increases heart rate, which increases myocardial oxygen demand. In patients with coronary artery disease, this can precipitate ischemia. Watch for chest pain, ST changes, or new arrhythmias.\n\n"
            + "##Red flags:##\n\n"
            + "• Heart rate >120 (excessive tachycardia, reduce dose)\n"
            + "• New chest pain or ST changes (myocardial ischemia)\n"
            + "• Frequent PVCs or runs of V-tach (stop dobutamine)\n"
            + "• Hypotension worsens (add norepinephrine for BP support)",
            dose: "##Cardiogenic shock:##\n\n"
            + "• Start: 2.5-5 mcg/kg/min IV infusion\n"
            + "• Titrate: Increase by 2.5 mcg/kg/min every 15-30 minutes\n"
            + "• Target: Improved cardiac output, better perfusion\n"
            + "• Typical range: 2.5-20 mcg/kg/min\n"
            + "• Max: 20 mcg/kg/min (higher doses increase arrhythmia risk)\n\n"
            + "##Heart failure exacerbation:##\n\n"
            + "• Low-dose inotropic support: 2.5-10 mcg/kg/min\n"
            + "• Short-term bridge (days, not weeks)\n\n"
            + "##Stress echocardiography:##\n\n"
            + "• Incremental doses up to 40 mcg/kg/min\n"
            + "• Used to detect inducible ischemia\n\n"
            + "##Administration:##\n\n"
            + "• Requires central line preferred (can use large peripheral)\n"
            + "• Standard concentration: 250-1000 mg in 250 mL\n"
            + "• Calculate dose based on actual body weight\n"
            + "• Taper gradually when discontinuing (don't stop abruptly)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Synthetic catecholamine, beta-1 selective inotrope.\n\n"
            + "First-line inotrope for cardiogenic shock and acute decompensated heart failure.",
            indications: "##Primary indications:##\n\n"
            + "• Cardiogenic shock (low cardiac output)\n"
            + "• Acute decompensated heart failure with low cardiac output\n"
            + "• Post-cardiac surgery (temporary inotropic support)\n"
            + "• Bridge to transplant or LVAD\n"
            + "• Stress echocardiography (diagnostic)\n\n"
            + "##You'll reach for dobutamine when:##\n\n"
            + "• Patient has signs of low cardiac output (cold extremities, elevated lactate, low urine output)\n"
            + "• Echo shows reduced ejection fraction with poor contractility\n"
            + "• Patient is in cardiogenic shock despite fluid resuscitation\n"
            + "• Heart failure patient needs temporary bridge to definitive therapy\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Post-MI patient with BP 85/50, cold extremities, EF 20% → Dobutamine (and possibly norepinephrine for BP)\n"
            + "• Heart failure patient with pulmonary edema and low cardiac output → Dobutamine to improve forward flow\n"
            + "• Post-cardiac surgery patient with low CO despite adequate preload → Dobutamine for inotropic support",
            contraindiction: "##Absolute:##\n\n"
            + "• Hypertrophic obstructive cardiomyopathy (HOCM)\n"
            + "• Idiopathic hypertrophic subaortic stenosis (IHSS)\n"
            + "• Severe aortic stenosis\n"
            + "• Pheochromocytoma (unless alpha-blocked)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Recent myocardial infarction (increases O₂ demand)\n"
            + "• Atrial fibrillation with rapid rate (dobutamine can worsen)\n"
            + "• Ventricular arrhythmias\n"
            + "• Severe hypovolemia (fill the tank first)\n\n"
            + "##Critical safety point:## Dobutamine is for pump failure (cardiogenic shock), not pipe failure (distributive shock). If you give dobutamine to a septic patient with normal cardiac function, you'll just cause tachycardia and hypotension without benefit.",
            onSet: "1-2 minutes",
            halfLife: "2-3 minutes",
            duration: "Few minutes after stopping",
            absorbtion: "IV only",
            distribution: "Widely distributed",
            metaBolism: "Liver (COMT, MAO), tissues",
            excretion: "Urine (metabolites)",
            pregnancyExplanation: "Category B. Generally safe for short-term use in pregnancy when maternal cardiac output needs support.",
            criticalPearls: "##How to use dobutamine safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Ensure adequate preload (patient should be euvolemic)\n"
            + "• Get baseline echo to confirm low EF and poor contractility\n"
            + "• Check for coronary artery disease (dobutamine increases O₂ demand)\n"
            + "• Have norepinephrine ready in case BP drops\n\n"
            + "##While it's running:##\n\n"
            + "• Start low (2.5-5 mcg/kg/min) and titrate slowly\n"
            + "• Monitor heart rate closely (goal HR <120)\n"
            + "• Watch for arrhythmias on telemetry\n"
            + "• Follow cardiac output, lactate, urine output (signs of improved perfusion)\n"
            + "• If BP drops → Add norepinephrine (don't stop dobutamine)\n\n"
            + "##When to add norepinephrine:##\n\n"
            + "Many patients need both:\n"
            + "• Dobutamine for inotropy (make the heart squeeze better)\n"
            + "• Norepinephrine for vasoconstriction (maintain BP)\n\n"
            + "This combination is common in cardiogenic shock.\n\n"
            + "##Dobutamine vs. Other inotropes:##\n\n"
            + "##Dobutamine:##\n"
            + "• Pure inotrope (increases contractility)\n"
            + "• May lower BP (vasodilation)\n"
            + "• First-line for cardiogenic shock\n\n"
            + "##Milrinone:##\n"
            + "• Inotrope + vasodilator\n"
            + "• More vasodilation than dobutamine\n"
            + "• Used when dobutamine isn't working\n\n"
            + "##Epinephrine:##\n"
            + "• Inotrope + vasoconstriction\n"
            + "• Raises BP better than dobutamine\n"
            + "• More arrhythmogenic\n\n"
            + "##Norepinephrine:##\n"
            + "• Mainly vasoconstriction, some inotropy\n"
            + "• Better for septic shock\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using dobutamine in septic shock (wrong indication)\n"
            + "• Starting too high (should start at 2.5-5 mcg/kg/min)\n"
            + "• Not adding norepinephrine when BP drops\n"
            + "• Continuing dobutamine despite frequent arrhythmias\n"
            + "• Using dobutamine in hypovolemic patient (give fluids first)\n\n"
            + "##The takeaway:##\n\n"
            + "Dobutamine is the heart squeezer for pump failure — it increases contractility and cardiac output, making it the first-line inotrope for cardiogenic shock. Start low, watch for tachycardia and arrhythmias, and be ready to add norepinephrine if blood pressure drops. Remember: dobutamine is for weak hearts (low EF), not dilated blood vessels (sepsis)."
        ),
        
        // 18. Epinephrine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Epinephrine",
            brandName: "Adrenaline ®",
            mechansim: "Epinephrine is the body's emergency override system. It hits all adrenergic receptors — alpha, beta-1, and beta-2.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of epinephrine as hitting three targets simultaneously:\n\n"
            + "##Alpha-1 effects:##\n\n"
            + "• Vasoconstriction → Increases SVR and blood pressure\n"
            + "• Shunts blood from periphery to vital organs\n\n"
            + "##Beta-1 effects:##\n\n"
            + "• Increases heart rate (chronotropy)\n"
            + "• Increases contractility (inotropy)\n"
            + "• Increases cardiac output\n\n"
            + "##Beta-2 effects:##\n\n"
            + "• Bronchodilation → Opens airways\n"
            + "• Stabilizes mast cells → Stops histamine release\n\n"
            + "##The key:## The dose determines the effect. Low doses favor beta effects (bronchodilation, inotropy), high doses favor alpha effects (vasoconstriction). This is why anaphylaxis gets IM epi 0.3-0.5 mg, but cardiac arrest gets IV epi 1 mg.\n\n"
            + "##High-yield point:## Epinephrine is the ONLY drug proven to improve survival in cardiac arrest. It's also first-line for anaphylaxis — give IM into the lateral thigh, NOT IV unless coding.",
            adverseEffects: "##Common:##\n\n"
            + "• Tachycardia, palpitations\n"
            + "• Hypertension (can be severe)\n"
            + "• Tremors, anxiety, restlessness\n\n"
            + "##Serious:##\n\n"
            + "• Ventricular arrhythmias (V-tach, V-fib)\n"
            + "• Myocardial ischemia (increased O₂ demand)\n"
            + "• Pulmonary edema (from increased afterload)\n"
            + "• Extravasation injury → Tissue necrosis\n"
            + "• Cerebral hemorrhage (from extreme hypertension)\n\n"
            + "##Antidote for extravasation:## Phentolamine 5-10 mg in 10 mL NS, infiltrate around site.",
            dose: "##Cardiac arrest:##\n\n"
            + "• 1 mg IV/IO every 3-5 minutes\n"
            + "• Continue throughout resuscitation\n\n"
            + "##Anaphylaxis:##\n\n"
            + "• 0.3-0.5 mg IM (0.3-0.5 mL of 1:1000 solution)\n"
            + "• Lateral thigh (vastus lateralis)\n"
            + "• Repeat q5-15min if needed\n"
            + "• Pediatric: 0.01 mg/kg IM (max 0.3 mg)\n\n"
            + "##Infusion (ICU vasopressor):##\n\n"
            + "• 2-10 mcg/min IV (titrate to effect)\n"
            + "• Requires central line\n\n"
            + "##Push-dose pressor:##\n\n"
            + "• 5-20 mcg IV push (for peri-intubation hypotension)\n"
            + "• Mix 1 mL of 1:10,000 in 9 mL NS = 10 mcg/mL",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Catecholamine, sympathomimetic, vasopressor, inotrope, bronchodilator.\n\n"
            + "The most versatile emergency drug — used in cardiac arrest, anaphylaxis, and severe refractory shock.",
            indications: "##Primary indications:##\n\n"
            + "• Cardiac arrest (V-fib, pulseless V-tach, PEA, asystole)\n"
            + "• Anaphylaxis (first-line, life-saving)\n"
            + "• Severe asthma/bronchospasm unresponsive to albuterol\n"
            + "• Refractory bradycardia (after atropine)\n"
            + "• Croup (racemic epinephrine)\n\n"
            + "##Less common/ICU uses:##\n\n"
            + "• Vasopressor in refractory shock\n"
            + "• Post-cardiac arrest hypotension\n"
            + "• Severe septic shock not responding to norepinephrine\n"
            + "• Push-dose pressor for peri-intubation hypotension\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Patient with hives, stridor, hypotension after bee sting → IM epi 0.3 mg immediately\n"
            + "• Pulseless arrest → 1 mg IV every 3-5 min during CPR\n"
            + "• Severe asthma, not moving air, declining despite albuterol → Consider IV/IM epi",
            contraindiction: "There are NO absolute contraindications in cardiac arrest or anaphylaxis.\n\n"
            + "##Relative contraindications (for non-emergency use):##\n\n"
            + "• Coronary artery disease (increases O₂ demand)\n"
            + "• Uncontrolled hypertension\n"
            + "• Tachyarrhythmias\n"
            + "• Pheochromocytoma\n"
            + "• Hyperthyroidism\n\n"
            + "##Critical safety point:## In anaphylaxis, there is NO contraindication to epinephrine. Delay kills. Give IM immediately.",
            onSet: "IV: immediate. IM: 5-10 minutes.",
            halfLife: "2-3 minutes (plasma elimination). Rapidly metabolized by MAO and COMT.",
            duration: "1-4 hrs",
            absorbtion: "Well absorbed",
            distribution: "Crosses placenta",
            metaBolism: "Hepatic",
            excretion: "Urine",
            pregnancyExplanation: "Safe in pregnancy for life-threatening indications. Benefits far outweigh risks in anaphylaxis or cardiac arrest.",
            criticalPearls: "##How to use epinephrine safely:##\n\n"
            + "##For anaphylaxis:##\n\n"
            + "• Give IM into lateral thigh immediately (do NOT delay)\n"
            + "• Use 1:1000 concentration (1 mg/mL)\n"
            + "• Repeat every 5-15 minutes if needed\n"
            + "• Most deaths from anaphylaxis are from delayed or no epinephrine\n"
            + "• Do NOT give IV unless patient is coding\n\n"
            + "##For cardiac arrest:##\n\n"
            + "• 1 mg IV/IO every 3-5 minutes\n"
            + "• Give throughout the entire resuscitation\n"
            + "• No maximum dose\n"
            + "• High-dose epi (>1 mg) does NOT improve outcomes\n\n"
            + "##For push-dose pressor:##\n\n"
            + "• Only use in monitored setting\n"
            + "• Draw up carefully (dosing errors are common)\n"
            + "• Flush well after each dose\n"
            + "• Duration is brief (~5-10 minutes)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using wrong concentration (1:1000 vs 1:10,000)\n"
            + "• Giving IV instead of IM for anaphylaxis\n"
            + "• Delaying epi in anaphylaxis while giving Benadryl/steroids first\n"
            + "• Using subcutaneous route (absorption too slow)\n\n"
            + "##Watch for:##\n\n"
            + "• Severe hypertension (can cause stroke)\n"
            + "• Arrhythmias (especially with repeated doses)\n"
            + "• Pulmonary edema after resuscitation\n\n"
            + "##The takeaway:##\n\n"
            + "Epinephrine saves lives in two critical scenarios: cardiac arrest and anaphylaxis. In anaphylaxis, give IM immediately — don't hesitate, don't delay, don't use IV. In cardiac arrest, give 1 mg IV every 3-5 minutes throughout CPR. Know your concentrations, use the right route, and remember: this drug has no substitute."
        ),
        
        // 19. Eptifibatide
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Eptifibatide",
            brandName: "Integrilin ®",
            mechansim: "Eptifibatide is a glycoprotein IIb/IIIa inhibitor that blocks the final common pathway of platelet aggregation.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of eptifibatide as the platelet glue blocker. GP IIb/IIIa is the receptor that allows platelets to bind to each other via fibrinogen — the final step in platelet aggregation. By blocking this receptor, eptifibatide prevents clots from forming, making it a potent antiplatelet agent for acute coronary syndromes and PCI.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks glycoprotein IIb/IIIa receptor on platelets\n"
            + "• Prevents fibrinogen binding between platelets\n"
            + "• Blocks the final common pathway of platelet aggregation\n"
            + "• Reversible inhibition (clears in 4-8 hours after stopping)\n\n"
            + "##The key:## GP IIb/IIIa inhibitors like eptifibatide are used in high-risk ACS and PCI to prevent acute thrombosis. They're potent — expect increased bleeding risk. Reduce dose in renal impairment.\n\n"
            + "##High-yield point:## Eptifibatide is renally cleared. Reduce dose if CrCl <50 mL/min. Contraindicated if CrCl <10 mL/min or on dialysis. If bleeding occurs, stop the infusion — platelet transfusion can partially reverse the effect.",
            adverseEffects: "##Common:##\n\n"
            + "• Bleeding (most common — access sites, GI, GU)\n"
            + "• Minor bleeding (15-20%)\n\n"
            + "##Serious:##\n\n"
            + "• Major bleeding (4-10%)\n"
            + "• Thrombocytopenia (rare, 0.5-1%)\n"
            + "• Intracranial hemorrhage (rare, 0.1%)\n\n"
            + "##The bleeding problem:##\n\n"
            + "##GP IIb/IIIa## inhibitors cause significant bleeding risk. Risk factors include:\n\n"
            + "• Elderly, female, low body weight\n"
            + "• Renal impairment\n"
            + "• Recent surgery or trauma\n"
            + "• Concurrent anticoagulation\n\n"
            + "##Red flags:##\n\n"
            + "• Access site hematoma (apply pressure)\n"
            + "• Drop in hemoglobin (check for occult bleeding)\n"
            + "• Platelet count drop (check for thrombocytopenia)\n"
            + "• Neurologic changes (intracranial hemorrhage)",
            dose: "##Acute Coronary Syndrome:##\n\n"
            + "• Bolus: 180 mcg/kg IV\n"
            + "• Infusion: 2 mcg/kg/min IV for up to 72 hours\n"
            + "• Continue through PCI and 12-24 hours after\n\n"
            + "##PCI only:##\n\n"
            + "• Bolus: 180 mcg/kg IV at PCI start\n"
            + "• Second bolus: 180 mcg/kg 10 minutes after first\n"
            + "• Infusion: 2 mcg/kg/min for 12-24 hours\n\n"
            + "##Renal dosing:##\n\n"
            + "• CrCl 30-50: Reduce infusion to 1 mcg/kg/min\n"
            + "• CrCl <30: Avoid (or consult specialist)\n"
            + "• Dialysis: Contraindicated\n\n"
            + "##Administration:##\n\n"
            + "• Give IV bolus then continuous infusion\n"
            + "• Monitor platelet count\n"
            + "• Watch for bleeding",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Glycoprotein IIb/IIIa inhibitor.\n\n"
            + "Potent antiplatelet agent for ACS and PCI.",
            indications: "##Primary indications:##\n\n"
            + "• Acute coronary syndrome (NSTEMI, unstable angina)\n"
            + "• Percutaneous coronary intervention (PCI)\n\n"
            + "##You'll reach for eptifibatide when:##\n\n"
            + "• High-risk ACS planned for invasive management\n"
            + "• PCI in high-risk patient (thrombus, large lesion)\n"
            + "• Bail-out during complicated PCI\n\n"
            + "##Classic scenarios:##\n\n"
            + "• NSTEMI with positive troponins, planned for cardiac cath → Eptifibatide bolus + infusion\n"
            + "• PCI with visible thrombus → Eptifibatide to prevent acute stent thrombosis\n"
            + "• Complication during PCI (no-reflow, dissection) → Eptifibatide as bail-out",
            contraindiction: "##Absolute:##\n\n"
            + "• Active internal bleeding or recent (within 30 days) significant bleeding\n"
            + "• History of hemorrhagic stroke\n"
            + "• Ischemic stroke within 2 years\n"
            + "• Severe uncontrolled hypertension (>200/110)\n"
            + "• Major surgery or trauma within 6 weeks\n"
            + "• Dialysis-dependent renal failure\n"
            + "• Thrombocytopenia (<100,000)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Renal impairment (reduce dose)\n"
            + "• Recent minor surgery\n"
            + "• Concurrent anticoagulation\n\n"
            + "##Critical safety point:## Eptifibatide significantly increases bleeding risk. Before starting, ensure no active bleeding, check platelet count, and verify no recent stroke or major surgery.",
            onSet: "Immediate (platelet inhibition within minutes)",
            halfLife: "2.5 hrs",
            duration: "4-8 hrs after stopping infusion",
            absorbtion: "N/A (IV only)",
            distribution: "Plasma",
            metaBolism: "Minimal (excreted largely unchanged)",
            excretion: "Urine (50% unchanged)",
            pregnancyExplanation: "Category B. Use in pregnancy only if benefits clearly outweigh risks (significant bleeding risk).",
            criticalPearls: "##How to use eptifibatide safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check platelet count (hold if <100,000)\n"
            + "• Check creatinine (reduce dose if CrCl <50)\n"
            + "• Rule out active bleeding and recent stroke/surgery\n"
            + "• Check for severe hypertension (control first)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor access sites for bleeding\n"
            + "• Check hemoglobin and hematocrit\n"
            + "• Repeat platelet count (acute thrombocytopenia can occur)\n"
            + "• Monitor for signs of major bleeding\n\n"
            + "##Reversal if bleeding:##\n\n"
            + "##Eptifibatide has## a short half-life (2.5 hrs), so:\n\n"
            + "• Stop the infusion immediately\n"
            + "• Platelet function recovers in 4-8 hours\n"
            + "• For severe bleeding: Platelet transfusion (can partially restore function)\n"
            + "• No specific antidote\n\n"
            + "##Renal dosing is critical:##\n\n"
            + "##Eptifibatide is## renally cleared:\n\n"
            + "• Normal: 2 mcg/kg/min infusion\n"
            + "• CrCl 30-50: 1 mcg/kg/min infusion\n"
            + "• CrCl <30: Generally avoid\n"
            + "• Dialysis: Contraindicated\n\n"
            + "##Not accounting for renal function is a common cause of bleeding.\n\n"
            + "##Eptifibatide vs. other GP IIb/IIIa inhibitors:##\n\n"
            + "##Eptifibatide (Integrilin):##\n\n"
            + "• Synthetic peptide\n"
            + "• Reversible (short duration)\n"
            + "• Renally cleared (adjust for renal function)\n\n"
            + "##Abciximab (ReoPro):##\n\n"
            + "• Monoclonal antibody\n"
            + "• Irreversible (long duration — 48-72 hrs)\n"
            + "• Not renally cleared\n"
            + "• Higher thrombocytopenia risk\n\n"
            + "##Tirofiban (Aggrastat):##\n\n"
            + "• Non-peptide small molecule\n"
            + "• Reversible (similar to eptifibatide)\n"
            + "• Renally cleared\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not reducing dose in renal impairment (bleeding)\n"
            + "• Using in patients with recent stroke (contraindicated)\n"
            + "• Not checking platelet count before and during infusion\n"
            + "• Continuing infusion when bleeding develops\n\n"
            + "##The takeaway:##\n\n"
            + "##Eptifibatide is## a GP IIb/IIIa inhibitor that blocks platelet aggregation for high-risk ACS and PCI. Give 180 mcg/kg bolus, then 2 mcg/kg/min infusion. Reduce infusion to 1 mcg/kg/min if CrCl <50. Watch for bleeding — if it occurs, stop infusion (platelet function returns in 4-8 hours). Platelet transfusion can help in severe bleeding."
        ),
        
        // 20. Etomidate
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Etomidate",
            brandName: "Amidate ®",
            mechansim: "Etomidate is a hypnotic sedative that works by enhancing GABA-A receptor activity in the brain.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of etomidate as the hemodynamically neutral induction agent. It puts patients to sleep fast without dropping their blood pressure or affecting their heart rate. This makes it the go-to choice for hypotensive or hemodynamically unstable patients who need intubation.\n\n"
            + "##How it works:##\n\n"
            + "• Enhances GABA-A receptor activity → Increases chloride influx → Hyperpolarizes neurons\n"
            + "• Produces rapid sedation and unconsciousness\n"
            + "• Minimal effect on cardiovascular system (no drop in BP or HR)\n"
            + "• No analgesic properties (doesn't treat pain)\n\n"
            + "##The key:## Etomidate is the most hemodynamically stable induction agent. It doesn't cause hypotension like propofol or tachycardia/hypertension like ketamine. But it has one major downside: it temporarily suppresses adrenal function, which is why many centers avoid it in septic shock.\n\n"
            + "##High-yield point:## Etomidate causes transient adrenal suppression (blocks 11-β-hydroxylase) lasting 24-48 hours. Some studies suggest this may worsen outcomes in septic shock patients. Because of this, many centers now prefer ketamine for RSI in sepsis.",
            adverseEffects: "##Common:##\n\n"
            + "• Myoclonus (involuntary muscle jerks)\n"
            + "• Pain on injection\n"
            + "• Transient adrenal suppression (24-48 hours)\n"
            + "• Nausea and vomiting (mild)\n\n"
            + "##Serious:##\n\n"
            + "• Adrenal insufficiency (with repeated doses or continuous infusion)\n"
            + "• Hypotension (rare, but can happen)\n\n"
            + "##The adrenal suppression issue:##\n\n"
            + "Etomidate blocks cortisol synthesis for 24-48 hours after a single dose. In healthy patients, this doesn't matter. But in septic shock patients who may already have relative adrenal insufficiency, this could theoretically worsen outcomes.\n\n"
            + "##The evidence## is mixed:\n"
            + "• Some studies show worse outcomes in septic patients\n"
            + "• Other studies show no difference\n"
            + "• Single-dose etomidate is probably safe, but many centers avoid it in sepsis\n\n"
            + "##The myoclonus:##\n\n"
            + "These are involuntary muscle jerks that look like seizures but aren't. They're harmless and stop once the paralytic is given. Some providers pre-treat with fentanyl or a defasciculating dose of a paralytic to reduce myoclonus.\n\n"
            + "##Red flags:##\n\n"
            + "• Hypotension despite etomidate → Severe hypovolemia or cardiac dysfunction (give fluids/pressors)\n"
            + "• Using etomidate for procedural sedation (NO — causes nausea and adrenal suppression without benefit)",
            dose: "##RSI (induction):##\n\n"
            + "• 0.3 mg/kg IV push (typical adult: 20-30 mg)\n"
            + "• Onset: 10-20 seconds\n"
            + "• Duration: 4-10 minutes\n\n"
            + "##Pediatric RSI:##\n\n"
            + "• 0.3 mg/kg IV push (same as adults)\n\n"
            + "##Administration:##\n\n"
            + "• Give as rapid IV push\n"
            + "• Can cause pain on injection (give into large vein)\n"
            + "• Never use as continuous infusion (causes prolonged adrenal suppression)\n\n"
            + "##Important:##\n\n"
            + "Etomidate is ONLY for induction during RSI. It should never be used for:\n"
            + "• Procedural sedation (causes nausea, no analgesia)\n"
            + "• Continuous infusion (prolonged adrenal suppression)\n"
            + "• Repeated doses in same patient within 24 hours",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Sedative-hypnotic, GABA-A agonist, imidazole derivative.\n\n"
            + "The most hemodynamically stable induction agent for RSI.",
            indications: "##Primary indication:##\n\n"
            + "• RSI induction in hemodynamically unstable patients\n\n"
            + "##You'll reach for etomidate when:##\n\n"
            + "• Patient needs intubation and is hypotensive (BP <90 systolic)\n"
            + "• Patient has borderline hemodynamics and you can't afford a drop in BP\n"
            + "• Patient has severe cardiac dysfunction (low EF, cardiogenic shock)\n"
            + "• You want to preserve hemodynamics during induction\n\n"
            + "##When to choose something else:##\n\n"
            + "• Septic shock → Many centers prefer ketamine (avoids adrenal suppression)\n"
            + "• Hypotensive but need bronchodilation → Ketamine (also raises BP)\n"
            + "• Hemodynamically stable → Propofol (smoother, no adrenal effects)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Trauma patient with BP 85/50, needs intubation → Etomidate 20 mg IV (preserves BP)\n"
            + "• GI bleed patient with BP 92/60, altered mental status → Etomidate (won't drop BP further)\n"
            + "• Cardiogenic shock patient with EF 15%, needs intubation → Etomidate (safest hemodynamically)",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity to etomidate\n"
            + "• Adrenal insufficiency (relative, but avoid if known)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Septic shock (many centers avoid due to adrenal suppression concerns)\n"
            + "• Known or suspected adrenal insufficiency\n"
            + "• Don't use for repeated dosing or continuous infusion\n\n"
            + "##Critical safety point:## Etomidate should only be used for single-dose RSI induction. Never use it for procedural sedation, continuous infusion, or repeated doses. The adrenal suppression from repeated doses can be severe and prolonged.",
            onSet: "10-20 sec",
            halfLife: "75 min",
            duration: "4-10 min",
            absorbtion: "N/A (IV only)",
            distribution: "Rapid (highly lipophilic)",
            metaBolism: "Liver and plasma esterases",
            excretion: "Urine (75%)",
            pregnancyExplanation: "Category C. Use with caution in pregnancy. Generally considered safe for short-term use during RSI.",
            criticalPearls: "##How to use etomidate safely:##\n\n"
            + "##For RSI:##\n\n"
            + "• Calculate dose: 0.3 mg/kg (typical adult 20-30 mg)\n"
            + "• Give as rapid IV push\n"
            + "• Expect myoclonus (muscle jerks) — this is normal\n"
            + "• Give paralytic immediately after patient loses consciousness\n"
            + "• Blood pressure should remain stable\n\n"
            + "##The adrenal suppression debate:##\n\n"
            + "Etomidate temporarily blocks cortisol production for 24-48 hours. Does this matter?\n\n"
            + "• In healthy trauma patients: Probably not\n"
            + "• In septic shock patients: Maybe (evidence is mixed)\n"
            + "• In patients already on stress-dose steroids: Probably not\n\n"
            + "Many centers have moved away from etomidate in sepsis and now use ketamine instead. Check your local protocols.\n\n"
            + "##Etomidate vs. Ketamine vs. Propofol:##\n\n"
            + "##Etomidate:##\n"
            + "• Best for: Hemodynamically unstable (non-septic)\n"
            + "• Pros: No drop in BP, fast onset\n"
            + "• Cons: Adrenal suppression, myoclonus\n\n"
            + "##Ketamine:##\n"
            + "• Best for: Hypotensive, septic, or bronchospastic\n"
            + "• Pros: Raises BP, bronchodilation, no adrenal effects\n"
            + "• Cons: Emergence reactions, contraindicated in severe HTN\n\n"
            + "##Propofol:##\n"
            + "• Best for: Hemodynamically stable\n"
            + "• Pros: Smooth induction, short duration\n"
            + "• Cons: Drops BP significantly\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using etomidate for procedural sedation (causes nausea, no analgesia)\n"
            + "• Giving repeated doses or continuous infusion (prolonged adrenal suppression)\n"
            + "• Worrying about myoclonus (it's harmless, stops with paralytic)\n"
            + "• Using etomidate in septic shock without considering ketamine as alternative\n\n"
            + "##The takeaway:##\n\n"
            + "Etomidate is the most hemodynamically stable induction agent for RSI. It doesn't drop blood pressure, making it ideal for unstable trauma patients and those with cardiac dysfunction. The adrenal suppression issue is real but probably overstated — a single dose is likely safe even in sepsis. That said, many centers now prefer ketamine for septic shock to avoid any theoretical risk."
        ),
        
        // 21. Fentanyl
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Fentanyl Citrate",
            brandName: "Sublimaze ®",
            mechansim: "Fentanyl is a synthetic opioid that works by binding to μ (mu) opioid receptors in the brain and spinal cord.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of fentanyl as the fast-acting, powerful pain killer that doesn't mess with blood pressure. It's 50-100 times more potent than morphine, but it's much shorter-acting and cleaner hemodynamically.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to μ-opioid receptors → Blocks pain signals\n"
            + "• CNS depression → Sedation and respiratory depression\n"
            + "• No histamine release → Minimal hypotension (unlike morphine)\n\n"
            + "##The key:## Fentanyl is lipophilic, so it crosses the blood-brain barrier rapidly. That's why onset is so fast (1-2 minutes), but it also redistributes quickly into fat and muscle, which is why the effect wears off in 30-60 minutes.\n\n"
            + "##High-yield point:## Fentanyl doesn't release histamine, so it's the preferred opioid in hemodynamically unstable patients. It's also the go-to for RSI premedication because it blunts the sympathetic response to laryngoscopy without dropping the blood pressure.",
            adverseEffects: "##Common:##\n\n"
            + "• Respiratory depression (dose-dependent)\n"
            + "• Sedation, drowsiness\n"
            + "• Nausea, vomiting\n"
            + "• Bradycardia (vagal stimulation)\n\n"
            + "##Serious:##\n\n"
            + "• Chest wall rigidity (\"wooden chest syndrome\")\n"
            + "• Apnea (especially with rapid IV push)\n"
            + "• Severe respiratory depression\n"
            + "• Hypotension (less common than morphine)\n\n"
            + "##Chest wall rigidity:##\n\n"
            + "This is the big scary one. It happens when you give high doses (>5 mcg/kg) too fast. The chest and abdominal muscles get rigid, and you can't ventilate the patient — even with a bag.\n\n"
            + "• Prevent it: Give fentanyl slowly (over 1-2 minutes)\n"
            + "• Treat it: Naloxone reverses it, but paralysis (succinylcholine or rocuronium) is faster if you need to intubate immediately\n\n"
            + "##Red flags:##\n\n"
            + "• Apnea or severe respiratory depression → Support ventilation, consider naloxone\n"
            + "• Rigid chest wall → Can't bag → Paralyze and intubate immediately",
            dose: "##Analgesia (moderate pain):##\n\n"
            + "• 0.5-1 mcg/kg IV slow push\n"
            + "• Onset: 1-2 minutes\n"
            + "• Repeat q30-60min as needed\n\n"
            + "##RSI premedication (blunt sympathetic response):##\n\n"
            + "• 2-3 mcg/kg IV (give 3 minutes before induction)\n"
            + "• Reduces tachycardia and hypertension from laryngoscopy\n\n"
            + "##Procedural sedation:##\n\n"
            + "• 1-2 mcg/kg IV\n"
            + "• Combine with a benzodiazepine or propofol\n\n"
            + "##ICU analgesia/sedation infusion:##\n\n"
            + "• Loading dose: 25-50 mcg IV\n"
            + "• Infusion: 25-200 mcg/hr (titrate to effect)\n\n"
            + "##Pediatric:##\n\n"
            + "• 1-2 mcg/kg IV (same as adults)\n\n"
            + "##Administration:##\n\n"
            + "• Always give slow IV push (over 1-2 minutes)\n"
            + "• Have naloxone and bag-mask ready\n"
            + "• Monitor respiratory rate and oxygen saturation",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Synthetic opioid analgesic, μ-receptor agonist.\n\n"
            + "One of the most commonly used opioids in critical care and procedural sedation.",
            indications: "##Primary indications:##\n\n"
            + "• Acute pain management (trauma, post-op, procedures)\n"
            + "• RSI premedication (blunt sympathetic response to laryngoscopy)\n"
            + "• Procedural sedation (combined with sedatives)\n"
            + "• ICU analgesia and sedation\n"
            + "• Acute coronary syndrome (pain control)\n\n"
            + "##You'll reach for fentanyl when:##\n\n"
            + "• Patient needs analgesia but has borderline blood pressure (hemodynamically unstable)\n"
            + "• You're about to intubate and want to blunt the sympathetic surge\n"
            + "• Patient needs fast pain relief for a procedure\n"
            + "• Patient has a morphine allergy or gets too hypotensive with morphine\n\n"
            + "##Classic scenario:## Trauma patient with femur fracture, BP 100/60, in severe pain → Fentanyl 50-100 mcg IV (not morphine, which would drop the BP further).",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity to fentanyl\n"
            + "• Acute respiratory depression or severe asthma (relative)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• COPD or baseline respiratory compromise\n"
            + "• Head injury with altered mental status (can mask neuro exam)\n"
            + "• Elderly or frail patients (increased sensitivity)\n"
            + "• Concurrent use of other CNS depressants (benzos, alcohol)\n\n"
            + "##Critical safety point:## Always have bag-mask ventilation and naloxone immediately available. Fentanyl can cause apnea faster than you think, especially in opioid-naive patients.",
            onSet: "1-2 min",
            halfLife: "2-4 hr",
            duration: "30-60 min",
            absorbtion: "Well absorbed",
            distribution: "Lipophilic (rapid CNS penetration, redistributes to fat/muscle)",
            metaBolism: "Liver (CYP3A4)",
            excretion: "Urine",
            pregnancyExplanation: "Category C. Use with caution in pregnancy. Safe for short-term use in labor and delivery, but prolonged use can cause neonatal withdrawal.",
            criticalPearls: "##How to use fentanyl safely:##\n\n"
            + "##Before giving:##\n\n"
            + "• Assess respiratory status (rate, effort, oxygen saturation)\n"
            + "• Have bag-mask and naloxone at bedside\n"
            + "• Ask about other CNS depressants (benzos, alcohol)\n"
            + "• Reduce dose in elderly, frail, or opioid-naive patients\n\n"
            + "##During administration:##\n\n"
            + "• Give slowly (over 1-2 minutes) to prevent chest wall rigidity\n"
            + "• Monitor respiratory rate and SpO₂ continuously\n"
            + "• Have someone ready to bag if apnea occurs\n\n"
            + "##After giving:##\n\n"
            + "• Watch for respiratory depression (peaks at 5-10 minutes)\n"
            + "• If respiratory rate <8 or apnea → Stimulate patient, bag if needed, give naloxone if severe\n"
            + "• Effect lasts 30-60 minutes, but patient may need repeat dosing\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving too fast → Chest wall rigidity, apnea\n"
            + "• Not having naloxone ready\n"
            + "• Combining with benzos without reducing doses (synergistic respiratory depression)\n"
            + "• Forgetting that fentanyl wears off quickly (patient's pain returns in 30-60 min)\n\n"
            + "##The takeaway:##\n\n"
            + "Fentanyl is the clean, fast-acting opioid for acute pain — perfect for unstable patients because it doesn't drop blood pressure like morphine. Give it slow, watch the breathing, and keep naloxone close. It's powerful, short-acting, and safe when used correctly."
        ),
        
        // 22. Fosphenytoin
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Fosphenytoin Sodium",
            brandName: "Cerebyx ®",
            mechansim: "Fosphenytoin is a water-soluble prodrug of phenytoin that is rapidly converted to phenytoin after IV/IM administration.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of fosphenytoin as phenytoin without the problems. Phenytoin is highly alkaline (pH 12) and causes severe phlebitis and tissue necrosis. Fosphenytoin is water-soluble and neutral pH, so it can be given faster, causes less pain, and can even be given IM. It's converted to phenytoin within minutes.\n\n"
            + "##How it works:##\n\n"
            + "• Prodrug: Rapidly converted to phenytoin by plasma phosphatases\n"
            + "• Conversion time: 7-15 minutes (IV), slightly longer (IM)\n"
            + "• Phenytoin then stabilizes neuronal membranes by blocking voltage-gated sodium channels\n"
            + "• Reduces repetitive neuronal firing without affecting normal activity\n\n"
            + "##The key:## Fosphenytoin is dosed in \"PE\" (phenytoin equivalents) — 1.5 mg of fosphenytoin = 1 mg of phenytoin (PE). Always dose in PE to avoid confusion. Can infuse at 150 mg PE/min (vs. phenytoin max 50 mg/min).\n\n"
            + "##High-yield point:## Fosphenytoin can be given IM (phenytoin cannot). This is useful when IV access is difficult. Use fosphenytoin if giving phenytoin causes severe pain or phlebitis.",
            adverseEffects: "##Common:##\n\n"
            + "• Paresthesias (especially groin area — from phosphate metabolite)\n"
            + "• Pruritus (during infusion)\n"
            + "• Nystagmus, dizziness\n"
            + "• Somnolence\n\n"
            + "##Serious (from phenytoin after conversion):##\n\n"
            + "• Hypotension (with rapid infusion)\n"
            + "• Bradycardia, arrhythmias\n"
            + "• Purple glove syndrome (less common than phenytoin)\n"
            + "• Stevens-Johnson syndrome (rare)\n\n"
            + "##The paresthesia problem:##\n\n"
            + "Fosphenytoin causes paresthesias during infusion (tingling, burning, especially in groin and face). This is from the phosphate metabolite, not phenytoin. It's temporary and harmless but can be uncomfortable. Slow the infusion if severe.\n\n"
            + "##Red flags:##\n\n"
            + "• Hypotension during infusion (slow rate or stop)\n"
            + "• Bradycardia <50 (stop infusion)\n"
            + "• QRS widening >50% (phenytoin toxicity)",
            dose: "##Status Epilepticus (loading dose):##\n\n"
            + "• 20 mg PE/kg IV\n"
            + "• Max infusion rate: 150 mg PE/min\n"
            + "• (Compare to phenytoin: max 50 mg/min)\n\n"
            + "##Seizure Prophylaxis/Maintenance:##\n\n"
            + "• 4-6 mg PE/kg/day divided q8-12h\n\n"
            + "##IM dosing (when IV unavailable):##\n\n"
            + "• Same dose as IV\n"
            + "• Split large volumes between two sites\n\n"
            + "##Administration:##\n\n"
            + "• Monitor BP, HR, ECG during infusion\n"
            + "• Have resuscitation equipment available\n"
            + "• Slow rate if hypotension or paresthesias",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.D),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.D),
            DrugClass: "Anticonvulsant (hydantoin prodrug).\n\n"
            + "Water-soluble prodrug of phenytoin. Can be given faster and IM.",
            indications: "##Primary indications:##\n\n"
            + "• Status epilepticus (second-line after benzodiazepines)\n"
            + "• Seizure prophylaxis (TBI, post-neurosurgery)\n"
            + "• Replacement for oral phenytoin when NPO\n\n"
            + "##You'll reach for fosphenytoin when:##\n\n"
            + "• Status epilepticus not controlled by benzos → Load fosphenytoin or levetiracetam\n"
            + "• Need IV phenytoin but patient has poor veins or history of phlebitis\n"
            + "• Need IM loading when IV unavailable\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Status epilepticus, lorazepam given → Fosphenytoin 20 mg PE/kg IV at 150 mg PE/min\n"
            + "• Patient on oral phenytoin, now NPO for surgery → Convert to IV fosphenytoin\n"
            + "• Seizures in field, no IV access → Fosphenytoin IM",
            contraindiction: "##Absolute:##\n\n"
            + "• Sinus bradycardia\n"
            + "• 2nd or 3rd degree AV block\n"
            + "• Sinoatrial block\n"
            + "• Adams-Stokes syndrome\n"
            + "• Known hypersensitivity to hydantoins\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Hypotension (risk of further drop)\n"
            + "• Myocardial insufficiency\n"
            + "• Acute intermittent porphyria\n\n"
            + "##Critical safety point:## Monitor ECG and blood pressure during fosphenytoin infusion. Hypotension and bradycardia are dose-related. Stop infusion if significant cardiovascular effects occur.",
            onSet: "7-15 min (conversion to phenytoin)",
            halfLife: "12-29 hrs (phenytoin half-life)",
            duration: "24+ hrs",
            absorbtion: "Complete (IV and IM)",
            distribution: "Widely distributed, high CSF penetration",
            metaBolism: "Converted to phenytoin by phosphatases, then liver (CYP2C9, CYP2C19)",
            excretion: "Urine (as phenytoin metabolites)",
            pregnancyExplanation: "Category D. Phenytoin causes fetal hydantoin syndrome (craniofacial abnormalities, hypoplasia of digits, developmental delay). Use only if benefits outweigh risks and no safer alternative exists.",
            criticalPearls: "##How to use fosphenytoin safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check for heart block, bradycardia (contraindicated)\n"
            + "• Have continuous ECG monitoring ready\n"
            + "• Have resuscitation equipment available\n"
            + "• Calculate dose in PE (phenytoin equivalents)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor BP and HR continuously\n"
            + "• Watch for paresthesias (common, temporary)\n"
            + "• If hypotension → Slow rate or stop\n"
            + "• If bradycardia <50 → Stop infusion\n\n"
            + "##Fosphenytoin vs. Phenytoin:##\n\n"
            + "##Fosphenytoin advantages:##\n\n"
            + "• Faster infusion (150 mg PE/min vs 50 mg/min)\n"
            + "• Less phlebitis and tissue necrosis\n"
            + "• Can be given IM\n"
            + "• Neutral pH (phenytoin is pH 12)\n\n"
            + "##Phenytoin advantages:##\n\n"
            + "• Cheaper\n"
            + "• Immediate phenytoin levels (no conversion time)\n"
            + "• More familiar to some clinicians\n\n"
            + "##PE Dosing:##\n\n"
            + "##Fosphenytoin is## dosed in phenytoin equivalents (PE):\n\n"
            + "• 1.5 mg fosphenytoin = 1 mg phenytoin (1 mg PE)\n"
            + "• Loading dose: 20 mg PE/kg\n"
            + "• Example: 70 kg patient = 1400 mg PE = 2100 mg fosphenytoin\n\n"
            + "##Always prescribe and order in PE to avoid confusion.##\n\n"
            + "##Fosphenytoin vs. Levetiracetam in status epilepticus:##\n\n"
            + "Both are second-line after benzodiazepines. Current evidence suggests similar efficacy.\n\n"
            + "##Fosphenytoin/Phenytoin:##\n\n"
            + "• More cardiovascular side effects\n"
            + "• Requires level monitoring\n"
            + "• Many drug interactions\n"
            + "• Longer track record in status epilepticus\n\n"
            + "##Levetiracetam:##\n\n"
            + "• Fewer cardiovascular effects\n"
            + "• Minimal drug interactions\n"
            + "• No level monitoring needed\n"
            + "• May cause behavioral changes (Keppra rage)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Confusing mg with PE (leads to under/overdosing)\n"
            + "• Infusing too fast without cardiac monitoring\n"
            + "• Not stopping for hypotension or bradycardia\n"
            + "• Using in patients with heart block\n\n"
            + "##The takeaway:##\n\n"
            + "##Fosphenytoin is## a water-soluble prodrug of phenytoin that can be given faster (150 mg PE/min) and causes less phlebitis. Always dose in PE (phenytoin equivalents). Monitor ECG and BP during infusion. Stop if hypotension or bradycardia. Can be given IM when IV unavailable. Second-line for status epilepticus after benzodiazepines."
        ),
        
        // 23. Furosemide
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Furosemide",
            brandName: "Lasix ®",
            mechansim: "Furosemide is a loop diuretic that inhibits the Na⁺-K⁺-2Cl⁻ cotransporter in the thick ascending loop of Henle.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of furosemide as the powerful diuretic that pulls fluid off fast — it blocks sodium reabsorption in the loop of Henle, causing massive sodium and water loss. The trade-off: you lose potassium, magnesium, and calcium too.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks Na⁺-K⁺-2Cl⁻ cotransporter in the ascending loop of Henle\n"
            + "• Prevents sodium and chloride reabsorption\n"
            + "• Massive diuresis (can lose liters of fluid)\n"
            + "• Also venodilates (reduces preload before diuresis kicks in)\n\n"
            + "##Key concept:## Furosemide causes significant electrolyte wasting — hypokalemia, hypomagnesemia, hypocalcemia, and metabolic alkalosis. Always monitor electrolytes, especially potassium.\n\n"
            + "##High-yield point:## Furosemide has a ceiling dose (max 80-100 mg IV bolus) — beyond this, you don't get more diuresis, just more side effects. If 80 mg doesn't work, consider an infusion (5-10 mg/hr) or switch to bumetanide (more potent).",
            adverseEffects: "##Common:##\n\n"
            + "• Hypokalemia (most common)\n"
            + "• Hypomagnesemia\n"
            + "• Hypocalcemia\n"
            + "• Metabolic alkalosis\n"
            + "• Dehydration\n"
            + "• Hypotension\n\n"
            + "##Serious:##\n\n"
            + "• Ototoxicity (hearing loss) — especially with rapid IV push >20 mg/min or high doses\n"
            + "• Severe dehydration and prerenal AKI\n"
            + "• Hypokalemia → Arrhythmias\n"
            + "• Severe hyponatremia\n\n"
            + "##Ototoxicity:##\n\n"
            + "Rapid IV push or high doses can cause permanent hearing loss. The mechanism is damage to the hair cells in the cochlea.\n\n"
            + "##How to avoid:##\n\n"
            + "• Push slowly (max 20 mg/min)\n"
            + "• For doses >40 mg, push over 10-20 minutes\n"
            + "• Use continuous infusion for high doses (5-10 mg/hr)\n\n"
            + "##Red flags:##\n\n"
            + "• K⁺ <3.0 mEq/L → Arrhythmia risk, replace potassium before giving more furosemide\n"
            + "• Patient reports hearing loss or tinnitus → Ototoxicity, stop furosemide\n"
            + "• Creatinine rising despite diuresis → Prerenal AKI from overdiuresis",
            dose: "##Acute Pulmonary Edema:##\n\n"
            + "• 40 mg IV push (or double the patient's home oral dose)\n"
            + "• If no response in 30-60 min, double the dose (80 mg, then 160 mg)\n"
            + "• Max bolus: 80-100 mg (beyond this, use infusion)\n\n"
            + "##Continuous Infusion (for refractory edema):##\n\n"
            + "• Loading dose: 20-40 mg IV bolus\n"
            + "• Infusion: 5-10 mg/hr IV\n"
            + "• Titrate to urine output\n\n"
            + "##Chronic CHF/Volume Overload:##\n\n"
            + "• 20-80 mg IV/PO daily or BID\n"
            + "• Titrate based on response\n\n"
            + "##Renal Dosing:##\n\n"
            + "• CrCl <20 mL/min: Higher doses needed (80-160 mg) due to reduced tubular secretion\n"
            + "• May need continuous infusion\n\n"
            + "##Administration:##\n\n"
            + "• IV push: ≤20 mg/min\n"
            + "• For doses >40 mg, push over 10-20 minutes\n"
            + "• Onset: 5-10 min (IV), 30-60 min (PO)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "##Loop diuretic.##\n\n"
            + "The most commonly used diuretic for acute volume overload and pulmonary edema.",
            indications: "##Standard Indications:##\n\n"
            + "• Acute pulmonary edema\n"
            + "• Congestive heart failure (CHF)\n"
            + "• Volume overload (renal, hepatic, cardiac)\n"
            + "• Hypertensive emergency (adjunct)\n"
            + "• Hypercalcemia (with saline)\n\n"
            + "##When to reach for furosemide:##\n\n"
            + "• Patient is in acute pulmonary edema (crackles, hypoxia, JVD)\n"
            + "• CHF exacerbation with volume overload\n"
            + "• Patient needs rapid diuresis\n"
            + "• Oliguric renal failure with fluid overload\n\n"
            + "##Clinical clues:## Hypoxia, crackles, JVD, peripheral edema, weight gain, positive fluid balance.",
            contraindiction: "##Absolute:##\n\n"
            + "• Anuria (no urine output — diuretics won't work)\n"
            + "• Severe hypovolemia or dehydration\n\n"
            + "##Caution:##\n\n"
            + "• Sulfa allergy (furosemide contains sulfonamide moiety — usually safe, but caution in severe allergy)\n"
            + "• Hypokalemia (replace potassium first)\n"
            + "• Concurrent ototoxic drugs (aminoglycosides)\n"
            + "• Severe hepatic cirrhosis (can precipitate hepatic encephalopathy)\n\n"
            + "##Important:## Diuretics don't work in anuria. If the patient has no urine output, furosemide won't help — address the underlying cause of anuria first.",
            onSet: "5-10 min (IV); 30-60 min (PO)",
            halfLife: "30-60 minutes",
            duration: "2 hours (IV); 6-8 hours (PO)",
            absorbtion: "60-67% oral bioavailability",
            distribution: "Crosses placenta, highly protein-bound (>98%)",
            metaBolism: "Minimal hepatic metabolism",
            excretion: "Renal (65% unchanged)\n\n"
            + "##Reduced tubular secretion in renal failure → Need higher doses##",
            pregnancyExplanation: "##Pregnancy Category C:## Crosses the placenta. Can cause fetal diuresis. Use only if benefits outweigh risks.",
            criticalPearls: "##Ototoxicity Risk##\n\n"
            + "• ##Push slowly## (≤20 mg/min) to avoid hearing loss\n"
            + "• For doses >40 mg, push over 10-20 minutes\n"
            + "• Permanent hearing loss can occur with rapid IV push or high doses\n\n"
            + "##Sulfa Allergy##\n\n"
            + "• Contains sulfonamide moiety\n"
            + "• Usually safe in mild sulfa allergy\n"
            + "• Caution in severe sulfa allergy (anaphylaxis) — consider bumetanide or ethacrynic acid\n\n"
            + "##Ceiling Dose##\n\n"
            + "• Max bolus: 80-100 mg\n"
            + "• Beyond this, you don't get more diuresis — just more side effects\n"
            + "• If not working, consider continuous infusion (5-10 mg/hr) or switch to bumetanide\n\n"
            + "##Electrolyte Wasting:##\n\n"
            + "• Hypokalemia (most common) → Arrhythmias\n"
            + "• Hypomagnesemia → Also causes arrhythmias\n"
            + "• Hypocalcemia\n"
            + "• Metabolic alkalosis\n"
            + "• Always monitor electrolytes and replace as needed\n\n"
            + "##Furosemide vs. Bumetanide:##\n\n"
            + "• ##Furosemide:## 40 mg IV ≈ 1 mg bumetanide\n"
            + "• ##Bumetanide:## More potent, better oral bioavailability (80% vs. 60%), less ototoxic\n"
            + "• If furosemide isn't working, switch to bumetanide\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Furosemide is the first-line diuretic for acute pulmonary edema and volume overload. Start with 40 mg IV (or double the home dose), and if no response, escalate to 80 mg. Push slowly (≤20 mg/min) to avoid ototoxicity. Always monitor potassium — hypokalemia is common and dangerous.\n\n"
            + "##High-yield point:## Furosemide has a ceiling dose (80-100 mg bolus). If the patient isn't responding, don't keep increasing the bolus — switch to a continuous infusion (5-10 mg/hr) or switch to bumetanide (40x more potent)."
        ),
        
        // 24. Glucagon
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Glucagon",
            brandName: "GlucaGen",
            mechansim: "Glucagon is a pancreatic hormone that raises blood glucose by mobilizing liver glycogen. It also has positive inotropic effects independent of beta-receptors.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of glucagon as the hypoglycemia reverser and beta-blocker antidote. For hypoglycemia, it mobilizes stored glycogen from the liver (only works if glycogen stores exist). For beta-blocker overdose, it bypasses blocked beta-receptors and directly stimulates the heart through the glucagon receptor.\n\n"
            + "##How it works:##\n\n"
            + "• Activates glucagon receptors on liver → Stimulates glycogenolysis → Raises blood glucose\n"
            + "• Activates glucagon receptors on heart → Increases cAMP → Positive inotropy/chronotropy (bypasses beta-receptors)\n"
            + "• Relaxes GI smooth muscle → Reduces peristalsis\n"
            + "• Does NOT work if glycogen stores are depleted (malnourished, alcoholics)\n\n"
            + "##The key:## Glucagon is the antidote for beta-blocker and calcium channel blocker overdose. It bypasses blocked beta-receptors and stimulates the heart directly. For hypoglycemia, it only works if the patient has glycogen stores (won't work in malnourished patients or alcoholics).\n\n"
            + "##High-yield point:## Glucagon causes severe nausea and vomiting — place the patient on their side before giving to prevent aspiration. It's the antidote for beta-blocker overdose because it stimulates the heart through glucagon receptors, bypassing blocked beta-receptors.",
            adverseEffects: "##Common:##\n\n"
            + "• Nausea, vomiting (very common — place patient on side!)\n"
            + "• Hyperglycemia\n"
            + "• Dizziness\n\n"
            + "##Serious:##\n\n"
            + "• Hypertensive crisis in pheochromocytoma (contraindicated)\n"
            + "• Hypoglycemia (rebound, if glycogen stores depleted)\n"
            + "• Allergic reactions (rare)\n\n"
            + "##The vomiting problem:##\n\n"
            + "Glucagon almost always causes nausea and vomiting. Before giving glucagon, turn the patient on their side to prevent aspiration, especially if they're obtunded from hypoglycemia.\n\n"
            + "##Red flags:##\n\n"
            + "• Vomiting in obtunded patient (aspiration risk)\n"
            + "• No response to glucagon for hypoglycemia (glycogen stores depleted — need IV dextrose)\n"
            + "• Patient has pheochromocytoma (can trigger hypertensive crisis)",
            dose: "##Hypoglycemia:##\n\n"
            + "• 1 mg IM or SQ (or 0.5 mg if <25 kg)\n"
            + "• Onset: 5-20 minutes\n"
            + "• If no response in 15-20 minutes, give IV dextrose (glycogen stores may be depleted)\n\n"
            + "##Beta-Blocker Overdose:##\n\n"
            + "• Bolus: 3-10 mg IV (start with 3-5 mg)\n"
            + "• Infusion: 3-5 mg/hr IV (titrate to effect)\n"
            + "• May need very high doses (up to 10 mg/hr)\n\n"
            + "##Calcium Channel Blocker Overdose:##\n\n"
            + "• Same as beta-blocker: 3-10 mg IV bolus, then 3-5 mg/hr infusion\n"
            + "• Often used with calcium, insulin + dextrose (high-dose insulin therapy)\n\n"
            + "##Administration:##\n\n"
            + "• Reconstitute powder with diluent before use\n"
            + "• Can give IM, SQ, or IV\n"
            + "• Place patient on side before giving (vomiting risk)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Pancreatic hormone, antidote.\n\n"
            + "Used for hypoglycemia and as antidote for beta-blocker and calcium channel blocker overdose.",
            indications: "##Primary indications:##\n\n"
            + "• Hypoglycemia (when IV access unavailable)\n"
            + "• Beta-blocker overdose (antidote)\n"
            + "• Calcium channel blocker overdose (adjunct)\n"
            + "• GI motility reduction (imaging studies)\n\n"
            + "##You'll reach for glucagon when:##\n\n"
            + "• Hypoglycemic patient without IV access (IM/SQ glucagon)\n"
            + "• Beta-blocker overdose with refractory bradycardia/hypotension\n"
            + "• CCB overdose not responding to calcium\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Diabetic patient found unresponsive, glucose 35, no IV access → Glucagon 1 mg IM\n"
            + "• Propranolol overdose, HR 35, BP 70/40, not responding to fluids/atropine → Glucagon 5 mg IV\n"
            + "• Diltiazem overdose, refractory hypotension → Glucagon + calcium + high-dose insulin",
            contraindiction: "##Absolute:##\n\n"
            + "• Pheochromocytoma (can trigger hypertensive crisis)\n"
            + "• Insulinoma (can trigger insulin release → worsening hypoglycemia)\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Depleted glycogen stores (malnourished, alcoholics) — glucagon won't work for hypoglycemia\n"
            + "• Adrenal insufficiency (may not respond)\n\n"
            + "##Critical safety point:## Glucagon causes severe nausea and vomiting. Place the patient on their side before giving to prevent aspiration, especially if obtunded from hypoglycemia.",
            onSet: "5-20 min (IM/SQ for hypoglycemia), minutes (IV for beta-blocker OD)",
            halfLife: "8-18 min",
            duration: "30-60 min",
            absorbtion: "Well absorbed (IM, SQ)",
            distribution: "Widely distributed",
            metaBolism: "Liver and plasma",
            excretion: "Urine",
            pregnancyExplanation: "Category B. Generally safe in pregnancy. No teratogenic effects reported.",
            criticalPearls: "##How to use glucagon safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Place patient on their side (glucagon causes vomiting)\n"
            + "• Rule out pheochromocytoma and insulinoma (contraindicated)\n"
            + "• For hypoglycemia: Consider if glycogen stores exist (won't work in malnourished/alcoholics)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor for vomiting (aspiration risk)\n"
            + "• Monitor glucose (for hypoglycemia)\n"
            + "• Monitor HR and BP (for beta-blocker/CCB overdose)\n"
            + "• If no response for hypoglycemia → Give IV dextrose (glycogen depleted)\n\n"
            + "##Glucagon for hypoglycemia:##\n\n"
            + "• 1 mg IM or SQ\n"
            + "• Works by mobilizing liver glycogen → Raises glucose\n"
            + "• Onset: 5-20 minutes\n"
            + "• Duration: 30-60 minutes\n\n"
            + "##Limitations:##\n\n"
            + "• Won't work if glycogen stores depleted (alcoholics, malnourished, prolonged fasting)\n"
            + "• Need IV dextrose if no response\n\n"
            + "##Glucagon for beta-blocker overdose:##\n\n"
            + "##Beta-blockers block## beta-receptors → Bradycardia, hypotension. Glucagon bypasses beta-receptors:\n\n"
            + "• Activates glucagon receptors on heart → Increases cAMP directly\n"
            + "• Results in positive inotropy and chronotropy\n"
            + "• Dose: 3-10 mg IV bolus, then 3-5 mg/hr infusion\n"
            + "• May need very high doses\n\n"
            + "##Glucagon for CCB overdose:##\n\n"
            + "##CCB overdose## is often treated with multiple agents:\n\n"
            + "• Calcium (first-line)\n"
            + "• High-dose insulin + dextrose (improves cardiac contractility)\n"
            + "• Glucagon (adjunct)\n"
            + "• Vasopressors (norepinephrine)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not placing patient on side (vomiting → aspiration)\n"
            + "• Expecting glucagon to work in malnourished patients (no glycogen stores)\n"
            + "• Using insufficient doses for beta-blocker OD (need 3-10 mg bolus, not 1 mg)\n\n"
            + "##The takeaway:##\n\n"
            + "Glucagon is a pancreatic hormone that raises glucose (by mobilizing liver glycogen) and stimulates the heart (by bypassing beta-receptors). It's used for hypoglycemia (when IV access unavailable) and as an antidote for beta-blocker/CCB overdose. Place the patient on their side before giving — it causes severe vomiting. For beta-blocker OD, use high doses (3-10 mg bolus, 3-5 mg/hr infusion)."
        ),
        
        // 25. Haloperidol
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Haloperidol",
            brandName: "Haldol ®",
            mechansim: "Haloperidol is a butyrophenone antipsychotic that blocks postsynaptic dopamine D2 receptors in the CNS.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of haloperidol as the dopamine blocker for severe agitation — it calms patients without causing respiratory depression (unlike benzodiazepines). It's the go-to for ICU delirium, severe psychosis, and acute agitation. However, it can cause QT prolongation and extrapyramidal symptoms (EPS).\n\n"
            + "##How it works:##\n\n"
            + "• Blocks D2 dopamine receptors in the mesolimbic pathway → Antipsychotic effect\n"
            + "• Blocks D2 receptors in nigrostriatal pathway → Causes EPS (dystonia, parkinsonism, akathisia)\n"
            + "• Blocks D2 receptors in CTZ → Antiemetic effect\n"
            + "• Blocks potassium channels → QT prolongation\n\n"
            + "##The key:## Haloperidol is preferred for acute agitation in patients who can't have benzodiazepines (respiratory compromise, elderly). It doesn't cause respiratory depression. However, it can cause Torsades de Pointes (especially IV), so check ECG before giving.\n\n"
            + "##High-yield point:## IV haloperidol causes more QT prolongation than IM. If giving IV (especially repeated doses), check ECG for QT prolongation. If QTc >500 ms, hold haloperidol and use an alternative (olanzapine, dexmedetomidine).",
            adverseEffects: "##Common:##\n\n"
            + "• Sedation\n"
            + "• Extrapyramidal symptoms (dystonia, akathisia, parkinsonism)\n"
            + "• Hypotension\n"
            + "• Dry mouth\n\n"
            + "##Serious:##\n\n"
            + "• QT prolongation and Torsades de Pointes (especially IV)\n"
            + "• Neuroleptic malignant syndrome (NMS) — rare but life-threatening\n"
            + "• Tardive dyskinesia (with chronic use)\n\n"
            + "##The QT prolongation problem:##\n\n"
            + "Haloperidol blocks potassium channels, prolonging the QT interval. IV haloperidol causes more QT prolongation than IM. Check ECG before giving, especially if patient is on other QT-prolonging drugs.\n\n"
            + "##Red flags:##\n\n"
            + "• QTc >500 ms (hold haloperidol, risk of Torsades)\n"
            + "• Muscle rigidity + fever + altered mental status (NMS)\n"
            + "• Dystonia (treat with diphenhydramine 25-50 mg IV)\n"
            + "• Severe akathisia (restlessness)",
            dose: "##Acute Agitation/Delirium:##\n\n"
            + "• 2-5 mg IM every 4-8 hours as needed\n"
            + "• Or 0.5-2 mg IV every 4-8 hours (more QT prolongation)\n"
            + "• Start low in elderly (0.5-1 mg)\n\n"
            + "##Severe Agitation:##\n\n"
            + "• 5-10 mg IM\n"
            + "• May repeat every 20-30 minutes if needed (max 20 mg/day)\n\n"
            + "##ICU Delirium:##\n\n"
            + "• 2-5 mg IV every 6-8 hours\n"
            + "• Check QTc before and during treatment\n\n"
            + "##Administration:##\n\n"
            + "• IM preferred (less QT prolongation than IV)\n"
            + "• Check ECG before IV dosing\n"
            + "• Hold if QTc >500 ms",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Butyrophenone antipsychotic.\n\n"
            + "Used for acute agitation, psychosis, ICU delirium, and nausea/vomiting.",
            indications: "##Primary indications:##\n\n"
            + "• Acute agitation (psychosis, delirium, intoxication)\n"
            + "• ICU delirium (hyperactive delirium)\n"
            + "• Psychosis (acute or chronic)\n"
            + "• Nausea/vomiting (antiemetic)\n\n"
            + "##You'll reach for haloperidol when:##\n\n"
            + "• Agitated patient who can't have benzodiazepines (respiratory compromise)\n"
            + "• ICU patient with hyperactive delirium\n"
            + "• Psychotic patient with agitation\n\n"
            + "##Classic scenarios:##\n\n"
            + "• ICU patient pulling at lines, confused, agitated → Haloperidol 2-5 mg IM\n"
            + "• Elderly patient with agitated delirium, respiratory compromise → Haloperidol 0.5-1 mg IM\n"
            + "• Acute psychosis, not responding to verbal de-escalation → Haloperidol 5 mg IM",
            contraindiction: "##Absolute:##\n\n"
            + "• Parkinson's disease (worsens symptoms via dopamine blockade)\n"
            + "• CNS depression or coma\n"
            + "• Long QT syndrome or QTc >500 ms\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Lewy body dementia (very sensitive to antipsychotics)\n"
            + "• Concurrent QT-prolonging drugs\n"
            + "• Elderly with dementia (increased mortality — black box warning)\n"
            + "• Hypokalemia or hypomagnesemia (increases QT risk)\n\n"
            + "##Critical safety point:## Haloperidol can cause Torsades de Pointes, especially with IV administration. Check ECG for QT prolongation before giving. If QTc >500 ms, use an alternative (olanzapine, dexmedetomidine). Correct hypokalemia and hypomagnesemia first.",
            onSet: "20-30 min (IM), 10-20 min (IV)",
            halfLife: "21-24 hrs",
            duration: "4-8 hrs",
            absorbtion: "Well absorbed (IM)",
            distribution: "Widely distributed, crosses BBB",
            metaBolism: "Liver (CYP2D6, CYP3A4)",
            excretion: "Urine (40%), feces (15%)",
            pregnancyExplanation: "Category C. Use in pregnancy only if benefits outweigh risks. Potential for EPS in neonates.",
            criticalPearls: "##How to use haloperidol safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check ECG for QT prolongation (hold if QTc >500 ms)\n"
            + "• Check for Parkinson's disease (contraindicated)\n"
            + "• Check electrolytes (correct hypokalemia, hypomagnesemia)\n"
            + "• Have diphenhydramine ready (for EPS)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor for EPS (dystonia, akathisia, parkinsonism)\n"
            + "• Monitor ECG for QT prolongation (especially with IV or repeated doses)\n"
            + "• If dystonia → Give diphenhydramine 25-50 mg IV\n"
            + "• Watch for signs of NMS (rigidity, fever, altered mental status)\n\n"
            + "##Haloperidol vs. Benzodiazepines for agitation:##\n\n"
            + "##Haloperidol:##\n\n"
            + "• No respiratory depression\n"
            + "• Causes QT prolongation, EPS\n"
            + "• Preferred in respiratory compromise\n"
            + "• Works well for psychosis/delirium\n\n"
            + "##Benzodiazepines (lorazepam, midazolam):##\n\n"
            + "• Causes respiratory depression\n"
            + "• No QT prolongation\n"
            + "• Preferred for alcohol/benzo withdrawal, seizures\n"
            + "• Works well for anxiety-driven agitation\n\n"
            + "##Bottom line:## Use haloperidol for delirium/psychosis. Use benzodiazepines for alcohol withdrawal, anxiety, or seizures.\n\n"
            + "##Neuroleptic Malignant Syndrome (NMS):##\n\n"
            + "NMS is a rare but life-threatening reaction to antipsychotics:\n\n"
            + "• Fever (often >40°C)\n"
            + "• Muscle rigidity (\"lead pipe\")\n"
            + "• Altered mental status\n"
            + "• Autonomic instability (BP swings, tachycardia)\n"
            + "• Elevated CK (rhabdomyolysis)\n\n"
            + "##Treatment:## Stop haloperidol, supportive care, dantrolene, bromocriptine\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not checking ECG before IV haloperidol (QT prolongation risk)\n"
            + "• Using haloperidol in Parkinson's disease (worsens symptoms)\n"
            + "• Not having diphenhydramine ready (needed for EPS)\n"
            + "• Using in Lewy body dementia (extreme sensitivity to antipsychotics)\n\n"
            + "##The takeaway:##\n\n"
            + "Haloperidol is a dopamine blocker that calms agitation without causing respiratory depression. It's preferred for ICU delirium and psychosis. However, it can cause QT prolongation (especially IV), EPS, and rarely NMS. Check ECG before giving, have diphenhydramine ready for EPS, and avoid in Parkinson's disease. If QTc >500 ms, use an alternative."
        ),
        
        // 26. Hydralazine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Hydralazine",
            brandName: "Apresoline ®",
            mechansim: "Hydralazine is a direct-acting arterial vasodilator that relaxes smooth muscle in arterioles.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of hydralazine as the pregnancy-safe blood pressure reducer — it's one of the few IV antihypertensives safe in pre-eclampsia and eclampsia. It dilates arteries (not veins), which drops systemic vascular resistance and blood pressure, but this triggers reflex tachycardia as the body tries to compensate.\n\n"
            + "##How it works:##\n\n"
            + "• Direct vasodilation of arterioles → Decreases SVR\n"
            + "• Blood pressure drops → Baroreceptor reflex activates\n"
            + "• Reflex tachycardia occurs (increased HR and cardiac output)\n"
            + "• Venous return unchanged (doesn't dilate veins)\n\n"
            + "##The key:## Hydralazine causes reflex tachycardia, which can increase myocardial oxygen demand. This makes it risky in patients with coronary artery disease or recent MI. It's often combined with a beta-blocker (e.g., labetalol) to blunt the reflex tachycardia.\n\n"
            + "##High-yield point:## Hydralazine is first-line for hypertensive emergencies in pregnancy (pre-eclampsia, eclampsia) because it's safe for the fetus. It's also used in heart failure (combined with nitrates) to reduce afterload. Chronic use can cause drug-induced lupus (more common in slow acetylators).",
            adverseEffects: "##Common:##\n\n"
            + "• Reflex tachycardia (most common)\n"
            + "• Hypotension\n"
            + "• Headache, flushing\n"
            + "• Nausea, vomiting\n"
            + "• Palpitations\n\n"
            + "##Serious:##\n\n"
            + "• Myocardial ischemia (from reflex tachycardia and increased O₂ demand)\n"
            + "• Drug-induced lupus (with chronic use >200 mg/day)\n"
            + "• Peripheral neuropathy (chronic use)\n"
            + "• Severe hypotension\n\n"
            + "##The reflex tachycardia problem:##\n\n"
            + "Hydralazine drops blood pressure by dilating arteries, which triggers the baroreceptor reflex. The body responds by increasing heart rate and cardiac output to maintain perfusion. In patients with CAD, this increased myocardial oxygen demand can trigger ischemia or MI.\n\n"
            + "##Red flags:##\n\n"
            + "• HR increases >20 bpm (excessive reflex tachycardia)\n"
            + "• New chest pain or ST changes (myocardial ischemia)\n"
            + "• SBP <90 (hypotension)\n"
            + "• Signs of lupus-like syndrome (joint pain, rash, fever with chronic use)",
            dose: "##Hypertensive Emergency (pre-eclampsia/eclampsia):##\n\n"
            + "• 5-10 mg IV push every 20-30 minutes\n"
            + "• Max cumulative dose: 20-40 mg\n"
            + "• Alternative: 5 mg IV, then 5-10 mg every 20 min as needed\n\n"
            + "##Hypertensive Urgency:##\n\n"
            + "• 10-20 mg IM (less predictable absorption)\n\n"
            + "##Heart Failure (oral, chronic use):##\n\n"
            + "• Combined with isosorbide dinitrate (BiDil)\n"
            + "• 37.5-75 mg PO TID\n\n"
            + "##Administration:##\n\n"
            + "• Give IV push slowly over 1-2 minutes\n"
            + "• Onset is 5-20 minutes, so wait before repeating\n"
            + "• Monitor blood pressure and heart rate continuously\n"
            + "• Consider beta-blocker to prevent reflex tachycardia",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Direct-acting arterial vasodilator.\n\n"
            + "First-line IV antihypertensive for pre-eclampsia and eclampsia. Also used in heart failure (combined with nitrates).",
            indications: "##Primary indications:##\n\n"
            + "• Hypertensive emergency in pregnancy (pre-eclampsia, eclampsia)\n"
            + "• Severe hypertension (urgency/emergency)\n"
            + "• Heart failure with reduced ejection fraction (oral, combined with nitrates)\n\n"
            + "##You'll reach for hydralazine when:##\n\n"
            + "• Pregnant patient with BP >160/110 (severe pre-eclampsia)\n"
            + "• Eclamptic patient seizing with hypertension\n"
            + "• Heart failure patient with high afterload needs vasodilation\n\n"
            + "##Classic scenarios:##\n\n"
            + "• 32-week pregnant patient with BP 180/120, headache, proteinuria → Hydralazine 5-10 mg IV\n"
            + "• Eclamptic patient with BP 200/130 → Hydralazine + magnesium sulfate\n"
            + "• African American patient with heart failure, EF 25% → Hydralazine + isosorbide (BiDil)",
            contraindiction: "##Absolute:##\n\n"
            + "• Coronary artery disease or recent MI (reflex tachycardia increases O₂ demand)\n"
            + "• Mitral valve rheumatic heart disease (can worsen regurgitation)\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Severe aortic stenosis (vasodilation can cause hypotension)\n"
            + "• Aortic aneurysm or dissection (increased cardiac output can worsen)\n"
            + "• Cerebrovascular disease (rapid BP drop can reduce cerebral perfusion)\n"
            + "• Renal impairment (adjust dose)\n\n"
            + "##Critical safety point:## Hydralazine is contraindicated in coronary artery disease because reflex tachycardia increases myocardial oxygen demand, which can trigger ischemia or infarction. If the patient has known CAD, use labetalol (has beta-blockade to prevent tachycardia) or nicardipine instead.",
            onSet: "5-20 min (IV), 20-30 min (IM)",
            halfLife: "2-8 hrs",
            duration: "2-6 hrs (IV), up to 12 hrs (PO)",
            absorbtion: "Rapid (oral and IV)",
            distribution: "Widely distributed",
            metaBolism: "Liver (acetylation; slow acetylators at higher risk for lupus)",
            excretion: "Urine (metabolites)",
            pregnancyExplanation: "Category C. Extensively used in pregnancy for pre-eclampsia/eclampsia with good safety profile. Preferred over ACE inhibitors, ARBs, and labetalol in some cases.",
            criticalPearls: "##How to use hydralazine safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Rule out coronary artery disease (reflex tachycardia is dangerous in CAD)\n"
            + "• Check baseline heart rate and blood pressure\n"
            + "• Ensure IV access and continuous monitoring available\n"
            + "• Consider beta-blocker if tachycardia is expected\n\n"
            + "##While it's running:##\n\n"
            + "• Start with 5-10 mg IV push\n"
            + "• Wait 20-30 minutes before repeating (onset is slow)\n"
            + "• Monitor heart rate (watch for reflex tachycardia)\n"
            + "• Monitor blood pressure (goal: gradual reduction, not precipitous drop)\n"
            + "• If HR increases significantly → Consider beta-blocker (metoprolol 5 mg IV)\n\n"
            + "##Hydralazine vs. Labetalol for pre-eclampsia:##\n\n"
            + "##Hydralazine:##\n\n"
            + "• Classic first-line in pregnancy\n"
            + "• Safe for fetus\n"
            + "• Causes reflex tachycardia\n\n"
            + "##Labetalol:##\n\n"
            + "• Increasingly preferred\n"
            + "• No reflex tachycardia (has beta-blockade)\n"
            + "• More predictable BP response\n\n"
            + "##Bottom line:## Both are safe in pregnancy. Labetalol is often preferred now because it doesn't cause reflex tachycardia and has smoother BP control.\n\n"
            + "##Hydralazine + Nitrates for heart failure:##\n\n"
            + "In African## American patients with heart failure, the combination of hydralazine + isosorbide dinitrate (BiDil) improves survival. This combination:\n\n"
            + "• Hydralazine → Reduces afterload (arterial vasodilation)\n"
            + "• Isosorbide → Reduces preload (venous vasodilation)\n"
            + "• Together → Improve cardiac output and reduce heart failure symptoms\n\n"
            + "##Drug-induced lupus:##\n\n"
            + "##Chronic hydralazine## use (>200 mg/day for months) can cause drug-induced lupus, especially in slow acetylators. Symptoms include:\n\n"
            + "• Arthralgia (joint pain)\n"
            + "• Positive ANA (antinuclear antibody)\n"
            + "• Fever, rash\n"
            + "• Resolves after stopping hydralazine\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using hydralazine in patients with CAD (causes reflex tachycardia → ischemia)\n"
            + "• Repeating dose too quickly (onset takes 20 minutes, so wait)\n"
            + "• Not monitoring for reflex tachycardia\n"
            + "• Using in aortic dissection (increased cardiac output can worsen)\n\n"
            + "##The takeaway:##\n\n"
            + "Hydralazine is a direct arterial vasodilator that's first-line for hypertensive emergencies in pregnancy (pre-eclampsia, eclampsia) because it's safe for the fetus. It causes reflex tachycardia, which can trigger myocardial ischemia in patients with CAD, so avoid it in that population. It's also used in heart failure (combined with nitrates) to reduce afterload. Start low, wait 20 minutes before repeating, and watch for reflex tachycardia."
        ),
        
        // 27. Hydromorphone
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Hydromorphone",
            brandName: "Dilaudid ®",
            mechansim: "Hydromorphone is a semi-synthetic μ (mu) opioid receptor agonist.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of hydromorphone as the high-potency, clean opioid — it's about ##5-7x more potent than morphine## but without the histamine release. This makes it ideal for patients who need strong analgesia without hemodynamic effects.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to μ (mu) opioid receptors in the CNS\n"
            + "• Inhibits ascending pain pathways\n"
            + "• Activates descending pain inhibition\n"
            + "• No histamine release (unlike morphine)\n\n"
            + "##Key concept:## Hydromorphone is safer than morphine in renal failure because it has no active metabolites. Morphine's active metabolite (M6G) accumulates in kidney disease and causes prolonged sedation — hydromorphone doesn't have this problem.\n\n"
            + "##High-yield point:## Hydromorphone is the opioid of choice for severe pain in patients with renal failure, hemodynamic instability, or morphine allergies. It's more potent but cleaner than morphine.",
            adverseEffects: "##Common:##\n\n"
            + "• Respiratory depression (dose-dependent)\n"
            + "• Sedation\n"
            + "• Nausea/vomiting\n"
            + "• Constipation\n"
            + "• Pruritus (less than morphine)\n\n"
            + "##Serious:##\n\n"
            + "• Severe respiratory depression (overdose)\n"
            + "• Hypotension (minimal compared to morphine — no histamine release)\n"
            + "• CNS depression\n\n"
            + "##Why hydromorphone is \"cleaner\" than morphine:##\n\n"
            + "• No histamine release → Less hypotension, less bronchospasm, less itching\n"
            + "• No active metabolites → Safe in renal failure\n"
            + "• More hemodynamically stable\n\n"
            + "##Red flags:##\n\n"
            + "• Respiratory rate <8-10 breaths/min → Respiratory depression, consider naloxone\n"
            + "• Oversedation → Reduce dose or increase dosing interval",
            dose: "##Acute Pain (moderate to severe):##\n\n"
            + "• 0.5-2 mg IV/IM/SC q2-4h PRN\n"
            + "• Start low in opioid-naive patients (0.5-1 mg)\n\n"
            + "##Patient-Controlled Analgesia (PCA):##\n\n"
            + "• Bolus: 0.2-0.4 mg IV\n"
            + "• Lockout: 5-10 minutes\n"
            + "• Max hourly dose: 2-6 mg\n\n"
            + "##Continuous Infusion (rare):##\n\n"
            + "• 0.5-3 mg/hr IV\n\n"
            + "##Renal Dosing:##\n\n"
            + "• No dose adjustment needed (no active metabolites)\n"
            + "• Still monitor closely, but safer than morphine\n\n"
            + "##Morphine Equivalence:##\n\n"
            + "• Hydromorphone 1 mg IV ≈ Morphine 5-7 mg IV\n"
            + "• When converting, start at lower end of range and titrate\n\n"
            + "##Pediatric:##\n\n"
            + "• 0.015-0.02 mg/kg IV q2-4h",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "##Opioid analgesic (μ-receptor agonist).##\n\n"
            + "The high-potency, clean alternative to morphine — safer in renal failure and hemodynamic instability.",
            indications: "##Standard Indications:##\n\n"
            + "• Moderate to severe pain\n"
            + "• Post-operative pain\n"
            + "• Cancer pain\n"
            + "• Acute pain in renal failure (safer than morphine)\n\n"
            + "When to reach for hydromorphone:##\n\n"
            + "• Patient needs strong analgesia and has renal failure (no active metabolites)\n"
            + "• Morphine causes too much hypotension (no histamine release)\n"
            + "• Patient has morphine allergy or intolerance\n"
            + "• Need more potent opioid than morphine\n\n"
            + "##Clinical clues:## Severe pain in a patient with kidney disease, hypotension, or morphine intolerance.",
            contraindiction: "##Absolute:##\n\n"
            + "• Severe respiratory depression without airway support\n"
            + "• Status asthmaticus (opioids worsen hypoventilation)\n\n"
            + "##Caution:##\n\n"
            + "• Head injury or increased ICP (can worsen CO₂ retention)\n"
            + "• Elderly (increased sensitivity, fall risk)\n"
            + "• Concurrent CNS depressants (benzos, alcohol)\n"
            + "• Severe hepatic impairment (although safer than morphine in renal failure)\n\n"
            + "##Important:## Hydromorphone is much more potent than morphine. A common dosing error is giving hydromorphone at the same dose as morphine — this can cause severe respiratory depression.",
            onSet: "5-10 min (IV); 30 min (PO)",
            halfLife: "2-4 hours",
            duration: "3-4 hours",
            absorbtion: "Well absorbed (oral bioavailability 30-40%)",
            distribution: "Widely distributed, crosses BBB and placenta",
            metaBolism: "Hepatic (to inactive metabolites)\n\n"
            + "##No active metabolites → Safe in renal failure##",
            excretion: "Renal (as inactive metabolites)\n\n"
            + "##No dose adjustment needed in renal failure##",
            pregnancyExplanation: "##Pregnancy Category C:## Crosses the placenta. Chronic use can cause neonatal withdrawal. Use lowest effective dose for shortest duration.",
            criticalPearls: "##High Potency!##\n\n"
            + "• ##~5-7x more potent than morphine##\n"
            + "• Common dosing error: Giving hydromorphone at the same dose as morphine → Respiratory depression\n"
            + "• Always start low in opioid-naive patients (0.5-1 mg)\n\n"
            + "##No Active Metabolites##\n\n"
            + "• Safer in renal failure than morphine\n"
            + "• Morphine's M6G accumulates → Prolonged sedation\n"
            + "• Hydromorphone metabolites are inactive → No accumulation\n\n"
            + "##No Histamine Release##\n\n"
            + "• Less hypotension than morphine\n"
            + "• Less bronchospasm than morphine\n"
            + "• Less pruritus than morphine\n"
            + "• Better choice for hemodynamically unstable patients\n\n"
            + "##Hydromorphone vs. Morphine vs. Fentanyl:##\n\n"
            + "• ##Morphine:## Longer-acting, histamine release, active metabolite in renal failure\n"
            + "• ##Hydromorphone:## High-potency, no histamine, safe in renal failure\n"
            + "• ##Fentanyl:## Shortest-acting, no histamine, best for ICU/rapid titration\n\n"
            + "##Conversion:##\n\n"
            + "• Morphine 10 mg IV → Hydromorphone 1.5-2 mg IV\n"
            + "• When converting, start at lower end and titrate to effect\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Hydromorphone is the clean, high-potency opioid for severe pain. It's safer than morphine in renal failure (no active metabolites) and causes less hypotension (no histamine release). The main risk is respiratory depression from its high potency — always start low in opioid-naive patients.\n\n"
            + "##High-yield point:## Hydromorphone 1 mg IV ≈ Morphine 5-7 mg IV. It's the opioid of choice for severe pain in renal failure or when morphine causes too much hypotension."
        ),
        
        // 28. Insulin
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Insulin",
            brandName: "Humulin ®, Novolin ®",
            mechansim: "Insulin is an endogenous hormone that promotes glucose uptake into cells and shifts potassium intracellularly.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of insulin as the glucose and potassium shuttle — it drives both into cells. This makes it essential for treating DKA (lowers glucose), hyperkalemia (lowers potassium), and hyperglycemic crises. In the ICU, you'll use regular insulin IV for tight glycemic control.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to insulin receptors → Activates GLUT4 transporters\n"
            + "• Glucose uptake into muscle and fat cells → Lowers blood glucose\n"
            + "• Activates Na+/K+-ATPase pump → Shifts K+ into cells (lowers serum K+)\n"
            + "• Promotes glycogen synthesis, protein synthesis, lipogenesis\n"
            + "• Inhibits gluconeogenesis, glycogenolysis, lipolysis\n\n"
            + "##The key:## Only regular insulin can be given IV. Long-acting insulins (glargine, detemir) are subcutaneous only. Insulin causes hypokalemia by shifting K+ into cells, so always check potassium before and during infusion.\n\n"
            + "##High-yield point:## Insulin is the ONLY way to turn off ketogenesis in DKA. Fluids alone won't fix DKA — you need insulin to stop ketoacid production. For hyperkalemia, insulin + dextrose shifts K+ into cells within 15-30 minutes (effect lasts 4-6 hours).",
            adverseEffects: "##Common:##\n\n"
            + "• Hypoglycemia (most common, most dangerous)\n"
            + "• Hypokalemia (insulin shifts K+ into cells)\n"
            + "• Weight gain (chronic use)\n"
            + "• Injection site reactions\n\n"
            + "##Serious:##\n\n"
            + "• Severe hypoglycemia (seizures, coma, death)\n"
            + "• Severe hypokalemia (arrhythmias, cardiac arrest)\n"
            + "• Cerebral edema (rare, in DKA with rapid correction)\n\n"
            + "##The hypoglycemia problem:##\n\n"
            + "Insulin-induced hypoglycemia can be fatal. Always give dextrose (D5W or D10W) concurrently with insulin infusions once glucose drops to prevent hypoglycemia. In hyperkalemia treatment, give insulin + dextrose together.\n\n"
            + "##Red flags:##\n\n"
            + "• Glucose <70 mg/dL (hypoglycemia, give dextrose)\n"
            + "• K+ <3.3 mEq/L (hold insulin in DKA until K+ repleted)\n"
            + "• Altered mental status (hypoglycemia or cerebral edema in DKA)\n"
            + "• Severe headache in DKA patient (cerebral edema)",
            dose: "##DKA (Diabetic Ketoacidosis):##\n\n"
            + "• Bolus: 0.1 units/kg IV (optional, often omitted)\n"
            + "• Infusion: 0.1 units/kg/hr IV (typically 5-10 units/hr)\n"
            + "• When glucose <200-250 mg/dL → Add D5W and reduce insulin to 0.05 units/kg/hr\n"
            + "• Continue until anion gap closes and ketones clear\n\n"
            + "##Hyperglycemia (ICU, non-DKA):##\n\n"
            + "• Goal glucose: 140-180 mg/dL\n"
            + "• Start infusion at 0.5-2 units/hr IV\n"
            + "• Titrate based on glucose checks every 1-2 hours\n\n"
            + "##Hyperkalemia:##\n\n"
            + "• 10 units regular insulin IV + 25 g dextrose (1 amp D50)\n"
            + "• Onset: 15-30 minutes\n"
            + "• Duration: 4-6 hours\n"
            + "• Lowers K+ by 0.5-1.5 mEq/L\n\n"
            + "##Administration:##\n\n"
            + "• IV: MUST use regular insulin only (Humulin R, Novolin R)\n"
            + "• Subcutaneous: Can use rapid-acting (lispro, aspart), short-acting (regular), intermediate (NPH), or long-acting (glargine, detemir)\n"
            + "• Always check K+ before starting insulin (hold if K+ <3.3 mEq/L in DKA)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Endogenous hormone, antihyperglycemic.\n\n"
            + "Used for DKA, hyperglycemia, hyperkalemia, and glycemic control in diabetes.",
            indications: "##Primary indications:##\n\n"
            + "• Diabetic ketoacidosis (DKA)\n"
            + "• Hyperosmolar hyperglycemic state (HHS)\n"
            + "• Hyperglycemia (ICU glycemic control)\n"
            + "• Hyperkalemia (shifts K+ into cells)\n"
            + "• Type 1 diabetes (absolute insulin deficiency)\n"
            + "• Type 2 diabetes (when oral agents insufficient)\n\n"
            + "##You'll reach for insulin when:##\n\n"
            + "• DKA patient with glucose >250, anion gap acidosis, ketones\n"
            + "• Hyperkalemia patient needs rapid K+ lowering\n"
            + "• ICU patient with glucose >180 mg/dL\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Type 1 diabetic with glucose 450, pH 7.2, anion gap 24, ketones → Insulin infusion 0.1 units/kg/hr\n"
            + "• ESRD patient with K+ 7.2, peaked T waves → Insulin 10 units + D50\n"
            + "• Post-op patient with glucose 280 → Insulin infusion for glycemic control",
            contraindiction: "##Absolute:##\n\n"
            + "• Hypoglycemia (glucose <70 mg/dL)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Hypokalemia (K+ <3.3 mEq/L) — Do NOT give insulin in DKA until K+ repleted\n"
            + "• Renal failure (insulin is renally cleared; may need dose reduction)\n"
            + "• Adrenal insufficiency (increased risk of hypoglycemia)\n\n"
            + "##Critical safety point:## In DKA, do NOT start insulin if K+ <3.3 mEq/L. Insulin will drive K+ even lower, causing life-threatening arrhythmias. Replete potassium first, then start insulin. Most DKA patients are total-body potassium depleted despite normal or high serum K+ on presentation.",
            onSet: "5-15 min (IV regular insulin)",
            halfLife: "4-6 min (IV); longer for SubQ formulations",
            duration: "30-60 min (IV), 3-4 hrs (SubQ regular), 12-24 hrs (long-acting)",
            absorbtion: "Rapid (SubQ), immediate (IV)",
            distribution: "Extracellular fluid, does not cross BBB",
            metaBolism: "Liver (insulinase), kidney",
            excretion: "Kidney (60-80%)",
            pregnancyExplanation: "Category B. Insulin is the preferred agent for glycemic control in pregnancy. Gestational diabetes and pre-existing diabetes should be managed with insulin, not oral agents.",
            criticalPearls: "##How to use insulin safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check glucose (confirm hyperglycemia)\n"
            + "• Check potassium (hold if K+ <3.3 mEq/L in DKA)\n"
            + "• Ensure IV regular insulin for IV use (NOT long-acting insulin)\n"
            + "• Have dextrose (D50, D10, D5W) at bedside\n\n"
            + "##While it's running:##\n\n"
            + "• Check glucose hourly (titrate insulin infusion)\n"
            + "• Check K+ every 2-4 hours (replace as needed)\n"
            + "• When glucose <200-250 mg/dL in DKA → Add D5W to prevent hypoglycemia\n"
            + "• If glucose <70 mg/dL → Give D50 (1 amp) and reduce insulin rate\n\n"
            + "##Insulin for DKA:##\n\n"
            + "DKA management: Insulin + Fluids + Potassium\n\n"
            + "• Fluids: 1-2 L NS bolus, then 250-500 mL/hr\n"
            + "• Insulin: 0.1 units/kg/hr IV (don't start until K+ >3.3 mEq/L)\n"
            + "• Potassium: Replete aggressively (most patients are total-body K+ depleted)\n"
            + "• When glucose <200-250 mg/dL → Add D5W, reduce insulin to 0.05 units/kg/hr\n"
            + "• Continue insulin until anion gap closes and ketones clear (not just glucose)\n\n"
            + "##Why continue insulin after glucose normalizes:##\n\n"
            + "In DKA, glucose will drop before ketones clear. You need to continue insulin (with dextrose) to turn off ketogenesis. Stopping insulin too early will cause rebound ketoacidosis.\n\n"
            + "##Insulin for hyperkalemia:##\n\n"
            + "• 10 units regular insulin IV + 25 g dextrose (1 amp D50)\n"
            + "• Give dextrose WITH insulin (not after) to prevent hypoglycemia\n"
            + "• Onset: 15-30 minutes\n"
            + "• Duration: 4-6 hours\n"
            + "• This is a temporizing measure — need definitive K+ removal (diuretics, dialysis, Kayexalate)\n\n"
            + "##Insulin types:##\n\n"
            + "##Regular Insulin (Humulin R, Novolin R):##\n\n"
            + "• ONLY insulin that can be given IV\n"
            + "• Onset: 30 min (SubQ), 5-15 min (IV)\n"
            + "• Duration: 3-4 hrs (SubQ), 30-60 min (IV)\n\n"
            + "##Rapid-Acting (Lispro, Aspart, Glulisine):##\n\n"
            + "• SubQ only\n"
            + "• Onset: 10-15 min\n"
            + "• Duration: 2-4 hrs\n\n"
            + "##Long-Acting (Glargine, Detemir):##\n\n"
            + "• SubQ only (NEVER give IV)\n"
            + "• Duration: 12-24 hrs\n"
            + "• Used for basal insulin (not for DKA or hyperkalemia)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Starting insulin in DKA before checking/repleting potassium (causes severe hypokalemia)\n"
            + "• Stopping insulin when glucose normalizes in DKA (ketones still present → rebound DKA)\n"
            + "• Not giving dextrose with insulin for hyperkalemia (causes hypoglycemia)\n"
            + "• Using long-acting insulin IV (can only use regular insulin IV)\n"
            + "• Correcting glucose too rapidly in DKA (risk of cerebral edema, especially in kids)\n\n"
            + "##The takeaway:##\n\n"
            + "Insulin is the glucose and potassium shuttle — it drives both into cells. Use regular insulin IV for DKA (0.1 units/kg/hr) and hyperkalemia (10 units + dextrose). Always check and replete potassium before starting insulin in DKA. Continue insulin (with dextrose) until ketones clear, not just until glucose normalizes. Insulin is the only way to stop ketogenesis in DKA."
        ),
        
        // 29. Ipratropium
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Ipratropium Bromide",
            brandName: "Atrovent ®",
            mechansim: "Ipratropium is an anticholinergic bronchodilator that blocks muscarinic receptors in the airways.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of ipratropium as the \"dries you up\" bronchodilator — it blocks acetylcholine, which normally causes bronchoconstriction and mucus production. By blocking these receptors, it opens airways and dries secretions. Unlike atropine (which crosses the BBB), ipratropium is quaternary ammonium and stays in the lungs, so it doesn't cause systemic anticholinergic effects.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks muscarinic (M3) receptors in bronchial smooth muscle → Prevents acetylcholine-induced bronchoconstriction\n"
            + "• Reduces mucus production → Dries secretions\n"
            + "• Quaternary ammonium structure → Doesn't cross BBB (no CNS effects)\n"
            + "• Minimal systemic absorption → Few systemic side effects\n\n"
            + "##The key:## Ipratropium is synergistic with β-agonists (albuterol) — they work through different pathways, so combining them gives better bronchodilation than either alone. It's first-line for COPD exacerbations (often combined with albuterol) and used in severe asthma exacerbations.\n\n"
            + "##High-yield point:## Ipratropium + albuterol is the standard combination for severe asthma/COPD exacerbations. Ipratropium works on cholinergic pathways (parasympathetic), while albuterol works on adrenergic pathways (sympathetic). Together, they provide superior bronchodilation.",
            adverseEffects: "##Common:##\n\n"
            + "• Dry mouth (most common)\n"
            + "• Bitter taste\n"
            + "• Headache\n"
            + "• Cough (paradoxical, from dry airways)\n\n"
            + "##Serious:##\n\n"
            + "• Urinary retention (especially in BPH)\n"
            + "• Narrow-angle glaucoma (if gets in eyes)\n"
            + "• Paradoxical bronchospasm (rare)\n\n"
            + "##The systemic effects problem:##\n\n"
            + "Ipratropium is designed to stay in the lungs (quaternary ammonium), but some can still cause systemic anticholinergic effects, especially urinary retention in men with BPH and glaucoma if it gets in the eyes.\n\n"
            + "##Red flags:##\n\n"
            + "• Urinary retention (especially men with BPH)\n"
            + "• Eye pain, blurred vision (glaucoma if gets in eyes)\n"
            + "• Worsening bronchospasm (paradoxical reaction)",
            dose: "##COPD/Asthma Exacerbation:##\n\n"
            + "• 0.5 mg nebulized every 6-8 hours\n"
            + "• Often combined with albuterol (DuoNeb: 0.5 mg ipratropium + 2.5 mg albuterol)\n"
            + "• For severe exacerbations: Can give every 20 minutes × 3 doses\n\n"
            + "##MDI (Metered-Dose Inhaler):##\n\n"
            + "• 2 puffs (36 mcg) every 6-8 hours\n"
            + "• Use spacer for better delivery\n\n"
            + "##Administration:##\n\n"
            + "• Nebulized: Mix with 3-4 mL normal saline\n"
            + "• Can combine with albuterol in same nebulizer (DuoNeb)\n"
            + "• Avoid getting in eyes (can cause glaucoma)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Anticholinergic bronchodilator.\n\n"
            + "Used for COPD and asthma exacerbations, often combined with β-agonists for synergistic bronchodilation.",
            indications: "##Primary indications:##\n\n"
            + "• COPD exacerbation (first-line, often with albuterol)\n"
            + "• Severe asthma exacerbation (adjunct to albuterol)\n"
            + "• Chronic COPD (maintenance therapy)\n\n"
            + "##You'll reach for ipratropium when:##\n\n"
            + "• COPD patient with exacerbation (first-line)\n"
            + "• Severe asthma exacerbation (add to albuterol)\n"
            + "• Need to dry secretions\n\n"
            + "##Classic scenarios:##\n\n"
            + "• COPD exacerbation, increased dyspnea → Ipratropium + albuterol (DuoNeb)\n"
            + "• Severe asthma, not responding to albuterol alone → Add ipratropium\n"
            + "• COPD patient with excessive secretions → Ipratropium to dry up",
            contraindiction: "##Absolute:##\n\n"
            + "• Hypersensitivity to ipratropium or atropine\n"
            + "• Narrow-angle glaucoma (if gets in eyes)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• BPH (urinary retention)\n"
            + "• Bladder outlet obstruction\n"
            + "• Myasthenia gravis (anticholinergics worsen weakness)\n\n"
            + "##Critical safety point:## Ipratropium can cause urinary retention, especially in men with BPH. If it gets in the eyes, it can cause narrow-angle glaucoma. Use caution in these patients.",
            onSet: "1-3 min (nebulized), 5-15 min (MDI)",
            halfLife: "2 hrs",
            duration: "4-6 hrs",
            absorbtion: "Poor systemic absorption (quaternary ammonium)",
            distribution: "Local (lungs), minimal systemic",
            metaBolism: "Minimal (not metabolized)",
            excretion: "Urine (unchanged)",
            pregnancyExplanation: "Category B. Generally safe in pregnancy. No teratogenic effects reported.",
            criticalPearls: "##How to use ipratropium safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check for BPH or urinary retention history\n"
            + "• Check for narrow-angle glaucoma\n"
            + "• Consider combining with albuterol (synergistic)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor for dry mouth (most common side effect)\n"
            + "• Watch for urinary retention (especially men with BPH)\n"
            + "• Avoid getting in eyes (can cause glaucoma)\n\n"
            + "##Ipratropium + Albuterol (DuoNeb):##\n\n"
            + "The combination of ipratropium + albuterol is synergistic:\n\n"
            + "• Ipratropium blocks cholinergic (parasympathetic) pathways\n"
            + "• Albuterol stimulates adrenergic (sympathetic) pathways\n"
            + "• Together: Superior bronchodilation\n\n"
            + "##Standard for severe asthma/COPD exacerbations:##\n\n"
            + "• DuoNeb: 0.5 mg ipratropium + 2.5 mg albuterol nebulized\n"
            + "• Give every 20 minutes × 3 doses for severe exacerbations\n"
            + "• Then every 4-6 hours\n\n"
            + "##Ipratropium vs. Tiotropium:##\n\n"
            + "##Ipratropium:##\n\n"
            + "• Short-acting (4-6 hours)\n"
            + "• Used for acute exacerbations\n"
            + "• Multiple daily doses\n\n"
            + "##Tiotropium:##\n\n"
            + "• Long-acting (24 hours)\n"
            + "• Used for maintenance therapy\n"
            + "• Once daily\n\n"
            + "##Bottom line:## Use ipratropium for acute exacerbations. Use tiotropium for maintenance.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not combining with albuterol in severe exacerbations (synergistic effect)\n"
            + "• Using in patients with BPH without monitoring (urinary retention)\n"
            + "• Getting in eyes (can cause glaucoma)\n\n"
            + "##The takeaway:##\n\n"
            + "Ipratropium is an anticholinergic bronchodilator that blocks muscarinic receptors, opening airways and drying secretions. It's first-line for COPD exacerbations and used in severe asthma (often combined with albuterol for synergistic bronchodilation). It stays in the lungs (minimal systemic effects), but can cause urinary retention in BPH and glaucoma if it gets in the eyes."
        ),
        
        // 30. Ketamine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Ketamine",
            brandName: "Ketalar ®",
            mechansim: "Ketamine is a dissociative anesthetic that works by antagonizing NMDA receptors in the brain.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of ketamine as the drug that separates the mind from the body. It creates a dissociative state where patients are technically awake but disconnected from their surroundings and pain. Unlike other sedatives, it preserves airway reflexes and respiratory drive.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks NMDA receptors (glutamate) → Dissociative anesthesia\n"
            + "• Stimulates sympathetic nervous system → Increases heart rate and blood pressure\n"
            + "• Bronchodilation → Opens airways (great for asthma/COPD)\n"
            + "• Provides analgesia + sedation + amnesia (complete package)\n\n"
            + "##The key:## Ketamine is the only induction agent that increases blood pressure and heart rate (sympathetic surge). This makes it ideal for hypotensive, hypovolemic, or bronchospastic patients. It also preserves respiratory drive, so patients keep breathing even after induction.\n\n"
            + "##High-yield point:## Ketamine is the preferred induction agent for RSI in hypotensive patients (trauma, sepsis) and patients with reactive airway disease (asthma, COPD). It's also the go-to for procedural sedation in kids because of the IM route option.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypertension and tachycardia (sympathetic stimulation)\n"
            + "• Emergence reactions (hallucinations, vivid dreams)\n"
            + "• Nystagmus (involuntary eye movement)\n"
            + "• Hypersalivation (increased secretions)\n"
            + "• Nausea and vomiting\n\n"
            + "##Serious:##\n\n"
            + "• Laryngospasm (rare, but treat with suctioning and bag-mask ventilation)\n"
            + "• Severe hypertension (can worsen intracranial pressure)\n"
            + "• Emergence delirium (agitation on wakening)\n\n"
            + "##Emergence reactions:##\n\n"
            + "This is the weird, dissociative state patients enter as ketamine wears off — hallucinations, confusion, agitation. It's more common in adults than kids.\n\n"
            + "• Prevent it: Give a benzo (midazolam 1-2 mg) before or with ketamine\n"
            + "• Treat it: Reassure the patient, keep the environment quiet and dim, give more midazolam if severe\n\n"
            + "##Red flags:##\n\n"
            + "• Severe hypertension (SBP >200) in a patient with known intracranial pathology\n"
            + "• Laryngospasm → Can't ventilate → Suction, bag aggressively, give succinylcholine if needed",
            dose: "##RSI (induction):##\n\n"
            + "• 1-2 mg/kg IV (typical adult: 100-150 mg)\n"
            + "• Onset: 30-60 seconds\n"
            + "• Duration: 10-15 minutes\n\n"
            + "##Procedural sedation:##\n\n"
            + "• IV: 0.5-1 mg/kg (lower dose for sedation, higher for dissociation)\n"
            + "• IM: 4-5 mg/kg (kids who won't let you start an IV)\n"
            + "• Onset IM: 3-5 minutes\n\n"
            + "##Analgesia (sub-dissociative dose):##\n\n"
            + "• 0.1-0.3 mg/kg IV (10-30 mg typical adult)\n"
            + "• Can repeat every 15-20 minutes\n"
            + "• Provides analgesia without full dissociation\n\n"
            + "##ICU sedation (continuous infusion):##\n\n"
            + "• Loading dose: 0.5-1 mg/kg IV\n"
            + "• Infusion: 0.05-0.4 mg/kg/hr (titrate to effect)\n\n"
            + "##Pediatric procedural sedation:##\n\n"
            + "• IV: 1-2 mg/kg\n"
            + "• IM: 4-5 mg/kg (uncooperative child)\n\n"
            + "##Administration:##\n\n"
            + "• Can give IV or IM (unique among induction agents)\n"
            + "• Consider giving atropine or glycopyrrolate to reduce secretions\n"
            + "• Give midazolam 1-2 mg before ketamine to prevent emergence reactions",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Dissociative anesthetic, NMDA receptor antagonist.\n\n"
            + "The only induction agent that raises blood pressure and preserves respiratory drive.",
            indications: "##Primary indications:##\n\n"
            + "• RSI induction (especially in hypotensive, hypovolemic, or bronchospastic patients)\n"
            + "• Procedural sedation (pediatrics and adults)\n"
            + "• Acute pain management (sub-dissociative doses)\n"
            + "• Agitated or combative patients (IM route)\n"
            + "• Status asthmaticus (refractory bronchospasm)\n\n"
            + "##You'll reach for ketamine when:##\n\n"
            + "• Patient is hypotensive and needs intubation (trauma, sepsis)\n"
            + "• Patient is in severe respiratory distress from asthma or COPD\n"
            + "• You need to sedate an uncooperative patient and can't start an IV\n"
            + "• Patient needs analgesia but opioids aren't working or are causing respiratory depression\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Trauma patient with femur fracture, BP 80/50, needs intubation → Ketamine 1-2 mg/kg (not etomidate, which would drop BP further)\n"
            + "• Asthmatic in status, tiring out, needs intubation → Ketamine (bronchodilation + preserves respiratory drive)\n"
            + "• Combative intoxicated patient, no IV access → Ketamine 4-5 mg/kg IM",
            contraindiction: "##Absolute:##\n\n"
            + "• Severe uncontrolled hypertension (SBP >200)\n"
            + "• Acute coronary syndrome or recent MI (sympathetic surge can worsen ischemia)\n"
            + "• Elevated intracranial pressure (can increase ICP further)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Intracranial mass or bleed (historically contraindicated, but evidence is mixed)\n"
            + "• Severe psychiatric illness (schizophrenia, active psychosis)\n"
            + "• Globe injury (can increase intraocular pressure)\n"
            + "• Porphyria\n\n"
            + "##Critical safety point:## The old dogma was that ketamine increases ICP and should never be used in head injury. Recent evidence suggests this isn't true if the patient is adequately ventilated and sedated. Many centers now use ketamine for RSI in head trauma, but check your local protocols.",
            onSet: "30-60 sec (IV), 3-5 min (IM)",
            halfLife: "2-3 hrs",
            duration: "10-15 min (IV), 15-30 min (IM)",
            absorbtion: "Rapid",
            distribution: "Lipophilic (rapid CNS penetration)",
            metaBolism: "Liver (CYP metabolism to norketamine)",
            excretion: "Urine",
            pregnancyExplanation: "Category not formally assigned. Generally considered safe for short-term use in pregnancy. Used routinely in obstetric anesthesia.",
            criticalPearls: "##How to use ketamine safely:##\n\n"
            + "##Before giving:##\n\n"
            + "• Check blood pressure (avoid if SBP >200 or acute MI)\n"
            + "• Consider giving midazolam 1-2 mg to prevent emergence reactions\n"
            + "• Consider atropine or glycopyrrolate to reduce secretions\n"
            + "• Have suction ready (ketamine increases secretions)\n\n"
            + "##During administration:##\n\n"
            + "• Give IV push over 30-60 seconds (or IM if no IV access)\n"
            + "• Patient may have nystagmus and a blank stare (this is normal)\n"
            + "• Airway reflexes are preserved, but have bag-mask ready\n\n"
            + "##After giving:##\n\n"
            + "• Monitor BP and heart rate (expect them to rise)\n"
            + "• Watch for laryngospasm (rare, but life-threatening)\n"
            + "• Keep environment quiet and calm during emergence\n"
            + "• If emergence reaction occurs → Give more midazolam, reassure patient\n\n"
            + "##The unique advantages:##\n\n"
            + "1. Raises blood pressure (only induction agent that does this)\n"
            + "2. Preserves respiratory drive (patient keeps breathing)\n"
            + "3. Bronchodilation (opens airways)\n"
            + "4. Can give IM (no IV needed)\n"
            + "5. Provides analgesia + sedation + amnesia\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using ketamine in a hypertensive patient with acute MI (can worsen ischemia)\n"
            + "• Not giving a benzo first (leads to bad emergence reactions)\n"
            + "• Not having suction ready (patients drool a lot on ketamine)\n"
            + "• Thinking ketamine is contraindicated in head injury (outdated dogma)\n\n"
            + "##The takeaway:##\n\n"
            + "Ketamine is the Swiss Army knife of sedatives — it sedates, provides analgesia, raises blood pressure, opens airways, and can be given IM. It's perfect for hypotensive patients, asthmatics, and uncooperative patients. Give a benzo first to prevent bad trips, and keep suction handy."
        ),
        
        // 31. Labetalol
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Labetalol",
            brandName: "Trandate ®",
            mechansim: "Labetalol is a combined non-selective beta-blocker and selective alpha-1 blocker.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of labetalol as the dual-action blood pressure medication — it blocks both beta receptors (slows heart rate) and alpha-1 receptors (dilates vessels). This dual mechanism drops blood pressure WITHOUT causing reflex tachycardia.\n\n"
            + "##How it works:##\n\n"
            + "• Beta blockade (β1 & β2): Slows heart rate, decreases cardiac output\n"
            + "• Alpha-1 blockade: Vasodilation → Lowers systemic vascular resistance\n"
            + "• Net effect: Blood pressure drops smoothly without reflex tachycardia\n\n"
            + "##Key concept:## Most vasodilators (hydralazine, nitroglycerin) cause reflex tachycardia because the body tries to compensate for the drop in BP. Labetalol's beta blockade prevents this reflex, making it ideal for hypertensive emergencies where you want controlled BP reduction without stressing the heart.\n\n"
            + "##High-yield point:## Labetalol is the first-line drug for hypertensive emergency in pregnancy (preeclampsia/eclampsia) and for acute ischemic stroke BP management. It's safe, predictable, and doesn't cause sudden drops in BP.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypotension (dose-dependent)\n"
            + "• Bradycardia\n"
            + "• Dizziness\n"
            + "• Fatigue\n\n"
            + "##Serious:##\n\n"
            + "• Severe bradycardia or heart block\n"
            + "• Bronchospasm (in asthmatics — beta-2 blockade)\n"
            + "• Severe hypotension\n"
            + "• Heart failure exacerbation (negative inotrope)\n\n"
            + "##Why labetalol is safer than pure vasodilators:##\n\n"
            + "##Pure vasodilators## (hydralazine, nitroprusside) can cause:\n"
            + "• Reflex tachycardia → Increases myocardial oxygen demand\n"
            + "• Unpredictable BP drops\n\n"
            + "Labetalol avoids this by blocking the reflex tachycardia.\n\n"
            + "##Red flags:##\n\n"
            + "• HR <50 bpm → Hold dose, risk of bradycardia\n"
            + "• SBP drops >25% or <140 mmHg → May be overshooting target\n"
            + "• Wheezing after labetalol → Bronchospasm (beta-2 blockade)",
            dose: "##Hypertensive Emergency:##\n\n"
            + "• Initial: 10-20 mg IV push over 2 minutes\n"
            + "• Repeat: 20-80 mg IV q10min (double the dose each time)\n"
            + "• Max cumulative dose: 300 mg\n\n"
            + "##Infusion (if boluses not effective):##\n\n"
            + "• Start: 0.5-2 mg/min IV infusion\n"
            + "• Titrate to effect\n"
            + "• Max: 300 mg total\n\n"
            + "##Acute Ischemic Stroke BP Management:##\n\n"
            + "• Goal: SBP <185 mmHg, DBP <110 mmHg (for tPA eligibility)\n"
            + "• Give 10-20 mg IV over 1-2 minutes\n"
            + "• May repeat every 10 minutes\n\n"
            + "##Preeclampsia/Eclampsia:##\n\n"
            + "• 20 mg IV, then 40 mg, then 80 mg q10min PRN\n"
            + "• Goal: SBP 140-160 mmHg, DBP 90-105 mmHg\n\n"
            + "##Administration:##\n\n"
            + "• Give slowly over 2 minutes (rapid push can cause severe hypotension)\n"
            + "• Monitor BP every 5-10 minutes",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "##Combined alpha and beta blocker.##\n\n"
            + "The dual-action antihypertensive for hypertensive emergencies, especially in pregnancy and stroke.",
            indications: "##Standard Indications:##\n\n"
            + "• Hypertensive emergency\n"
            + "• Hypertensive urgency\n"
            + "• Acute ischemic stroke BP management (for tPA eligibility)\n"
            + "• Preeclampsia/eclampsia\n"
            + "• Hypertensive encephalopathy\n\n"
            + "When to reach for labetalol:##\n\n"
            + "• SBP >180 mmHg or DBP >120 mmHg with end-organ damage\n"
            + "• Stroke patient needs BP lowering for tPA\n"
            + "• Pregnant patient with severe hypertension\n"
            + "• Need controlled BP reduction without reflex tachycardia\n\n"
            + "##Clinical clues:## Severe hypertension with headache, chest pain, stroke, or seizures (eclampsia).",
            contraindiction: "##Absolute:##\n\n"
            + "• Asthma or severe COPD (beta blockade → bronchospasm)\n"
            + "• 2nd or 3rd degree heart block\n"
            + "• Severe bradycardia (HR <45-50 bpm)\n"
            + "• Decompensated heart failure\n"
            + "• Cardiogenic shock\n\n"
            + "##Caution:##\n\n"
            + "• Cocaine-induced hypertension (pure beta blockade can worsen — use benzodiazepines first)\n"
            + "• Pheochromocytoma (can cause paradoxical hypertension)\n"
            + "• Concurrent calcium channel blockers (risk of severe bradycardia/hypotension)\n\n"
            + "##Important:## In cocaine intoxication, avoid pure beta blockers (can cause unopposed alpha stimulation → worse hypertension). Labetalol has some alpha blockade, so it's safer than pure beta blockers, but benzodiazepines are still first-line.",
            onSet: "2-5 min (IV)",
            halfLife: "3-8 hours",
            duration: "2-4 hours (IV); up to 16-18 hours (oral)",
            absorbtion: "Well absorbed orally (25% bioavailability due to first-pass metabolism)",
            distribution: "Widely distributed",
            metaBolism: "Hepatic (extensive first-pass)",
            excretion: "Urine (55-60% as metabolites)",
            pregnancyExplanation: "##Pregnancy Category C:## However, labetalol is considered SAFE in pregnancy and is first-line for severe hypertension in preeclampsia/eclampsia. Widely used with good safety profile.",
            criticalPearls: "##Dual Action##\n\n"
            + "• ##Alpha-1 blockade## (vasodilation) + ##Beta blockade## (rate control)\n"
            + "• Ratio: 1:7 (alpha:beta) IV, 1:3 (alpha:beta) oral\n"
            + "• This means more beta blockade than alpha blockade\n\n"
            + "##Does NOT Cause Reflex Tachycardia##\n\n"
            + "• Unlike pure vasodilators (hydralazine, nitroprusside)\n"
            + "• Beta blockade prevents the reflex increase in heart rate\n"
            + "• Smoother, more controlled BP reduction\n\n"
            + "##Safe in Pregnancy##\n\n"
            + "• First-line for severe hypertension in pregnancy\n"
            + "• Used for preeclampsia/eclampsia\n"
            + "• Goal: SBP 140-160 mmHg, DBP 90-105 mmHg (don't drop too low — can compromise placental perfusion)\n\n"
            + "##Stroke BP Management:##\n\n"
            + "• For tPA eligibility: SBP <185, DBP <110\n"
            + "• Labetalol 10-20 mg IV q10min until goal\n"
            + "• Alternative: Nicardipine infusion\n\n"
            + "##Labetalol vs. Hydralazine vs. Nicardipine:##\n\n"
            + "| Feature | Labetalol | Hydralazine | Nicardipine |\n"
            + "|---------|-----------|-------------|-------------|\n"
            + "| ##Mechanism## | α+β blocker | Vasodilator | CCB |\n"
            + "| ##Reflex tachy## | No ❌ | Yes ✅ | Mild |\n"
            + "| ##Onset## | 2-5 min | 10-30 min | 5-10 min |\n"
            + "| ##Pregnancy## | Safe ✅ | Safe ✅ | Safe ✅ |\n"
            + "| ##Asthma## | Avoid ❌ | OK ✅ | OK ✅ |\n"
            + "| ##Titration## | Boluses | Boluses | Infusion |\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Labetalol is the go-to drug for hypertensive emergency, especially in pregnancy and stroke. Its dual alpha and beta blockade drops blood pressure smoothly without reflex tachycardia. Give 10-20 mg IV, double the dose every 10 minutes until BP is controlled. Avoid in asthma (beta blockade → bronchospasm) and cocaine intoxication (use benzos first).\n\n"
            + "##High-yield point:## Labetalol is first-line for severe hypertension in pregnancy (preeclampsia/eclampsia) and for acute ischemic stroke BP management. It's safer than pure vasodilators because it doesn't cause reflex tachycardia."
        ),
        
        // 32. Levalbuterol (Updated)
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Levalbuterol",
            brandName: "Xopenex",
            mechansim: "Levalbuterol is the pure R-isomer (active form) of albuterol — it's the same drug, just without the inactive S-isomer.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of levalbuterol as the \"cleaner\" albuterol — same bronchodilator effect, but with fewer side effects. Albuterol is a racemic mixture (50% R-isomer, 50% S-isomer), but only the R-isomer binds to β2 receptors. The S-isomer doesn't do anything useful and may actually cause inflammation. Levalbuterol is just the R-isomer, so you get the same bronchodilation with less tachycardia and tremors.\n\n"
            + "##How it works:##\n\n"
            + "• Pure R-isomer binds to β2 receptors → Bronchodilation (same as albuterol)\n"
            + "• No S-isomer → Less inflammation, fewer side effects\n"
            + "• More β2-selective → Less β1 stimulation → Less tachycardia\n"
            + "• Same mechanism as albuterol (increases cAMP)\n\n"
            + "##The key:## Levalbuterol is essentially the same drug as albuterol, just purified. It causes less tachycardia and tremors because it's more β2-selective. However, it's more expensive, so it's usually reserved for patients who can't tolerate albuterol's side effects (cardiac patients, excessive tachycardia).\n\n"
            + "##High-yield point:## Levalbuterol is half the dose of albuterol (0.63 mg levalbuterol = 1.25 mg albuterol) because you're only getting the active isomer. Use it when albuterol causes excessive tachycardia or tremors.",
            adverseEffects: "##Common:##\n\n"
            + "• Tremor (less than albuterol)\n"
            + "• Tachycardia (less than albuterol)\n"
            + "• Nervousness\n"
            + "• Headache\n\n"
            + "##Serious:##\n\n"
            + "• Arrhythmias (rare, less than albuterol)\n"
            + "• Paradoxical bronchospasm (rare)\n\n"
            + "##The advantage:##\n\n"
            + "Levalbuterol causes fewer side effects than albuterol because it's more β2-selective (less β1 stimulation). This makes it preferred in cardiac patients or when albuterol causes excessive tachycardia.\n\n"
            + "##Red flags:##\n\n"
            + "• HR >120 (still possible, but less likely than albuterol)\n"
            + "• New arrhythmias",
            dose: "##Acute Bronchospasm:##\n\n"
            + "• 0.63-1.25 mg nebulized every 6-8 hours as needed\n"
            + "• For severe exacerbations: Can repeat every 20 minutes × 3 doses\n\n"
            + "##Dose equivalence:##\n\n"
            + "• 0.63 mg levalbuterol ≈ 1.25 mg albuterol\n"
            + "• 1.25 mg levalbuterol ≈ 2.5 mg albuterol\n\n"
            + "##Administration:##\n\n"
            + "• Nebulized: Mix with 3-4 mL normal saline\n"
            + "• Same administration as albuterol",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Short-acting β2-adrenergic agonist (SABA), bronchodilator.\n\n"
            + "Purified R-isomer of albuterol with fewer side effects. Used when albuterol causes excessive tachycardia or tremors.",
            indications: "##Primary indications:##\n\n"
            + "• Acute asthma exacerbation (when albuterol causes excessive side effects)\n"
            + "• COPD exacerbation (cardiac patients)\n"
            + "• Patients intolerant of albuterol (excessive tachycardia, tremors)\n\n"
            + "##You'll reach for levalbuterol when:##\n\n"
            + "• Patient needs bronchodilation but albuterol causes excessive tachycardia\n"
            + "• Cardiac patient with bronchospasm (less tachycardia risk)\n"
            + "• Patient complains of severe tremors with albuterol\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Cardiac patient with asthma, albuterol causes HR 140 → Switch to levalbuterol\n"
            + "• Patient with severe tremors from albuterol → Levalbuterol 0.63 mg\n"
            + "• COPD patient with CAD, needs bronchodilation → Levalbuterol (less cardiac risk)",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity to levalbuterol\n"
            + "• Severe hypokalemia\n"
            + "• Symptomatic tachyarrhythmias\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Coronary artery disease (still can cause tachycardia, just less likely)\n"
            + "• Heart failure\n\n"
            + "##Critical safety point:## Levalbuterol still causes tachycardia and can worsen cardiac conditions — it's just less likely than albuterol. Monitor heart rate closely, especially in cardiac patients.",
            onSet: "5-15 min",
            halfLife: "3-4 hrs",
            duration: "4-6 hrs",
            absorbtion: "Rapid (nebulized)",
            distribution: "Tissues",
            metaBolism: "Hepatic",
            excretion: "Urine",
            pregnancyExplanation: "Category C. Use in pregnancy only if benefits outweigh risks. Similar to albuterol.",
            criticalPearls: "##How to use levalbuterol safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Consider if patient really needs levalbuterol (more expensive than albuterol)\n"
            + "• Check heart rate (still monitor for tachycardia)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor heart rate (less tachycardia than albuterol, but still possible)\n"
            + "• Monitor response (same bronchodilation as albuterol)\n\n"
            + "##Levalbuterol vs. Albuterol:##\n\n"
            + "##Levalbuterol:##\n\n"
            + "• Pure R-isomer (active form)\n"
            + "• Less tachycardia and tremors\n"
            + "• More expensive\n"
            + "• Preferred in cardiac patients or if albuterol causes excessive side effects\n\n"
            + "##Albuterol:##\n\n"
            + "• Racemic mixture (R + S isomers)\n"
            + "• More tachycardia and tremors\n"
            + "• Less expensive\n"
            + "• First-line for most patients\n\n"
            + "##Bottom line:## Use albuterol first-line. Use levalbuterol if albuterol causes excessive tachycardia or tremors, or in cardiac patients.\n\n"
            + "##Dose conversion:##\n\n"
            + "Levalbuterol is half the dose of albuterol:\n\n"
            + "• 0.63 mg levalbuterol ≈ 1.25 mg albuterol\n"
            + "• 1.25 mg levalbuterol ≈ 2.5 mg albuterol\n\n"
            + "This is because levalbuterol is pure R-isomer, while albuterol is 50% R-isomer.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using levalbuterol as first-line (more expensive, use albuterol first)\n"
            + "• Not monitoring heart rate (still can cause tachycardia)\n"
            + "• Using wrong dose (need half the albuterol dose)\n\n"
            + "##The takeaway:##\n\n"
            + "Levalbuterol is the pure R-isomer of albuterol — same bronchodilation, fewer side effects. It causes less tachycardia and tremors because it's more β2-selective. Use it when albuterol causes excessive side effects or in cardiac patients. It's more expensive, so use albuterol first-line."
        ),
        
        // 33. Levetiracetam
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Levetiracetam",
            brandName: "Keppra ®",
            mechansim: "Levetiracetam is an anticonvulsant with a unique mechanism that modulates synaptic vesicle protein 2A (SV2A) to reduce neurotransmitter release.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of levetiracetam as the clean anticonvulsant. Unlike phenytoin, it has minimal drug interactions, no hepatic metabolism, no need for loading dose adjustments, and no need to check levels. It's the first-line choice for seizure prophylaxis in TBI and for most status epilepticus after benzos.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to synaptic vesicle protein 2A (SV2A)\n"
            + "• Modulates neurotransmitter release\n"
            + "• Inhibits burst firing without affecting normal neuronal excitability\n"
            + "• Does NOT affect sodium channels, GABA, or glutamate (unlike other AEDs)\n\n"
            + "##The key:## Levetiracetam is renally cleared with minimal drug interactions. No need to check levels in most cases. It's preferred over phenytoin for seizure prophylaxis in TBI and after hemorrhagic stroke.\n\n"
            + "##High-yield point:## Levetiracetam can cause behavioral changes, including aggression, irritability, and psychosis — known as 'Keppra rage.' This is more common in patients with prior psychiatric history. Monitor and consider alternative if severe behavioral changes occur.",
            adverseEffects: "##Common:##\n\n"
            + "• Somnolence, drowsiness\n"
            + "• Dizziness\n"
            + "• Behavioral changes, irritability\n"
            + "• Headache\n\n"
            + "##Serious:##\n\n"
            + "• 'Keppra rage' — aggression, psychosis, suicidal ideation\n"
            + "• Severe skin reactions (rare)\n"
            + "• Thrombocytopenia (rare)\n\n"
            + "##The 'Keppra rage' problem:##\n\n"
            + "About 10-15% of patients experience behavioral side effects (irritability, aggression, mood changes). Risk factors include prior psychiatric history and high doses. If severe, switch to alternative anticonvulsant.\n\n"
            + "##Red flags:##\n\n"
            + "• New aggression, psychosis, or suicidal thoughts (Keppra rage)\n"
            + "• Severe rash (discontinue)\n"
            + "• New thrombocytopenia",
            dose: "##Status Epilepticus (after benzos):##\n\n"
            + "• Load: 20-60 mg/kg IV (max 4500 mg)\n"
            + "• Common: 1000-1500 mg IV load\n"
            + "• Infusion rate: Give over 15 minutes\n\n"
            + "##Seizure Prophylaxis:##\n\n"
            + "• 500-1500 mg IV or PO twice daily\n"
            + "• TBI: 500-1000 mg IV q12h for 7 days\n\n"
            + "##Maintenance:##\n\n"
            + "• 500-1500 mg twice daily\n"
            + "• Max: 3000 mg/day\n\n"
            + "##Renal dosing:##\n\n"
            + "• CrCl 30-50: 250-750 mg q12h\n"
            + "• CrCl <30: 250-500 mg q12h\n"
            + "• HD: Give supplemental dose after dialysis",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Anticonvulsant (SV2A modulator).\n\n"
            + "First-line for seizure prophylaxis in TBI and second-line (after benzos) for status epilepticus.",
            indications: "##Primary indications:##\n\n"
            + "• Status epilepticus (second-line after benzodiazepines)\n"
            + "• Seizure prophylaxis (TBI, post-craniotomy, hemorrhagic stroke)\n"
            + "• Partial and generalized seizures (maintenance)\n\n"
            + "##You'll reach for levetiracetam when:##\n\n"
            + "• Status epilepticus not controlled by benzos → Load levetiracetam\n"
            + "• TBI requiring seizure prophylaxis → Levetiracetam preferred over phenytoin\n"
            + "• Need anticonvulsant with minimal drug interactions\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Status epilepticus, lorazepam given → Levetiracetam 1500 mg IV load\n"
            + "• Severe TBI → Levetiracetam 1000 mg IV q12h for 7 days\n"
            + "• SAH for seizure prophylaxis → Levetiracetam 500 mg IV q12h",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Prior psychiatric history (higher risk of behavioral side effects)\n"
            + "• Severe renal impairment (reduce dose)\n\n"
            + "##Critical safety point:## Levetiracetam is generally very safe with a clean side effect profile, but behavioral changes can occur. Monitor for aggression, irritability, and mood changes, especially in patients with psychiatric history.",
            onSet: "Rapid (IV)",
            halfLife: "6-8 hrs",
            duration: "12-24 hrs (clinical effect)",
            absorbtion: "Rapid (IV and PO)",
            distribution: "Widely distributed, low protein binding",
            metaBolism: "Minimal hepatic (non-CYP)",
            excretion: "Urine (66% unchanged)",
            pregnancyExplanation: "Category C. Crosses placenta. Use if benefits outweigh risks. Generally considered safer than many other AEDs.",
            criticalPearls: "##How to use levetiracetam safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check renal function (renally cleared)\n"
            + "• Ask about psychiatric history (higher risk of behavioral effects)\n"
            + "• No need to check drug levels routinely\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor for behavioral changes ('Keppra rage')\n"
            + "• Monitor for sedation\n"
            + "• No need for level monitoring in most cases\n\n"
            + "##Levetiracetam vs. Phenytoin:##\n\n"
            + "##Levetiracetam advantages:##\n\n"
            + "• No drug interactions (phenytoin has many)\n"
            + "• No hepatic metabolism (safe in liver disease)\n"
            + "• No need for level monitoring\n"
            + "• No cardiovascular toxicity (phenytoin can cause hypotension, arrhythmias)\n"
            + "• Better for TBI (phenytoin may worsen cognitive outcomes)\n\n"
            + "##Phenytoin advantages:##\n\n"
            + "• Longer history of use\n"
            + "• Some prefer for status epilepticus\n"
            + "• Cheaper (in some settings)\n\n"
            + "##Bottom line:## Levetiracetam is preferred for most indications due to its clean profile.\n\n"
            + "##Status Epilepticus protocol:##\n\n"
            + "1. Benzodiazepine first (lorazepam 0.1 mg/kg or midazolam 0.2 mg/kg IM)\n"
            + "2. If seizures continue → Levetiracetam 60 mg/kg IV (max 4500 mg) or fosphenytoin/valproate\n"
            + "3. If still seizing → Refractory status → Propofol or midazolam drip\n\n"
            + "##TBI seizure prophylaxis:##\n\n"
            + "• Levetiracetam preferred over phenytoin\n"
            + "• Dose: 500-1000 mg IV q12h\n"
            + "• Duration: 7 days (discontinue if no seizures)\n"
            + "• Phenytoin may worsen cognitive outcomes in TBI\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using phenytoin over levetiracetam in TBI (levetiracetam preferred)\n"
            + "• Continuing prophylaxis beyond 7 days in TBI (not beneficial)\n"
            + "• Not reducing dose in renal failure\n"
            + "• Not monitoring for behavioral changes\n\n"
            + "##The takeaway:##\n\n"
            + "Levetiracetam is the clean anticonvulsant — minimal drug interactions, no hepatic metabolism, no need for level monitoring. It's first-line for TBI seizure prophylaxis and second-line (after benzos) for status epilepticus. Watch for 'Keppra rage' (behavioral changes), especially in patients with psychiatric history. Renally dosed."
        ),
        
        // 34. Levothyroxine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Levothyroxine",
            brandName: "Synthroid, T4",
            mechansim: "Levothyroxine is a synthetic form of thyroxine (T4) that is converted to active T3 in tissues, regulating metabolism, temperature, and cardiovascular function.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of levothyroxine as the metabolic resuscitator. In myxedema coma (severe hypothyroidism), the body's metabolism is critically slowed — hypothermia, bradycardia, hypotension, altered mental status. Levothyroxine restores metabolic function. In brain-dead organ donors, it's part of the hormone replacement protocol to maintain organ viability.\n\n"
            + "##How it works:##\n\n"
            + "• T4 is converted to active T3 in peripheral tissues\n"
            + "• T3 binds nuclear receptors → Regulates gene transcription\n"
            + "• Increases metabolic rate, oxygen consumption, heat production\n"
            + "• Positive inotropic and chronotropic effects on heart\n\n"
            + "##The key:## In critical care, levothyroxine is used for myxedema coma (give with hydrocortisone — stress doses, as hypothyroidism may mask underlying adrenal insufficiency) and for brain-dead organ donors (maintains hemodynamic stability and organ viability).\n\n"
            + "##High-yield point:## In myxedema coma, always give stress-dose steroids (hydrocortisone 100 mg IV) BEFORE or WITH levothyroxine. Many patients have concurrent adrenal insufficiency, and thyroid replacement can increase cortisol metabolism, precipitating adrenal crisis.",
            adverseEffects: "##Common (if overdosed):##\n\n"
            + "• Tachycardia, palpitations\n"
            + "• Heat intolerance, sweating\n"
            + "• Tremor, anxiety\n"
            + "• Weight loss\n\n"
            + "##Serious:##\n\n"
            + "• Arrhythmias (especially in cardiac patients)\n"
            + "• Angina, MI (in patients with CAD)\n"
            + "• Adrenal crisis (if adrenal insufficiency present and not covered)\n\n"
            + "##The adrenal crisis risk:##\n\n"
            + "Hypothyroidism can mask adrenal insufficiency. Giving thyroid hormone increases cortisol metabolism. If adrenal insufficiency is present, this can precipitate adrenal crisis. Always give stress-dose steroids with levothyroxine for myxedema coma.\n\n"
            + "##Red flags:##\n\n"
            + "• New arrhythmias after starting treatment\n"
            + "• Chest pain (coronary patients)\n"
            + "• Signs of adrenal crisis (hypotension, shock)",
            dose: "##Myxedema Coma:##\n\n"
            + "• Load: 200-400 mcg IV (or 300-500 mcg PO via NGT if IV unavailable)\n"
            + "• Then: 50-100 mcg IV daily\n"
            + "• MUST give with hydrocortisone 100 mg IV q8h\n\n"
            + "##Brain-Dead Organ Donors:##\n\n"
            + "• Infusion: 5-50 mcg/hr IV (titrate to effect)\n"
            + "• Part of hormone replacement protocol (with vasopressin, methylprednisolone)\n\n"
            + "##Hypothyroidism (outpatient):##\n\n"
            + "• Start: 1.6 mcg/kg/day PO\n"
            + "• Elderly/cardiac: Start 25-50 mcg/day, titrate slowly\n\n"
            + "##Administration:##\n\n"
            + "• IV preferred for myxedema coma (poor GI absorption)\n"
            + "• IV dose is ~75% of PO dose\n"
            + "• Give on empty stomach (PO)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.A),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.A),
            DrugClass: "Thyroid hormone (T4).\n\n"
            + "Used for hypothyroidism, myxedema coma, and brain-dead organ donor management.",
            indications: "##Primary indications:##\n\n"
            + "• Myxedema coma (critical care emergency)\n"
            + "• Brain-dead organ donor management\n"
            + "• Hypothyroidism (maintenance)\n\n"
            + "##You'll reach for IV levothyroxine when:##\n\n"
            + "• Myxedema coma — altered mental status, hypothermia, bradycardia\n"
            + "• Brain-dead organ donor requiring hormone replacement\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Elderly patient with hypothermia (32°C), bradycardia, AMS, elevated TSH → Myxedema coma → Levothyroxine IV + hydrocortisone\n"
            + "• Brain-dead organ donor with hemodynamic instability → Hormone replacement protocol (T4 + vasopressin + methylprednisolone)",
            contraindiction: "##Absolute:##\n\n"
            + "• Untreated thyrotoxicosis (would worsen)\n"
            + "• Untreated adrenal insufficiency (give steroids first)\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Coronary artery disease (can precipitate angina/MI)\n"
            + "• Elderly (start low, go slow)\n"
            + "• Recent MI (wait 4-6 weeks if possible)\n\n"
            + "##Critical safety point:## Always give stress-dose steroids (hydrocortisone 100 mg IV) with levothyroxine for myxedema coma. Many patients have coexisting adrenal insufficiency.",
            onSet: "6-8 hrs (IV), days (clinical effect)",
            halfLife: "6-7 days",
            duration: "Long (due to long half-life)",
            absorbtion: "Variable (PO), 100% (IV)",
            distribution: "Highly protein bound (99%+)",
            metaBolism: "Liver (deiodination to T3)",
            excretion: "Feces (20%), urine (20%)",
            pregnancyExplanation: "Category A. Safe in pregnancy. Essential for fetal brain development. Continue or increase dose in pregnancy.",
            criticalPearls: "##How to use levothyroxine safely in critical care:##\n\n"
            + "##Myxedema Coma:##\n\n"
            + "Myxedema coma is decompensated hypothyroidism — a medical emergency with high mortality (30-60%).\n\n"
            + "##Clinical features:##\n\n"
            + "• Hypothermia (often <35°C)\n"
            + "• Altered mental status → coma\n"
            + "• Bradycardia\n"
            + "• Hypotension\n"
            + "• Hyponatremia\n"
            + "• Hypoglycemia\n\n"
            + "##Treatment:##\n\n"
            + "1. ##Supportive care:## Warm slowly (passive rewarming), IV fluids (avoid hypotonic), intubate if needed\n"
            + "2. ##Hydrocortisone 100 mg IV q8h## — Give BEFORE or WITH levothyroxine (adrenal crisis risk)\n"
            + "3. ##Levothyroxine 200-400 mcg IV load,## then 50-100 mcg IV daily\n"
            + "4. Can add T3 (liothyronine) 5-20 mcg IV q8h in severe cases\n\n"
            + "##Why steroids first:##\n\n"
            + "Hypothyroidism can mask adrenal insufficiency. Thyroid hormone replacement increases cortisol metabolism. Without steroid coverage, this can precipitate adrenal crisis.\n\n"
            + "##Brain-Dead Organ Donor Management:##\n\n"
            + "##Brain death## causes hormonal collapse. Hormone replacement protocol:\n\n"
            + "• Levothyroxine 5-50 mcg/hr IV (or T3)\n"
            + "• Vasopressin (diabetes insipidus from absent ADH)\n"
            + "• Methylprednisolone (adrenal support)\n"
            + "• Insulin (if hyperglycemic)\n\n"
            + "##Goal:## Maintain hemodynamic stability to preserve organ viability for transplant.\n\n"
            + "##T4 vs. T3:##\n\n"
            + "• T4 (levothyroxine) — longer acting, must be converted to T3\n"
            + "• T3 (liothyronine) — immediately active, shorter half-life\n"
            + "• Some protocols add T3 for faster effect in myxedema coma\n"
            + "• T3 is more expensive and less available\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not giving steroids before/with levothyroxine (adrenal crisis risk)\n"
            + "• Aggressive rewarming (can cause arrhythmias) — rewarm slowly\n"
            + "• Starting high doses in elderly/cardiac patients (can cause MI)\n"
            + "• Not recognizing myxedema coma (classic triad: hypothermia, AMS, bradycardia)\n\n"
            + "##The takeaway:##\n\n"
            + "##Levothyroxine is## synthetic T4 used for myxedema coma and organ donor management. For myxedema coma: Load 200-400 mcg IV, then 50-100 mcg IV daily — and ALWAYS give hydrocortisone 100 mg IV q8h with it. Brain-dead organ donors receive T4 infusion as part of hormone replacement to maintain organ viability."
        ),
        
        // 35. Lidocaine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Lidocaine",
            brandName: "Xylocaine ®",
            mechansim: "Lidocaine is a Class IB antiarrhythmic that blocks sodium channels in the heart, suppressing ventricular automaticity and stabilizing cardiac membranes.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of lidocaine as the ventricular rhythm stabilizer. It preferentially binds to sodium channels in ischemic/damaged myocardium, suppressing abnormal automaticity without significantly affecting normal conduction. It's the second-line agent for VT/VF when amiodarone fails or isn't available.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks sodium channels in cardiac tissue\n"
            + "• Shortens action potential duration\n"
            + "• Suppresses ventricular automaticity (especially in ischemic tissue)\n"
            + "• Minimal effect on normal conduction velocity\n"
            + "• Class IB = fast-in, fast-out sodium channel blocking\n\n"
            + "##The key:## Lidocaine is less effective than amiodarone for VT/VF, but it's an alternative when amiodarone fails or causes toxicity. It's also used for local anesthesia and as an adjunct for intubation (blunts cough/gag reflex).\n\n"
            + "##High-yield point:## Lidocaine toxicity presents with CNS symptoms first — perioral numbness, slurred speech, confusion, seizures. Then cardiovascular collapse. Reduce dose in liver failure and CHF (reduced clearance).",
            adverseEffects: "##Common:##\n\n"
            + "• Perioral numbness, paresthesias\n"
            + "• Dizziness, drowsiness\n"
            + "• Nausea\n\n"
            + "##Serious (toxicity):##\n\n"
            + "##CNS toxicity (dose-related):##\n\n"
            + "• Perioral numbness, metallic taste (early)\n"
            + "• Slurred speech, confusion\n"
            + "• Tremors, muscle twitching\n"
            + "• Seizures (late)\n\n"
            + "##Cardiovascular (severe toxicity):##\n\n"
            + "• Hypotension\n"
            + "• Bradycardia\n"
            + "• Heart block\n"
            + "• Cardiac arrest\n\n"
            + "##The progression of toxicity:## CNS symptoms appear before cardiovascular collapse. If patient develops perioral numbness or confusion, stop infusion immediately.\n\n"
            + "##Red flags:##\n\n"
            + "• Slurred speech, confusion (CNS toxicity — stop infusion)\n"
            + "• Seizures (severe toxicity — stop and give benzodiazepines)\n"
            + "• Hypotension/bradycardia (cardiovascular collapse)",
            dose: "##VT/VF:##\n\n"
            + "• Load: 1-1.5 mg/kg IV push\n"
            + "• May repeat 0.5-0.75 mg/kg every 5-10 min (max 3 mg/kg total)\n"
            + "• Infusion: 1-4 mg/min IV\n\n"
            + "##Maintenance infusion:##\n\n"
            + "• 1-4 mg/min IV\n"
            + "• Reduce dose in CHF and liver failure (reduced clearance)\n\n"
            + "##Intubation (blunting laryngeal reflexes):##\n\n"
            + "• 1.5 mg/kg IV 3 minutes before intubation\n\n"
            + "##Administration:##\n\n"
            + "• Give IV push (bolus) over 2 minutes\n"
            + "• Follow bolus with continuous infusion\n"
            + "• Monitor for CNS toxicity",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Class IB antiarrhythmic.\n\n"
            + "Also used as local anesthetic. Sodium channel blocker that suppresses ventricular automaticity.",
            indications: "##Primary indications:##\n\n"
            + "• Ventricular tachycardia with pulse\n"
            + "• Ventricular fibrillation (ACLS)\n"
            + "• Alternative to amiodarone in cardiac arrest\n\n"
            + "##Secondary uses:##\n\n"
            + "• Blunting laryngeal reflexes for intubation (especially with elevated ICP)\n"
            + "• Local anesthesia\n"
            + "• Neuropathic pain (IV infusion)\n\n"
            + "##You'll reach for lidocaine when:##\n\n"
            + "• VT/VF not responding to amiodarone\n"
            + "• Amiodarone contraindicated or unavailable\n"
            + "• RSI in patient with elevated ICP (blunts laryngeal reflexes)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Monomorphic VT → Cardioversion, if stable try amiodarone first, lidocaine if fails\n"
            + "• VF arrest → Amiodarone 300 mg, if recurrent VF → Lidocaine 1-1.5 mg/kg\n"
            + "• TBI patient needing intubation → Lidocaine 1.5 mg/kg IV before RSI",
            contraindiction: "##Absolute:##\n\n"
            + "• High-degree heart block (2nd or 3rd degree AV block)\n"
            + "• Stokes-Adams syndrome (syncope from heart block)\n"
            + "• Known hypersensitivity to amide local anesthetics\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Liver failure (reduced clearance)\n"
            + "• CHF (reduced clearance)\n"
            + "• Hypovolemia\n"
            + "• Elderly (more sensitive to toxicity)\n\n"
            + "##Critical safety point:## Lidocaine is hepatically cleared. In liver failure or CHF, clearance is reduced and toxicity is more likely. Reduce the maintenance infusion rate to 1-2 mg/min in these patients.",
            onSet: "Immediate (IV)",
            halfLife: "1-2 hrs (prolonged in CHF, liver failure)",
            duration: "10-20 min (bolus), continuous (infusion)",
            absorbtion: "100% (IV)",
            distribution: "Widely distributed, crosses BBB",
            metaBolism: "Liver (CYP3A4, CYP1A2)",
            excretion: "Urine (10% unchanged)",
            pregnancyExplanation: "Category B. Use if benefits outweigh risks. Crosses placenta.",
            criticalPearls: "##How to use lidocaine safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check for heart block (contraindicated in 2nd/3rd degree AV block)\n"
            + "• Assess liver function (reduce dose in liver failure)\n"
            + "• Consider if patient has CHF (reduce dose)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor for CNS toxicity (perioral numbness, confusion, slurred speech)\n"
            + "• Monitor cardiac rhythm\n"
            + "• If signs of toxicity → Stop infusion immediately\n\n"
            + "##Lidocaine vs. Amiodarone:##\n\n"
            + "##Amiodarone advantages:##\n\n"
            + "• More effective for VT/VF in cardiac arrest\n"
            + "• First-line in ACLS guidelines\n"
            + "• Longer duration of action\n\n"
            + "##Lidocaine advantages:##\n\n"
            + "• Faster onset\n"
            + "• Less hypotension\n"
            + "• Shorter half-life (toxicity clears faster)\n"
            + "• Alternative when amiodarone fails\n\n"
            + "##Lidocaine toxicity — the progression:##\n\n"
            + "##Lidocaine toxicity## follows a predictable pattern:\n\n"
            + "1. ##Perioral numbness, metallic taste## (early warning)\n"
            + "2. ##Lightheadedness, tinnitus##\n"
            + "3. ##Slurred speech, confusion##\n"
            + "4. ##Tremors, muscle twitching##\n"
            + "5. ##Seizures##\n"
            + "6. ##Cardiovascular collapse## (hypotension, bradycardia, arrest)\n\n"
            + "If toxicity develops:##\n\n"
            + "• Stop infusion immediately\n"
            + "• For seizures → Benzodiazepines (midazolam, lorazepam)\n"
            + "• For cardiovascular collapse → Intralipid 20% (lipid emulsion therapy)\n\n"
            + "##Dose reduction in high-risk patients:##\n\n"
            + "##Reduce maintenance## infusion to 1-2 mg/min (instead of 1-4 mg/min) in:\n\n"
            + "• Liver failure (reduced hepatic clearance)\n"
            + "• CHF (reduced hepatic blood flow → reduced clearance)\n"
            + "• Elderly\n"
            + "• Shock (reduced hepatic perfusion)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not reducing dose in liver failure/CHF (leads to toxicity)\n"
            + "• Ignoring early CNS symptoms (progresses to seizures)\n"
            + "• Using lidocaine in heart block (worsens block)\n"
            + "• Continuing infusion when signs of toxicity appear\n\n"
            + "##The takeaway:##\n\n"
            + "Lidocaine is a Class IB antiarrhythmic used for VT/VF as an alternative to amiodarone. Load with 1-1.5 mg/kg IV, then infuse at 1-4 mg/min. Reduce dose in liver failure and CHF. Watch for CNS toxicity (perioral numbness, confusion, seizures) — if it occurs, stop immediately. Contraindicated in high-degree heart block."
        ),
        
        // 36. Linezolid - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Linezolid",
            brandName: "Zyvox",
            mechansim: "Linezolid is an oxazolidinone that inhibits bacterial protein synthesis.\n\n"
            + "##The Mental Model:##\n"
            + "Think of linezolid as a precision brake on protein production.\n\n"
            + "It stops gram-positive bacteria from starting new proteins by blocking the ribosomal start signal.\n\n"
            + "##Key concept:## Human mitochondria use similar machinery, so linezolid can slow them too. That explains:\n"
            + "• Falling platelets\n"
            + "• Neuropathy\n"
            + "• Rising lactate",
            adverseEffects: "##Common:## GI upset, nausea.\n\n"
            + "##Serious:##\n"
            + "• Bone marrow suppression (thrombocytopenia, anemia)\n"
            + "• Serotonin syndrome (with SSRIs, tramadol)\n"
            + "• Lactic acidosis\n"
            + "• Peripheral/optic neuropathy (prolonged use)\n\n"
            + "##What toxicity## looks like:\n"
            + "• Platelets drop\n"
            + "• Hemoglobin falls\n"
            + "• Lactate creeps up\n"
            + "• Patient becomes jittery, hyperreflexic, and hot (serotonin syndrome)\n\n"
            + "##Red flags## to stop:\n"
            + "• Thrombocytopenia\n"
            + "• Rising lactate\n"
            + "• New confusion, clonus, or hyperthermia",
            dose: "600 mg IV or PO q12h.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Oxazolidinone antibiotic.\n\n"
            + "One of the few antibiotics that works just as well by mouth as by IV — powerful and deceptively easy to use.",
            indications: "Standard Indications:\n"
            + "• MRSA infections\n"
            + "• VRE infections\n"
            + "• Pneumonia (excellent lung penetration)\n\n"
            + "##You see linezolid## most often in:\n"
            + "• MRSA ventilator-associated pneumonia\n"
            + "• MRSA diabetic foot or soft-tissue infection\n"
            + "• VRE bacteremia or intra-abdominal infection\n\n"
            + "##What it covers:##\n"
            + "• MRSA\n"
            + "• VRE\n"
            + "• Resistant pneumococcus\n\n"
            + "##What it does nothing against:##\n"
            + "• Gram-negatives\n"
            + "• Anaerobes\n"
            + "• Atypicals",
            contraindiction: "Absolute: Use with MAOIs (severe interaction).\n\n"
            + "##High caution:## SSRIs, SNRIs, tramadol, meperidine → Serotonin syndrome risk.\n\n"
            + "##Before or early## in therapy:\n"
            + "• Review serotonergic meds\n"
            + "• Get baseline CBC",
            onSet: "Rapid onset",
            halfLife: "5 hours",
            duration: "Varies",
            absorbtion: "IV/PO (100% oral bioavailability — works equally well either route).",
            distribution: "Excellent tissue penetration, especially lungs.",
            metaBolism: "Hepatic (oxidation).",
            excretion: "Renal/Non-renal (no dose adjustment for renal failure).",
            pregnancyExplanation: "Use with caution in pregnancy. Monitor CBC closely.",
            criticalPearls: "##Mnemonic:## L.I.N.E.\n\n"
            + "• ##L##ungs (Pneumonia) & ##I##nhibits MAO (Serotonin Syndrome risk).\n"
            + "• ##N##europathy & ##E##rythrocytes (Thrombocytopenia).\n\n"
            + "##How to use safely:##\n\n"
            + "##Start linezolid when:##\n"
            + "• You need MRSA lung or VRE coverage\n"
            + "• Vancomycin or daptomycin isn't ideal\n\n"
            + "##While it's running:##\n"
            + "• Monitor platelets and hemoglobin\n"
            + "• Watch acid–base status (lactate)\n"
            + "• Ask about vision and neuropathy if therapy >2 weeks\n\n"
            + "If red flags appear:##\n"
            + "• Stop the drug and switch\n\n"
            + "##The Clinical Takeaway:##\n"
            + "Linezolid is a high-precision weapon for MRSA and VRE, especially in the lungs — but it quietly injures marrow, nerves, and mitochondria over time. Use it deliberately, monitor closely, and don't let it run longer than it has to."
        ),
        
        // 37. Lorazepam
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Lorazepam",
            brandName: "Ativan ®",
            mechansim: "Lorazepam is a benzodiazepine that enhances GABA (gamma-aminobutyric acid) activity in the brain.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of lorazepam as the reliable, predictable benzodiazepine. It's not as fast as midazolam, but it lasts longer (6-8 hours vs. 2-4 hours) and doesn't accumulate in renal or hepatic failure because it's metabolized via glucuronidation (no active metabolites).\n\n"
            + "##How it works:##\n\n"
            + "• Binds to GABA-A receptors → Increases chloride influx → Hyperpolarizes neurons → CNS depression\n"
            + "• Produces anxiolysis, sedation, amnesia, anticonvulsant effects, and muscle relaxation\n\n"
            + "##Key concept:## Lorazepam is the benzodiazepine of choice for status epilepticus and alcohol withdrawal in patients with liver or kidney disease because its metabolism is safer than other benzos.",
            adverseEffects: "##Common:##\n\n"
            + "• Sedation\n"
            + "• Respiratory depression (especially with opioids)\n"
            + "• Hypotension (less than midazolam)\n"
            + "• Amnesia\n\n"
            + "##Serious:##\n\n"
            + "• Propylene glycol toxicity (with prolonged IV infusions)\n"
            + "• Paradoxical agitation (especially in elderly or ICU delirium)\n"
            + "• Accumulation with repeated dosing (long half-life)\n\n"
            + "##Propylene glycol toxicity:##\n\n"
            + "##Lorazepam IV contains## propylene glycol. With high doses or prolonged infusions (>1 mg/hr for days), watch for:\n"
            + "• Metabolic acidosis (anion gap)\n"
            + "• Rising lactate\n"
            + "• Acute kidney injury\n"
            + "• Altered mental status\n\n"
            + "##Red flags:##\n\n"
            + "• If the patient is on a lorazepam infusion and develops unexplained acidosis, stop the drip and switch to propofol or dexmedetomidine.",
            dose: "##Seizures/Status Epilepticus:##\n\n"
            + "• 4 mg IV (0.1 mg/kg), may repeat once after 5-10 minutes if seizure persists\n\n"
            + "##Alcohol Withdrawal:##\n\n"
            + "• CIWA protocol: 1-4 mg IV/PO q1-4h PRN based on symptoms\n"
            + "• Severe withdrawal: 2-4 mg IV q15-30min until calm (can require large cumulative doses)\n\n"
            + "##Sedation/Anxiety:##\n\n"
            + "• 0.5-2 mg IV/PO q4-6h PRN\n\n"
            + "##Procedural Sedation:##\n\n"
            + "• 1-2 mg IV prior to procedure",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.D),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.D),
            DrugClass: "##Benzodiazepine.##\n\n"
            + "One of the most commonly used benzos in the ICU for seizures and alcohol withdrawal.",
            indications: "##Standard Indications:##\n\n"
            + "• Status epilepticus (first-line)\n"
            + "• Alcohol withdrawal syndrome\n"
            + "• Anxiety\n"
            + "• Procedural sedation\n"
            + "• Agitation (though midazolam often preferred for acute sedation)\n\n"
            + "When to reach for lorazepam:##\n\n"
            + "• Status epilepticus (with midazolam)\n"
            + "• Severe alcohol withdrawal with autonomic instability\n"
            + "• Sedation in patients with liver or kidney disease (safer metabolism)\n"
            + "• Need for longer-acting sedation than midazolam provides\n\n"
            + "##Clinical clues:## Patient is seizing, tremulous, diaphoretic, hypertensive, tachycardic (withdrawal), or needs procedural sedation.",
            contraindiction: "##Absolute:##\n\n"
            + "• Acute narrow-angle glaucoma\n"
            + "• Severe respiratory depression without airway support\n\n"
            + "##Caution:##\n\n"
            + "• Sleep apnea (can worsen hypoventilation)\n"
            + "• COPD\n"
            + "• Concurrent opioid use (synergistic respiratory depression)\n"
            + "• Elderly (increased fall risk, paradoxical agitation, prolonged sedation)\n\n"
            + "##Important:## Benzos do NOT treat ICU delirium and may make it worse. If the patient is delirious, treat the underlying cause — don't reflexively give lorazepam.",
            onSet: "2-3 min (IV); 30-60 min (PO)",
            halfLife: "14 hours (long-acting)",
            duration: "6-8 hours",
            absorbtion: "Good oral bioavailability (90%)",
            distribution: "Widely distributed, crosses BBB",
            metaBolism: "Hepatic glucuronidation (no active metabolites — safe in liver disease)",
            excretion: "Renal (inactive metabolites)",
            pregnancyExplanation: "##Pregnancy Category D:## Risk of congenital malformations and neonatal withdrawal. Avoid in pregnancy unless benefits outweigh risks.",
            criticalPearls: "##Refrigerate!##\n\n"
            + "• Lorazepam is viscous and precipitates if not refrigerated — use a large-bore needle (18G or larger).\n\n"
            + "##Propylene glycol toxicity##\n\n"
            + "• Can occur with high/prolonged doses (infusions >1 mg/hr for days)\n"
            + "• Watch for metabolic acidosis, rising lactate, AKI\n"
            + "• Switch to propofol or dexmedetomidine if this develops\n\n"
            + "##Status epilepticus dosing:##\n\n"
            + "• 4 mg IV (0.1 mg/kg), may repeat once after 5-10 minutes\n"
            + "• If seizure persists after 2 doses, load with antiepileptic (fosphenytoin, levetiracetam) and consider intubation\n\n"
            + "##Alcohol withdrawal:##\n\n"
            + "• Use symptom-triggered (CIWA) dosing\n"
            + "• Don't be afraid of large cumulative doses in severe withdrawal (some patients need 20-40+ mg in first 24 hours)\n"
            + "• Lorazepam is safer than diazepam in liver disease (no active metabolites)\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Lorazepam is the reliable##, long-acting benzo for seizures and alcohol withdrawal. It's safer than other benzos in liver and kidney disease because of its metabolism. Watch for propylene glycol toxicity with prolonged infusions, and remember: benzos don't treat delirium — they often make it worse.\n\n"
            + "##High-yield point:## Lorazepam is first-line for status epilepticus and alcohol withdrawal, but avoid long-term use in the ICU due to accumulation, delirium risk, and propylene glycol toxicity."
        ),
        
        // 38. Magnesium Sulfate
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Magnesium Sulfate",
            brandName: "MgSO4",
            mechansim: "Magnesium is a physiologic calcium channel blocker and NMDA receptor antagonist.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of magnesium as the antiarrhythmic, bronchodilator, and seizure preventer. It's the drug of choice for Torsades de Pointes (polymorphic V-tach), severe asthma exacerbations, and eclampsia (seizure prevention in pre-eclampsia). It works by stabilizing cell membranes and blocking calcium influx.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks calcium channels → Stabilizes cardiac membranes (antiarrhythmic)\n"
            + "• Antagonizes NMDA receptors → Prevents seizures (eclampsia)\n"
            + "• Relaxes smooth muscle → Bronchodilation (asthma), vasodilation (lowers BP)\n"
            + "• Blocks neuromuscular transmission at high doses → Muscle relaxation\n\n"
            + "##The key:## Magnesium is the ONLY effective treatment for Torsades de Pointes. It's also neuroprotective in eclampsia (prevents seizures better than phenytoin). At high doses, it can cause respiratory depression and loss of deep tendon reflexes — calcium gluconate is the antidote.\n\n"
            + "##High-yield point:## Magnesium toxicity presents with loss of deep tendon reflexes (first sign), then respiratory depression, then cardiac arrest. Check reflexes frequently when giving magnesium. If reflexes are lost, stop the infusion and give calcium gluconate.",
            adverseEffects: "##Common:##\n\n"
            + "• Flushing, warmth\n"
            + "• Hypotension (vasodilation)\n"
            + "• Nausea\n"
            + "• Drowsiness\n\n"
            + "##Serious:##\n\n"
            + "• Respiratory depression (high doses)\n"
            + "• Loss of deep tendon reflexes (first sign of toxicity)\n"
            + "• Severe hypotension\n"
            + "• Cardiac arrest (severe hypermagnesemia)\n"
            + "• Heart block, bradycardia\n\n"
            + "##The respiratory depression problem:##\n\n"
            + "Magnesium blocks neuromuscular transmission at high doses, which can cause respiratory muscle weakness and apnea. This is why you must monitor deep tendon reflexes (DTRs) — loss of reflexes is the first sign of toxicity and precedes respiratory depression.\n\n"
            + "##Red flags:##\n\n"
            + "• Loss of deep tendon reflexes (STOP infusion, give calcium gluconate)\n"
            + "• Respiratory rate <12 or shallow breathing (respiratory depression)\n"
            + "• Severe hypotension (SBP <90)\n"
            + "• Serum magnesium >4-5 mEq/L (therapeutic is 2-4 mEq/L for eclampsia)",
            dose: "##Torsades de Pointes:##\n\n"
            + "• 2 g IV push over 1-2 minutes\n"
            + "• May repeat once if Torsades persists\n\n"
            + "##Severe Asthma Exacerbation:##\n\n"
            + "• 2 g IV over 20 minutes\n"
            + "• Given as adjunct to albuterol, steroids, ipratropium\n\n"
            + "##Eclampsia (seizure prevention):##\n\n"
            + "• Loading dose: 4-6 g IV over 15-20 minutes\n"
            + "• Maintenance: 1-2 g/hr IV infusion\n"
            + "• Goal magnesium level: 4-7 mEq/L\n\n"
            + "##Hypomagnesemia:##\n\n"
            + "• 1-2 g IV over 15 minutes (mild)\n"
            + "• 4-6 g IV over 3-6 hours (severe)\n\n"
            + "##Administration:##\n\n"
            + "• For cardiac arrest (Torsades): Push rapidly over 1-2 minutes\n"
            + "• For all other indications: Infuse slowly over 15-20 minutes (rapid push causes hypotension)\n"
            + "• Monitor deep tendon reflexes every hour during infusion\n"
            + "• Keep calcium gluconate at bedside (antidote)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.D),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.D),
            DrugClass: "Electrolyte, physiologic calcium channel blocker.\n\n"
            + "First-line for Torsades de Pointes, eclampsia (seizure prevention), and adjunct in severe asthma.",
            indications: "##Primary indications:##\n\n"
            + "• Torsades de Pointes (polymorphic ventricular tachycardia)\n"
            + "• Eclampsia (seizure prevention in pre-eclampsia)\n"
            + "• Severe asthma exacerbation (adjunct bronchodilator)\n"
            + "• Hypomagnesemia (symptomatic)\n"
            + "• Cardiac arrest (pulseless V-tach/V-fib with suspected hypomagnesemia)\n\n"
            + "##You'll reach for magnesium when:##\n\n"
            + "• Patient has Torsades de Pointes (polymorphic V-tach with long QT)\n"
            + "• Pre-eclamptic patient with BP >160/110, proteinuria, headache (prevent seizures)\n"
            + "• Severe asthma not responding to albuterol and steroids\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Patient on quinolone + azithromycin develops polymorphic V-tach → Magnesium 2 g IV\n"
            + "• 34-week pregnant patient with BP 180/120, proteinuria, headache → Magnesium 4-6 g load\n"
            + "• Severe asthma, PEFR 150, not improving with albuterol → Magnesium 2 g IV over 20 min",
            contraindiction: "##Absolute:##\n\n"
            + "• Heart block (2nd or 3rd degree AV block)\n"
            + "• Hypermagnesemia\n"
            + "• Myasthenia gravis (can worsen muscle weakness)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Renal failure (magnesium is renally excreted; can accumulate)\n"
            + "• Concurrent neuromuscular blockers (potentiates paralysis)\n"
            + "• Severe bradycardia\n\n"
            + "##Critical safety point:## Magnesium toxicity causes respiratory depression and cardiac arrest. Always monitor deep tendon reflexes during infusion — loss of reflexes is the first sign of toxicity. If reflexes are lost, stop the infusion immediately and give calcium gluconate 1-2 g IV (antidote).",
            onSet: "Immediate (IV)",
            halfLife: "Unknown (renally excreted)",
            duration: "30 minutes (bolus), continuous during infusion",
            absorbtion: "Rapid (IV)",
            distribution: "Widely distributed, crosses placenta",
            metaBolism: "None",
            excretion: "Urine (100% renal excretion)",
            pregnancyExplanation: "Category D. Magnesium crosses the placenta and can cause fetal hypotonia, respiratory depression, and hypocalcemia in the neonate if given long-term. However, it's the standard of care for eclampsia prevention despite the category.",
            criticalPearls: "##How to use magnesium safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check baseline deep tendon reflexes (DTRs)\n"
            + "• Check renal function (magnesium is renally excreted)\n"
            + "• Have calcium gluconate 1-2 g IV at bedside (antidote)\n"
            + "• Ensure continuous monitoring available\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor deep tendon reflexes every hour (loss of reflexes = toxicity)\n"
            + "• Monitor respiratory rate (goal >12)\n"
            + "• Monitor blood pressure (magnesium causes vasodilation)\n"
            + "• Check serum magnesium levels (therapeutic for eclampsia: 4-7 mEq/L; normal: 1.7-2.2 mEq/L)\n"
            + "• If reflexes are lost → STOP infusion, give calcium gluconate 1-2 g IV\n\n"
            + "##Magnesium for Torsades de Pointes:##\n\n"
            + "##Torsades de Pointes## is a polymorphic ventricular tachycardia triggered by a prolonged QT interval. Magnesium is the ONLY effective treatment:\n\n"
            + "• Give 2 g IV push over 1-2 minutes\n"
            + "• Repeat once if Torsades persists\n"
            + "• Follow with infusion if refractory (1-2 g/hr)\n"
            + "• Identify and fix the cause (hypokalemia, QT-prolonging drugs)\n\n"
            + "##Magnesium for eclampsia:##\n\n"
            + "Magnesium is the standard## of care for seizure prevention in pre-eclampsia and eclampsia. It's more effective than phenytoin:\n\n"
            + "• Loading dose: 4-6 g IV over 15-20 minutes\n"
            + "• Maintenance: 1-2 g/hr IV infusion\n"
            + "• Goal magnesium level: 4-7 mEq/L\n"
            + "• Continue for 24 hours postpartum (risk of seizure persists)\n\n"
            + "##Signs of magnesium toxicity (in order):##\n\n"
            + "• Loss of deep tendon reflexes (first sign; mag >7 mEq/L)\n"
            + "• Respiratory depression (mag >10 mEq/L)\n"
            + "• Heart block, severe hypotension (mag >12 mEq/L)\n"
            + "• Cardiac arrest (mag >15 mEq/L)\n\n"
            + "##Antidote:## Calcium gluconate 1-2 g IV over 2-5 minutes (reverses toxicity)\n\n"
            + "##Magnesium for asthma:##\n\n"
            + "Magnesium is a bronchodilator## (relaxes smooth muscle). It's used as an adjunct in severe asthma exacerbations:\n\n"
            + "• 2 g IV over 20 minutes\n"
            + "• Give alongside albuterol, steroids, ipratropium\n"
            + "• Modest benefit (improves FEV1 by ~10%)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not monitoring deep tendon reflexes (first sign of toxicity)\n"
            + "• Continuing infusion despite loss of reflexes (can cause respiratory arrest)\n"
            + "• Pushing too fast (causes hypotension)\n"
            + "• Not having calcium gluconate ready (antidote)\n"
            + "• Using in renal failure without dose adjustment (accumulates)\n\n"
            + "##The takeaway:##\n\n"
            + "Magnesium is the drug of choice for Torsades de Pointes, eclampsia, and adjunct in severe asthma. It works by blocking calcium channels and NMDA receptors. At high doses, it causes respiratory depression and loss of reflexes — monitor deep tendon reflexes hourly and keep calcium gluconate at bedside. Loss of reflexes = STOP the infusion and give calcium."
        ),
        
        // 39. Mannitol
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Mannitol",
            brandName: "Osmitrol",
            mechansim: "Mannitol is an osmotic diuretic that draws water from tissues into the vascular space, reducing intracranial pressure and promoting diuresis.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of mannitol as the brain desweller. It creates an osmotic gradient across the blood-brain barrier, pulling water out of the brain and into the circulation, reducing cerebral edema and ICP. It's the classic first-line agent for acute ICP crisis (herniation).\n\n"
            + "##How it works:##\n\n"
            + "• Creates osmotic gradient (plasma > brain/tissues)\n"
            + "• Draws water from brain → Reduces cerebral edema\n"
            + "• Increases intravascular volume → May improve CPP temporarily\n"
            + "• Osmotic diuresis → Excreted unchanged in urine\n"
            + "• Requires intact blood-brain barrier to work\n\n"
            + "##The key:## Mannitol works best when the blood-brain barrier is intact. In areas of significant BBB disruption (contusions, hemorrhage), mannitol can leak into the brain and worsen edema ('reverse osmotic shift'). Hypertonic saline may be preferred in these cases.\n\n"
            + "##High-yield point:## Mannitol can crystallize at room temperature. ALWAYS use an in-line filter when infusing. Warm the solution if crystals are visible. Don't give if crystals remain after warming.",
            adverseEffects: "##Common:##\n\n"
            + "• Volume depletion, dehydration (from diuresis)\n"
            + "• Electrolyte abnormalities (hyponatremia initially, hypernatremia later)\n"
            + "• Thirst\n\n"
            + "##Serious:##\n\n"
            + "• Pulmonary edema (fluid overload before diuresis kicks in)\n"
            + "• Acute kidney injury (especially with repeated high doses)\n"
            + "• Hyperosmolar state (serum osmolality >320)\n"
            + "• Rebound ICP elevation (if given repeatedly)\n\n"
            + "##The osmolality problem:##\n\n"
            + "Mannitol increases serum osmolality. If osmolality exceeds 320 mOsm/kg, risk of acute kidney injury increases significantly. Check osmolality before each dose if using repeatedly.\n\n"
            + "##Red flags:##\n\n"
            + "• Serum osmolality >320 (hold mannitol — AKI risk)\n"
            + "• Pulmonary edema (volume overloaded before diuresis)\n"
            + "• Rising creatinine\n"
            + "• Severe hypotension",
            dose: "##Acute ICP elevation:##\n\n"
            + "• 0.25-1 g/kg IV over 15-30 minutes\n"
            + "• Commonly: 50-100 g for adults (1-1.5 g/kg)\n"
            + "• Repeat every 4-6 hours as needed\n\n"
            + "##Herniation/Emergency:##\n\n"
            + "• 1-1.5 g/kg IV rapid infusion\n"
            + "• Effect within 20-30 minutes\n\n"
            + "##Monitoring:##\n\n"
            + "• Check serum osmolality before each dose (hold if >320)\n"
            + "• Monitor renal function\n"
            + "• Monitor urine output\n"
            + "• Check sodium (can cause hyper- or hyponatremia)\n\n"
            + "##Administration:##\n\n"
            + "• ALWAYS use in-line filter (crystallization risk)\n"
            + "• Give via large bore IV (concentrated solution)\n"
            + "• Warm if crystals visible (dissolves at 37°C)\n"
            + "• Don't give if crystals remain after warming",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Osmotic diuretic.\n\n"
            + "Primary use is to reduce intracranial pressure. Also used in some rhabdomyolysis protocols.",
            indications: "##Primary indications:##\n\n"
            + "• Elevated intracranial pressure (TBI, tumor, stroke)\n"
            + "• Cerebral edema\n"
            + "• Impending herniation\n"
            + "• Acute angle-closure glaucoma (reduce intraocular pressure)\n\n"
            + "##You'll reach for mannitol when:##\n\n"
            + "• Acute ICP crisis — herniation signs (blown pupil, posturing)\n"
            + "• Severe TBI with elevated ICP on monitor\n"
            + "• Post-operative neurosurgery with brain swelling\n\n"
            + "##Classic scenarios:##\n\n"
            + "• TBI patient with ICP >25, acutely herniating → Mannitol 1 g/kg IV rapid infusion\n"
            + "• Large MCA stroke with midline shift → Mannitol 0.5-1 g/kg q6h\n"
            + "• Post-craniotomy with increasing edema → Mannitol with ICP monitoring",
            contraindiction: "##Absolute:##\n\n"
            + "• Severe dehydration/hypovolemia (worsens with diuresis)\n"
            + "• Severe pulmonary edema (can worsen before diuresis)\n"
            + "• Anuria/renal failure (mannitol accumulates)\n"
            + "• Active intracranial hemorrhage (controversial — can worsen in some cases)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Serum osmolality >320 mOsm/kg (high AKI risk)\n"
            + "• CHF (volume overload risk)\n"
            + "• Renal impairment\n\n"
            + "##Critical safety point:## Check serum osmolality before repeated doses. If osmolality >320, hold mannitol and consider hypertonic saline instead.",
            onSet: "20-30 min (ICP reduction)",
            halfLife: "100 min",
            duration: "3-8 hrs",
            absorbtion: "100% (IV only)",
            distribution: "Extracellular fluid (does not cross intact BBB)",
            metaBolism: "Minimal",
            excretion: "Urine (unchanged)",
            pregnancyExplanation: "Category C. Use in pregnancy only if benefits outweigh risks. May cause volume shifts.",
            criticalPearls: "##How to use mannitol safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check serum osmolality (hold if >320)\n"
            + "• Ensure adequate volume status (mannitol causes diuresis)\n"
            + "• Verify IV is patent (mannitol is an irritant)\n"
            + "• Use an in-line filter (crystallization risk)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor urine output (expect brisk diuresis)\n"
            + "• Monitor ICP (if available)\n"
            + "• Check osmolality every 4-6 hours if repeated doses\n"
            + "• Monitor for pulmonary edema (transient volume expansion before diuresis)\n\n"
            + "##Mannitol vs. Hypertonic Saline:##\n\n"
            + "##Both reduce ICP##, but they work differently:\n\n"
            + "##Mannitol:##\n\n"
            + "• Osmotic diuresis → Can cause hypovolemia\n"
            + "• Better when need to reduce overall volume\n"
            + "• Contraindicated in renal failure\n"
            + "• Requires intact BBB to work best\n"
            + "• Can cause rebound ICP if repeated doses\n\n"
            + "##Hypertonic Saline (3%, 23.4%):##\n\n"
            + "• Expands volume → Better in hypovolemic patients\n"
            + "• Can use in renal failure\n"
            + "• May work better with disrupted BBB\n"
            + "• Less rebound ICP elevation\n"
            + "• Requires central line for high concentrations\n\n"
            + "##Crystallization — the practical issue:##\n\n"
            + "Mannitol can crystallize at room temperature:\n\n"
            + "• ALWAYS use an in-line filter\n"
            + "• Inspect solution before infusing\n"
            + "• If crystals present → Warm in water bath or warming cabinet (37°C)\n"
            + "• Don't microwave\n"
            + "• Don't use if crystals remain after warming\n\n"
            + "##The osmolality gap:##\n\n"
            + "Keep serum osmolality <320 mOsm/kg:\n\n"
            + "• Check before each dose if using repeated doses\n"
            + "• If >320 → Hold mannitol, consider hypertonic saline\n"
            + "• Calculate osmole gap if possible (accumulated mannitol)\n"
            + "• Higher osmolality = higher AKI risk\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not using an in-line filter (crystallization)\n"
            + "• Giving to hypovolemic patient (worsens hypotension)\n"
            + "• Not checking osmolality before repeated doses\n"
            + "• Continuing mannitol when osmolality >320 (AKI risk)\n"
            + "• Expecting immediate effect (takes 20-30 minutes)\n\n"
            + "##The takeaway:##\n\n"
            + "Mannitol is an osmotic diuretic used to reduce ICP. Give 0.5-1.5 g/kg IV over 15-30 minutes. ALWAYS use an in-line filter (crystallization). Check serum osmolality before repeated doses — hold if >320 mOsm/kg. Watch for AKI and volume shifts. Consider hypertonic saline as an alternative, especially in hypovolemic patients or renal failure."
        ),
        
        // 40. Meropenem - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Meropenem",
            brandName: "Merrem",
            mechansim: "Meropenem is a carbapenem that inhibits bacterial cell wall synthesis. Broad-spectrum.\n\n"
            + "##The Mental Model:##\n"
            + "Think of meropenem as the ICU's fire extinguisher behind glass.\n\n"
            + "It hits:##\n"
            + "• Gram-negatives (including Pseudomonas and many ESBLs)\n"
            + "• Gram-positives\n"
            + "• Anaerobes\n\n"
            + "It misses:##\n"
            + "• Atypicals\n"
            + "• Some carbapenem-resistant organisms (CRE)\n\n"
            + "##Key concept:## Meropenem is safe and effective — until it builds up in the brain. When the kidneys fail, meropenem accumulates and causes CNS toxicity.\n\n"
            + "What is ESBL?\n"
            + "ESBL = Extended-Spectrum Beta-Lactamase. An enzyme that destroys most penicillins and cephalosporins, making drugs like ceftriaxone, cefepime, and often Zosyn unreliable. That's why ESBL infections usually require a carbapenem.",
            adverseEffects: "##Common:## GI upset, Rash, Nausea.\n\n"
            + "##Serious:## Seizures (especially in renal failure), CNS toxicity.\n\n"
            + "If dosing is wrong## or renal function worsens, you may see:\n"
            + "• Confusion\n"
            + "• Myoclonus\n"
            + "• Seizures\n\n"
            + "That is NOT 'ICU delirium.' That is carbapenem neurotoxicity until proven otherwise.",
            dose: "1 g IV q8h (adjusted in renal failure). Use full-dose and extended infusion in septic shock.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Carbapenem antibiotic.\n\n"
            + "One of the few antibiotics that can reliably cover almost everything while you stabilize the patient and wait for cultures.",
            indications: "Standard Indications:\n"
            + "• Intra-abdominal infections\n"
            + "• Sepsis\n"
            + "• ESBL Organisms\n\n"
            + "##Reach for meropenem when:##\n"
            + "• A septic patient is not responding to cefepime or Zosyn\n"
            + "• The source is gut, bile, necrotizing tissue, or hospital-acquired\n"
            + "• There's a history of ESBL or MDR organisms\n"
            + "• The patient is crashing and you can't miss",
            contraindiction: "##Absolute:## Hypersensitivity to carbapenems.\n\n"
            + "##Caution:## Renal failure (high neurotoxicity risk).\n\n"
            + "##Important:## Meropenem is not a 'set it and forget it' drug. It is a bridge to clarity.",
            onSet: "Rapid onset",
            halfLife: "1 hour",
            duration: "Varies",
            absorbtion: "IV only",
            distribution: "Widely distributed, including CSF.",
            metaBolism: "Minimal hepatic metabolism.",
            excretion: "Renal (dose adjust for CrCl).",
            pregnancyExplanation: "Use with caution in pregnancy. Benefits should outweigh risks in serious infections.",
            criticalPearls: "##Covers ESBL Organisms:##\n\n"
            + "• Use for resistant Gram-negatives\n"
            + "• ##Seizure risk## is lower than Imipenem but still exists in renal failure\n\n"
            + "##How to use safely:##\n\n"
            + "• Use full-dose and extended infusion in septic shock\n"
            + "• Check creatinine before starting\n\n"
            + "##While it's running:##\n\n"
            + "• Re-dose aggressively if renal clearance is high\n"
            + "• Reduce quickly if AKI or dialysis appears\n"
            + "• Watch mental status for neurotoxicity\n\n"
            + "When cultures return:##\n\n"
            + "• De-escalate to a narrower agent as soon as possible\n\n"
            + "##The takeaway:##\n\n"
            + "Meropenem is the ICU's biggest gun for resistant sepsis — powerful, fast, and lifesaving. Use enough early, dose to the kidneys, and step down as soon as you can."
        ),
        
        // 41. Metoclopramide
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Metoclopramide",
            brandName: "Reglan",
            mechansim: "Metoclopramide is a dopamine D2 receptor antagonist that blocks nausea/vomiting and increases gastric motility.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of metoclopramide as the dopamine blocker with prokinetic powers — it blocks dopamine receptors in the chemoreceptor trigger zone (CTZ) to stop nausea, and it also speeds up gastric emptying (prokinetic effect). This dual action makes it useful for gastroparesis, but the dopamine blockade can cause extrapyramidal symptoms (EPS) like dystonia and akathisia.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks D2 dopamine receptors in CTZ → Prevents nausea/vomiting\n"
            + "• Blocks D2 receptors in GI tract → Increases gastric motility (prokinetic)\n"
            + "• Speeds gastric emptying → Helps gastroparesis\n"
            + "• Can cause EPS (dystonia, akathisia, parkinsonism) due to dopamine blockade\n\n"
            + "##The key:## Metoclopramide is second-line for nausea/vomiting (ondansetron is first-line) because it causes EPS. However, it's first-line for gastroparesis because of its prokinetic effect. Push slowly (over 2-3 minutes) to reduce the risk of anxiety and restlessness.\n\n"
            + "##High-yield point:## Metoclopramide causes extrapyramidal symptoms (EPS) — dystonia (muscle spasms), akathisia (restlessness), and parkinsonism. These are more common in young patients and with rapid IV push. If EPS occurs, give diphenhydramine 25-50 mg IV (antidote).",
            adverseEffects: "##Common:##\n\n"
            + "• Drowsiness\n"
            + "• Restlessness, anxiety (especially with rapid push)\n"
            + "• Dizziness\n"
            + "• Diarrhea\n\n"
            + "##Serious:##\n\n"
            + "• Extrapyramidal symptoms (EPS): Dystonia, akathisia, parkinsonism\n"
            + "• Tardive dyskinesia (with prolonged use)\n"
            + "• Neuroleptic malignant syndrome (rare)\n"
            + "• Hyperprolactinemia (galactorrhea, gynecomastia)\n\n"
            + "##The EPS problem:##\n\n"
            + "Metoclopramide blocks dopamine receptors, which can cause extrapyramidal symptoms (EPS). Dystonia (muscle spasms, especially neck/face) and akathisia (severe restlessness) are most common. These are more likely with rapid IV push and in young patients. If EPS occurs, give diphenhydramine 25-50 mg IV.\n\n"
            + "##Red flags:##\n\n"
            + "• Muscle spasms, especially neck/face (dystonia)\n"
            + "• Severe restlessness, can't sit still (akathisia)\n"
            + "• Rigidity, tremor (parkinsonism)\n"
            + "• Galactorrhea (hyperprolactinemia)",
            dose: "##Nausea/Vomiting:##\n\n"
            + "• 10 mg IV/IM/PO every 6-8 hours\n"
            + "• Push IV slowly over 2-3 minutes (rapid push causes anxiety/restlessness)\n"
            + "• Max: 30 mg/day\n\n"
            + "##Gastroparesis:##\n\n"
            + "• 10 mg PO 30 minutes before meals and at bedtime\n"
            + "• Or 10 mg IV before meals\n\n"
            + "##GI Bleeding (prokinetic):##\n\n"
            + "• 10 mg IV before endoscopy (empties stomach)\n\n"
            + "##Administration:##\n\n"
            + "• Push IV slowly over 2-3 minutes (rapid push causes anxiety and EPS)\n"
            + "• Can give IM or PO\n"
            + "• For gastroparesis: Give 30 minutes before meals",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Dopamine D2 antagonist, antiemetic, prokinetic.\n\n"
            + "Used for nausea/vomiting (second-line) and gastroparesis (first-line).",
            indications: "##Primary indications:##\n\n"
            + "• Gastroparesis (delayed gastric emptying)\n"
            + "• Nausea/vomiting (second-line if ondansetron fails)\n"
            + "• GI bleeding (prokinetic before endoscopy)\n"
            + "• Migraine-associated nausea\n\n"
            + "##You'll reach for metoclopramide when:##\n\n"
            + "• Patient has gastroparesis (diabetic, post-op, idiopathic)\n"
            + "• Nausea/vomiting not responding to ondansetron\n"
            + "• Need to empty stomach before endoscopy\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Diabetic patient with gastroparesis, early satiety → Metoclopramide 10 mg PO before meals\n"
            + "• Patient vomiting, ondansetron failed → Metoclopramide 10 mg IV slowly\n"
            + "• Upper GI bleed, need to empty stomach → Metoclopramide 10 mg IV before endoscopy",
            contraindiction: "##Absolute:##\n\n"
            + "• GI obstruction or perforation\n"
            + "• GI bleeding (unless using for prokinetic before endoscopy)\n"
            + "• Pheochromocytoma (can cause hypertensive crisis)\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Parkinson's disease (can worsen symptoms)\n"
            + "• Seizure disorder (lowers seizure threshold)\n"
            + "• Young patients (higher risk of EPS)\n"
            + "• Prolonged use (risk of tardive dyskinesia)\n\n"
            + "##Critical safety point:## Metoclopramide causes extrapyramidal symptoms (EPS), especially with rapid IV push and in young patients. Always push slowly over 2-3 minutes. If EPS occurs (dystonia, akathisia), give diphenhydramine 25-50 mg IV immediately.",
            onSet: "1-3 min (IV), 30-60 min (PO)",
            halfLife: "5-6 hrs",
            duration: "1-2 hrs",
            absorbtion: "Good oral bioavailability",
            distribution: "Widely distributed, crosses BBB",
            metaBolism: "Liver (sulfation, glucuronidation)",
            excretion: "Kidney (85% unchanged)",
            pregnancyExplanation: "Category B. Generally safe in pregnancy. Used for hyperemesis gravidarum. No teratogenic effects reported.",
            criticalPearls: "##How to use metoclopramide safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Rule out GI obstruction or perforation\n"
            + "• Check for Parkinson's disease (contraindicated)\n"
            + "• Have diphenhydramine ready (antidote for EPS)\n\n"
            + "##While it's running:##\n\n"
            + "• Push IV slowly over 2-3 minutes (rapid push causes anxiety and EPS)\n"
            + "• Monitor for EPS (dystonia, akathisia, parkinsonism)\n"
            + "• If EPS occurs → Give diphenhydramine 25-50 mg IV immediately\n"
            + "• Limit duration of use (risk of tardive dyskinesia with prolonged use)\n\n"
            + "##Metoclopramide vs. Ondansetron:##\n\n"
            + "##Metoclopramide:##\n\n"
            + "• Blocks dopamine receptors\n"
            + "• Causes EPS (dystonia, akathisia)\n"
            + "• Prokinetic (helps gastroparesis)\n"
            + "• Second-line for nausea/vomiting\n"
            + "• First-line for gastroparesis\n\n"
            + "##Ondansetron:##\n\n"
            + "• Blocks serotonin (5-HT3) receptors\n"
            + "• No EPS\n"
            + "• Not prokinetic\n"
            + "• First-line for nausea/vomiting\n"
            + "• No effect on gastroparesis\n\n"
            + "##Bottom line:## Use ondansetron first for nausea/vomiting. Use metoclopramide if ondansetron fails or if patient has gastroparesis.\n\n"
            + "##Metoclopramide for gastroparesis:##\n\n"
            + "Metoclopramide is first-line for gastroparesis:\n\n"
            + "• 10 mg PO 30 minutes before meals and at bedtime\n"
            + "• Increases gastric motility and speeds emptying\n"
            + "• Helps with early satiety, bloating, nausea\n"
            + "• Limit duration (risk of tardive dyskinesia)\n\n"
            + "##Extrapyramidal symptoms (EPS):##\n\n"
            + "EPS are movement disorders caused by dopamine blockade:\n\n"
            + "• Dystonia: Muscle spasms, especially neck (torticollis), face (grimacing), eyes (oculogyric crisis)\n"
            + "• Akathisia: Severe restlessness, can't sit still\n"
            + "• Parkinsonism: Rigidity, tremor, bradykinesia\n\n"
            + "##Treatment:## Diphenhydramine 25-50 mg IV (anticholinergic antidote)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Pushing IV too fast (causes anxiety and EPS)\n"
            + "• Not having diphenhydramine ready (needed if EPS occurs)\n"
            + "• Using in Parkinson's disease (worsens symptoms)\n"
            + "• Prolonged use without monitoring (risk of tardive dyskinesia)\n\n"
            + "##The takeaway:##\n\n"
            + "Metoclopramide is a dopamine blocker that treats nausea/vomiting and gastroparesis. It's second-line for nausea (ondansetron is first-line) because it causes EPS, but it's first-line for gastroparesis because of its prokinetic effect. Push slowly over 2-3 minutes, watch for EPS, and have diphenhydramine ready as an antidote."
        ),
        
        // 42. Methylprednisolone
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Methylprednisolone",
            brandName: "Solu-Medrol ®",
            mechansim: "Methylprednisolone is a potent corticosteroid that suppresses inflammation by inhibiting inflammatory mediators and stabilizing cell membranes.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of methylprednisolone as the lung and spinal cord rescue steroid. It's the standard of care for asthma/COPD exacerbations (reduces airway inflammation) and historically used for acute spinal cord injury (though controversial). It has less mineralocorticoid activity than hydrocortisone, so less fluid retention.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to glucocorticoid receptors → Suppresses inflammatory cytokines (IL-1, TNF-α)\n"
            + "• Inhibits phospholipase A2 → Reduces prostaglandins and leukotrienes\n"
            + "• Stabilizes cell membranes → Reduces capillary permeability\n"
            + "• Decreases airway edema and bronchial hyperresponsiveness\n\n"
            + "##The key:## Methylprednisolone is 5x more potent than hydrocortisone and has a shorter half-life than dexamethasone (12-36 hours). It's first-line for asthma/COPD exacerbations because it reduces inflammation and speeds recovery.\n\n"
            + "##High-yield point:## In severe asthma or COPD exacerbations, steroids reduce the need for intubation, shorten hospital stay, and prevent relapse. Give methylprednisolone 125 mg IV (or prednisone 60 mg PO) as soon as possible.",
            adverseEffects: "##Common:##\n\n"
            + "• Hyperglycemia (very common)\n"
            + "• Hypertension (fluid retention)\n"
            + "• Insomnia, agitation\n"
            + "• Increased appetite\n\n"
            + "##Serious:##\n\n"
            + "• Adrenal suppression (with prolonged use)\n"
            + "• Immunosuppression (increased infection risk)\n"
            + "• GI bleeding, peptic ulcers\n"
            + "• Avascular necrosis (long-term)\n"
            + "• Psychosis\n\n"
            + "##The hyperglycemia problem:##\n\n"
            + "Steroids cause insulin resistance, leading to hyperglycemia. Monitor glucose closely, especially in diabetics. May need insulin.\n\n"
            + "##Red flags:##\n\n"
            + "• Glucose >300 mg/dL (steroid-induced hyperglycemia)\n"
            + "• New-onset psychosis or agitation\n"
            + "• GI bleeding (black stools)\n"
            + "• Signs of infection (steroids mask fever)",
            dose: "##Asthma/COPD Exacerbation:##\n\n"
            + "• 125 mg IV once, then 60-80 mg IV/PO daily for 5 days\n"
            + "• Alternative: Prednisone 60 mg PO daily for 5 days (equivalent)\n\n"
            + "##Anaphylaxis (adjunct):##\n\n"
            + "• 125 mg IV (given after epinephrine, antihistamines)\n"
            + "• Prevents biphasic reaction\n\n"
            + "##Spinal Cord Injury (controversial):##\n\n"
            + "• Loading: 30 mg/kg IV over 15 minutes\n"
            + "• Maintenance: 5.4 mg/kg/hr IV for 23 hours\n"
            + "• Must start within 8 hours of injury (benefit unclear, risks high)\n\n"
            + "##Administration:##\n\n"
            + "• Can give IV or PO\n"
            + "• For asthma/COPD: Give early, continue for 5 days\n"
            + "• No need to taper for short courses (<2 weeks)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Corticosteroid.\n\n"
            + "Standard of care for asthma/COPD exacerbations, anaphylaxis (adjunct), and historically for spinal cord injury.",
            indications: "##Primary indications:##\n\n"
            + "• Asthma exacerbation (severe)\n"
            + "• COPD exacerbation\n"
            + "• Anaphylaxis (adjunct to epinephrine)\n"
            + "• Acute spinal cord injury (controversial)\n"
            + "• Multiple sclerosis flare\n"
            + "• Organ transplant rejection\n\n"
            + "##You'll reach for methylprednisolone when:##\n\n"
            + "• Severe asthma patient not responding to albuterol, on high-flow O₂\n"
            + "• COPD exacerbation patient with respiratory distress\n"
            + "• Anaphylaxis patient after epinephrine (prevent biphasic reaction)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Asthma patient, PEFR 150, on albuterol + high-flow O₂ → Methylprednisolone 125 mg IV\n"
            + "• COPD exacerbation, increasing dyspnea, hypercapnia → Methylprednisolone 60 mg PO/IV\n"
            + "• Anaphylaxis, post-epi, stable → Methylprednisolone 125 mg IV",
            contraindiction: "##Absolute:##\n\n"
            + "• Systemic fungal infection\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Active infection (steroids suppress immune response)\n"
            + "• Diabetes (causes hyperglycemia)\n"
            + "• Peptic ulcer disease (increases GI bleeding risk)\n"
            + "• Psychosis\n\n"
            + "##Critical safety point:## High-dose methylprednisolone for spinal cord injury is controversial. The NASCIS trials showed modest benefit, but serious complications (infections, GI bleeding) are common. Many centers no longer use it.",
            onSet: "1 hr",
            halfLife: "12-36 hrs",
            duration: "1-5 wks",
            absorbtion: "Well absorbed (oral and IV)",
            distribution: "Widely distributed",
            metaBolism: "Liver",
            excretion: "Urine",
            pregnancyExplanation: "Category C. Use in pregnancy only if benefits outweigh risks. May cause fetal adrenal suppression.",
            criticalPearls: "##How to use methylprednisolone safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check glucose (especially in diabetics)\n"
            + "• Rule out active infection if possible\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor glucose (may need insulin)\n"
            + "• Watch for GI bleeding (especially with NSAIDs)\n"
            + "• Monitor for signs of infection (steroids mask fever)\n\n"
            + "##Methylprednisolone for asthma/COPD:##\n\n"
            + "Steroids are first-line for severe asthma and COPD exacerbations:\n\n"
            + "• Reduce inflammation in the airways\n"
            + "• Speed recovery, reduce relapse\n"
            + "• Reduce need for intubation\n\n"
            + "##Dose:## 125 mg IV initially, then 60-80 mg daily for 5 days (or prednisone 60 mg PO for 5 days)\n\n"
            + "##No taper needed for short courses (<2 weeks):## Just stop after 5 days.\n\n"
            + "##Methylprednisolone vs. Dexamethasone:##\n\n"
            + "##Methylprednisolone:##\n\n"
            + "• 5x more potent than hydrocortisone\n"
            + "• Shorter half-life (12-36 hours)\n"
            + "• Some mineralocorticoid activity (mild fluid retention)\n"
            + "• Preferred for asthma/COPD exacerbations\n\n"
            + "##Dexamethasone:##\n\n"
            + "• 25x more potent than hydrocortisone\n"
            + "• Longer half-life (36-72 hours)\n"
            + "• Minimal mineralocorticoid activity (no fluid retention)\n"
            + "• Preferred for cerebral edema, meningitis, COVID-19\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not giving steroids early in severe asthma/COPD (delays recovery)\n"
            + "• Tapering after short courses (not necessary for <2 weeks)\n"
            + "• Not monitoring glucose (causes severe hyperglycemia)\n"
            + "• Using high-dose methylprednisolone for spinal cord injury (controversial, high complication rate)\n\n"
            + "##The takeaway:##\n\n"
            + "Methylprednisolone is a potent anti-inflammatory steroid that's standard of care for asthma and COPD exacerbations. Give 125 mg IV (or prednisone 60 mg PO) early, continue for 5 days, and don't taper for short courses. Monitor glucose closely. It's also used in anaphylaxis (after epinephrine) to prevent biphasic reactions."
        ),
        
        // 43. Metoprolol
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Metoprolol",
            brandName: "Lopressor ®",
            mechansim: "Metoprolol is a cardioselective (beta-1 selective) beta-blocker that blocks beta-1 adrenergic receptors in the heart.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of metoprolol as the heart rate and blood pressure controller — it slows the heart down, reduces contractility, and lowers blood pressure by blocking sympathetic stimulation. It's cardioselective (beta-1), so at low doses it doesn't cause much bronchospasm, making it safer in mild COPD/asthma compared to non-selective beta-blockers (propranolol).\n\n"
            + "##How it works:##\n\n"
            + "• Blocks beta-1 receptors in the heart → Decreases heart rate (negative chronotropy)\n"
            + "• Decreases contractility (negative inotropy)\n"
            + "• Slows AV node conduction (negative dromotropy)\n"
            + "• Reduces myocardial oxygen demand\n"
            + "• Lowers blood pressure\n\n"
            + "##The key:## Metoprolol is cardioselective at low doses, but this selectivity is lost at higher doses (it will block beta-2 in the lungs → bronchospasm). It's great for rate control in atrial fibrillation, post-MI patients (improves survival), and hypertensive emergencies.\n\n"
            + "##High-yield point:## Beta-blockers improve survival in heart failure (with reduced EF), post-MI, and hypertension. Metoprolol is one of the evidence-based beta-blockers for heart failure (along with carvedilol and bisoprolol). However, don't start beta-blockers in decompensated heart failure — stabilize the patient first.",
            adverseEffects: "##Common:##\n\n"
            + "• Bradycardia (dose-dependent)\n"
            + "• Hypotension\n"
            + "• Fatigue, dizziness\n"
            + "• Cold extremities (peripheral vasoconstriction)\n\n"
            + "##Serious:##\n\n"
            + "• Heart block (2nd or 3rd degree AV block)\n"
            + "• Severe bradycardia (HR <40)\n"
            + "• Worsening heart failure (in decompensated patients)\n"
            + "• Bronchospasm (at high doses, even though cardioselective)\n"
            + "• Masking hypoglycemia symptoms (in diabetics)\n\n"
            + "##The bronchospasm problem:##\n\n"
            + "Metoprolol is cardioselective (beta-1), so it's safer in mild asthma/COPD compared to non-selective beta-blockers. However, at high doses, it loses selectivity and can cause bronchospasm. Avoid in severe asthma or COPD exacerbation.\n\n"
            + "##Red flags:##\n\n"
            + "• HR <50 (excessive bradycardia)\n"
            + "• New heart block on ECG (2nd or 3rd degree)\n"
            + "• BP <90 systolic (hypotension)\n"
            + "• Wheezing or respiratory distress (bronchospasm)",
            dose: "##Atrial Fibrillation/Flutter (rate control):##\n\n"
            + "• 2.5-5 mg IV over 2 minutes\n"
            + "• May repeat every 5 minutes\n"
            + "• Max: 15 mg total\n\n"
            + "##Acute Myocardial Infarction:##\n\n"
            + "• 5 mg IV every 5 minutes for 3 doses (max 15 mg)\n"
            + "• Then transition to oral metoprolol\n\n"
            + "##Hypertension:##\n\n"
            + "• 5 mg IV every 5 minutes (max 15 mg)\n\n"
            + "##Administration:##\n\n"
            + "• Push slowly over 2 minutes (rapid push can cause hypotension/bradycardia)\n"
            + "• Monitor heart rate and blood pressure continuously\n"
            + "• Hold if HR <60 or SBP <100",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Cardioselective (beta-1) beta-blocker.\n\n"
            + "Used for rate control in atrial fibrillation, post-MI survival benefit, hypertension, and heart failure (chronic use).",
            indications: "##Primary indications:##\n\n"
            + "• Atrial fibrillation/flutter (rate control)\n"
            + "• Acute myocardial infarction (reduce mortality)\n"
            + "• Hypertension (especially hypertensive urgency/emergency)\n"
            + "• Heart failure with reduced EF (chronic oral use)\n"
            + "• Angina (reduce myocardial oxygen demand)\n\n"
            + "##You'll reach for metoprolol when:##\n\n"
            + "• Patient has atrial fib with RVR and you want rate control\n"
            + "• Post-MI patient needs beta-blockade for cardioprotection\n"
            + "• Hypertensive urgency/emergency needs rapid BP control\n\n"
            + "##Classic scenarios:##\n\n"
            + "• 60-year-old with atrial fib, HR 140, BP 150/90 → Metoprolol 5 mg IV\n"
            + "• STEMI patient, BP 160/100, HR 110 → Metoprolol 5 mg IV (reduce O₂ demand)\n"
            + "• Hypertensive urgency, BP 200/120 → Metoprolol 5 mg IV",
            contraindiction: "##Absolute:##\n\n"
            + "• Severe bradycardia (HR <45)\n"
            + "• Second- or third-degree AV block (unless pacemaker in place)\n"
            + "• Cardiogenic shock\n"
            + "• Decompensated heart failure (acute pulmonary edema)\n"
            + "• Severe hypotension (SBP <90)\n"
            + "• Sick sinus syndrome (unless pacemaker)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Asthma or COPD (cardioselective, but can still cause bronchospasm at high doses)\n"
            + "• Diabetes (masks hypoglycemia symptoms)\n"
            + "• Peripheral vascular disease (can worsen)\n"
            + "• Concurrent calcium channel blocker use (additive negative inotropy)\n\n"
            + "##Critical safety point:## Do NOT give metoprolol (or any beta-blocker) in decompensated heart failure or cardiogenic shock. Beta-blockers reduce contractility, which can worsen pump function in acutely decompensated patients. Start beta-blockers only after the patient is euvolemic and stable.",
            onSet: "1-2 min (IV)",
            halfLife: "3-7 hrs",
            duration: "5-8 hrs (IV), longer with oral",
            absorbtion: "Well absorbed (oral)",
            distribution: "Widely distributed, crosses BBB (can cause CNS effects)",
            metaBolism: "Liver (CYP2D6)",
            excretion: "Urine (metabolites)",
            pregnancyExplanation: "Category C. Use in pregnancy only if benefits outweigh risks. Can cause fetal bradycardia and hypoglycemia.",
            criticalPearls: "##How to use metoprolol safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check heart rate (hold if <60)\n"
            + "• Check blood pressure (hold if SBP <100)\n"
            + "• Check ECG for heart block\n"
            + "• Ensure patient is not in cardiogenic shock or decompensated heart failure\n\n"
            + "##While it's running:##\n\n"
            + "• Push 2.5-5 mg slowly over 2 minutes\n"
            + "• Monitor heart rate and blood pressure continuously\n"
            + "• Wait 5 minutes before repeating (don't stack doses)\n"
            + "• If bradycardia or hypotension → Hold further doses, consider atropine or fluids\n\n"
            + "##Metoprolol vs. Diltiazem for atrial fib rate control:##\n\n"
            + "##Metoprolol:##\n\n"
            + "• Better if patient has heart failure (beta-blockers improve HF outcomes)\n"
            + "• Contraindicated in bronchospasm\n"
            + "• Less hypotension than diltiazem\n\n"
            + "##Diltiazem:##\n\n"
            + "• Safe in asthma/COPD (doesn't cause bronchospasm)\n"
            + "• More predictable rate control with infusion\n"
            + "• More hypotension than metoprolol\n\n"
            + "##Bottom line:## Both work well. Use metoprolol in heart failure patients; use diltiazem in asthmatics/COPD patients.\n\n"
            + "##Beta-blockers in acute MI:##\n\n"
            + "##Metoprolol (and other## beta-blockers) reduce mortality post-MI by:\n\n"
            + "• Reducing myocardial oxygen demand (lower HR, lower contractility)\n"
            + "• Preventing arrhythmias (reduce sudden cardiac death)\n"
            + "• Reducing infarct size\n\n"
            + "Give metoprolol early in STEMI if the patient is hemodynamically stable (no cardiogenic shock, no heart block, no severe bradycardia).\n\n"
            + "##Beta-blockers in heart failure:##\n\n"
            + "##Beta-blockers (metoprolol##, carvedilol, bisoprolol) improve survival in heart failure with reduced ejection fraction (HFrEF). However:\n\n"
            + "• Start ONLY after patient is euvolemic and stable\n"
            + "• Start low, go slow (titrate up over weeks)\n"
            + "• Never start in decompensated heart failure (can worsen)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving metoprolol in cardiogenic shock or decompensated heart failure\n"
            + "• Combining with diltiazem (additive negative inotropy → heart failure)\n"
            + "• Not waiting 5 minutes between doses (stacking doses → severe bradycardia)\n"
            + "• Using in severe asthma exacerbation (can cause bronchospasm)\n"
            + "• Stopping beta-blockers abruptly (rebound hypertension, tachycardia, angina)\n\n"
            + "##The takeaway:##\n\n"
            + "Metoprolol is a cardioselective beta-blocker that slows heart rate, reduces blood pressure, and lowers myocardial oxygen demand. It's used for rate control in atrial fibrillation, post-MI cardioprotection, and hypertension. Push slowly, monitor closely, and avoid in decompensated heart failure or severe bradycardia. Beta-blockers save lives in heart failure and post-MI, but only when the patient is stable."
        ),
        
        // 44. Midazolam
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Midazolam",
            brandName: "Versed ®",
            mechansim: "Midazolam is a short-acting benzodiazepine that works by enhancing GABA activity in the brain.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of midazolam as the amnestic sedative — it makes patients calm, relaxed, and forget the procedure. It's lipophilic, so it crosses the blood-brain barrier fast (onset in 1-3 minutes), but the duration is short (2-4 hours).\n\n"
            + "##How it works:##\n\n"
            + "• Enhances GABA-A receptor activity → Increases chloride influx → Hyperpolarizes neurons\n"
            + "• Produces sedation, anxiolysis, amnesia, and muscle relaxation\n"
            + "• No analgesic properties (doesn't treat pain)\n\n"
            + "##The key:## Midazolam is dose-dependent. Low doses (1-2 mg) give anxiolysis and amnesia. Higher doses (5-10 mg) give deep sedation and respiratory depression. Always titrate slowly.\n\n"
            + "##High-yield point:## Midazolam is 2-3 times more potent than diazepam and has a faster onset. It's the preferred benzo for procedural sedation because of the amnesia and short duration. Flumazenil reverses it.",
            adverseEffects: "##Common:##\n\n"
            + "• Sedation, drowsiness\n"
            + "• Anterograde amnesia (patients won't remember the procedure)\n"
            + "• Respiratory depression (dose-dependent)\n"
            + "• Hypotension (especially with rapid IV push)\n\n"
            + "##Serious:##\n\n"
            + "• Apnea (especially when combined with opioids)\n"
            + "• Severe hypotension (in hypovolemic or elderly patients)\n"
            + "• Paradoxical agitation (rare, more common in children and elderly)\n\n"
            + "##The opioid-benzo combo:##\n\n"
            + "Midazolam + fentanyl (or any opioid) = synergistic respiratory depression. If you give both, reduce the dose of each by 30-50%.\n\n"
            + "##Red flags:##\n\n"
            + "• Respiratory rate <8 or apnea → Stimulate, bag, consider flumazenil\n"
            + "• Severe hypotension → Fluids, pressors if needed\n"
            + "• Paradoxical agitation → Stop midazolam, switch to another sedative",
            dose: "##Procedural sedation (adult):##\n\n"
            + "• Start with 0.5-1 mg IV slow push\n"
            + "• Titrate by 0.5-1 mg every 2-3 minutes\n"
            + "• Typical total dose: 2-5 mg\n"
            + "• Max: 10 mg (elderly: max 5 mg)\n\n"
            + "##RSI (induction):##\n\n"
            + "• 0.2-0.3 mg/kg IV (5-10 mg for average adult)\n"
            + "• Give slowly over 30-60 seconds\n\n"
            + "##ICU sedation (continuous infusion):##\n\n"
            + "• Loading dose: 2-5 mg IV\n"
            + "• Infusion: 1-7 mg/hr (titrate to RASS target)\n\n"
            + "##Status epilepticus (alternative to lorazepam):##\n\n"
            + "• 0.1-0.2 mg/kg IV (5-10 mg typical adult dose)\n"
            + "• Repeat in 5-10 minutes if seizures persist\n\n"
            + "##Pediatric procedural sedation:##\n\n"
            + "• 0.05-0.1 mg/kg IV (max 5 mg)\n"
            + "• Intranasal: 0.2-0.3 mg/kg (for uncooperative kids)\n\n"
            + "##Administration:##\n\n"
            + "• Always give slow IV push (over 1-2 minutes)\n"
            + "• Wait 2-3 minutes between doses to assess effect\n"
            + "• Reduce dose by 30-50% in elderly or when combined with opioids",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.D),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.D),
            DrugClass: "Benzodiazepine, GABA-A agonist, sedative-hypnotic.\n\n"
            + "The most commonly used benzo for procedural sedation and ICU sedation.",
            indications: "##Primary indications:##\n\n"
            + "• Procedural sedation (endoscopy, cardioversion, fracture reduction)\n"
            + "• RSI induction agent (alternative to etomidate)\n"
            + "• ICU sedation (mechanically ventilated patients)\n"
            + "• Status epilepticus (second-line after lorazepam)\n"
            + "• Anxiolysis pre-procedure\n\n"
            + "##You'll reach for midazolam when:##\n\n"
            + "• Patient needs sedation for a short procedure (and you want them to forget it)\n"
            + "• You're intubating and want a sedative without much hemodynamic effect\n"
            + "• Patient is agitated on the ventilator and needs ICU sedation\n"
            + "• Seizures aren't stopping and you've already given lorazepam\n\n"
            + "##Classic scenario:## Patient needs a cardioversion. Give midazolam 2-5 mg IV slowly until they're sedated, shock them, and they wake up 10 minutes later with no memory of it.",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity to benzodiazepines\n"
            + "• Acute narrow-angle glaucoma\n"
            + "• Severe respiratory depression (unless intubated)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Shock or severe hypotension (midazolam can drop BP further)\n"
            + "• Elderly or frail patients (increased sensitivity, higher fall risk)\n"
            + "• COPD or sleep apnea (respiratory depression risk)\n"
            + "• Concurrent use of other CNS depressants (opioids, alcohol)\n\n"
            + "##Critical safety point:## Never give midazolam alone for painful procedures — it has no analgesic effect. Always combine with an opioid (fentanyl) or use a different agent (ketamine).",
            onSet: "1-5 min",
            halfLife: "2-6 hrs",
            duration: "2-4 hrs",
            absorbtion: "Well",
            distribution: "Lipophilic (rapid CNS penetration)",
            metaBolism: "Liver (CYP3A4)",
            excretion: "Urine",
            pregnancyExplanation: "Category D. Avoid in pregnancy (risk of cleft palate in first trimester, neonatal withdrawal/floppy baby syndrome).",
            criticalPearls: "##How to use midazolam safely:##\n\n"
            + "##Before giving:##\n\n"
            + "• Assess hemodynamic status (BP, heart rate)\n"
            + "• Check respiratory status (rate, effort, oxygen saturation)\n"
            + "• Have bag-mask, oxygen, and flumazenil at bedside\n"
            + "• Reduce dose in elderly (start with 0.5 mg and titrate)\n"
            + "• Reduce dose by 30-50% if combining with opioids\n\n"
            + "##During administration:##\n\n"
            + "• Give slowly (over 1-2 minutes)\n"
            + "• Wait 2-3 minutes to assess effect before giving more\n"
            + "• Monitor BP, heart rate, respiratory rate, SpO₂ continuously\n\n"
            + "##After giving:##\n\n"
            + "• Watch for respiratory depression (peaks at 5-10 minutes)\n"
            + "• If apnea → Stimulate, bag, give flumazenil if severe\n"
            + "• If hypotension → Fluids, consider small dose of phenylephrine\n"
            + "• Patient will have amnesia — don't expect them to remember instructions\n\n"
            + "##The amnesia effect:##\n\n"
            + "Midazolam causes anterograde amnesia, meaning patients won't remember anything after you give it. This is great for procedures, but it also means they won't remember post-procedure instructions. Write things down.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving too much too fast → Apnea, hypotension\n"
            + "• Using midazolam alone for painful procedures (it doesn't treat pain)\n"
            + "• Not reducing dose in elderly (they're way more sensitive)\n"
            + "• Combining with opioids without dose reduction (synergistic respiratory depression)\n\n"
            + "##The takeaway:##\n\n"
            + "Midazolam is the go-to sedative for procedures because it's fast, short-acting, and creates amnesia. Titrate slowly, watch the breathing and blood pressure, and always have flumazenil ready. It's safe when dosed correctly, but it can cause apnea and hypotension if you push it too fast."
        ),
        
        // 45. Morphine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Morphine Sulfate",
            brandName: "MSO4 ®",
            mechansim: "Morphine is a mu (μ) opioid receptor agonist that provides analgesia, sedation, and euphoria.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of morphine as the classic, versatile opioid — it's slower and less potent than fentanyl, but it lasts longer (4 hours vs. 30 minutes). The trade-off: morphine causes more histamine release, leading to hypotension and vasodilation.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to μ (mu) opioid receptors in the brain and spinal cord\n"
            + "• Inhibits ascending pain pathways\n"
            + "• Activates descending pain inhibition\n"
            + "• Also affects κ (kappa) and δ (delta) receptors\n\n"
            + "##Key concept:## Morphine is unique because it causes histamine release, which leads to vasodilation and hypotension. This makes it useful for pulmonary edema (preload reduction) but less ideal for hemodynamically unstable patients (use fentanyl instead).\n\n"
            + "##High-yield point:## Morphine is renally cleared, so it accumulates in kidney failure. The active metabolite (morphine-6-glucuronide) builds up and can cause prolonged sedation and respiratory depression. Use lower doses or switch to fentanyl/hydromorphone in renal failure.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypotension (histamine-mediated vasodilation)\n"
            + "• Respiratory depression (dose-dependent)\n"
            + "• Nausea/vomiting\n"
            + "• Pruritus (itching)\n"
            + "• Constipation\n\n"
            + "##Serious:##\n\n"
            + "• Severe respiratory depression (overdose)\n"
            + "• Hypotension requiring vasopressors\n"
            + "• Bronchospasm (histamine-induced, avoid in asthma)\n"
            + "• Accumulation in renal failure → prolonged sedation\n\n"
            + "##Histamine release:##\n\n"
            + "##Morphine directly triggers## mast cell degranulation, releasing histamine. This causes:\n"
            + "• Vasodilation → Hypotension\n"
            + "• Bronchospasm (avoid in asthma/COPD)\n"
            + "• Flushing, itching, urticaria\n\n"
            + "##Why this matters:## If the patient is hypotensive or has asthma, use fentanyl instead (no histamine release).\n\n"
            + "##Red flags:##\n\n"
            + "• Respiratory rate <8-10 breaths/min → Respiratory depression, consider naloxone\n"
            + "• Hypotension after morphine → Histamine release, give fluids, avoid in shock\n"
            + "• Renal failure patient becoming oversedated → Morphine-6-glucuronide accumulation, switch to fentanyl",
            dose: "##Acute Pain (moderate to severe):##\n\n"
            + "• 2-10 mg IV/IM/SC q2-4h PRN\n"
            + "• Titrate to effect\n\n"
            + "##Patient-Controlled Analgesia (PCA):##\n\n"
            + "• Bolus: 1-2 mg IV\n"
            + "• Lockout: 5-10 minutes\n"
            + "• Max hourly dose: 10-30 mg\n\n"
            + "##Continuous Infusion (rare, fentanyl preferred):##\n\n"
            + "• 2-30 mg/hr IV\n\n"
            + "##Pulmonary Edema (acute cardiogenic):##\n\n"
            + "• 2-4 mg IV (preload reduction via vasodilation)\n\n"
            + "##Renal Dosing:##\n\n"
            + "• Reduce dose by 50% in CrCl <10 mL/min or consider fentanyl/hydromorphone instead\n\n"
            + "##Pediatric:##\n\n"
            + "• 0.05-0.1 mg/kg IV q2-4h",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "##Opioid analgesic (μ-receptor agonist).##\n\n"
            + "The classic opioid — slower onset, longer duration, more histamine release than fentanyl.",
            indications: "##Standard Indications:##\n\n"
            + "• Moderate to severe pain\n"
            + "• Post-operative pain\n"
            + "• Acute coronary syndrome (ACS) — for pain and anxiety\n"
            + "• Acute pulmonary edema (preload reduction)\n\n"
            + "When to reach for morphine:##\n\n"
            + "• Patient has severe pain and is hemodynamically stable\n"
            + "• Acute pulmonary edema (morphine helps reduce preload)\n"
            + "• Post-op pain management\n"
            + "• Chronic pain in a patient with normal renal function\n\n"
            + "When NOT to use morphine:##\n\n"
            + "• Hemodynamically unstable (use fentanyl instead)\n"
            + "• Asthma or severe COPD (histamine → bronchospasm)\n"
            + "• Renal failure (use fentanyl or hydromorphone instead)\n\n"
            + "##Clinical clues:## Patient is in pain, hemodynamically stable, and needs longer-acting analgesia than fentanyl provides.",
            contraindiction: "##Absolute:##\n\n"
            + "• Severe respiratory depression without airway support\n"
            + "• Acute or severe bronchial asthma (histamine → bronchospasm)\n\n"
            + "##Caution:##\n\n"
            + "• Hypotension (histamine-mediated vasodilation)\n"
            + "• Renal failure (active metabolite accumulation)\n"
            + "• Head injury or increased ICP (can worsen CO₂ retention)\n"
            + "• Elderly (increased sensitivity, fall risk)\n"
            + "• Concurrent CNS depressants (benzos, alcohol)\n\n"
            + "##Important:## If the patient is hypotensive, in shock, or has renal failure, choose fentanyl or hydromorphone instead.",
            onSet: "5-10 min (IV); 30 min (PO)",
            halfLife: "2-4 hours",
            duration: "4 hours",
            absorbtion: "Well absorbed (oral bioavailability 20-40% due to first-pass metabolism)",
            distribution: "Widely distributed, crosses BBB and placenta",
            metaBolism: "Hepatic (morphine-3-glucuronide and morphine-6-glucuronide)\n\n"
            + "• M6G is active and more potent than morphine\n"
            + "• M6G accumulates in renal failure → prolonged effects",
            excretion: "Renal (90% as glucuronide metabolites)\n\n"
            + "##Reduce dose in renal failure!##",
            pregnancyExplanation: "##Pregnancy Category C:## Crosses the placenta. Chronic use can cause neonatal withdrawal. Use lowest effective dose for shortest duration.",
            criticalPearls: "##Histamine Release##\n\n"
            + "• Causes ##more hypotension## than fentanyl.\n"
            + "• Useful for ##pulmonary edema## (preload reduction via vasodilation).\n"
            + "• Avoid in asthma/COPD (histamine → bronchospasm).\n\n"
            + "##Renal Failure##\n\n"
            + "• Morphine-6-glucuronide (active metabolite) accumulates in renal failure\n"
            + "• Causes prolonged sedation and respiratory depression\n"
            + "• Reduce dose by 50% or switch to fentanyl/hydromorphone\n\n"
            + "##Morphine vs. Fentanyl:##\n\n"
            + "• ##Morphine:## Longer-acting (4 hrs), causes histamine release (hypotension), renally cleared\n"
            + "• ##Fentanyl:## Shorter-acting (30 min), no histamine release (hemodynamically neutral), hepatically cleared\n\n"
            + "##Pulmonary Edema Use:##\n\n"
            + "• Morphine 2-4 mg IV reduces preload (vasodilation) and anxiety\n"
            + "• However, recent studies show no mortality benefit and risk of respiratory depression\n"
            + "• Use cautiously — NIV and diuretics are first-line\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Morphine is the classic opioid for moderate to severe pain in hemodynamically stable patients. It's longer-acting than fentanyl but causes more hypotension (histamine release). Avoid in renal failure (active metabolite accumulation), asthma (bronchospasm risk), and hypotension. For ICU analgesia or unstable patients, fentanyl is usually better.\n\n"
            + "##High-yield point:## Morphine is useful for pulmonary edema (preload reduction), but it accumulates in renal failure and causes hypotension. If the patient is in shock or has kidney disease, use fentanyl instead."
        ),
        
        // 46. Naloxone
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Naloxone",
            brandName: "Narcan ®",
            mechansim: "Naloxone is a pure opioid antagonist that works by competitively blocking opioid receptors.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of naloxone as the opioid off-switch. It kicks opioids off the mu, kappa, and delta receptors and reverses all opioid effects — analgesia, sedation, and respiratory depression.\n\n"
            + "##How it works:##\n\n"
            + "• Competitively binds to opioid receptors (μ, κ, δ)\n"
            + "• Displaces opioid agonists from receptors\n"
            + "• Reverses respiratory depression, sedation, and analgesia\n"
            + "• No agonist activity (doesn't cause respiratory depression on its own)\n\n"
            + "##The key:## Naloxone's half-life (30-90 minutes) is shorter than most opioids (morphine 2-4 hours, fentanyl 2-4 hours, methadone 8-59 hours). This means patients can re-sedate after naloxone wears off. Always observe for at least 2 hours, longer for long-acting opioids.\n\n"
            + "##High-yield point:## The goal isn't to wake the patient up completely — it's to restore adequate respirations. Titrate naloxone slowly to avoid precipitating acute withdrawal (agitation, vomiting, hypertension, pulmonary edema). Give just enough to get them breathing.",
            adverseEffects: "##Common:##\n\n"
            + "• Acute opioid withdrawal (agitation, nausea, vomiting, diarrhea)\n"
            + "• Hypertension, tachycardia\n"
            + "• Pain (reversal of analgesia)\n\n"
            + "##Serious:##\n\n"
            + "• Severe hypertensive crisis (can cause stroke or MI)\n"
            + "• Pulmonary edema (non-cardiogenic)\n"
            + "• Ventricular arrhythmias\n"
            + "• Seizures (rare)\n\n"
            + "##Acute withdrawal syndrome:##\n\n"
            + "This happens when you give too much naloxone too fast to an opioid-dependent patient. They go from deeply sedated to extremely agitated in seconds — vomiting, combative, hypertensive. It's dangerous for both the patient and the staff.\n\n"
            + "##How to avoid it:##\n\n"
            + "• Titrate slowly (0.04-0.1 mg at a time)\n"
            + "• Only give enough to restore respirations, not full consciousness\n"
            + "• If patient wakes up and starts breathing, stop giving naloxone\n\n"
            + "##Red flags:##\n\n"
            + "• Patient suddenly becomes combative and vomiting → Acute withdrawal\n"
            + "• Patient improves then deteriorates 30-60 min later → Re-sedation (give more naloxone or start infusion)\n"
            + "• Pulmonary edema after naloxone → Non-cardiogenic, treat with oxygen and positive pressure",
            dose: "##Opioid overdose with respiratory depression:##\n\n"
            + "• Start low: 0.04-0.1 mg IV (dilute 0.4 mg in 10 mL, give 1-2 mL)\n"
            + "• Titrate: Give 0.04-0.1 mg every 2-3 minutes\n"
            + "• Goal: Adequate respirations (RR >10, SpO₂ >90%), not full consciousness\n"
            + "• Max: 2-10 mg total (if no response, consider other causes)\n\n"
            + "##Opioid overdose without IV access:##\n\n"
            + "• Intranasal: 2-4 mg (using nasal spray device)\n"
            + "• IM: 0.4-2 mg\n"
            + "• Onset is slower (5-10 minutes vs 1-2 minutes IV)\n\n"
            + "##Post-operative opioid-induced respiratory depression:##\n\n"
            + "• 0.04-0.1 mg IV every 2-3 minutes\n"
            + "• Titrate carefully to avoid reversing all analgesia\n\n"
            + "##Naloxone infusion (for long-acting opioids):##\n\n"
            + "• Loading dose: 0.4-2 mg IV\n"
            + "• Infusion: 0.25-0.5 mg/hr (titrate to respiratory rate)\n"
            + "• Use for methadone, sustained-release opioids\n\n"
            + "##Pediatric:##\n\n"
            + "• 0.01-0.1 mg/kg IV/IM/IO (max 2 mg per dose)\n\n"
            + "##Administration:##\n\n"
            + "• Dilute 0.4 mg ampule in 10 mL saline for precise titration\n"
            + "• Give slowly, 1 mL at a time\n"
            + "• Wait 2-3 minutes between doses to assess effect",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Pure opioid antagonist, antidote.\n\n"
            + "The reversal agent for all opioid overdoses.",
            indications: "##Primary indications:##\n\n"
            + "• Opioid overdose with respiratory depression\n"
            + "• Post-operative opioid-induced respiratory depression\n"
            + "• Reversal of procedural sedation (opioids)\n"
            + "• Neonatal respiratory depression (maternal opioid use)\n\n"
            + "##You'll reach for naloxone when:##\n\n"
            + "• Unresponsive patient with pinpoint pupils and respiratory depression\n"
            + "• Post-op patient with RR <8 after receiving opioids\n"
            + "• Known opioid overdose (heroin, fentanyl, prescription opioids)\n"
            + "• Patient on opioid infusion becomes apneic\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Unresponsive patient found with needles nearby, pinpoint pupils, RR 4 → Naloxone 0.4 mg IV/IM\n"
            + "• Post-op patient on PCA, RR 6, SpO₂ 88% → Naloxone 0.04-0.1 mg IV (titrate slowly)\n"
            + "• Chronic pain patient on methadone, found unresponsive → Naloxone + infusion (long-acting opioid)",
            contraindiction: "##Absolute:##\n\n"
            + "• No absolute contraindications in life-threatening respiratory depression\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Known opioid dependence (risk of severe withdrawal)\n"
            + "• Cardiovascular disease (naloxone can cause hypertensive crisis)\n"
            + "• Recent cardiac surgery (stress response can cause complications)\n\n"
            + "##Critical safety point:## In a life-threatening overdose, there are no contraindications. Give naloxone to save the airway and restore breathing. But titrate carefully in opioid-dependent patients to avoid violent withdrawal.",
            onSet: "1-2 min (IV), 5-10 min (IM/IN)",
            halfLife: "30-90 min",
            duration: "45-90 min (shorter than most opioids)",
            absorbtion: "Well (all routes: IV, IM, IN)",
            distribution: "Widely distributed, crosses placenta",
            metaBolism: "Liver (first-pass metabolism limits oral bioavailability)",
            excretion: "Urine",
            pregnancyExplanation: "Category C. Safe to use in pregnancy for life-threatening maternal opioid overdose. May precipitate withdrawal in opioid-dependent mothers and neonates.",
            criticalPearls: "##How to use naloxone safely:##\n\n"
            + "For opioid overdose:##\n\n"
            + "• Dilute 0.4 mg in 10 mL saline (makes 0.04 mg/mL)\n"
            + "• Give 1-2 mL (0.04-0.08 mg) every 2-3 minutes\n"
            + "• Goal: RR >10, SpO₂ >90% — NOT full consciousness\n"
            + "• If patient starts breathing and responds to voice, STOP\n"
            + "• Watch for at least 2 hours (naloxone wears off faster than opioids)\n\n"
            + "##When to give more naloxone:##\n\n"
            + "• If no response after 2 mg → Consider other causes (benzodiazepines, hypoglycemia, head injury)\n"
            + "• If patient improves then deteriorates 30-60 min later → Re-sedation (give more naloxone)\n"
            + "• For long-acting opioids (methadone, sustained-release morphine) → Start naloxone infusion\n\n"
            + "##The re-sedation problem:##\n\n"
            + "Naloxone's duration (45-90 min) is shorter than most opioids:\n"
            + "• Morphine: 2-4 hours\n"
            + "• Fentanyl: 2-4 hours\n"
            + "• Methadone: 8-59 hours\n"
            + "• Buprenorphine: 24-72 hours\n\n"
            + "This means patients can \"wake up\" initially, then re-sedate when naloxone wears off. Always observe for at least 2 hours, longer for long-acting opioids.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving full 0.4-2 mg bolus to opioid-dependent patient (causes violent withdrawal)\n"
            + "• Waking patient up completely instead of just restoring respirations\n"
            + "• Not observing long enough (patient re-sedates after naloxone wears off)\n"
            + "• Not considering naloxone infusion for long-acting opioids\n"
            + "• Forgetting to give naloxone for iatrogenic opioid overdose (post-op, procedural sedation)\n\n"
            + "##The takeaway:##\n\n"
            + "Naloxone reverses opioid-induced respiratory depression fast and effectively. Titrate slowly (0.04-0.1 mg at a time) to restore breathing without causing violent withdrawal. Watch for re-sedation — naloxone wears off faster than most opioids. The goal is adequate respirations, not a wide-awake patient."
        ),
        
        // 47. Nitroglycerine (Updated)
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Nitroglycerine",
            brandName: "Nitrostat ®",
            mechansim: "Nitroglycerin is an organic nitrate that releases nitric oxide (NO), causing vasodilation — primarily venous, with some arterial effects at higher doses.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of nitroglycerin as the preload reducer. It dilates veins more than arteries, reducing blood return to the heart (preload). Less blood filling the heart means less work, less oxygen demand, and relief of anginal chest pain. At higher doses, it also dilates arteries (reduces afterload) and coronary arteries directly.\n\n"
            + "##How it works:##\n\n"
            + "• Converted to nitric oxide (NO) in vascular smooth muscle\n"
            + "• NO activates guanylate cyclase → Increases cGMP → Smooth muscle relaxation\n"
            + "• Low doses: Primarily venodilation → Decreases preload\n"
            + "• Higher doses: Arterial dilation → Decreases afterload, coronary vasodilation\n\n"
            + "##The key:## Nitroglycerin is first-line for angina and acute coronary syndrome. It reduces myocardial oxygen demand (preload reduction) and increases coronary blood flow (direct coronary dilation). However, it's contraindicated in right ventricular MI (preload-dependent) and with PDE5 inhibitors (sildenafil/Viagra).\n\n"
            + "##High-yield point:## ALWAYS ask about erectile dysfunction medications (Viagra, Cialis, Levitra) before giving nitroglycerin. The combination causes profound, refractory hypotension. Wait 24 hours after sildenafil, 48 hours after tadalafil before giving nitroglycerin.",
            adverseEffects: "##Common:##\n\n"
            + "• Headache (most common — from cerebral vasodilation)\n"
            + "• Hypotension\n"
            + "• Flushing\n"
            + "• Dizziness, lightheadedness\n\n"
            + "##Serious:##\n\n"
            + "• Severe hypotension (especially with PDE5 inhibitors or RV MI)\n"
            + "• Reflex tachycardia\n"
            + "• Methemoglobinemia (rare, with prolonged high doses)\n"
            + "• Tolerance (with continuous use >24 hours)\n\n"
            + "##The PDE5 inhibitor problem:##\n\n"
            + "Sildenafil (Viagra), tadalafil (Cialis), and vardenafil (Levitra) potentiate the hypotensive effects of nitroglycerin. The combination can cause severe, refractory hypotension that doesn't respond to fluids or vasopressors.\n\n"
            + "##Timing:##\n\n"
            + "• Sildenafil/vardenafil: Wait 24 hours\n"
            + "• Tadalafil: Wait 48 hours\n\n"
            + "##Red flags:##\n\n"
            + "• SBP <90 after nitroglycerin (stop, give fluids)\n"
            + "• Profound hypotension not responding to fluids (consider PDE5 inhibitor use)\n"
            + "• Bradycardia with hypotension (vagal response)",
            dose: "##Sublingual (for angina):##\n\n"
            + "• 0.4 mg (1 tablet) SL every 5 minutes\n"
            + "• Max: 3 tablets in 15 minutes\n"
            + "• If no relief after 3 tablets → Call 911\n\n"
            + "##IV Infusion (for ACS, CHF, hypertensive emergency):##\n\n"
            + "• Start: 5-10 mcg/min IV\n"
            + "• Titrate: Increase by 5-10 mcg/min every 3-5 minutes\n"
            + "• Usual range: 20-200 mcg/min\n"
            + "• Target: Symptom relief, BP reduction (don't drop SBP <90)\n\n"
            + "##Topical (for chronic angina):##\n\n"
            + "• 0.5-2 inches paste q6-8h\n"
            + "• Nitrate-free interval (10-12 hrs) to prevent tolerance\n\n"
            + "##Administration:##\n\n"
            + "• Use non-PVC tubing (nitroglycerin binds to PVC)\n"
            + "• Monitor BP closely\n"
            + "• Ask about PDE5 inhibitors before giving",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Organic nitrate vasodilator.\n\n"
            + "Primarily venodilator (reduces preload), with arterial effects at higher doses.",
            indications: "##Primary indications:##\n\n"
            + "• Acute coronary syndrome (angina, STEMI, NSTEMI)\n"
            + "• Acute pulmonary edema / decompensated heart failure\n"
            + "• Hypertensive emergency (with myocardial ischemia)\n"
            + "• Chronic stable angina (prophylaxis)\n\n"
            + "##You'll reach for nitroglycerin when:##\n\n"
            + "• Chest pain concerning for ACS → SL nitroglycerin (after ruling out RV MI)\n"
            + "• Acute heart failure with pulmonary edema → IV nitroglycerin (reduces preload)\n"
            + "• Hypertensive emergency with chest pain → IV nitroglycerin\n\n"
            + "##Classic scenarios:##\n\n"
            + "• 55-year-old with crushing chest pain → Aspirin + nitroglycerin SL 0.4 mg\n"
            + "• CHF exacerbation with rales, SBP 180 → IV nitroglycerin to reduce preload\n"
            + "• STEMI anterior wall → Nitroglycerin for ischemia (but check for RV involvement)",
            contraindiction: "##Absolute:##\n\n"
            + "• PDE5 inhibitor use (sildenafil within 24 hrs, tadalafil within 48 hrs)\n"
            + "• Right ventricular MI (preload dependent — nitroglycerin can cause cardiovascular collapse)\n"
            + "• Severe hypotension (SBP <90)\n"
            + "• Severe aortic stenosis\n"
            + "• Hypertrophic cardiomyopathy with obstruction\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Inferior STEMI (may have RV involvement — check right-sided leads)\n"
            + "• Volume depletion\n"
            + "• Concurrent use of other vasodilators\n\n"
            + "##Critical safety point:## ALWAYS ask about erectile dysfunction medications before giving nitroglycerin. The combination with PDE5 inhibitors causes severe, refractory hypotension. Also, check for RV MI in inferior STEMI before giving nitroglycerin.",
            onSet: "1-3 min (SL), 1-2 min (IV)",
            halfLife: "1-4 min",
            duration: "20-30 min (SL), duration of infusion + 5-10 min (IV)",
            absorbtion: "Rapid (SL bypasses first-pass metabolism)",
            distribution: "Widely distributed",
            metaBolism: "Liver (first-pass effect with oral)",
            excretion: "Urine (as metabolites)",
            pregnancyExplanation: "Category B. Generally safe in pregnancy when maternal condition requires treatment. Monitor for hypotension which can affect fetal perfusion.",
            criticalPearls: "##How to use nitroglycerin safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• ASK ABOUT PDE5 INHIBITORS (Viagra, Cialis, Levitra)\n"
            + "• Check blood pressure (hold if SBP <90)\n"
            + "• Check for RV MI in inferior STEMI (right-sided leads)\n"
            + "• Rule out severe aortic stenosis\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor BP frequently (every 5-10 min initially)\n"
            + "• Watch for headache (common, treat with acetaminophen)\n"
            + "• Titrate to symptom relief and BP\n"
            + "• Keep SBP ≥90 mmHg\n\n"
            + "##Right Ventricular MI — the critical exception:##\n\n"
            + "In inferior STEMI##, the right ventricle may be infarcted too. The RV is preload-dependent — it needs adequate filling to pump blood. Nitroglycerin reduces preload, which can cause:\n\n"
            + "• Severe hypotension\n"
            + "• Cardiovascular collapse\n"
            + "• Death\n\n"
            + "##Before nitroglycerin in inferior STEMI:##\n\n"
            + "• Get right-sided ECG leads (V4R)\n"
            + "• ST elevation in V4R = RV MI\n"
            + "• If RV MI present → Hold nitroglycerin, give fluids instead\n\n"
            + "##PDE5 Inhibitor Interaction:##\n\n"
            + "Both nitroglycerin and PDE5 inhibitors increase cGMP → Profound vasodilation and hypotension.\n\n"
            + "##Safe intervals:##\n\n"
            + "• Sildenafil (Viagra): Wait 24 hours\n"
            + "• Vardenafil (Levitra): Wait 24 hours\n"
            + "• Tadalafil (Cialis): Wait 48 hours (longer half-life)\n\n"
            + "If hypotension occurs with PDE5 inhibitor + nitrate:##\n\n"
            + "• IV fluids (aggressive)\n"
            + "• Vasopressors may not work well (cGMP pathway is bypassed)\n"
            + "• Consider methylene blue (inhibits guanylate cyclase) if refractory\n\n"
            + "##Nitrate Tolerance:##\n\n"
            + "##With continuous nitroglycerin## use (>24 hours), tolerance develops:\n\n"
            + "• Effectiveness decreases\n"
            + "• Need higher doses for same effect\n"
            + "• Prevention: Nitrate-free interval (10-12 hours/day)\n"
            + "• Clinical relevance: Less of an issue with acute use (ACS, CHF)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not asking about PDE5 inhibitors (life-threatening hypotension)\n"
            + "• Giving nitroglycerin in RV MI (cardiovascular collapse)\n"
            + "• Giving nitroglycerin when SBP <90\n"
            + "• Not checking right-sided leads in inferior STEMI\n\n"
            + "##The takeaway:##\n\n"
            + "Nitroglycerin is a venodilator that reduces preload, decreasing myocardial oxygen demand. Give 0.4 mg SL for angina or 5-200 mcg/min IV for ACS/CHF. ALWAYS ask about Viagra/Cialis (wait 24-48 hours). ALWAYS check for RV MI in inferior STEMI (get V4R). Keep SBP ≥90."
        ),
        
        // 48. Norepinephrine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Norepinephrine",
            brandName: "Levophed",
            mechansim: "Norepinephrine is a powerful vasopressor that hits two receptors simultaneously.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of norepinephrine as tightening the vascular pipes while also squeezing the pump.\n\n"
            + "##Primary action (Alpha-1):##\n\n"
            + "• Vasoconstriction → Increases systemic vascular resistance (SVR)\n"
            + "• Raises blood pressure by tightening arteries\n\n"
            + "##Secondary action (Beta-1):##\n\n"
            + "• Increases contractility (inotropy)\n"
            + "• Minimal chronotropy (doesn't significantly increase heart rate)\n\n"
            + "##The key:## Norepinephrine is the first-line vasopressor for septic shock because it increases MAP without causing significant tachycardia. The alpha effects dominate — you're raising pressure through vasoconstriction, not by revving the heart.\n\n"
            + "##High-yield point:## Norepinephrine is preferred over dopamine in septic shock (SOAP II trial). Dopamine causes more arrhythmias and has unpredictable dose-dependent effects.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypertension (excessive vasoconstriction)\n"
            + "• Reflex bradycardia (baroreceptor response)\n\n"
            + "##Serious:##\n\n"
            + "• Tissue ischemia (fingers, toes, gut, kidneys)\n"
            + "• Arrhythmias (ventricular ectopy, V-tach)\n"
            + "• Extravasation injury → Tissue necrosis if IV infiltrates\n\n"
            + "##What ischemia looks like:##\n\n"
            + "• Cold, mottled extremities\n"
            + "• Rising lactate despite adequate MAP\n"
            + "• Acute kidney injury\n"
            + "• Mesenteric ischemia (abdominal pain, rising lactate)\n\n"
            + "##Red flags to reduce or stop:##\n\n"
            + "• Dose >20 mcg/min (consider adding vasopressin)\n"
            + "• New arrhythmias or ischemic ECG changes\n"
            + "• Worsening lactic acidosis despite MAP >65",
            dose: "##Initial dose:## 8-12 mcg/min IV\n\n"
            + "##Titration:## Adjust by 2-4 mcg/min every 2-5 minutes\n\n"
            + "##Target:## MAP ≥65 mmHg (or patient-specific goal)\n\n"
            + "##Typical range:## 2-20 mcg/min\n\n"
            + "##High-dose:## >20 mcg/min (consider adding vasopressin or stress-dose steroids)\n\n"
            + "##Administration:##\n\n"
            + "• Requires central line (peripheral OK temporarily if no alternative)\n"
            + "• Standard concentration: 16 mg in 250 mL (64 mcg/mL)\n"
            + "• NEVER stop abruptly — wean slowly",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Vasopressor, sympathomimetic, catecholamine.\n\n"
            + "The most commonly used first-line vasopressor in septic shock and most forms of distributive shock.",
            indications: "##Primary indications:##\n\n"
            + "• Septic shock (first-line per Surviving Sepsis Campaign)\n"
            + "• Distributive shock (anaphylaxis, neurogenic)\n"
            + "• Cardiogenic shock (after fluid resuscitation)\n"
            + "• Hypotension during anesthesia\n\n"
            + "##You'll reach for norepinephrine when:##\n\n"
            + "• MAP <65 mmHg despite adequate fluid resuscitation\n"
            + "• Septic patient with warm shock (low SVR, normal/high cardiac output)\n"
            + "• Anaphylaxis not responding to epinephrine alone\n"
            + "• Post-cardiac arrest with persistent hypotension\n\n"
            + "##Classic scenario:## Septic patient, lactate 4.5, given 30 mL/kg fluids, MAP still 58 → Start norepinephrine.",
            contraindiction: "##Absolute:##\n\n"
            + "• Hypovolemia (must give fluids first)\n"
            + "• Pheochromocytoma (unless alpha-blocked)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Mesenteric ischemia (can worsen)\n"
            + "• Peripheral vascular disease\n"
            + "• Tachydysrhythmias\n\n"
            + "##Critical safety point:## Never use norepinephrine to substitute for adequate volume resuscitation. Fix the tank before you tighten the pipes.",
            onSet: "Immediate",
            halfLife: "2 min",
            duration: "Few min",
            absorbtion: "IV",
            distribution: "Widely",
            metaBolism: "Hepatic",
            excretion: "Urine",
            pregnancyExplanation: "Use with caution. Benefits typically outweigh risks in life-threatening maternal hypotension.",
            criticalPearls: "##How to use norepinephrine safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Ensure adequate fluid resuscitation (30 mL/kg crystalloid in sepsis)\n"
            + "• Establish central access if possible (peripheral OK temporarily)\n"
            + "• Set MAP goal (usually ≥65 mmHg, may be higher in chronic hypertension)\n\n"
            + "##While it's running:##\n\n"
            + "• Titrate to MAP goal every 2-5 minutes\n"
            + "• Monitor for end-organ perfusion (urine output, lactate clearance, mentation)\n"
            + "• Watch extremities for ischemia\n"
            + "• Check for extravasation at IV site\n\n"
            + "##If dose exceeds 20 mcg/min:##\n\n"
            + "• Add vasopressin 0.03-0.04 units/min (synergistic effect)\n"
            + "• Consider stress-dose hydrocortisone if septic shock\n"
            + "• Reassess fluid status\n"
            + "• Check for occult bleeding or ongoing septic source\n\n"
            + "##Weaning:##\n\n"
            + "• Reduce gradually as patient improves\n"
            + "• Ensure adequate volume status\n"
            + "• Wean by 2-4 mcg/min decrements\n"
            + "• Never stop abruptly (can cause rebound hypotension)\n\n"
            + "##The takeaway:##\n\n"
            + "Norepinephrine is your first-line pressor for septic shock — powerful, predictable, and safer than dopamine. Start early after fluids, titrate to MAP goal, watch for ischemia, and remember: pressors buy time while you fix the underlying problem."
        ),
        
        // 49. Octreotide
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Octreotide",
            brandName: "Sandostatin",
            mechansim: "Octreotide is a synthetic somatostatin analog that reduces splanchnic blood flow and inhibits hormone secretion.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of octreotide as the variceal bleeding stopper and sulfonylurea antidote. It mimics somatostatin, reducing portal venous pressure (stops variceal bleeding) and inhibiting insulin release (reverses sulfonylurea-induced hypoglycemia). It's the pharmacological adjunct to endoscopy for GI bleeds.\n\n"
            + "##How it works:##\n\n"
            + "• Reduces splanchnic blood flow → Lowers portal venous pressure\n"
            + "• Inhibits gastric acid secretion → Reduces GI bleeding\n"
            + "• Inhibits insulin release → Reverses sulfonylurea hypoglycemia\n"
            + "• Inhibits glucagon, GH, TSH → Various endocrine effects\n\n"
            + "##The key:## Octreotide is used as an adjunct to endoscopy for esophageal variceal bleeding (reduces re-bleeding) and as the antidote for sulfonylurea overdose (inhibits insulin release from pancreas).\n\n"
            + "##High-yield point:## Octreotide is the antidote for sulfonylurea overdose. Sulfonylureas (glipizide, glyburide) cause hypoglycemia by forcing insulin release. Dextrose alone can actually worsen hypoglycemia by triggering more insulin release. Octreotide blocks insulin release, breaking this cycle.",
            adverseEffects: "##Common:##\n\n"
            + "• Nausea, diarrhea\n"
            + "• Abdominal pain\n"
            + "• Hyperglycemia (inhibits insulin)\n"
            + "• Injection site pain\n\n"
            + "##Serious:##\n\n"
            + "• Bradycardia\n"
            + "• Gallstones (with chronic use)\n"
            + "• Hypoglycemia (rarely, early in treatment)\n"
            + "• QT prolongation (rare)\n\n"
            + "##The bradycardia problem:##\n\n"
            + "Octreotide can cause bradycardia, especially in patients with cardiac disease. Monitor heart rate during infusion.\n\n"
            + "##Red flags:##\n\n"
            + "• HR <50 (bradycardia)\n"
            + "• Glucose >300 (hyperglycemia from insulin inhibition)\n"
            + "• Severe abdominal pain (rare gallbladder issues)",
            dose: "##Variceal Bleeding:##\n\n"
            + "• Bolus: 50 mcg IV\n"
            + "• Infusion: 50 mcg/hr IV for 3-5 days\n"
            + "• Give as adjunct to endoscopy\n\n"
            + "##Sulfonylurea Overdose:##\n\n"
            + "• 50-100 mcg SQ every 6-12 hours\n"
            + "• Or 50 mcg/hr IV infusion\n"
            + "• Continue until sulfonylurea cleared (may take days)\n\n"
            + "##Carcinoid Crisis:##\n\n"
            + "• 100-500 mcg IV/SQ every 8 hours\n\n"
            + "##Administration:##\n\n"
            + "• Can give IV bolus, IV infusion, or SQ\n"
            + "• For variceal bleeding: Start immediately, continue 3-5 days\n"
            + "• Monitor glucose (causes hyperglycemia)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Somatostatin analog.\n\n"
            + "Used for variceal bleeding (adjunct to endoscopy), sulfonylurea overdose, and carcinoid syndrome.",
            indications: "##Primary indications:##\n\n"
            + "• Esophageal variceal bleeding (adjunct to endoscopy)\n"
            + "• Sulfonylurea overdose (antidote)\n"
            + "• Carcinoid syndrome and crisis\n"
            + "• Acromegaly (chronic use)\n"
            + "• VIPoma, glucagonoma (hormone-secreting tumors)\n\n"
            + "##You'll reach for octreotide when:##\n\n"
            + "• Patient with cirrhosis and upper GI bleeding (suspected varices)\n"
            + "• Sulfonylurea overdose with recurrent hypoglycemia despite dextrose\n"
            + "• Carcinoid crisis (flushing, diarrhea, bronchospasm)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Cirrhotic patient with hematemesis → Octreotide 50 mcg IV bolus, then 50 mcg/hr infusion\n"
            + "• Glipizide overdose, recurrent hypoglycemia despite dextrose → Octreotide 50 mcg SQ q6h\n"
            + "• Carcinoid crisis before surgery → Octreotide 100-500 mcg IV",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Diabetes (can cause hyperglycemia or rarely hypoglycemia)\n"
            + "• Cardiac disease (can cause bradycardia)\n"
            + "• Gallbladder disease (can worsen)\n\n"
            + "##Critical safety point:## Octreotide inhibits insulin release, which can cause hyperglycemia. However, in sulfonylurea overdose, this is the desired effect. Monitor glucose closely in all patients receiving octreotide.",
            onSet: "Rapid (minutes)",
            halfLife: "1.5-2 hrs",
            duration: "6-12 hrs",
            absorbtion: "Rapid (IV and SQ)",
            distribution: "Widely distributed",
            metaBolism: "Liver",
            excretion: "Urine",
            pregnancyExplanation: "Category B. Use in pregnancy only if benefits outweigh risks. Limited human data.",
            criticalPearls: "##How to use octreotide safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• For variceal bleeding: Give immediately, don't wait for endoscopy\n"
            + "• For sulfonylurea overdose: Confirm sulfonylurea ingestion (long-acting → need extended treatment)\n"
            + "• Check glucose and heart rate baseline\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor glucose (causes hyperglycemia in most, rarely hypoglycemia)\n"
            + "• Monitor heart rate (can cause bradycardia)\n"
            + "• For variceal bleeding: Continue 3-5 days\n"
            + "• For sulfonylurea OD: Continue until drug cleared (can take days for long-acting agents)\n\n"
            + "##Octreotide for variceal bleeding:##\n\n"
            + "##Octreotide reduces## portal venous pressure, decreasing bleeding from esophageal varices:\n\n"
            + "• Bolus: 50 mcg IV\n"
            + "• Infusion: 50 mcg/hr IV for 3-5 days\n"
            + "• Start immediately, don't wait for endoscopy\n"
            + "• Used with PPI (pantoprazole) and endoscopic banding\n\n"
            + "##Octreotide for sulfonylurea overdose:##\n\n"
            + "##Sulfonylureas cause## hypoglycemia by forcing insulin release from pancreatic beta cells. The problem with dextrose alone:\n\n"
            + "• Dextrose raises glucose temporarily\n"
            + "• But it also stimulates MORE insulin release\n"
            + "• Leading to rebound hypoglycemia\n\n"
            + "##Octreotide breaks this cycle:##\n\n"
            + "• Blocks insulin release from beta cells\n"
            + "• Prevents rebound hypoglycemia\n"
            + "• Dose: 50-100 mcg SQ every 6-12 hours\n"
            + "• Long-acting sulfonylureas (glipizide, glyburide) need treatment for 1-3 days\n\n"
            + "##Common mistakes:##\n\n"
            + "• Waiting for endoscopy to start octreotide for variceal bleeding (should start immediately)\n"
            + "• Stopping octreotide too early in sulfonylurea OD (long-acting agents need days of treatment)\n"
            + "• Not monitoring glucose (causes hyperglycemia)\n\n"
            + "##The takeaway:##\n\n"
            + "Octreotide is a somatostatin analog that reduces portal pressure (variceal bleeding) and inhibits insulin release (sulfonylurea overdose). For variceal bleeding, give 50 mcg IV bolus then 50 mcg/hr infusion for 3-5 days. For sulfonylurea overdose, give 50-100 mcg SQ every 6-12 hours until the drug clears. Monitor glucose and heart rate."
        ),
        
        // 50. Ondansetron
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Ondansetron",
            brandName: "Zofran ®",
            mechansim: "Ondansetron is a selective 5-HT3 (serotonin) receptor antagonist that blocks nausea and vomiting.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of ondansetron as the serotonin blocker — it prevents serotonin from binding to receptors in the chemoreceptor trigger zone (CTZ) and GI tract, stopping the nausea/vomiting signal. It's the most commonly used antiemetic in the hospital because it's effective, well-tolerated, and doesn't cause sedation.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks 5-HT3 receptors in the CTZ (brainstem) → Prevents nausea signal\n"
            + "• Blocks 5-HT3 receptors in the GI tract → Reduces vomiting reflex\n"
            + "• Does NOT block dopamine receptors (unlike metoclopramide) → No extrapyramidal symptoms\n"
            + "• Does NOT cause sedation (unlike promethazine)\n\n"
            + "##The key:## Ondansetron is first-line for chemotherapy-induced nausea, post-operative nausea, and general nausea/vomiting. It's safe in pregnancy (Category B) and doesn't cause the EPS (extrapyramidal symptoms) that metoclopramide can cause. However, it can prolong QT interval, especially at high doses.\n\n"
            + "##High-yield point:## Ondansetron can cause QT prolongation, especially at doses >16 mg. Avoid in patients with long QT syndrome or on other QT-prolonging drugs. If giving high doses, check ECG.",
            adverseEffects: "##Common:##\n\n"
            + "• Headache (most common)\n"
            + "• Constipation\n"
            + "• Dizziness\n"
            + "• Fatigue\n\n"
            + "##Serious:##\n\n"
            + "• QT prolongation (especially doses >16 mg)\n"
            + "• Torsades de Pointes (rare, with high doses or long QT)\n"
            + "• Serotonin syndrome (if combined with other serotonergic drugs)\n\n"
            + "##The QT prolongation problem:##\n\n"
            + "Ondansetron blocks potassium channels, which can prolong the QT interval. This is dose-dependent and more common at doses >16 mg. Avoid in patients with long QT syndrome or on other QT-prolonging drugs (amiodarone, sotalol, etc.).\n\n"
            + "##Red flags:##\n\n"
            + "• QTc >500 ms on ECG (hold ondansetron)\n"
            + "• Patient on multiple QT-prolonging drugs (additive risk)\n"
            + "• Signs of serotonin syndrome (hyperthermia, rigidity, altered mental status)",
            dose: "##Nausea/Vomiting (adults):##\n\n"
            + "• 4-8 mg IV/PO every 4-8 hours as needed\n"
            + "• Max: 16 mg per dose\n\n"
            + "##Chemotherapy-Induced Nausea:##\n\n"
            + "• 8 mg IV before chemotherapy, then 8 mg PO every 8 hours\n"
            + "• Often combined with dexamethasone\n\n"
            + "##Post-Operative Nausea:##\n\n"
            + "• 4 mg IV before emergence from anesthesia\n\n"
            + "##Administration:##\n\n"
            + "• Can give IV push (over 2-5 minutes) or PO\n"
            + "• For high doses (>16 mg), check ECG\n"
            + "• Avoid in patients with long QT syndrome",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "5-HT3 receptor antagonist, antiemetic.\n\n"
            + "First-line antiemetic for chemotherapy, post-operative nausea, and general nausea/vomiting.",
            indications: "##Primary indications:##\n\n"
            + "• Chemotherapy-induced nausea/vomiting\n"
            + "• Post-operative nausea/vomiting\n"
            + "• General nausea/vomiting\n"
            + "• Radiation-induced nausea\n\n"
            + "##You'll reach for ondansetron when:##\n\n"
            + "• Patient has nausea/vomiting (first-line)\n"
            + "• Post-op patient is nauseated\n"
            + "• Chemotherapy patient needs antiemetic prophylaxis\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Post-op patient vomiting → Ondansetron 4 mg IV\n"
            + "• Chemotherapy patient, pre-treatment → Ondansetron 8 mg IV + dexamethasone\n"
            + "• General nausea, no sedation desired → Ondansetron 4-8 mg PO",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity to ondansetron\n"
            + "• Long QT syndrome (or QTc >500 ms)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Concurrent QT-prolonging drugs (amiodarone, sotalol, haloperidol)\n"
            + "• Heart failure (increased risk of arrhythmias)\n"
            + "• Electrolyte abnormalities (hypokalemia, hypomagnesemia)\n"
            + "• High doses (>16 mg) in elderly or cardiac patients\n\n"
            + "##Critical safety point:## Ondansetron can cause QT prolongation, especially at doses >16 mg. Avoid in patients with long QT syndrome or on multiple QT-prolonging drugs. If giving high doses, check ECG first.",
            onSet: "Rapid (within minutes)",
            halfLife: "3-4 hrs",
            duration: "4-8 hrs",
            absorbtion: "100% oral bioavailability",
            distribution: "Widely distributed",
            metaBolism: "Liver (CYP3A4, CYP2D6)",
            excretion: "Urine (metabolites)",
            pregnancyExplanation: "Category B. Generally safe in pregnancy. No teratogenic effects reported. Commonly used for hyperemesis gravidarum.",
            criticalPearls: "##How to use ondansetron safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check ECG if high dose (>16 mg) or patient has cardiac risk factors\n"
            + "• Review medications for QT-prolonging drugs\n"
            + "• Check electrolytes (hypokalemia, hypomagnesemia increase QT risk)\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor for headache (most common side effect)\n"
            + "• Watch for constipation (especially with repeated doses)\n"
            + "• If high dose, monitor ECG for QT prolongation\n\n"
            + "##Ondansetron vs. Metoclopramide:##\n\n"
            + "##Ondansetron:##\n\n"
            + "• Blocks serotonin (5-HT3) receptors\n"
            + "• No extrapyramidal symptoms (EPS)\n"
            + "• No sedation\n"
            + "• Can cause QT prolongation\n"
            + "• First-line for most nausea/vomiting\n\n"
            + "##Metoclopramide:##\n\n"
            + "• Blocks dopamine receptors\n"
            + "• Causes EPS (dystonia, akathisia)\n"
            + "• Prokinetic (helps gastroparesis)\n"
            + "• No QT prolongation\n"
            + "• Second-line if ondansetron fails\n\n"
            + "##Bottom line:## Use ondansetron first-line. Use metoclopramide if ondansetron fails or if patient has gastroparesis.\n\n"
            + "##Ondansetron for chemotherapy:##\n\n"
            + "Ondansetron is first-line## for chemotherapy-induced nausea/vomiting:\n\n"
            + "• Give 8 mg IV 30 minutes before chemotherapy\n"
            + "• Often combined with dexamethasone (synergistic)\n"
            + "• Continue 8 mg PO every 8 hours for 2-3 days\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving high doses (>16 mg) without checking ECG (QT prolongation risk)\n"
            + "• Using in patients with long QT syndrome\n"
            + "• Not considering metoclopramide if ondansetron fails (may need different mechanism)\n\n"
            + "##The takeaway:##\n\n"
            + "Ondansetron is a selective 5-HT3 antagonist that's first-line for nausea/vomiting. It's effective, well-tolerated, and doesn't cause sedation or EPS. However, it can prolong QT interval, especially at high doses (>16 mg). Avoid in long QT syndrome and check ECG if giving high doses."
        ),
        
        // 51. Oxytocin
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Oxytocin",
            brandName: "Pitocin ®",
            mechansim: "Oxytocin is a uterotonic hormone that stimulates uterine smooth muscle contraction by activating oxytocin receptors.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of oxytocin as the uterine contractor. It's the first-line agent for postpartum hemorrhage and labor induction. It causes powerful uterine contractions that compress uterine vessels and stop bleeding. However, rapid IV push can cause dangerous hypotension, so give it slowly.\n\n"
            + "##How it works:##\n\n"
            + "• Binds oxytocin receptors on uterine myometrium\n"
            + "• Increases intracellular calcium → Muscle contraction\n"
            + "• Compresses uterine blood vessels → Reduces bleeding\n"
            + "• Also has ADH-like effects at high doses → Water retention\n\n"
            + "##The key:## Oxytocin is first-line for postpartum hemorrhage due to uterine atony. It's typically given as a slow infusion, not a rapid push. Rapid IV bolus can cause severe hypotension and even cardiovascular collapse.\n\n"
            + "##High-yield point:## The most common cause of postpartum hemorrhage is uterine atony (failure of uterus to contract). Oxytocin treats this by stimulating uterine contractions. Give 10-40 units IV in 1L NS as infusion for PPH.",
            adverseEffects: "##Common:##\n\n"
            + "• Nausea, vomiting\n"
            + "• Flushing\n"
            + "• Headache\n\n"
            + "##Serious:##\n\n"
            + "• Hypotension (especially with rapid IV push)\n"
            + "• Uterine rupture (rare, with excessive dosing)\n"
            + "• Water intoxication and hyponatremia (ADH-like effect at high doses)\n"
            + "• Cardiac arrhythmias (with rapid IV bolus)\n\n"
            + "##The hypotension problem:##\n\n"
            + "Oxytocin causes vasodilation. Rapid IV push can cause severe, sudden hypotension and even cardiovascular collapse. Always give as infusion or slow IV push for PPH (not rapid bolus).\n\n"
            + "##Red flags:##\n\n"
            + "• Hypotension after IV push (give fluids, vasopressors if needed)\n"
            + "• Signs of uterine rupture (sudden severe pain, fetal distress, hemodynamic instability)\n"
            + "• Hyponatremia with prolonged high-dose infusion",
            dose: "##Postpartum Hemorrhage:##\n\n"
            + "• 10-40 units IV in 1L NS — infuse at 125-250 mL/hr\n"
            + "• Or 10 units IM (if IV not available)\n"
            + "• Can give 10 units slow IV push (over 1-2 minutes) if needed urgently\n\n"
            + "##Labor Induction/Augmentation:##\n\n"
            + "• Start: 0.5-2 milliunits/min IV\n"
            + "• Increase: 1-2 milliunits/min every 30-60 minutes\n"
            + "• Max: 20-40 milliunits/min\n\n"
            + "##After Cesarean (prophylaxis):##\n\n"
            + "• 10-40 units IV in 1L crystalloid after delivery\n\n"
            + "##Administration:##\n\n"
            + "• For PPH: Give as infusion (safest)\n"
            + "• Avoid rapid IV bolus (causes hypotension)\n"
            + "• If needed urgently, give 10 units IV over 1-2 minutes (not push)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.X),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.X),
            DrugClass: "Uterotonic hormone.\n\n"
            + "First-line for postpartum hemorrhage and labor induction.",
            indications: "##Primary indications:##\n\n"
            + "• Postpartum hemorrhage (uterine atony)\n"
            + "• Labor induction and augmentation\n"
            + "• Prevention of PPH after delivery\n\n"
            + "##You'll reach for oxytocin when:##\n\n"
            + "• Postpartum hemorrhage — first-line treatment\n"
            + "• Need to induce or augment labor\n"
            + "• After placental delivery to prevent atony\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Vaginal delivery, bleeding persists, uterus is boggy → Oxytocin 10-40 units IV infusion + uterine massage\n"
            + "• C-section, after delivery of placenta → Oxytocin 10 units in 1L NS\n"
            + "• Term pregnancy, need to induce labor → Oxytocin infusion (low dose, titrate)",
            contraindiction: "##Absolute:##\n\n"
            + "• Active fetal distress (before delivery)\n"
            + "• Uterine rupture or high risk for rupture\n"
            + "• Prolapsed umbilical cord\n"
            + "• Placenta previa with bleeding\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Previous uterine surgery (higher rupture risk)\n"
            + "• Grand multiparity (higher rupture risk)\n"
            + "• Malpresentation (not vertex)\n\n"
            + "##Critical safety point:## Oxytocin is pregnancy category X for antepartum use (can cause fetal distress, uterine rupture). But it's indicated for labor induction and PPH management. The contraindication is primarily for inappropriate use in pregnancy.",
            onSet: "Immediate (IV), 3-5 minutes (IM)",
            halfLife: "1-9 min",
            duration: "30-60 min",
            absorbtion: "N/A (IV/IM only)",
            distribution: "Widely distributed",
            metaBolism: "Liver, kidneys, plasma",
            excretion: "Urine",
            pregnancyExplanation: "Category X for antepartum use. Indicated for labor induction and postpartum hemorrhage under appropriate medical supervision.",
            criticalPearls: "##How to use oxytocin safely:##\n\n"
            + "For Postpartum Hemorrhage:##\n\n"
            + "PPH is a medical emergency. Uterine atony (failure to contract) is the most common cause.\n\n"
            + "##First-line treatment:##\n\n"
            + "• Uterine massage (compress fundus)\n"
            + "• Oxytocin 10-40 units in 1L NS IV infusion\n"
            + "• Or oxytocin 10 units IM\n\n"
            + "If oxytocin fails (second-line uterotonics):##\n\n"
            + "• Methylergonovine (Methergine) 0.2 mg IM (avoid in hypertension)\n"
            + "• Carboprost (Hemabate) 0.25 mg IM (avoid in asthma)\n"
            + "• Misoprostol 800-1000 mcg PR or SL\n\n"
            + "If medical therapy fails:##\n\n"
            + "• Uterine balloon tamponade\n"
            + "• Surgical intervention (B-Lynch suture, hysterectomy)\n\n"
            + "##Avoid rapid IV bolus:##\n\n"
            + "Rapid IV push of oxytocin causes:\n\n"
            + "• Sudden hypotension (vasodilation)\n"
            + "• Tachycardia\n"
            + "• Possible cardiovascular collapse\n\n"
            + "##Safe administration:##\n\n"
            + "• Give as infusion when possible\n"
            + "• If urgent, give 10 units IV over 1-2 minutes (not rapid push)\n"
            + "• Have fluids running\n\n"
            + "##Water intoxication:##\n\n"
            + "Oxytocin has ADH-like effects at high doses:\n\n"
            + "• Can cause water retention\n"
            + "• Leads to dilutional hyponatremia\n"
            + "• Can cause seizures if severe\n"
            + "• More common with prolonged high-dose infusions\n"
            + "• Monitor sodium with prolonged infusions\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving rapid IV push (causes hypotension)\n"
            + "• Not performing uterine massage (most effective intervention)\n"
            + "• Delaying second-line uterotonics when oxytocin fails\n"
            + "• Not monitoring for hyponatremia with prolonged infusions\n\n"
            + "##The takeaway:##\n\n"
            + "Oxytocin is first-line for postpartum hemorrhage from uterine atony. Give 10-40 units IV in 1L NS as infusion (or 10 units IM). Avoid rapid IV bolus — it causes hypotension. Combine with uterine massage. If oxytocin fails, move to second-line uterotonics (methylergonovine, carboprost, misoprostol)."
        ),
        
        // 52. Pantoprazole
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Pantoprazole",
            brandName: "Protonix ®",
            mechansim: "Pantoprazole is a proton pump inhibitor (PPI) that irreversibly blocks the H+/K+-ATPase pump in gastric parietal cells.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of pantoprazole as the acid factory shutdown — it permanently blocks the pump that makes stomach acid. Unlike H2 blockers (ranitidine, famotidine) that temporarily reduce acid, PPIs shut down acid production for 24+ hours. This makes them ideal for stress ulcer prophylaxis in the ICU and active GI bleeding.\n\n"
            + "##How it works:##\n\n"
            + "• Irreversibly blocks H+/K+-ATPase pump in parietal cells → Stops acid production\n"
            + "• Requires active acid secretion to work (give before meals or as continuous infusion)\n"
            + "• Takes 2-3 days to reach full effect (parietal cells need to regenerate pumps)\n"
            + "• Raises gastric pH to >4 (prevents stress ulcers, helps clot formation in GI bleeds)\n\n"
            + "##The key:## Pantoprazole is the PPI of choice for IV use in the ICU. For stress ulcer prophylaxis, give 40 mg IV/PO daily. For active GI bleeding, use continuous infusion (80 mg bolus, then 8 mg/hr) to maintain pH >6 (optimal for clot formation).\n\n"
            + "##High-yield point:## PPIs are superior to H2 blockers for stress ulcer prophylaxis and GI bleeding. They raise pH higher and more consistently. For active GI bleeding, continuous infusion is better than bolus dosing.",
            adverseEffects: "##Common:##\n\n"
            + "• Headache\n"
            + "• Diarrhea\n"
            + "• Nausea\n"
            + "• Constipation\n\n"
            + "##Serious:##\n\n"
            + "• C. difficile infection (increased risk with PPI use)\n"
            + "• Pneumonia (reduced gastric acid allows bacterial colonization)\n"
            + "• Hypomagnesemia (with prolonged use)\n"
            + "• Osteoporosis (with long-term use)\n"
            + "• Vitamin B12 deficiency (with long-term use)\n\n"
            + "##The C. diff problem:##\n\n"
            + "PPIs reduce gastric acid, which normally kills bacteria. This allows C. difficile spores to survive passage through the stomach, increasing the risk of C. diff colitis. Use PPIs only when indicated, and discontinue when no longer needed.\n\n"
            + "##Red flags:##\n\n"
            + "• Watery diarrhea (possible C. diff)\n"
            + "• Hypomagnesemia (check Mg+ with prolonged use)\n"
            + "• Recurrent pneumonia (may be PPI-related)",
            dose: "##Stress Ulcer Prophylaxis (ICU):##\n\n"
            + "• 40 mg IV/PO once daily\n"
            + "• Continue while patient is intubated or on pressors\n\n"
            + "##Active GI Bleeding:##\n\n"
            + "• Bolus: 80 mg IV\n"
            + "• Then: 8 mg/hr continuous infusion for 72 hours\n"
            + "• Goal: Maintain gastric pH >6 (optimal for clot formation)\n\n"
            + "##GERD/Peptic Ulcer Disease:##\n\n"
            + "• 40 mg PO once daily (before breakfast)\n"
            + "• May increase to 40 mg BID for severe GERD\n\n"
            + "##Administration:##\n\n"
            + "• IV: Can give bolus or continuous infusion\n"
            + "• PO: Give 30-60 minutes before meals (requires active acid secretion)\n"
            + "• For active GI bleeding: Continuous infusion is superior to bolus",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Proton pump inhibitor (PPI).\n\n"
            + "Used for stress ulcer prophylaxis, active GI bleeding, GERD, and peptic ulcer disease.",
            indications: "##Primary indications:##\n\n"
            + "• Stress ulcer prophylaxis (ICU patients on mechanical ventilation or pressors)\n"
            + "• Active upper GI bleeding (peptic ulcer, varices)\n"
            + "• GERD (gastroesophageal reflux disease)\n"
            + "• Peptic ulcer disease\n"
            + "• Zollinger-Ellison syndrome\n\n"
            + "##You'll reach for pantoprazole when:##\n\n"
            + "• ICU patient on mechanical ventilation (stress ulcer prophylaxis)\n"
            + "• Patient with active upper GI bleeding\n"
            + "• Patient on multiple risk factors for stress ulcers (coagulopathy, shock, steroids)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Intubated ICU patient → Pantoprazole 40 mg IV daily (stress ulcer prophylaxis)\n"
            + "• Patient with melena, dropping Hgb → Pantoprazole 80 mg IV bolus, then 8 mg/hr infusion\n"
            + "• Patient on steroids + NSAIDs → Pantoprazole 40 mg PO daily",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity to pantoprazole or other PPIs\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Active C. difficile infection (PPIs increase risk)\n"
            + "• Osteoporosis (long-term use can worsen)\n"
            + "• Hypomagnesemia (PPIs can cause)\n"
            + "• Concurrent clopidogrel (may reduce antiplatelet effect, though evidence is mixed)\n\n"
            + "##Critical safety point:## PPIs increase the risk of C. difficile infection and pneumonia. Use only when indicated (stress ulcer prophylaxis, active GI bleeding, severe GERD). Discontinue when no longer needed. For stress ulcer prophylaxis, stop when patient is extubated and off pressors.",
            onSet: "15-30 min (IV), 1-2 hours (PO)",
            halfLife: "1 hr",
            duration: "24+ hrs (irreversible pump blockade)",
            absorbtion: "Delayed-release formulation (PO)",
            distribution: "Highly protein-bound (98%)",
            metaBolism: "Liver (CYP2C19, CYP3A4)",
            excretion: "Urine (80%), feces (20%)",
            pregnancyExplanation: "Category B. Generally safe in pregnancy. Limited human data, but no teratogenic effects reported.",
            criticalPearls: "##How to use pantoprazole safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Confirm indication (stress ulcer prophylaxis, active GI bleeding, GERD)\n"
            + "• Check for active C. diff infection (avoid if possible)\n"
            + "• For active GI bleeding: Set up continuous infusion pump\n\n"
            + "##While it's running:##\n\n"
            + "• For stress ulcer prophylaxis: Give 40 mg daily while intubated/on pressors\n"
            + "• For active GI bleeding: Maintain continuous infusion (8 mg/hr) for 72 hours\n"
            + "• Monitor for C. diff (watery diarrhea)\n"
            + "• Discontinue when no longer needed (reduce infection risk)\n\n"
            + "##Pantoprazole vs. H2 Blockers (ranitidine, famotidine):##\n\n"
            + "##Pantoprazole (PPI):##\n\n"
            + "• Irreversibly blocks acid pump\n"
            + "• More potent (raises pH higher)\n"
            + "• Longer duration (24+ hours)\n"
            + "• Preferred for stress ulcer prophylaxis and GI bleeding\n"
            + "• Higher risk of C. diff and pneumonia\n\n"
            + "##H2 Blockers:##\n\n"
            + "• Reversibly blocks histamine receptors\n"
            + "• Less potent\n"
            + "• Shorter duration (6-12 hours)\n"
            + "• Tachyphylaxis (tolerance develops)\n"
            + "• Lower risk of C. diff\n\n"
            + "##Bottom line:## PPIs are superior for stress ulcer prophylaxis and GI bleeding. Use H2 blockers only if PPIs are contraindicated.\n\n"
            + "##Pantoprazole for stress ulcer prophylaxis:##\n\n"
            + "##Indications for stress ulcer prophylaxis:##\n\n"
            + "• Mechanical ventilation >48 hours\n"
            + "• Coagulopathy (platelets <50k, INR >1.5, PTT >2x normal)\n"
            + "• Shock (hypotension requiring pressors)\n"
            + "• Severe burns (>35% body surface area)\n"
            + "• Head injury (GCS <10)\n"
            + "• Multiple organ failure\n\n"
            + "##Dose:## 40 mg IV/PO daily. Stop when patient is extubated and off pressors.\n\n"
            + "##Pantoprazole for active GI bleeding:##\n\n"
            + "##For## active upper GI bleeding (peptic ulcer, varices):\n\n"
            + "• Bolus: 80 mg IV\n"
            + "• Then: 8 mg/hr continuous infusion for 72 hours\n"
            + "• Goal: Maintain gastric pH >6 (optimal for clot formation)\n"
            + "• Continuous infusion is superior to bolus dosing\n\n"
            + "##Common mistakes:##\n\n"
            + "• Continuing stress ulcer prophylaxis after extubation (no longer needed)\n"
            + "• Using bolus dosing for active GI bleeding (continuous infusion is better)\n"
            + "• Not discontinuing PPIs when no longer needed (increases C. diff and pneumonia risk)\n"
            + "• Giving PO pantoprazole with meals (should be 30-60 min before meals)\n\n"
            + "##The takeaway:##\n\n"
            + "Pantoprazole is a PPI that irreversibly blocks acid production. It's first-line for stress ulcer prophylaxis (40 mg daily) and active GI bleeding (80 mg bolus, then 8 mg/hr infusion). It's more potent than H2 blockers but increases the risk of C. diff and pneumonia. Use only when indicated and discontinue when no longer needed."
        ),
        
        // 53. Piperacillin-Tazobactam (Zosyn) - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Piperacillin-Tazobactam",
            brandName: "Zosyn",
            mechansim: "Broad-spectrum β-lactam + β-lactamase inhibitor.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of Zosyn as two tools working together:\n\n"
            + "##Piperacillin = The Killer## — Breaks bacterial cell walls by inhibiting transpeptidases.\n\n"
            + "##Tazobactam = The Shield## — Blocks the enzymes (beta-lactamases) that try to destroy piperacillin.\n\n"
            + "Together, they give you broad gram-negative coverage (including Pseudomonas), many gram-positives, and anaerobes. Tazobactam protects piperacillin so it can keep killing bacteria that would normally be resistant.\n\n"
            + "##Key concept:## This is your workhorse broad-spectrum antibiotic when you don't yet know the bug and can't afford to miss.",
            adverseEffects: "##Common:## Diarrhea, rash, nausea.\n\n"
            + "##Serious:## Anaphylaxis, Acute kidney injury (especially with vancomycin).\n\n"
            + "##Watch for these while it's running:##\n\n"
            + "• Rising creatinine (nephrotoxicity)\n"
            + "• New severe diarrhea (C. diff risk)\n"
            + "• Rash or eosinophilia (hypersensitivity)\n"
            + "• Worsening leukopenia or thrombocytopenia\n\n"
            + "##Red flags to stop or rethink:##\n\n"
            + "• Severe beta-lactam allergy history\n"
            + "• Anaphylaxis",
            dose: "3.375 g IV q6h or 4.5 g IV q8h (adjust for renal function).",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Beta-lactam + Beta-lactamase inhibitor.\n\n"
            + "Your broad-spectrum safety net for seriously ill patients when you don't yet know the bug.",
            indications: "##Standard Indications:##\n\n"
            + "• Hospital-acquired pneumonia (HAP)\n"
            + "• Sepsis\n"
            + "• Intra-abdominal infections\n\n"
            + "When to reach for Zosyn:##\n\n"
            + "• Patient is sick enough that delays are dangerous\n"
            + "• Resistant gram-negatives or mixed flora are possible\n"
            + "• Infection could be from gut, pelvis, wounds\n"
            + "• Hospital-acquired infections\n"
            + "• ICU line, lung, or abdominal sources\n\n"
            + "##Clinical clues:## These patients usually look systemically sick — tachycardic, hypotensive, febrile, rising lactate, or altered.",
            contraindiction: "##Absolute:## Penicillin/beta-lactam allergy (anaphylaxis).\n\n"
            + "##What Zosyn does NOT cover:##\n\n"
            + "• MRSA\n"
            + "• VRE\n"
            + "• Atypicals\n"
            + "• Many ESBL or CRE organisms\n\n"
            + "##Key point:## If the patient could have MRSA pneumonia or line sepsis, Zosyn alone is not enough. It's the base, not the full stack.",
            onSet: "Immediate (IV)",
            halfLife: "1 hour",
            duration: "Varies by indication",
            absorbtion: "IV only",
            distribution: "Widely distributed throughout body tissues and fluids.",
            metaBolism: "Minimal hepatic metabolism.",
            excretion: "Primarily renal (dose adjust for CrCl).",
            pregnancyExplanation: "Use with caution in pregnancy. Benefits should outweigh risks in serious infections.",
            criticalPearls: "##Broad Spectrum 'Workhorse'##\n\n"
            + "• Covers Pseudomonas!\n"
            + "• Does NOT cover MRSA.\n\n"
            + "##The Clinical Takeaway##\n\n"
            + "Zosyn is your broad-spectrum safety net for seriously ill patients when you don't yet know the bug.\n\n"
            + "##Before the first dose:##\n\n"
            + "• Draw cultures\n"
            + "• Check kidney function\n\n"
            + "##While it's running:##\n\n"
            + "• Watch creatinine\n"
            + "• Watch for diarrhea\n"
            + "• Watch for rash\n\n"
            + "##As soon as cultures return:##\n\n"
            + "• Narrow the antibiotic\n"
            + "• Do NOT let Zosyn run out of inertia\n\n"
            + "##High-yield point:## Vanc + Zosyn = 35% AKI risk. If you need both, watch the kidneys closely or consider vanc + cefepime instead.\n\n"
            + "Start it when needed, monitor closely, and narrow fast — that's how you use it like an attending."
        ),
        
        // 54. Potassium Chloride
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Potassium Chloride",
            brandName: "KCL ®",
            mechansim: "Potassium chloride is an electrolyte replacement that restores intracellular and extracellular potassium levels.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of potassium as the electrolyte that keeps your heart beating regularly. Low potassium (hypokalemia) → arrhythmias, muscle weakness. High potassium (hyperkalemia) → cardiac arrest. The therapeutic window is narrow (3.5-5.0 mEq/L).\n\n"
            + "##How it works:##\n\n"
            + "• Maintains resting membrane potential in cardiac and skeletal muscle\n"
            + "• Critical for cardiac conduction\n"
            + "• Required for muscle contraction and nerve transmission\n"
            + "• Shifts into cells with insulin, beta-agonists, and alkalosis\n\n"
            + "##Key concept:## Potassium is a HIGH-ALERT medication. ##NEVER give IV push## — it will cause instant cardiac arrest. Always dilute and give slowly (max 10 mEq/hr peripheral, 20 mEq/hr central line with cardiac monitoring).\n\n"
            + "##High-yield point:## Hypokalemia makes the heart sensitive to digoxin toxicity and increases risk of arrhythmias (especially with diuretics). Always replace magnesium BEFORE potassium — low magnesium prevents potassium from staying in cells.",
            adverseEffects: "##Common:##\n\n"
            + "• Peripheral vein irritation/phlebitis (burning sensation)\n"
            + "• Nausea (oral)\n\n"
            + "##Serious:##\n\n"
            + "• Hyperkalemia → Arrhythmias, cardiac arrest\n"
            + "• Too-rapid infusion → Cardiac arrest\n"
            + "• Extravasation → Tissue necrosis\n\n"
            + "##Hyperkalemia signs:##\n\n"
            + "• Peaked T waves (earliest sign)\n"
            + "• Widened QRS\n"
            + "• Loss of P waves\n"
            + "• Sine wave → Cardiac arrest\n\n"
            + "##RED FLAG - NEVER DO THIS:##\n\n"
            + "• ##NEVER give potassium IV push## → Instant cardiac arrest\n"
            + "• ##NEVER exceed 10 mEq/hr## via peripheral IV\n"
            + "• ##NEVER give without checking K+ level first## (unless life-threatening hypokalemia)\n\n"
            + "If patient develops sudden cardiac arrest during K+ infusion:##\n\n"
            + "• STOP the infusion immediately\n"
            + "• Start ACLS\n"
            + "• Give calcium gluconate or calcium chloride (membrane stabilizer)\n"
            + "• Consider hyperkalemia protocol",
            dose: "##Mild Hypokalemia (K+ 3.0-3.5 mEq/L):##\n\n"
            + "• 20-40 mEq PO or 10 mEq IV (peripheral)\n"
            + "• Recheck K+ in 2-4 hours\n\n"
            + "##Moderate Hypokalemia (K+ 2.5-3.0 mEq/L):##\n\n"
            + "• 40-80 mEq total replacement (divided doses)\n"
            + "• Peripheral IV: 10 mEq/hr (max)\n"
            + "• Central line: 20 mEq/hr with cardiac monitoring\n\n"
            + "##Severe Hypokalemia (K+ <2.5 mEq/L or symptomatic):##\n\n"
            + "• Central line required for rapid replacement\n"
            + "• 10-20 mEq/hr with continuous cardiac monitoring\n"
            + "• Recheck K+ every 2 hours\n"
            + "• Total deficit often 200-400 mEq\n\n"
            + "##Infusion Guidelines:##\n\n"
            + "• Peripheral IV: Max 10 mEq/hr, max 40 mEq per liter\n"
            + "• Central line: Max 20 mEq/hr (with cardiac monitoring), max 40 mEq per liter\n"
            + "• Always dilute in at least 100 mL fluid per 10 mEq K+\n\n"
            + "##Rule of thumb:##\n\n"
            + "• 10 mEq K+ replacement → increases serum K+ by ~0.1 mEq/L\n"
            + "• Example: K+ 2.5 → goal 3.5 = need ~100 mEq total",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "##Electrolyte replacement.##\n\n"
            + "##HIGH-ALERT MEDICATION## — requires careful monitoring and slow administration.",
            indications: "##Standard Indications:##\n\n"
            + "• Hypokalemia (K+ <3.5 mEq/L)\n"
            + "• Prevention of hypokalemia (diuretic therapy)\n"
            + "• Diabetic ketoacidosis (DKA) — potassium drops when insulin is given\n"
            + "• Digoxin toxicity (hypokalemia worsens toxicity)\n\n"
            + "When to give potassium:##\n\n"
            + "• K+ <3.0 mEq/L → Always replace\n"
            + "• K+ 3.0-3.5 mEq/L → Replace if symptomatic or on diuretics/digoxin\n"
            + "• Ongoing losses (diarrhea, vomiting, diuretics)\n\n"
            + "##Common causes of hypokalemia:##\n\n"
            + "• Diuretics (furosemide, HCTZ)\n"
            + "• GI losses (vomiting, diarrhea, NG suction)\n"
            + "• Insulin therapy (shifts K+ into cells)\n"
            + "• Renal losses (RTA, hyperaldosteronism)\n"
            + "• Medications (beta-agonists, steroids)",
            contraindiction: "##Absolute:##\n\n"
            + "• Hyperkalemia (K+ >5.0 mEq/L)\n"
            + "• Severe renal failure with oliguria/anuria\n"
            + "• Untreated Addison's disease\n"
            + "• Severe tissue trauma (releases K+ from cells)\n\n"
            + "##Caution:##\n\n"
            + "• Renal impairment (monitor closely, K+ can accumulate)\n"
            + "• Concurrent K+-sparing diuretics (spironolactone, amiloride)\n"
            + "• ACE inhibitors or ARBs (reduce K+ excretion)\n"
            + "• NSAIDs (reduce K+ excretion)\n"
            + "• Digoxin therapy (monitor carefully — K+ affects digoxin levels)\n\n"
            + "##Always check K+ level before giving more potassium!##",
            onSet: "30-60 minutes (IV)",
            halfLife: "N/A (regulated by kidneys)",
            duration: "Variable (depends on ongoing losses)",
            absorbtion: "Well absorbed orally (90%)",
            distribution: "98% intracellular (only 2% in serum!)\n\n"
            + "This is why serum K+ can be low even with normal total body K+##",
            metaBolism: "None — excreted unchanged",
            excretion: "Renal (90%) and GI (10%)\n\n"
            + "##Kidneys are the primary regulator of K+ balance##",
            pregnancyExplanation: "##Pregnancy Category C:## Safe to use when indicated. Hypokalemia must be corrected in pregnancy.",
            criticalPearls: "##⚠️ HIGH-ALERT MEDICATION ⚠️##\n\n"
            + "• ##NEVER give IV push## → Instant cardiac arrest (lethal)\n"
            + "• ##Maximum peripheral infusion rate: 10 mEq/hr##\n"
            + "• ##Maximum central line rate: 20 mEq/hr## (with cardiac monitoring)\n"
            + "• ##Always dilute## — never give concentrated K+\n\n"
            + "##Check Magnesium First!##\n\n"
            + "• Low magnesium → potassium won't stay in cells\n"
            + "• Always replace magnesium BEFORE or WITH potassium\n"
            + "• If K+ not responding to replacement, check Mg²⁺\n\n"
            + "##Diuretic-Induced Hypokalemia:##\n\n"
            + "• Loop diuretics (furosemide) → Massive K+ loss\n"
            + "• Always monitor K+ with diuretic therapy\n"
            + "• Consider K+-sparing diuretic (spironolactone) if recurrent\n\n"
            + "##DKA Potassium Management:##\n\n"
            + "• K+ is HIGH initially (acidosis shifts K+ out of cells)\n"
            + "• Insulin causes K+ to drop rapidly (shifts into cells)\n"
            + "• Start K+ replacement when K+ <5.2 mEq/L (before giving insulin if K+ <3.3)\n"
            + "• Monitor K+ every 2 hours during insulin therapy\n\n"
            + "##ECG Changes with Potassium:##\n\n"
            + "##Hypokalemia (K+ <3.5):##\n"
            + "• Flattened T waves\n"
            + "• U waves (after T wave)\n"
            + "• ST depression\n"
            + "• Prolonged QT\n"
            + "• Risk: Torsades de Pointes\n\n"
            + "##Hyperkalemia (K+ >5.5):##\n"
            + "• Peaked T waves (earliest sign)\n"
            + "• Prolonged PR interval\n"
            + "• Widened QRS\n"
            + "• Loss of P waves\n"
            + "• Sine wave → Asystole\n\n"
            + "##Administration Safety:##\n\n"
            + "• Use infusion pump (never gravity drip)\n"
            + "• Label prominently: \"HIGH-ALERT MEDICATION\"\n"
            + "• Peripheral IV: 10 mEq in 100 mL over 1 hour\n"
            + "• Central line: 20 mEq in 100 mL over 1 hour with telemetry\n"
            + "• Recheck K+ after each dose\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Potassium is a high-alert medication that requires extreme caution. NEVER give IV push — it's instantly lethal. Always dilute and give slowly (max 10 mEq/hr peripheral, 20 mEq/hr central with monitoring). Check magnesium first — low Mg²⁺ prevents K+ from staying in cells. Monitor ECG for arrhythmias, especially in patients on digoxin or with cardiac disease.\n\n"
            + "##High-yield point:## The three rules of potassium: 1) NEVER IV push, 2) Check Mg²⁺ first, 3) Max 10 mEq/hr peripheral. Violating rule #1 = cardiac arrest."
        ),
        
        // 55. Procainamide
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Pronestyl",
            brandName: "Procainamide ®",
            mechansim: "Procainamide is a Class IA antiarrhythmic that blocks sodium channels and prolongs the action potential duration and effective refractory period.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of procainamide as the wide-complex tachycardia drug — it slows conduction and prolongs refractoriness throughout the heart. It's particularly useful for stable VT and WPW with atrial fibrillation (where AV nodal blockers are contraindicated). The trade-off: it can cause significant hypotension and QRS widening.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks sodium channels (phase 0 depolarization) → Slows conduction\n"
            + "• Blocks potassium channels → Prolongs action potential duration\n"
            + "• Increases effective refractory period → Prevents re-entrant arrhythmias\n"
            + "• Active metabolite (NAPA) has Class III effects (potassium channel blockade)\n\n"
            + "##The key:## Procainamide is the drug of choice for stable VT and for atrial fibrillation with WPW (where digoxin, beta-blockers, and calcium channel blockers are contraindicated because they can accelerate conduction down the accessory pathway).\n\n"
            + "##High-yield point:## Know the four stopping endpoints: (1) Arrhythmia terminates, (2) Hypotension develops, (3) QRS widens >50%, (4) Maximum dose reached (17 mg/kg). Stop the infusion when ANY of these occur.",
            adverseEffects: "##Common (during infusion):##\n\n"
            + "• Hypotension (most common limiting factor)\n"
            + "• QRS widening\n"
            + "• Nausea\n\n"
            + "##Serious:##\n\n"
            + "• Torsades de Pointes (Class IA drugs prolong QT)\n"
            + "• Heart block\n"
            + "• Drug-induced lupus (with chronic oral use — not acute IV)\n"
            + "• Agranulocytosis (with chronic use)\n\n"
            + "##The lupus problem:##\n\n"
            + "Drug-induced lupus occurs with chronic oral procainamide (not acute IV use). It's associated with anti-histone antibodies. Symptoms resolve after stopping the drug.\n\n"
            + "##Red flags (stop infusion):##\n\n"
            + "• Hypotension (SBP <90)\n"
            + "• QRS widens >50% from baseline\n"
            + "• QTc >500 ms (risk of Torsades)\n"
            + "• New AV block",
            dose: "##Stable Ventricular Tachycardia:##\n\n"
            + "• Loading: 20-50 mg/min IV (usually 20 mg/min)\n"
            + "• Continue until: Arrhythmia terminates, hypotension, QRS >50% wider, or max dose (17 mg/kg)\n"
            + "• Maintenance: 1-4 mg/min IV infusion\n\n"
            + "##WPW with Atrial Fibrillation:##\n\n"
            + "• Same dosing as above\n"
            + "• Procainamide is preferred because it slows accessory pathway conduction\n\n"
            + "##Maximum dose:##\n\n"
            + "• 17 mg/kg loading (about 1.2 g for 70 kg patient)\n"
            + "• Stop when endpoint reached, not always at max dose\n\n"
            + "##Administration:##\n\n"
            + "• Slow IV infusion (20-50 mg/min)\n"
            + "• Monitor BP, QRS, and rhythm continuously\n"
            + "• Have pacing available (can cause heart block)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Class IA antiarrhythmic.\n\n"
            + "Sodium channel blocker that also prolongs action potential. Used for stable VT and WPW with AF.",
            indications: "##Primary indications:##\n\n"
            + "• Stable wide-complex tachycardia (monomorphic VT)\n"
            + "• WPW with atrial fibrillation (when AV nodal blockers contraindicated)\n"
            + "• Atrial flutter or fibrillation (less common use)\n\n"
            + "##You'll reach for procainamide when:##\n\n"
            + "• Stable VT not responding to or not candidate for amiodarone\n"
            + "• WPW with rapid AF (digoxin, BB, CCB contraindicated)\n"
            + "• Need to chemically cardiovert stable wide-complex tachycardia\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Stable VT, BP 110/70 → Can try procainamide 20-50 mg/min (or cardiovert)\n"
            + "• WPW with AF, irregular wide-complex tachycardia → Procainamide (NOT diltiazem, digoxin)\n"
            + "• VT not responding to amiodarone → Alternative: procainamide or lidocaine",
            contraindiction: "##Absolute:##\n\n"
            + "• Complete heart block (without pacemaker)\n"
            + "• Torsades de Pointes\n"
            + "• Long QT syndrome\n"
            + "• Lupus (prior drug-induced or SLE)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Hypotension (will worsen)\n"
            + "• Myasthenia gravis (can worsen)\n"
            + "• Renal impairment (NAPA accumulates)\n"
            + "• CHF (negative inotrope)\n\n"
            + "##Critical safety point:## Know the stopping endpoints: hypotension, QRS widening >50%, arrhythmia termination, max dose (17 mg/kg). Stop the infusion when ANY endpoint is reached.",
            onSet: "10-30 min",
            halfLife: "3-4 hrs (procainamide), 6-8 hrs (NAPA metabolite)",
            duration: "24+ hrs",
            absorbtion: "Complete (IV)",
            distribution: "Widely distributed",
            metaBolism: "Liver (acetylation to NAPA — active metabolite)",
            excretion: "Kidneys (both procainamide and NAPA)",
            pregnancyExplanation: "Category C. Use in pregnancy only if benefits outweigh risks. Limited data on fetal effects.",
            criticalPearls: "##How to use procainamide safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Confirm stable VT or WPW with AF\n"
            + "• Check baseline QRS width and QTc\n"
            + "• Check blood pressure (hold if hypotensive)\n"
            + "• Have pacing available (can cause heart block)\n\n"
            + "##While it's running:##\n\n"
            + "• Continuous ECG monitoring\n"
            + "• Monitor BP every 1-2 minutes during loading\n"
            + "• Watch QRS width (stop if widens >50%)\n"
            + "• Watch for hypotension (most common limiting factor)\n\n"
            + "##The Four Stopping Endpoints:##\n\n"
            + "##Stop procainamide## when ANY of these occur:\n\n"
            + "1. ##Arrhythmia terminates## (success!)\n"
            + "2. ##Hypotension develops## (stop infusion, give fluids)\n"
            + "3. ##QRS widens >50%## from baseline (toxicity sign)\n"
            + "4. ##Maximum dose reached## (17 mg/kg)\n\n"
            + "##WPW with Atrial Fibrillation — Special Case:##\n\n"
            + "In WPW, there's## an accessory pathway bypassing the AV node. In atrial fibrillation:\n\n"
            + "• Rapid atrial impulses conduct down the accessory pathway\n"
            + "• This can cause very rapid ventricular rates (>300 bpm)\n"
            + "• Can degenerate to VF\n\n"
            + "##Dangerous drugs in WPW + AF:##\n\n"
            + "• AV nodal blockers (digoxin, beta-blockers, calcium channel blockers)\n"
            + "• They slow AV node conduction but can ACCELERATE accessory pathway conduction\n"
            + "• This makes the ventricular rate even faster\n\n"
            + "##Safe drugs in WPW + AF:##\n\n"
            + "• Procainamide (slows accessory pathway conduction)\n"
            + "• Cardioversion (preferred if unstable)\n"
            + "• Ibutilide (alternative)\n\n"
            + "##Drug-induced lupus (chronic use):##\n\n"
            + "##With chronic oral procainamide##:\n\n"
            + "• Up to 30% develop anti-histone antibodies\n"
            + "• 10-20% develop lupus-like syndrome\n"
            + "• Arthralgia, myalgia, fever, rash\n"
            + "• Resolves after stopping drug\n"
            + "• Not a concern with acute IV use\n\n"
            + "##Common mistakes:##\n\n"
            + "• Infusing too fast (causes hypotension)\n"
            + "• Not monitoring QRS width during infusion\n"
            + "• Giving AV nodal blockers for WPW with AF (dangerous)\n"
            + "• Continuing infusion despite hypotension\n\n"
            + "##The takeaway:##\n\n"
            + "Procainamide is a Class IA## antiarrhythmic used for stable VT and WPW with AF. Infuse at 20-50 mg/min, max 17 mg/kg. Know the four stopping endpoints: arrhythmia terminates, hypotension, QRS widens >50%, max dose. For WPW + AF, procainamide is SAFE (AV nodal blockers are dangerous). Monitor ECG and BP continuously."
        ),
        
        // 56. Rocuronium
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Rocuronium",
            brandName: "Zemuron ®",
            mechansim: "Rocuronium is a non-depolarizing neuromuscular blocker that works by competitively blocking acetylcholine at the nicotinic receptor.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of rocuronium as the safe, reliable alternative to succinylcholine. It doesn't cause the transient depolarization (no fasciculations, no hyperkalemia), but it takes slightly longer to work (60-90 seconds vs 45-60 seconds). The trade-off is that it lasts much longer (30-60 minutes).\n\n"
            + "##How it works:##\n\n"
            + "• Competitively binds to nicotinic receptors at the neuromuscular junction\n"
            + "• Blocks acetylcholine from binding → Prevents muscle contraction\n"
            + "• No depolarization → No fasciculations, no hyperkalemia\n"
            + "• Can be reversed with sugammadex (unique among paralytics)\n\n"
            + "##The key:## Rocuronium at high dose (1.2 mg/kg) is nearly as fast as succinylcholine (60-90 seconds), but without the hyperkalemia risk. This makes it the preferred RSI paralytic in many centers, especially now that sugammadex can reverse it if you can't intubate.\n\n"
            + "##High-yield point:## Rocuronium is the only paralytic that can be rapidly reversed with sugammadex. If you give rocuronium and can't intubate, you can give sugammadex 16 mg/kg and the patient will wake up and breathe within 2-3 minutes.",
            adverseEffects: "##Common:##\n\n"
            + "• Prolonged paralysis (30-60 minutes)\n"
            + "• No fasciculations (this is actually an advantage)\n"
            + "• Minimal hemodynamic effects at normal doses\n\n"
            + "##Serious:##\n\n"
            + "• Anaphylaxis (rare, but rocuronium is the most common paralytic to cause it)\n"
            + "• Prolonged paralysis in liver or renal failure\n"
            + "• Can't intubate, can't ventilate scenario (need sugammadex to reverse)\n\n"
            + "##Anaphylaxis risk:##\n\n"
            + "Rocuronium is the most common neuromuscular blocker to cause anaphylaxis. It's still rare (<1%), but if a patient has a severe allergic reaction during RSI, rocuronium is often the culprit.\n\n"
            + "##Red flags:##\n\n"
            + "• Severe hypotension, bronchospasm, or rash after giving rocuronium → Treat as anaphylaxis\n"
            + "• Can't intubate after giving rocuronium → Give sugammadex 16 mg/kg to reverse immediately",
            dose: "##RSI (standard dose):##\n\n"
            + "• 0.6 mg/kg IV (typical adult: 50-60 mg)\n"
            + "• Onset: 90-120 seconds\n"
            + "• Duration: 30-45 minutes\n\n"
            + "##RSI (high dose for rapid onset):##\n\n"
            + "• 1.2 mg/kg IV (typical adult: 100-120 mg)\n"
            + "• Onset: 60-90 seconds (nearly as fast as succinylcholine)\n"
            + "• Duration: 45-60 minutes\n\n"
            + "##Intubation (non-emergent):##\n\n"
            + "• 0.6 mg/kg IV\n"
            + "• Wait 90-120 seconds before attempting intubation\n\n"
            + "##ICU paralysis (continuous infusion):##\n\n"
            + "• Loading dose: 0.6-1.2 mg/kg IV\n"
            + "• Infusion: 8-12 mcg/kg/min (titrate to train-of-four)\n\n"
            + "##Pediatric RSI:##\n\n"
            + "• 1.2 mg/kg IV (same as adult high dose)\n"
            + "• Onset: 60-90 seconds\n\n"
            + "##Reversal with sugammadex (can't intubate scenario):##\n\n"
            + "• Immediate reversal: 16 mg/kg IV (1200-1400 mg for average adult)\n"
            + "• Reversal occurs in 2-3 minutes\n\n"
            + "##Administration:##\n\n"
            + "• Give as rapid IV push\n"
            + "• Ensure induction agent is given first (never paralyze an awake patient)\n"
            + "• Have sugammadex available for reversal if needed",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Non-depolarizing neuromuscular blocker, aminosteroid.\n\n"
            + "The preferred RSI paralytic in many centers due to safety profile and reversibility with sugammadex.",
            indications: "##Primary indications:##\n\n"
            + "• Rapid sequence intubation (RSI)\n"
            + "• Facilitated intubation (non-emergent)\n"
            + "• ICU paralysis for mechanically ventilated patients\n\n"
            + "##You'll reach for rocuronium when:##\n\n"
            + "• Succinylcholine is contraindicated (hyperkalemia, burns, crush injuries)\n"
            + "• You want the option to reverse paralysis if you can't intubate\n"
            + "• Patient needs longer paralysis for post-intubation transport or procedures\n"
            + "• You're following a protocol that uses rocuronium as default RSI paralytic\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Burn patient (>24 hours) needs intubation → Rocuronium (succinylcholine contraindicated)\n"
            + "• Patient with unknown K+ needs RSI → Rocuronium (safer if hyperkalemia is present)\n"
            + "• Difficult airway anticipated → Rocuronium (can reverse with sugammadex if you can't get the tube)",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity or anaphylaxis to rocuronium\n"
            + "• No absolute medical contraindications (unlike succinylcholine)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Severe liver failure (prolonged duration)\n"
            + "• Myasthenia gravis or myasthenic syndromes (extreme sensitivity)\n"
            + "• No sugammadex available (can't reverse if intubation fails)\n\n"
            + "##Critical safety point:## Rocuronium is much safer than succinylcholine in terms of contraindications. The main risk is prolonged paralysis if you can't intubate and don't have sugammadex. Always have a backup plan (bag-mask ventilation, surgical airway).",
            onSet: "60-90 sec (at 1.2 mg/kg), 90-120 sec (at 0.6 mg/kg)",
            halfLife: "1-2 hrs",
            duration: "30-60 min (dose-dependent)",
            absorbtion: "IV only",
            distribution: "Extracellular fluid",
            metaBolism: "Liver (minimal metabolism)",
            excretion: "Bile (70%), Urine (30%)",
            pregnancyExplanation: "Category C. Safe for short-term use in pregnancy. Commonly used for RSI in obstetric emergencies.",
            criticalPearls: "##How to use rocuronium safely:##\n\n"
            + "##Before giving:##\n\n"
            + "• Give induction agent first (never paralyze an awake patient)\n"
            + "• Confirm sugammadex is available (or have backup airway plan)\n"
            + "• Check for myasthenia gravis history (extreme sensitivity)\n"
            + "• Decide on dose: 0.6 mg/kg (standard) vs 1.2 mg/kg (rapid onset)\n\n"
            + "##During administration:##\n\n"
            + "• Give as rapid IV push\n"
            + "• Wait 60-90 seconds for full paralysis (at 1.2 mg/kg dose)\n"
            + "• No fasciculations (unlike succinylcholine)\n"
            + "• Intubate once jaw is relaxed and patient is fully paralyzed\n\n"
            + "##After giving:##\n\n"
            + "• Patient will be paralyzed for 30-60 minutes\n"
            + "• If you can't intubate → Bag the patient, call for help\n"
            + "• If you can't intubate and can't bag → Give sugammadex 16 mg/kg immediately\n"
            + "• Monitor train-of-four if using continuous infusion in ICU\n\n"
            + "##Rocuronium vs. Succinylcholine:##\n\n"
            + "##Rocuronium advantages:##\n"
            + "• Safer (no hyperkalemia, no malignant hyperthermia)\n"
            + "• Reversible with sugammadex\n"
            + "• Fewer contraindications\n\n"
            + "##Succinylcholine advantages:##\n"
            + "• Slightly faster onset (45-60 sec vs 60-90 sec)\n"
            + "• Shorter duration (wears off in 5-10 min if you can't intubate)\n\n"
            + "##The shift:## Many centers now use rocuronium 1.2 mg/kg as the default RSI paralytic because it's nearly as fast, much safer, and reversible.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using 0.6 mg/kg dose for RSI (too slow — use 1.2 mg/kg for rapid onset)\n"
            + "• Not having sugammadex available\n"
            + "• Attempting intubation too early (wait the full 60-90 seconds)\n"
            + "• Forgetting that rocuronium lasts 30-60 minutes (not 5-10 like succinylcholine)\n\n"
            + "##The takeaway:##\n\n"
            + "Rocuronium is the safe, reliable RSI paralytic — nearly as fast as succinylcholine at high dose (1.2 mg/kg), but without the hyperkalemia risk. The big advantage is reversibility with sugammadex. It's become the default RSI paralytic in many centers. Give it fast, wait 60-90 seconds, and keep sugammadex nearby."
        ),
        
        // 57. Sodium Bicarbonate
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Sodium Bicarbonate",
            brandName: "HCO3",
            mechansim: "Sodium bicarbonate is an alkalinizing agent that buffers hydrogen ions, raising blood pH.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of sodium bicarbonate as the pH corrector for severe metabolic acidosis and the antidote for tricyclic antidepressant (TCA) overdose. It works by directly buffering acid (raising pH) and increasing serum sodium, which helps overcome sodium channel blockade in TCA toxicity.\n\n"
            + "##How it works:##\n\n"
            + "• Buffers hydrogen ions → HCO3- + H+ → H2CO3 → H2O + CO2\n"
            + "• Raises blood pH (treats acidosis)\n"
            + "• Increases serum sodium → Overcomes sodium channel blockade (TCA overdose)\n"
            + "• Alkalinizes urine → Enhances excretion of weak acids (aspirin, methotrexate)\n\n"
            + "##The key:## Bicarbonate is NOT first-line for most acidosis — treat the underlying cause (sepsis, shock, DKA). It's indicated for severe metabolic acidosis (pH <7.1), TCA overdose (wide QRS), and hyperkalemia (shifts K+ into cells). But overuse causes metabolic alkalosis, hyponatremia, and paradoxical CNS acidosis.\n\n"
            + "##High-yield point:## Bicarbonate is the antidote for TCA overdose. It raises serum sodium, which overcomes sodium channel blockade, narrowing the QRS and preventing arrhythmias. Give bicarbonate if QRS >100 ms or if patient is seizing.",
            adverseEffects: "##Common:##\n\n"
            + "• Metabolic alkalosis (over-correction)\n"
            + "• Hypernatremia (sodium load)\n"
            + "• Fluid overload (isotonic solution)\n"
            + "• Hypokalemia (shifts K+ into cells)\n\n"
            + "##Serious:##\n\n"
            + "• Paradoxical CNS acidosis (CO2 crosses BBB faster than HCO3-)\n"
            + "• Hypocalcemia (alkalosis increases protein binding of calcium)\n"
            + "• Tissue necrosis if extravasated (vesicant)\n"
            + "• Pulmonary edema (fluid overload)\n\n"
            + "##The paradoxical CNS acidosis problem:##\n\n"
            + "When you give bicarbonate, CO2 is generated. CO2 crosses the blood-brain barrier faster than bicarbonate, which can temporarily worsen CNS acidosis. This is why ventilation is critical — you need to blow off the CO2.\n\n"
            + "##Red flags:##\n\n"
            + "• pH >7.5 (metabolic alkalosis from over-correction)\n"
            + "• Serum sodium >150 (hypernatremia)\n"
            + "• Tetany, paresthesias (hypocalcemia from alkalosis)\n"
            + "• Extravasation (tissue necrosis)",
            dose: "##Metabolic Acidosis (pH <7.1):##\n\n"
            + "• 1 mEq/kg IV push (typically 50-100 mEq)\n"
            + "• Reassess ABG after 10-15 minutes\n"
            + "• Repeat as needed to maintain pH >7.2\n\n"
            + "##TCA Overdose (wide QRS >100 ms):##\n\n"
            + "• 1-2 mEq/kg IV bolus (50-100 mEq)\n"
            + "• Goal: Narrow QRS, achieve serum pH 7.45-7.55\n"
            + "• Repeat boluses or start infusion (150 mEq in 1 L D5W at 150-200 mL/hr)\n\n"
            + "##Hyperkalemia:##\n\n"
            + "• 50 mEq (1 amp) IV push over 5 minutes\n"
            + "• Shifts K+ into cells temporarily\n\n"
            + "##Cardiac Arrest (severe metabolic acidosis):##\n\n"
            + "• 1 mEq/kg IV push\n"
            + "• Repeat every 10 minutes as needed\n\n"
            + "##Urine Alkalinization (aspirin, methotrexate overdose):##\n\n"
            + "• 150 mEq in 1 L D5W at 150-200 mL/hr\n"
            + "• Goal: Urine pH >7.5\n\n"
            + "##Administration:##\n\n"
            + "• Can push IV or give as infusion\n"
            + "• Do NOT mix with calcium (precipitates)\n"
            + "• Flush line before and after\n"
            + "• Monitor ABG, electrolytes, pH closely",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Alkalinizing agent, electrolyte.\n\n"
            + "Used for severe metabolic acidosis, TCA overdose, hyperkalemia, and urine alkalinization.",
            indications: "##Primary indications:##\n\n"
            + "• Severe metabolic acidosis (pH <7.1 despite treating underlying cause)\n"
            + "• Tricyclic antidepressant (TCA) overdose with wide QRS or arrhythmias\n"
            + "• Hyperkalemia (temporary measure, shifts K+ into cells)\n"
            + "• Urine alkalinization (aspirin, methotrexate, phenobarbital overdose)\n"
            + "• Cardiac arrest with severe pre-existing acidosis\n\n"
            + "##You'll reach for bicarbonate when:##\n\n"
            + "• TCA overdose patient has QRS >100 ms or is seizing\n"
            + "• Severe metabolic acidosis (pH <7.1) despite fluid resuscitation\n"
            + "• Hyperkalemia patient needs immediate temporizing measure\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Amitriptyline overdose, QRS 140 ms → Bicarbonate 100 mEq IV bolus\n"
            + "• DKA patient with pH 6.9 despite insulin → Bicarbonate 100 mEq IV\n"
            + "• Aspirin overdose, need urine alkalinization → Bicarbonate infusion",
            contraindiction: "##Absolute:##\n\n"
            + "• Metabolic or respiratory alkalosis\n"
            + "• Hypocalcemia (bicarbonate worsens it)\n"
            + "• Hypokalemia (bicarbonate shifts K+ into cells)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Heart failure or pulmonary edema (sodium and fluid load)\n"
            + "• Renal failure (can't excrete sodium load)\n"
            + "• Hypernatremia\n\n"
            + "##Critical safety point:## Do NOT routinely give bicarbonate in DKA. Insulin and fluids are the mainstays. Bicarbonate is only indicated if pH <6.9 despite treatment. Overuse can cause metabolic alkalosis, hypokalemia, and paradoxical CNS acidosis.",
            onSet: "Immediate",
            halfLife: "Unknown (buffers acid, then CO2 exhaled)",
            duration: "Variable (depends on underlying acidosis)",
            absorbtion: "N/A (IV)",
            distribution: "Extracellular fluid",
            metaBolism: "None (buffers acid → CO2 + H2O)",
            excretion: "Lungs (CO2), kidneys (excess HCO3-)",
            pregnancyExplanation: "Category C. Use in pregnancy only if benefits outweigh risks. Sodium load can worsen edema.",
            criticalPearls: "##How to use bicarbonate safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check ABG (confirm pH <7.1 or TCA overdose with wide QRS)\n"
            + "• Check electrolytes (correct hypokalemia first)\n"
            + "• Ensure adequate ventilation (need to blow off CO2)\n"
            + "• Treat underlying cause of acidosis (fluids for shock, insulin for DKA)\n\n"
            + "##While it's running:##\n\n"
            + "• Give 1 mEq/kg (50-100 mEq) IV bolus\n"
            + "• Recheck ABG in 10-15 minutes\n"
            + "• Monitor pH, sodium, potassium\n"
            + "• Increase ventilation to blow off CO2 (prevent paradoxical CNS acidosis)\n"
            + "• Do NOT overshoot (goal pH 7.2-7.3 for acidosis; 7.45-7.55 for TCA overdose)\n\n"
            + "##Bicarbonate for TCA overdose:##\n\n"
            + "##Tricyclic antidepressants## (amitriptyline, nortriptyline, imipramine) block sodium channels, causing wide QRS and arrhythmias. Bicarbonate is the antidote:\n\n"
            + "• Increases serum sodium → Overcomes sodium channel blockade\n"
            + "• Alkalinizes blood → Reduces free TCA (protein binding increases)\n"
            + "• Give if QRS >100 ms or patient is seizing\n"
            + "• Bolus: 1-2 mEq/kg (100 mEq)\n"
            + "• Goal: Narrow QRS, achieve pH 7.45-7.55\n\n"
            + "##Bicarbonate for severe metabolic acidosis:##\n\n"
            + "##Bicarbonate is NOT## first-line for most acidosis. Treat the underlying cause:\n\n"
            + "• Sepsis → Fluids, antibiotics, pressors\n"
            + "• DKA → Insulin, fluids\n"
            + "• Lactic acidosis → Treat shock\n\n"
            + "Bicarbonate is only indicated if pH <7.1 despite treating the cause. Even then, evidence is weak.\n\n"
            + "##Bicarbonate for hyperkalemia:##\n\n"
            + "Bicarbonate shifts K##+ into cells temporarily (takes 30-60 minutes). It's NOT first-line:\n\n"
            + "• First-line: Calcium (membrane stabilization), insulin + dextrose (faster K+ shift)\n"
            + "• Bicarbonate is adjunct, especially if patient is acidotic\n\n"
            + "##Bicarbonate incompatibility:##\n\n"
            + "Do NOT mix bicarbonate with calcium — it forms an insoluble precipitate. Flush the line between doses.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving bicarbonate for every acidosis (treat the underlying cause first)\n"
            + "• Overcorrecting pH (causes metabolic alkalosis, hypokalemia)\n"
            + "• Not increasing ventilation (causes paradoxical CNS acidosis)\n"
            + "• Mixing with calcium (precipitates)\n"
            + "• Using in DKA without severe acidosis (pH <6.9)\n\n"
            + "##The takeaway:##\n\n"
            + "Sodium bicarbonate is an alkalinizing agent that buffers acid, raising blood pH. It's indicated for severe metabolic acidosis (pH <7.1), TCA overdose (wide QRS), and hyperkalemia. It's NOT first-line for most acidosis — treat the underlying cause. Give boluses slowly, monitor ABG closely, and don't overshoot. Bicarbonate is the antidote for TCA overdose — it overcomes sodium channel blockade and prevents arrhythmias."
        ),
        
        // 58. Succinylcholine
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Succinylcholine",
            brandName: "Anectine",
            mechansim: "Succinylcholine is a depolarizing neuromuscular blocker that works by mimicking acetylcholine at the neuromuscular junction.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of succinylcholine as the fast-on, fast-off paralytic. It binds to the nicotinic receptor and causes a brief muscle contraction (fasciculations), then paralysis. Unlike non-depolarizing paralytics (rocuronium, vecuronium), it depolarizes the muscle first, which is why you see the twitching.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to nicotinic receptors at the neuromuscular junction\n"
            + "• Causes initial depolarization → Fasciculations (muscle twitching)\n"
            + "• Sustained depolarization → Flaccid paralysis\n"
            + "• Rapidly broken down by plasma pseudocholinesterase → Short duration (5-10 minutes)\n\n"
            + "##The key:## Succinylcholine is the fastest-acting paralytic (onset in 45-60 seconds), which is why it's the gold standard for RSI. But it has a long list of contraindications, especially hyperkalemia, because it causes a transient 0.5-1 mEq/L potassium release.\n\n"
            + "##High-yield point:## Succinylcholine is contraindicated in burns >24 hours, crush injuries, denervation injuries, and any condition with upregulated nicotinic receptors. In these cases, it can cause massive hyperkalemia (K+ >7-8 mEq/L) and cardiac arrest.",
            adverseEffects: "##Common:##\n\n"
            + "• Fasciculations (muscle twitching)\n"
            + "• Transient hyperkalemia (0.5-1 mEq/L increase)\n"
            + "• Muscle pain (myalgia) after the drug wears off\n"
            + "• Bradycardia (especially with repeat dosing)\n\n"
            + "##Serious:##\n\n"
            + "• Severe hyperkalemia (K+ >7-8 mEq/L in at-risk patients)\n"
            + "• Malignant hyperthermia (genetic disorder, rare)\n"
            + "• Masseter spasm (jaw rigidity, can't intubate)\n"
            + "• Prolonged paralysis (in pseudocholinesterase deficiency)\n\n"
            + "##The hyperkalemia risk:##\n\n"
            + "Succinylcholine causes a small potassium release (0.5-1 mEq/L) in normal patients. But in patients with upregulated nicotinic receptors, the release can be massive (K+ >7-8 mEq/L) and cause cardiac arrest.\n\n"
            + "##High-risk patients:##\n\n"
            + "• Burns >24 hours old\n"
            + "• Crush injuries >24 hours old\n"
            + "• Denervation injuries (spinal cord injury, stroke)\n"
            + "• Prolonged immobility\n"
            + "• Severe sepsis or critical illness\n"
            + "• Muscular dystrophy, myopathies\n"
            + "• Chronic renal failure (baseline K+ already high)\n\n"
            + "##Red flags:##\n\n"
            + "• Any patient with baseline hyperkalemia (K+ >5.5 mEq/L) → Don't give succinylcholine\n"
            + "• Jaw rigidity after giving succinylcholine → Possible malignant hyperthermia → Abort intubation, give dantrolene",
            dose: "##RSI (adult):##\n\n"
            + "• 1.5 mg/kg IV push (typical adult: 100-120 mg)\n"
            + "• Onset: 45-60 seconds\n"
            + "• Duration: 5-10 minutes\n\n"
            + "##Pediatric RSI:##\n\n"
            + "• 2 mg/kg IV (higher dose in kids)\n"
            + "• Onset: 45-60 seconds\n"
            + "• Always give atropine first (0.02 mg/kg) to prevent bradycardia\n\n"
            + "##Defasciculation (optional):##\n\n"
            + "• Give 10% of the RSI dose of a non-depolarizing paralytic (rocuronium 0.1 mg/kg) 3 minutes before succinylcholine\n"
            + "• This reduces fasciculations and muscle pain\n\n"
            + "##Administration:##\n\n"
            + "• Give as rapid IV push\n"
            + "• Ensure induction agent is given first (never give paralytic to an awake patient)\n"
            + "• Have bag-mask and intubation equipment ready",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Depolarizing neuromuscular blocker.\n\n"
            + "The fastest-acting paralytic, gold standard for RSI.",
            indications: "##Primary indication:##\n\n"
            + "• Rapid sequence intubation (RSI)\n\n"
            + "##You'll reach for succinylcholine when:##\n\n"
            + "• You need to intubate fast (crash airway, can't wait for rocuronium)\n"
            + "• Patient has a full stomach and aspiration risk\n"
            + "• You're unsure if you can intubate and want the paralytic to wear off quickly\n\n"
            + "##Classic scenario:## Trauma patient with full stomach, vomiting, needs emergent intubation → RSI with succinylcholine (fastest onset, shortest duration if you can't get the tube).",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hyperkalemia (K+ >5.5 mEq/L)\n"
            + "• Burns >24 hours old\n"
            + "• Crush injuries >24 hours old\n"
            + "• Denervation injuries (spinal cord injury, stroke >24 hours)\n"
            + "• Muscular dystrophy or myopathies\n"
            + "• Malignant hyperthermia (personal or family history)\n"
            + "• Pseudocholinesterase deficiency (causes prolonged paralysis)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Chronic renal failure (K+ may already be elevated)\n"
            + "• Severe sepsis or critical illness\n"
            + "• Prolonged immobility\n"
            + "• Open globe injury (increases intraocular pressure)\n\n"
            + "##Critical safety point:## If you give succinylcholine to a patient with occult hyperkalemia (undiagnosed burn, crush injury, or denervation), they can arrest from hyperkalemic cardiac arrest within minutes. When in doubt, use rocuronium instead.",
            onSet: "45-60 sec",
            halfLife: "Unknown (rapidly metabolized)",
            duration: "5-10 min",
            absorbtion: "IV only",
            distribution: "Plasma",
            metaBolism: "Plasma pseudocholinesterase (butyrylcholinesterase)",
            excretion: "Urine (metabolites)",
            pregnancyExplanation: "Category C. Safe for short-term use in pregnancy. Commonly used for RSI in obstetric emergencies (eclamptic seizure, failed airway).",
            criticalPearls: "##How to use succinylcholine safely:##\n\n"
            + "##Before giving:##\n\n"
            + "• Screen for contraindications (hyperkalemia, burns, crush injuries)\n"
            + "• Check K+ if available (don't give if K+ >5.5 mEq/L)\n"
            + "• Give induction agent first (never paralyze an awake patient)\n"
            + "• In kids, give atropine first to prevent bradycardia\n"
            + "• Have backup plan (rocuronium) if succinylcholine is contraindicated\n\n"
            + "##During administration:##\n\n"
            + "• Give as rapid IV push\n"
            + "• Watch for fasciculations (means it's working)\n"
            + "• Paralysis occurs 45-60 seconds after fasciculations stop\n"
            + "• Intubate immediately once paralyzed\n\n"
            + "##After giving:##\n\n"
            + "• Monitor for bradycardia (give atropine if HR <50)\n"
            + "• If you can't intubate, bag the patient — paralysis wears off in 5-10 minutes\n"
            + "• If jaw rigidity occurs → Suspect malignant hyperthermia → Abort, give dantrolene\n\n"
            + "When to use rocuronium instead:##\n\n"
            + "Succinylcholine has so many contraindications that many centers now use rocuronium 1.2 mg/kg as the default RSI paralytic. It's nearly as fast (onset 60-90 seconds vs 45-60 seconds) and can be reversed with sugammadex if you can't intubate.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving succinylcholine to a burn patient (even if they look fine — it's the upregulated receptors that matter)\n"
            + "• Not asking about family history of malignant hyperthermia\n"
            + "• Forgetting to give atropine first in kids (causes severe bradycardia)\n"
            + "• Not having a backup paralytic (rocuronium) ready if succinylcholine is contraindicated\n\n"
            + "##The takeaway:##\n\n"
            + "Succinylcholine is the fastest paralytic for RSI — 45-60 seconds to full paralysis, wears off in 5-10 minutes. But it has a long list of contraindications, especially hyperkalemia. Screen carefully before giving, and when in doubt, use rocuronium instead. It's nearly as fast and safer in most scenarios."
        ),
        
        // 59. Terbutaline
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Terbutaline",
            brandName: "Brethine ®",
            mechansim: "Terbutaline is a β2-adrenergic agonist that relaxes smooth muscle in both the bronchi and uterus.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of terbutaline as the dual-purpose β2-agonist — it opens airways (bronchodilation) and stops uterine contractions (tocolytic). It's more β2-selective than albuterol, so it causes less tachycardia, but it's not commonly used for asthma anymore (albuterol is preferred). Its main use now is tocolysis (stopping preterm labor).\n\n"
            + "##How it works:##\n\n"
            + "• Binds to β2 receptors on bronchial smooth muscle → Bronchodilation\n"
            + "• Binds to β2 receptors on uterine smooth muscle → Relaxes uterus (stops contractions)\n"
            + "• More β2-selective than albuterol → Less tachycardia\n"
            + "• Increases cAMP → Relaxes smooth muscle\n\n"
            + "##The key:## Terbutaline is rarely used for asthma anymore (albuterol is preferred). Its main indication is tocolysis (preterm labor). However, tocolytics don't actually improve neonatal outcomes — they just delay delivery by 24-48 hours to allow for steroid administration (betamethasone) to mature fetal lungs.\n\n"
            + "##High-yield point:## Terbutaline for tocolysis is controversial. The goal isn't to stop labor permanently — it's to delay delivery by 24-48 hours so you can give steroids to mature the fetal lungs. Prolonged tocolysis (>48 hours) doesn't improve outcomes and increases maternal risk.",
            adverseEffects: "##Common:##\n\n"
            + "• Tachycardia (maternal and fetal)\n"
            + "• Tremors\n"
            + "• Nervousness, anxiety\n"
            + "• Palpitations\n"
            + "• Hypotension (vasodilation)\n\n"
            + "##Serious:##\n\n"
            + "• Pulmonary edema (especially with prolonged use)\n"
            + "• Myocardial ischemia (tachycardia increases O₂ demand)\n"
            + "• Arrhythmias\n"
            + "• Hyperglycemia (β2 effects)\n"
            + "• Hypokalemia (shifts K+ into cells)\n\n"
            + "##The pulmonary edema problem:##\n\n"
            + "Terbutaline can cause pulmonary edema, especially with prolonged use or in patients with multiple gestations, infection, or fluid overload. This is thought to be due to increased cardiac output and fluid shifts.\n\n"
            + "##Red flags:##\n\n"
            + "• Maternal HR >120 (excessive tachycardia)\n"
            + "• Fetal HR >180 (fetal tachycardia)\n"
            + "• Dyspnea, crackles (pulmonary edema)\n"
            + "• Chest pain (myocardial ischemia)",
            dose: "##Preterm Labor (Tocolysis):##\n\n"
            + "• 0.25 mg SQ every 20 minutes to 4 hours (until contractions stop)\n"
            + "• Max: 0.5 mg in 4 hours\n"
            + "• Goal: Delay delivery 24-48 hours (for steroid administration)\n\n"
            + "##Bronchospasm (rare, albuterol preferred):##\n\n"
            + "• 0.25 mg SQ every 4-6 hours\n"
            + "• Or 2.5-5 mg nebulized\n\n"
            + "##Administration:##\n\n"
            + "• SQ injection for tocolysis\n"
            + "• Monitor maternal and fetal heart rate\n"
            + "• Limit duration to 48 hours (prolonged use increases complications)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "β2-adrenergic agonist, bronchodilator, tocolytic.\n\n"
            + "Used primarily for tocolysis (preterm labor). Rarely used for bronchospasm (albuterol preferred).",
            indications: "##Primary indications:##\n\n"
            + "• Preterm labor (tocolysis) — delay delivery 24-48 hours for steroids\n"
            + "• Bronchospasm (rare, albuterol preferred)\n\n"
            + "##You'll reach for terbutaline when:##\n\n"
            + "• Preterm labor (24-34 weeks) — delay delivery for betamethasone\n"
            + "• Need tocolysis (rarely used now, nifedipine preferred)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• 30-week pregnant patient, regular contractions, cervix dilating → Terbutaline 0.25 mg SQ (delay delivery for betamethasone)\n"
            + "• Preterm labor, need 24-48 hour delay → Terbutaline tocolysis",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity\n"
            + "• Active cardiac disease (tachycardia risk)\n"
            + "• Uncontrolled diabetes (causes hyperglycemia)\n"
            + "• Hyperthyroidism (increased sensitivity)\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Multiple gestations (increased risk of pulmonary edema)\n"
            + "• Infection (increases pulmonary edema risk)\n"
            + "• Fluid overload\n"
            + "• Maternal tachycardia >120\n\n"
            + "##Critical safety point:## Terbutaline for tocolysis is controversial and rarely used now. Nifedipine (calcium channel blocker) is preferred because it's more effective and has fewer side effects. Terbutaline can cause pulmonary edema, especially with prolonged use.",
            onSet: "6-15 min (SQ)",
            halfLife: "3-4 hrs",
            duration: "4 hrs",
            absorbtion: "Rapid (SQ)",
            distribution: "Crosses placenta, enters breast milk",
            metaBolism: "Liver",
            excretion: "Urine",
            pregnancyExplanation: "Category B. Used in pregnancy for tocolysis. No teratogenic effects reported, but can cause maternal and fetal tachycardia.",
            criticalPearls: "##How to use terbutaline safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Confirm preterm labor (24-34 weeks)\n"
            + "• Check maternal heart rate (hold if HR >120)\n"
            + "• Check for cardiac disease, diabetes, infection\n"
            + "• Goal: Delay delivery 24-48 hours for betamethasone\n\n"
            + "##While it's running:##\n\n"
            + "• Monitor maternal HR (goal <120)\n"
            + "• Monitor fetal HR (watch for tachycardia >180)\n"
            + "• Watch for pulmonary edema (dyspnea, crackles)\n"
            + "• Limit duration to 48 hours (prolonged use increases complications)\n\n"
            + "##Tocolysis goals:##\n\n"
            + "• Delay delivery by 24-48 hours\n"
            + "• Allow time for betamethasone (steroid) to mature fetal lungs\n"
            + "• NOT to stop labor permanently\n"
            + "• Dose: 0.25 mg SQ every 20 minutes to 4 hours until contractions stop\n\n"
            + "##Prolonged tocolysis (>48 hours) doesn't improve outcomes:##\n\n"
            + "Studies show that tocolytics don't improve neonatal outcomes beyond 48 hours. The goal is just to delay delivery long enough to give steroids (betamethasone 12 mg IM × 2 doses, 24 hours apart).\n\n"
            + "##Terbutaline vs. Nifedipine for tocolysis:##\n\n"
            + "##Terbutaline:##\n\n"
            + "• β2-agonist\n"
            + "• Causes tachycardia, pulmonary edema\n"
            + "• Rarely used now\n\n"
            + "##Nifedipine:##\n\n"
            + "• Calcium channel blocker\n"
            + "• More effective\n"
            + "• Fewer side effects\n"
            + "• Preferred for tocolysis\n\n"
            + "##Bottom line:## Nifedipine is preferred for tocolysis. Terbutaline is rarely used.\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using terbutaline for prolonged tocolysis (>48 hours) — doesn't improve outcomes\n"
            + "• Not monitoring for pulmonary edema (can be fatal)\n"
            + "• Using for asthma (albuterol is preferred)\n\n"
            + "##The takeaway:##\n\n"
            + "Terbutaline is a β2-agonist that relaxes both bronchial and uterine smooth muscle. It's rarely used for asthma (albuterol is preferred). Its main use is tocolysis (preterm labor), but nifedipine is now preferred. The goal of tocolysis is to delay delivery 24-48 hours for steroid administration, not to stop labor permanently. Terbutaline can cause pulmonary edema, especially with prolonged use."
        ),
        
        // 60. Thiamine (Updated)
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Thiamine",
            brandName: "Vitamin B-1",
            mechansim: "Thiamine (Vitamin B1) is an essential coenzyme for carbohydrate metabolism, required for energy production in the brain and heart.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of thiamine as brain fuel. Without it, the brain can't metabolize glucose properly, leading to Wernicke's encephalopathy (confusion, ataxia, ophthalmoplegia). Alcoholics and malnourished patients are chronically thiamine-depleted. Give thiamine BEFORE glucose to prevent precipitating or worsening Wernicke's.\n\n"
            + "##How it works:##\n\n"
            + "• Coenzyme for pyruvate dehydrogenase → Converts pyruvate to acetyl-CoA (energy production)\n"
            + "• Coenzyme for transketolase → Pentose phosphate pathway (NADPH production)\n"
            + "• Required for aerobic metabolism in brain and heart\n"
            + "• Without thiamine → Lactate accumulation, cellular energy failure\n\n"
            + "##The key:## Always give thiamine BEFORE or WITH glucose in alcoholics and malnourished patients. Giving glucose alone in a thiamine-depleted patient can precipitate or worsen Wernicke's encephalopathy by increasing metabolic demand for thiamine.\n\n"
            + "##High-yield point:## Wernicke's triad is confusion, ataxia, and ophthalmoplegia (nystagmus, CN VI palsy). Not all patients have all three. If untreated, Wernicke's progresses to Korsakoff's syndrome (permanent anterograde amnesia, confabulation).",
            adverseEffects: "##Common:##\n\n"
            + "• Injection site pain\n"
            + "• Warm feeling\n"
            + "• Rarely: nausea\n\n"
            + "##Serious:##\n\n"
            + "• Anaphylaxis (rare, more common with IV push)\n\n"
            + "##The safety profile:##\n\n"
            + "Thiamine is extremely safe. It's water-soluble, so excess is excreted in urine. Anaphylaxis is very rare but can occur with IV push. For prevention dosing (100 mg), IM or slow IV is fine. For treatment of Wernicke's (500 mg), give IV infusion.",
            dose: "##Prevention (at-risk patients):##\n\n"
            + "• 100 mg IV or IM daily\n"
            + "• Give to all alcohol-dependent patients\n"
            + "• Give before or with glucose\n\n"
            + "##Treatment of Wernicke's Encephalopathy:##\n\n"
            + "• 500 mg IV over 30 minutes, 3 times daily for 2-3 days\n"
            + "• Then 250-500 mg IV daily for 3-5 more days\n"
            + "• Continue oral supplementation\n\n"
            + "##Alcohol withdrawal:##\n\n"
            + "• 100 mg IM or IV daily during acute withdrawal\n"
            + "• Continue oral maintenance\n\n"
            + "##Administration:##\n\n"
            + "• Prevention: 100 mg IM or slow IV\n"
            + "• Treatment: 500 mg IV infusion over 30 min\n"
            + "• Give BEFORE glucose in malnourished patients",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.A),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.A),
            DrugClass: "Vitamin (B1).\n\n"
            + "Essential for glucose metabolism in brain and heart. Prevents and treats Wernicke's encephalopathy.",
            indications: "##Primary indications:##\n\n"
            + "• Wernicke's encephalopathy (treatment)\n"
            + "• Alcohol-dependent patients (prevention)\n"
            + "• Malnourished patients (before glucose)\n"
            + "• Refeeding syndrome prevention\n\n"
            + "##You'll reach for thiamine when:##\n\n"
            + "• Any alcohol-dependent patient presenting to ED\n"
            + "• Altered mental status + alcohol use history\n"
            + "• Before giving glucose to malnourished patients\n"
            + "• Confusion, ataxia, or eye movement abnormalities\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Chronic alcoholic found confused → Thiamine 500 mg IV before glucose\n"
            + "• Alcohol withdrawal, starting treatment → Thiamine 100 mg IV + banana bag\n"
            + "• Cachetic patient with confusion, nystagmus → Wernicke's → High-dose thiamine",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity (very rare)\n\n"
            + "##Relative:##\n\n"
            + "• History of anaphylaxis to thiamine (extremely rare)\n\n"
            + "##Critical safety point:## Thiamine is extremely safe with almost no contraindications. The risk of not giving it far outweighs any risk of giving it. When in doubt, give thiamine.",
            onSet: "Hours to days (clinical improvement)",
            halfLife: "Unknown (water-soluble, rapidly eliminated)",
            duration: "Must give daily (no storage)",
            absorbtion: "Rapid (IV and IM)",
            distribution: "Widely distributed, crosses blood-brain barrier",
            metaBolism: "Utilized as coenzyme",
            excretion: "Urine (excess excreted)",
            pregnancyExplanation: "Category A. Safe in pregnancy. Essential vitamin.",
            criticalPearls: "##How to use thiamine safely:##\n\n"
            + "##The cardinal rule:##\n\n"
            + "##THIAMINE BEFORE GLUCOSE!## Giving glucose to a thiamine-depleted patient can precipitate or worsen Wernicke's encephalopathy by increasing metabolic demand for thiamine.\n\n"
            + "##Who needs thiamine:##\n\n"
            + "• All alcohol-dependent patients\n"
            + "• Malnourished patients\n"
            + "• Hyperemesis gravidarum\n"
            + "• Refeeding after prolonged starvation\n"
            + "• Bariatric surgery patients\n"
            + "• Dialysis patients\n\n"
            + "##Wernicke's Encephalopathy:##\n\n"
            + "##Classic triad:## Confusion, ataxia, ophthalmoplegia (nystagmus, CN VI palsy)\n\n"
            + "##But:## Only 10-30% have all three! Confusion alone can be Wernicke's.\n\n"
            + "##Diagnosis is clinical:## If you suspect it, treat it. Don't wait for confirmation.\n\n"
            + "##Treatment dosing:## 500 mg IV three times daily for 2-3 days, not 100 mg\n\n"
            + "##Prevention vs. Treatment:##\n\n"
            + "• ##Prevention:## 100 mg IV or IM daily (alcoholics, malnourished)\n"
            + "• ##Treatment of Wernicke's:## 500 mg IV three times daily × 2-3 days\n\n"
            + "The 100 mg dose is for prevention only. If Wernicke's is suspected, use high-dose (500 mg TID).\n\n"
            + "##Why before glucose:##\n\n"
            + "• Thiamine is required for glucose metabolism\n"
            + "• Giving glucose increases metabolic demand for thiamine\n"
            + "• In depleted patients, this can precipitate acute Wernicke's\n"
            + "• Always give thiamine first or simultaneously with glucose\n\n"
            + "##Common mistakes:##\n\n"
            + "• Using 100 mg for Wernicke's treatment (need 500 mg TID)\n"
            + "• Giving glucose before thiamine in alcoholics\n"
            + "• Waiting for all three of the triad to treat (only 10-30% have all three)\n"
            + "• Stopping thiamine too early\n\n"
            + "##The takeaway:##\n\n"
            + "Thiamine is essential for glucose metabolism in the brain. Give it to all alcoholics and malnourished patients, BEFORE giving glucose. For prevention, use 100 mg daily. For Wernicke's treatment, use 500 mg IV three times daily. It's extremely safe — when in doubt, give it."
        ),
        // 61. Tranexamic Acid (TXA)
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Tranexamic Acid (TXA)",
            brandName: "Cyklokapron ®",
            mechansim: "Tranexamic acid is an antifibrinolytic that prevents clot breakdown by blocking plasminogen activation.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of TXA as the clot stabilizer — it doesn't make new clots, it prevents existing clots from breaking down. In trauma, patients often have hyperfibrinolysis (clots breaking down too fast), which worsens bleeding. TXA blocks this process, stabilizing clots and reducing blood loss.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks plasminogen activation → Prevents plasmin formation\n"
            + "• Plasmin breaks down fibrin clots → TXA prevents this breakdown\n"
            + "• Stabilizes existing clots → Reduces bleeding\n"
            + "• Does NOT cause new clot formation (just prevents breakdown)\n\n"
            + "##The key:## TXA must be given within 3 hours of injury to be effective. The CRASH-2 trial showed that TXA reduces mortality in trauma patients with significant bleeding when given early. After 3 hours, it may actually increase mortality (possibly due to increased thrombotic complications).\n\n"
            + "##High-yield point:## TXA reduces mortality in trauma patients with significant bleeding (SBP <90 or HR >110) when given within 3 hours of injury. The benefit is greatest when given within 1 hour. After 3 hours, don't give it — it may increase mortality.",
            adverseEffects: "##Common:##\n\n"
            + "• Nausea, vomiting\n"
            + "• Diarrhea\n"
            + "• Dizziness\n\n"
            + "##Serious:##\n\n"
            + "• Thrombosis (DVT, PE, stroke) — especially if given >3 hours after injury\n"
            + "• Seizures (with high doses or intrathecal use)\n"
            + "• Visual disturbances (rare)\n\n"
            + "##The thrombosis problem:##\n\n"
            + "TXA prevents clot breakdown, which can lead to thrombosis if given too late (>3 hours) or in patients with hypercoagulable states. The CRASH-2 trial showed increased mortality when TXA was given >3 hours after injury.\n\n"
            + "##Red flags:##\n\n"
            + "• Signs of thrombosis (DVT, PE, stroke) after TXA administration\n"
            + "• Seizures (especially with high doses)\n"
            + "• Given >3 hours after injury (increased mortality risk)",
            dose: "##Trauma with Significant Bleeding:##\n\n"
            + "• Loading: 1 g IV over 10 minutes\n"
            + "• Then: 1 g IV over 8 hours\n"
            + "• Must give within 3 hours of injury (best if within 1 hour)\n\n"
            + "##Postpartum Hemorrhage:##\n\n"
            + "• 1 g IV over 10 minutes\n"
            + "• May repeat once if bleeding continues\n\n"
            + "##Surgery (cardiac, orthopedic):##\n\n"
            + "• 10-15 mg/kg IV before incision\n"
            + "• Or 1 g IV before surgery\n\n"
            + "##Administration:##\n\n"
            + "• Give first dose within 3 hours of injury (critical)\n"
            + "• Can give IV push or infusion\n"
            + "• Don't give if injury >3 hours old",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Antifibrinolytic.\n\n"
            + "Used for trauma with significant bleeding, postpartum hemorrhage, and surgical bleeding prophylaxis.",
            indications: "##Primary indications:##\n\n"
            + "• Trauma with significant bleeding (SBP <90 or HR >110)\n"
            + "• Postpartum hemorrhage\n"
            + "• Surgical bleeding prophylaxis (cardiac, orthopedic surgery)\n"
            + "• Menorrhagia (heavy menstrual bleeding)\n\n"
            + "##You'll reach for TXA when:##\n\n"
            + "• Trauma patient with significant bleeding, within 3 hours of injury\n"
            + "• Postpartum hemorrhage not responding to oxytocin\n"
            + "• Surgical patient at high risk for bleeding\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Trauma patient, SBP 85, HR 120, 30 minutes post-injury → TXA 1 g IV\n"
            + "• Postpartum hemorrhage, bleeding heavily → TXA 1 g IV\n"
            + "• Cardiac surgery, high bleeding risk → TXA 1 g IV before surgery",
            contraindiction: "##Absolute:##\n\n"
            + "• Injury >3 hours old (increases mortality)\n"
            + "• Active intravascular clotting (DIC with thrombosis)\n"
            + "• Known hypersensitivity\n\n"
            + "##Relative/High caution:##\n\n"
            + "• History of thrombosis (DVT, PE, stroke)\n"
            + "• Hypercoagulable states\n"
            + "• Renal failure (TXA is renally cleared)\n\n"
            + "##Critical safety point:## TXA must be given within 3 hours of injury. The CRASH-2 trial showed that TXA given >3 hours after injury increases mortality (likely due to increased thrombotic complications). Don't give it if the injury is >3 hours old.",
            onSet: "Immediate",
            halfLife: "2-3 hrs",
            duration: "24 hrs",
            absorbtion: "Rapid (IV)",
            distribution: "Extracellular fluid",
            metaBolism: "Minimal (mostly excreted unchanged)",
            excretion: "Urine (95% unchanged)",
            pregnancyExplanation: "Category B. Generally safe in pregnancy. Used for postpartum hemorrhage. No teratogenic effects reported.",
            criticalPearls: "##How to use TXA safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Confirm injury time (must be <3 hours old)\n"
            + "• Check for signs of significant bleeding (SBP <90, HR >110)\n"
            + "• Rule out active thrombosis (DIC with thrombosis)\n\n"
            + "##While it's running:##\n\n"
            + "• Give loading dose (1 g over 10 minutes) immediately\n"
            + "• Start infusion (1 g over 8 hours)\n"
            + "• Monitor for signs of thrombosis (DVT, PE, stroke)\n"
            + "• Don't give if injury >3 hours old\n\n"
            + "##TXA for trauma (CRASH-2 trial):##\n\n"
            + "##The CRASH-2 trial showed:##\n\n"
            + "• TXA reduces mortality in trauma patients with significant bleeding\n"
            + "• Benefit is greatest when given within 1 hour of injury\n"
            + "• Still beneficial when given 1-3 hours after injury\n"
            + "• INCREASES mortality when given >3 hours after injury\n\n"
            + "##Indications:##\n\n"
            + "• SBP <90 mmHg OR HR >110 bpm\n"
            + "• Significant bleeding (visible or suspected)\n"
            + "• Within 3 hours of injury\n\n"
            + "##Dose:## 1 g IV over 10 minutes, then 1 g IV over 8 hours\n\n"
            + "##TXA for postpartum hemorrhage:##\n\n"
            + "##TXA is effective## for postpartum hemorrhage:\n\n"
            + "• 1 g IV over 10 minutes\n"
            + "• May repeat once if bleeding continues\n"
            + "• Give early (within 3 hours of delivery)\n\n"
            + "##Common mistakes:##\n\n"
            + "• Giving TXA >3 hours after injury (increases mortality)\n"
            + "• Not checking injury time before giving\n"
            + "• Using in patients with active thrombosis\n"
            + "• Not monitoring for thrombotic complications\n\n"
            + "##The takeaway:##\n\n"
            + "TXA is an antifibrinolytic that prevents clot breakdown, reducing bleeding in trauma and postpartum hemorrhage. It must be given within 3 hours of injury to be effective — giving it >3 hours increases mortality. The dose is 1 g IV over 10 minutes, then 1 g IV over 8 hours. Monitor for thrombotic complications."
        ),
        
        // 62. Vancomycin - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Vancomycin",
            brandName: "Vancocin",
            mechansim: "Vancomycin is a glycopeptide antibiotic that inhibits bacterial cell wall synthesis by binding to D-Ala-D-Ala terminals.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of vancomycin as the MRSA killer that demands respect for the kidneys. It's a large molecule that can't penetrate gram-negative outer membranes, so it only works on gram-positive bacteria. It grabs the building blocks of the bacterial cell wall and stops construction cold.\n\n"
            + "##How it works:##\n\n"
            + "• Binds to D-Ala-D-Ala peptide chains in bacterial cell wall precursors\n"
            + "• Prevents cross-linking and cell wall synthesis\n"
            + "• Bactericidal against most gram-positive bacteria\n"
            + "• Too large to cross gram-negative outer membrane (no gram-negative coverage)\n\n"
            + "##The key:## Vancomycin is effective and toxic in a narrow dose range. Too little and it fails, too much and you damage the kidneys. AUC-guided dosing (area under the curve) is now preferred over trough-based dosing.\n\n"
            + "##High-yield point:## The combination of vancomycin + piperacillin-tazobactam (Zosyn) has synergistic nephrotoxicity — up to 35% AKI risk. Consider alternative combinations when possible.",
            adverseEffects: "##Common:##\n\n"
            + "• Nephrotoxicity (dose-dependent, most common serious effect)\n"
            + "• Red Man Syndrome (histamine release from rapid infusion)\n"
            + "• Phlebitis (peripheral IV)\n"
            + "• Nausea\n\n"
            + "##Serious:##\n\n"
            + "• Acute kidney injury (especially with concurrent nephrotoxins)\n"
            + "• Ototoxicity (hearing loss, tinnitus)\n"
            + "• Thrombocytopenia\n"
            + "• Drug-induced interstitial nephritis\n\n"
            + "##Red Man Syndrome:##\n\n"
            + "This is histamine release from too-rapid infusion. The patient develops flushing, itching, hypotension, and sometimes chest pain during or shortly after the infusion.\n\n"
            + "• Prevent it: Infuse over at least 60 minutes (longer for higher doses)\n"
            + "• Treat it: Stop infusion, give antihistamines (diphenhydramine), slow the rate\n"
            + "• It's NOT an allergy — you can rechallenge once resolved\n\n"
            + "##The nephrotoxicity problem:##\n\n"
            + "Days into therapy, the creatinine creeps up. Urine output falls. Troughs drift too high. That's vancomycin nephrotoxicity until proven otherwise.\n\n"
            + "##High-risk situations:##\n\n"
            + "• Vancomycin + piperacillin-tazobactam (35% AKI risk)\n"
            + "• Vancomycin + aminoglycosides\n"
            + "• IV contrast administration\n"
            + "• Shock or dehydration\n"
            + "• Baseline chronic kidney disease\n\n"
            + "##Red flags:##\n\n"
            + "• Rising creatinine (check daily)\n"
            + "• Decreasing urine output\n"
            + "• Trough >20 mcg/mL or AUC >600\n"
            + "• New hearing loss or tinnitus",
            dose: "##Loading dose (critically ill):##\n\n"
            + "• 25-30 mg/kg IV (actual body weight)\n"
            + "• Give over 2-3 hours\n"
            + "• Max single dose: typically 2-3 g\n"
            + "• Use in septic shock, meningitis, or severe infections\n\n"
            + "##Maintenance dosing (traditional):##\n\n"
            + "• 15-20 mg/kg IV every 8-12 hours\n"
            + "• Adjust interval based on renal function\n"
            + "• Normal renal function: q8-12h\n"
            + "• CrCl 40-60: q12-24h\n"
            + "• CrCl <40: q24-48h or longer\n\n"
            + "##AUC-guided dosing (preferred):##\n\n"
            + "• Target AUC/MIC ratio 400-600\n"
            + "• Requires pharmacokinetic calculation\n"
            + "• More accurate than trough-only monitoring\n\n"
            + "##Monitoring:##\n\n"
            + "• Check trough before 4th dose (steady state)\n"
            + "• Target trough: 15-20 mcg/mL (for serious infections)\n"
            + "• Target trough: 10-15 mcg/mL (for less severe infections)\n"
            + "• Better: Use AUC monitoring if available\n\n"
            + "##Oral vancomycin (C. difficile):##\n\n"
            + "• 125 mg PO four times daily\n"
            + "• Stays in gut (not absorbed systemically)\n"
            + "• Only for C. difficile colitis",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.UseWithCaution),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.UseWithCaution),
            DrugClass: "Glycopeptide antibiotic.\n\n"
            + "The backbone drug for MRSA and serious gram-positive infections.",
            indications: "##Primary indications:##\n\n"
            + "• MRSA infections (pneumonia, bacteremia, endocarditis, osteomyelitis)\n"
            + "• Methicillin-susceptible Staph aureus (MSSA) when allergic to beta-lactams\n"
            + "• Coagulase-negative staph infections (line infections)\n"
            + "• Enterococcus (some strains)\n"
            + "• C. difficile colitis (oral formulation only)\n"
            + "• Meningitis (gram-positive, penetrates inflamed meninges)\n\n"
            + "##You'll reach for vancomycin when:##\n\n"
            + "• Gram-positive cocci in clusters on gram stain (likely Staph)\n"
            + "• Known MRSA colonization + new infection\n"
            + "• Healthcare-associated pneumonia (cover MRSA empirically)\n"
            + "• Line infection (central line-associated bloodstream infection)\n"
            + "• Septic shock with unknown source (add to broad gram-negative coverage)\n\n"
            + "##What vancomycin covers:##\n\n"
            + "• MRSA (Methicillin-resistant Staph aureus)\n"
            + "• MSSA (though beta-lactams are better)\n"
            + "• Coagulase-negative Staph\n"
            + "• Most Streptococcus species\n"
            + "• Some Enterococcus (not VRE)\n"
            + "• C. difficile (oral only)\n\n"
            + "##What vancomycin does NOT cover:##\n\n"
            + "• No gram-negative bacteria (too big to cross outer membrane)\n"
            + "• No anaerobes (except C. diff if given orally)\n"
            + "• No atypicals (Legionella, Mycoplasma, Chlamydia)\n"
            + "• VRE (vancomycin-resistant Enterococcus)\n\n"
            + "##Classic scenarios:##\n\n"
            + "• Blood culture shows gram-positive cocci in clusters → Start vancomycin empirically (likely Staph)\n"
            + "• Healthcare-associated pneumonia → Vancomycin + Zosyn (cover MRSA + Pseudomonas)\n"
            + "• Central line infection → Vancomycin (empiric for Staph while awaiting cultures)",
            contraindiction: "##Absolute:##\n\n"
            + "• Known hypersensitivity to vancomycin\n\n"
            + "##Relative/High caution:##\n\n"
            + "• Chronic kidney disease (dose adjust required)\n"
            + "• Concurrent nephrotoxic drugs (consider alternatives)\n"
            + "• Hearing loss or ototoxicity history\n\n"
            + "##Critical safety point:## Red Man Syndrome is NOT an allergy — it's histamine release. Slow the infusion rate and pre-treat with antihistamines if it recurs. True vancomycin allergy is rare.",
            onSet: "Slow (hours to days for clinical effect)",
            halfLife: "4-8 hours (normal renal function), prolonged in renal failure",
            duration: "Requires continuous therapy until infection clears",
            absorbtion: "IV for systemic infections, PO for C. difficile (not absorbed from gut)",
            distribution: "Widely distributed (except CSF unless meninges inflamed)",
            metaBolism: "Minimal metabolism",
            excretion: "Renal (80-90% unchanged) — dose adjust for renal impairment",
            pregnancyExplanation: "Category C (prior to 2015 classification). Use with caution in pregnancy. Safe for maternal infections when benefits outweigh risks. Monitor levels closely.",
            criticalPearls: "##How to use vancomycin safely:##\n\n"
            + "##Before starting:##\n\n"
            + "• Check baseline creatinine and renal function\n"
            + "• Calculate loading dose (25-30 mg/kg for critically ill)\n"
            + "• Review medication list for other nephrotoxins\n"
            + "• Get cultures before first dose if possible\n\n"
            + "##During therapy:##\n\n"
            + "• Infuse over at least 60 minutes (longer for doses >1 g)\n"
            + "• Check creatinine daily\n"
            + "• Monitor trough before 4th dose (or use AUC if available)\n"
            + "• Adjust dose based on levels and renal function\n"
            + "• Avoid other nephrotoxins when possible\n\n"
            + "##Target levels:##\n\n"
            + "• Serious infections (bacteremia, pneumonia, meningitis): Trough 15-20 mcg/mL or AUC 400-600\n"
            + "• Less severe infections: Trough 10-15 mcg/mL or AUC 400-600\n"
            + "• If trough >20 mcg/mL: Hold dose, recheck level, adjust dosing\n\n"
            + "##The vancomycin + Zosyn problem:##\n\n"
            + "This is one of the most common antibiotic## combinations in the ICU (covers MRSA + Pseudomonas), but it has synergistic nephrotoxicity:\n"
            + "• AKI risk: 35% with combination\n"
            + "• AKI risk: 16% with vancomycin alone\n"
            + "• AKI risk: 13% with Zosyn alone\n\n"
            + "##Alternatives to consider:##\n\n"
            + "• Vancomycin + cefepime (less nephrotoxic)\n"
            + "• Vancomycin + aztreonam\n"
            + "• Linezolid + Zosyn (if MRSA risk but concerned about kidneys)\n\n"
            + "##De-escalation strategy:##\n\n"
            + "• If MRSA not found on cultures → Stop vancomycin\n"
            + "• If MSSA found → Switch to nafcillin or cefazolin (better than vancomycin for MSSA)\n"
            + "• Don't continue vancomycin \"just in case\"\n\n"
            + "##Common mistakes:##\n\n"
            + "• Not giving loading dose in critically ill patients\n"
            + "• Infusing too fast (causes Red Man Syndrome)\n"
            + "• Not monitoring levels or renal function\n"
            + "• Continuing vancomycin after negative cultures\n"
            + "• Using vancomycin for MSSA when beta-lactams are better\n"
            + "• Not dose-adjusting for renal dysfunction\n\n"
            + "##The takeaway:##\n\n"
            + "Vancomycin is the backbone antibiotic for MRSA, but it demands careful monitoring. Give a loading dose in sick patients, infuse slowly to avoid Red Man Syndrome, check levels and creatinine regularly, and de-escalate early when cultures come back. Watch the kidneys closely, especially with other nephrotoxins. It's effective and safe when dosed correctly."
        ),
        
        // 63. Vecuronium (Updated)
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Vecuronium",
            brandName: "Norcuron ®",
            mechansim: "Vecuronium is a non-depolarizing neuromuscular blocker that competitively antagonizes acetylcholine at the nicotinic receptor.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of vecuronium as the long-acting, hemodynamically neutral paralytic. It's slower than rocuronium (2-3 minutes vs. 60-90 seconds) but has zero cardiovascular effects — no tachycardia, no hypotension, no histamine release.\n\n"
            + "##How it works:##\n\n"
            + "• Competes with acetylcholine at nicotinic receptors at the neuromuscular junction\n"
            + "• Blocks muscle contraction without causing depolarization\n"
            + "• No fasciculations, no hyperkalemia (unlike succinylcholine)\n"
            + "• Cannot be reversed with sugammadex (unlike rocuronium)\n\n"
            + "##Key concept:## Vecuronium is the paralytic of choice when you need hemodynamic stability and aren't in a rush. It's ideal for controlled intubations, prolonged paralysis in the ICU, or patients with cardiovascular instability where you can't tolerate any blood pressure changes.\n\n"
            + "##High-yield point:## Vecuronium comes as a powder and must be reconstituted — this takes time. It's NOT the first choice for RSI (use rocuronium or succinylcholine instead). Use vecuronium for elective intubations or ICU paralysis.",
            adverseEffects: "##Common:##\n\n"
            + "• Prolonged paralysis (45-65 minutes, can be longer in renal/hepatic failure)\n"
            + "• Apnea (expected — this is a paralytic!)\n\n"
            + "##Serious:##\n\n"
            + "• Prolonged paralysis in ICU (critical illness myopathy)\n"
            + "• Anaphylaxis (rare)\n"
            + "• Bronchospasm (very rare)\n\n"
            + "##Critical illness myopathy:##\n\n"
            + "Prolonged use of paralytics (especially with steroids) can cause severe weakness that persists for weeks or months after stopping the drug. This is ICU-acquired weakness.\n\n"
            + "##How to avoid:##\n\n"
            + "• Use the lowest dose necessary\n"
            + "• Daily sedation holidays to assess need\n"
            + "• Avoid concurrent steroids if possible\n"
            + "• Use train-of-four monitoring to titrate dose\n\n"
            + "##Red flags:##\n\n"
            + "• Patient still paralyzed hours after stopping vecuronium → Check liver/kidney function, consider neostigmine reversal",
            dose: "##RSI/Intubation:##\n\n"
            + "• 0.1 mg/kg IV (typical adult: 8-10 mg)\n"
            + "• Onset: 2-3 minutes (too slow for emergent RSI)\n"
            + "• Duration: 45-65 minutes\n\n"
            + "##Maintenance (ICU paralysis):##\n\n"
            + "• Bolus: 0.01-0.015 mg/kg IV q30-60min\n"
            + "• Infusion: 0.8-1.2 mcg/kg/min\n\n"
            + "##Reconstitution:##\n\n"
            + "• Vecuronium comes as a powder (10 mg vial)\n"
            + "• Reconstitute with 10 mL sterile water → 1 mg/mL solution\n"
            + "• Use immediately after reconstitution\n\n"
            + "##Reversal (if needed):##\n\n"
            + "• Neostigmine 0.04-0.07 mg/kg + glycopyrrolate 0.01 mg/kg\n"
            + "• OR sugammadex does NOT reverse vecuronium effectively (only rocuronium)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "##Non-depolarizing neuromuscular blocker.##\n\n"
            + "The hemodynamically neutral paralytic for controlled intubations and ICU paralysis.",
            indications: "##Standard Indications:##\n\n"
            + "• Elective/controlled intubation (not emergent RSI)\n"
            + "• Prolonged paralysis in ICU (ARDS, ventilator dyssynchrony)\n"
            + "• Procedures requiring muscle relaxation\n"
            + "• Patients who can't tolerate hemodynamic changes\n\n"
            + "When to reach for vecuronium:##\n\n"
            + "• You have time to wait 2-3 minutes for paralysis\n"
            + "• Patient is hemodynamically unstable (can't risk rocuronium's mild tachycardia)\n"
            + "• Need prolonged ICU paralysis\n"
            + "• Avoiding succinylcholine due to hyperkalemia risk\n\n"
            + "When NOT to use vecuronium:##\n\n"
            + "• Emergent RSI — too slow! Use rocuronium or succinylcholine\n"
            + "• Can't intubate scenario — can't reverse with sugammadex (rocuronium can be)",
            contraindiction: "##Absolute:##\n\n"
            + "• Hypersensitivity to vecuronium\n\n"
            + "##Caution:##\n\n"
            + "• Hepatic failure (prolonged duration — metabolized by liver)\n"
            + "• Renal failure (active metabolites accumulate)\n"
            + "• Myasthenia gravis (extreme sensitivity — use much lower doses)\n"
            + "• Prolonged ICU paralysis (risk of critical illness myopathy)\n\n"
            + "##Important:## Never give a paralytic without adequate sedation! The patient must be unconscious first. Paralytics cause awareness under anesthesia if given alone.",
            onSet: "2-3 min (too slow for RSI)",
            halfLife: "1.5 hours (longer in hepatic/renal failure)",
            duration: "45-65 minutes (can be 90+ minutes in liver/kidney disease)",
            absorbtion: "IV only",
            distribution: "Extracellular fluid (does not cross BBB)",
            metaBolism: "Hepatic (to active metabolites)\n\n"
            + "##Active metabolites can prolong paralysis in liver failure##",
            excretion: "Bile (40-50%) and Urine (30%)\n\n"
            + "##Dose adjust in renal/hepatic failure##",
            pregnancyExplanation: "##Pregnancy Category C:## Use with caution. Limited data. Ensure adequate sedation.",
            criticalPearls: "##Must be Reconstituted!##\n\n"
            + "• Comes as a powder (unlike rocuronium which is ready-to-use)\n"
            + "• Reconstitute with 10 mL sterile water → 1 mg/mL\n"
            + "• This takes time — NOT ideal for emergent RSI\n\n"
            + "##Not Preferred for RSI##\n\n"
            + "• Onset: 2-3 minutes (too slow for crash airway)\n"
            + "• Use rocuronium (60-90 sec) or succinylcholine (45-60 sec) instead\n\n"
            + "##Hemodynamically Neutral##\n\n"
            + "• No tachycardia\n"
            + "• No hypotension\n"
            + "• No histamine release\n"
            + "• Perfect for unstable patients when you have time\n\n"
            + "##Reversal Options:##\n\n"
            + "• Neostigmine + glycopyrrolate (traditional)\n"
            + "• Sugammadex does NOT work well for vecuronium (only rocuronium)\n\n"
            + "##ICU Paralysis Monitoring:##\n\n"
            + "• Use train-of-four (TOF) monitoring\n"
            + "• Goal: 1-2 twitches out of 4\n"
            + "• Daily sedation holidays to assess need\n"
            + "• Avoid prolonged use (>48-72 hours) unless absolutely necessary\n\n"
            + "##Vecuronium vs. Rocuronium:##\n\n"
            + "| Feature | Vecuronium | Rocuronium |\n"
            + "|---------|------------|------------|\n"
            + "| ##Onset## | 2-3 min | 60-90 sec |\n"
            + "| ##Duration## | 45-65 min | 30-60 min |\n"
            + "| ##Hemodynamics## | Neutral | Mild ↑HR |\n"
            + "| ##Preparation## | Powder (reconstitute) | Ready-to-use |\n"
            + "| ##Reversal## | Neostigmine | Sugammadex |\n"
            + "| ##RSI use## | ❌ Too slow | ✅ Yes |\n\n"
            + "##The Clinical Takeaway:##\n\n"
            + "Vecuronium is the hemodynamically neutral paralytic for controlled intubations and ICU paralysis. It's NOT for emergent RSI (too slow — use rocuronium instead). Perfect for unstable patients when you have time, but requires reconstitution and can't be reversed with sugammadex. Always ensure adequate sedation before giving any paralytic.\n\n"
            + "##High-yield point:## Vecuronium = neutral hemodynamics but slow onset. Rocuronium = fast onset but mild tachycardia. For RSI in unstable patients, rocuronium's speed usually outweighs its mild HR increase."
        ),
        
        // ══════════════════════════════════════════════════════════════════
        // MARK: - ANTIBIOTICS (New Additions for Masterclass)
        // ══════════════════════════════════════════════════════════════════
        
        // 64. Ampicillin-Sulbactam (Unasyn) - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Ampicillin-Sulbactam",
            brandName: "Unasyn",
            mechansim: "Penicillin + β-lactamase inhibitor combination.\n\n"
            + "##The Mental Model:##\n"
            + "Think of this as a team effort: ampicillin kills bacteria by destroying their cell walls, while sulbactam protects ampicillin from being destroyed by bacterial enzymes.\n\n"
            + "##Coverage:##\n"
            + "• Gram-positives (Strep, some Staph)\n"
            + "• Anaerobes (mouth, aspiration flora)\n"
            + "• Some gram-negatives\n\n"
            + "##Key limitation:## Does NOT cover Pseudomonas.",
            adverseEffects: "##Common:## Diarrhea, rash, nausea.\n\n"
            + "##Serious:## Hypersensitivity reactions, C. difficile colitis.\n\n"
            + "##Watch for:## GI upset is common. Rash may develop, especially in patients with viral illness.",
            dose: "Adult: 3 g x1 load, then 1.5–3 g IV q6–12h.\nPediatric: 300 mg/kg/day IV ÷ q6h (≤ adult dose).",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Penicillin + β-lactamase inhibitor.\n\n"
            + "This is your go-to for aspiration pneumonia and ENT infections where you need anaerobic coverage but don't need to reach for the big guns.",
            indications: "Classic uses:\n"
            + "• Aspiration pneumonia — covers mouth flora and anaerobes\n"
            + "• ENT infections (sinusitis, otitis, dental)\n"
            + "• Some intra-abdominal infections (less severe)\n"
            + "• Skin and soft tissue infections\n\n"
            + "When to reach for it:## Community-acquired infections with anaerobic concern, especially aspiration events.",
            contraindiction: "Absolute: Penicillin hypersensitivity.\n\n"
            + "##Important limitation:## No Pseudomonas coverage. If hospital-acquired or ICU infection, you need cefepime, Zosyn, or meropenem instead.",
            onSet: "Rapid (IV)",
            halfLife: "1-2 hours",
            duration: "6-8 hours",
            absorbtion: "IV, IM",
            distribution: "Wide tissue penetration.",
            metaBolism: "Minimal hepatic.",
            excretion: "Renal — adjust in renal impairment.",
            pregnancyExplanation: "Generally considered safe in pregnancy. Commonly used for GBS prophylaxis.",
            criticalPearls: "##Aspiration Coverage Champion:##\n\n"
            + "• Perfect for community aspiration pneumonia\n"
            + "• Covers mouth flora + anaerobes without Pseudomonas coverage\n\n"
            + "##Critical limitation:##\n\n"
            + "• No Pseudomonas = not for HAP/VAP\n"
            + "• If hospital-acquired, use cefepime or Zosyn instead\n\n"
            + "##Dosing tip:##\n\n"
            + "• The '3 g' is the combination (2 g ampicillin + 1 g sulbactam)"
        ),
        
        // 65. Cefazolin (Ancef) - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Cefazolin",
            brandName: "Ancef",
            mechansim: "1st-generation cephalosporin that inhibits bacterial cell wall synthesis.\n\n"
            + "##The Mental Model:##\n\n"
            + "Cefazolin is the gram-positive workhorse — excellent against skin flora (Staph and Strep) but minimal gram-negative or anaerobic activity.\n\n"
            + "##Key strength:## Best MSSA drug we have. If the organism is methicillin-sensitive Staph aureus, cefazolin is often the first choice.",
            adverseEffects: "##Common:## Injection site reactions, diarrhea, rash.\n\n"
            + "##Serious:## Hypersensitivity, rare anaphylaxis.\n\n"
            + "##Good news:## Very well tolerated. One of the safest antibiotics in our arsenal.",
            dose: "Adult: 2 g x1 load, then 1–2 g IV/IM q8–12h (3 g if >120 kg).\nPediatric: 25–33 mg/kg IV q8–12h (≤ adult dose).",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "1st-generation cephalosporin.\n\n"
            + "The foundation drug for skin infections and surgical prophylaxis.",
            indications: "##Classic uses:##\n\n"
            + "• Skin and soft tissue infections (cellulitis, abscess)\n"
            + "• Surgical prophylaxis (especially orthopedic hardware)\n"
            + "• MSSA infections (bacteremia, bone/joint)\n"
            + "• Pre-operative prophylaxis\n\n"
            + "When to reach for it:## Non-purulent cellulitis without MRSA risk. Orthopedic surgery prophylaxis. Known MSSA infection.",
            contraindiction: "##Absolute:## Severe cephalosporin or penicillin hypersensitivity (anaphylaxis).\n\n"
            + "##Limitations:##\n\n"
            + "• No MRSA coverage\n"
            + "• Minimal gram-negative activity\n"
            + "• No anaerobic coverage\n"
            + "• No Pseudomonas",
            onSet: "Rapid (IV)",
            halfLife: "1.5-2 hours",
            duration: "6-8 hours",
            absorbtion: "IV, IM",
            distribution: "Good tissue penetration, including bone.",
            metaBolism: "Not metabolized.",
            excretion: "Renal — adjust in severe renal impairment.",
            pregnancyExplanation: "Safe in pregnancy. Used for surgical prophylaxis in cesarean section.",
            criticalPearls: "##The MSSA Drug##\n\n"
            + "• If it's methicillin-sensitive Staph, this is often the best choice.\n"
            + "• Excellent for surgical prophylaxis, especially orthopedic.\n\n"
            + "##Remember:## Does NOT cover MRSA — if MRSA is possible, add vancomycin.\n\n"
            + "##Weight-based dosing:## 3 g if patient >120 kg.\n\n"
            + "##High-yield point:## Cefazolin is superior to vancomycin for MSSA infections — faster bactericidal activity, lower mortality in MSSA bacteremia. Always de-escalate from vanc to cefazolin when cultures show MSSA."
        ),
        
        // 66. Ceftriaxone (Rocephin) - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Ceftriaxone",
            brandName: "Rocephin",
            mechansim: "3rd-generation cephalosporin that inhibits bacterial cell wall synthesis.\n\n"
            + "##The Mental Model:##\n\n"
            + "Ceftriaxone is the gram-negative killer for community infections — strong against Enterobacterales (E. coli, Klebsiella) with some gram-positive activity, but no Pseudomonas.\n\n"
            + "##Key strength:## Once-daily dosing, broad coverage, excellent CNS penetration (meningitis dose = 2 g q12h).",
            adverseEffects: "##Common:## Diarrhea, rash, injection site reactions.\n\n"
            + "##Serious:## Biliary sludge/pseudolithiasis, hemolytic anemia (rare).\n\n"
            + "##Caution:## Avoid with calcium-containing IV solutions (precipitation risk, especially in neonates).",
            dose: "Adult: 2 g x1 load, then 1–2 g IV/IM q12–24h.\nMeningitis: 2 g IV q12h.\nPediatric: 50–75 mg/kg IV/IM q12–24h (≤ adult dose).",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "3rd-generation cephalosporin.\n\n"
            + "The most commonly used antibiotic in emergency and critical care for community infections.",
            indications: "##Classic uses:##\n\n"
            + "• Community-acquired pneumonia (CAP) — with doxycycline or azithromycin\n"
            + "• Meningitis — 2 g q12h\n"
            + "• Pyelonephritis / UTI\n"
            + "• Intra-abdominal — with metronidazole for anaerobes\n"
            + "• Gonorrhea, Lyme disease\n\n"
            + "When to reach for it:## Community-acquired infection with gram-negative concern, no Pseudomonas risk.",
            contraindiction: "##Absolute:## Severe cephalosporin hypersensitivity.\n\n"
            + "##Critical limitation:## No Pseudomonas coverage. If hospital-acquired, recent antibiotics, or ICU patient — you need cefepime, Zosyn, or meropenem.\n\n"
            + "##Avoid:## Do not mix with calcium-containing solutions.",
            onSet: "Rapid (IV/IM)",
            halfLife: "6-9 hours (allows once-daily dosing)",
            duration: "12-24 hours",
            absorbtion: "IV, IM",
            distribution: "Excellent — including CSF, bone, lung.",
            metaBolism: "Not metabolized.",
            excretion: "Renal and biliary.",
            pregnancyExplanation: "Safe in pregnancy. Commonly used for infections during pregnancy.",
            criticalPearls: "##Community Infection Workhorse##\n\n"
            + "• Perfect for CAP, meningitis, pyelonephritis, intra-abdominal (+ metro).\n"
            + "• Once-daily dosing makes it practical.\n\n"
            + "##Critical gap:## No Pseudomonas — don't use for HAP/VAP.\n\n"
            + "##Meningitis dosing:## 2 g IV q12h (double the standard dose).\n\n"
            + "##Partner drugs:## Add metronidazole for belly coverage. Add doxycycline/azithro for CAP atypicals.\n\n"
            + "##High-yield point:## Ceftriaxone has dual excretion (renal + biliary), so no dose adjustment needed for renal failure (but watch for biliary sludge). This makes it a safe choice in AKI."
        ),
        
        // 67. Ciprofloxacin (Cipro) - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Ciprofloxacin",
            brandName: "Cipro",
            mechansim: "Fluoroquinolone that inhibits bacterial DNA gyrase and topoisomerase IV.\n\n"
            + "##The Mental Model:##\n"
            + "Ciprofloxacin is a gram-negative specialist with Pseudomonas activity. It's the fluoroquinolone you use when you need urinary, abdominal, or resistant gram-negative coverage.\n\n"
            + "##Key difference from levofloxacin##: Cipro is stronger against gram-negatives (including Pseudomonas) but weaker against gram-positives (Strep pneumo).",
            adverseEffects: "##Common:## Nausea, diarrhea, headache.\n\n"
            + "##Serious## (Black Box Warnings):\n"
            + "• Tendinopathy/tendon rupture — especially in elderly, on steroids, renal failure\n"
            + "• QT prolongation\n"
            + "• CNS effects — confusion, seizures\n"
            + "• Aortic dissection/aneurysm risk\n\n"
            + "##Caution:## Avoid in myasthenia gravis (can worsen weakness).",
            dose: "Adult: 400 mg IV q8–12h or 500–750 mg PO q12h.\nPediatric: Generally avoided due to cartilage concerns; consult specialist.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Fluoroquinolone antibiotic.\n\n"
            + "Concentration-dependent killer — works based on peak levels above MIC.",
            indications: "Classic uses:\n"
            + "• Pyelonephritis / complicated UTI\n"
            + "• Intra-abdominal infections — with metronidazole for anaerobes\n"
            + "• Pseudomonas infections (when other options limited)\n"
            + "• Severe penicillin allergy alternative\n\n"
            + "When to reach for it:## Gram-negative UTI, possible Pseudomonas, and patient has severe beta-lactam allergy.",
            contraindiction: "Absolute: Hypersensitivity to fluoroquinolones.\n\n"
            + "##Strong cautions:##\n"
            + "• Myasthenia gravis\n"
            + "• Prior tendon rupture on FQ\n"
            + "• QT prolongation\n"
            + "• Elderly on steroids\n\n"
            + "##Not for:## Respiratory infections — levofloxacin is better for lung/Strep pneumo.",
            onSet: "Rapid (IV); 1-2 hours (PO)",
            halfLife: "4-6 hours",
            duration: "12 hours",
            absorbtion: "Excellent oral bioavailability (70–80%).",
            distribution: "Wide — including urine, prostate, lung.",
            metaBolism: "Hepatic (partial).",
            excretion: "Renal — adjust in renal impairment.",
            pregnancyExplanation: "Avoid in pregnancy due to potential cartilage effects on fetus.",
            criticalPearls: "##Gram-Negative Specialist:##\n\n"
            + "• Stronger against gram-negatives (including Pseudomonas) than levofloxacin\n"
            + "• Weaker against Strep pneumo — don't use for CAP\n\n"
            + "##Black Box Warnings:##\n\n"
            + "• Tendinopathy and tendon rupture\n"
            + "• Aortic dissection/aneurysm risk\n"
            + "• QT prolongation\n"
            + "• CNS effects (confusion, seizures)\n\n"
            + "##Key clinical tips:##\n\n"
            + "• ##Partner drug:## Add metronidazole for intra-abdominal anaerobes\n"
            + "• ##PO = IV:## Excellent oral bioavailability allows PO step-down\n"
            + "• Avoid in myasthenia gravis — can worsen weakness"
        ),
        
        // 68. Gentamicin (Garamycin) - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Gentamicin",
            brandName: "Garamycin",
            mechansim: "Aminoglycoside that binds to the 30S ribosomal subunit, causing misreading of mRNA and bacterial death.\n\n"
            + "##The Mental Model:##\n"
            + "Gentamicin is a gram-negative power punch — fast, potent, and concentration-dependent. Give a big dose, get a high peak, and let the post-antibiotic effect do the work.\n\n"
            + "##Key concept:## This is a synergy drug — often added to beta-lactams for severe sepsis or endocarditis to enhance killing.",
            adverseEffects: "Serious (dose-limiting):\n"
            + "• Nephrotoxicity — acute tubular necrosis, usually reversible\n"
            + "• Ototoxicity — vestibular and cochlear damage, may be permanent\n"
            + "• Neuromuscular blockade (rare, with high doses)\n\n"
            + "##Monitoring:## Trough levels and creatinine. Keep troughs <1 mcg/mL.",
            dose: "Adult: 5 mg/kg IV q24h (once-daily extended interval dosing).\nPediatric: 2–2.5 mg/kg IV/IM q8h; Neonates: 4–5 mg/kg IV q24–48h.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.D),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.D),
            DrugClass: "Aminoglycoside antibiotic.\n\n"
            + "Concentration-dependent killer — efficacy tied to Cmax/MIC ratio. Prefer once-daily dosing.",
            indications: "Classic uses:\n"
            + "• Severe gram-negative sepsis — as add-on therapy\n"
            + "• Synergy for endocarditis — with beta-lactam\n"
            + "• Open fractures / severe trauma\n"
            + "• Intra-abdominal sepsis — as part of combination therapy\n\n"
            + "When to reach for it:## Critically ill with severe gram-negative infection. Need synergy. Open traumatic wound.",
            contraindiction: "Relative: Pre-existing renal impairment, hearing loss.\n\n"
            + "##Caution:## Avoid prolonged courses. Do not use as monotherapy for most infections.\n\n"
            + "##Drug interactions:## Avoid concurrent nephrotoxins (vancomycin, NSAIDs, contrast).",
            onSet: "Rapid (IV) — peak within 30-60 min",
            halfLife: "2-3 hours (prolonged in renal failure)",
            duration: "Concentration-dependent; post-antibiotic effect lasts hours",
            absorbtion: "IV, IM only (not absorbed orally)",
            distribution: "Poor tissue penetration; stays in extracellular fluid.",
            metaBolism: "Not metabolized.",
            excretion: "Renal — requires dose adjustment in renal impairment.",
            pregnancyExplanation: "Avoid in pregnancy — risk of fetal ototoxicity (Category D).",
            criticalPearls: "##Gram-Negative Power Punch:##\n\n"
            + "• Once-daily dosing preferred for efficacy and reduced toxicity\n"
            + "• Monitor troughs (<1 mcg/mL) and creatinine\n\n"
            + "##Synergy drug:##\n\n"
            + "• Often added to beta-lactam for severe infections\n"
            + "• Enhances killing in endocarditis and sepsis\n\n"
            + "##Two toxicities to remember:##\n\n"
            + "• ##Nephrotoxicity## — usually reversible\n"
            + "• ##Ototoxicity## — may be permanent\n\n"
            + "##Don't forget:##\n\n"
            + "• Avoid in pregnancy (Category D — fetal ototoxicity risk)"
        ),
        
        // 69. Levofloxacin (Levaquin) - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Levofloxacin",
            brandName: "Levaquin",
            mechansim: "Fluoroquinolone that inhibits bacterial DNA gyrase and topoisomerase IV.\n\n"
            + "##The Mental Model:##\n"
            + "Levofloxacin is the respiratory fluoroquinolone — excellent against Strep pneumoniae and atypicals (Legionella, Mycoplasma, Chlamydia), plus gram-negatives and some Pseudomonas.\n\n"
            + "##Key difference from ciprofloxacin##: Levofloxacin is better for lung and respiratory infections; cipro is better for pure gram-negative (urinary, abdominal).",
            adverseEffects: "##Common:## Nausea, diarrhea, headache, insomnia.\n\n"
            + "##Serious## (Black Box Warnings):\n"
            + "• Tendinopathy/tendon rupture — especially elderly, steroids, renal failure\n"
            + "• QT prolongation\n"
            + "• CNS effects — confusion, seizures, psychosis\n"
            + "• Aortic dissection/aneurysm risk\n"
            + "• Peripheral neuropathy\n\n"
            + "##Caution:## Avoid in myasthenia gravis.",
            dose: "Adult: 750 mg IV/PO q24h (severe); 500 mg q24h (moderate).\nPediatric: Generally avoided due to cartilage concerns.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Respiratory fluoroquinolone.\n\n"
            + "The fluoroquinolone of choice for pneumonia and respiratory infections.",
            indications: "Classic uses:\n"
            + "• Community-acquired pneumonia (CAP) — monotherapy covers Strep + atypicals\n"
            + "• Severe penicillin/cephalosporin allergy alternative\n"
            + "• Some UTI/pyelonephritis\n"
            + "• HAP/VAP in combination regimens\n\n"
            + "When to reach for it:## CAP with severe beta-lactam allergy. Need atypical coverage. Can't use ceftriaxone + azithro.",
            contraindiction: "Absolute: Hypersensitivity to fluoroquinolones.\n\n"
            + "##Strong cautions:##\n"
            + "• Myasthenia gravis\n"
            + "• Prior tendon rupture on FQ\n"
            + "• QT prolongation / concurrent QT-prolonging drugs\n"
            + "• Elderly on corticosteroids\n\n"
            + "##First-line warning##: FQs should not be first-line for uncomplicated UTI or mild infections.",
            onSet: "Rapid (IV); 1-2 hours (PO)",
            halfLife: "6-8 hours",
            duration: "24 hours",
            absorbtion: "Excellent oral bioavailability (~99%).",
            distribution: "Wide — lung, urine, prostate, bone.",
            metaBolism: "Minimal.",
            excretion: "Renal — adjust in renal impairment.",
            pregnancyExplanation: "Avoid in pregnancy due to potential cartilage effects on fetus.",
            criticalPearls: "##Respiratory Fluoroquinolone:##\n\n"
            + "• Covers Strep pneumo + atypicals + gram-negatives\n"
            + "• Can be CAP monotherapy (unlike ceftriaxone which needs a partner)\n\n"
            + "##Black Box Warnings:##\n\n"
            + "• Tendons, aorta, QT prolongation\n"
            + "• CNS effects, peripheral neuropathy\n\n"
            + "##Key clinical tips:##\n\n"
            + "• ##PO = IV:## 99% bioavailability — oral is as good as IV\n"
            + "• ##Stewardship:## Reserve for true indications; don't use for uncomplicated UTI"
        ),
        
        // 70. Metronidazole (Flagyl) - Enhanced Teaching Content
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Metronidazole",
            brandName: "Flagyl",
            mechansim: "Nitroimidazole that disrupts bacterial DNA synthesis after reduction by anaerobic enzymes.\n\n"
            + "##The Mental Model:##\n"
            + "Metronidazole is the anaerobe## assassin — it only works in low-oxygen environments where its mechanism can activate. That's why it's perfect for:\n"
            + "• Abscesses\n"
            + "• Bowel perforations\n"
            + "• Necrotic tissue\n"
            + "• C. difficile (PO only)\n\n"
            + "##Key concept:## Also covers protozoa (Giardia, Trichomonas, Entamoeba).",
            adverseEffects: "##Common:## Nausea, metallic taste, headache.\n\n"
            + "##Serious:##\n"
            + "• ##Disulfiram-like reaction## with alcohol (severe nausea/vomiting)\n"
            + "• ##Peripheral neuropathy## with prolonged use\n"
            + "• Seizures (high doses)\n\n"
            + "##Important:## Tell patients NO ALCOHOL during and 48-72h after therapy.",
            dose: "Adult: 500 mg IV/PO q6–8h.\nC. diff: 500 mg PO TID (with PO vancomycin for severe).\nPediatric: 7.5 mg/kg IV/PO q6h (≤ 500 mg).",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Nitroimidazole antibiotic/antiprotozoal.\n\n"
            + "The definitive anaerobic coverage drug. Partner it with ceftriaxone for intra-abdominal infections.",
            indications: "Classic uses:\n"
            + "• Intra-abdominal infections — with ceftriaxone for complete coverage\n"
            + "• C. difficile colitis — PO only (IV doesn't reach colon lumen well)\n"
            + "• Pelvic infections (PID, tubo-ovarian abscess)\n"
            + "• Brain abscess (crosses BBB well)\n"
            + "• Giardiasis, trichomoniasis, amebiasis\n\n"
            + "When to reach for it:## Whenever you need anaerobic coverage and aren't using Zosyn or meropenem.",
            contraindiction: "Absolute: Hypersensitivity. Concurrent alcohol (disulfiram reaction).\n\n"
            + "##Caution:##\n"
            + "• Prolonged therapy (>14 days) — neuropathy risk\n"
            + "• Seizure history (high doses)\n\n"
            + "##Drug interactions:## Warfarin (potentiates anticoagulation), lithium, disulfiram.",
            onSet: "Rapid (IV); 1-2 hours (PO)",
            halfLife: "6-8 hours",
            duration: "8 hours",
            absorbtion: "Excellent oral bioavailability (nearly 100%).",
            distribution: "Wide — including CSF, bone, abscess cavities.",
            metaBolism: "Hepatic.",
            excretion: "Renal (60-80%), some fecal.",
            pregnancyExplanation: "Safe in pregnancy. Commonly used for BV and trichomoniasis during pregnancy.",
            criticalPearls: "##Anaerobe Assassin:##\n\n"
            + "• Perfect partner for ceftriaxone in intra-abdominal sepsis\n"
            + "• PO for C. diff (IV doesn't work well for colonic infection)\n\n"
            + "##Alcohol warning:##\n\n"
            + "• Disulfiram-like reaction — must avoid alcohol during therapy\n"
            + "• Can cause severe nausea/vomiting with alcohol exposure\n\n"
            + "##Watch for neuropathy:##\n\n"
            + "• Peripheral neuropathy with prolonged courses (>2 weeks)\n\n"
            + "##Coverage reminder:##\n\n"
            + "• Anaerobes + protozoa — does NOT cover aerobes"
        ),
        
        // 71. Nicardipine (Cardene) - Antihypertensive Drip
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Nicardipine",
            brandName: "Cardene",
            mechansim: "Dihydropyridine calcium channel blocker that selectively blocks L-type calcium channels in vascular smooth muscle.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of nicardipine as the smooth, predictable BP-lowering drip. Unlike nipride (which drops BP instantly and can overshoot) or labetalol (which can cause reflex bradycardia), nicardipine gives you:\n"
            + "• Gradual, titratable BP reduction\n"
            + "• Preserved cerebral blood flow (doesn't steal)\n"
            + "• No reflex tachycardia issues\n\n"
            + "##How it works:##\n\n"
            + "• Blocks L-type Ca²⁺ channels in arterial smooth muscle\n"
            + "• Causes arterial vasodilation → Decreases SVR\n"
            + "• Minimal effect on cardiac conduction or contractility\n"
            + "• Maintains or increases cerebral blood flow\n\n"
            + "##Key point:## Nicardipine is the go-to antihypertensive for stroke (both ischemic and hemorrhagic) because it doesn't reduce cerebral perfusion like other agents can.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypotension (dose-related, titratable)\n"
            + "• Tachycardia (reflex, usually mild)\n"
            + "• Headache\n"
            + "• Nausea\n"
            + "• Peripheral edema\n\n"
            + "##Serious:##\n\n"
            + "• Severe hypotension if over-titrated\n"
            + "• Worsening angina in severe CAD (rare)\n\n"
            + "##Important:## Monitor for tachycardia — may need to add beta-blocker if HR becomes problematic.",
            dose: "##Infusion:##\n"
            + "• Start: 2.5-5 mg/hr\n"
            + "• Titrate: Increase by 2.5 mg/hr every 5-15 minutes\n"
            + "• Max: 15 mg/hr\n"
            + "• Maintenance: 3-15 mg/hr\n\n"
            + "##Concentration:## 25 mg/250 mL (0.1 mg/mL)\n\n"
            + "##Target:## Specific BP goal depends on indication (stroke vs. HTN emergency).",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Dihydropyridine calcium channel blocker. Antihypertensive.\n\n"
            + "First-line for hypertensive emergencies in stroke patients. Preferred over labetalol when reflex bradycardia is a concern.",
            indications: "##Primary Uses:##\n"
            + "• Hypertensive emergency\n"
            + "• Acute ischemic stroke (BP management)\n"
            + "• Intracerebral hemorrhage (ICH)\n"
            + "• Subarachnoid hemorrhage (cerebral vasospasm)\n"
            + "• Perioperative hypertension\n"
            + "• Aortic dissection (with beta-blocker first)\n\n"
            + "When to reach for it:## Whenever you need smooth, predictable BP control without affecting heart rate or cerebral perfusion.",
            contraindiction: "##Absolute:##\n"
            + "• Severe aortic stenosis\n"
            + "• Hypersensitivity\n\n"
            + "##Relative:##\n"
            + "• Advanced heart failure (negative inotrope)\n"
            + "• Severe coronary artery disease\n"
            + "• Concurrent beta-blocker use (monitor for excessive bradycardia)\n\n"
            + "##Important:## In aortic dissection, always give beta-blocker FIRST before nicardipine to prevent reflex tachycardia.",
            onSet: "5-15 minutes",
            halfLife: "40-60 minutes (initial), 8-14 hours (terminal)",
            duration: "Effect dissipates within 30-60 min of stopping infusion",
            absorbtion: "IV only for acute management.",
            distribution: "Highly protein bound (>95%).",
            metaBolism: "Hepatic (CYP3A4).",
            excretion: "Biliary (60%), renal (35%).",
            pregnancyExplanation: "Animal studies show fetal harm. Use only if benefits outweigh risks.",
            criticalPearls: "##Stroke-Friendly Antihypertensive:##\n\n"
            + "• Preserves cerebral blood flow — ideal for stroke patients\n"
            + "• Start at 5 mg/hr, titrate q5-15 min for rapid control\n\n"
            + "##Aortic Dissection Rule:##\n\n"
            + "• ALWAYS beta-blocker first, THEN nicardipine\n"
            + "• Prevents reflex tachycardia from worsening shear stress\n\n"
            + "##Compatibility tip:##\n\n"
            + "• Usually pre-mixed. Not compatible with Lactated Ringer's\n\n"
            + "##Transition planning:##\n\n"
            + "• Start oral antihypertensives 1 hour before stopping drip"
        ),
        
        // 72. Dexmedetomidine (Precedex) - Sedative Drip
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Dexmedetomidine",
            brandName: "Precedex",
            mechansim: "Highly selective alpha-2 adrenergic agonist that provides sedation without respiratory depression.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of dexmedetomidine as 'natural sleep' sedation. Unlike propofol or benzos which suppress the respiratory drive, dex works on the locus coeruleus (the brain's natural sleep center). Patients on dex:\n"
            + "• Are arousable (can follow commands even while sedated)\n"
            + "• Maintain airway reflexes\n"
            + "• Don't stop breathing\n\n"
            + "##How it works:##\n\n"
            + "• Binds alpha-2 receptors in locus coeruleus → Sedation\n"
            + "• Binds alpha-2 receptors in spinal cord → Analgesia\n"
            + "• Decreases sympathetic outflow → Bradycardia, hypotension\n"
            + "• Does NOT affect GABA → No respiratory depression\n\n"
            + "##Key point:## Dex is ideal for patients you want to extubate — they can be sedated but still breathe and protect their airway.",
            adverseEffects: "##Common:##\n\n"
            + "• Bradycardia (dose-dependent)\n"
            + "• Hypotension\n"
            + "• Dry mouth\n"
            + "• Nausea\n\n"
            + "##Serious:##\n\n"
            + "• Severe bradycardia (may need atropine/glycopyrrolate)\n"
            + "• Sinus arrest (rare, with bolus dosing)\n"
            + "• Transient hypertension (with loading dose)\n\n"
            + "##Important:## Avoid bolus dosing in hemodynamically unstable patients. The loading dose can cause significant bradycardia.",
            dose: "##Loading (optional):## 1 mcg/kg over 10 minutes\n"
            + "##Infusion:## 0.2-0.7 mcg/kg/hr (up to 1.5 mcg/kg/hr off-label)\n\n"
            + "##Concentration:## 4 mcg/mL (200 mcg/50 mL) or 200 mcg/50 mL\n\n"
            + "##Titration:## Adjust q15-30 min to target RASS score.\n\n"
            + "##Note:## Can skip loading dose in hypotensive or bradycardic patients.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Alpha-2 adrenergic agonist. Sedative.\n\n"
            + "The 'cooperative sedation' drug. Ideal for awake intubation, sedation weaning, and delirium-prone patients.",
            indications: "##ICU Sedation:##\n"
            + "• Mechanically ventilated patients (especially during weaning)\n"
            + "• Delirium prevention/treatment (reduces incidence vs. benzos)\n"
            + "• Alcohol/benzo withdrawal adjunct\n\n"
            + "##Procedural Sedation:##\n"
            + "• Awake craniotomy\n"
            + "• Awake fiberoptic intubation\n"
            + "• Cardiac catheterization\n\n"
            + "When to reach for it:## Patient needs sedation but you want them arousable and breathing.",
            contraindiction: "##Absolute:##\n"
            + "• Heart block (without pacemaker)\n"
            + "• Severe bradycardia\n\n"
            + "##Relative:##\n"
            + "• Hypotension\n"
            + "• Hepatic impairment (reduce dose)\n"
            + "• Concurrent beta-blockers/digoxin (additive bradycardia)\n\n"
            + "##Caution:## Not appropriate for deep sedation or paralyzed patients who need complete unconsciousness.",
            onSet: "15 minutes (no loading), 5-10 minutes (with loading)",
            halfLife: "2-3 hours",
            duration: "Sedation wears off within 1-2 hours of stopping",
            absorbtion: "IV only.",
            distribution: "94% protein bound.",
            metaBolism: "Hepatic (glucuronidation and CYP2A6).",
            excretion: "Renal (95% as metabolites).",
            pregnancyExplanation: "Limited data. Use only if clearly needed.",
            criticalPearls: "##Cooperative Sedation:##\n\n"
            + "• Patients are arousable — can follow commands even while sedated\n"
            + "• No respiratory depression — ideal for weaning or extubation\n\n"
            + "##Delirium Prevention:##\n\n"
            + "• Reduces delirium incidence compared to benzos\n"
            + "• First-line for ICU agitation if hemodynamically stable\n\n"
            + "##Watch the Heart Rate:##\n\n"
            + "• Bradycardia is common — avoid loading dose if HR <60\n"
            + "• Have atropine ready\n\n"
            + "##Bonus use:##\n\n"
            + "• Great for post-operative shivering (off-label)"
        ),
        
        // 73. Esmolol (Brevibloc) - Ultra-Short Beta Blocker
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Esmolol",
            brandName: "Brevibloc",
            mechansim: "Ultra-short-acting cardioselective beta-1 blocker.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of esmolol as the beta-blocker with a kill switch. If the patient crashes, the effect is gone in 9 minutes. This makes it perfect for:\n"
            + "• Titrating rate control\n"
            + "• Testing beta-blocker tolerance\n"
            + "• Situations where you might need to reverse course quickly\n\n"
            + "##How it works:##\n\n"
            + "• Selective beta-1 blockade → Decreases HR, contractility, AV conduction\n"
            + "• Minimal beta-2 effect at low doses (bronchospasm less likely)\n"
            + "• Metabolized by RBC esterases (not liver/kidney)\n"
            + "• Half-life: 9 minutes\n\n"
            + "##Key point:## Esmolol's metabolism is independent of hepatic/renal function, making it safe in multiorgan failure.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypotension (dose-related)\n"
            + "• Bradycardia\n"
            + "• Dizziness\n"
            + "• Nausea\n\n"
            + "##Serious:##\n\n"
            + "• Severe bradycardia (may need glucagon/atropine)\n"
            + "• Heart block\n"
            + "• Bronchospasm (less common than non-selective)\n"
            + "• Heart failure exacerbation\n\n"
            + "##Important:## Effects resolve within 20-30 minutes of stopping infusion.",
            dose: "##Loading:## 500 mcg/kg over 1 minute\n"
            + "##Infusion:## 50-200 mcg/kg/min\n"
            + "##Titration:## Can repeat loading dose and increase infusion by 50 mcg/kg/min q4 min\n\n"
            + "##Max:## 200 mcg/kg/min (some protocols go to 300)\n\n"
            + "##Concentration:## Usually premixed 10 mg/mL or 20 mg/mL",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Beta-1 selective adrenergic blocker. Class II antiarrhythmic.\n\n"
            + "The titratable, reversible beta-blocker. Use when you're not sure how the patient will tolerate rate control.",
            indications: "##Primary Uses:##\n"
            + "• SVT (rate control)\n"
            + "• Atrial fibrillation/flutter (acute rate control)\n"
            + "• Perioperative tachycardia/hypertension\n"
            + "• Aortic dissection (first-line for rate control)\n"
            + "• Thyroid storm\n"
            + "• Pheochromocytoma (after alpha blockade)\n\n"
            + "When to reach for it:## Acute rate control when you want reversibility.",
            contraindiction: "##Absolute:##\n"
            + "• Severe bradycardia or heart block (without pacemaker)\n"
            + "• Cardiogenic shock\n"
            + "• Decompensated heart failure\n"
            + "• Sick sinus syndrome\n\n"
            + "##Relative:##\n"
            + "• Asthma/COPD (may still trigger bronchospasm)\n"
            + "• Cocaine toxicity (avoid initially)\n"
            + "• Hypotension\n\n"
            + "##Important:## In aortic dissection, esmolol BEFORE vasodilators.",
            onSet: "60 seconds",
            halfLife: "9 minutes",
            duration: "10-30 minutes after stopping infusion",
            absorbtion: "IV only.",
            distribution: "Rapidly distributed.",
            metaBolism: "Hydrolyzed by RBC esterases (NOT hepatic/renal).",
            excretion: "Renal (inactive metabolites).",
            pregnancyExplanation: "May cause fetal bradycardia. Use only if benefits outweigh risks.",
            criticalPearls: "##The Reversible Beta-Blocker:##\n\n"
            + "• 9-minute half-life — if patient crashes, effect is gone quickly\n"
            + "• Metabolized by RBC esterases — safe in liver/kidney failure\n\n"
            + "##Aortic Dissection:##\n\n"
            + "• Beta-blocker FIRST (target HR <60), THEN vasodilator\n"
            + "• Prevents reflex tachycardia from worsening shear stress\n\n"
            + "##SVT Algorithm:##\n\n"
            + "• Esmolol is an alternative to diltiazem/adenosine\n\n"
            + "##Incompatibility warning:##\n\n"
            + "• Don't mix with sodium bicarbonate"
        ),
        
        // 74. Milrinone (Primacor) - Inotrope/Vasodilator
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Milrinone",
            brandName: "Primacor",
            mechansim: "Phosphodiesterase-3 (PDE-3) inhibitor that increases cardiac contractility and causes vasodilation.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of milrinone as the 'inodilator' — it strengthens the heart AND opens up the blood vessels. Unlike dobutamine (which works through beta receptors), milrinone bypasses receptors entirely. This means:\n"
            + "• Works even when beta receptors are downregulated (chronic CHF)\n"
            + "• Works even on beta-blockers\n\n"
            + "##How it works:##\n\n"
            + "• Inhibits PDE-3 → Increases intracellular cAMP\n"
            + "• In heart: Increased Ca²⁺ → Increased contractility (inotropy)\n"
            + "• In vessels: Smooth muscle relaxation → Vasodilation\n"
            + "• Net effect: ↑ Cardiac output, ↓ SVR, ↓ Preload\n\n"
            + "##Key point:## Milrinone causes significant vasodilation — patients may need volume or a vasopressor to maintain MAP.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypotension (vasodilation > inotropy initially)\n"
            + "• Arrhythmias (ventricular ectopy, VT)\n"
            + "• Headache\n\n"
            + "##Serious:##\n\n"
            + "• Sustained ventricular arrhythmias\n"
            + "• Hypotension requiring vasopressor support\n"
            + "• Thrombocytopenia\n\n"
            + "##Important:## Monitor potassium — hypokalemia increases arrhythmia risk.",
            dose: "##Loading (optional):## 50 mcg/kg over 10 minutes\n"
            + "##Infusion:## 0.375-0.75 mcg/kg/min\n\n"
            + "##Concentration:## 200 mcg/mL (40 mg/200 mL) or premixed\n\n"
            + "##Renal adjustment:## Reduce dose in renal impairment (drug accumulates).\n\n"
            + "##Note:## Often skip loading dose to avoid hypotension.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Phosphodiesterase-3 inhibitor. Inotrope and vasodilator.\n\n"
            + "The 'inodilator' — increases contractility while decreasing afterload. Ideal for patients on beta-blockers or with downregulated beta receptors.",
            indications: "##Primary Uses:##\n"
            + "• Acute decompensated heart failure (ADHF)\n"
            + "• Cardiogenic shock (with vasopressor support)\n"
            + "• Post-cardiac surgery low output syndrome\n"
            + "• Bridge to transplant/LVAD\n"
            + "• Pulmonary hypertension (reduces PVR)\n\n"
            + "When to reach for it:## Heart failure patient on beta-blockers who needs inotropic support.",
            contraindiction: "##Absolute:##\n"
            + "• Severe aortic/pulmonic stenosis (fixed obstruction)\n"
            + "• Hypertrophic cardiomyopathy with outflow obstruction\n\n"
            + "##Relative:##\n"
            + "• Hypotension (may need vasopressor)\n"
            + "• Ventricular arrhythmias\n"
            + "• Severe renal impairment (reduce dose)\n\n"
            + "##Important:## Not for long-term use — increases mortality in chronic CHF.",
            onSet: "5-15 minutes",
            halfLife: "2.3 hours (prolonged in renal failure)",
            duration: "3-6 hours after stopping infusion",
            absorbtion: "IV only.",
            distribution: "70% protein bound.",
            metaBolism: "Minimal hepatic metabolism.",
            excretion: "Primarily renal (80-90% unchanged).",
            pregnancyExplanation: "Limited data. Use only if clearly needed.",
            criticalPearls: "##The Inodilator:##\n\n"
            + "• Works even on beta-blockers — bypasses beta receptors\n"
            + "• Increases contractility AND decreases afterload\n\n"
            + "##Hypotension Warning:##\n\n"
            + "• Vasodilation can cause significant hypotension\n"
            + "• Often need norepinephrine or vasopressin for MAP support\n\n"
            + "##Renal Dosing:##\n\n"
            + "• Reduce in CKD — drug accumulates\n\n"
            + "##Watch for arrhythmias:##\n\n"
            + "• Monitor potassium closely — hypokalemia increases VT risk"
        ),
        
        // 75. Propofol (Diprivan) - Sedative Hypnotic
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Propofol",
            brandName: "Diprivan",
            mechansim: "Potent, lipid-emulsified sedative-hypnotic that enhances GABA-mediated inhibition.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of propofol as the fast on/fast off sedative. It redistributes so quickly that patients wake up within minutes of stopping. This makes it ideal for:\n"
            + "• Titrating sedation depth\n"
            + "• Daily wake-up tests\n"
            + "• Rapid neurological assessment\n\n"
            + "##How it works:##\n\n"
            + "• Potentiates GABA-A receptor activity → CNS depression\n"
            + "• Rapid redistribution from brain to fat tissue\n"
            + "• No analgesic properties — must combine with opioid for pain\n\n"
            + "##Key point:## Propofol causes hypotension and respiratory depression — only use in intubated patients or with airway control.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypotension (dose-dependent)\n"
            + "• Respiratory depression/apnea\n"
            + "• Bradycardia\n"
            + "• Pain on injection (peripheral IV)\n"
            + "• Hypertriglyceridemia\n\n"
            + "##Serious:##\n\n"
            + "• Propofol Infusion Syndrome (PRIS) — rare but fatal\n"
            + "• Severe hypotension\n"
            + "• Pancreatitis (with prolonged use)\n\n"
            + "##PRIS Warning:## Risk increases with doses >5 mg/kg/hr for >48 hours. Monitor for metabolic acidosis, rhabdomyolysis, hyperkalemia, arrhythmias.",
            dose: "##Induction:## 1-2.5 mg/kg IV push\n"
            + "##Infusion:## 5-50 mcg/kg/min (0.3-3 mg/kg/hr)\n"
            + "##Max:## 50-80 mcg/kg/min (PRIS risk increases above this)\n\n"
            + "##Concentration:## 10 mg/mL\n\n"
            + "##Lipid content:## 0.1 g fat/mL — count in TPN calculations.\n\n"
            + "##Titration:## Adjust q5-10 min to target RASS score.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.B),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.B),
            DrugClass: "Sedative-hypnotic. Alkylphenol derivative.\n\n"
            + "The fast-on/fast-off sedative. Ideal for when you need rapid awakening for neurological assessment.",
            indications: "##ICU Sedation:##\n"
            + "• Mechanically ventilated patients\n"
            + "• Status epilepticus (refractory)\n"
            + "• Intracranial pressure control\n\n"
            + "##Procedural Sedation:##\n"
            + "• RSI induction agent\n"
            + "• Cardioversion\n"
            + "• Bronchoscopy, endoscopy\n\n"
            + "When to reach for it:## Need deep sedation with rapid wake-up capability.",
            contraindiction: "##Absolute:##\n"
            + "• Egg or soy allergy (lipid emulsion)\n"
            + "• Severe hypovolemia/shock\n\n"
            + "##Relative:##\n"
            + "• Hypotension\n"
            + "• Elderly (reduce dose)\n"
            + "• Pancreatitis history\n"
            + "• Hyperlipidemia\n\n"
            + "##Important:## Change tubing every 12 hours — infection risk from lipid medium.",
            onSet: "30-45 seconds",
            halfLife: "Initial: 2-8 minutes. Terminal: 4-12 hours",
            duration: "5-10 minutes (single dose), longer after prolonged infusion",
            absorbtion: "IV only.",
            distribution: "Highly lipophilic. Rapid redistribution.",
            metaBolism: "Hepatic (glucuronidation).",
            excretion: "Renal (88% as metabolites).",
            pregnancyExplanation: "Crosses placenta but no teratogenic effects shown. Use caution.",
            criticalPearls: "##Fast On, Fast Off:##\n\n"
            + "• Wake-up within minutes of stopping — ideal for neuro checks\n"
            + "• No analgesia — always pair with opioid\n\n"
            + "##PRIS (Propofol Infusion Syndrome):##\n\n"
            + "• Risk: >5 mg/kg/hr for >48 hours\n"
            + "• Signs: Metabolic acidosis, rhabdo, hyperK, cardiac failure\n"
            + "• Prevention: Keep dose <4 mg/kg/hr when possible\n\n"
            + "##Lipid Load:##\n\n"
            + "• 1.1 kcal/mL — count in nutrition calculations\n\n"
            + "##Infection Risk:##\n\n"
            + "• Change tubing q12h — lipid is bacterial growth medium"
        ),
        
        // 76. Nitroprusside (Nipride) - Vasodilator
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Nitroprusside",
            brandName: "Nipride",
            mechansim: "Direct-acting arterial and venous vasodilator that releases nitric oxide.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of nitroprusside as the most powerful BP-lowering agent — it works instantly and can drop BP dramatically. It dilates BOTH arteries AND veins:\n"
            + "• Arterial dilation → Decreased SVR → Lower BP\n"
            + "• Venous dilation → Decreased preload → Helpful in CHF\n\n"
            + "##How it works:##\n\n"
            + "• Releases nitric oxide (NO) in vascular smooth muscle\n"
            + "• NO activates guanylate cyclase → Increases cGMP\n"
            + "• cGMP causes smooth muscle relaxation\n"
            + "• Effect is nearly instantaneous (seconds)\n\n"
            + "##Key point:## Nitroprusside is metabolized to cyanide — monitor for toxicity with prolonged use or high doses.",
            adverseEffects: "##Common:##\n\n"
            + "• Hypotension (can be profound)\n"
            + "• Nausea\n"
            + "• Headache\n"
            + "• Tachycardia (reflex)\n\n"
            + "##Serious:##\n\n"
            + "• Cyanide toxicity (metabolic acidosis, confusion, seizures)\n"
            + "• Thiocyanate toxicity (with prolonged use/renal failure)\n"
            + "• Methemoglobinemia\n"
            + "• Coronary steal in CAD\n\n"
            + "##Warning:## If metabolic acidosis develops during infusion, suspect cyanide toxicity.",
            dose: "##Infusion:## 0.25-10 mcg/kg/min\n"
            + "##Start:## 0.3-0.5 mcg/kg/min\n"
            + "##Max:## 10 mcg/kg/min (cyanide risk increases above 2 mcg/kg/min for >10 min)\n\n"
            + "##Concentration:## 50 mg/250 mL (200 mcg/mL)\n\n"
            + "##Light-sensitive:## Wrap in foil or use amber tubing.\n\n"
            + "##Cyanide antidote:## Have sodium thiosulfate available.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Direct-acting vasodilator. Antihypertensive.\n\n"
            + "The most potent IV antihypertensive — use when you need immediate, dramatic BP reduction.",
            indications: "##Primary Uses:##\n"
            + "• Hypertensive emergency (especially with acute heart failure)\n"
            + "• Aortic dissection (with beta-blocker first)\n"
            + "• Controlled hypotension during surgery\n"
            + "• Acute decompensated heart failure (afterload reduction)\n\n"
            + "When to reach for it:## Need dramatic, immediate BP reduction. Less common now due to cyanide risk — nicardipine often preferred.",
            contraindiction: "##Absolute:##\n"
            + "• Inadequate cerebral perfusion\n"
            + "• Compensatory hypertension (coarctation, AV shunt)\n"
            + "• Tobacco amblyopia, Leber's optic atrophy\n\n"
            + "##Relative:##\n"
            + "• Hepatic impairment (cyanide metabolism)\n"
            + "• Renal impairment (thiocyanate excretion)\n"
            + "• Vitamin B12 deficiency\n\n"
            + "##Important:## In aortic dissection, beta-blocker FIRST to prevent reflex tachycardia.",
            onSet: "Seconds (almost instantaneous)",
            halfLife: "2 minutes (drug); cyanide metabolite is longer",
            duration: "1-10 minutes after stopping",
            absorbtion: "IV only.",
            distribution: "Vascular compartment.",
            metaBolism: "Non-enzymatic in blood → Releases cyanide → Liver converts to thiocyanate.",
            excretion: "Thiocyanate excreted by kidneys.",
            pregnancyExplanation: "Cyanide crosses placenta. Avoid unless life-threatening emergency.",
            criticalPearls: "##Fastest Acting Antihypertensive:##\n\n"
            + "• Works in seconds — arterial line required for monitoring\n"
            + "• Can overshoot — start low, titrate carefully\n\n"
            + "##Cyanide Toxicity:##\n\n"
            + "• Risk: >2 mcg/kg/min for >10 minutes, or >10 mcg/kg total\n"
            + "• Signs: Metabolic acidosis, confusion, tachyphylaxis\n"
            + "• Treatment: Stop infusion, sodium thiosulfate, hydroxocobalamin\n\n"
            + "##Light-Sensitive:##\n\n"
            + "• Wrap IV bag and tubing in foil\n\n"
            + "##Modern Alternative:##\n\n"
            + "• Nicardipine is often preferred — no cyanide risk"
        ),
        
        // 77. Angiotensin II (Giapreza) - Vasopressor
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Angiotensin II",
            brandName: "Giapreza",
            mechansim: "Synthetic human angiotensin II that causes direct vasoconstriction via AT1 receptors.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of angiotensin II as a vasopressor that works through a completely different pathway than catecholamines. When norepinephrine isn't enough, angiotensin II can:\n"
            + "• Provide additional vasoconstriction via AT1 receptors\n"
            + "• Allow catecholamine dose reduction\n"
            + "• Work even in catecholamine-refractory shock\n\n"
            + "##How it works:##\n\n"
            + "• Binds AT1 receptors on vascular smooth muscle\n"
            + "• Causes potent arterial vasoconstriction\n"
            + "• Stimulates aldosterone release (volume retention)\n"
            + "• Increases ADH secretion\n\n"
            + "##Key point:## Consider angiotensin II when the patient requires high-dose vasopressors (norepi >0.2 mcg/kg/min) despite adequate volume resuscitation.",
            adverseEffects: "##Common:##\n\n"
            + "• Thromboembolic events (arterial and venous)\n"
            + "• Tachycardia\n"
            + "• Peripheral ischemia\n"
            + "• Acidosis\n\n"
            + "##Serious:##\n\n"
            + "• Arterial and venous thrombosis (requires DVT prophylaxis)\n"
            + "• Digital/peripheral ischemia\n"
            + "• Delirium\n\n"
            + "##Important:## Strongly consider DVT prophylaxis while on angiotensin II.",
            dose: "##Initial:## 20 ng/kg/min\n"
            + "##Titration:## Increase by 15 ng/kg/min every 5 minutes to MAP target\n"
            + "##Max initial:## 80 ng/kg/min (first 3 hours)\n"
            + "##Max maintenance:## 40 ng/kg/min\n\n"
            + "##Concentration:## 2.5 mg/250 mL or 2.5 mg/500 mL\n\n"
            + "##Goal:## Raise MAP or reduce catecholamine doses.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Vasopressor. Peptide hormone (synthetic angiotensin II).\n\n"
            + "The catecholamine-sparing vasopressor. Use in refractory septic shock when norepinephrine alone isn't enough.",
            indications: "##Primary Uses:##\n"
            + "• Septic/distributive shock refractory to first-line vasopressors\n"
            + "• Vasodilatory shock requiring high-dose norepinephrine\n"
            + "• ACE-inhibitor/ARB overdose (replaces blocked RAAS pathway)\n\n"
            + "When to reach for it:## Patient on norepinephrine >0.2 mcg/kg/min with inadequate MAP despite fluids.",
            contraindiction: "##Relative:##\n"
            + "• Active thrombosis\n"
            + "• Severe peripheral vascular disease\n"
            + "• Recent stroke or MI\n\n"
            + "##Important:## Weigh thrombosis risk vs. benefit in refractory shock. Consider concurrent DVT prophylaxis.",
            onSet: "5-15 minutes",
            halfLife: "Less than 1 minute in circulation",
            duration: "Effect dependent on continuous infusion",
            absorbtion: "IV only.",
            distribution: "Rapidly distributed.",
            metaBolism: "Degraded by circulating aminopeptidases.",
            excretion: "Inactive metabolites.",
            pregnancyExplanation: "Limited data. Use only in life-threatening situations.",
            criticalPearls: "##Catecholamine-Sparing Vasopressor:##\n\n"
            + "• Different mechanism — works when catecholamines are maxed out\n"
            + "• Add when norepi >0.2 mcg/kg/min to reduce catecholamine load\n\n"
            + "##Thrombosis Risk:##\n\n"
            + "• Increased VTE and arterial thrombosis — use DVT prophylaxis\n"
            + "• Watch for peripheral ischemia (fingers, toes)\n\n"
            + "##Key clinical evidence:##\n\n"
            + "• ATHOS-3 Trial: Showed improved MAP and reduced catecholamine need\n\n"
            + "##ACE-I/ARB Overdose:##\n\n"
            + "• May be particularly effective when RAAS is blocked"
        ),
        
        // 78. Clevidipine (Cleviprex) - Calcium Channel Blocker
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Clevidipine",
            brandName: "Cleviprex",
            mechansim: "Ultra-short-acting dihydropyridine calcium channel blocker.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of clevidipine as nicardipine's even faster cousin. With a 1-minute half-life, it's the most titratable IV antihypertensive. If you overshoot, the effect is gone almost immediately.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks L-type Ca²⁺ channels in arterial smooth muscle\n"
            + "• Causes arterial vasodilation → Decreases SVR\n"
            + "• No venous dilation (minimal preload effect)\n"
            + "• Metabolized by blood esterases (not liver/kidney)\n\n"
            + "##Key point:## Clevidipine comes in a lipid emulsion — similar precautions as propofol (lipid calories, infection risk, 12-hour tubing changes).",
            adverseEffects: "##Common:##\n\n"
            + "• Headache\n"
            + "• Nausea\n"
            + "• Reflex tachycardia\n"
            + "• Hypotension (if over-titrated)\n\n"
            + "##Serious:##\n\n"
            + "• Severe hypotension (rare, quickly reversible)\n"
            + "• Rebound hypertension if stopped abruptly after prolonged use\n"
            + "• Atrial fibrillation (more common than other CCBs)\n\n"
            + "##Important:## Contains lipid emulsion — count calories and change tubing q12h.",
            dose: "##Initial:## 1-2 mg/hr\n"
            + "##Titration:## Double dose every 90 seconds until near target, then increase by 1-2 mg/hr\n"
            + "##Max:## 32 mg/hr (most patients respond to 4-6 mg/hr)\n\n"
            + "##Concentration:## 0.5 mg/mL (25 mg/50 mL or 50 mg/100 mL)\n\n"
            + "##Lipid content:## 2 kcal/mL — count in nutrition.",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Dihydropyridine calcium channel blocker. Antihypertensive.\n\n"
            + "The ultra-titratable antihypertensive — 1-minute half-life allows precise BP control.",
            indications: "##Primary Uses:##\n"
            + "• Perioperative hypertension\n"
            + "• Hypertensive emergency (when rapid titration needed)\n"
            + "• Acute aortic dissection (with beta-blocker)\n\n"
            + "When to reach for it:## Need very precise, rapidly titratable BP control.",
            contraindiction: "##Absolute:##\n"
            + "• Severe aortic stenosis\n"
            + "• Egg or soy allergy (lipid emulsion)\n"
            + "• Defective lipid metabolism\n"
            + "• Acute pancreatitis with hyperlipidemia\n\n"
            + "##Relative:##\n"
            + "• Heart failure\n"
            + "• Hyperlipidemia\n\n"
            + "##Important:## In aortic dissection, always beta-blocker FIRST.",
            onSet: "2-4 minutes",
            halfLife: "Approximately 1 minute",
            duration: "5-15 minutes after stopping",
            absorbtion: "IV only.",
            distribution: "Highly protein bound.",
            metaBolism: "Blood and tissue esterases (NOT hepatic/renal dependent).",
            excretion: "Renal (inactive metabolites).",
            pregnancyExplanation: "Limited data. Use only if clearly needed.",
            criticalPearls: "##Ultra-Short Half-Life:##\n\n"
            + "• 1-minute half-life — most titratable IV antihypertensive\n"
            + "• If you overshoot, effect is gone in 5-15 minutes\n\n"
            + "##Lipid Emulsion:##\n\n"
            + "• Same precautions as propofol — 2 kcal/mL, change tubing q12h\n"
            + "• Avoid in egg/soy allergy, pancreatitis, severe hyperlipidemia\n\n"
            + "##Metabolism:##\n\n"
            + "• Blood esterases — safe in liver/kidney failure\n\n"
            + "##Key tip:##\n\n"
            + "• No bolus needed — rapid titration achieves target quickly"
        ),
        
        // 79. Heparin - Anticoagulant
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Heparin",
            brandName: "Heparin",
            mechansim: "Indirect thrombin inhibitor that potentiates antithrombin III activity.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of heparin as the amplifier of your body's natural anticoagulation system. It doesn't dissolve clots — it prevents NEW clot formation by:\n"
            + "• Supercharging antithrombin III (1000x more effective)\n"
            + "• Blocking thrombin (Factor IIa) and Factor Xa\n"
            + "• Preventing clot propagation\n\n"
            + "##How it works:##\n\n"
            + "• Binds to antithrombin III → Conformational change\n"
            + "• Accelerated inactivation of thrombin, Xa, IXa, XIa, XIIa\n"
            + "• Does NOT lyse existing clot — prevents extension\n\n"
            + "##Key point:## Heparin works immediately (unlike warfarin) and is reversible with protamine. Monitor with PTT or anti-Xa levels.",
            adverseEffects: "##Common:##\n\n"
            + "• Bleeding (any site)\n"
            + "• Bruising\n"
            + "• Injection site reactions\n\n"
            + "##Serious:##\n\n"
            + "• Heparin-Induced Thrombocytopenia (HIT) — paradoxical clotting\n"
            + "• Major hemorrhage\n"
            + "• Hyperkalemia (suppresses aldosterone)\n"
            + "• Osteoporosis (with prolonged use)\n\n"
            + "##HIT Warning:## If platelets drop >50% or <150K after starting heparin, stop immediately and check HIT antibodies.",
            dose: "##DVT/PE Treatment:##\n"
            + "• Bolus: 80 units/kg IV\n"
            + "• Infusion: 18 units/kg/hr\n"
            + "• Adjust to PTT 60-80 seconds (or per protocol)\n\n"
            + "##ACS Protocol:##\n"
            + "• Bolus: 60 units/kg (max 4000 units)\n"
            + "• Infusion: 12 units/kg/hr (max 1000 units/hr)\n"
            + "• Target PTT: 50-70 seconds\n\n"
            + "##Concentration:## 25,000 units/250 mL or 500 mL (100 or 50 units/mL)",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Anticoagulant. Indirect thrombin inhibitor.\n\n"
            + "The standard parenteral anticoagulant — immediate onset, reversible with protamine, monitored with PTT.",
            indications: "##Primary Uses:##\n"
            + "• DVT/PE treatment\n"
            + "• Acute coronary syndromes (NSTEMI, STEMI)\n"
            + "• Atrial fibrillation (bridge to warfarin)\n"
            + "• Cardiac surgery (CPB anticoagulation)\n"
            + "• Hemodialysis (circuit anticoagulation)\n"
            + "• Mechanical valve (bridging)\n\n"
            + "##DVT prophylaxis:## 5000 units SQ q8-12h (low-dose, no monitoring needed).",
            contraindiction: "##Absolute:##\n"
            + "• Active major bleeding\n"
            + "• History of HIT (use argatroban/bivalirudin instead)\n"
            + "• Severe thrombocytopenia\n\n"
            + "##Relative:##\n"
            + "• Recent surgery/trauma\n"
            + "• Bleeding diathesis\n"
            + "• Severe hypertension\n"
            + "• Active peptic ulcer\n\n"
            + "##Important:## Check baseline platelet count. Repeat in 3-5 days to screen for HIT.",
            onSet: "Immediate (IV); 20-60 minutes (SQ)",
            halfLife: "1-2 hours (dose-dependent)",
            duration: "4-6 hours after stopping infusion",
            absorbtion: "Poor oral absorption — must give IV or SQ.",
            distribution: "Does not cross placenta (large molecule).",
            metaBolism: "Hepatic (reticuloendothelial system).",
            excretion: "Renal (partial).",
            pregnancyExplanation: "Does not cross placenta — anticoagulant of choice in pregnancy.",
            criticalPearls: "##Immediate, Reversible Anticoagulation:##\n\n"
            + "• Works immediately — unlike warfarin which takes days\n"
            + "• Reversible with protamine (1 mg per 100 units heparin)\n\n"
            + "##HIT (Heparin-Induced Thrombocytopenia):##\n\n"
            + "• Check platelets at baseline and day 3-5\n"
            + "• If platelets drop >50%, STOP heparin and check HIT antibodies\n"
            + "• Paradoxically causes CLOTTING, not bleeding\n\n"
            + "##Monitoring:##\n\n"
            + "• PTT for infusion (target per protocol), or anti-Xa\n\n"
            + "##Pregnancy:##\n\n"
            + "• Safe — does not cross placenta"
        ),
        
        // 80. Droperidol - Butyrophenone Antiemetic/Antipsychotic
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Droperidol",
            brandName: "Inapsine ®",
            mechansim: "Droperidol is a butyrophenone that blocks dopamine D2 receptors in the CNS chemoreceptor trigger zone and mesolimbic pathways.\n\n"
            + "##The Mental Model:##\n\n"
            + "Think of droperidol as the potent, fast-acting antiemetic for the ED and OR. It works faster and at lower doses than haloperidol for nausea. Despite the black box warning, at antiemetic doses (≤2.5 mg), the QT prolongation risk is comparable to ondansetron.\n\n"
            + "##How it works:##\n\n"
            + "• Blocks D2 dopamine receptors in the chemoreceptor trigger zone (CTZ) → Antiemetic effect\n"
            + "• Blocks D2 receptors in mesolimbic pathway → Antipsychotic/sedative effect\n"
            + "• α1-adrenergic blockade → Mild hypotension\n"
            + "• Blocks potassium channels → QT prolongation (dose-dependent)\n\n"
            + "##The key:## At antiemetic doses (0.625-2.5 mg), droperidol is remarkably effective with a rapid onset (3-10 minutes). The 2001 FDA black box warning was based on high-dose use; modern evidence supports its safety at low doses.\n\n"
            + "##High-yield point:## Droperidol at 1.25 mg IV is as effective as ondansetron 4 mg for PONV with a faster onset. Consider it for refractory nausea when ondansetron fails.",
            adverseEffects: "##Common:##\n\n"
            + "• Sedation (dose-dependent)\n"
            + "• Restlessness/akathisia\n"
            + "• Hypotension (α-blockade)\n"
            + "• Dizziness\n\n"
            + "##Serious:##\n\n"
            + "• QT prolongation (dose-dependent — minimal at ≤2.5 mg)\n"
            + "• Torsades de Pointes (rare at antiemetic doses)\n"
            + "• Extrapyramidal symptoms (dystonia, akathisia)\n"
            + "• Neuroleptic malignant syndrome (very rare)\n\n"
            + "##The QT controversy:##\n\n"
            + "The 2001 black box warning was based on case reports with high doses. Modern studies show QT prolongation at 0.625-2.5 mg is comparable to ondansetron. Still, avoid in patients with baseline QT prolongation or on other QT-prolonging drugs.\n\n"
            + "##Red flags:##\n\n"
            + "• Baseline QTc >450 ms (relative contraindication)\n"
            + "• Akathisia (inner restlessness — can be distressing)\n"
            + "• Dystonic reaction (treat with diphenhydramine 25-50 mg IV)",
            dose: "##Antiemetic (Primary Use):##\n\n"
            + "• 0.625-1.25 mg IV — start here for most patients\n"
            + "• May repeat once in 30-60 minutes if needed\n"
            + "• Maximum: 2.5 mg IV for refractory nausea\n\n"
            + "##Migraine Cocktail:##\n\n"
            + "• 1.25-2.5 mg IV with metoclopramide or ketorolac\n"
            + "• Excellent for nausea-predominant migraines\n\n"
            + "##Acute Agitation (Off-label):##\n\n"
            + "• 2.5-5 mg IM\n"
            + "• Consider if haloperidol unavailable\n\n"
            + "##Administration:##\n\n"
            + "• Give IV over 2-5 minutes (slow push to minimize hypotension)\n"
            + "• IM absorption is reliable\n"
            + "• ECG monitoring recommended if giving >2.5 mg or in high-risk patients",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Butyrophenone antiemetic/antipsychotic.\n\n"
            + "Potent D2 blocker — fast-acting antiemetic with sedative properties. Related to haloperidol but more commonly used for nausea.",
            indications: "##Primary indications:##\n\n"
            + "• Postoperative nausea and vomiting (PONV)\n"
            + "• Refractory nausea in ED (when ondansetron fails)\n"
            + "• Migraine with nausea\n"
            + "• Chemotherapy-induced nausea (adjunct)\n\n"
            + "##Off-label uses:##\n\n"
            + "• Acute agitation (alternative to haloperidol)\n"
            + "• Sedation for procedures\n"
            + "• Cyclic vomiting syndrome\n\n"
            + "##When to reach for droperidol:## Ondansetron failed, patient is miserable with nausea, and you need something fast and effective. Droperidol 1.25 mg IV often works when nothing else does.",
            contraindiction: "##Absolute:##\n\n"
            + "• Known QT prolongation (QTc >500 ms)\n"
            + "• History of Torsades de Pointes\n"
            + "• Concurrent use of class I/III antiarrhythmics\n"
            + "• Severe hypokalemia or hypomagnesemia (uncorrected)\n\n"
            + "##Relative:##\n\n"
            + "• Baseline QTc 450-500 ms\n"
            + "• Multiple QT-prolonging medications\n"
            + "• Severe hepatic impairment\n"
            + "• Parkinson's disease (dopamine blockade)\n"
            + "• Elderly (start with lower doses)\n\n"
            + "##Important:## At antiemetic doses ≤2.5 mg, the QT risk is low. The black box warning shouldn't prevent use in appropriate patients.",
            onSet: "3-10 minutes IV; 10-30 minutes IM",
            halfLife: "2-3 hours",
            duration: "2-4 hours (antiemetic effect); 12 hours (sedation may persist)",
            absorbtion: "IM absorption is rapid and reliable. IV preferred for immediate effect.",
            distribution: "Highly lipophilic — crosses blood-brain barrier rapidly. This explains the fast onset.",
            metaBolism: "Hepatic (CYP1A2, CYP3A4). Active metabolites minimal.",
            excretion: "Renal (75%) and fecal (22%). No significant accumulation with single doses.",
            pregnancyExplanation: "Category C — crosses placenta. Limited human data. Use only if benefit outweighs risk. Generally avoided unless severe hyperemesis unresponsive to first-line agents.",
            criticalPearls: "##The Best-Kept Secret in the ED:##\n\n"
            + "• Droperidol at 0.625-1.25 mg is often more effective than ondansetron for refractory nausea\n"
            + "• Onset is faster (3-10 min vs 15-30 min for ondansetron)\n"
            + "• Works through a different mechanism — try it when serotonin antagonists fail\n\n"
            + "##The Black Box Reality:##\n\n"
            + "• 2001 warning was based on high-dose (25+ mg) case reports\n"
            + "• Modern evidence: 0.625-2.5 mg has QT prolongation similar to ondansetron\n"
            + "• Many institutions have returned droperidol to formulary for antiemetic use\n\n"
            + "##Practical Tips:##\n\n"
            + "• Start with 0.625-1.25 mg IV — this works for most patients\n"
            + "• Warn patients about possible sedation and restlessness (akathisia)\n"
            + "• If akathisia occurs, diphenhydramine 25-50 mg IV treats it\n"
            + "• Consider baseline ECG for high-risk patients, but routine ECG not required at low doses\n\n"
            + "##Migraine Pearl:##\n\n"
            + "• Droperidol + ketorolac + IV fluids is an excellent migraine cocktail\n"
            + "• Works well for nausea-predominant presentations"
        ),

        // 81. Olanzapine - Atypical Antipsychotic (Acute Agitation)
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Olanzapine",
            brandName: "Zyprexa, Zyprexa Zydis (ODT)",
            mechansim: "Olanzapine is a second-generation (atypical) antipsychotic that blocks dopamine D2 and serotonin 5-HT2A receptors.\n\n"
            + "**The Mental Model:** Think of olanzapine as the calm-without-sedation antipsychotic. Unlike haloperidol (which is a dopamine sledgehammer), olanzapine has a broader receptor profile that produces calming without the heavy sedation or dystonic reactions. IM olanzapine works fast (15-30 minutes to clinical effect) and produces a cooperative, calm patient rather than a knocked-out one.\n\n"
            + "• Dopamine D2 blockade → Reduces psychotic symptoms and agitation\n"
            + "• Serotonin 5-HT2A blockade → Anxiolysis, mood stabilization, fewer EPS than typical antipsychotics\n"
            + "• Histamine H1 blockade → Mild sedation (less than haloperidol + lorazepam combo)\n"
            + "• Muscarinic blockade → Anticholinergic effects (dry mouth, mild tachycardia)\n\n"
            + "**The key:** Olanzapine IM is becoming first-line for acute agitation in many EDs and flight programs because it calms patients effectively with fewer adverse effects than the traditional B52 (Benadryl + Haldol + Ativan). Multiple RCTs show it works as well as or better than haloperidol combinations.\n\n"
            + "**High-yield point:** Breier et al. (2002) showed IM olanzapine 10 mg was non-inferior to IM haloperidol 7.5 mg for acute agitation, with significantly fewer extrapyramidal symptoms. Wright et al. (2001) confirmed IM olanzapine provided effective agitation control with a better side-effect profile than haloperidol.",
            adverseEffects: "**Common:**\n\n"
            + "• Orthostatic hypotension (especially first dose)\n"
            + "• Mild sedation (less than haloperidol + benzo combo)\n"
            + "• Dizziness\n"
            + "• Dry mouth\n"
            + "• Injection site pain (IM)\n\n"
            + "**Serious:**\n\n"
            + "• Respiratory depression when combined with benzodiazepines (THIS IS THE BIG ONE)\n"
            + "• QT prolongation (less than haloperidol or droperidol)\n"
            + "• Neuroleptic malignant syndrome (rare)\n"
            + "• Severe hypotension\n\n"
            + "**Red flags:**\n\n"
            + "• SpO2 dropping after IM olanzapine + benzodiazepine → Respiratory depression, support airway\n"
            + "• Rigid, febrile, altered after antipsychotic → NMS, stop drug immediately\n"
            + "• Severe hypotension after first dose → IV fluids, supine positioning",
            dose: "**Acute Agitation (IM — primary use):**\n\n"
            + "• 5-10 mg IM (start 5 mg in elderly, debilitated, or hepatically impaired)\n"
            + "• May repeat 5-10 mg IM in 2 hours if needed\n"
            + "• Max: 30 mg/day (though most patients respond to 10 mg)\n\n"
            + "**Acute Agitation (ODT — orally disintegrating tablet):**\n\n"
            + "• 5-10 mg ODT placed on tongue (dissolves in seconds)\n"
            + "• Useful for cooperative-but-agitated patients willing to take PO\n"
            + "• Onset: 15-45 minutes (slower than IM)\n\n"
            + "**Undifferentiated Agitation (ED standard):**\n\n"
            + "• Olanzapine 10 mg IM as monotherapy\n"
            + "• Do NOT give IM benzodiazepines within 1 hour of IM olanzapine\n\n"
            + "**Excited Delirium / Severe Agitation:**\n\n"
            + "• Olanzapine 10 mg IM\n"
            + "• If inadequate after 20 min, consider ketamine 4 mg/kg IM instead of adding benzos",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Second-generation (atypical) antipsychotic. Thienobenzodiazepine class.",
            indications: "**Primary indications:**\n\n"
            + "• Acute agitation (psychotic or non-psychotic)\n"
            + "• Acute psychosis\n"
            + "• Excited delirium (as alternative to ketamine)\n"
            + "• Alcohol withdrawal agitation (when benzos aren't enough)\n"
            + "• Agitated delirium in the ICU\n\n"
            + "**You'll reach for olanzapine when:**\n\n"
            + "• Patient is acutely agitated and you want calm cooperation, not deep sedation\n"
            + "• Patient has history of dystonic reactions to haloperidol\n"
            + "• You want to avoid the respiratory depression risk of benzo combinations\n"
            + "• Undifferentiated agitation where you're not sure if it's psychiatric, substance, or medical\n\n"
            + "**Classic scenario:** Agitated patient in the ED, etiology unclear, yelling and threatening staff → Olanzapine 10 mg IM. Patient calm and cooperative in 20 minutes, able to participate in evaluation. No dystonia, no over-sedation.",
            contraindiction: "**CRITICAL: The Olanzapine-Benzodiazepine Rule:**\n\n"
            + "• Do NOT give IM olanzapine and IM benzodiazepines together or within 1 hour of each other\n"
            + "• This combination has caused fatal respiratory depression and cardiac arrest\n"
            + "• If patient needs both, use IV benzos (where you can titrate) with monitoring\n\n"
            + "**Other contraindications/cautions:**\n\n"
            + "• Known QT prolongation — use with caution\n"
            + "• Signs of anticholinergic toxicity — avoid combining with other anticholinergics\n"
            + "• Severe hepatic impairment — start at lower dose\n"
            + "• Hypersensitivity to olanzapine",
            onSet: "IM: 15-30 minutes (peak plasma concentration at 15-45 min per FDA PI). ODT: 15-45 minutes.",
            halfLife: "21-54 hours (mean 30 hours). Long half-life means effects persist.",
            duration: "Calming effect: 4-8 hours. Some sedation may persist 12-24 hours.",
            absorbtion: "IM absorption is rapid and reliable. Bioavailability is 100% IM vs 60% oral (first-pass metabolism).",
            distribution: "Extensively protein bound (93%). Large volume of distribution. Highly lipophilic — crosses BBB rapidly.",
            metaBolism: "Hepatic via CYP1A2 (major) and CYP2D6 (minor). Smoking induces CYP1A2 — smokers may need higher doses.",
            excretion: "Renal (57%) and fecal (30%). No dose adjustment needed for renal impairment. Reduce dose in hepatic impairment.",
            pregnancyExplanation: "Category C. Third-trimester use associated with neonatal extrapyramidal symptoms and withdrawal. Use only if benefit clearly outweighs risk.",
            criticalPearls: "**Why Olanzapine is Replacing the B52:**\n\n"
            + "• B52 (Benadryl 50 + Haldol 5 + Ativan 2) has been the gold standard for decades\n"
            + "• But olanzapine 10 mg IM monotherapy works just as well with fewer side effects\n"
            + "• No dystonia (the most distressing side effect of haloperidol)\n"
            + "• Less over-sedation (patients can participate in their care sooner)\n"
            + "• Less respiratory depression (no benzodiazepine component)\n"
            + "• Simpler (one drug vs three)\n\n"
            + "**The Evidence:**\n\n"
            + "• Breier et al. (2002): IM olanzapine non-inferior to IM haloperidol, significantly fewer EPS\n"
            + "• Wright et al. (2001): IM olanzapine effective for acute agitation with better tolerability\n"
            + "• TREC trial (2003): haloperidol 5 mg + promethazine 50 mg was faster-acting than olanzapine alone, but olanzapine had fewer side effects and less need for additional sedation\n"
            + "• Consistent finding across studies: lower rate of EPS (extrapyramidal symptoms) vs haloperidol\n\n"
            + "**Olanzapine vs Ketamine for Excited Delirium:**\n\n"
            + "• Ketamine 4 mg/kg IM works faster (5-10 min vs 15-30 min)\n"
            + "• But ketamine has a variable intubation rate across studies (reported 0-39%, commonly ~6-15%)\n"
            + "• Olanzapine is better for non-emergent severe agitation\n"
            + "• Ketamine is better when patient safety is in immediate jeopardy\n\n"
            + "**Flight Medicine Pearl:**\n\n"
            + "• Olanzapine 10 mg IM is increasingly carried on HEMS and CCT\n"
            + "• Ideal for transport because it doesn't cause respiratory depression (when used alone)\n"
            + "• ODT form can be given without needles in hostile environments\n"
            + "• Always carry diphenhydramine as rescue for rare akathisia"
        ),

        // 82. Ziprasidone - Atypical Antipsychotic (Acute Agitation)
        ClinicalPharamcologyDetailsModelView(
            mainTitle: "Ziprasidone",
            brandName: "Geodon",
            mechansim: "Ziprasidone is a second-generation (atypical) antipsychotic with potent dopamine D2 and serotonin 5-HT2A receptor antagonism, plus serotonin and norepinephrine reuptake inhibition.\n\n"
            + "**The Mental Model:** Think of ziprasidone as the antipsychotic that acts like an antidepressant on the side. It blocks the same dopamine and serotonin receptors as olanzapine, but it also inhibits serotonin and norepinephrine reuptake — giving it mild antidepressant-like properties. IM ziprasidone works fast and is particularly useful for agitated psychotic patients.\n\n"
            + "• Dopamine D2 blockade → Antipsychotic effect, reduces agitation\n"
            + "• Serotonin 5-HT2A blockade → Fewer EPS than typical antipsychotics, anxiolysis\n"
            + "• 5-HT1A partial agonism → Anxiolytic effect\n"
            + "• SERT/NET reuptake inhibition → Mild mood elevation\n"
            + "• Minimal histamine and muscarinic blockade → Less sedation and anticholinergic effects than olanzapine\n\n"
            + "**The key:** Ziprasidone IM is the go-to when you need rapid antipsychotic effect in a known psychotic patient. Among the sedating atypicals used for acute agitation, it has high D2 occupancy at therapeutic doses, making it particularly effective for psychosis-driven agitation. The trade-off is more QT prolongation than olanzapine.\n\n"
            + "**High-yield point:** Ziprasidone causes more QT prolongation than any other atypical antipsychotic. Always check baseline ECG if possible. However, the clinical significance at standard IM doses (10-20 mg) is debated — Torsades de Pointes is extremely rare at these doses.",
            adverseEffects: "**Common:**\n\n"
            + "• Injection site pain (IM)\n"
            + "• Somnolence\n"
            + "• Dizziness\n"
            + "• Nausea\n"
            + "• Headache\n\n"
            + "**Serious:**\n\n"
            + "• QT prolongation (FDA black box warning — mean QTc increase ~20 ms at therapeutic doses; clinically significant Torsades is rare at IM doses)\n"
            + "• Torsades de Pointes (rare but documented)\n"
            + "• Orthostatic hypotension\n"
            + "• Neuroleptic malignant syndrome (rare)\n"
            + "• Extrapyramidal symptoms (less than haloperidol, similar to olanzapine)\n\n"
            + "**Red flags:**\n\n"
            + "• QTc >500 ms → STOP, do not give additional doses\n"
            + "• Syncope after dose → Check ECG immediately, rule out arrhythmia\n"
            + "• Rigid, febrile, altered → NMS workup, stop drug",
            dose: "**Acute Agitation — Psychotic (IM):**\n\n"
            + "• 10-20 mg IM\n"
            + "• 10 mg may be repeated q2h\n"
            + "• 20 mg may be repeated q4h\n"
            + "• Max: 40 mg/day IM\n\n"
            + "**Acute Agitation — Non-Psychotic (IM):**\n\n"
            + "• 10 mg IM (lower dose for non-psychotic agitation)\n"
            + "• Reassess in 2 hours\n\n"
            + "**Important IM preparation:**\n\n"
            + "• Reconstitute with 1.2 mL sterile water for injection\n"
            + "• Shake vigorously until dissolved\n"
            + "• Must give IM only — NOT for IV use\n"
            + "• Discard unused portion (single-use vial)\n\n"
            + "**Transition to oral:**\n\n"
            + "• 20-40 mg PO BID with food (food required — increases absorption approximately 2-fold per FDA PI)\n"
            + "• Can transition from IM to PO same day",
            pregnancyClass: PregnancyLetter(pregCategory: pregnancyType.C),
            pregLettercolor: PregnancyColor(pregCategory: pregnancyType.C),
            DrugClass: "Second-generation (atypical) antipsychotic. Benzisothiazolyl piperazine class.",
            indications: "**Primary indications:**\n\n"
            + "• Acute agitation in schizophrenia\n"
            + "• Acute agitation in bipolar mania\n"
            + "• Psychosis-driven agitation (known psychiatric history)\n\n"
            + "**You'll reach for ziprasidone when:**\n\n"
            + "• Patient has known psychotic disorder and is acutely agitated\n"
            + "• You want rapid antipsychotic effect (high D2 binding)\n"
            + "• Patient has had good response to ziprasidone previously\n"
            + "• Olanzapine is contraindicated (recent benzo use) and you don't want haloperidol\n\n"
            + "**Classic scenario:** Patient with known schizophrenia brought in by EMS, paranoid, combative, refusing all oral medication → Ziprasidone 20 mg IM. Calmer in 30 minutes, able to take oral medications.",
            contraindiction: "**Critical contraindications/cautions:**\n\n"
            + "• QTc prolongation — check baseline ECG if available; do NOT use if QTc >500 ms\n"
            + "• Concurrent QT-prolonging drugs (amiodarone, haloperidol, ondansetron, fluoroquinolones)\n"
            + "• Hypokalemia or hypomagnesemia — correct electrolytes before dosing\n"
            + "• Recent MI or uncompensated heart failure\n"
            + "• Hypersensitivity to ziprasidone\n\n"
            + "**Administration caution:**\n\n"
            + "• IM only — never give IV\n"
            + "• Monitor vitals and place on cardiac monitor if possible after administration",
            onSet: "IM: 15-30 minutes. Faster than oral (which requires food for absorption).",
            halfLife: "IM: 2-5 hours. Oral: 6-7 hours. Shorter than olanzapine.",
            duration: "IM: 4-6 hours of antipsychotic effect.",
            absorbtion: "IM: rapid and complete. Oral: requires food — bioavailability doubles with food (take with 500+ calorie meal).",
            distribution: "Extensively protein bound (>99%). Large volume of distribution.",
            metaBolism: "Hepatic. Two-thirds via aldehyde oxidase (not CYP — fewer drug interactions). One-third via CYP3A4.",
            excretion: "Fecal (66%) and renal (20%). Minimal active metabolites.",
            pregnancyExplanation: "Category C. Third-trimester use associated with neonatal extrapyramidal symptoms. Use only if benefit outweighs risk.",
            criticalPearls: "**Olanzapine vs Ziprasidone vs Haloperidol — When to Use Each:**\n\n"
            + "**Olanzapine 10 mg IM:**\n"
            + "• Best for undifferentiated agitation (cause unknown)\n"
            + "• Fewest EPS, good safety profile\n"
            + "• Cannot give with recent benzodiazepines\n"
            + "• Less QT concern than ziprasidone or haloperidol IV\n\n"
            + "**Ziprasidone 20 mg IM:**\n"
            + "• Best for known psychotic agitation\n"
            + "• High D2 occupancy (strong antipsychotic effect at therapeutic doses)\n"
            + "• CAN be given with benzodiazepines (no respiratory depression interaction)\n"
            + "• More QT prolongation — check ECG when possible\n\n"
            + "**Haloperidol 5 mg IM:**\n"
            + "• Traditional choice, long track record\n"
            + "• Higher rate of dystonia and EPS\n"
            + "• Can combine with lorazepam and diphenhydramine (B52)\n"
            + "• IV haloperidol has more QT risk than IM\n\n"
            + "**The B52 Cocktail (for reference):**\n\n"
            + "• Benadryl (diphenhydramine) 50 mg IM\n"
            + "• Haldol (haloperidol) 5 mg IM\n"
            + "• Ativan (lorazepam) 2 mg IM\n"
            + "• Still widely used but olanzapine monotherapy is gaining ground\n\n"
            + "**Flight Medicine Considerations:**\n\n"
            + "• Both ziprasidone and olanzapine IM require reconstitution (olanzapine: 2.1 mL SWFI; ziprasidone: 1.2 mL SWFI)\n"
            + "• Olanzapine ODT (orally disintegrating tablet) requires no injection — advantage in austere environments\n"
            + "• Both are reasonable choices for HEMS/CCT\n"
            + "• Always have diphenhydramine available for EPS rescue\n"
            + "• Monitor QT if giving ziprasidone with any other QT-prolonging medications"
        ),
    ]
}
