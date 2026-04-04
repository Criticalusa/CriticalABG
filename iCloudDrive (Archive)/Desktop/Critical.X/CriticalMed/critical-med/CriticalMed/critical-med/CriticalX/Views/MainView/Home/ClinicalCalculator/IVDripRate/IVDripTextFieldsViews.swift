//
//  IVDripTextFieldsViews.swift
//  CriticalX
//
//  Created by Macbook 4 on 10/12/2021.
//

import SwiftUI
//import RadioGroup

struct IVDripTextFieldsViews: View {

    @Environment(\.colorScheme) var colorScheme
    @State private var volumeTextField: String = ""
    @State private var durationTextField: String = ""
    @State private var dripTextField: String = ""
    
    @State private var volume: Double = 0.0
    @State private var duration: Double = 0.0
    @State private var drip: Double = 0.0
    
    @State var resultInMinHr: Double = 0.0
    @State var mLresult: Double = 0.0
    
    @State var showingPopup = false
    @State var isHidden = false
    @State var selection = 0
   

    
    //MARK: Part of Collapsing Segment
    @State var showingTab1 = false
    @State var showingTab2 = false
    @State var showingTab3 = false
    
    @State var calcName = "When to Use"
    var data: clinicalCalculatorData
    
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
                    .animation(.easeInOut(duration: 0.5), value: selected)

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
                    Text(clinicalCalculatorData.IVRateDripSegmentDetails.whatToKnow)
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
                    Text(clinicalCalculatorData.IVRateDripSegmentDetails.pearls)
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
                Text(clinicalCalculatorData.IVRateDripSegmentDetails.whyUse)
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
        
        
        
        // MARK: End of Data Segment
        
