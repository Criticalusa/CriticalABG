//
//  OthersRowsMiddleView.swift
//  CriticalX
//
//  Created by Macbook 4 on 03/12/2021.
//

import SwiftUI

struct OthersRowsMiddleView: View {
    
    var section: Int?
    var row: Int?
    
    var body: some View {

        switch (section, row) {
        case (3,0):
            CriticalEKGRowDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (3,1):
            SinuBradycardiaDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (3,2):
            SinusTachycardiaDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (4,0):
            AtrialFlutterDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (4,1):
            SupraventricularDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (4,2):
            ArtialFibrillationDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (5,0):
            SecondDegreeDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (5,1):
            SecondDegreeAvDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (5,2):
            ThirdDegreeDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (6,0):
            AsystoleDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (6,1):
            TorsadesDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (6,2):
            VentricularDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (6,3):
            VentriculartachycardiaDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        case (2,0):
            LeadView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        default:
            CriticalEKGRowDetailView().navigationBarBackground{Color.logoBlue.shadow(radius: 1)}
                .navigationBarTitle("", displayMode: .inline)
        }
    }
}
struct OthersRowsMiddleView_Previews: PreviewProvider {
    static var previews: some View {
        OthersRowsMiddleView(section: 0, row: 0)
    }
}
