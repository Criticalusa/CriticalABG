//
//  TPAResultView.swift
//  CriticalX
//
//  Created by Macbook 4 on 03/12/2021.
//

import SwiftUI

struct TPAResultView: View {
    
    @Environment(\.colorScheme) var colorScheme
    var bolus: Double?
    var infusion: Double?
    var wastedTpa: Double?
    
    var body: some View {
        
//        let bolus = Text(String(bolus ?? 0))
//        let infusion = Text(String(infusion ?? 0))
//        let wasteTpa = Text(String(wastedTpa ?? 0))
        
        let bolus1 = String(format: "%.1f", bolus!)
        let infusion1 = String(format: "%.1f", infusion!)
        let wastedTpaCorrected = String(format: "%.1f", wastedTpa!)

        
        VStack{
            
            Text("Results")
                .font(.system(size: 28, weight: .medium, design: .default))
                .foregroundColor(Color.blue)
                .padding(.top, 30)

            VStack(spacing: 10){
                
                HStack{
                    
                    Text("Bolus mg's to be given IV over 1 minute :")
                        .font(.system(size: 16, weight: .medium, design: .default))                          .foregroundColor(Color.charcol_gray)
                   
                    
                    Spacer()
                    
                    
                    
                    Text("\(bolus1)")
                        .font(.system(size: 20, weight: .medium, design: .default))                          .foregroundColor(Color.redColor)
                }
                .padding(EdgeInsets(top: 5, leading: 10, bottom: 0, trailing: 10))
               
               
                
                HStack{
                    Text("Infusion mg's over 60 min is:")
                        .font(.system(size: 16, weight: .medium, design: .default))                          .foregroundColor(Color.charcol_gray)
                   
                    
                    Spacer()
                    
                   
                    
                    Text("\(infusion1)")
                        .font(.system(size: 20, weight: .medium, design: .default))                          .foregroundColor(Color.paoloVeronese_green)
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
              
                
                HStack{
                    Text("The remaining mg's is to be\ndiscarded:")
                        .font(.system(size: 16, weight: .medium, design: .default))                          .foregroundColor(Color.charcol_gray)
             
                    Spacer()
                    
                    
                    Text("\(wastedTpaCorrected)")
                        .font(.system(size: 20, weight: .medium, design: .default))                          .foregroundColor(Color.criticalBlue)
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
            }
            .frame(width:  UIScreen.main.bounds.width * 0.9, height: 134)
            .background(Color(UIColor.component(red: 227, green: 240, blue: 241, opacity: 1)))
            .cornerRadius(8)
            .padding(.top, 20)
            .padding(.bottom, 50)
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.95)
        .shadow(color: Color.gray.opacity(0.01), radius: 5, x: 0, y: 2)
        .shadow(color: Color.critical_gray.opacity(0.01), radius: 20, x: 0, y: 10)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .cornerRadius(8)
        .padding(.top, 30)
        .padding(.leading, 8)

        //.shadow(radius: 5)
        
    }
}

struct TPAResultView_Previews: PreviewProvider {
    static var previews: some View {
        TPAResultView(bolus: 0.0, infusion: 0.0, wastedTpa: 0.0)
    }
}
