//
//  CheckDrioTextFieldsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 01/12/2021.
//

import SwiftUI
//import SwiftUITooltip


struct CheckDrioTextFieldsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var weightTextField: String = ""
    @State private var doseTextField: String = ""
    @State private var bagTextField: String = ""
    @State private var flowRateTextField: String = ""
    @State private var value: Double = 0
    @State private var weight: Double = 0
    @State private var dose: Double = 0
    @State private var bag: Double = 0
    @State private var flowRate: Double = 0
    @State private var finalResult: String = ""
    @State private var resultDetail: String = ""
    @State private var mg: String = ""
    
    let potiency: [String] = ["g/min", "g/hr", "mg/min", "mg/hr", "mcg/min", "mcg/hr", "mcg/kg/min","mcg/kg/hr", "mg/kg/hr", "units/kg/hr", "mEq/kg/hr"]
    @State private var slectedObj = "g/min"
    @State var enableSheet = false
    @State var index = 0
    
    @State private var milligramsPermL: String = ""
    @State private var changePosition = false
    @State private var isHidden: Bool = false
    @State var showingPopup = false
    
    let pickerPresented: () -> Void
    
    
    //MARK: Part of Collapsing Segment
    @State var showingTab1 = false
    @State var showingTab2 = false
    @State var showingTab3 = false
    
    @State var calcName = "When to Use"
    var data: clinicalCalculatorData
    
    
    @State var tooltipConfig = DefaultTooltipConfig()
    @State var padding: CGFloat = -10
    @State var isPadding = false
    let timer = Timer.publish(
        every: 0.5, // second
        on: .main,
        in: .common
    ).autoconnect()
 
    
    struct DefaultTooltipConfig {
      
            var animationOffset: CGFloat
            var animationTime: Double
            var backgroundColor: Color
            var borderColor: Color
            var contentPaddingTop: CGFloat
            var contentPaddingBottom: CGFloat
            var contentPaddingLeft: CGFloat
            var contentPaddingRight: CGFloat
            var margin: CGFloat
            
            init(
                animationOffset: CGFloat = 40,
                animationTime: Double = 2,
                backgroundColor: Color = .clear,
                borderColor: Color = .clear,
                contentPaddingTop: CGFloat = -10,
                contentPaddingBottom: CGFloat = 0,
                contentPaddingLeft: CGFloat = 0,
                contentPaddingRight: CGFloat = 0,
                margin: CGFloat = 0
            ) {
                self.animationOffset = animationOffset
                self.animationTime = animationTime
                self.backgroundColor = backgroundColor
                self.borderColor = borderColor
                self.contentPaddingTop = contentPaddingTop
                self.contentPaddingBottom = contentPaddingBottom
                self.contentPaddingLeft = contentPaddingLeft
                self.contentPaddingRight = contentPaddingRight
                self.margin = margin
            }
            
           
        
    }

 
    
    // MARK: Animating Segment
    struct calculatorDetailSegment: View {
        @Binding var selected: String
        @Binding var showingTab1: Bool
        @Binding var showingTab2: Bool
        @Binding var showingTab3: Bool
        
        
        // Changed State for the Animation
        
        
        // The name of the segments
        let labels = ["When to Use", "Key Points", "Why Use It"]
        
        var body: some View {
            
            HStack(spacing:0) {
                
                ForEach(labels, id: \.self) { label in
                    
                    VStack(spacing: 4) {
                        
                        HStack {
                            
                            Text(label).font((selected == label) ?  .system(size: 15).bold() : .system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(getTitleColor(index: labels.firstIndex(of: label)!))
                                .padding(.leading, 5)
                            //.padding(.trailing)
                                .animation(.easeInOut(duration: 0.5), value: selected)
                            
                            Image(systemName:"chevron.down.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15 , height: 15)
                                .shadow(radius: 5)
                            
                            //Accessing the animation_Calc_DropSegment Function and the child functions inside to get Info
                                .foregroundColor(getArrowColor(index: labels.firstIndex(of: label)!))
                                .rotationEffect(.degrees(getRotateAngle(index: labels.firstIndex(of: label)!))) // Change degrees on change"
                                .animation(.default, value: getValueChange(index: labels.firstIndex(of: label)!))
                        }
                        
                        Rectangle()
                            .frame(width: 75, height: 4)
                            .foregroundColor((selected == label) ? Color.BlueYonder : .clear)
                            .padding(.bottom, 10)
                        
                    }
                    .padding(.top, 2)

                    // What happens when we tap a section
                    .onTapGesture {
                        selected = label
                        #if DEBUG
                        print("onTapGesture Selected Index: \(selected)")
                        #endif

                        // Animating drop down and arrow turning.
                        if selected == "When to Use" {
                            showingTab1.toggle()
                            showingTab2 = false
                            showingTab3 = false

                        }
                        if selected == "Key Points" {
                            showingTab2.toggle()
                            showingTab1 = false
                            showingTab3 = false

                        }
                        if selected == "Why Use It"{
                            showingTab3.toggle()
                            showingTab2 = false
                            showingTab1 = false
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: showingTab1 || showingTab2 || showingTab3)
                    
                    if labels.firstIndex(of: label) != 2 {
                        Spacer()
                    }
                }
            }
            
            .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
            // Optional Divider before the text
            //            Divider()
            //                .frame(width: UIScreen.main.bounds.width * 0.9, height: 1)
            //                .background(Color(UIColor.component(red: 209, green: 209, blue: 209, opacity: 1)))
            
        }
        
        // MARK: Rotation Angle Function
        func getRotateAngle(index: Int) -> Double{
            // Switch on the index item of the label array
            switch index {
            case 0: // When to use
                if showingTab1 {
                    return 0
                }
                else{
                    return -180
                }
            case 1: // Critical Pearls
                if showingTab2 {
                    return 0
                }
                else {
                    return -180
                }
            case 2: // Why We Use
                if showingTab3 {
                    return 0
                }
                else {
                    return -180
                }
            default:
                return 0
            }
        }
        
        func getTitleColor(index: Int) -> Color{
            
            // Switch on the index item of the label array
            switch index {
            case 0:// When to use
                if showingTab1 {
                    
                    return Color.red
                } else
                {
                    return .criticalBlue
                }
            case 1: // Critical Pearls
                if showingTab2 {
                    return .red
                } else
                {
                    return .criticalBlue
                }
            case 2: // Why We Use
                if showingTab3 {
                    return .red
                } else
                {
                    return .criticalBlue
                }
            default:
                return .green
            }
        }
        
        func getArrowColor(index: Int) -> Color{
            
            // Switch on the index item of the label array
            switch index {
            case 0:// When to use
                if showingTab1 {
                    return .green
                } else
                {
                    return .gunMetal_Gray
                }
            case 1:// Critical Pearls
                if showingTab2 {
                    return .green
                    
                } else
                {
                    return .gunMetal_Gray
                }
            case 2: // Why We Use
                if showingTab3 {
                    return .green
                }  else
                {
                    return .gunMetal_Gray
                }
            default:
                return .green
            }
        }
        
        func getValueChange(index: Int) -> Bool{
            
            // Switch on the index item of the label array
            switch index {
            case 0: // When to use
                return showingTab1
            case 1:// Critical Pearls
                return showingTab2
            case 2:// Why We Use
                return showingTab3
            default:
                return false
            }
        }
        
        
    }
    
    
    var body: some View {
        
        // MARK:  Detail Segment
        VStack(alignment: .leading, spacing: 0){
            
            calculatorDetailSegment(selected: $calcName, showingTab1: $showingTab1, showingTab2: $showingTab2, showingTab3: $showingTab3)
                .padding(.top, 15)
            
            // The Drug Detail String has to be accurate
            if calcName == "When to Use" {
                //Change the data here for the appropriate VC
                if showingTab1 {
                    Text(clinicalCalculatorData.checkmyDripSegmentDetails.whatToKnow)
                        .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                        .font(.system(size: 16))
                        .foregroundColor(Color.charcol_gray)
                        .padding(.bottom, 20)
                        .padding(.top,15)
                    
                }
            }
            else if calcName == "Key Points" {
                //Change the data here for the appropriate VC
                if showingTab2 {
                    Text(clinicalCalculatorData.checkmyDripSegmentDetails.pearls)
                        .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                        .font(.system(size: 16))
                        .foregroundColor(Color.charcol_gray)
                        .padding(.bottom, 20)
                        .padding(.top,15)
                }
            }
            
            else if calcName == "Why Use It" {
                //Change the data here for the appropriate VC
                if showingTab3 {
                Text(clinicalCalculatorData.checkmyDripSegmentDetails.whyUse)
                    .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                    .font(.system(size: 16))
                    .foregroundColor(Color.charcol_gray)
                    .padding(.bottom, 20)
                    .padding(.top,15)
                }
            }
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.95)
        //.background(Color(UIColor.component(red: 71, green: 159, blue: 156, opacity: 0.15)))
        .cornerRadius(8)
        .shadow(color: Color.gray.opacity(0.01), radius: 5, x: 0, y: 2)
        .shadow(color: Color.critical_gray.opacity(0.01), radius: 20, x: 0, y: 10)
        // Theres Ultrathin, regular, thick material as well
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        .animation(.easeInOut(duration: 0.5), value: calcName)
        .padding(.top, 10)
        .shadow(radius: 28)
        .onAppear {
            tooltipConfig.animationOffset = 40
            tooltipConfig.animationTime = 2
            tooltipConfig.backgroundColor = .clear
            tooltipConfig.borderColor = .clear
            tooltipConfig.contentPaddingTop = -10
            tooltipConfig.contentPaddingBottom = 0
            tooltipConfig.contentPaddingLeft = 0
            tooltipConfig.contentPaddingRight = 0
            tooltipConfig.margin = 0
            
        }
        
        
        // MARK: End of Data Segment
        
        
        VStack(spacing: 0){
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color.purple)
                VStack(alignment: .leading, spacing: 10){
                    Text("Weight")
                        .foregroundColor(Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 1)))
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .padding(.leading, 5)
                    
                    Text("Optional")
                        .foregroundColor(Color.red)
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .padding(.leading, 5)
                }
                Spacer()
                Text("KG")
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .padding(.top, 10)
                
                TextField("", text: $weightTextField, onEditingChanged: { editing in
                    if editing {
                        weightTextField = ""
                    }
                })
                   
                // MARK: Placeholder for textField
                    .placeholder(when: weightTextField.isEmpty) {
                            Text("96").foregroundColor(.gray)
                            .opacity(0.3)
                    }
                    .font(.system(size: 36, weight: .medium, design: .default))
                    .foregroundColor(Color.rollTide_red)
                    .frame(width: 80, height: 25)
                    .padding(.leading, 20)
                    .minimumScaleFactor(0.5)
                    .keyboardType(.decimalPad)
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(Color.babyPowderWhite))
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .padding(.top, 5)
            .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 4, x: 0, y: 4)
            .shadow(radius: 8)
            .animation(.easeInOut(duration: 0.5), value: weightTextField)

            
            VStack{
                
            }
            .frame(width: 16, height: 42, alignment: .leading)
            //Changes the background of the navigation Bar
                .background(Color.criticalBlue)
            .animation(.easeInOut(duration: 0.5), value: isHidden)

            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color.rollTide_red)
                .animation(.easeInOut(duration: 0.5), value: isHidden)

                VStack(alignment: .leading, spacing: 10){
                    Text("Total Dose in Solution")
                        .foregroundColor(Color.gunMetal_Gray)
                        .font(.system(size: 24, weight: .regular, design: .default))
                        .padding(.leading, 5)
                    
                    Text("On Hand, Available:  Mg, Units, mEq")
                        .foregroundColor(Color.red)
                        .font(.system(size: 13, weight: .regular, design: .default))
                        .padding(.leading, 5)
                        .padding(.bottom, 10)

                }
                Spacer()
                Text("\(mg)")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(Color.gray)
                    .padding(.top, 10)
                
                TextField("", text: $doseTextField, onEditingChanged: { editing in
                    if editing {
                        doseTextField = ""
                    }

                })
               
                // MARK: Placeholder for textField
                    .placeholder(when: doseTextField.isEmpty) {
                            Text("21").foregroundColor(.gray)
                            .opacity(0.3)
                    }
                    .accentColor(Color.red)
                    .font(.system(size: 36, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .frame(width: 80, height: 25)
                    .minimumScaleFactor(0.5)
                    .padding(.leading, 20)
                    .keyboardType(.decimalPad)
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(Color(.white)))
            .frame(width: UIScreen.main.bounds.width * 0.95)
            //.shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
            //.shadow(radius: 8)
            .animation(.easeInOut(duration: 0.5), value: doseTextField)

            
            HStack{
                Spacer()
                VStack{
                    Rectangle()
                    .fill(Color.green)
                    .frame(width: 16, height: 44)
                    .padding(.trailing, 50)
                    .animation(.easeInOut(duration: 0.5), value: isHidden)
                   // MARK:  Overlay over the line
//                    .overlay(
//                        HStack {
//                        Image(systemName: "arrow.down")
//                        Text("Mixed Into")
//                        }
//                            .frame(width: 150, height: 60, alignment: .center)
//                            .font(.system(size: 17, weight: .heavy, design: .default))
//                            .foregroundColor(Color.white)
//                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.rollTide_red))
//                            .shadow(radius: 8, y: 14)
//                            .offset(x: changePosition ? 0: 0, y: changePosition ? -10: 10)
//                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
//                            .onAppear(perform: {
//                                changePosition.toggle()
//                            }))
            }
                .animation(.easeInOut(duration: 0.5), value: isHidden)

                Spacer()
                Spacer()

                Rectangle()
                    .fill(Color.criticalBlue)
                    .frame(width: 16, height: 44)
                    .padding(.leading, 50)
                    .animation(.easeInOut(duration: 0.5), value: isHidden)

                Spacer()
            }
            
            // MARK: Start new stack
            HStack{
                HStack{
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 16, height: 86)
                    VStack(alignment: .leading){
                        Text("Volume")
                            //.frame(width: 70)
                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                            .font(.system(size: 18, weight: .medium, design: .default))

                    }
                    .padding(.bottom, 13)
                   Spacer()
                    VStack(alignment: .leading, spacing: 0){
                        
                        TextField("", text: $bagTextField, onEditingChanged: { editing in
                            if editing {
                                bagTextField = ""
                            }
                        })
                        
                        // MARK: Placeholder for textField
                            .placeholder(when: bagTextField.isEmpty) {
                                Text("250").foregroundColor(.gray)
                                    .opacity(0.3)
                            }
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.green)
                            .minimumScaleFactor(0.6)
                            .font(.system(size: 36, weight: .medium, design: .default))
                            .padding(.top, 3)
                            .keyboardType(.decimalPad)
                        
                        Text("mL's")
                            .font(.system(size: 13, weight: .medium, design: .default))
                            .foregroundColor(Color.orange_TerraCotta)
                            .padding(.leading, 40)
                            .padding(.bottom, 3)
                    }
                    .padding(.trailing, 3)
                }
                .frame(width: UIScreen.main.bounds.width * 0.45, height: 86)
                .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(Color.babyPowderWhite))
                //.shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                //.shadow(radius: 8)
                .animation(.easeInOut(duration: 0.5), value: bagTextField)
