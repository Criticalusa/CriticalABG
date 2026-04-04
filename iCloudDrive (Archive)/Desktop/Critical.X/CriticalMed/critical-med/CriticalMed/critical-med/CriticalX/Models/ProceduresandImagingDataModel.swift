//
//  ProceduresandImagingDataModel.swift
//  CriticalX
//
//  Created by Macbook 7 on 05/01/2022.
//

import Foundation
import SwiftUI

struct ProceduresHeaderDataModel {
    
    let title: String
    let row: [ProceduresSectionDataModel]
}

extension ProceduresHeaderDataModel {
    
    static let proceduresHeaderData = [ProceduresHeaderDataModel(title: "Procedures", row: ProceduresSectionDataModel.proceduresSectionData)]
}

struct ProceduresSectionDataModel {
    
    let image: String
    let title: String
    let subTitle: String
    let color: Color
    let isPicCell: Bool
}

extension ProceduresSectionDataModel {
    
    static let proceduresSectionData = [
       
       // ProceduresSectionDataModel(image: "Ultrasound", title: "Ultrasonography", subTitle: "Emergency Ultrasound, E-FAST, RUSH ", color: Color.init(uiColor: UIColor.component(red: 16, green: 26, blue: 35, opacity: 1)), isPicCell: true),
        
        ProceduresSectionDataModel(image: "icon-ultrasound 1", title: "Ultrasound", subTitle: "Emergency Ultrasound, E-FAST, RUSH ", color: Color.clear, isPicCell: true),
        
        ProceduresSectionDataModel(image: "icon-cxr", title: "Chest X-ray Interpretation", subTitle: "Normal chest x-ray with a detailed overlay", color: Color.clear, isPicCell: true),
        
        ProceduresSectionDataModel(image: "icon-TLC", title: "Central Venous Catheter", subTitle: "Ultrasound guided insertion", color: Color.clear, isPicCell: true),
        
        ProceduresSectionDataModel(image: "icon-aorta", title: "REBOA", subTitle: "Resuscitative Endovascular Balloon Occlusion of the Aorta", color: Color.clear, isPicCell: true)

    ]
}
