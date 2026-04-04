//
//  FenaTextFieldsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 01/12/2021.
//

import SwiftUI

struct FenaTextFieldsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var serumNaTextField: String = ""
    @State private var serumCrTextField: String = ""
    @State private var urineNaTextField: String = ""
    @State private var urineCrTextField: String = ""
    @State private var result: Double = 0.0
    @State private var isHidden: Bool = false
    @State var showingPopup = false
    
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
                    Text(clinicalCalculatorData.fenaSegmentDetails.whatToKnow)
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
                    Text(clinicalCalculatorData.fenaSegmentDetails.pearls)
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
                Text(clinicalCalculatorData.fenaSegmentDetails.whyUse)
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
        
        VStack(spacing: 0){
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
                VStack(alignment: .leading, spacing: 10){
                    Text("Serum Na")
                        .foregroundColor(Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 1)))
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .padding(.leading, 5)
                    
                    Text("135 - 145 mEq/L")
                        .foregroundColor(Color.red)
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .padding(.leading, 5)
                }
                
                Spacer()
                Text("mEq/L")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .padding(.top, 10)
                
                TextField("", text: $serumNaTextField,onEditingChanged: { editing in
                    if editing {
                        serumNaTextField = ""
                    }
                })
                
                // MARK: Placeholder for textField
                .placeholder(when: serumNaTextField.isEmpty) {
                    Text("140").foregroundColor(.gray)
                        .opacity(0.3)
                }
                .font(.system(size: 36, weight: .medium, design: .default))
                .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                .frame(width: 80, height: 25)
                .padding(.leading, 20)
                .keyboardType(.decimalPad)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
            .shadow(radius: 8)
            .padding(.top, 5)
            .animation(.easeInOut(duration: 0.5), value: serumNaTextField)
            
            
            VStack{
                
            }
            .frame(width: 16, height: 42, alignment: .leading)
            
            
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color(UIColor.component(red: 61, green: 186, blue: 133, opacity: 1)))
                .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
                VStack(alignment: .leading, spacing: 10){
                    Text("Serum Cr")
                        .foregroundColor(Color.charcol_gray)
                        .font(.system(size: 16 , weight: .medium, design: .default))
                        .padding(.leading, 5)
                    
                    Text("0.7 - 1.3 mg/dL")
                        .foregroundColor(Color.green)
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .padding(.leading, 5)
                }
                
                Spacer()
                Text("mg/dL")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .padding(.top, 10)
                
                TextField("", text: $serumCrTextField, onEditingChanged: { editing in
                    if editing {
                        serumCrTextField = ""
                    }
                })
                
                // MARK: Placeholder for textField
                .placeholder(when: serumCrTextField.isEmpty) {
                    Text("1.0").foregroundColor(.gray)
                        .opacity(0.3)
                }
                .accentColor(Color.red)
                .font(.system(size: 36, weight: .medium, design: .default))
                .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                .frame(width: 80, height: 25)
                .padding(.leading, 20)
                .keyboardType(.decimalPad)
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
            .shadow(radius: 8)
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .animation(.easeInOut(duration: 0.5), value: serumCrTextField)
            
            
            HStack{
                Spacer()
                Rectangle()
                    .fill(Color.criticalBlue)
                    .frame(width: 16, height: 44)
                    .padding(.trailing, 50)
                    .animation(.easeInOut(duration: 0.5), value: isHidden)

                Spacer()
                Rectangle()
                    .fill(Color.criticalBlue)
                    .frame(width: 16, height: 44)
                    .padding(.leading, 50)
                    .animation(.easeInOut(duration: 0.5), value: isHidden)
                
                Spacer()
            }
            
            HStack{
                HStack{
                    Rectangle()
                        .fill(Color.royal_blue)
                        .frame(width: 16, height: 86)
                    VStack(alignment: .leading){
                        Text("Urine Na")
                        //.frame(width: 70)
                            .foregroundColor(Color.charcol_gray)
                            .font(.system(size: 16, weight: .medium, design: .default))
                        
                        Text("40-220 mg/dL")
                        //.frame(width: 80)
                            .foregroundColor(Color.red)
                            .font(.system(size: 10, weight: .medium, design: .default))
                    }
                    .padding(.bottom, 13)
                    Spacer()
                    VStack(alignment: .leading, spacing: 0){
                        
                        TextField("", text: $urineNaTextField, onEditingChanged: { editing in
                            if editing {
                                urineNaTextField = ""
                            }
                        })
                        
                        // MARK: Placeholder for textField
                        .placeholder(when: urineNaTextField.isEmpty) {
                            Text("150").foregroundColor(.gray)
                                .opacity(0.3)
                        }
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                        .font(.system(size: 36, weight: .medium, design: .default))
                        .padding(.top, 3)
                        .keyboardType(.decimalPad)
                        
                        Text("mEq/L")
                            .foregroundColor(Color.charcol_gray)
                            .font(.system(size: 13, weight: .medium, design: .default))
                            .padding(.leading, 20)
                            .padding(.bottom, 3)
                    }
                    .padding(.trailing, 3)
                }
                .frame(width: UIScreen.main.bounds.width * 0.45, height: 86)
                .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(Color.babyPowderWhite))
                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                .shadow(radius: 8)
                .animation(.easeInOut(duration: 0.5), value: urineNaTextField)


                Spacer()

                HStack{
                    Rectangle()
                        .fill(Color(UIColor.component(red: 250, green: 198, blue: 118, opacity: 1)))
                        .frame(width: 16, height: 86)
                    VStack(alignment: .leading){
                        Text("Urine Cr")
                        //.frame(width: 70)
                            .foregroundColor(Color.charcol_gray)
                            .font(.system(size: 16, weight: .medium, design: .default))
                        Text("200-370 mg/dL")
                        //.frame(width: 80)
                            .foregroundColor(Color.red)
                            .font(.system(size: 10, weight: .medium, design: .default))
                    }
                    .padding(.bottom, 13)
                    Spacer()
                    VStack(alignment: .leading, spacing: 0){
                        
                        TextField("", text: $urineCrTextField,onEditingChanged: { editing in
                            if editing {
                                urineCrTextField = ""
                            }
                        })
                        
                        // MARK: Placeholder for textField
                        .placeholder(when: urineCrTextField.isEmpty) {
                            Text("250").foregroundColor(.gray)
                                .opacity(0.3)
                        }
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                        .font(.system(size: 36, weight: .medium, design: .default))
                        .padding(.top, 3)
                        .keyboardType(.decimalPad)
                        
                        Text("mg/dL")
                            .foregroundColor(Color.charcol_gray)
                            .font(.system(size: 13, weight: .medium, design: .default))
                            .padding(.leading, 20)
                            .padding(.bottom, 3)
                    }
                    .padding(.trailing, 3)
                }
                .frame(width: UIScreen.main.bounds.width * 0.45, height: 86)
                .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(Color.babyPowderWhite))
                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                .shadow(radius: 8)
                .animation(.easeInOut(duration: 0.5), value: urineCrTextField)


            } // Hstack divider
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 86)
            
            Spacer(minLength: 0)
            
            Button(action: {
                validation()
                hideKeyboard()
            }){
                HStack{
                    Text("Analyze")
                        .font(.system(size: 22, weight: .heavy, design: .default ))
                        .foregroundColor(Color.white)
                        .padding()
                }
                 .frame(width: 230, height: 55)
                .background(Color.royal_blue)
            }
            .cornerRadius(6)
            .padding(.top, 30)
            .shadow(radius: 8, y: 12)
            .animation(.easeInOut(duration: 0.5), value: isHidden)
            .fullScreenCover(isPresented: $showingPopup, content: {
                WarningPopupView(title: "Wait!!", message: "Enter value in all fields, then recalculate!")
                    .background(BackgroundClearView())
            })
            
            
            Text("Result")
                .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                .foregroundColor(Color.blue)
                .padding(.top, 20)
                .opacity(isHidden ? 1 : 0)
            
            FenaResultView(result: result)
                .padding(.bottom, 20)
                .padding(.top, 10)
                .opacity(isHidden ? 1 : 0)
        }
    }
    
    
    func CalCulation() {
        
        let serumCr = Double(serumCrTextField) ?? 0
        let serumNa = Double(serumNaTextField) ?? 0
        let urineCr = Double(urineCrTextField) ?? 0
        let urineNa = Double(urineNaTextField) ?? 0
        result = (100 * (serumCr * urineNa) / (serumNa * urineCr))
        
    }
    
    func validation() {
        if !serumCrTextField.isEmpty && !serumNaTextField.isEmpty && !urineNaTextField.isEmpty && !urineCrTextField.isEmpty{
            CalCulation()
            isHidden = true
            showingPopup = false
        } else {
            isHidden = false
            showingPopup = true
        }
    }
}

struct FenaTextFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        FenaTextFieldsView( data: clinicalCalculatorData.fenaSegmentDetails)
    }
}
