//
//  FreeWaterDepicitResultView.swift
//  CriticalX
//
//  Created by Macbook 4 on 01/12/2021.
//

import SwiftUI

struct FreeWaterDepicitResultView: View {

    @Environment(\.colorScheme) var colorScheme

    var freeWaterResult: String?
    var deficitLabel: String?
    var ivFlowRate: String?
    
    var body: some View {
        
        VStack{
            VStack{
                
                Text(deficitLabel ?? "")
                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 15)
                
                Text(freeWaterResult ?? "")
                    .font(.system(size: 48, weight: .semibold, design: .default))
                    .foregroundColor(Color.red)
                    .padding(.top, 2)
            }
            VStack{
                Text(ivFlowRate ?? "")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(Color(UIColor.component(red: 250, green: 250, blue: 250, opacity: 1)))
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            }
            .frame(width: UIScreen.main.bounds.width * 0.93)
            .background(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
        }
        .animation(Animation.easeInOut(duration: 1.0), value: freeWaterResult)
        .frame(width: UIScreen.main.bounds.width * 0.95)
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
        .shadow(radius: 5)
    }
}

struct FreeWaterDepicitResultView_Previews: PreviewProvider {
    static var previews: some View {
    FreeWaterDepicitResultView(freeWaterResult: "", deficitLabel: "", ivFlowRate: "")
    }
}
