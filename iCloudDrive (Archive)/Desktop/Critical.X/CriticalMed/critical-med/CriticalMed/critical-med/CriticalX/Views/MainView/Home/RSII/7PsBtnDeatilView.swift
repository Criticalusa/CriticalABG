//
//  7PsBtnDeatilView.swift
//  CriticalX
//
//  Created by Macbook 7 on 04/01/2022.
//  Updated to use CriticalDesign system
//

import SwiftUI

struct SevenPsBtnDetailView: View {
    @Environment(\.colorScheme) var colorScheme

    let data: RSIIBtnDetailDataModel
   
    var body: some View {
        ZStack {
            CriticalDesign.Colors.canvas
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: CriticalDesign.Spacing.lg) {
                    // Title Section with Neumorphic style
                    VStack(spacing: CriticalDesign.Spacing.sm) {
                        Text("Rapid Sequence Intubation Process")
                            .font(.custom("Poppins-Bold", size: 28))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .multilineTextAlignment(.center)
                        
                        Text(data.title)
                            .font(.custom("Poppins-SemiBold", size: 22))
                            .foregroundColor(CriticalDesign.Colors.accentBlue)
                    }
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                    .padding(.vertical, CriticalDesign.Spacing.lg)
                    .frame(maxWidth: .infinity)
                    .deepNeumorphicCard(cornerRadius: CriticalDesign.Radius.xl)
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                    .padding(.top, CriticalDesign.Spacing.lg)
                    
                    // Overview Card with enhanced Neumorphic style
                    VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
                        HStack {
                            Text("Overview")
                                .font(.custom("Poppins-Bold", size: 20))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            
                            Spacer()
                            
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(CriticalDesign.Colors.accentBlue)
                        }
                        
                        Text(data.description)
                            .font(.custom("Poppins-Regular", size: 16))
                            .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                            .lineSpacing(5)
                    }
                    .padding(CriticalDesign.Spacing.lg)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .deepNeumorphicCard(cornerRadius: CriticalDesign.Radius.xl)
                    .padding(.horizontal, CriticalDesign.Spacing.lg)
                }
                .padding(.bottom, CriticalDesign.Spacing.xl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SevenPsBtnDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SevenPsBtnDetailView(data: RSIIBtnDetailDataModel(title: "Pre-Treatment", description: "This is the mnemonic : SOAP ME"))
    }
}
