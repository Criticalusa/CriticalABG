//
//  WinterFormulaResultView.swift
//  CriticalX
//
//  Created by Macbook 4 on 03/12/2021.
//

import SwiftUI

struct WinterFormulaResultView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var lblResult: String?
    var lblCoDescription: String?
    var winterSmallTxt: String?
    @State var resultView = false
    
    var body: some View {
        
        let co = Text("\(lblResult!)")
            .foregroundColor(Color.butter_gold)
        
        
        HStack{
            VStack(alignment: .leading){ }
                .frame(width: 14, height: 400)
                .background(Color.mint_darkGreen)
            
            Spacer()
            VStack(spacing: 0){
                Text("Expected CO2")
                    .foregroundColor(Color.gray)
                    .font(.system(size: 25, weight: .regular, design: .default))
                    .padding(.top, 20)
                
                Text("\(lblResult!)")
                    .foregroundColor(Color.red)
                    .font(.system(size: 55, weight: .regular, design: .default))
                    .padding(.top, 10)
                
                Text("mmHg")
                    .font(.system(size: 14, weight: .bold, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .padding(.top, 10)
                
                Text("Explanation")
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundColor(Color.blue)
                    .underline()
                    .padding(.top, 15)
                    
                Text("The corrected CO2 should be between \(co). \(lblCoDescription!)")
                //.frame(width: UIScreen.main.bounds.width * 0.85)
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.component(red: 66, green: 78, blue: 96, opacity: 1)))
                    .padding(.top, 15)
                
                Text("\(winterSmallTxt!)")
                    .foregroundColor(Color.red)
                    .font(.system(size: 28, weight: .medium, design: .default))
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                
                
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.95, height: 400)
        .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
        .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 4, x: 0, y: 4)
        .shadow(radius: 8)
        .animation(.easeInOut(duration: 1.0), value: resultView)
        .foregroundStyle(.regularMaterial)
        
    }
}

struct WinterFormulaResultView_Previews: PreviewProvider {
    static var previews: some View {
        WinterFormulaResultView(lblResult: "34-56", lblCoDescription: "", winterSmallTxt: "Resp Alkalosis")
    }
}

