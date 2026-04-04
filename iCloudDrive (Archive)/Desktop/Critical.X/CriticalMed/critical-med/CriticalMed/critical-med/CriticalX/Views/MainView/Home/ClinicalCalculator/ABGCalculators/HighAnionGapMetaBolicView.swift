//
//  HighAnionGapMetaBolicView.swift
//  CriticalX
//
//  Created by Macbook 4 on 09/12/2021.
//

import SwiftUI

struct HighAnionGapMetaBolicView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isActive = false
    var expectedCo2: NSAttributedString?
    var anionGap: NSAttributedString?
    
    @State var textHeight: CGFloat = 0 // <-- this for compesnation text
    @State var textHeight1: CGFloat = 0 // <-- this
    @State var textHeight2: CGFloat = 0 // <-- this

    var main_DisorderTitle_Label: String?
    var isHiddenTheoryButton: Bool?
    @Binding  var compensationText: String
    
    
    var body: some View {
        
        VStack{
//            VStack(alignment: .leading, spacing: 0){
            VStack{
                
                // MARK: End text and line
                
                VStack{
                    // Primary Disorder title banner. 
                    Text(compensationText)
                        .foregroundColor(Color.white)
                        .font(.system(size: 20, weight: .bold, design: .default))
//                        .padding(.top, 20)
//                        .padding(.leading, 20)
                }
                .frame(width: UIScreen.main.bounds.width, height: 40)
                .foregroundColor(Color.white)
                .background(Color.opal)
                .padding(.bottom, 10)
                
                
                VStack(alignment: .leading){
                    // START THE HSTACK DRAWING LINE AND TEXT
                    HStack {
                        // Drawing the line on the side in color
                        Rectangle()
                            .frame(width: 4, height: textHeight1) // <-- this
                            .foregroundColor(Color.opal)
                        
                        // Text to the right of the line
                        Text(expectedCo2 ?? NSAttributedString(""))
                            .overlay( GeometryReader { proxy in Color
                                    .clear
                                    .preference(key:ContentLengthPreference.self, value:proxy.size.height) // <-- this
                            })
                        Spacer()
                    }
                    .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
                        DispatchQueue.main.async {
                            self.textHeight1 = value
                        }
                    }
                }
                .foregroundColor(Color.charcol_gray)
                .font(.system(size: 16, weight: .medium, design: .default))
                .lineSpacing(3)
                .frame(width: UIScreen.main.bounds.width * 0.85)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 25, trailing: 15))
                
                // MARK: End text and line

                //                Text(expectedCo2 ?? "")
                //                    .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                //                    .font(.SFProRegular(ofSize: 16))
                //                    .lineSpacing(6)
                //                    .padding(.top, 15)
                
                
                
                VStack(alignment: .leading){
                    
                    // START THE HSTACK DRAWING LINE AND TEXT
                    HStack {
                        
                        // Drawing the line on the side in color
                        Rectangle()
                            .frame(width: 4, height: textHeight2) // <-- this
                            .foregroundColor(Color.royal_blue)
                        
                        // Text to the right of the line
                        Text(anionGap ?? NSAttributedString(""))
                            .overlay( GeometryReader { proxy in Color
                                    .clear
                                    .preference(key:ContentLengthPreference.self, value:proxy.size.height) // <-- this
                            })
                        Spacer()
                    }
                    .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
                        DispatchQueue.main.async {
                            self.textHeight2 = value
                        }
                    }
                }
                .foregroundColor(Color.charcol_gray)
                .font(.system(size: 16, weight: .medium, design: .default))
                .lineSpacing(3)
                .frame(width: UIScreen.main.bounds.width * 0.85)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 25, trailing: 15))

                // MARK: End text and line
    
                //                Text(anionGap ?? "")
                //                    .font(.SFProRegular(ofSize: 16))
                //                    .lineSpacing(6)
                //                    .padding(.top, 20)
            }
            .frame(width: UIScreen.main.bounds.width * 0.85)
            
            Button(action: {
                isActive = true
            }) {
                HStack{
                    Text("Theory")
                        .font(.system(size: 22, weight: .heavy, design: .default))
                        .lineSpacing(18)
                        .foregroundColor(Color.white)
                }
                .frame(width: UIScreen.main.bounds.width * 0.70, height: 55)
            }
            .background(Color.royal_blue)
            .cornerRadius(8)
            .padding(.top, 30)
            .padding(.bottom, 20)
            .opacity(isHiddenTheoryButton ?? false ? 0 : 1)
            .shadow(radius: 8,y:12)
            .animation(.easeInOut, value: 1.0)
            .background(
                NavigationLink(
                    destination: TheoryButtonDetailView(
                        interpretationLabel: NSAttributedString(""),
                        criticalPearl: NSAttributedString(""),
                        differentialsLabel: NSAttributedString(""),
                        main_DisorderTitle_Label: main_DisorderTitle_Label
                    )
                    .navigationBarBackground { Color.logoBlue.shadow(radius: 1) },
                    isActive: $isActive
                ) { EmptyView() }
                    .hidden()
            )
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.95)
        .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
        //.shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
        .cornerRadius(8)
        .padding(.top, 10)
        .shadow(radius: 8,y:12)

    }
}

struct HighAnionGapMetaBolicView_Previews: PreviewProvider {
    
    static var previews: some View {

        HighAnionGapMetaBolicView(expectedCo2: NSAttributedString("This is the expected C02"), anionGap: NSAttributedString("This is a high anion Gap"), isHiddenTheoryButton: false, compensationText: .constant(""))
    }
}
