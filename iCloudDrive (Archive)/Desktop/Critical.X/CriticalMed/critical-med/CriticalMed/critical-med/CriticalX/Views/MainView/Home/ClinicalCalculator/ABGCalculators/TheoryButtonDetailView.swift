//
//  TheoryButtonDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 02/02/2022.
//

import SwiftUI
// import SwiftUITrackableScrollView



//struct TheoryButtonDetailView: View {
//    @Environment(\.colorScheme) var colorScheme
//    
//    // States for the text heights
//    @State var textHeight: CGFloat = 0 // <-- this
//    @State var textHeight1: CGFloat = 0 // <-- this
//    @State var textHeight2: CGFloat = 0 // <-- this
//    @State private var scrollViewContentOffset = CGFloat(0)
//
//    @State public var titleLabel: String = ""
//    @State public var disturbanceTitle: String = ""
//    @State public var interpretationLabel: NSAttributedString
//    @State var criticalPearl: NSAttributedString
//    @State var differentialsLabel: NSAttributedString
//    @State var interpretationInfo: String = pushPhcondition + pushC02condition + pushHC03condition
//    
//    var main_DisorderTitle_Label: String?
    
//    var body: some View {
//        
//        ZStack{
//            Color.homeBackgroundColor.edgesIgnoringSafeArea(.all)
//            TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
//                
//                VStack{
//                    
//                    Text(main_DisorderTitle_Label ?? "")
//                        .foregroundColor(Color.red)
//                        .padding(.top, 20)
//                        .multilineTextAlignment(.leading)
//                    
//                    VStack{
//                      
//                        VStack(alignment: .leading){
//                        
//                            Text("Analysis 💭")
//                                .foregroundColor(Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)))
//                                .font(.system(size: 20, weight: .semibold, design: .default))
//                                .padding(.top, 25)
//                                .padding(.leading, 20)
//                            
//                            // Start drawing line and text.
//                            HStack {
//                                // Drawing the line on the side in color
//                                Rectangle()
//                                    .frame(width: 4, height: textHeight) // <-- this
//                                    .foregroundColor(Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)))
//                                // Text to the right of the line
//                                Text(interpretationLabel ?? NSAttributedString(""))
//                                    .overlay( GeometryReader { proxy in Color
//                                            .clear
//                                            .preference(key:ContentLengthPreference.self, value:proxy.size.height) // <-- this
//                                    })
//                            }
//                            .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
//                                DispatchQueue.main.async {
//                                    self.textHeight = value
//                                }
//                            }
//                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))                            .font(.system(size: 16, weight: .medium, design: .default))
//                            .lineSpacing(3)
//                            .frame(width: UIScreen.main.bounds.width * 0.85)
//                            
//                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 25, trailing: 25))
//                            
//                            // MARK: End text and line
//                            
//                            
//                            //                            Text(interpretationLabel.string)
//                            //                                .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
//                            //                                .font(.SFProRegular(ofSize: 16))
//                            //                                .frame(width: UIScreen.main.bounds.width * 0.85)
//                            //                                .lineSpacing(3)
//                            //                                .padding(.bottom, 20)
//                        }
//                    }
//                    .frame(width: UIScreen.main.bounds.width * 0.95)
//                    .background(Color.white)
//                    .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 4, x: 0, y: 4)
//                    .cornerRadius(8)
//                    
//                    VStack(alignment: .leading){
//                       
//                        Text("Differential DX'S 💡")
//                            .foregroundColor(Color.paoloVeronese_green)
//                            .font(.system(size: 20, weight: .semibold, design: .default))
//                            .padding(.leading, 20)
//                            .padding(.top, 25)
//                        
//                        
//                        // Start drawing line and text.
//                        HStack {
//                            // Drawing the line on the side in color
//                            Rectangle()
//                                .frame(width: 4, height: textHeight1) // <-- this
//                                .foregroundColor(Color.paoloVeronese_green)
//                            // Text to the right of the line
//                            Text(differentialsLabel ?? NSAttributedString(""))
//                                .overlay( GeometryReader { proxy in Color
//                                        .clear
//                                        .preference(key:ContentLengthPreference.self, value:proxy.size.height) // <-- this
//                                })
//                        }
//                        .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
//                            DispatchQueue.main.async {
//                                self.textHeight1 = value
//                            }
//                        }
//                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
//                        .font(.system(size: 16, weight: .medium, design: .default))
//                        .lineSpacing(3)
//                        .frame(width: UIScreen.main.bounds.width * 0.85)
//                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 25, trailing: 25))
//                        
//                        // MARK: End text and line
//                        
////                        Text(differentialsLabel.string)
////                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
////                            .font(.SFProRegular(ofSize: 16))
////                            .frame(width: UIScreen.main.bounds.width * 0.85)
////                            .lineSpacing(3)
////                            .padding(.bottom, 20)
////                            .padding(.top, 15)
//                    }
//                    .frame(width: UIScreen.main.bounds.width * 0.95)
//                    .background(Color.white)
//                    .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 4, x: 0, y: 4)
//                    .cornerRadius(8)
//                    
//                    VStack{
//                        VStack(alignment: .leading){
//                            Text("Critical Pearls 🌟")
//                                .foregroundColor(Color.red)
//                                .font(.system(size: 20, weight: .semibold, design: .default))
//                                .padding(.top, 25)
//                                .padding(.leading, 20)
//
//                            // Start drawing line and text.
//                            HStack {
//                                // Drawing the line on the side in color
//                                Rectangle()
//                                    .frame(width: 4, height: textHeight2) // <-- this
//                                    .foregroundColor(Color.red)
//                                // Text to the right of the line
//                                Text(criticalPearl ?? NSAttributedString(""))
//                                    .overlay( GeometryReader { proxy in Color
//                                            .clear
//                                            .preference(key:ContentLengthPreference.self, value:proxy.size.height) // <-- this
//                                    })
//                            }
//                            .onPreferenceChange(ContentLengthPreference.self) { value in // <-- this
//                                DispatchQueue.main.async {
//                                    self.textHeight2 = value
//                                }
//                            }
//                            .foregroundColor(Color.charcol_gray)                            .font(.system(size: 16, weight: .medium, design: .default))
//                            .lineSpacing(3)
//                            .frame(width: UIScreen.main.bounds.width * 0.85)
//                            
//                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 25, trailing: 25))
//                            
//                            // MARK: End text and line
//                            
////                            Text(criticalPearl.string)
////                                .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
////                                .font(.system(size: 16, weight: .bold, design: .default))
////                                .frame(width: UIScreen.main.bounds.width * 0.85)
////                                .lineSpacing(3)
////                                .padding(.bottom, 20)
//                        }
//                        .frame(width: UIScreen.main.bounds.width * 0.95)
//                        //.background(BlurView(style: .systemChromeMaterialDark))
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 4, x: 0, y: 4)
//                        .cornerRadius(8)
//                    }
//                    
//                } // main Vstack
//            } // scroll view
//            if scrollViewContentOffset > 50 {
//                VStack{
//                    ZStack {
//                        
//                        HStack {
//                            
//                            // Image on the LEft
//                            Image(systemName: "staroflife.circle")
//                                .resizable()
//                                .symbolRenderingMode(.palette)
//                                .foregroundStyle((Color.royal_blue), (Color.red ))
//                                .frame(width: 22, height: 22)
//                                .scaledToFill()
//                               // .padding(.leading, 8)
//                            
//                           // Name of the drug comes after the image.
//                            Text(main_DisorderTitle_Label ?? "")
//                                .font(.system(size: 18, weight: .semibold, design: .default))
//                                .foregroundColor(Color.red)
//                                .fixedSize(horizontal: false, vertical: true)
//                            //No need to set frame. It dynamically adjusts
//                            //.frame(width: Text.width, height: 40)
//                                
//                            //.multilineTextAlignment(.center)
//                        }
//                        .padding(.all, 15)
//                        .background(
//                            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                            //.foregroundColor(Color.criticalBlue).opacity(0.6)
//                                .foregroundStyle(.ultraThinMaterial)
//                                .padding(0)
//                        )
//                        .animation(.easeInOut(duration: 0.5))
//                    }
//                    Spacer()
//                }
//                .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .leading)
//                .shadow(radius: 8)
//                .padding(.top, 30)
//            }
//
//        } // zstack
//        .navigationTitle("Theory")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            didLoad()
//        }
//         
//    }
//}



    // MARK: - Modern Card Component
struct ModernCard: View {
    let title: String
    let titleColor: Color
    let content: NSAttributedString
    let lineColor: Color
    @Binding var textHeight: CGFloat
    
    // Neumorphic colors
    private let backgroundColor = Color(UIColor.systemBackground)
    private let shadowColor = Color.black.opacity(0.2)
    private let highlightColor = Color.white.opacity(0.7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Card Header
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(titleColor)
                .padding(.top, 24)
                .padding(.horizontal, 24)
            
            // Content with Line
            HStack(spacing: 16) {
                Rectangle()
                    .frame(width: 4, height: textHeight)
                    .foregroundColor(lineColor)
                
                Text(AttributedString(content))
                    .overlay(GeometryReader { proxy in
                        Color.clear.preference(
                            key: ContentLengthPreference.self,
                            value: proxy.size.height
                        )
                    })
                    .font(.system(size: 16, weight: .regular, design: .default))
                    .lineSpacing(6)
                    .padding(.vertical, 20)
            }
            .padding(.horizontal, 20)
            .onPreferenceChange(ContentLengthPreference.self) { value in
                DispatchQueue.main.async {
                    self.textHeight = value
                }
            }
        }
        .background(
            NeumorphicBackground()
        )
        .padding(.horizontal, 2) // Add padding to prevent shadow clipping
    }
}

// Neumorphic Background Component
struct NeumorphicBackground: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color(UIColor.systemBackground))
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(colorScheme == .dark ? 0.05 : 0.7), radius: 10, x: -5, y: -5)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color(UIColor.systemBackground), lineWidth: 2)
                    .blur(radius: 4)
                    .offset(x: -1, y: -1)
                    .mask(RoundedRectangle(cornerRadius: 24).fill(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .topLeading, endPoint: .bottomTrailing)))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(colorScheme == .dark ? 0.08 : 0.5), lineWidth: 2)
                    .blur(radius: 4)
                    .offset(x: 1, y: 1)
                    .mask(RoundedRectangle(cornerRadius: 24).fill(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)))
            )
    }
}

// Neumorphic colors are now defined in Extensions.swift

// For even more advanced neumorphism, you can add this pressed state effect
struct PressableButton: View {
    let action: () -> Void
    let content: AnyView
    @State private var isPressed = false
    
    var body: some View {
        content
            .scaleEffect(isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in
                        isPressed = false
                        action()
                    }
            )
    }
}

// Usage example with pressable effect
struct NeumorphicCard: View {
    @State private var isPressed = false
    
