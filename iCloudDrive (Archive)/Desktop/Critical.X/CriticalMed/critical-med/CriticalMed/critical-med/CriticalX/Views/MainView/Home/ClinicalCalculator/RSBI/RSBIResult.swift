//
//  RSBIResult.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 3/24/22.
//

import SwiftUI

struct RSBIResult: View {
    
    @Environment(\.colorScheme) var colorScheme
    var rsbiResult: Double?
    var rsbi_detailText: String
    
    var body: some View {
       
        HStack {
            
            VStack(alignment: .leading){ }
            .frame(width: 14, height: 270)
            .background(Color.paoloVeronese_green)
            .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
           
            Spacer()
            
            VStack(spacing: 0){
                
            
                
                Text("The RSBI was calculated at")
                .foregroundColor(Color.charcol_gray)
                .font(.system(size: 16, weight: .medium, design: .default))
                .fontWeight(.regular)
                .lineSpacing(3)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
                .fixedSize(horizontal: false, vertical: true)

                Text(rsbiResult?.sigFig ?? "")
                .font(.system(size: 90, weight: .medium, design: .rounded))
                .foregroundColor(Color.red)
            
                Text("breaths/min/L")
                    .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 18))
                    .foregroundColor(Color.blue)
                    .padding(.bottom, 20)
                    
                
                Text(rsbi_detailText)
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(Color.paoloVeronese_green)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .padding(.bottom, 20)
               
        }
            .animation(.easeInOut(duration: 0.3), value: rsbiResult)

        Spacer()
    }

        .frame(width: UIScreen.main.bounds.width * 0.95, height: .infinity)
    .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
    .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.1)), radius: 4, x: 0, y: 4)
    .animation(.easeInOut(duration: 1.0), value: rsbiResult)

    //.shadow(radius: 8)
        
        
    }


  
}

struct RSBIResult_Previews: PreviewProvider {
    static var previews: some View {
        RSBIResult(rsbiResult: 0, rsbi_detailText: "Likely successful extubation by RSBI. Consider all patient factors before extubating (see Pearls/Pitfalls for suggestions). 97% sensitive.")
    }
}
