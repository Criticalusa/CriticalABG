//
//  MAPTextFieldsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 10/12/2021.
//

import SwiftUI

struct MAPTextFieldsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var systolicTextField: String = ""
    @State private var diastolicTextField: String = ""
    @State private var icpField: String = ""
    
    @State private var result = 0
    @State private var systolic = 0
    @State private var diastolic = 0
    @State private var icp = 0
    @State var isHidden: Bool = false
    @State var isIcpNIL: Bool = false
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
                    Text(clinicalCalculatorData.MAPCPPSegmentDetails.whatToKnow)
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
                    Text(clinicalCalculatorData.MAPCPPSegmentDetails.pearls)
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
                Text(clinicalCalculatorData.MAPCPPSegmentDetails.whyUse)
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
        
        VStack{
            
            VStack {
                VStack{
                    HStack{
                        VStack(alignment: .leading){
                            Text("Systolic BP")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                                .foregroundColor(Color(UIColor.component(red: 81, green: 86, blue: 95, opacity: 1)))
                            Text("mmHg")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(Color(UIColor.component(red: 145, green: 146, blue: 148, opacity: 1)))
                        }
                        .padding(.top, 15)
                        .padding(.leading, 15)
                        Spacer()
                           
                        
                        TextField("", text: $systolicTextField)
                                   
                        // MARK: Placeholder for textField
                            .placeholder(when: systolicTextField.isEmpty) {
                                        HStack{
                                            Spacer()
                                            Text("220").foregroundColor(.gray)
                                            .multilineTextAlignment(.trailing)
                                            .opacity(0.3)
                                        }
                                    }
                            .font(.system(size: 28, weight: .medium, design: .default))
                                    .foregroundColor(Color.criticalBlue)
                                    .padding(.trailing, 15)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                    }
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text("Diastolic BP")
                                .font(.system(size: 20, weight: .semibold, design: .default))
                                .foregroundColor(Color(UIColor.component(red: 81, green: 86, blue: 95, opacity: 1)))
                                .padding(.trailing, 10)
                            Text("mmHg")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(Color(UIColor.component(red: 145, green: 146, blue: 148, opacity: 1)))
                        }
                        .padding(.top, 10)
                        .padding(.leading, 15)
                        Spacer()
                        VStack(alignment: .trailing,spacing: 0){
                            
                            TextField("", text: $diastolicTextField)
                               
                            // MARK: Placeholder for textField
                                .placeholder(when: diastolicTextField.isEmpty) {
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
                    .padding(.bottom, 15)
                }
                .background(Color(UIColor.component(red: 233, green: 233, blue: 242, opacity: 1)))
                .frame(width: UIScreen.main.bounds.width * 0.90)
                .cornerRadius(8)
                .padding(.top, 30)
                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                .shadow(radius: 8)

                
                Text("**Blood Pressure is Required to Calculate the CPP")
                    .foregroundColor(Color.orange_TerraCotta)
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .padding(.top, 3)
                
                    HStack{
                        VStack(alignment: .leading){
                            Text("ICP")
                                .font(.system(size: 20, weight: .medium, design: .default))
                                .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                            Text("mmHg")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(Color.red)
                        }
                        .padding(.top, 15)
                        .padding(.leading, 15)
                        .padding(.bottom, 20)
                        Spacer()
                           
                        TextField("", text: $icpField)
                                    
                        // MARK: Placeholder for textField
                            .placeholder(when: icpField.isEmpty) {
                                        HStack{
                                            Spacer()
                                            Text("28")
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.trailing)
                                            .opacity(0.3)
                                        }
                                    }
                                    .font(.system(size: 28, weight: .medium, design: .default))
                                    .foregroundColor(Color(UIColor.component(red: 70, green: 157, blue: 154, opacity: 1)))
                                    .padding(.trailing, 15)
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.decimalPad)
                                    .shadow(color: .darkGray, radius: 2)

                    }
                    .background(Color(UIColor.component(red: 71, green: 159, blue: 156, opacity: 0.15)))
                    .frame(width: UIScreen.main.bounds.width * 0.90)
                    .cornerRadius(8)
                    .padding(.top, 10)
                    .padding(.bottom, 40)
                
         
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
            .shadow(radius: 8)

            
            Button(action: {
                validation()
                hideKeyboard()
            }){
                HStack{
                    Text("Analyze")
                        .font(.system(size: 22, weight: .heavy, design: .default))
                        .padding()
                }
                 .frame(width: 230, height: 55)
                .font(.system(size: 22, weight: .medium, design: .default))
                .foregroundColor(Color.white)
                .shadow(radius: 8)
                
            }
            .background(Color(UIColor.component(red: 208, green: 65, blue: 65, opacity: 1)))
            .cornerRadius(8)
            .shadow(radius: 8, y: 14)
            .padding(.top, 30)
            .fullScreenCover(isPresented: $showingPopup, content: {
                WarningPopupView(title: "Wait!!", message: "Enter both SBP and DBP, then recalculate!")
                    .background(BackgroundClearView())
            })
            
            Text("Result")
                .font(.custom(AssetConstants.fontSFProHeavy, size: 28))
                .foregroundColor(Color.blue)
                .padding(.top, 25)
                .opacity(isHidden ? 1 : 0)
            
            MAPResultView(map: result, icp: icp, isIcpNIL: isIcpNIL)
                .padding(.bottom, 30)
                .padding(.leading, 5)
                .opacity(isHidden ? 1 : 0)
            
            CalculatorDisclaimerView()
                .opacity(isHidden ? 1 : 0)
        }
    }
    
    func CalCulation() {

         systolic = Int(systolicTextField) ?? 0
         diastolic = Int(diastolicTextField) ?? 0
         icp = Int(icpField) ?? 0
         result =  (systolic + (2 * diastolic)) / 3
         icp = result - icp
         #if DEBUG
         print("Result: \(result)")
         #endif
    }
    
    func validation() {
        if !systolicTextField.isEmpty && !diastolicTextField.isEmpty && !icpField.isEmpty {
            CalCulation()
            isIcpNIL = false
            isHidden = true
            showingPopup = false
        }
        else if !systolicTextField.isEmpty && !diastolicTextField.isEmpty {
            CalCulation()
            isIcpNIL = true
            isHidden = true
            showingPopup = false
        }
        else {
            isHidden = false
            showingPopup = true
        }
    }
}

struct MAPTextFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        MAPTextFieldsView(data:clinicalCalculatorData.MAPCPPSegmentDetails)
    }
}