    var body: some View {
        PressableButton(action: {
            // Handle tap
        }, content: AnyView(
            ModernCard(
                title: "Analysis 💭",
                titleColor: Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)),
                content: NSAttributedString(string: "Content"),
                lineColor: Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)),
                textHeight: .constant(100)
            )
        ))
    }
}

    // MARK: - Floating Header Component
    struct FloatingHeader: View {
        let title: String
        
        var body: some View {
            VStack {
                HStack(spacing: 12) {
                    Image(systemName: "staroflife.circle.fill")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.royal_blue, Color.red)
                        .frame(width: 24, height: 24)
                    
                    Text(title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.red)
                        .lineLimit(1)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: true)
        }
    }

    // MARK: - Main View
    struct TheoryButtonDetailView: View {
        @Environment(\.colorScheme) var colorScheme

        // States for the text heights
        @State var textHeight: CGFloat = 0
        @State var textHeight1: CGFloat = 0
        @State var textHeight2: CGFloat = 0
        @State private var scrollViewContentOffset = CGFloat(0)
        
        @State public var titleLabel: String = ""
        @State public var disturbanceTitle: String = ""
        @State public var interpretationLabel: NSAttributedString
        @State var criticalPearl: NSAttributedString
        @State var differentialsLabel: NSAttributedString
        @State var interpretationInfo: String = pushPhcondition + pushC02condition + pushHC03condition
        
        var main_DisorderTitle_Label: String?
        
        var body: some View {
            ZStack {
                       // Use a subtle gradient background
                       LinearGradient(
                           gradient: Gradient(colors: [
                               Color(UIColor.systemBackground),
                               Color(UIColor.systemBackground).opacity(0.95)
                           ]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing
                       )
                       .edgesIgnoringSafeArea(.all)
                
                TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                              VStack(spacing: 32) { // Increased spacing for better neumorphic effect
                                  // Title
                                  Text(main_DisorderTitle_Label ?? "Acid Base Disturbance")
                                      .font(.system(size: 28, weight: .bold, design: .rounded))
                                      .foregroundColor(Color.red)
                                      .frame(maxWidth: .infinity, alignment: .leading)
                                      .padding(.horizontal, 24)
                                      .padding(.top, 20)
                                  
                                  // Analysis Card with Neumorphic effect
                                  PressableButton(action: {}, content: AnyView(
                                      ModernCard(
                                          title: "Analysis 💭",
                                          titleColor: Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)),
                                          content: interpretationLabel,
                                          lineColor: Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)),
                                          textHeight: $textHeight
                                      )
                                  ))
                        // Differential Card
                        ModernCard(
                            title: "Differential DX'S 💡",
                            titleColor: Color.paoloVeronese_green,
                            content: differentialsLabel,
                            lineColor: Color.paoloVeronese_green,
                            textHeight: $textHeight1
                        )
                        
                        // Critical Pearls Card
                        ModernCard(
                            title: "Critical Pearls 🌟",
                            titleColor: Color.red,
                            content: criticalPearl,
                            lineColor: Color.red,
                            textHeight: $textHeight2
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 25)
                }
                
                // Floating Header
                if scrollViewContentOffset > 50 {
                    FloatingHeader(title: main_DisorderTitle_Label ?? "")
                }
            }
            .navigationTitle("Theory")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { didLoad() }
        }
    }

    // MARK: - Preview Provider
    struct TheoryButtonDetailView_Previews: PreviewProvider {
        static var previews: some View {
            TheoryButtonDetailView(
                interpretationLabel: NSAttributedString("Sample interpretation"),
                criticalPearl: NSAttributedString("Sample critical pearl"),
                differentialsLabel: NSAttributedString("Sample differentials")
            )
        }
    }



extension TheoryButtonDetailView {
    
    func didLoad() {
        
        titleLabel = main_DisorderTitle_Label ?? ""
        let abgInterpretation =  interpretationInfo
        
        // Setting the attriubte to the string
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: abgInterpretation)
        
