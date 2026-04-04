//
//  BMIResultView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 3/22/22.
//

import SwiftUI

struct BMIResultView: View {
   
        
    @Environment(\.colorScheme) var colorScheme
        var resultBMI: Double?
        var resultBSA: Double?
        var isTargetBMINil: Bool?
        var targetWeight: Double?
        var targetBMI: Double
        var feets: String
        var weight: Double?
    
    var body: some View {

            
            HStack {
                
                VStack(alignment: .leading){ }
                .frame(width: 14, height: 220)
                .background(Color.paoloVeronese_green)
                .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
               
                Spacer()
                
                VStack(spacing: 0){
                    
                    let description = "For a target BMI of \(targetBMI), You need to get to \(resultBSA!.sigFig) lbs. The Body Mass Index at \(feets) and \(weight!) kg's is:"
                
                    Text(isTargetBMINil ?? false ? "The Body Mass Index at \(feets) and \(weight!) kg's :" : String (description))
                    .foregroundColor(Color.charcol_gray)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .fontWeight(.regular)
                    .lineSpacing(3)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .fixedSize(horizontal: false, vertical: true)

                    Text(resultBMI?.sigFig ?? "")
                    .font(.system(size: 90, weight: .medium, design: .rounded))
                    .foregroundColor(Color.red)
                
                Text("kg/m2")
                    .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 18))
                    .foregroundColor(Color.charcol_gray)
                    .padding(.bottom, 20)
            }
            Spacer()
        }

        .frame(width: UIScreen.main.bounds.width * 0.95, height: 220)
        .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
        .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.1)), radius: 4, x: 0, y: 4)
        .animation(Animation.easeInOut(duration: 1.0), value: resultBMI)

        //.shadow(radius: 8)
                
            }
        }
        
    

struct BMIResultView_Previews: PreviewProvider {
    static var previews: some View {
        BMIResultView(resultBMI: 0.0,isTargetBMINil: false, targetWeight: 0.0, targetBMI: 0.0, feets: "")
    }
}

extension Double {
    var sigFig: String {
        return  String(format: "%.1f" ,self)
    }
}

