//
//  IdealBodyTextFiledsView.swift
//  CriticalX
//
//  Created by Macbook 4 on 02/12/2021.
//

import SwiftUI

struct IdealBodyTextFiledsView: View {

    @Environment(\.colorScheme) var colorScheme

    @State private var heightTextField: String = ""
    @State private var TargetTVTextField: String = ""
    @State private var height: Double = 0
    @State private var targetTV: Double = 0
    @State private var pounds: Double = 0
    @State private var poundsExpected: Double = 0
    @State private var ettDepth: Double = 0
    @State private var feetss: String = ""
    @State private var calculateTV: Int = 0
    @State private var gender: String = ""
    let cm = 2.54
    @State var showingPopup = false
    @State var showingPopup1 = false
    @State var isDisable = true
    @State private var isHidden: Bool = false
    @State private var segmentIndex: Int = 0

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
                    Text(clinicalCalculatorData.idealBodyWeightSegmentDetails.whatToKnow)
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
                    Text(clinicalCalculatorData.idealBodyWeightSegmentDetails.pearls)
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
                Text(clinicalCalculatorData.idealBodyWeightSegmentDetails.whyUse)
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
        
        
        VStack{
            
            VStack {
                
                SegmentControllerView(selectedIndex: $segmentIndex)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
                    .padding(.top, 15)
                    .padding(.leading, 10).padding(.trailing, 10)

                  
                HStack{
                    VStack(alignment: .center){
                        Text("Height")
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                            .padding(.trailing, 5)
                        
                        TextField("", text: $heightTextField)
                           
                        // MARK: Placeholder for textField
                            .placeholder(when: heightTextField.isEmpty) {
                                HStack{
                                    Spacer()
                                    Text("72").foregroundColor(.gray)
                                    .opacity(0.3)
                                    Spacer()
                                }
                            }
                            .font(.system(size: 28, weight: .medium, design: .default))

                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.orange_TerraCotta)
                            .keyboardType(.decimalPad)
                        
                        Text("inches")
                            .font(.system(size: 13, weight: .medium, design: .default))
                            .foregroundColor(Color.red_matte)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 40)
                    
                    Spacer()
                    
                    VStack(alignment: .center){
                        Text("Target TV")
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                        
                        TextField("", text: $TargetTVTextField)
                            .placeholder(when: TargetTVTextField.isEmpty) {
                                HStack{
                                    Spacer()
                                    Text("6-8").foregroundColor(.gray)
                                    .opacity(0.3)
                                    Spacer()
                                }

                            }
                            .font(.system(size: 28, weight: .medium, design: .default))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.paoloVeronese_green)
                            .keyboardType(.decimalPad)
                            .fullScreenCover(isPresented: $showingPopup1, content: {
                               
                                HoldOnPopupView(title: "Hold Up!", message: "Enter a target tidal volume in mL/kg\nRecommended 4 - 10 mL/kg!")
                                    .background(BackgroundClearView())
                            })
                            .onChange(of: TargetTVTextField) { newValue in
                                if !TargetTVTextField.isEmpty{
                                    isDisable = true
                                    
                                    let targetTV = Double(newValue)
                                    
                                    if targetTV != nil {
                                        if (targetTV! >= 4 && targetTV! <= 10) {
                                            isDisable = false
                                        }
                                        else {
                                            showingPopup1 = true
                                        }
                                    }
                                }
                            }
                        
                        Text("mL/kg")
                            .font(.system(size: 13, weight: .medium, design: .default))
                            .foregroundColor(Color.red_matte)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.trailing, 40)
                }
                .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.component(red: 227, green: 241, blue: 240, opacity: 1)))
                .frame(width: UIScreen.main.bounds.width * 0.85)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
                )
                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                Text("Ideal Tidal Volumes is between 6-8 mL/kg")
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(Color.purple_Independence)
                    .padding(.bottom, 15)
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .background(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color(UIColor.systemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.3) : Color.clear, lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.5), value: segmentIndex)

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
                .font(.system(size: 18, weight: .medium, design: .default))
                .foregroundColor(Color.white)
                .animation(.easeInOut(duration: 0.5), value: isDisable)

            }
            .background(Color.royal_blue)
            .cornerRadius(8)
            .padding(.top, 30)
            .shadow(radius: 8, y: 14)
            .animation(.easeInOut(duration: 0.5), value: isDisable)
            .disabled(isDisable)
            .fullScreenCover(isPresented: $showingPopup, content: {
                HoldOnPopupView(title: "Error", message: "Make sure all of the text fields have values before calculating.")
                    .background(BackgroundClearView())
            })

            Text("Result")
                .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 20))
                .foregroundColor(Color.blue)
                .padding(.top, 10)
                .opacity(isHidden ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isHidden)

            IdealBodyResultView(pounds: pounds, poundsExpected: poundsExpected,  gender: gender, height: height, targetTV: targetTV, ettDepth: ettDepth, calculateTv: calculateTV, measurement: feetss)
                .padding(.top, 5)
                .padding(.bottom, 10)
                .opacity(isHidden ? 1 : 0)
            
            CalculatorDisclaimerView()
                .opacity(isHidden ? 1 : 0)
                .padding(.bottom, 50)
        }
        .animation(.easeInOut(duration: 0.5), value: isHidden)

    }
    
    //MARK: Functions
    
    func CalCulation() {
        
        height = heightTextField.safeDouble ?? 0
        targetTV = TargetTVTextField.safeDouble ?? 0
        
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium //e.g.: 10 feet would be formatted as 10 ft
        formatter.unitOptions = .naturalScale
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .none
        formatter.numberFormatter = numberFormatter
        
        var heighttoCmConversion: Int {
            
            return Int (height.rounded() * cm)
        }
        
        ettDepth = 0.1 * Double(heighttoCmConversion ) + 4
        
        // Declaring the measurement "Height in inches.
        let heightInches = Measurement(value: height, unit: UnitLength.inches)

        // Takes the input in "inches entered and convert the "inches" to "feet"
        let heightFeet = heightInches.converted(to: UnitLength.feet)
        
        //Variable declaring the raw value of feet in a double Since mearsurement method is a unit function of swift. It will retun 6 sig figs.
        let numberInUnit = heightFeet.value
        
        // We want to take the raw value of "feet" and round towards zero and inset it into a Unit Measurement for swift
        let feet = numberInUnit.rounded(.towardZero)
        let feetString = Measurement(value: feet, unit: UnitLength.feet)
        
        //Figure out the inches by using truncatingRemainder math from the feet.
        let inches = abs(numberInUnit.truncatingRemainder(dividingBy: 1.0)) * 12
        
        // Takes the inches "Double" and rounds to a whole value. 1.9 will be 2 etc.
        let finalInch = inches.rounded(.up)
        // Finally create our inches measurement from the new value.
        let inchesString = Measurement(value: Double(finalInch), unit: UnitLength.inches)
        
        let maleIBWCalculation  = (50 + 2.3 * (Double (heightTextField)! - 60)).roundTo(places: 1)
        let femaleIBWCalculation  = (45.5 + 2.3 * (Double (heightTextField)! - 60)).roundTo(places: 1)
        let IBW_Int_MALE = maleIBWCalculation.rounded()
        
        let IBW_Int_FEMALE = femaleIBWCalculation.rounded()
        
        switch segmentIndex {
            
        case 0:
            
            pounds = (50 + 2.3 * (Double(height) - 60)).roundTo(places: 1)
            poundsExpected = (pounds.rounded() * 2.2)
            calculateTV = Int(IBW_Int_MALE * targetTV)
            feetss = "\(feetString) \(inchesString)"
            gender = "Male"
        case 1:
            
            pounds = (45.5 + 2.3 * (Double(height) - 60)).roundTo(places: 1)
            poundsExpected = (pounds.rounded() * 2.2)
            calculateTV = Int(IBW_Int_FEMALE * targetTV)
            feetss = "\(feetString) \(inchesString)"
            gender = "Female"
 
        default:
            #if DEBUG
            print("Nothing...")
            #endif
        }
        
        
    }
    
    func validation() {
        if !heightTextField.isEmpty && !TargetTVTextField.isEmpty {
            CalCulation()
            isHidden = true
            showingPopup = false
        } else {
            isHidden = false
            showingPopup = true
        }
    }
}