        //1  Change the color of a word in the string
        attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "Blood Gas Analysis:")
        attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Blood Gas Analysis:")
        
        // Takes the interpretation strings from the input values and displays it
        //interpretationLabel.text = "ABG Interpretation: " + "\n" + interpretationInfo
        interpretationLabel = attributedText
        
        disturbanceTitle = titleLabel
        
        
        //MARK: - Switch TitleLabel
        // Switch on the title and if it matches the disorder, set label to the enum description below.
        switch titleLabel {
            
        case "No acid-base disorder" :
            
            let abgInterpretation = "" + "\n" + interpretationInfo  + "\nHowever, with an ⬆︎ AG present, a normal pH and pC02 can't full exclude a mixed metabolic disorder. In the case where the patient has a normal ABG and a positive anion gap, consider the following differentials."
            
            // Setting the attriubte to the string
            let attributedText_A = NSMutableAttributedString.getAttributedString(fromString: abgInterpretation)
            
            // Delcare the font to be used and set it to the text
            let customFont  = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
            
            //1  Change the color of a word in the string
            attributedText_A.apply(color: UIColor(Color.orange_TerraCotta), subString: "Blood Gas Analysis:")
            
            attributedText_A.apply(font: customFont!, subString: "Blood Gas Analysis:")
            
            
            interpretationLabel = attributedText_A
            
            // Initialize the second text attribute.
            let normal = Result.Normal.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: normal)
            
            //1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "POSITIVE ANION GAP:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "POSITIVE ANION GAP:")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "NORMAL ANION GAP METABOLIC ACIDOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "NORMAL ANION GAP METABOLIC ACIDOSIS")
            
            // 3
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "GLYCOL:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GLYCOL:")
            
            // 4
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "OXOPROLINE:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "OXOPROLINE:")
            //5
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "LACTIC ACIDOSIS:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "LACTIC ACIDOSIS:")
            //6
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "D-LACTATE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "D-LACTATE")
            //7
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "METHANOL:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "METHANOL:")
            //8
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "ASPIRIN:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "ASPIRIN:")
            //9
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "RENAL FAILURE:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "RENAL FAILURE:")
            //10
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "KETOACIDOSIS:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "KETOACIDOSIS:")
            
            //11
            attributedText.apply(color: #colorLiteral(red: 0.987544477, green: 0.6673021617, blue: 0, alpha: 1), subString: "GOLD MARK")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GOLD MARK")
            
            // Set the text labels.
            differentialsLabel = attributedText
            
            // changes the critical pearls attributes with this function
            changeMetabolicAcidosisTextAttributes_CriticalPearls()
            
            #if DEBUG
            print("Acute Metabolic Acidosis")
            #endif



        case "Acute Metabolic Acidosis":
            
            let metabolicAcidosis = Result.metabolic_ACIDOSIS.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: metabolicAcidosis)
            
            //1
            attributedText.apply(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), subString: "POSITIVE ANION GAP:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "POSITIVE ANION GAP:")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "NORMAL ANION GAP METABOLIC ACIDOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "NORMAL ANION GAP METABOLIC ACIDOSIS")
            
            // 3
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "GLYCOL:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GLYCOL:")
            
            // 4
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "OXOPROLINE:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "OXOPROLINE:")
            //5
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "LACTIC ACIDOSIS:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "LACTIC ACIDOSIS:")
            //6
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "D-LACTATE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "D-LACTATE")
            //7
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "METHANOL:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "METHANOL:")
            //8
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "ASPIRIN:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "ASPIRIN:")
            //9
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "RENAL FAILURE:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "RENAL FAILURE:")
            //10
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "KETOACIDOSIS:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "KETOACIDOSIS:")
            
            //11
            attributedText.apply(color: #colorLiteral(red: 0.987544477, green: 0.6673021617, blue: 0, alpha: 1), subString: "GOLD MARK")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GOLD MARK")
            
            
            
            differentialsLabel = attributedText
            
            //differentialsLabel.text = Result.metabolic_ACIDOSIS.explain()
            
            // changes the critical pearls attributes with this function
            changeMetabolicAcidosisTextAttributes_CriticalPearls()
            
            #if DEBUG
            print("Acute Metabolic Acidosis")
            #endif

        case "Compensated Metabolic Acidosis":
            
            // Execte code
            let metabolicAcidosis = Result.metabolic_ACIDOSIS.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: metabolicAcidosis)
            
            //1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "POSITIVE ANION GAP:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "POSITIVE ANION GAP:")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "NORMAL ANION GAP METABOLIC ACIDOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "NORMAL ANION GAP METABOLIC ACIDOSIS")
            
            // 3
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "GLYCOL:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GLYCOL:")
            
            // 4
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "OXOPROLINE:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "OXOPROLINE:")
            //5
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "LACTIC ACIDOSIS:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "LACTIC ACIDOSIS:")
            //6
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "D-LACTATE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "D-LACTATE")
            //7
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "METHANOL:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "METHANOL:")
            //8
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "ASPIRIN:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "ASPIRIN:")
            //9
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "RENAL FAILURE:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "RENAL FAILURE:")
            //10
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "KETOACIDOSIS:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "KETOACIDOSIS:")
            
            //11
            //11
            attributedText.apply(color: #colorLiteral(red: 0.987544477, green: 0.6673021617, blue: 0, alpha: 1), subString: "GOLD MARK")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GOLD MARK")
            
            
            
            // Set the label to the attributes
            differentialsLabel = attributedText
            
            //differentialsLabel.text = Result.metabolic_ACIDOSIS_Compensated.explain()
            
            // changes the critical pearls attributes with this function
            changeMetabolicAcidosisTextAttributes_CriticalPearls()
            
            #if DEBUG
            print("Compensated Metabolic Acidosis")
            #endif

        case "Partially Compensated Metabolic Acidosis":
            
            let metabolicAcidosis = Result.metabolic_ACIDOSIS.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: metabolicAcidosis)
            
            //1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "POSITIVE ANION GAP:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "POSITIVE ANION GAP:")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "NORMAL ANION GAP METABOLIC ACIDOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "NORMAL ANION GAP METABOLIC ACIDOSIS")
            
            // 3
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "GLYCOL:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GLYCOL:")
            
            // 4
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "OXOPROLINE:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "OXOPROLINE:")
            //5
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "LACTIC ACIDOSIS:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "LACTIC ACIDOSIS:")
            //6
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "D-LACTATE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "D-LACTATE")
            //7
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "METHANOL:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "METHANOL:")
            //8
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "ASPIRIN:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "ASPIRIN:")
            //9
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "RENAL FAILURE:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "RENAL FAILURE:")
            //10
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "KETOACIDOSIS:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "KETOACIDOSIS:")
            
            //11
            attributedText.apply(color: #colorLiteral(red: 0.987544477, green: 0.6673021617, blue: 0, alpha: 1), subString: "GOLD MARK")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GOLD MARK")
            
            
            
            differentialsLabel = attributedText
            
            // changes the critical pearls attributes with this function
            changeMetabolicAcidosisTextAttributes_CriticalPearls()
            
            
            // differentialsLabel.text = Result.metabolic_ACIDOSIS_Partially_Compensated.explain()
            //criticalPearl.text = Result.metabolic_ACIDOSIS_Partially_Compensated.clinicalPearls()
            #if DEBUG
            print("Partially Compensated Metabolic Acidosis")
            #endif

        case "Acute Metabolic Alkalosis":
            
            // Set the string to change
            let metabolicAlk = Result.metabolic_ALKALOSIS.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: metabolicAlk)
            
            // What to change inside of the explanation ??
            // 1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "METABOLIC ALKALOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "METABOLIC ALKALOSIS")
            
            // 2
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "GROE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GROE")
            
            
            // 3
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "G- GIT excess acid loss")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "G- GIT excess acid loss")
            
            // 4
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "R- RENAL EXCESS ACID LOSS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "R- RENAL EXCESS ACID LOSS")
            
            // 5
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "O- OVERDOSE OF BASE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "O- OVERDOSE OF BASE")
            
            // 6
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "E- ENDOCRINE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "E- ENDOCRINE")
            
            // Set the label to the changed attributed string
            differentialsLabel = attributedText
            //differentialsLabel.text = Result.metabolic_ALKALOSIS.explain()
            //criticalPearl.text = Result.metabolic_ALKALOSIS.clinicalPearls()
            criticalAttributes_CompensatedMetabolic_Alkalosis()
            
            #if DEBUG
            print("Acute Metabolic Alkalosis")
            #endif

        case "Partially Compensated Metabolic Alkalosis":
            // Set the string to change
            let metabolicAlk = Result.metabolic_ALKALOSIS.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: metabolicAlk)
            
            // 1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "METABOLIC ALKALOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "METABOLIC ALKALOSIS")
            
            // 2
            attributedText.apply(color: UIColor(Color.FBI_Blue), subString: "GROE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GROE")
            
            
            // 3
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "G- GIT excess acid loss")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "G- GIT excess acid loss")
            
            // 4
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "R- RENAL EXCESS ACID LOSS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "R- RENAL EXCESS ACID LOSS")
            
            // 5
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "O- OVERDOSE OF BASE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "O- OVERDOSE OF BASE")
            
            // 6
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "E- ENDOCRINE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "E- ENDOCRINE")
            
            // Set the attributes label
            differentialsLabel = attributedText
            
            //differentialsLabel.text = Result.metabolic_ALKALOSIS_Partially_Compensated.explain()
            //criticalPearl.text = Result.metabolic_ALKALOSIS_Partially_Compensated.clinicalPearls()
            criticalAttributes_CompensatedMetabolic_Alkalosis()
            
            #if DEBUG
            print("Partially Compensated Metabolic Alkalosis")
            #endif

        case "Compensated Metabolic Alkalosis":
            
            // Set the string to change
            let metabolicAlk = Result.metabolic_ALKALOSIS.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: metabolicAlk)
            
            // 1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "METABOLIC ALKALOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "METABOLIC ALKALOSIS")
            
            // 2
            attributedText.apply(color: UIColor(Color.orange_TerraCotta), subString: "GROE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "GROE")
            
            
            // 3
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "G- GIT excess acid loss")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "G- GIT excess acid loss")
            
            // 4
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "R- RENAL EXCESS ACID LOSS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "R- RENAL EXCESS ACID LOSS")
            
            // 5
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "O- OVERDOSE OF BASE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "O- OVERDOSE OF BASE")
            
            // 6
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "E- ENDOCRINE")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "E- ENDOCRINE")
            
            
            // Set the attributes label
            differentialsLabel = attributedText
            criticalAttributes_CompensatedMetabolic_Alkalosis()
            //differentialsLabel.text = Result.metabolic_ALKALOSIS_Compensated.explain()
            //  criticalPearl.text = Result.metabolic_ALKALOSIS_Compensated.clinicalPearls()
            
            #if DEBUG
            print("Compensated Metabolic Alkalosis")
            #endif


        case "Acute Respiratory Acidosis":
            
            // Set the attributed text here.
            let respAcidosis = Result.Resp_ACIDOSIS.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: respAcidosis)
            
            // Change the colors of the individual words within the text
            //1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Respiratory ACIDOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Respiratory ACIDOSIS")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Hypercatabolic disorders such as:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Hypercatabolic disorders such as:")
            
            //3
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Any decreased alveolar ventilatory state with or without any compensatory increase in HC03.")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Any decreased alveolar ventilatory state with or without any compensatory increase in HC03.")
            
            // Set the text label to the attrubuted text that we changed.
            differentialsLabel = attributedText
            
            // The func runs, sets and changes the critical pearls text with colors etc
            changeRespAcidosisTextAttributes_CriticalPearls()
            
            #if DEBUG
            print("Acute Respiratory Acidosis")
            #endif


        case "Partially Compensated Respiratory Acidosis":
            
            let respAcidosis = Result.Resp_ACIDOSIS_Partially_Compensated.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: respAcidosis)
            
            // Change the colors of the individual words within the text
            //1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Respiratory ACIDOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Respiratory ACIDOSIS")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Hypercatabolic disorders such as:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Hypercatabolic disorders such as:")
            
            //3
            attributedText.apply(color: UIColor(Color.jonquil_Gold), subString: "Any decreased alveolar ventilatory state with or without any compensatory increase in HC03.")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Any decreased alveolar ventilatory state with or without any compensatory increase in HC03.")
            
            // Set the text label to the attrubuted text that we changed.
            differentialsLabel = attributedText
            
            // The func runs, sets and changes the critical pearls text with colors etc
            changeRespAcidosisTextAttributes_CriticalPearls()
            
            #if DEBUG
            print("Partially Compensated Respiratory Acidosis")
            #endif

        case "Compensated Respiratory Acidosis":
            
            let respAcidosis = Result.Resp_ACIDOSIS_Compensated.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: respAcidosis)
            
            // Change the colors of the individual words within the text
            //1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Respiratory ACIDOSIS")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Respiratory ACIDOSIS")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Hypercatabolic disorders such as:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Hypercatabolic disorders such as:")
            
            //3
            attributedText.apply(color: UIColor(Color.BlueYonder), subString: "Any decreased alveolar ventilatory state with or without any compensatory increase in HC03.")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 15), subString: "Any decreased alveolar ventilatory state with or without any compensatory increase in HC03.")
            
            differentialsLabel = attributedText
            
            // The func runs, sets and changes the critical pearls text with colors etc
            changeRespAcidosisTextAttributes_CriticalPearls()
            
            #if DEBUG
            print("Compensated Respiratory Acidosis")
            #endif

        case "Acute Respiratory Alkalosis":
            
            let respAlkalosis = Result.Resp_ALKALOSIS.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: respAlkalosis)
            
            // Change the colors of the individual words within the text
            
            //1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Respiratory factors:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 16), subString: "Respiratory factors:")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Stimulation of the Central Nervous System due to:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 16), subString: "Stimulation of the Central Nervous System due to:")
            
            
            differentialsLabel = attributedText
            // Change the attributes of the clinical perls to  bold and dark
            change_Resp_Alkalosis_TextAttributes_CriticalPearls()
            
            //criticalPearl.text = Result.Resp_ALKALOSIS.clinicalPearls()
            
            #if DEBUG
            print("Acute Respiratory Alkalosis")
            #endif

        case "Partially Compensated Respiratory Alkalosis":
            
            let respAlkalosis = Result.Resp_ALKALOSIS_Partially_Compensated.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: respAlkalosis)
            
            // Change the colors of the individual words within the text
            
            //1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Respiratory factors:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 16), subString: "Respiratory factors:")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Stimulation of the Central Nervous System due to:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 16), subString: "Stimulation of the Central Nervous System due to:")
            
            //3
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString:  "Minute Ventilation - RR x TV")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 16), subString:  "Minute Ventilation - RR x TV")
            differentialsLabel = attributedText
            // Change the attributes of the clinical perls to  bold and dark
            change_Resp_Alkalosis_TextAttributes_CriticalPearls()
            
            #if DEBUG
            print("Partially Compensated Respiratory Alkalosis")
            #endif

        case "Compensated Respiratory Alkalosis":
            
            
            let respAlkalosis = Result.Resp_ALKALOSIS_Compensated.explain()
            let attributedText = NSMutableAttributedString.getAttributedString(fromString: respAlkalosis)
            
            // Change the colors of the individual words within the text
            
            //1
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Respiratory factors:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 16), subString: "Respiratory factors:")
            
            //2
            attributedText.apply(color:UIColor(Color.orange_TerraCotta), subString: "Stimulation of the Central Nervous System due to:")
            attributedText.apply(font: UIFont.boldSystemFont(ofSize: 16), subString: "Stimulation of the Central Nervous System due to:")
            
            
            differentialsLabel = attributedText
            // Change the attributes of the clinical perls to  bold and dark
            change_Resp_Alkalosis_TextAttributes_CriticalPearls()
            
            #if DEBUG
            print("Compensated Respiratory Alkalosis")
            #endif


            //MIXED Disturbances 1.
        case "Metabolic & Respiratory Acidosis" :
            #if DEBUG
            print("Mixed disturbance 1 pushed")
            #endif
            
            mixedDisturbance1_Explain()
            
            mixedDisturbance1_CriticalPearls()
            
            
            //MARK: - Mixed Disturbance 2
        case "Mixed Metabolic & Respiratory Alkalosis" :
            #if DEBUG
            print("Mixed disturbance 2 pushed")
            #endif
            
            // Runs the attributes func from the extension to change the colors
            mixedDisturbance2_Explain()
            mixedDisturbance2_CriticalPearls()
            
            
        case "Metabolic Acidosis & Respiratory Alkalosis" :
            
            changeAttributes_MixedResp_MetabolicAcidosis()
            
            // Display the clinical pearls attributes set by the func
            change_MetabolicAcid_RespAlkalosis_CriticalPearls()
            
            // MARK Mixed Disturbance 4
        case  "Metabolic Alkalosis & Respiratory Acidosis":
            mixedDisturbance4_Explain()
            mixedDisturbance4_CriticalPearls()
            
            
        default:
            break
        }
    } // end didLoad function
}


// Explanations for the disorder.
extension TheoryButtonDetailView {
    
    
    //MARK: - Enums and functions for the different disorders
    enum Result {
        
        case metabolic_ACIDOSIS
        case metabolic_ACIDOSIS_Compensated
        case metabolic_ACIDOSIS_Partially_Compensated
        
        case metabolic_ALKALOSIS
        case metabolic_ALKALOSIS_Compensated
        case metabolic_ALKALOSIS_Partially_Compensated
        
        case Resp_ACIDOSIS
        case Resp_ACIDOSIS_Compensated
        case Resp_ACIDOSIS_Partially_Compensated
        
        case Resp_ALKALOSIS
        case Resp_ALKALOSIS_Compensated
        case Resp_ALKALOSIS_Partially_Compensated
        case Mixed_Metabolic_Resp_Acidosis
        case Mixed_Metabolic_Resp_ALKALOSIS
        case Mixed_MetabolicAcidosis_RespAlkalosis
        case Metabolic_Alkalosis_Respiratory_Acidosis
        case Normal
        
        
        