//                .tooltip(.top, config: tooltipConfig) {
//                        HStack {
//                            Image(systemName: "arrow.down")
//                                .foregroundColor(Color.yellowColor)
//                        
//                            Text("Mixed Into")
//                                .foregroundColor(Color.white)
//
//                            Image(systemName: "arrow.down")
//                                .foregroundColor(Color.yellowColor)
//                        }
//                            .frame(width: 140, height: 40, alignment: .center)
//                            .font(.system(size: 15, weight: .medium, design: .default))
//                            .foregroundColor(Color.white)
//                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.criticalBlue).opacity(0.6))
//                            .padding(.top,10)
//                            .shadow(radius: 8, y: 14)
//                            .shadow(radius: -8, y: -14)
//                            .padding(.bottom, padding)
//                            .onReceive(timer) { (_) in
//                                withAnimation (.easeInOut(duration: 1.0)) {
//                                    isPadding = !isPadding
//                                    if isPadding {
//                                        padding = 90
//                                    }else{
//                                        padding = -10
//                                        
//                                    }                                    
//                                }
//                                
//                            }                .animation(.easeInOut(duration: 0.5))
//
//               
//                }

                Spacer()
                
                HStack{
                    Rectangle()
                        .fill(Color.royal_blue)
                        .frame(width: 16, height: 86)
                    
                    VStack(alignment: .leading){
                        Text("Flow Rate")
                            //.frame(width: 70)
                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                            .font(.system(size: 18, weight: .medium, design: .default))

                    }
                    .padding(.bottom, 13)
                   Spacer()
                    VStack(alignment: .leading, spacing: 0){
                       
                        TextField("", text: $flowRateTextField, onEditingChanged: { editing in
                            if editing {
                                flowRateTextField = ""
                            }
                        })
                            .placeholder(when: flowRateTextField.isEmpty) {
                                HStack{
                                    Spacer()
                                    Text("12").foregroundColor(.gray)
                                        .opacity(0.3)
                                    Spacer()
                                }

                            }
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.charcol_gray)
                            .minimumScaleFactor(0.6)
                            .font(.system(size: 36, weight: .medium, design: .default))
                            .padding(.top, 3)
                            .keyboardType(.decimalPad)
                        
                        Text("mL/hr")
                            .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 13))
                            .foregroundColor(Color.orange_TerraCotta)
                            .padding(.leading, 20)
                            .padding(.bottom, 3)
                    }
                    .padding(.trailing, 3)
                }
                .frame(width: UIScreen.main.bounds.width * 0.45, height: 86)
                .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
               // .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
               // .shadow(radius: 8)
                .animation(.easeInOut(duration: 0.5), value: flowRateTextField)

            } // Hstack divider
            .frame(width: UIScreen.main.bounds.width * 0.80, height: 86)
            
