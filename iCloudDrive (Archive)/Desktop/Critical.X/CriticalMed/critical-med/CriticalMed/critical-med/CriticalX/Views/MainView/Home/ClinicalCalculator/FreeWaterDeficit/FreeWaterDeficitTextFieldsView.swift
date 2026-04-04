//
//  FreeWaterDeficitTextFieldsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 01/12/2021.
//

import SwiftUI

struct FreeWaterDeficitTextFieldsView: View {

    @Environment(\.colorScheme) var colorScheme

    @State private var weightTextField: String = ""
    @State private var currentSodiumTextField: String = ""
    @State private var desiredSodiumTextField: String = ""
    @State private var weight: Double = 0
    @State private var currentSodium: Double = 0
    @State private var desiredSodium: Double = 0
    @State private var hoursToCorrectSodium: Double = 0
    
    @State private var segmentSelectedIndex: Int = 0
    @State private var MinimalSegmentSelectedIndex: String = "Child"
    
    @State private var childResult: Double = 0
    @State private var childResultOneDigit: String = ""
    
    @State private var adultResult: Double = 0
    @State private var adultResultOneDigit: String = ""
    
    @State private var elderlyResult: Double = 0
    @State private var elderlyResultOneDigit: String = ""
    
    @State private var negPos: String = ""
    @State private var infusionRate: Double = 0
    @State private var freeWaterResult: String = ""
    @State private var ivFlowRate: String = ""
    @State private var deficitLabel: String = ""
    
    
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
                    
                    SwiftUI.VStack(spacing: 4) {
                        
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
                        Text(clinicalCalculatorData.FreeWaterDeficitIdealBodyWeightSegmentDetails.whatToKnow)
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
                        Text(clinicalCalculatorData.FreeWaterDeficitIdealBodyWeightSegmentDetails.pearls)
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
                        Text(clinicalCalculatorData.FreeWaterDeficitIdealBodyWeightSegmentDetails.whyUse)
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
        .shadow(color: Color.gray.opacity(0.01), radius: 5, x: 0, y: 2)
        .shadow(color: Color.critical_gray.opacity(0.01), radius: 20, x: 0, y: 10)
        // Theres Ultrathin, regular, thick material as well
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 8))
        .animation(.easeInOut(duration: 0.5), value: calcName)
        .padding(.top, 10)
        .shadow(radius: 8)
        
       
        // MARK: End of Data Segment
        
        ZStack {
            
        
            VStack(spacing: 10){
                SegmentControllerView(selectedIndex: $segmentSelectedIndex)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
                
                MinimalPickerView(selectedIndex: $MinimalSegmentSelectedIndex)
                    .padding(.vertical, 3)
                
                
              
                HStack{
                    
                    
                    VStack{
                        
                    }
                    .frame(width: 15, height: 77, alignment: .leading)
                    .background(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                    VStack(alignment: .leading, spacing: 10){
                        Text("Weight")
                            .foregroundColor(Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 1)))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .padding(.leading, 5)
                        
                        Text("Current Weight")
                            .foregroundColor(Color.paoloVeronese_green)
                            .font(.custom(AssetConstants.fontSFProRoundedSemiBold, size: 12))
                            .padding(.leading, 5)
                    }
                    Spacer()
                    Text("Kg")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                        .padding(.top, 10)
                    
                    TextField("", text: $weightTextField)
                        
                    // MARK: Placeholder for textField
                        .placeholder(when: weightTextField.isEmpty) {
                                Text("96").foregroundColor(.gray)
                                .opacity(0.3)
                        }
                        .font(.system(size: 30, weight: .medium, design: .default))
                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                        .frame(width: 80, height: 25)
                        .padding(.leading, 20)
                        .keyboardType(.decimalPad)
                }
                .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground)))
                .overlay(
                    RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15)
                        .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
                )
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .padding(.top, 5)
                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                .shadow(radius: 6)
                
                
                VStack{
                    
                }
                .frame(width: 16, height: 42, alignment: .leading)
                .background(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                
                HStack{
                    VStack{
                        
                    }
                    .frame(width: 15, height: 77, alignment: .leading)
                    .background(Color(UIColor.component(red: 243, green: 171, blue: 60, opacity: 1)))
                    VStack(alignment: .leading, spacing: 10){
                        Text("Current Sodium")
                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .padding(.leading, 5)
                        
                        Text("mEq/L")
                            .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                            .font(.custom(AssetConstants.fontSFProRoundedSemiBold, size: 12))
                            .padding(.leading, 5)
                    }
                    Spacer()
                    Text("Na")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                        .padding(.top, 10)
                    
                    TextField("", text: $currentSodiumTextField)
                        
                    // MARK: Placeholder for textField
                        .placeholder(when: currentSodiumTextField.isEmpty) {
                                Text("158").foregroundColor(.gray)
                                .opacity(0.3)
                        }
                        .accentColor(Color.red)
                        .font(.system(size: 30, weight: .medium, design: .default))
                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                        .frame(width: 80, height: 25)
                        .padding(.leading, 20)
                        .keyboardType(.decimalPad)
                }
                .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground)))
                .overlay(
                    RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15)
                        .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
                )
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                .shadow(radius: 6)
                
                VStack{
                    
                }
                .frame(width: 16, height: 42, alignment: .leading)
                .background(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                
                HStack{
                    VStack{
                        
                    }
                    .frame(width: 15, height: 77, alignment: .leading)
                    .background(Color.royal_blue)
                    
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text("Desired Sodium")
                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .padding(.leading, 5)
                        
                        Text("mEq/L")
                            .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                            .font(.custom(AssetConstants.fontSFProRoundedSemiBold, size: 12))
                            .padding(.leading, 5)
                    }
                    Spacer()
                    Text("Na")
                        .font(.system(size: 16, weight: .semibold, design: .default))
                        .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                        .padding(.top, 10)
                    
                    TextField("", text: $desiredSodiumTextField)
                    
                    // MARK: Placeholder for textField
                        .placeholder(when: desiredSodiumTextField.isEmpty) {
                                Text("140").foregroundColor(.gray)
                                .opacity(0.3)
                        }
                        .accentColor(Color.red)
                        .font(.system(size: 30, weight: .medium, design: .default))
                        .foregroundColor(Color.paoloVeronese_green)
                        .frame(width: 80, height: 25)
                        .padding(.leading, 20)
                        .keyboardType(.decimalPad)
                       
                }
                .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground)))
                .overlay(
                    RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15)
                        .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
                )
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.005)), radius: 2, x: 0, y: 1)
                .shadow(radius: 6)
                
                
                
                Button(action: {
                    validation()
                    hideKeyboard()
                }){
                    HStack{
                        Text("Analyze")
                            .font(.system(size: 22, weight: .heavy, design: .default ))
                          .padding()
                    }
                    .frame(width:230, height: 55)
                    .foregroundColor(Color.white)
                }
                .cornerRadius(8)
                .background(Color.royal_blue)
                .shadow(radius: 8, y: 14)
                // This is when we want a clear button with an outside stroke
