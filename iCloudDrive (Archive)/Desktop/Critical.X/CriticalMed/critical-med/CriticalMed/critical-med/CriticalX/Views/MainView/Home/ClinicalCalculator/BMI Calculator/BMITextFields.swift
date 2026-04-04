//
//  BMITextFields.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 3/22/22.
//v

import SwiftUI

struct BMITextFields: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var weightTextField: String = ""
    @State private var heightTextField: String = ""
    @State private var targetBMITextField: String = ""
    @State private var resultBMI: Double = 0.0
    @State private var resultBSA: Double = 0.0
    @State private var isHidden: Bool = false
    @State private var showingPopup: Bool = false
    @State var isTargetBMINil: Bool = false
    @State private var weight: Double = 0
    @State private var height: Double = 0
    @State private var targetWeight: Double = 0
    @State private var targetBMI: Double = 0
    @State private var feets: String = ""
 
    
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
                                .animation(.easeInOut(duration: 0.5))
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
                    .animation(.easeInOut(duration: 0.5))
                    
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
                        Text(clinicalCalculatorData.BMISegmentDetails.whatToKnow)
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
                        Text(clinicalCalculatorData.BMISegmentDetails.pearls)
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
                        Text(clinicalCalculatorData.BMISegmentDetails.whyUse)
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
        .animation(.easeInOut(duration: 0.5))
        .padding(.top, 10)
        .shadow(radius: 8)
        
       
        // MARK: End of Data Segment
        
        
        
        VStack(spacing: 0) {
            
            //MARK: Sodium Stack
            HStack{
                
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color.red_matte)
                
                VStack(alignment: .leading, spacing: 10){
                    
                    Text("Weight")
                        .foregroundColor(Color.charcol_gray)
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .padding(.leading, 5)
                    
                    Text("Lbs: \(Int(pounds))")
                        .foregroundColor(Color.FBI_Blue)
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .padding(.leading, 6)
                
                }
                Spacer()
                
                Text("Kg")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .padding(.top, 10)
                
                TextField("", text: $weightTextField, onEditingChanged: { editing in
                    if editing {
                        weightTextField = ""
                    }
                })
                // MARK: Placeholder for textField
                .placeholder(when: weightTextField.isEmpty) {
                    Text("100").foregroundColor(.gray)
                        .opacity(0.3)
                }
                .font(.system(size: 32, weight: .medium, design: .default))
                .foregroundColor(Color.FBI_Blue)
                .frame(width: 80, height: 25)
                .padding(.leading, 20)
                .keyboardType(.decimalPad)
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .padding(.top, 5)
            .clipped()
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 4)
            .shadow(radius: 8)
            
            // MARK: Blue Line
            VStack{
                
            }
            .frame(width: 16, height: 42, alignment: .leading)
            .background(Color.criticalBlue)
            
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color(UIColor.component(red: 161, green: 210, blue: 216, opacity: 1)))
                
                
                VStack(alignment: .leading, spacing: 10){
                    
                    Text("Height")
                        .foregroundColor(Color.charcol_gray)
                        .font(.system(size: 18, weight: .medium, design: .default))
                    
                    Text("Cm: \(Int(centimeters))")
                        .foregroundColor(Color.orange_TerraCotta)
                        .font(.system(size: 13, weight: .medium, design: .default))
                }
                Spacer()
                
                Text("Inches")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .padding(.top, 10)
                
                TextField("", text: $heightTextField, onEditingChanged: { editing in
                    if editing {
                        heightTextField = ""
                    }
                })
                // MARK: Placeholder for textField
                
                .placeholder(when: heightTextField.isEmpty) {
                    Text("65").foregroundColor(.gray)
                        .opacity(0.3)
                }
                .accentColor(Color.red)
                .font(.system(size: 32, weight: .medium, design: .default))
                .foregroundColor(Color.FBI_Blue)
                .frame(width: 80, height: 25)
                .padding(.leading, 20)
                .keyboardType(.decimalPad)
                
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .clipped()
            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
            .shadow(radius: 8)
            
            
            
            HStack{
                Spacer()
                Rectangle()
                    .background(Color.criticalBlue)
                    .frame(width: 16, height: 44)
                    .padding(.trailing, 50)
                Spacer()
                
                Rectangle()
                    .background(Color.criticalBlue)
                    .frame(width: 16, height: 44)
                    .padding(.leading, 50)
                Spacer()
            }
            
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color(UIColor.component(red: 236, green: 194, blue: 102, opacity: 1)))
                
                
                VStack(alignment: .leading, spacing: 10){
                    
                    Text("Target BMI")
                        .foregroundColor(Color.charcol_gray)
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .padding(.leading, 5)
                    
                    Text("Optional, to calculate the weight necessary to achieve the desired BMI.")
                        .foregroundColor(Color.orange_TerraCotta)
                        .font(.system(size: 10, weight: .medium, design: .default))
                        .padding(.leading, 5)
                }
                
                Spacer()
                
                Text("Kg/m2")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .padding(.top, 10)
                
                TextField("", text: $targetBMITextField,onEditingChanged: { editing in
                    if editing {
                        targetBMITextField = ""
                    }
                })
                // MARK: Placeholder for textField
                .placeholder(when: targetBMITextField.isEmpty) {
                    Text("21").foregroundColor(.gray)
                        .opacity(0.3)
                }
                .accentColor(Color.red)
                .font(.system(size: 32, weight: .medium, design: .default))
                .foregroundColor(Color.paoloVeronese_green)
                .frame(width: 80, height: 25)
                .padding(.leading, 20)
                .keyboardType(.decimalPad)
                
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(Color.babyPowderWhite))
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .clipped()
            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
            .padding(.bottom, 40)
            .shadow(radius: 8)
            .animation(.easeInOut(duration: 0.5))

            Button(action: {
                validation()
                hideKeyboard()
                feetConversion()
            }){
                Text("Analyze")
                    .font(.system(size: 22, weight: .heavy, design: .default ))
                    .foregroundColor(Color.white)
                    .padding()
                
                
                // Show Warning Sheet that the textFields are empty
                    .sheet(isPresented: $showingPopup, content: {
                        EmptyTextFieldPopUp() .background(BackgroundClearView())
                        
                    })
            }
            .font(.system(size: 18, weight: .heavy, design: .default))
            .frame(width: 230, height: 55, alignment: .center)
            .foregroundColor(Color.white)
            .background(Color.royal_blue)
            .cornerRadius(8)
            .padding(.bottom, 40)
            .shadow(radius: 8, y: 14)
            .animation(.easeInOut(duration: 0.5))

            
            Text("Result")
                .font(.system(size: 30, weight: .medium, design: .default))
                .foregroundColor(Color.blue)
                .padding(.top, 25)
                .opacity(isHidden ? 1 : 0)
                .animation(.easeInOut(duration: 0.3))
            
            BMIResultView(resultBMI: resultBMI, resultBSA: resultBSA, isTargetBMINil: isTargetBMINil, targetWeight: targetWeight, targetBMI: targetBMI, feets: feets, weight: weight)
                .padding(.top, 7)
                .padding(.bottom, 40)
                .opacity(isHidden ? 1 : 0)
                .animation(.easeInOut(duration: 0.3))
            
        }
        // Animate the stack
        .animation(.easeInOut(duration: 0.5))

    }
    // MARK: Calculate Centimeters
    var centimeters: Double {
       
        let heighInches = Double(heightTextField) ?? 0
        
        let finalCalculation = heighInches * 2.54

        #if DEBUG
        print("Patient is \(finalCalculation)")
        #endif
        
        return  finalCalculation
        
       
    }