//            HStack{
//                VStack{
//                    HStack{
//                        VStack(alignment: .leading){
//                            Text("IV")
//                            Text("Bag")
//                                .padding(.top, 5)
//                        }
//                        .padding(.leading, 20.0)
//                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
//                        .font(.system(size: 18, weight: .medium, design: .default))
//                        VStack{
//                            TextField("", text: $bagTextField, onEditingChanged: { editing in
//                                if editing {
//                                    bagTextField = ""
//                                }
//                            })
//
//                            // MARK: Placeholder for textField
//                                .placeholder(when: bagTextField.isEmpty) {
//                                        Text("250").foregroundColor(.gray)
//                                        .opacity(0.3)
//                                }
//                                .multilineTextAlignment(.leading)
//                                .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
//                                .font(.system(size: 34, weight: .medium, design: .default))
//                                .minimumScaleFactor(0.5)
//                                .keyboardType(.decimalPad)
//                            Text("mL's")
//                                .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
//                                .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 14))
//
//                        }
//                        .padding(.top, 30)
//                        .padding(.leading, 20)
//
//                    }
//                    Rectangle()
//                        .fill(Color.midnightBlue)
//                        .frame(width: 190, height: 5, alignment: .leading)
//                    //.padding(.leading, 10)
//                                     }
//
//                Spacer()
//                VStack{
//                    HStack{
//                        VStack(alignment: .leading){
//                            Text("Flow")
//                            Text("Rate")
//                                .padding(.top, 5)
//                        }
//                        .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
//                        .font(.system(size: 18, weight: .medium, design: .default))
//                        VStack(alignment: .leading){
//
//                            // MARK: Placeholder for textField
//                            TextField("", text: $flowRateTextField, onEditingChanged: { editing in
//                                if editing {
//                                    flowRateTextField = ""
//                                }
//                            })
//                                .placeholder(when: flowRateTextField.isEmpty) {
//                                        Text("12").foregroundColor(.gray)
//                                        .opacity(0.3)
//                                }
//                                .frame(width: 90)
//                                .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
//                                .font(.system(size: 34, weight: .medium, design: .default))
//                                .minimumScaleFactor(0.5)
//                                .keyboardType(.decimalPad)
//                            Text("mL's")
//                                .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
//                                .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 14))
//
//                        }
//                        .padding(.top, 30)
//                        .padding(.leading, 20)
//
//                    }
//                    Rectangle()
//                        .fill(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
//                        .frame(width: 163, height: 5, alignment: .trailing)
//                    //.padding(.trailing, 10)
//                        .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
//                }
//
//            }
//            .frame(width: UIScreen.main.bounds.width * 0.95)
//
            Spacer(minLength: 0)
            
            Text(milligramsPermL)
                .font(.system(size: 25, weight: .medium, design: .default))                .foregroundColor(Color.blue)
                .padding(.top, 20)
                .opacity(isHidden ? 1 : 0)
            
            Button(action: {
                enableSheet = true
                hideKeyboard()
                pickerPresented()
            }){
                HStack{
                    Text("Analyze")
                        .font(.system(size: 22).weight(.heavy))
                        .foregroundColor(Color.white)
                        .padding()
                }
                

            }
            .frame(width: 230, height: 55)
            //.foregroundStyle(.ultraThinMaterial)
            .background(Color.royal_blue)
            .cornerRadius(8)
            .shadow(radius: 8, y: 14)
            .padding(.top, 20)
            .animation(.easeInOut(duration: 0.5), value: isHidden)
            .fullScreenCover(isPresented: $showingPopup, content: {
                WarningPopupView(title: "Wait!!", message: "Enter value in all fields, then recalculate!")
                    .background(BackgroundClearView())
            })
            