struct IdealBodyTextFiledsView_Previews: PreviewProvider {
    static var previews: some View {
        IdealBodyTextFiledsView(data: clinicalCalculatorData.idealBodyWeightSegmentDetails)
    }
}


//MARK: IdealBodySegmentController

//struct idealBodySegmentView: View {
//    @State private var segmentIndex: Int = 0
//    var body: some View {
//
//        VStack {
//            Picker("", selection: $segmentIndex) {
//                Text("Male").tag(0)
//                    .padding()
//                Text("Female").tag(1)
//                    .padding()
//            }
//            .pickerStyle(.segmented)
//            .font(.system(size: 18).weight(.semibold))//            .frame(width: UIScreen.main.bounds.width * 0.65)
//            //.cornerRadius(20)
//            .shadow(radius: 1)
//        }
//        .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
//    }
//    init() {
//        UISegmentedControl.appearance().selectedSegmentTintColor =  (UIColor.component(red: 204, green: 91, blue: 87, opacity: 1))
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
//        UISegmentedControl.appearance().backgroundColor = (UIColor.white)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)], for: .normal)
//    }
//
//}
//
//struct idealBodySegmentView_Previews: PreviewProvider {
//    static var previews: some View {
//        idealBodySegmentView()
//    }
//}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}


extension Double {
    
    func roundTo(places:Int) -> Double {
    
        let divisor = pow(10.0, Double(places))
    
        return (self * divisor).rounded() / divisor
    }
}
