//
//  ParkLandTextFieldiew.swift
//  CriticalX
//
//  Created by Macbook 4 on 08/12/2021.
//

import SwiftUI

struct ParkLandTextFieldiew: View {
    @Environment(\.colorScheme) var colorScheme

    @State private var weightTextField: String = ""
    @State private var totalBodyTextField: String = ""
    
    @State private var fluidRequired = ""
    @State private var theRemaing = ""
    @State private var result = ""
    @State private var result1 = ""
    @State private var deliver = ""
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
                    Text(clinicalCalculatorData.ParklandFormulaSegmentDetails.whatToKnow)
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
                    Text(clinicalCalculatorData.ParklandFormulaSegmentDetails.pearls)
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
                Text(clinicalCalculatorData.ParklandFormulaSegmentDetails.whyUse)
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
                
                HStack(spacing: 0){
                    Spacer()
                    VStack(alignment: .center){
                        
                        Text("Weight")
                        //.textStyle(_font: .system(size: 18, weight: .semibold, design: .default), color_text: .gunMetal_Gray)
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .padding(.trailing, 5)
                        
                        
                        TextField("", text: $weightTextField)
                        
                        // MARK: Placeholder for textField
                            .placeholder(when: weightTextField.isEmpty) {
                                HStack{
                                    Spacer()
                                    Text("90").foregroundColor(.gray)
                                        .opacity(0.3)
                                    Spacer()
                                }
                            }
                            .font(.system(size: 28, weight: .medium, design: .default))
                        // .font(.system(size: 28, weight: .medium, design: .default))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.criticalBlue)
                            .padding(.top, 15)
                            .keyboardType(.decimalPad)
                        
                        
                        Text("Kg")
                            .font(.system(size: 13, weight: .medium, design: .default))
                            .foregroundColor(Color.charcol_gray)
                            .padding(.top, 7)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                    
                    Spacer()
                    
                    
                    
                    VStack(alignment: .center){
                        
                        Text("Total Body\nSurface Area")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(Color.BlueYonder)
                            .multilineTextAlignment(.center)
                        
                        TextField("", text: $totalBodyTextField)
                        // MARK: Placeholder for textField
                            .placeholder(when: totalBodyTextField.isEmpty) {
                                HStack{
                                    Spacer()
                                    Text("90").foregroundColor(.gray)
                                        .opacity(0.3)
                                    Spacer()
                                }
                            }
                        //.font(.system(size: 28, weight: .medium, design: .default))
                            .font(.system(size: 28, weight: .medium, design: .default))                            .foregroundColor(Color.red)
                            .padding(.leading, 20)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                        
                        Text("BSA %")
                            .font(.system(size: 13, weight: .medium, design: .default))
                            .foregroundColor(Color.charcol_gray)
                            .padding(.top, 5)
                            .padding(.leading, 25)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                    Spacer()
                }
                
                HStack{

                    //                    Image(systemName: "info.circle.fill")
                    //                        .foregroundColor(.vitalRed)
                    Circle()
                        .fill(CriticalDesign.Colors.accentOrange)
                        .frame(width: 16, height: 16)

                    Text("Rule of 9's Info")
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        .textStyle(_font: .system(size: 14, weight: .medium, design: .default), color_text: .gunMetal_Gray)
                    //.tracking(2)
                        .lineSpacing(36)
                    
                }
                .padding(.bottom, 5)
                
                Rectangle()
                    .fill(Color.paoloVeronese_green)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 12)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(
                RoundedCornersShape(corners: [.topRight,.topLeft,.bottomRight,.bottomLeft], radius: 8)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                    .overlay(
                        RoundedCornersShape(corners: [.topRight,.topLeft,.bottomRight,.bottomLeft], radius: 8)
                            .stroke(colorScheme == .dark ? CriticalDesign.Colors.goldMid.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.1), radius: 2.71, x: 0, y: 1.36)
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 0.68, x: 0, y: 0)
            .animation(.easeInOut(duration: 0.5), value: isHidden)
            
            // .shadow(radius: 8)
            
            
            
            Button(action: {
                
                validation()
                
                // Hides the keyboard after calculation button is pressed
                hideKeyboard()
                
            }){
                
                HStack{
                    
                    Text("Analyze")
                    
                        .font(.system(size: 22).weight(.heavy))
                        .padding()
                }

            }
            .padding() .frame(width: 230, height: 55)
            .foregroundColor(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
            .background(colorScheme == .dark ? CriticalDesign.Colors.gold : Color.royal_blue)
            .cornerRadius(10)
            .padding(.top, 30)
            .shadow(radius: 8, y: 14)
            .animation(.easeInOut(duration: 0.5), value: isHidden)
            
            .fullScreenCover(isPresented: $showingPopup, content: {
                WarningPopupView(title: "Wait!!", message: "Enter both weight and BSA values, then recalculate!")
                    .background(BackgroundClearView())
            })
            
            FluidsRequirmentView(fluid1: fluidRequired, fluid2: deliver)
                .padding(.top, 30)
                .opacity(isHidden ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isHidden)

            ParkLandResultView(theRemaing: theRemaing, res: result, res1: result1)
                .padding(.top, 15)
                .padding(.bottom, 60)
                .opacity(isHidden ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isHidden)
            
        }
    }
    
    
    func CalCulation() {
        
        let weight = Double(weightTextField) ?? 0.0
        
        let bsa = Double(totalBodyTextField) ?? 0
        
        let parkLandFormula1 = bsa * weight * 4
        let parkLandFormulaLitters =  parkLandFormula1 / 1000
        
        let parklandFormula = String(format: "%.1f", parkLandFormulaLitters)
        // let colorParklandFormula = Text("\(parklandFormula)").foregroundColor(Color(UIColor.component(red: 235, green: 78, blue: 87, opacity: 1)))
        
        
        //MARK:- fluids Requirement
        let firstEight1 = parkLandFormula1 / 2
        let firstEightLiters = firstEight1 / 1000
        let firstEight = String(format:"%.1f",firstEightLiters)
        // let colorFirstEight = Text("\(firstEight)").foregroundColor(Color(UIColor.component(red: 243, green: 171, blue: 60, opacity: 1)))
        
        
        fluidRequired = "With a weight of \(weight) kgs and BSA of \(bsa) %, a total of \(parklandFormula) liters  needs to be delivered over 24 hours.\n\n"
        
        deliver = "Deliver a total of \(firstEight) liters over the first 8 hrs."
        
        //MARK:- the remaining resultView part
        let overSixteen1 = parkLandFormula1 / 2
        let overSixteenLiters = overSixteen1 / 1000
        let overSixteen = String(format:"%.1f",overSixteenLiters)
        
        theRemaing = "The remaining \(overSixteen) liters to be delivered over the last 16 hours."
        
        //MARK:- ResultView
        let firstEight2 = parkLandFormula1 / 2
        let firstEightLiters1 = firstEight2 / 1000
        let firstEight3 = String(format:"%.1f",firstEightLiters1)
        
        let overSixteen2 = parkLandFormula1 / 2
        let overSixteenLiters1 = overSixteen2 / 1000
        let overSixteen3 = String(format:"%.1f",overSixteenLiters1)
        
        let infusionRateEight = parkLandFormula1 / 8
        let infusionRateSisteen = parkLandFormula1 / 16
        
        result = "To infuse \(firstEight3) L's over 8 hrs., consider an infusion rate of \(infusionRateEight / 2 ) mL/hr"
        result1 = "For the final 16 hrs., consider an infusion rate of \(infusionRateSisteen / 2) mL/hr to infuse the remaining \(overSixteen3) liters."
    }
    
    func validation() {
        if !weightTextField.isEmpty && !totalBodyTextField.isEmpty{
            CalCulation()
            isHidden = true
            showingPopup = false
        } else {
            isHidden = false
            showingPopup = true
        }
    }
}

struct ParkLandTextFieldiew_Previews: PreviewProvider {
    static var previews: some View {
        ParkLandTextFieldiew(data: clinicalCalculatorData.ParklandFormulaSegmentDetails)
    }
}