//            Text("Result")
//                .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 14))
//                .foregroundColor(Color.blue)
//                .padding(.top, 20)
//                .opacity(isHidden ? 1 : 0)
            
            if isHidden {
                CheckDripsResultView(result: finalResult, resultDetail: resultDetail)
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                    .animation(.easeInOut(duration: 0.5), value: finalResult)
            }

        }
//        .blur(radius: $enableSheet.wrappedValue ? 1 : 0)
//        .overlay(
//            $enableSheet.wrappedValue ? Color.black.opacity(0.6) : nil
//        )
        if $enableSheet.wrappedValue {
            GeometryReader { gr in
                VStack {
                    VStack {
                        HStack{
                            Button(action: {
                                self.enableSheet = false
                            }) {
                                HStack{
                                    Text("Cancel").fontWeight(Font.Weight.bold)
                                }
                                .foregroundColor(Color.blue)
                            }
                            .padding(.all)
                            Spacer()
                            
                            Button(action: {
                                #if DEBUG
                                print("Selected: \(slectedObj)")
                                #endif
                                validation()
                                index = potiency.firstIndex(of: slectedObj) ?? 0
                                resultDetail = "\(slectedObj)"
                                self.enableSheet = false
                            }) {
                                HStack{
                                    Text("Done").fontWeight(Font.Weight.bold)
                                }
                                .foregroundColor(Color.blue)
                            }
                            .padding(.all)
                        }
                        .background(Color.homeLightBackgroundColor)
                        
                        Picker("Please choose a color", selection: $slectedObj) {
                            ForEach(potiency, id: \.self) {
                                Text($0)
                            }
                            
                        }.labelsHidden()
//                        Text("Selected: \(slectedObj)")
                    }
//                    .pickerStyle(WheelPickerStyle())
                    .background(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 10))
                    .foregroundColor(Color.newred)
                    .animation(.easeInOut(duration: 0.5), value: enableSheet)

                }
                .position(x: gr.size.width / 2 ,y: gr.size.height - 62)
            }
        }
        
    }

}