        //MARK: - Reasons to why there's the disorder.
        func explain() -> String {
            switch self {
                
                // Metabolic disorders
                
                //MARK: - Normal . This will only have a metabolic process because the AG can only be entered.
            case .Normal :
                return """
                POSITIVE ANION GAP: GOLD MARK (+ STS)
                \rGLYCOL: Ethylene and propylene glycol, calcium oxalate crystals, (anti-freeze), and glycolic acid.
                \rOXOPROLINE: Metabolite of acetaminophen-associated with chronic acetaminophen use, often by malnourished women.
                \rLACTIC ACIDOSIS: Check serum lactate. Correct hypoperfusion/hypotension.
                \rD-LACTATE: Which can occur in some with short bowel syndromes.
                \rMETHANOL: Formic acid, formaldehyde, optic papillitis, and metformin.
                \rASPIRIN: Aspirin OD. Initially will have a respiratory alkalosis, which develops into a metabolic acidosis. Alkalinize the urine.
                \rRENAL FAILURE: Any hypoperfusion.
                \rKETOACIDOSIS: From alcohol, diabetes (hyperglycemia and low serum HC03 is life-threatening), starvation - check serum ketones.
                \r(STS) SODIUM THIOSULFATE: Emerging cause (2024) - can cause HAGMA in patients receiving STS therapy for calciphylaxis or cyanide poisoning.
                
                NORMAL ANION GAP METABOLIC ACIDOSIS
                \rInfusions such as NaCl, TPN or NH4+, diarrhea due to the increasing loss of bicarbonate from the colon, Aldosterone Inhibitors, ATN, CKD, GI and Renal loss of HC03+. Renal Tubular Acidosis (RTA).
                """
                
                //MARK: - Metabolic Acidosis
            case .metabolic_ACIDOSIS:
                
                return """
                POSITIVE ANION GAP: GOLD MARK (+ STS)
                \rGLYCOL: Ethylene and propylene glycol, calcium oxalate crystals, (anti-freeze), and glycolic acid.
                \rOXOPROLINE: Metabolite of acetaminophen-associated with chronic acetaminophen use, often by malnourished women.
                \rLACTIC ACIDOSIS: Check serum lactate. Correct hypoperfusion/hypotension.
                \rD-LACTATE: Which can occur in some with short bowel syndromes.
                \rMETHANOL: Formic acid, formaldehyde, optic papillitis, and metformin.
                \rASPIRIN: Aspirin OD. Initially will have a respiratory alkalosis, which develops into a metabolic acidosis. Alkalinize the urine.
                \rRENAL FAILURE: Any hypoperfusion.
                \rKETOACIDOSIS: From alcohol, diabetes (hyperglycemia and low serum HC03 is life-threatening), starvation - check serum ketones.
                \r(STS) SODIUM THIOSULFATE: Emerging cause (2024) - can cause HAGMA in patients receiving STS therapy for calciphylaxis or cyanide poisoning.
                
                NORMAL ANION GAP METABOLIC ACIDOSIS
                \rInfusions such as NaCl, TPN or NH4+, diarrhea due to the increasing loss of bicarbonate from the colon, Aldosterone Inhibitors, ATN, CKD, GI and Renal loss of HC03+. Renal Tubular Acidosis (RTA).
                """
                
                //MARK: - Metabolic  compensated Acidosis
            case .metabolic_ACIDOSIS_Compensated:
                return """
                POSITIVE ANION GAP: GOLD MARK (+ STS)
                \rGLYCOL: Ethylene and propylene glycol, calcium oxalate crystals, (anti-freeze), and glycolic acid.
                \rOXOPROLINE: Metabolite of acetaminophen-associated with chronic acetaminophen use, often by malnourished women.
                \rLACTIC ACIDOSIS: Check serum lactate. Correct hypoperfusion/hypotension.
                \rD-LACTATE: Which can occur in some with short bowel syndromes.
                \rMETHANOL: Formic acid, formaldehyde, optic papillitis, and metformin.
                \rASPIRIN: Aspirin OD. Initially will have a respiratory alkalosis, which develops into a metabolic acidosis. Alkalinize the urine.
                \rRENAL FAILURE: Any hypoperfusion.
                \rKETOACIDOSIS: From alcohol, diabetes (hyperglycemia and low serum HC03 is life-threatening), starvation - check serum ketones.
                \r(STS) SODIUM THIOSULFATE: Emerging cause (2024) - can cause HAGMA in patients receiving STS therapy for calciphylaxis or cyanide poisoning.
                
                NORMAL ANION GAP METABOLIC ACIDOSIS
                \rInfusions such as NaCl, TPN or NH4+, diarrhea due to the increasing loss of bicarbonate from the colon, Aldosterone Inhibitors, ATN, CKD, GI and Renal loss of HC03+. Renal Tubular Acidosis (RTA).
                """
                
                
                //MARK: - Metabolic  Partially compensated Acidosis
            case .metabolic_ACIDOSIS_Partially_Compensated:
                return """
                POSITIVE ANION GAP: GOLD MARK (+ STS)
                \rGLYCOL: Ethylene and propylene glycol, calcium oxalate crystals, (anti-freeze), and glycolic acid.
                \rOXOPROLINE: Metabolite of acetaminophen-associated with chronic acetaminophen use, often by malnourished women.
                \rLACTIC ACIDOSIS: Check serum lactate. Correct hypoperfusion/hypotension.
                \rD-LACTATE: Which can occur in some with short bowel syndromes.
                \rMETHANOL: Formic acid, formaldehyde, optic papillitis, and metformin.
                \rASPIRIN: Aspirin OD. Initially will have a respiratory alkalosis, which develops into a metabolic acidosis. Alkalinize the urine.
                \rRENAL FAILURE: Any hypoperfusion.
                \rKETOACIDOSIS: From alcohol, diabetes (hyperglycemia and low serum HC03 is life-threatening), starvation - check serum ketones.
                \r(STS) SODIUM THIOSULFATE: Emerging cause (2024) - can cause HAGMA in patients receiving STS therapy for calciphylaxis or cyanide poisoning.
                
                NORMAL ANION GAP METABOLIC ACIDOSIS
                \rInfusions such as NaCl, TPN or NH4+, diarrhea due to the increasing loss of bicarbonate from the colon, Aldosterone Inhibitors, ATN, CKD, GI and Renal loss of HC03+. Renal Tubular Acidosis (RTA).
                """
                
                
                
                //MARK: - Metabolic  Alkalosis
            case .metabolic_ALKALOSIS:
                return """
                METABOLIC ALKALOSIS: GROE
                \r Retention of serum HC03, loss of metabolic acid or contraction alkalosis
                
                G- GIT excess acid loss
                \r• Vomit (and pyloric stenosis)- loss of acid from the stomach. Fluid loss will lead to volume contraction
                \r• NGT drainage
                \r• Diarrhea
                \r• Ileostomy
                \r• Dehydration - Volume contraction
                
                R- RENAL EXCESS ACID LOSS
                \r• Renal Artery stenosis, renin-secreting tumor, adenoma, hyperplasia, carcinoma
                \r• Mg+ deficiency, K+ depletion, Hypercalcemia/hypoparathyroidism
                \r• Bartter's - (loss of function mutations of transporters and ion channels in TALH)
                \r• Gitelman's - (loss of function mutation of Na+-Cl– cotransporter in DCT)
                \r• Diuretics (Loss of H+, K+, Cl-)
                
                O- OVERDOSE OF BASE
                \r• Antacid OD, Laxative, Milk-alkali syndrome - too much liquid antacids
                \r• Massive Hartmann's transfusion
                \r• Iatrogenic use of HCO3
                
                E- ENDOCRINE
                \r• Cushing
                \r• Steroid excess
                \r• Hyperaldosteronism - from volume contraction which increases urinary waste of acids
                """
                
                
                //MARK: - Metabolic  compensated Alkalosis
            case .metabolic_ALKALOSIS_Compensated:
                return """
                METABOLIC ALKALOSIS: GROE
                \r Retention of serum HC03, loss of metabolic acid or contraction alkalosis
                
                G- GIT excess acid loss
                \r• Vomit (and pyloric stenosis)- loss of acid from the stomach. Fluid loss will lead to volume contraction
                \r• NGT drainage
                \r• Diarrhea
                \r• Ileostomy
                \r• Dehydration - Volume contraction
                
                R- RENAL EXCESS ACID LOSS
                \r• Renal Artery stenosis, renin-secreting tumor, adenoma, hyperplasia, carcinoma
                \r• Mg+ deficiency, K+ depletion, Hypercalcemia/hypoparathyroidism
                \r• Bartter's - (loss of function mutations of transporters and ion channels in TALH)
                \r• Gitelman's - (loss of function mutation of Na+-Cl– cotransporter in DCT)
                \r• Diuretics (Loss of H+, K+, Cl-)
                
                O- OVERDOSE OF BASE
                \r• Antacid OD, Laxative, Milk-alkali syndrome - too much liquid antacids
                \r• Massive Hartmann's transfusion
                \r• Iatrogenic use of HCO3
                
                E- ENDOCRINE
                \r• Cushing
                \r• Steroid excess
                \r• Hyperaldosteronism - from volume contraction which increases urinary waste of acids
                """
                
                
                //MARK: - Metabolic Partially compensated Alkalosis
            case .metabolic_ALKALOSIS_Partially_Compensated:
                return """
                METABOLIC ALKALOSIS: GROE
                \r Retention of serum HC03, loss of metabolic acid or contraction alkalosis
                
                G- GIT excess acid loss
                \r• Vomit (and pyloric stenosis)- loss of acid from the stomach. Fluid loss will lead to volume contraction
                \r• NGT drainage
                \r• Diarrhea
                \r• Ileostomy
                \r• Dehydration - Volume contraction
                
                R- RENAL EXCESS ACID LOSS
                \r• Renal Artery stenosis, renin-secreting tumor, adenoma, hyperplasia, carcinoma
                \r• Mg+ deficiency, K+ depletion, Hypercalcemia/hypoparathyroidism
                \r• Bartter's - (loss of function mutations of transporters and ion channels in TALH)
                \r• Gitelman's - (loss of function mutation of Na+-Cl– cotransporter in DCT)
                \r• Diuretics (Loss of H+, K+, Cl-)
                
                O- OVERDOSE OF BASE
                \r• Antacid OD, Laxative, Milk-alkali syndrome - too much liquid antacids
                \r• Massive Hartmann's transfusion
                \r• Iatrogenic use of HCO3
                
                E- ENDOCRINE
                \r• Cushing
                \r• Steroid excess
                \r• Hyperaldosteronism - from volume contraction which increases urinary waste of acids
                """
                
                // Respiratory Disorders
            case .Resp_ALKALOSIS:
                return """
                Hyperventilation, usually iatrogenic - the body discarded too much C02, leading to a deficiency in carbonic acid.
                
                Stimulation of the Central Nervous System due to:
                \r• Pain, fever, anxiety, cerebral edema, stroke,
                \r• Infection, TBI, Septicemia, or brain tumors.
                
                Respiratory factors:
                \r• Improper ventilator settings
                \r• Increase in minute volume
                \r• Pulmonary Edema
                \r• PNA
                \r• Pneumothorax
                \r• Pulmonary effusions
                \r• Pulmonary fibrosis
                \r• PE
                \r• Chronic lung disease
                \r• Decreased Fi02
                \r• CHF
                \r• High altitude
                
                Drugs: Such as salicylates, nicotine, and progesterone.
                
                Catecholamine surges, pregnancy, liver disease, and pontine bleeds.
                """
                
                //MARK: - Resp  compensated Alkalosis
            case .Resp_ALKALOSIS_Compensated:
                return """
                Hyperventilation, usually iatrogenic - the body discarded too much C02, leading to a deficiency in carbonic acid.
                
                Stimulation of the Central Nervous System due to:
                \r• Pain, fever, anxiety, cerebral edema, stroke,
                \r• Infection, TBI, Septicemia, or brain tumors.
                
                Respiratory factors:
                \r• Improper ventilator settings
                \r• Increase in minute volume
                \r• Pulmonary Edema
                \r• PNA
                \r• Pneumothorax
                \r• Pulmonary effusions
                \r• Pulmonary fibrosis
                \r• PE
                \r• Chronic lung disease
                \r• Decreased Fi02
                \r• CHF
                \r• High altitude
                
                Drugs: Such as salicylates, nicotine, and progesterone.
                
                Catecholamine surges, pregnancy, liver disease, and pontine bleeds.
                """
                
                //MARK: - Resp Partially compensated Alkalosis
            case .Resp_ALKALOSIS_Partially_Compensated:
                return """
                Hyperventilation, usually iatrogenic - the body discarded too much C02, leading to a deficiency in carbonic acid.
                
                Stimulation of the Central Nervous System due to:
                \r• Pain, fever, anxiety, cerebral edema, stroke,
                \r• Infection, TBI, Septicemia, or brain tumors.
                
                Respiratory factors:
                \r• Improper ventilator settings
                \r• Increase in minute volume
                \r• Pulmonary Edema
                \r• PNA
                \r• Pneumothorax
                \r• Pulmonary effusions
                \r• Pulmonary fibrosis
                \r• PE
                \r• Chronic lung disease
                \r• Decreased Fi02
                \r• CHF
                \r• High altitude
                
                Drugs: Such as salicylates, nicotine, and progesterone.
                
                Catecholamine surges, pregnancy, liver disease, and pontine bleeds.
                """
                
                //MARK: - Resp  Acidosis
            case .Resp_ACIDOSIS:
                return   """
                Respiratory ACIDOSIS:
                \rAny decreased alveolar ventilatory state with or without any compensatory increase in HC03.
                \r• Airway Obstruction
                \r• PE
                \r• PNA
                \r• Pneumothorax
                \r• Hemothorax
                \r• Myopathy
                \r• Drugs- Opiates, sedatives, anesthesia
                \r• Inadequate vent settings
                
                Hypercatabolic disorders such as:
                \r• Thyroid Storm
                \r• Pheochromocytoma
                \r• Sepsis
                \r• Liver disease
                \r• Malignant hyperthermia
                """
                
                //MARK: - Resp Compensated  Acidosis
            case .Resp_ACIDOSIS_Compensated:
                return  """
                Respiratory ACIDOSIS:
                \rAny decreased alveolar ventilatory state with or without any compensatory increase in HC03.
                \r• Airway Obstruction
                \r• PE
                \r• PNA
                \r• Pneumothorax
                \r• Hemothorax
                \r• Myopathy
                \r• Drugs- Opiates, sedatives, anesthesia
                \r• Inadequate vent settings
                
                Hypercatabolic disorders such as:
                \r• Thyroid Storm
                \r• Pheochromocytoma
                \r• Sepsis
                \r• Liver disease
                \r• Malignant hyperthermia
                """
                
                //MARK: - Resp  pArtially compensated Acidosis
            case .Resp_ACIDOSIS_Partially_Compensated:
                return  """
                Respiratory ACIDOSIS:
                \rAny decreased alveolar ventilatory state with or without any compensatory increase in HC03.
                \r• Airway Obstruction
                \r• PE
                \r• PNA
                \r• Pneumothorax
                \r• Hemothorax
                \r• Myopathy
                \r• Drugs- Opiates, sedatives, anesthesia
                \r• Inadequate vent settings
                
                Hypercatabolic disorders such as:
                \r• Thyroid Storm
                \r• Pheochromocytoma
                \r• Sepsis
                \r• Liver disease
                \r• Malignant hyperthermia
                """
                
                //            default: break
                
                //MARK: - Mixed  Acidosis
            case .Mixed_Metabolic_Resp_Acidosis:
                return """
                \rThis is a mixed disturbance that includes both metabolic and respiratory components.
                
                POSITIVE ANION GAP: GOLD MARK (+ STS)
                \rGLYCOL: Ethylene and propylene glycol, calcium oxalate crystals, (anti-freeze), and glycolic acid.
                \rOXOPROLINE: Metabolite of acetaminophen-associated with chronic acetaminophen use, often by malnourished women.
                \rLACTIC ACIDOSIS: Check serum lactate. Correct hypoperfusion/hypotension.
                \rD-LACTATE: Which can occur in some with short bowel syndromes.
                \rMETHANOL: Formic acid, formaldehyde, optic papillitis, and metformin.
                \rASPIRIN: Aspirin OD. Initially will have a respiratory alkalosis, which develops into a metabolic acidosis. Alkalinize the urine.
                \rRENAL FAILURE: Any hypoperfusion.
                \rKETOACIDOSIS: From alcohol, diabetes (hyperglycemia and low serum HC03 is life-threatening), starvation - check serum ketones.
                \r(STS) SODIUM THIOSULFATE: Emerging cause (2024) - can cause HAGMA in patients receiving STS therapy.
                
                NORMAL ANION GAP METABOLIC ACIDOSIS
                \rInfusions such as NaCl, TPN or NH4+, diarrhea due to the increasing loss of bicarbonate from the colon, Aldosterone Inhibitors, ATN, CKD, GI and Renal loss of HC03+. Renal Tubular Acidosis (RTA).
                
                \rIn Respiratory Acidosis:
                \rAny decreased alveolar ventilatory state with or without any compensatory increase in HC03.
                \r• Airway Obstruction
                \r• PE
                \r• PNA
                \r• Pneumothorax
                \r• Hemothorax
                \r• Myopathy
                \r• Drugs- Opiates, sedatives, anesthesia
                \r• Inadequate vent settings
                
                Hypercatabolic disorders such as:
                \r• Thyroid Storm
                \r• Pheochromocytoma
                \r• Sepsis
                \r• Liver disease
                \r• Malignant hyperthermia
                """
                
                
                
                //MARK: - Mixed Alkalosis
            case .Mixed_Metabolic_Resp_ALKALOSIS:
                return """
                METABOLIC ALKALOSIS: GROE
                \r Retention of serum HC03, loss of metabolic acid or contraction alkalosis
                
                G- GIT excess acid loss
                \r• Vomit (and pyloric stenosis)- loss of acid from the stomach. Fluid loss will lead to volume contraction
                \r• NGT drainage
                \r• Diarrhea
                \r• Ileostomy
                \r• Dehydration - Volume contraction
                
                R- RENAL EXCESS ACID LOSS
                \r• Renal Artery stenosis, renin-secreting tumor, adenoma, hyperplasia, carcinoma
                \r• Mg+ deficiency, K+ depletion, Hypercalcemia/hypoparathyroidism
                \r• Bartter's - (loss of function mutations of transporters and ion channels in TALH)
                \r• Gitelman's - (loss of function mutation of Na+-Cl– cotransporter in DCT)
                \r• Diuretics (Loss of H+, K+, Cl-)
                
                O- OVERDOSE OF BASE
                \r• Antacid OD, Laxative, Milk-alkali syndrome - too much liquid antacids
                \r• Massive Hartmann's transfusion
                \r• Iatrogenic use of HCO3
                
                E- ENDOCRINE
                \r• Cushing
                \r• Steroid excess
                \r• Hyperaldosteronism - from volume contraction which increases urinary waste of acids
                
                In respiratory alkalosis, think increased Minute Ventilation (VE). Hyperventilation, usually iatrogenic - the body discarded too much C02, leading to a deficiency in carbonic acid.
                
                
                Stimulation of the Central Nervous System due to:
                \r• Pain, fever, anxiety, cerebral edema, stroke,
                \r• Infection, TBI, Septicemia, or brain tumors.
                
                Respiratory factors:
                \r• Improper ventilator settings
                \r• Increase in minute volume
                \r• Pulmonary Edema
                \r• PNA
                \r• Pneumothorax
                \r• Pulmonary effusions
                \r• Pulmonary fibrosis
                \r• PE
                \r• Chronic lung disease
                \r• Decreased Fi02
                \r• CHF
                \r• High altitude
                
                Drugs: Such as salicylates, nicotine, and progesterone.
                
                Catecholamine surges, pregnancy, liver disease, and pontine bleeds.
                """
                
            case .Mixed_MetabolicAcidosis_RespAlkalosis:
                return """
                POSITIVE ANION GAP: GOLD MARK (+ STS)
                \rGLYCOL: Ethylene and propylene glycol, calcium oxalate crystals, (anti-freeze), and glycolic acid.
                \rOXOPROLINE: Metabolite of acetaminophen-associated with chronic acetaminophen use, often by malnourished women.
                \rLACTIC ACIDOSIS: Check serum lactate. Correct hypoperfusion/hypotension.
                \rD-LACTATE: Which can occur in some with short bowel syndromes.
                \rMETHANOL: Formic acid, formaldehyde, optic papillitis, and metformin.
                \rASPIRIN: Aspirin OD. Initially will have a respiratory alkalosis, which develops into a metabolic acidosis. Alkalinize the urine.
                \rRENAL FAILURE: Any hypoperfusion.
                \rKETOACIDOSIS: From alcohol, diabetes (hyperglycemia and low serum HC03 is life-threatening), starvation - check serum ketones.
                \r(STS) SODIUM THIOSULFATE: Emerging cause (2024) - can cause HAGMA in patients receiving STS therapy.
                
                NORMAL ANION GAP METABOLIC ACIDOSIS
                \rInfusions such as NaCl, TPN or NH4+, diarrhea due to the increasing loss of bicarbonate from the colon, Aldosterone Inhibitors, ATN, CKD, GI and Renal loss of HC03+. Renal Tubular Acidosis (RTA).
                
                \rIn respiratory alkalosis, think increased Minute Ventilation (VE). Hyperventilation, usually iatrogenic - the body discarded too much C02, leading to a deficiency in carbonic acid.
                
                
                Stimulation of the Central Nervous System due to:
                \r• Pain, fever, anxiety, cerebral edema, stroke,
                \r• Infection, TBI, Septicemia, or brain tumors.
                
                Respiratory factors:
                \r• Improper ventilator settings
                \r• Increase in minute volume
                \r• Pulmonary Edema
                \r• PNA
                \r• Pneumothorax
                \r• Pulmonary effusions
                \r• Pulmonary fibrosis
                \r• PE
                \r• Chronic lung disease
                \r• Decreased Fi02
                \r• CHF
                \r• High altitude
                
                Drugs: Such as salicylates, nicotine, and progesterone.
                
                Catecholamine surges, pregnancy, liver disease, and pontine bleeds.
                """
                //MARK: - Mixed disturbance 4
            case .Metabolic_Alkalosis_Respiratory_Acidosis:
                return """
                METABOLIC ALKALOSIS: GROE
                \r Retention of serum HC03, loss of metabolic acid or contraction alkalosis
                
                G- GIT excess acid loss
                \r• Vomit (and pyloric stenosis)- loss of acid from the stomach. Fluid loss will lead to volume contraction
                \r• NGT drainage
                \r• Diarrhea
                \r• Ileostomy
                \r• Dehydration - Volume contraction
                
                R- RENAL EXCESS ACID LOSS
                \r• Renal Artery stenosis, renin-secreting tumor, adenoma, hyperplasia, carcinoma
                \r• Mg+ deficiency, K+ depletion, Hypercalcemia/hypoparathyroidism
                \r• Bartter's - (loss of function mutations of transporters and ion channels in TALH)
                \r• Gitelman's - (loss of function mutation of Na+-Cl– cotransporter in DCT)
                \r• Diuretics (Loss of H+, K+, Cl-)
                
                O- OVERDOSE OF BASE
                \r• Antacid OD, Laxative, Milk-alkali syndrome - too much liquid antacids
                \r• Massive Hartmann's transfusion
                \r• Iatrogenic use of HCO3
                
                E- ENDOCRINE
                \r• Cushing
                \r• Steroid excess
                \r• Hyperaldosteronism - from volume contraction which increases urinary waste of acids
                
                In respiratory acidosis, think increased Minute Ventilation (VE). Hyperventilation - the body discarded too much C02
                
                \r Consider the following in Respiratory Acidosis:
                \rAny decreased alveolar ventilatory state with or without any compensatory increase in HC03.
                \r• Airway Obstruction
                \r• PE
                \r• PNA
                \r• Pneumothorax
                \r• Hemothorax
                \r• Myopathy
                \r• Drugs- Opiates, sedatives, anesthesia
                \r• Inadequate vent settings
                
                Hypercatabolic disorders such as:
                \r• Thyroid Storm
                \r• Pheochromocytoma
                \r• Sepsis
                \r• Liver disease
                \r• Malignant hyperthermia
                """
                
            } // close switch
        } // close fn
        
        
        //MARK: - Clinical Pears for the disorder
        func clinicalPearls() -> String {
            switch self {
                // Metabolic disorders
                
                
                
                //MARK: - Critical Pearls: Metabolic Acidosis
            case .metabolic_ACIDOSIS, .Normal:
                return """
                \r• More than one primary acid-base disorder may be present simultaneously. It is important to identify and address each primary acid-base disorder.
                \r• Typically in an Anion Gap Metabolic Acidosis, the rise in AG should be equal to the decrease in HC03. In Non- Anion Gap Metabolic Acidosis, the reduction of HC03 should equal the rise in chloride. Typically, there's an inability of the kidneys to secrete HC03, or there's a direct loss of HC03.
                \r• NaHC03 is typically the agent commonly used to correct the metabolic acidosis. Refer to the HC03 deficit calculator to determine the HC03 deficit.
                \r• However, treatment can be controversial and sometimes not helpful as studies show that it can worsen intracellular acidosis in those patients with sepsis and lactic acidosis. Although there's low-quality evidence from observational studies, current literature suggests that NaHC03 is held unless the pH is < 7.1, then address the primary process once the pH rises. There are advantages and disadvantages.
                \r• Disadvantages of NaHC03: When treating a chronic metabolic acidosis, there can be a progression of renal disease, negative nitrogen balance, and growth retardation.
                \r• Disadvantages include: Intracellular lactate production, paradoxical intracellular acidosis, increased Na load, Left shift of the oxyhemoglobin dissociation curve.
                \r• A side effect of NaHC03 treatment is the subsequent rise in PaC02. Be sure to make the necessary ventilatory adjustments to subvert hypercapnia. If not, consider THAM. THAM consumes C02 and doesn't provide a sodium load as it's not a sodium salt like NaH03.
                \r• Clinical changes: Hyperventilation, right shift on the oxyhemoglobin dissociation curve, hyperkalemia, catecholamine resistance, and pulmonary vasoconstriction.
                """
                
                
                
                //MARK: - Critical Pearls: Metabolic Acidosis Compensated
            case .metabolic_ACIDOSIS_Compensated:
                return """
                \r• More than one primary acid-base disorder may be present simultaneously. It is important to identify and address each primary acid-base disorder.
                \r• NaHC03 is typically the agent commonly used to correct the metabolic acidosis. Refer to the HC03 deficit calculator to determine the HC03 deficit.
                \r• However, treatment can be controversial and sometimes not helpful as studies show that it can worsen intracellular acidosis in those patients with sepsis and lactic acidosis. Although there's low-quality evidence from observational studies, current literature suggests that NaHC03 is held unless the pH is < 7.1, then address the primary process once the pH rises. There are advantages and disadvantages.
                \r• Disadvantages of NaHC03: When treating a chronic metabolic acidosis, there can be a progression of renal disease, negative nitrogen balance, and growth retardation.
                \r• Disadvantages include: Intracellular lactate production, paradoxical intracellular acidosis, increased Na load, Left shift of the oxyhemoglobin dissociation curve.
                \r• A side effect of NaHC03 treatment is the subsequent rise in PaC02. Be sure to make the necessary ventilatory adjustments to subvert hypercapnia. If not, consider THAM. THAM consumes C02 and doesn't provide a sodium load as it's not a sodium salt like NaH03.
                \r• Clinical changes: Hyperventilation, right shift on the oxyhemoglobin dissociation curve, hyperkalemia, catecholamine resistance, and pulmonary vasoconstriction.
                """
                
                
                
                //MARK: - Critical Pearls: Metabolic Acidosis
            case .metabolic_ACIDOSIS_Partially_Compensated:
                return """
                \r• More than one primary acid-base disorder may be present simultaneously. It is important to identify and address each primary acid-base disorder.
                \r• NaHC03 is typically the agent commonly used to correct the metabolic acidosis. Refer to the HC03 deficit calculator to determine the HC03 deficit.
                \r• However, treatment can be controversial and sometimes not helpful as studies show that it can worsen intracellular acidosis in those patients with sepsis and lactic acidosis. Although there's low-quality evidence from observational studies, current literature suggests that NaHC03 is held unless the pH is < 7.1, then address the primary process once the pH rises. There are advantages and disadvantages.
                \r• Disadvantages of NaHC03: When treating a chronic metabolic acidosis, there can be a progression of renal disease, negative nitrogen balance, and growth retardation.
                \r• Disadvantages include: Intracellular lactate production, paradoxical intracellular acidosis, increased Na load, Left shift of the oxyhemoglobin dissociation curve.
                \r• A side effect of NaHC03 treatment is the subsequent rise in PaC02. Be sure to make the necessary ventilatory adjustments to subvert hypercapnia. If not, consider THAM. THAM consumes C02 and doesn't provide a sodium load as it's not a sodium salt like NaH03.
                \r• Clinical changes: Hyperventilation, right shift on the oxyhemoglobin dissociation curve, hyperkalemia, catecholamine resistance, and pulmonary vasoconstriction.
                """
                
                
                
                //MARK: - Critical Pearls: Metabolic Alkalosis
            case .metabolic_ALKALOSIS:
                return """
                \r• Look to correct the underlying issue.
                \r• Chloride Response:
                \rWhen Metabolic Alkalosis is chloride-responsive, there's usually excess secretion (depletion) of chloride ions - making the concentration of chloride in the urine low. The chloride ions can be depleted usually due to:
                
                \r1) Loop or Thiazide diuretics: Which result in a metabolic alkalosis due to the loss of K+ and H+ in the urine.
                    \r2) Gastric Suctioning or Vomiting
                    \r3) Use of laxatives
                    \r4) Hypercapnia
                    \r5) Contraction Alkalosis: Due to volume depletion and the use of fluids with a high sodium chloride concentration. The serum HC03 ultimately rises when there's decreased renal perfusion or excess loss of H+ from the GI tract or urine. In the kidneys, this will cause renin and aldosterone to be secreted. Therefore, increased angiotension II will cause an increase in Na+ and H+ ion exchange in the proximal tubule, thus increasing HC03 reabsorbsion.
                
                \rThis generally can be corrected by administering NaCl fluids, intravenously.
                
                \rWhen Metabolic Alkalosis is chloride- unresponsive or resistant, NaCl infusion typically won't correct the disorder as it would in chloride-responsive alkalosis. Usually, there's a deficiency in electrolytes: Such as potassium and/or magnesium - or excess in mineralocorticoids. A high urine chloride in the presence of hypertension can be suggestive of excess in mineralocorticoids, Liddle's syndrome, Conn's syndrome, Cushings disease, or primary and secondary hyperaldosteronsim.
                
                \r• Note: There's also a chance that a patient can present with co-existing forms of chloride responsiveness: as in patients that are volume overloaded and are hypokalemic from high-dose diuretics.
                
                \r• Correct electrolyte imbalances, avoid hyperventilation and improve bicarb excretion with volume, CL and K+.
                
                \r• There will be a shift in the 02 dissociation curve to the left due to the increased affinity for Hb-02.
                
                \r• Acetazolamide (Diamox) can increase HC03 excretion. Monitor P04- and K+ levels.
                
                \r• Labs: Common to observe hypokalemia, hypocalcemia during severe cases of alkalemia as there's increased binding of plasma proteins to ionized Ca++ and hypochloremia.
                """
                
                
                
                //MARK: - Critical Pearls: Metabolic Alkalosis
            case .metabolic_ALKALOSIS_Compensated:
                return """
                \r• Look to correct the underlying issue.
                \r• Chloride Response:
                \rWhen Metabolic Alkalosis is chloride-responsive, there's usually excess secretion (depletion) of chloride ions - making the concentration of chloride in the urine low. The chloride ions can be depleted usually due to:
                
                \r1) Loop or Thiazide diuretics: Which result in a metabolic alkalosis due to the loss of K+ and H+ in the urine.
                \r2) Gastric Suctioning or Vomiting
                \r3) Use of laxatives
                \r4) Hypercapnia
                \r5) Contraction Alkalosis: Due to volume depletion and the use of fluids with a high sodium chloride concentration. The serum HC03 ultimately rises when there's decreased renal perfusion or excess loss of H+ from the GI tract or urine. In the kidneys, this will cause renin and aldosterone to be secreted. Therefore, increased angiotension II will cause an increase in Na+ and H+ ion exchange in the proximal tubule, thus increasing HC03 reabsorbsion.
                
                \rThis generally can be corrected by administering NaCl fluids, intravenously.
                
                \rWhen Metabolic Alkalosis is chloride- unresponsive or resistant, NaCl infusion typically won't correct the disorder as it would in chloride-responsive alkalosis. Usually, there's a deficiency in electrolytes: Such as potassium and/or magnesium - or excess in mineralocorticoids. A high urine chloride in the presence of hypertension can be suggestive of excess in mineralocorticoids, Liddle's syndrome, Conn's syndrome, Cushings disease, or primary and secondary hyperaldosteronsim.
                
                \r• Note: There's also a chance that a patient can present with co-existing forms of chloride responsiveness: as in patients that are volume overloaded and are hypokalemic from high-dose diuretics.
                
                \r• Correct electrolyte imbalances, avoid hyperventilation and improve bicarb excretion with volume, CL and K+.
                
                \r• There will be a shift in the 02 dissociation curve to the left due to the increased affinity for Hb-02.
                
                \r• Acetazolamide (Diamox) can increase HC03 excretion. Monitor P04- and K+ levels.
                
                \r• Labs: Common to observe hypokalemia, hypocalcemia during severe cases of alkalemia as there's increased binding of plasma proteins to ionized Ca++ and hypochloremia.
                """
                //MARK: - Critical Pearls: Metabolic Alkalosis
            case .metabolic_ALKALOSIS_Partially_Compensated:
                return """
                \r• Look to correct the underlying issue.
                \r• Chloride Response:
                \rWhen Metabolic Alkalosis is chloride-responsive, there's usually excess secretion (depletion) of chloride ions - making the concentration of chloride in the urine low. The chloride ions can be depleted usually due to:
                
                \r1) Loop or Thiazide diuretics: Which result in a metabolic alkalosis due to the loss of K+ and H+ in the urine.
                \r2) Gastric Suctioning or Vomiting
                \r3) Use of laxatives
                \r4) Hypercapnia
                \r5) Contraction Alkalosis: Due to volume depletion and the use of fluids with a high sodium chloride concentration. The serum HC03 ultimately rises when there's decreased renal perfusion or excess loss of H+ from the GI tract or urine. In the kidneys, this will cause renin and aldosterone to be secreted. Therefore, increased angiotension II will cause an increase in Na+ and H+ ion exchange in the proximal tubule, thus increasing HC03 reabsorbsion.
                
                \rThis generally can be corrected by administering NaCl fluids, intravenously.
                
                \rWhen Metabolic Alkalosis is chloride- unresponsive or resistant, NaCl infusion typically won't correct the disorder as it would in chloride-responsive alkalosis. Usually, there's a deficiency in electrolytes: Such as potassium and/or magnesium - or excess in mineralocorticoids. A high urine chloride in the presence of hypertension can be suggestive of excess in mineralocorticoids, Liddle's syndrome, Conn's syndrome, Cushings disease, or primary and secondary hyperaldosteronsim.
                
                \r• Note: There's also a chance that a patient can present with co-existing forms of chloride responsiveness: as in patients that are volume overloaded and are hypokalemic from high-dose diuretics.
                
                \r• Correct electrolyte imbalances, avoid hyperventilation and improve bicarb excretion with volume, CL and K+.
                
                \r• There will be a shift in the 02 dissociation curve to the left due to the increased affinity for Hb-02.
                
                \r• Acetazolamide (Diamox) can increase HC03 excretion. Monitor P04- and K+ levels.
                
                \r• Labs: Common to observe hypokalemia, hypocalcemia during severe cases of alkalemia as there's increased binding of plasma proteins to ionized Ca++ and hypochloremia.
                """
                
                // Respiratory Disorders
                //MARK: - Critical Pearls: Resp Alkalosis
            case .Resp_ALKALOSIS:
                return """
                \r• Respiratory alkalosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• Respiratory alkalosis is a decrease in C02 with or without a mandatory decrease in HC03.
                
                COMPENSATION TIME FRAMES (Boston Rules):
                \r• ACUTE (minutes to hours): HCO₃⁻ drops ~2 mEq/L per 10 mmHg ↓ PaCO₂. Buffering via intracellular mechanisms.
                \r• CHRONIC (3-5 days): HCO₃⁻ drops ~4-5 mEq/L per 10 mmHg ↓ PaCO₂. Renal excretion of bicarbonate occurs.
                \r• Compensation is rarely complete; pH usually trends toward but doesn't fully reach normal.
                \r• Chloride Response:
                \rWhen Metabolic Alkalosis is chloride-responsive, there's usually excess secretion (depletion) of chloride ions - making the concentration of chloride in the urine low. The chloride ions can be depleted usually due to:
                
                \r1) Loop or Thiazide diuretics: Which result in a metabolic alkalosis due to the loss of K+ and H+ in the urine.
                \r2) Gastric Suctioning or Vomiting
                \r3) Use of laxatives
                \r4) Hypercapnia
                \r5) Contraction Alkalosis: Due to volume depletion and the use of fluids with a high sodium chloride concentration. The serum HC03 ultimately rises when there's decreased renal perfusion or excess loss of H+ from the GI tract or urine. In the kidneys, this will cause renin and aldosterone to be secreted. Therefore, increased angiotension II will cause an increase in Na+ and H+ ion exchange in the proximal tubule, thus increasing HC03 reabsorbsion.
                
                \rThis generally can be corrected by administering NaCl fluids, intravenously.
                
                \rWhen Metabolic Alkalosis is chloride- unresponsive or resistant, NaCl infusion typically won't correct the disorder as it would in chloride-responsive alkalosis. Usually, there's a deficiency in electrolytes: Such as potassium and/or magnesium - or excess in mineralocorticoids. A high urine chloride in the presence of hypertension can be suggestive of excess in mineralocorticoids, Liddle's syndrome, Conn's syndrome, Cushings disease, or primary and secondary hyperaldosteronsim.
                \r• Note: There's also a chance that a patient can present with co-existing forms of chloride responsiveness: as in patients that are volume overloaded and are hypokalemic from high-dose diuretics.
                \r• Those who have chronic conditions where  C02 is reduced for more than 3-5 days, then you may notice the HC03 fall approx 3-5 mEq/L for q 10 mmHg C02.
                \r• Generally not life-threatening.
                \r• Increases in respiratory minute volume or respiratory rate will cause the pH to increase.
                \r• Treat the underlying etiology, electrolyte imbalance and volume status. You may notice a slight fall in serum K+, phosphate and reduction in calcium.
                \r• Can consider Acetazolamide (Diamox) and avoid hyperventilation.
                \r• The priority is to treat any underlying hypoxemia.
                """
                //MARK: - Critical Pearls: Resp Alkalosis
            case .Resp_ALKALOSIS_Compensated:
                return """
                \r• Respiratory alkalosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• Respiratory alkalosis is a decrease in C02 with or without a mandatory decrease in HC03. The compensatory response is a renal loss of plasma HC03 - approx. 2 mEq/L for every 10 mmHg the C02 decreases below 40.
                \r• Chloride Response:
                \rWhen Metabolic Alkalosis is chloride-responsive, there's usually excess secretion (depletion) of chloride ions - making the concentration of chloride in the urine low. The chloride ions can be depleted usually due to:
                
                \r1) Loop or Thiazide diuretics: Which result in a metabolic alkalosis due to the loss of K+ and H+ in the urine.
                \r2) Gastric Suctioning or Vomiting
                \r3) Use of laxatives
                \r4) Hypercapnia
                \r5) Contraction Alkalosis: Due to volume depletion and the use of fluids with a high sodium chloride concentration. The serum HC03 ultimately rises when there's decreased renal perfusion or excess loss of H+ from the GI tract or urine. In the kidneys, this will cause renin and aldosterone to be secreted. Therefore, increased angiotension II will cause an increase in Na+ and H+ ion exchange in the proximal tubule, thus increasing HC03 reabsorbsion.
                
                \rThis generally can be corrected by administering NaCl fluids, intravenously.
                
                \rWhen Metabolic Alkalosis is chloride- unresponsive or resistant, NaCl infusion typically won't correct the disorder as it would in chloride-responsive alkalosis. Usually, there's a deficiency in electrolytes: Such as potassium and/or magnesium - or excess in mineralocorticoids. A high urine chloride in the presence of hypertension can be suggestive of excess in mineralocorticoids, Liddle's syndrome, Conn's syndrome, Cushings disease, or primary and secondary hyperaldosteronsim.
                \r• Note: There's also a chance that a patient can present with co-existing forms of chloride responsiveness: as in patients that are volume overloaded and are hypokalemic from high-dose diuretics.
                \r• Those who have chronic conditions where  C02 is reduced for more than 3-5 days, then you may notice the HC03 fall approx 3-5 mEq/L for q 10 mmHg C02.
                \r• Generally not life-threatening.
                \r• Increases in respiratory minute volume or respiratory rate will cause the pH to increase.
                \r• Treat the underlying etiology, electrolyte imbalance and volume status. You may notice a slight fall in serum K+, phosphate and reduction in calcium.
                \r• Can consider Acetazolamide (Diamox) and avoid hyperventilation.
                \r• The priority is to treat any underlying hypoxemia.
                """
                
                //MARK: - Critical Pearls: Resp Alkalosis
            case .Resp_ALKALOSIS_Partially_Compensated:
                return """
                \r• Respiratory alkalosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• Respiratory alkalosis is a decrease in C02 with or without a mandatory decrease in HC03. The compensatory response is a renal loss of plasma HC03 - approx. 2 mEq/L for every 10 mmHg the C02 decreases below 40.
                \r• Chloride Response:
                \rWhen Metabolic Alkalosis is chloride-responsive, there's usually excess secretion (depletion) of chloride ions - making the concentration of chloride in the urine low. The chloride ions can be depleted usually due to:
                
                \r1) Loop or Thiazide diuretics: Which result in a metabolic alkalosis due to the loss of K+ and H+ in the urine.
                \r2) Gastric Suctioning or Vomiting
                \r3) Use of laxatives
                \r4) Hypercapnia
                \r5) Contraction Alkalosis: Due to volume depletion and the use of fluids with a high sodium chloride concentration. The serum HC03 ultimately rises when there's decreased renal perfusion or excess loss of H+ from the GI tract or urine. In the kidneys, this will cause renin and aldosterone to be secreted. Therefore, increased angiotension II will cause an increase in Na+ and H+ ion exchange in the proximal tubule, thus increasing HC03 reabsorbsion.
                
                \rThis generally can be corrected by administering NaCl fluids, intravenously.
                
                \rWhen Metabolic Alkalosis is chloride- unresponsive or resistant, NaCl infusion typically won't correct the disorder as it would in chloride-responsive alkalosis. Usually, there's a deficiency in electrolytes: Such as potassium and/or magnesium - or excess in mineralocorticoids. A high urine chloride in the presence of hypertension can be suggestive of excess in mineralocorticoids, Liddle's syndrome, Conn's syndrome, Cushings disease, or primary and secondary hyperaldosteronsim.
                \r• Note: There's also a chance that a patient can present with co-existing forms of chloride responsiveness: as in patients that are volume overloaded and are hypokalemic from high-dose diuretics.
                \r• Those who have chronic conditions where  C02 is reduced for more than 3-5 days, then you may notice the HC03 fall approx 3-5 mEq/L for q 10 mmHg C02.
                \r• Generally not life-threatening.
                \r• Increases in respiratory minute volume or respiratory rate will cause the pH to increase.
                \r• Treat the underlying etiology, electrolyte imbalance and volume status. You may notice a slight fall in serum K+, phosphate and reduction in calcium.
                \r• Can consider Acetazolamide (Diamox) and avoid hyperventilation.
                \r• The priority is to treat any underlying hypoxemia.
                """
                
                //MARK: - Critical Pearls: Resp Acidosis
            case .Resp_ACIDOSIS:
                return """
                \r• Respiratory acidosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• The PaC02 generally will return to normal after restoring adequate alveolar ventilation.
                \r• Bicarbonate is not involved in this disorder as it can't buffer itself. It's almost always contraindicated in treating this disorder.
                \r• You can appreciate CNS depression at high levels of PaC02 which can result in confusion, dyspnea, disorientation, headache. etc.
                
                COMPENSATION TIME FRAMES (Boston Rules):
                \r• ACUTE (minutes to hours): HCO₃⁻ rises ~1 mEq/L per 10 mmHg ↑ PaCO₂. Buffering is via intracellular mechanisms.
                \r• CHRONIC (3-5 days): HCO₃⁻ rises ~3.5-4 mEq/L per 10 mmHg ↑ PaCO₂. Renal retention of bicarbonate occurs.
                \r• Note: Full compensation (pH normalization) is rare; suspect mixed disorder if pH is completely normal with abnormal PaCO₂ and HCO₃⁻.
                """
                
                //MARK: - Critical Pearls: Resp Acidosis
            case .Resp_ACIDOSIS_Compensated:
                return """
                \r• Respiratory acidosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• The PaC02 generally will return to normal after restoring adequate alveolar ventilation.
                \r• Bicarbonate is not involved in this disorder as it can't buffer itself. It's almost always contraindicated in treating this disorder.
                \r• You can appreciate CNS depression at high levels of PaC02 which can result in confusion, dyspnea, disorientation, headache. etc.
                """
                
                //MARK: - Critical Pearls: Resp Acidosis
            case .Resp_ACIDOSIS_Partially_Compensated:
                return """
                \r• Respiratory acidosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• The PaC02 generally will return to normal after restoring adequate alveolar ventilation.
                \r• Bicarbonate is not involved in this disorder as it can't buffer itself. It's almost always contraindicated in treating this disorder.
                \r• You can appreciate CNS depression at high levels of PaC02 which can result in confusion, dyspnea, disorientation, headache. etc.
                """
                
                //MARK: - Critical Pearls: Mixed Acidosis
            case .Mixed_Metabolic_Resp_Acidosis:
                return """
                \r• More than one primary acid-base disorder may be present simultaneously. It is important to identify and address each primary acid-base disorder.\r• Respiratory acidosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• The PaC02 generally will return to normal after restoring adequate alveolar ventilation.
                \r• Bicarbonate is not involved in this disorder as it can't buffer itself. It's almost always contraindicated in treating this disorder.
                \r• You can appreciate CNS depression at high levels of PaC02 which can result in confusion, dyspnea, disorientation, headache. etc.
                \r• Typically in an Anion Gap Metabolic Acidosis, the rise in AG should be equal to the decrease in HC03. In Non- Anion Gap Metabolic Acidosis, the reduction of HC03 should equal the rise in chloride. Typically, there's an inability of the kidneys to secrete HC03, or there's a direct loss of HC03.
                \r• NaHC03 is typically the agent commonly used to correct the metabolic acidosis. Refer to the HC03 deficit calculator to determine the HC03 deficit.
                \r• However, treatment can be controversial and sometimes not helpful as studies show that it can worsen intracellular acidosis in those patients with sepsis and lactic acidosis. Although there's low-quality evidence from observational studies, current literature suggests that NaHC03 is held unless the pH is < 7.1, then address the primary process once the pH rises. There are advantages and disadvantages.
                \r• Disadvantages of NaHC03: When treating a chronic metabolic acidosis, there can be a progression of renal disease, negative nitrogen balance, and growth retardation.
                \r• Disadvantages include: Intracellular lactate production, paradoxical intracellular acidosis, increased Na load, Left shift of the oxyhemoglobin dissociation curve.
                \r• A side effect of NaHC03 treatment is the subsequent rise in PaC02. Be sure to make the necessary ventilatory adjustments to subvert hypercapnia. If not, consider THAM. THAM consumes C02 and doesn't provide a sodium load as it's not a sodium salt like NaH03.
                \r• Clinical changes: Hyperventilation, right shift on the oxyhemoglobin dissociation curve, hyperkalemia, catecholamine resistance, and pulmonary vasoconstriction.
                """
                
                //MARK: - Critical Pearls: Mixed Alkalosis
            case .Mixed_Metabolic_Resp_ALKALOSIS:
                return """
                \r• With metabolic issues, look to correct the underlying issue.
                \r• Chloride Response:
                \rWhen Metabolic Alkalosis is chloride-responsive, there's usually excess secretion (depletion) of chloride ions - making the concentration of chloride in the urine low. The chloride ions can be depleted usually due to:
                
                \r1) Loop or Thiazide diuretics: Which result in a metabolic alkalosis due to the loss of K+ and H+ in the urine.
                \r2) Gastric Suctioning or Vomiting
                \r3) Use of laxatives
                \r4) Hypercapnia
                \r5) Contraction Alkalosis: Due to volume depletion and the use of fluids with a high sodium chloride concentration. The serum HC03 ultimately rises when there's decreased renal perfusion or excess loss of H+ from the GI tract or urine. In the kidneys, this will cause renin and aldosterone to be secreted. Therefore, increased angiotension II will cause an increase in Na+ and H+ ion exchange in the proximal tubule, thus increasing HC03 reabsorbsion.
                
                \rThis generally can be corrected by administering NaCl fluids, intravenously.
                
                \rWhen Metabolic Alkalosis is chloride- unresponsive or resistant, NaCl infusion typically won't correct the disorder as it would in chloride-responsive alkalosis. Usually, there's a deficiency in electrolytes: Such as potassium and/or magnesium - or excess in mineralocorticoids. A high urine chloride in the presence of hypertension can be suggestive of excess in mineralocorticoids, Liddle's syndrome, Conn's syndrome, Cushings disease, or primary and secondary hyperaldosteronsim.
                \r• Note: There's also a chance that a patient can present with co-existing forms of chloride responsiveness: as in patients that are volume overloaded and are hypokalemic from high-dose diuretics.
                \r• Correct electrolyte imbalances, avoid hyperventilation and improve bicarb excretion with volume, CL and K+.
                \r• There will be a shift in the 02 dissociation curve to the left due to the increased affinity for Hb-02.
                \r• Acetazolamide (Diamox) can increase HC03 excretion. Monitor P04- and K+ levels.
                \r• Labs: Common to observe hypokalemia, hypocalcemia during severe cases of alkalemia as there's increased binding of plasma proteins to ionized Ca++ and hypochloremia.
                \rRespiratory alkalosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• Respiratory alkalosis is a decrease in C02 with or without a mandatory decrease in HC03. The compensatory response is a renal loss of plasma HC03 - approx. 2 mEq/L for every 10 mmHg the C02 decreases below 40.
                \r• Those who have chronic conditions where  C02 is reduced for more than 3-5 days, then you may notice the HC03 fall approx 3-5 mEq/L for q 10 mmHg C02.
                \r• Generally not life-threatening.
                \r• Increases in respiratory minute volume or respiratory rate will cause the pH to increase.
                \r• Treat the underlying etiology, electrolyte imbalance and volume status.
                \r• Can consider Acetazolamide (Diamox) and avoid hyperventilation.
                \r• The priority is to treat any underlying hypoxemia.
                """
                
                
            case .Mixed_MetabolicAcidosis_RespAlkalosis:
                return """
                \r• More than one primary acid-base disorder may be present simultaneously. It is important to identify and address each primary acid-base disorder.
                \r• Typically in an Anion Gap Metabolic Acidosis, the rise in AG should be equal to the decrease in HC03. In Non- Anion Gap Metabolic Acidosis, the reduction of HC03 should equal the rise in chloride. Typically, there's an inability of the kidneys to secrete HC03, or there's a direct loss of HC03.
                \r• NaHC03 is typically the agent commonly used to correct the metabolic acidosis. Refer to the HC03 deficit calculator to determine the HC03 deficit.
                \r• However, treatment can be controversial and sometimes not helpful as studies show that it can worsen intracellular acidosis in those patients with sepsis and lactic acidosis. Although there's low-quality evidence from observational studies, current literature suggests that NaHC03 is held unless the pH is < 7.1, then address the primary process once the pH rises. There are advantages and disadvantages.
                \r• Disadvantages of NaHC03: When treating a chronic metabolic acidosis, there can be a progression of renal disease, negative nitrogen balance, and growth retardation.
                \r• Disadvantages include: Intracellular lactate production, paradoxical intracellular acidosis, increased Na load, Left shift of the oxyhemoglobin dissociation curve.
                \r• A side effect of NaHC03 treatment is the subsequent rise in PaC02. Be sure to make the necessary ventilatory adjustments to subvert hypercapnia. If not, consider THAM. THAM consumes C02 and doesn't provide a sodium load as it's not a sodium salt like NaH03.
                \r• Clinical changes: Hyperventilation, right shift on the oxyhemoglobin dissociation curve, hyperkalemia, catecholamine resistance, and pulmonary vasoconstriction.
                \r• Respiratory alkalosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• Respiratory alkalosis is a decrease in C02 with or without a mandatory decrease in HC03. The compensatory response is a renal loss of plasma HC03 - approx. 2 mEq/L for every 10 mmHg the C02 decreases below 40.
                \r• Those who have chronic conditions where  C02 is reduced for more than 3-5 days, then you may notice the HC03 fall approx 3-5 mEq/L for q 10 mmHg C02.
                \r• Generally not life-threatening.
                \r• Increases in respiratory minute volume or respiratory rate will cause the pH to increase.
                \r• Treat the underlying etiology, electrolyte imbalance and volume status. You may notice a slight fall in serum K+, phosphate and reduction in calcium.
                \r• The priority is to treat any underlying hypoxemia.
                
                """
                // default: break
                
                //MARK: - Metabolic Alkalosis and Resp Acidosis
            case .Metabolic_Alkalosis_Respiratory_Acidosis:
                return """
                \r• In Metabolic Alkalosis, look to correct the underlying issue.
                \r• Chloride Response:
                \rWhen Metabolic Alkalosis is chloride-responsive, there's usually excess secretion (depletion) of chloride ions - making the concentration of chloride in the urine low. The chloride ions can be depleted usually due to:
                
                \r1) Loop or Thiazide diuretics: Which result in a metabolic alkalosis due to the loss of K+ and H+ in the urine.
                \r2) Gastric Suctioning or Vomiting
                \r3) Use of laxatives
                \r4) Hypercapnia
                \r5) Contraction Alkalosis: Due to volume depletion and the use of fluids with a high sodium chloride concentration. The serum HC03 ultimately rises when there's decreased renal perfusion or excess loss of H+ from the GI tract or urine. In the kidneys, this will cause renin and aldosterone to be secreted. Therefore, increased angiotension II will cause an increase in Na+ and H+ ion exchange in the proximal tubule, thus increasing HC03 reabsorbsion.
                    
                \rThis generally can be corrected by administering NaCl fluids, intravenously.
                    
                \rWhen Metabolic Alkalosis is chloride- unresponsive or resistant, NaCl infusion typically won't correct the disorder as it would in chloride-responsive alkalosis. Usually, there's a deficiency in electrolytes: Such as potassium and/or magnesium - or excess in mineralocorticoids. A high urine chloride in the presence of hypertension can be suggestive of excess in mineralocorticoids, Liddle's syndrome, Conn's syndrome, Cushings disease, or primary and secondary hyperaldosteronsim.
                    
                \r• Note: There's also a chance that a patient can present with co-existing forms of chloride responsiveness: as in patients that are volume overloaded and are hypokalemic from high-dose diuretics.
                    
                \r• Correct electrolyte imbalances, avoid hyperventilation and improve bicarb excretion with volume, CL and K+.
                    
                \r• There will be a shift in the 02 dissociation curve to the left due to the increased affinity for Hb-02.
                    
                \r• Acetazolamide (Diamox) can increase HC03 excretion. Monitor P04- and K+ levels.
                    
                \r• Labs: Common to observe hypokalemia, hypocalcemia during severe cases of alkalemia as there's increased binding of plasma proteins to ionized Ca++ and hypochloremia.
                \r• Respiratory acidosis boils down to one pathway - Minute Ventilation - RR x TV
                \r• The PaC02 generally will return to normal after restoring adequate alveolar ventilation.
                \r• Bicarbonate is not involved in this disorder as it can't buffer itself. It's almost always contraindicated in treating this disorder.
                \r• You can appreciate CNS depression at high levels of PaC02 which can result in confusion, dyspnea, disorientation, headache. etc.
                """
            } // close switch
            
        } // close fn
        
    } // Close enum
    
    
}


extension UIColor {
    static func component(red: Int, green: Int, blue: Int, opacity: Double) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0,
                      green: CGFloat(green)/255.0,
                      blue: CGFloat(blue)/255.0,
                      alpha: opacity)
    }
}