        let ten = Text("10")
            .font(.system(size: 15, weight: .medium, design: .default))
        let fiftheen = Text("15")
            .foregroundColor(Color.blue)
            .font(.system(size: 15, weight: .medium, design: .default))
        let sixty = Text("60")
            .font(.system(size: 15, weight: .bold, design: .default))
        let standard = Text ("gtts/mL - Standard")
            .font(.system(size: 11, weight: .medium, design: .default))
            .foregroundColor(Color.midnightBlue)

        
        VStack{
            
            VStack {
                VStack{
                    HStack(alignment: .center){
                        VStack(alignment: .leading){
                            Text("Volume")
                                .font(.system(size: 22, weight: .regular, design: .default ))
                                .foregroundColor(Color.gunMetal_Gray)
                            Text("mL's")
                                .font(.system(size: 12, weight: .bold, design: .default ))
                                .foregroundColor(Color(UIColor.component(red: 145, green: 146, blue: 148, opacity: 1)))
                        }
                        .padding(.top, 15)
                        .padding(.leading, 15)
                        
                        Spacer()
                           
                        TextField("", text: $volumeTextField)
                        
                        // MARK: Placeholder for textField
                            .placeholder(when: volumeTextField.isEmpty) {
                                HStack{
                                    Spacer()
                                    Text("250").foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                                    .opacity(0.3)
                                }
                            }
                                    .font(.system(size: 28, weight: .medium, design: .default))

                                    .foregroundColor(Color(UIColor.component(red: 13, green: 26, blue: 53, opacity: 1)))
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing, 15)
                                    .keyboardType(.decimalPad)
                    }
                    
                    HStack(alignment: .center){
                        VStack(alignment: .leading){
                            Text("Duration")
                                .font(.system(size: 22, weight: .regular, design: .default ))
                                .foregroundColor(Color.gunMetal_Gray)
                                .padding(.trailing, 10)
                            Text("Time for fluids to run")
                                .font(.system(size: 12, weight: .bold, design: .default ))
                                .foregroundColor(Color.darkGray)
                        }
                        .padding(.top, 10)
                        .padding(.leading, 15)
                       
                        RadioGroupPicker(selectedIndex: $selection, titles: ["Min", "Hr"]).isVertical(false)
                            .padding(.top, 15)
                            .accentColor(.blue)

                        Spacer()
                        VStack(alignment: .trailing,spacing: 0){
                            
                            TextField("", text: $durationTextField)
                            
                            // MARK: Placeholder for textField
                                .placeholder(when: durationTextField.isEmpty) {
                                    HStack{
                                        Spacer()
                                        Text("110").foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                        .opacity(0.3)
                                    }
                                }
                                .font(.system(size: 28, weight: .medium, design: .default))
                                .foregroundColor(Color.red)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.trailing, 15)
                        
                    }
                    .padding(.bottom, 5)
                }
                .background(Color.yellow_PaleSpringBud)
                .frame(width: UIScreen.main.bounds.width * 0.90)
                .cornerRadius(8)
                .padding(.top, 20)
                .animation(.easeInOut(duration: 0.5), value: selection)

                    HStack{
                        VStack(alignment: .leading){
                            Text("Drip Factor")
                                .frame(width: UIScreen.main.bounds.width * 0.25, alignment: .leading)
                                .font(.custom(AssetConstants.fontSFProDisplayBold, size: 18))
                                .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                            Text("gtts/min")
                                .font(.custom(AssetConstants.fontSFProDisplayBold, size: 12))
                                .foregroundColor(Color.red)
                        }
                        .padding(.top, 15)
                        .padding(.leading, 15)
                        .padding(.bottom, 20)
                        Spacer()
                        
                            TextField("", text: $dripTextField)
                        
                        // MARK: Placeholder for textField
                            .placeholder(when: dripTextField.isEmpty) {
                                        HStack{
                                            Spacer()
                                            Text("15").foregroundColor(.gray)
                                            .multilineTextAlignment(.trailing)
                                            .opacity(0.3)
                                        }
                                    }
                                    .font(.system(size: 28, weight: .medium, design: .default))
                                    .foregroundColor(Color(UIColor.component(red: 61, green: 178, blue: 255, opacity: 1)))
                                    .padding(.trailing, 15)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                    }
                    .background(Color(UIColor.component(red: 226, green: 243, blue: 255, opacity: 1)))
                    .frame(width: UIScreen.main.bounds.width * 0.90)
                    .cornerRadius(8)
                    .padding(.top, 40)
                    .animation(.easeInOut(duration: 0.5), value: dripTextField)

                
                Text("\(ten) gtts/mL - Blood |  \(fiftheen) \(standard) | \(sixty) gtts/mL: Micro")
                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                    .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 12))
                    .padding(.top, 12)
                    .padding(.bottom, 12)
         
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
            )
            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
            .animation(.easeInOut(duration: 0.5), value: isHidden)

            Button(action: {
                validation()
                hideKeyboard()
            }){
                HStack{
                    Text("Analyze")
                        .font(.system(size: 22, weight: .heavy, design: .default ))
                        .padding()
                }
                .frame(width: 230, height: 55)
                .foregroundColor(Color.white)
                
            }
            .background(Color.royal_blue)
            .cornerRadius(8)
            .shadow(radius: 8, y: 12)
            .padding(.top, 30)
            .animation(.easeInOut(duration: 0.5), value: isHidden)

            .fullScreenCover(isPresented: $showingPopup, content: {
                WarningPopupView(title: "Wait!!", message: "Enter both volume and duration values, then re-calculate!")
                    .background(BackgroundClearView())
            })
            
            Text("Calculated Flow")
                .font(.system(size: 28, weight: .medium, design: .default))
                .foregroundColor(Color.FBI_Blue)
                .padding(.top, 40)
                .opacity(isHidden ? 1 : 0)
            
            IVDripResultView(resultMin: resultInMinHr, mLResult: mLresult)
                .padding(.bottom, 30)
                .padding(.leading, 5)
                .opacity(isHidden ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isHidden)

            CalculatorDisclaimerView()
                .opacity(isHidden ? 1 : 0)
            
        }
    }
    
    func CalCulation() {

        volume = volumeTextField.safeDouble ?? 0
        duration = durationTextField.safeDouble ?? 0
        drip = dripTextField.safeDouble ?? 0
        
        if selection == 0 {
            
            resultInMinHr = IVDripRateCalculationMin(Volume: volume, Time: duration, DripSet: drip)
            
            mLresult =  (mLperHours(duration: duration, volume: volume))
            mLresult = mLresult * 60
            
        } else if selection == 1 {
            
            resultInMinHr = IVDripRateCalculationHours(Volume: volume, Time: duration, DripSet: drip)
            
            mLresult =  (mLperHours(duration: duration, volume: volume))
        }
        
    }
    
    func mLperHours(duration: Double, volume: Double) -> Double {
        return SafeMath.divide(volume, by: duration)
    }
    
    func IVDripRateCalculationMin(Volume: Double, Time: Double, DripSet: Double) -> Double {
        return SafeMath.divide(Volume * DripSet, by: Time)
    }
    
    func IVDripRateCalculationHours(Volume: Double, Time: Double, DripSet: Double) -> Double {
        return SafeMath.divide(Volume * DripSet, by: Time * 60)
    }
    
    func validation() {
        if !volumeTextField.isEmpty && !durationTextField.isEmpty && !dripTextField.isEmpty {
            CalCulation()
            showingPopup = false
            isHidden = true
        } else {
            showingPopup = true
        }
    }
}

struct IVDripTextFieldsViews_Previews: PreviewProvider {
    static var previews: some View {
        IVDripTextFieldsViews(data:clinicalCalculatorData.IVRateDripSegmentDetails)
    }
}