struct CheckDrioTextFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        CheckDrioTextFieldsView(pickerPresented: {}, data: clinicalCalculatorData.checkmyDripSegmentDetails)
    }
}


//MARK: - Calculation
extension CheckDrioTextFieldsView {
    
    func CalCulation() {
        
        weight = Double(weightTextField) ?? 0
        dose = Double(doseTextField) ?? 0
        bag = Double(bagTextField) ?? 0
        flowRate = Double(flowRateTextField) ?? 0
        
        let calcDosePerMl = {(doseIn: Double, bag: Double) -> (Double) in
            //Acutal Calculation
            return (dose / bag)
        }
        
        //Converting the result value.
        let mgPerMLResult = Double(calcDosePerMl(dose, bag))
        
        // Calculated the mg/ml and coverts to mcg
        let mcgResult = mgPerMLResult * 1000
        
        // Rounds to the 1st decimal place
        let shortmgPerMLResult3 = String(format:"%.1f", mcgResult)
        
        // Rounds to the 1st decimal place
        let shortmgPerMLResult = String(format:"%.1f",mgPerMLResult)
        
        milligramsPermL = "\(shortmgPerMLResult) mg/mL"
        
        
        //MARK: - mcg/Hr Calculation
        func mcgHr () -> Double {
            
            return (flowRate * (dose / bag) )
        }
        
        //MARK: - mg/hr Closure
        // Closure with Multiple Parameters and One Return type
        let mgHr = {(mg: Double ,mL: Double ,flowRate ) -> Double in
            // Enter code.
            return (mg / mL) * flowRate
        }
        
        //Calcualtes the dose
        let mgPerHr =  mgHr(dose, bag, flowRate)
        
        
        //Shortens the double to one sig fig
        let mgPerHr_shortened = String(format:"%.1f",mgPerHr) // Rounds to the 1st decimal place
        
        
        
        //MARK: - Conditionals
        // If mg/mL is < 0.1, then we convert to micrograms.
        if mgPerMLResult < 0.1 {
            
            //Set the text label
            milligramsPermL = "\(shortmgPerMLResult3) mcg/mL"
        } else if mgPerMLResult > 0.1 {
            milligramsPermL = "\(shortmgPerMLResult) mg/mL"
            
        }
        
        // Only used for Units
        if slectedObj == "units/kg/hr"  {
            if mcgResult == 1 {
                milligramsPermL = "\(mgPerMLResult) unit/mL"
            } else {
            milligramsPermL = "\(mgPerMLResult) units/mL"
            }
        }
        
        if slectedObj == "mEq/kg/hr" {
            milligramsPermL = "\(mgPerMLResult * 1000) mEq/mL"

        }
        
        
        
        
        
        //MARK: - g/min
        if slectedObj == "g/min" {
            var gMin1: Double { return  (dose / bag) * (flowRate / 1000 / 60) }
            
            let gMin = String(format:"%.3f",gMin1)
            if Double(gMin) == 0.000 {
                finalResult = "ERROR"
                resultDetail = "Please try a new calculation"
            }
            finalResult = "\(gMin)"
            resultDetail = "g/min"
        }
        
        
        
        //MARK: - mg/hr
        else if slectedObj == "mg/hr" {
            
            // Sets the label to the shortened value
            finalResult = "\(mgPerHr_shortened)"
            resultDetail = "mg/hr"
        }
        
        //MARK: -  mg/min
        else if slectedObj == "mg/min" {
            
            let mgMin = mgPerHr / 60
            let mgMin_short = String(format:"%.2f",mgMin)
            // Sets the label to the shortened value
            finalResult = "\(mgMin_short)"
            resultDetail = "mg/min"
        }
        
        //MARK: - mcg/min
        else if slectedObj == "mcg/min" {
            
            // Takes the mg.min calculation * 1000
            let mcgMin = (mgPerHr / 60) * 1000
            
            // Rounds to the 2st decimal place
            let mcgMin_short = String(format:"%.1f",mcgMin)
            
            // Sets the label to the result rounded to 2 decimal places
            finalResult = "\(mcgMin_short)"
            resultDetail = "mcg/min"
        }
        
        // MARK: - mcg/Hr
        else if slectedObj ==  "mcg/hr" {
            
            finalResult = "\(mcgHr())"
            resultDetail = "mcg/hr"
        }
        
        //MARK: - mcg/kg/min
        else if slectedObj == "mcg/kg/min" {
            
            var calculationOfMcgKgMin: Double {
                
                let mcgKgMin = ((dose * 1000) * flowRate) / (bag * 60 * weight)
                
                return mcgKgMin
            }
            // Shortens the result to a 2 sigFig string.
            let shortResultofMcgKgMin = String(format:"%.1f",calculationOfMcgKgMin) // Rounds to the 1st decimal place
            
            // Sets the label to the shortened result.
            finalResult = "\(shortResultofMcgKgMin)"
            
            resultDetail = "mcg/kg/min"
        }
        
        //MARK: - mcg/kg/Hr
        else if slectedObj == "mcg/kg/hr" {
            
            var calculationOfMcgKgHr: Double {

              // Calculate rate in mL/kg/hr
              let rateMlKgHr = flowRate / weight

              // Calculate mcg/mL
              let mcgPerMl = dose / bag

              // Calculate mcg/kg/hr
              let mcgKgHr = mcgPerMl * rateMlKgHr

              return mcgKgHr

            }
            
            // Shortens the result to a 2 sigFig string.
            let shortResultofMcgKgHr = String(format:"%.2f",calculationOfMcgKgHr) // Rounds to the 1st decimal place
            
            // Sets the label to the shortened result.
            finalResult = "\(shortResultofMcgKgHr)"
            
            resultDetail = "mcg/kg/hr"
        }
        
        //MARK: - mcg/kg/Hr
        else if slectedObj == "mg/kg/hr" {

            var calculationOfMgKgHr: Double {
                
                // Calculate rate in mL/kg/hr
                let rateMlKgHr = flowRate / weight

                // Calculate mg/mL
                let mgPerMl = dose / bag
                
                // Calculate mg/kg/hr
                let mgKgHr = mgPerMl * rateMlKgHr
                
                return mgKgHr
            }

            // Shortens the result to a 2 sigFig string.
            let shortResultofmgKgHr = String(format:"%.1f",calculationOfMgKgHr) // Rounds to the 1st decimal place

            // Sets the label to the shortened result.
            finalResult = "\(shortResultofmgKgHr)"

            resultDetail = "mg/kg/hr"
        }
        
        //MARK: - mEq/kg/Hr
        else if slectedObj == "mEq/kg/hr" {

            var calculationOfMeqKgHr: Double {

              // Calculate rate in mL/kg/hr
              let rateMlKgHr = flowRate / weight

              // Calculate mEq/mL
              let meqPerMl = dose / bag

              // Calculate mEq/kg/hr
              let meqKgHr = meqPerMl * rateMlKgHr
                
                // Print result
                  #if DEBUG
                  print("mEq/kg/hr: \(meqKgHr)")
                  #endif


              return meqKgHr

            }

            // Shortens the result to a 2 sigFig string.
            let shortResultofmeQKgHr = String(format:"%.1f",calculationOfMeqKgHr) // Rounds to the 1st decimal place

            // Sets the label to the shortened result.
            finalResult = "\(shortResultofmeQKgHr)"

            resultDetail = "mEq/kg/hr"
        }
    
    //MARK: - units/kg/Hr
    else if slectedObj == "units/kg/hr" {

    
        var calculationOfUnitsKgHr: Double {

          // Calculate rate in mL/kg/hr
          let rateMlKgHr = flowRate / weight

          // Calculate units/mL
          let unitsPerMl = dose / bag

          // Calculate units/kg/hr
          let unitsKgHr = unitsPerMl * rateMlKgHr
            
            // Print result
              #if DEBUG
              print("units/kg/hr: \(unitsKgHr)")
              #endif


          return unitsKgHr

        }

        // Shortens the result to a 2 sigFig string.
        let shortResultofunitsKgHr = String(format:"%.1f", calculationOfUnitsKgHr) // Rounds to the 1st decimal place

        // Sets the label to the shortened result.
        finalResult = "\(shortResultofunitsKgHr)"

        resultDetail = "units/kg/hr"
        
        print (" units kg hour is ", shortResultofunitsKgHr)
    }
    
}
    
    //MARK: - Check Textfields are empty or not
    func validation() {
        
        if slectedObj == "mcg/kg/hr" || slectedObj == "mcg/kg/min" {
            if !weightTextField.isEmpty && !doseTextField.isEmpty && !bagTextField.isEmpty && !flowRateTextField.isEmpty{
                CalCulation()
                isHidden = true
                showingPopup = false
            } else {
                isHidden = false
                showingPopup = true
            }
        }else{
            if !doseTextField.isEmpty && !bagTextField.isEmpty && !flowRateTextField.isEmpty{
                CalCulation()
                isHidden = true
                showingPopup = false
            } else {
                isHidden = false 
                showingPopup = true
            }
        }
        

    }
}


