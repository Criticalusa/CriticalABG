//
//  IdealBodyResultView.swift
//  CriticalX
//
//  Created by Macbook 4 on 02/12/2021.
//

import SwiftUI

struct IdealBodyResultView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var pounds: Double?
    var poundsExpected: Double?
    var gender: String?
    var height: Double?
    var targetTV: Double?
    var ettDepth: Double?
    var calculateTv: Int?
    var measurement: String?

    init(pounds: Double? = nil, poundsExpected: Double? = nil, gender: String? = nil, height: Double? = nil, targetTV: Double? = nil, ettDepth: Double? = nil, calculateTv: Int? = nil, measurement: String? = nil) {
        self.pounds = pounds
        self.poundsExpected = poundsExpected
        self.gender = gender
        self.height = height
        self.targetTV = targetTV
        self.ettDepth = ettDepth
        self.calculateTv = calculateTv
        self.measurement = measurement
    }

    var body: some View {
        
        let targetTv1 = String(format: "%.0f", targetTV!)
        let poundsExpect =  String(format: "%.1f", poundsExpected!)
        let height =  String(format: "%.1f", height!)
        let ettDep =  String(format: "%.0f", ettDepth!)
        //let calculateTV =  String(format: "%.0f", calculateTv!)
        
        HStack{
            VStack(alignment: .leading){ }
            .frame(width: 14, height: 230)
            .background(Color(UIColor.component(red: 61, green: 186, blue: 133, opacity: 1)))
            
            Spacer()
            
            VStack{
                
                Text("\(gender!) at \(height) inches | \(measurement!)")
                    .foregroundColor(Color.orange_TerraCotta)
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                Spacer()
                HStack{
                    VStack(spacing: 15){
                        Text("Ideal Body Weight")
                            .foregroundColor(Color.charcol_gray)
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            
                        Text("\(String(pounds!)) Kg's")
                            .foregroundColor(Color.blue)
                            .font(.system(size: 18, weight: .medium, design: .default))
                        Text("ETT Depth")
                            .foregroundColor(Color.charcol_gray)
                            .font(.system(size: 14, weight: .semibold, design: .default))

                            .padding(.top, 10)
                        Text("\(ettDep) cm")
                            .foregroundColor(Color.charcol_gray)
                            .font(.system(size: 18, weight: .medium, design: .default))
                    }
                    .padding(.leading, 5)
                    Spacer()
                    
                    VStack(spacing: 15){
                        Text("TV at \(targetTv1) mL's/Kg")
                            .foregroundColor(Color.charcol_gray)
                            .font(.system(size: 14, weight: .semibold, design: .default))

                            .padding(.trailing, 13)
                        Text("\(calculateTv!) mL's")
                            .foregroundColor(Color.paoloVeronese_green)
                            .font(.system(size: 18, weight: .medium, design: .default))
                        Text("Pounds")
                            .foregroundColor(Color.charcol_gray)
                            .font(.system(size: 14, weight: .semibold, design: .default))

                            .padding(.top, 10)
                        Text("\(poundsExpect) lbs.")
                            .foregroundColor(Color(UIColor.component(red: 218, green: 98, blue: 99, opacity: 1)))
                            .font(.system(size: 18, weight: .medium, design: .default))
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 30)
                .padding(.top, 20)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: 230)
        .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
        .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 4, x: 0, y: 4)
    }
}

struct IdealBodyResultView_Previews: PreviewProvider {
    static var previews: some View {
        IdealBodyResultView(pounds: 0, poundsExpected: 0, gender: "", height: 0, targetTV: 0, ettDepth: 0, calculateTv: 0, measurement: "")
    }
}