// MARK: Calculate pounds
var pounds: Double {
   
    let weight = Double(weightTextField) ?? 0
    
    let finalCalculation = weight * 2.2

    #if DEBUG
    print("Patient weighs \(finalCalculation)")
    #endif
    
    return  finalCalculation
    
   
}
    
    func feetConversion() -> String {
        
        height = Double(heightTextField) ?? 0
        weight = Double(weightTextField) ?? 0

        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium //e.g.: 10 feet would be formatted as 10 ft
        formatter.unitOptions = .naturalScale
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        formatter.numberFormatter = numberFormatter
        
        // Declaring the measurement "Height in inches.
        var heightInches = Measurement(value: height, unit: UnitLength.inches)
        
        // Takes the input in "inches entered and convert the "inches" to "feet"
        var heightFeet = heightInches.converted(to: UnitLength.feet)
        
        //Variable declaring the raw value of feet in a double Since mearsurement method is a unit function of swift. It will retun 6 sig figs.
        let numberInUnit = heightFeet.value
        
        // We want to take the raw value of "feet" and round towards zero and inset it into a Unit Measurement for swift
        var feet = numberInUnit.rounded(.towardZero)
        let feetString = Measurement(value: feet, unit: UnitLength.feet)
        
        //Figure out the inches by using truncatingRemainder math from the feet.
        let inches = abs(numberInUnit.truncatingRemainder(dividingBy: 1.0)) * 12
        
        // Takes the inches "Double" and rounds to a whole value. 1.9 will be 2 etc.
        let finalInch = inches.rounded(.up)
        // Finally create our inches measurement from the new value.
        let inchesString = Measurement(value: Double(finalInch), unit: UnitLength.inches)
        
        feets = "\(feetString) \(inchesString)"
        weight = weight
        
        
        #if DEBUG
        print ("\(feets)")
        #endif
        return feets
        
    }
    
    func CalCulation() {
        
         weight = Double(weightTextField) ?? 0
         height = Double(heightTextField) ?? 0
         targetBMI = Double(targetBMITextField) ?? 0

        let squaredHeight: Double = (height * height)
        _ = weight * height
        
        resultBMI = ((weight * 2.2) * 703) / (height * height)
       
        resultBSA = (5 * (targetBMI * squaredHeight) / 7733 * 2)
    }
    
    func validation() {
    if !weightTextField.isEmpty && !heightTextField.isEmpty && !targetBMITextField.isEmpty  {
        
        CalCulation()
        isTargetBMINil = false
        isHidden = true
    }
    else if !weightTextField.isEmpty && !heightTextField.isEmpty {

        CalCulation()
        isHidden = true
        isTargetBMINil = true
        
    }
    
    else {
        isHidden = false
        showingPopup = true
        
    }
}
    
}

struct BMITextFields_Previews: PreviewProvider {
    static var previews: some View {
        BMITextFields( data: clinicalCalculatorData.BMISegmentDetails)
    }
}
