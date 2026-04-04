//
//  VadsOtherView.swift
//  CriticalX
//
//  Created by Macbook 4 on 23/11/2021.
//

import SwiftUI

// MARK: - Custom Components
struct ContentCard: View {
    let title: String
    let content: String
    let titleColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("SF Pro Display", size: 20))
                .fontWeight(.bold)
                .foregroundColor(titleColor)
            
            Text(content)
                .font(.custom("SF Pro Text", size: 16))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.3), lineWidth: 0.5)
        )
    }
}

struct VadsOtherView: View {
    
    @Binding var category:Int
    @Binding var model:VadsOtherDataModel
    @Binding var url: String
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode
    @State private var currentScale: CGFloat = 0
    @State private var finalScale: CGFloat = 1
    
    var body: some View {
        ZStack{
           
            LinearGradient(
                gradient: Gradient(colors: [
                    .criticalBlue,
                    .criticalBlue.opacity(0.7),
                    .red_matte.opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                
            
            ScrollView(showsIndicators: false) {
               
                VStack(spacing: 24){
                 
                    HStack{
                  
                        Spacer()
                        
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 40, height: 40)
                                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                    .overlay(
                                        Circle()
                                            .stroke(.white.opacity(0.3), lineWidth: 0.5)
                                    )
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                        
                        Spacer()
                        
                    }
                    
                
                    VStack(spacing: 20){
                        
                        Text(model.title)
                            .font(.custom("SF Pro Display", size: 42))
                            .fontWeight(.bold)
                            .foregroundColor(.critical_lightBlue)
                        
                        Image(model.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .scaleEffect(finalScale + currentScale)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { currentScale = $0 }
                                    .onEnded { scale in
                                        finalScale = scale
                                        currentScale = 0
                                    }
                            )
                            .shadow(color: .white.opacity(0.2), radius: 10)
                    }
                    .padding(.bottom, 32)
                    
                    VStack(spacing: 20){
                        
                        ContentCard(
                            title: "Overview",
                            content: model.overViewDescription,
                            titleColor: .red
                        )
                        
                        ContentCard(
                            title: "What to Know",
                            content: model.whatToKnowDescription,
                            titleColor: .red
                        )
                    }
                    .padding(.horizontal)
                    
                    Button(action: { openURL(URL(string: url)!) }) {
                        Text("Troubleshooting")
                            .font(.custom("SF Pro Display", size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 230, height: 55)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white.opacity(0.3), lineWidth: 0.5)
                            )
                    }
                    .padding(.vertical, 40)
                }
                .padding(.top, 30)
            }
        }
        .preferredColorScheme(.dark)
    }
}



struct VadsOtherView_Previews: PreviewProvider {
    static var previews: some View {
        VadsOtherView(category: .constant(0), model: .constant(VadsOtherDataModel(title: "HeartMate", overViewDescription: "This is a vad", whatToKnowDescription: "What do we know", image: "")), url: .constant(""))
    }
}