//                .overlay(
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(Color.black, lineWidth: 2)
//                )
                .padding(.top, 20)
                .fullScreenCover(isPresented: $showingPopup, content: {
                    WarningPopupView(title: "Wait!!", message: "Enter value in all fields, then recalculate!")
                        .background(BackgroundClearView())
                })
                
                Text("Result")
                    .font(.custom(AssetConstants.fontSFProDisplayMedium, size: 14))
                    .foregroundColor(Color.blue)
                    .padding(.top, 20)
                    .opacity(isHidden ? 1 : 0)
                
                
                FreeWaterDepicitResultView(freeWaterResult: freeWaterResult, deficitLabel: deficitLabel, ivFlowRate: ivFlowRate)
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                    .opacity(isHidden ? 1 : 0)
                
                CalculatorDisclaimerView()
                    .opacity(isHidden ? 1 : 0)
                    .padding(.bottom, 20)

            }
        }
        .animation(.easeInOut(duration: 0.5), value: isHidden)

    }
       

}

struct FreeWaterDeficitTextFieldsView_Previews: PreviewProvider {
    static var previews: some View {
        FreeWaterDeficitTextFieldsView(data: clinicalCalculatorData.FreeWaterDeficitIdealBodyWeightSegmentDetails)
    }
}

 //MARK: - Calculation
extension FreeWaterDeficitTextFieldsView {
    
