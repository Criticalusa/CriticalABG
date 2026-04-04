//
//  ShockIndexTextFieldsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 10/12/2021.
//

import SwiftUI

struct ShockIndexTextFieldsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var heartRateTextField: String = ""
    @State private var systloicBpTextField: String = ""
    
    @State private var result = 0.0
    @State private var heartRate = 0.0
    @State private var bloodPressure = 0.0
    @State var isHidden: Bool = false
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
                    Text(clinicalCalculatorData.shockIndexSegmentDetails.whatToKnow)
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
                    Text(clinicalCalculatorData.shockIndexSegmentDetails.pearls)
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
                Text(clinicalCalculatorData.shockIndexSegmentDetails.whyUse)
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
                
                HStack{
                    Spacer()
                    VStack(alignment: .center){
                        Text("Heart Rate")
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(Color.charcol_gray)
                        
                        TextField("", text: $heartRateTextField)
                        // MARK: Placeholder for textField
                            .placeholder(when: heartRateTextField.isEmpty) {
                                HStack{
                                    Spacer()
                                    Text("70").foregroundColor(.midnightBlue)
                                        .opacity(0.3)
                                    Spacer()
                                }
                            }
                            .font(.system(size: 28, weight: .medium, design: .default))                            .foregroundColor(Color.red)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                        Text("BPM")
                            .font(.system(size: 14, weight: .medium, design: .default))                               .foregroundColor(Color.charcol_gray)
                        
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    Spacer()
                    ZStack{
                        Image("drop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.red)
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding(.top, 10)
                    }
                    Spacer()
                    VStack(alignment: .center){
                        Text("Systolic BP")
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(Color.charcol_gray)
                        
                        TextField("", text: $systloicBpTextField)
                        // MARK: Placeholder for textField
                            .placeholder(when: systloicBpTextField.isEmpty) {
                                HStack{
                                    Spacer()
                                    Text("50").foregroundColor(.blue)
                                        .opacity(0.3)
                                    Spacer()
                                }
                            }
                            .font(.system(size: 28, weight: .medium, design: .default))
                            .foregroundColor(Color.red)
                            .multilineTextAlignment(.center)
                            .keyboardType(.decimalPad)
                        
                        Text("mmHg")
                            .font(.system(size: 14, weight: .medium, design: .default))                            .foregroundColor(Color.charcol_gray)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                }
                .frame(width: UIScreen.main.bounds.width * 0.85)
                .background(Color(UIColor.component(red: 71, green: 159, blue: 156, opacity: 0.15)))
                .cornerRadius(10)
                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
            .cornerRadius(8)
            .animation(.easeInOut(duration: 0.5), value: isHidden)

            Button(action: {
                validation()
                hideKeyboard()
            }){
                HStack{
                    Text("Analyze")
                        .font(.system(size: 22).weight(.heavy))
                        .padding()
                }
                 .frame(width: 230, height: 55)
                .foregroundColor(Color.white)
                
            }
            .background(Color.royal_blue)
            .cornerRadius(6)
            .shadow(radius: 8, y: 12)
            .padding(.top, 30)
            .animation(.easeInOut(duration: 0.5), value: isHidden)

            .fullScreenCover(isPresented: $showingPopup, content: {
                HoldOnPopupView(title: "Hold On!!", message: "Check all of the fields before calculating.")
                    .background(BackgroundClearView())
            })
            
            Text("Result")
.font(.system(size: 28, weight: .medium, design: .default))                .foregroundColor(Color.blue)
                .padding(.top, 40)
                .opacity(isHidden ? 1 : 0)
            
            ShockIndexResultView(result: result)
                .padding(.top, 10)
                .padding(.bottom, 30)
                .opacity(isHidden ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isHidden)

        }
    }
    func CalCulation() {
        
        heartRate = Double(heartRateTextField) ?? 0
        bloodPressure = Double(systloicBpTextField) ?? 0
        result = heartRate / bloodPressure

        #if DEBUG
        print("Result: \(result)")
        #endif
        
    }
    
    func validation() {
        if !heartRateTextField.isEmpty && !systloicBpTextField.isEmpty {
            CalCulation()
            isHidden = true
            showingPopup = false
        } else {
            isHidden = false
            showingPopup = true
        }
    }
    
}

struct ShockIndexTextFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        ShockIndexTextFieldsView(data:clinicalCalculatorData.shockIndexSegmentDetails)
    }
}
