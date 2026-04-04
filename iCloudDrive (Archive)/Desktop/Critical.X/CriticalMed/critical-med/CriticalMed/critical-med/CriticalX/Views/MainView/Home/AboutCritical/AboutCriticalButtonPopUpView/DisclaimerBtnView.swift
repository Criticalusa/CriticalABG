//
//  DisclaimerBtnView.swift
//  CriticalX
//
//  Created by Macbook 4 on 16/11/2021.
//

import SwiftUI
import MessageUI
struct DisclaimerBtnView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @Environment(\.openURL) var openURL

    
    var body: some View {
        
        ZStack {
            
            CriticalDesign.Adaptive.canvas(for: colorScheme)
            LinearGradient(gradient: Gradient (colors: colorScheme == .dark ? [CriticalDesign.Colors.darkCanvas, .criticalBlue, CriticalDesign.Colors.goldDeep] : [.white,.criticalBlue,.red_matte]), startPoint: .top, endPoint: .bottomTrailing)
                .opacity(0.17)
            
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack{
                    Text("DISCLAIMER AGREEMENT")
                        .font(.title2).bold()
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
                .background(Color.royal_blue)
               
                Spacer()
                   
                VStack {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                            
                        Text("""
                                    Disclaimer for Critical Medical Guide App

                                    1. Purpose of the App
                                    - The information provided is for educational purposes only and is not intended to substitute for professional medical advice, diagnosis, or treatment.

                                    2. No Substitute for Professional Advice
                                    - Always consult a healthcare professional for medical advice or decisions.
                                    - Do not use this App as the sole basis for any diagnosis or treatment.

                                    3. Limitation of Liability
                                    - The Barringer Group provides the App "as is" without any warranties, either expressed or implied.
                                    - We do not guarantee that the information is complete, accurate, or up-to-date.
                                    - The Barringer Group is not liable for any errors or omissions, or for any actions taken based on the information provided.

                                    4. User Acknowledgment and Agreement
                                    - By clicking the checkbox below, you acknowledge that you have read, understood, and agree to be legally bound by this Medical Disclaimer.
                                    - If you do not agree to these terms, do not use or register the App.

                                    Updated January 2025
                                    """)
                                //.fixedSize(horizontal: false, vertical: true)
                                //.multilineTextAlignment(.leading)
                                .font(.system(size: 18).weight(.regular))
                                .padding(.horizontal, 30)

                                
                                 Button(action: {
                                     presentationMode.wrappedValue.dismiss()
                            }) {
                                HStack{
                                    Text("Accept")
                                        .font(.system(size: 18).weight(.bold))
                                        .foregroundColor(.white)//

                                }
                                .frame(width: UIScreen.main.bounds.width, height: 50)
                            }
                            .background(Color.green)
                        
                        Button("Reject"){
                            showingAlert = true
                            
                        }
                        .background(Color.red)
                        .frame(width: UIScreen.main.bounds.width, height: 50)
                            .alert(isPresented:$showingAlert) {
                            Alert(
                                title: Text("Are you sure you want to reject this?"),
                                message: Text("There is no undo"),
                                primaryButton: .destructive(Text("Reject")) {
                                    openURL(URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                                },
                                secondaryButton: .cancel()
                            )
                     
                            }
                            .foregroundColor(.white)//
                            .background(Color.red)
                            .frame(width: UIScreen.main.bounds.width, height: 50)
                    }
                    
                }
            }
        }
        
    }
}

struct DisclaimerBtnView_Previews: PreviewProvider {
    static var previews: some View {
        DisclaimerBtnView()
    }
}