    func CalCulation() {

        weight = weightTextField.safeDouble ?? 0
        currentSodium = currentSodiumTextField.safeDouble ?? 0
        desiredSodium = desiredSodiumTextField.safeDouble ?? 0
        
        //Calculate hours
        hoursToCorrectSodium = (currentSodium - desiredSodium) / 0.5

        switch(segmentSelectedIndex, MinimalSegmentSelectedIndex) {
            
        case (0, "Child"): //0,0
            
            childResult = (0.6 * weight * (SafeMath.divide(currentSodium, by: desiredSodium) - 1))
            
            if childResult.isNaN {
                freeWaterResult = "Euvolemic"
                ivFlowRate = ""
            } else {
                
                childResultOneDigit = String(format: "%.1f", childResult)
                infusionRate = (childResult / hoursToCorrectSodium) * 1000
                
                // Check the result if +/- then change text
                if childResult > 0 {
                    negPos = "Positive"
                    ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                }
                if childResult < 0 {
                    negPos = "Negative"
                    ivFlowRate = "Diurese the patient \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium * -1 ) hrs."
                }
                deficitLabel = "This patient has a \(negPos) deficit of:"
                freeWaterResult = "\(childResultOneDigit) Liters"
            }
            
            
        case (0, "Adult"): //0,1
            
            adultResult = (0.6 * weight * (SafeMath.divide(currentSodium, by: desiredSodium) - 1))
            
            if adultResult.isNaN {
                freeWaterResult = "Euvolemic"
                ivFlowRate = ""
            } else {
                
                adultResultOneDigit = String(format: "%.1f", adultResult)
                infusionRate = (adultResult / hoursToCorrectSodium) * 1000
                ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                
                // Check the result if +/- then change text
                if adultResult > 0 {
                    negPos = "Positive"
                    ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                }
                if childResult < 0 {
                    negPos = "Negative"
                    ivFlowRate = "Diurese the patient \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium * -1 ) hrs."
                }
                deficitLabel = "This patient has a \(negPos) deficit of:"
                freeWaterResult = "\(adultResultOneDigit) Liters"
            }
            
        case (0, "Elderly"): //0,2
      
            elderlyResult = (0.5 * weight * (SafeMath.divide(currentSodium, by: desiredSodium) - 1))
            
            if elderlyResult.isNaN {
                freeWaterResult = "Euvolemic"
                ivFlowRate = ""
            } else {
                
                elderlyResultOneDigit = String(format: "%.1f", elderlyResult)
                infusionRate = (elderlyResult / hoursToCorrectSodium) * 1000
                ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                
                // Check the result if +/- then change text
                if adultResult > 0 {
                    negPos = "Positive"
                    ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                }
                if childResult < 0 {
                    negPos = "Negative"
                    ivFlowRate = "Diurese the patient \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium * -1 ) hrs."
                }
                deficitLabel = "This patient has a \(negPos) deficit of:"
                freeWaterResult = "\(elderlyResultOneDigit) Liters"
            }
            
        case (1, "Child"): //1,0
            
            childResult = (0.6 * weight * (SafeMath.divide(currentSodium, by: desiredSodium) - 1))
            
            if childResult.isNaN {
                freeWaterResult = "Euvolemic"
                ivFlowRate = ""
            } else {
                
                childResultOneDigit = String(format: "%.1f", childResult)
                infusionRate = (childResult / hoursToCorrectSodium) * 1000
                ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                
                // Check the result if +/- then change text
                if adultResult > 0 {
                    negPos = "Positive"
                    ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                }
                if childResult < 0 {
                    negPos = "Negative"
                    ivFlowRate = "Diurese the patient \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium * -1 ) hrs."
                }
                deficitLabel = "This patient has a \(negPos) deficit of:"
                freeWaterResult = "\(childResultOneDigit) Liters"
            }
            
        case (1, "Adult"): //1,1
           
            adultResult = (0.5 * weight * (SafeMath.divide(currentSodium, by: desiredSodium) - 1))
            
            if adultResult.isNaN {
                freeWaterResult = "Euvolemic"
                ivFlowRate = ""
            } else {
                
                adultResultOneDigit = String(format: "%.1f", adultResult)
                infusionRate = (adultResult / hoursToCorrectSodium) * 1000
                ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                
                // Check the result if +/- then change text
                if adultResult > 0 {
                    negPos = "Positive"
                    ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                }
                if childResult < 0 {
                    negPos = "Negative"
                    ivFlowRate = "Diurese the patient \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium * -1 ) hrs."
                }
                deficitLabel = "This patient has a \(negPos) deficit of:"
                freeWaterResult = "\(adultResultOneDigit) Liters"
            }
            
        case (1, "Elderly"): //1,2
            
            elderlyResult = (0.45 * weight * (SafeMath.divide(currentSodium, by: desiredSodium) - 1))
            
            if elderlyResult.isNaN {
                freeWaterResult = "Euvolemic"
                ivFlowRate = ""
            } else {
                
                elderlyResultOneDigit = String(format: "%.1f", elderlyResult)
                infusionRate = (elderlyResult / hoursToCorrectSodium) * 1000
                ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                
                // Check the result if +/- then change text
                if adultResult > 0 {
                    negPos = "Positive"
                    ivFlowRate = "IV flow rate of \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium) hrs."
                }
                if childResult < 0 {
                    negPos = "Negative"
                    ivFlowRate = "Diurese the patient \((infusionRate).oneDecimalPlace) cc/hr for \(hoursToCorrectSodium * -1 ) hrs."
                }
                deficitLabel = "This patient has a \(negPos) deficit of:"
                freeWaterResult = "\(elderlyResultOneDigit) Liters"
            }
            
        default:
            #if DEBUG
            print("Nothing")
            #endif
        }

    }

    //MARK: - Showing popup if values empty
    func validation() {
        if !weightTextField.isEmpty && !currentSodiumTextField.isEmpty && !desiredSodiumTextField.isEmpty{
            CalCulation()
            isHidden = true
            showingPopup = false
        } else {
            isHidden = false
            showingPopup = true
        }
    }
}
