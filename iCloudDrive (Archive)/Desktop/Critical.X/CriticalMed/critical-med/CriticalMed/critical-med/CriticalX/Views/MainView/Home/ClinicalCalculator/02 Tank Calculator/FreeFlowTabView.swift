//
//  FreeFlowTabView.swift
//  CriticalX
//
//  Created by Macbook 4 on 02/12/2021.
//

import SwiftUI

struct FreeFlowTabView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var tankPSITextField: String = ""
    @State var literMinTextField: String = ""
    
    @State var tidalVolumeTexField: String = ""
    @State var respRateTexField: String = ""
    @State var fiTexField: String = ""
    
    @State var tankPSI: Double = 0
    @State var literMin: Double = 0
    @State var conversionRate: Double = 0
    @State var conversionTextField: String = ""
    
    @State var resultsLabel: String = ""
    @State var minutesLabel: String = ""
    @State var descriptionLabel: String = ""
    
    @State private var isHidden = false
    @State private var showingPopup = false
    @State private var segmentSelection: Int = 0
    
    var dropDown: [String] = ["D","Jumbo D","E","G","H/K", "Kevlar", "M","EC 135 1 Tank","EC 135 2 Tank","Bell 407, Bell 206"]
    
    static var uniqueKey: String {
        UUID().uuidString
    }
    
    let options: [DropdownOption] = [
        DropdownOption(key: uniqueKey, value: "D"),
        DropdownOption(key: uniqueKey, value: "Jumbo D"),
        DropdownOption(key: uniqueKey, value: "E"),
        DropdownOption(key: uniqueKey, value: "G"),
        DropdownOption(key: uniqueKey, value: "H/K"),
        DropdownOption(key: uniqueKey, value: "Kevlar"),
        DropdownOption(key: uniqueKey, value: "M"),
        DropdownOption(key: uniqueKey, value: "EC 135 1 Tank"),
        DropdownOption(key: uniqueKey, value: "EC 135 2 Tank"),
        DropdownOption(key: uniqueKey, value: "Bell 407"),
        DropdownOption(key: uniqueKey, value: "Bell 206")
    ]
    
    @State private var selectedDropDown = DropdownOption(key: "", value: "")
    
    @State private var biasFlow: Int = 3
    
    
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
                    Text(clinicalCalculatorData.O2CylinderCalcSegmentDetails.whatToKnow)
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
                    Text(clinicalCalculatorData.O2CylinderCalcSegmentDetails.pearls)
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
                Text(clinicalCalculatorData.O2CylinderCalcSegmentDetails.whyUse)
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
        
        VStack(spacing: 10){
            
            TwoTanksegmentControllerView(selectedIndex: $segmentSelection)
                .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
                .shadow(radius: 6)
                .padding(.leading, 50)
                .padding(.trailing, 50)
                .padding(.top, 15)
            
            if segmentSelection == 0 {
                
                HStack{
                    VStack{
                        
                    }
                    .frame(width: 15, height: 77, alignment: .leading)
                    .background(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                    VStack(alignment: .leading, spacing: 10){
                        Text("Tank PSI")
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(Color.charcol_gray)
                            .padding(.leading, 5)
                        
                        HStack {
                            Text(" ∆ Conversion Factor (Optional)")
                                .font(.system(size: 13, weight: .medium, design: .default))
                                .foregroundColor(Color.quickSilver_gray)
                                .padding(.leading, 5)
                            
                            TextField("", text: $conversionTextField)
                        // MARK: Placeholder for textField
                            .placeholder(when: conversionTextField.isEmpty) {
                                Text("0.8").foregroundColor(.gray)
                                    .opacity(0.4)
                            }
                            .padding(.trailing)
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(Color.paoloVeronese_green)
                            .fixedSize()
                            .keyboardType(.decimalPad)
                            
                            Spacer()
                        }
                        
                    }
                    Spacer()
                    Text("PSI")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(Color.charcol_gray)
                        .padding(.top, 10)
                    
                    
                    TextField("", text: $tankPSITextField)
                    // MARK: Placeholder for textField
                        .placeholder(when: tankPSITextField.isEmpty) {
                            Text("1200").foregroundColor(.gray)
                                .opacity(0.3)
                        }
                        .padding(.trailing)
                        .font(.system(size: 30, weight: .medium, design: .default))
                        .foregroundColor(Color.royal_blue)
                        .fixedSize()
                        .keyboardType(.decimalPad)
                }
                .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .padding(.top, 15)
                .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
                .shadow(radius: 8)
                VStack{
                    
                }
                .frame(width: 16, height: 42, alignment: .leading)
                .background(Color.BlueYonder)
                
                HStack{
                    VStack{
                        
                    }
                    .frame(width: 15, height: 77, alignment: .leading)
                    .background(Color(UIColor.component(red: 161, green: 210, blue: 216, opacity: 1)))
                    VStack(alignment: .leading, spacing: 10){
                        Text("Liters/ min")
                            .font(.system(size: 18, weight: .medium, design: .default))
                            .foregroundColor(Color.charcol_gray)
                            .padding(.leading, 5)
                        
                        //                        Text("")
                        //                            .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                        //                            .font(.custom(AssetConstants.fontSFProRoundedSemiBold, size: 12))
                        //                            .padding(.leading, 5)
                    }
                    Spacer()
                    Text("L/Min")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(Color.charcol_gray)
                        .padding(.top, 10)
                    
                    TextField("", text: $literMinTextField)
                    // MARK: Placeholder for textField
                        .placeholder(when: literMinTextField.isEmpty) {
                            Text("14").foregroundColor(.gray)
                                .opacity(0.3)
                        }
                        .padding(.trailing)
                        .accentColor(Color.red)
                        .font(.system(size: 30, weight: .medium, design: .default))
                        .foregroundColor(Color.mint_darkGreen)
                        .fixedSize()
                        .keyboardType(.decimalPad)
                    
                }
                .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                .shadow(radius: 8)
                
                
                HStack{
                    Spacer()
                    Rectangle()
                        .fill(Color.BlueYonder)
                        .frame(width: 16, height: 44)
                        .padding(.trailing, 50)
                    Spacer()
                    Rectangle()
                        .fill(Color.BlueYonder)
                        .frame(width: 16, height: 44)
                        .padding(.leading, 50)
                    Spacer()
                }
                
                DropdownSelector(placeholder: "Select Tank Size", options: options, onOptionSelected: { option in
                    self.selectedDropDown = option
                    CalCulation()
                }, onTapPicker: {
                    isHidden = false
                    showingPopup = true
                },tankPSI: $tankPSITextField, literMin: $literMinTextField, isClear: .constant(true))
                .zIndex(3)
                .animation(.easeInOut(duration: 0.5), value: isHidden)

                .fullScreenCover(isPresented: $showingPopup, content: {
                    HoldOnPopupView(title: "Hold On!!", message: "Check all of the fields before calculating.")
                        .background(BackgroundClearView())
                })
                
            } else {
                TankventilatorView(isHidden: $isHidden,resultsLabel: $resultsLabel, minutesLabel: $minutesLabel, descriptionLabel: $descriptionLabel)
                    .zIndex(3)
            }
            //            if isHidden {
            TankCalculatorResult(descriptionLabel: $descriptionLabel, resulteLabel: $resultsLabel, minutesLabel: $minutesLabel)
                .padding(.vertical, 20.0)
                .opacity(isHidden ? 1 : 0)
            //            }
            
        }
    }
}

struct FreeFlowTabView_Previews: PreviewProvider {
    static var previews: some View {
        FreeFlowTabView(data:clinicalCalculatorData.O2CylinderCalcSegmentDetails)
    }
}


//MARK: - Calculation
extension FreeFlowTabView {
    func CalCulation() {
        
        
        tankPSI = Double(tankPSITextField) ?? 0
        literMin = Double(literMinTextField) ?? 0
        
        let _: Double = ((tankPSI - 200) * 0.16 / literMin)
        let _: Double = ((tankPSI - 200) * 0.28 / literMin)
        let _: Double = ((tankPSI - 200) * 2.41 / literMin)
        let _: Double = ((tankPSI - 200) * 3.14 / literMin)
        let _: Double = ((tankPSI - 200) * 1.56 / literMin)
        
        let name = selectedDropDown.value
        switch self.segmentSelection {
            
        case 0:
            
            if name == "D" {
                self.calculateFlow_D()
            }
            
            if name == "Jumbo D" {
                self.calculateFlow_JumboD()
            }
            
            if name == "E" {
                self.calculateFlow_E()
            }
            
            if name == "G" {
                self.calculateFlow_G()
            }
            
            if name == "H/K" {
                self.calculateFlow_HK()
            }
            if name == "Kevlar" {
                self.calculateFlow_Kevlar()
            }
            
            if name == "M" {
                self.calculateFlow_M()
            }
            if name == "EC 135 1 Tank" {
                self.calculateFlow_EC135_1()
            }
            
            if name == "EC 135 2 Tanks" {
                self.calculateFlow_EC135_2()
                
            }
            
            if name == "Bell 407" {
                self.calculateFlow_Bell()
            }
            
            if name == "Bell 206" {
                self.calculateFlow_Bell_206()
            }
        case 1:
            if name == "D" {
                
                self.calculateVent_D()
            }
            if name == "E" {
                
                //                    self.calculateVent_E()
            }
            
            if name == "G" {
                //                self.calculateVent_G()
            }
            
            if name == "M" {
                //                    self.calculateVent_M()
            }
            if name == "H/K" {
                //                    self.calculateVent_HK()
            }
            
            if name == "EC 135 1 Tank" {
                //                    self.calculateVent_EC135_1()
            }
            
            if name == "EC 135 2 Tanks" {
                //                    self.calculateVent_EC135_2()
                
            }
            
            if name == "Bell 407" {
                //                    self.calculateVent_bell()
            }
            
        default:
            break
        }
        
        
        
        //        if (resultsLabel > "0.0") {
        //
        //            switch segmentSelection {
        //            case 0?:
        //                resultsLabel = String(format:"%.1f",D) // Rounds to the 1st decimal place
        //                //o2DetailView.isHidden = false
        //
        //                minutesLabel = "Minutes"
        //                descriptionLabel = "A \"D\" cylinder with \(tankPSI) PSI at \(literMin) L/min"
        //
        //                if (resultsLabel < "0.0") {
        //                    minutesLabel = "Refill the tank"
        //                    resultsLabel = "Empty Tank"
        //                    // o2DetailView.isHidden = false
        //                    descriptionLabel = "Looks like the tank is"
        //                }
        //
        //            case 1?:
        //                resultsLabel = E.oneDecimalPlace
        //                //o2DetailView.isHidden = false
        //                minutesLabel = "Minutes"
        //                descriptionLabel = "An \"E\" cylinder at \(tankPSI) PSI at \(literMin) L/min"
        //
        //            case 2?:
        //
        //                resultsLabel = G.oneDecimalPlace
        //                //o2DetailView.isHidden = false
        //                minutesLabel = "Minutes"
        //                descriptionLabel = "A \"G\" cylinder at \(tankPSI) PSI on \(literMin) L/min"
        //
        //            case 3?:
        //
        //                resultsLabel = HK.oneDecimalPlace
        //                //o2DetailView.isHidden = false
        //                minutesLabel = "Minutes"
        //                descriptionLabel = "An \"H/K\" cylinder at \(tankPSI) PSI on \(literMin) L/min"
        //
        //            case 4?:
        //
        //                resultsLabel = M.oneDecimalPlace
        //                // o2DetailView.isHidden = false
        //                minutesLabel = "Minutes"
        //
        //                descriptionLabel = "An \"M\" cylinder with \(tankPSI) PSI at \(literMin) L/min"
        //
        //            default:
        //                break
        //            }
        //        }
        //        else if (resultsLabel < "0.0") {
        //            minutesLabel = "Refill tank"
        //            resultsLabel = "Empty Tank"
        //            // o2DetailView.isHidden = false
        //        }
    }
    
    func calculateFlow_D()  {
        
        
        _ = (literMin + Double(biasFlow))
        
        conversionRate = Double(conversionTextField) ?? 0.16
        
        if conversionTextField.isEmpty {
            
            conversionRate = 0.16
       }
        
        #if DEBUG
        print(conversionRate)
        #endif

        let D: Double = ((tankPSI - 200) * conversionRate / literMin)

        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(D))

        isHidden = true

        descriptionLabel = "A \"D\" cylinder with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"

        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"

        minutesLabel = "Hours : Minutes"

        if (self.resultsLabel < "0.0") {

            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            #if DEBUG
            print("Tank D was selected")
            #endif
        }
        
    }
   
    func calculateFlow_JumboD()  {
        
        
        _ = (literMin + Double(biasFlow))
        
        conversionRate = Double(conversionTextField) ?? 0.25
        
        if conversionTextField.isEmpty {
            
            conversionRate = 0.25
       }
        
        #if DEBUG
        print(conversionRate)
        #endif

        let D: Double = ((tankPSI - 200) * conversionRate / literMin)

        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(D))

        isHidden = true
        descriptionLabel = "A \"Jumbo D\" cylinder with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"

        minutesLabel = "Hours : Minutes"

        if (self.resultsLabel < "0.0") {

            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            #if DEBUG
            print("Tank Jumbo D was selected")
            #endif
        }
        
    }
    
    func calculateFlow_E()  {
        
        
        _ = (literMin + Double(biasFlow))
        
        conversionRate = Double(conversionTextField) ?? 0.28
        
        if conversionTextField.isEmpty {
            
            conversionRate = 0.28
       }
        
        #if DEBUG
        print(conversionRate)
        #endif

        // Pressure Calculation
        let E: Double = ((tankPSI - 200) * conversionRate / literMin)
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(E))
        
        isHidden = true
        self.resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Hours minute label
        self.minutesLabel = "Hr:Min"
        
        // Set description label
        self.descriptionLabel = "A \"E\" cylinder with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        
        // If its empty then let us know.
        if (self.resultsLabel < "0.0") {
            
            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            
        }
    }
    
    func calculateFlow_G()  {
        
        
        _ = (literMin + Double(biasFlow))
        
        conversionRate = Double(conversionTextField) ?? 2.41
        
        if conversionTextField.isEmpty {
            
            conversionRate = 2.41
       }
        
        #if DEBUG
        print(conversionRate)
        #endif
        // Pressure Calculation
        let G: Double = ((tankPSI - 200) * conversionRate / literMin)
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(G))
        
        
        isHidden = true
        
        // Displays time left
        self.resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Hours minute label
        self.minutesLabel = "Hr:Min"
        
        // Set description label
        self.descriptionLabel = "A \"G\" cylinder with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        
        
        // If its empty then let us know.
        if (self.resultsLabel < "0.0") {
            
            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            
        }
    }
    
    
    func calculateFlow_HK()  {
        
        _ = (literMin + Double(biasFlow))
        
        conversionRate = Double(conversionTextField) ?? 3.14
        
        if conversionTextField.isEmpty {
            
            conversionRate = 3.14
       }
        
        // Pressure Calculation
        let HK: Double = ((tankPSI - 200) * conversionRate / literMin)
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(HK))
        isHidden = true
        
        // Displays time left
        self.resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Hours minute label
        self.minutesLabel = "Hr:Min"
        
        // Set description label
        self.descriptionLabel = "A \"HK\" cylinder with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        
        // If its empty then let us know.
        if (self.resultsLabel < "0.0") {
            
            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            
        }
    }
    
    func calculateFlow_Kevlar()  {
        
        
        _ = (literMin + Double(biasFlow))
        
        conversionRate = Double(conversionTextField) ?? 0.25
        
        if conversionTextField.isEmpty {
            
            conversionRate = 0.25
       }
        
        // Pressure Calculation
        let M: Double = ((tankPSI - 200) * conversionRate / literMin)
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(M))
        
        isHidden = true
        
        // Displays time left
        self.resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Hours minute label
        self.minutesLabel = "Hr:Min"
        
        // Set description label
        self.descriptionLabel = "A \"Kevlar\" cylinder with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        
        // If its empty then let us know.
        if (self.resultsLabel < "0.0") {
            
            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            
        }
    }
    
    
    func calculateFlow_M()  {
        
        
        _ = (literMin + Double(biasFlow))
        
        conversionRate = Double(conversionTextField) ?? 1.56
        
        if conversionTextField.isEmpty {
            
            conversionRate = 1.56
       }
        
        // Pressure Calculation
        let M: Double = ((tankPSI - 200) * conversionRate / literMin)
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(M))
        
        isHidden = true
        
        // Displays time left
        self.resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Hours minute label
        self.minutesLabel = "Hr:Min"
        
        // Set description label
        self.descriptionLabel = "A \"M\" cylinder with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        
        // If its empty then let us know.
        if (self.resultsLabel < "0.0") {
            
            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            
        }
    }
    
    func calculateFlow_EC135_1()  {
        
        _ = (literMin + Double(biasFlow))
        
        
        // Pressure Calculation
        // Older calculation.
        //let EC135_1: Double = ((tankPSI - 200) * 0.96 / literMin)
        
        conversionRate = Double(conversionTextField) ?? 1.17
        
        if conversionTextField.isEmpty {
            
            conversionRate = 1.17
       }
        
        //based off Conversion Factor 2166(Max Pressure)/1850 (Max Volume)
        let EC135_1: Double = ((tankPSI - 200) * conversionRate / literMin)
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(EC135_1))
        isHidden = true
        
        // Displays time left
        self.resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Hours minute label
        self.minutesLabel = "Hr:Min"
        
        // Set description label
        self.descriptionLabel = "A \"EC135\" 1 tank with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        
        // If its empty then let us know.
        if (self.resultsLabel < "0.0") {
            
            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            
        }
    }
    
    func calculateFlow_EC135_2()  {
        
        _ = (literMin + Double(biasFlow))
        
        
        conversionRate = Double(conversionTextField) ?? 1.93
        
        if conversionTextField.isEmpty {
            
            conversionRate = 1.93
       }
        
        // Pressure Calculation
        let EC135_2: Double = ((tankPSI - 200) * conversionRate / literMin)
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(EC135_2))
        
        isHidden = true
        
        // Displays time left
        self.resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Hours minute label
        self.minutesLabel = "Hr:Min"
        
        // Set description label
        self.descriptionLabel = "A \"EC135\" 2 tank with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        
        
        // If its empty then let us know.
        if (self.resultsLabel < "0.0") {
            
            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            
        }
    }
    
    func calculateFlow_Bell()  {
        
        _ = (literMin + Double(biasFlow))
        
        
        // Pressure Calculation
        // Older Calculation
        // let bell: Double = ((tankPSI - 200) * 1.45 / literMin)
        
        conversionRate = Double(conversionTextField) ?? 1.14
        
        if conversionTextField.isEmpty {
            
            conversionRate = 1.14
       }
        
        let bell: Double = ((tankPSI - 200) * conversionRate / literMin)
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(bell))
        isHidden = true
        
        // Displays time left
        self.resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Hours minute label
        self.minutesLabel = "Hr:Min"
        
        // Set description label
        self.descriptionLabel = "A \"Bell 407\" tank with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        
        // If its empty then let us know.
        if (self.resultsLabel < "0.0") {
            
            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            
        }
    }
    
    
    func calculateFlow_Bell_206() {
        
        _ = (literMin + Double(biasFlow))
        
        conversionRate = Double(conversionTextField) ?? 1.8
        
        if conversionTextField.isEmpty {
            
            conversionRate = 1.8
       }
        
        // Pressure Calculation
        let bell: Double = ((tankPSI - 200) * conversionRate / literMin)
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(bell))
        isHidden = true
        
        // Displays time left
        self.resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Hours minute label
        self.minutesLabel = "Hr:Min"
        
        // Set description label
        self.descriptionLabel = "A \"Bell 206\" tank with \(tankPSI) PSI | \(literMin) L/min | Conversion Factor of \(conversionRate)"
        
        // If its empty then let us know.
        if (self.resultsLabel < "0.0") {
            
            self.minutesLabel = "Refill the tank"
            self.resultsLabel = "Empty Tank"
            self.descriptionLabel = "Looks like the tank is"
            
        }
    }
    
    func calculateVent_D() -> Void {
        
        
        //        let respRate = Double(rrTextField.text!)
        //
        //        guard let TV = Double(tvTextField.text!) else {
        //            print("TV not entered")
        //             _ = SCLAlertView().showWarning("Hold On...", subTitle: "Fill in all of the fields before calculating.")
        //            // Hide the view
        //            resultView.isHidden = true
        //
        //            return
        //        }
        //
        //        let fio2 = Double(fi02TextField.text!)
        //
        //        guard let rr = Double(rrTextField.text!) else {
        //             _ = SCLAlertView().showWarning("Hold On...", subTitle: "Fill in all of the fields before calculating.")
        //
        //            //Hide the view
        //            resultView.isHidden = true
        //
        //            print("RR not entered")
        //            return
        //        }
        //
        //
        //
        //        guard   let _  = psitTxt.text,
        //                let _  = fi02TextField.text,
        //                let _  = tvTextField.text,
        //                let _  = rrTextField.text
        //                else {
        //                    print("values not filled all the way in for the Vent")
        //                    _ = SCLAlertView().showWarning("Hold On...", subTitle: "Fill in all of the fields before calculating.")
        //
        //                    return  }
        //
        //        //let totalLpm = (liters! + Double(biasFlow))
        //
        ////        guard var fi02Adjusted: Double? = ((totalLpm * fio2! / 100) ) else {
        ////            print("Enter fio2 and lpm")
        ////            return
        ////
        ////        }
        //
        //        let D: Double = ((psi! - 200) * 0.19)
        //
        ////        let E: Double = ((psi! - 200) * 0.28 / liters!)
        ////
        ////        let G: Double = ((psi! - 200) * 2.41 / liters!)
        ////
        ////        let HK: Double = ((psi! - 200) * 3.14 / liters!)
        ////
        ////        let M: Double = ((psi! - 200) * 1.56 / liters!)
        //
        //
        //        // calcualte the minite vlm
        //        let MV = (rr * TV) / 1000
        //        print("MV calculated  is \(MV)")
        //
        //
        //        let o2Draw = (((fio2!/100) - 0.21) * 1.265) * 100
        //
        //        let correctedFlow = ((MV + (Double(biasFlow))))
        //
        //        // We get the total LPM off the bias flow and corrected fi02
        //        let totalLPM_O2_Draw = (correctedFlow * o2Draw) / 100
        //
        //
        //
        //
        //        print("corrected flow is \(correctedFlow)")
        //
        //        let ventCalculation_D = ((D / totalLPM_O2_Draw))
        //
        //        print("\(D) divided by \(totalLPM_O2_Draw) is \(ventCalculation_D) final")
        //
        //
        //        let DVent: Double = ventCalculation_D
        //
        //        // Convert the calculation to hours and minutes
        //        let timeLeftOver = minutesToHours(minutes: Int(DVent))
        //
        //
        //
        //
        //        resultView.isHidden = false
        //
        //        pickerButton.setTitle("D Portable Cylinder", for: .normal)
        //
        //        resultsLabel.text = "\(timeLeftOver.hours): \(timeLeftOver.leftMinites)"
        //
        //
        //        minutesLabel.text = "Hours : Minutes"
        //        descriptionLabel.text = "A \"D\" cylinder with \(psi!) PSI at a total LPM of \(correctedFlow ) L/min"
        //
        //        view.endEditing(true)
        //
        //        // If its empty then let us know.
        //        if (resultsLabel.text! < "0.0") {
        //
        //            minutesLabel.text = "Refill the tank"
        //
        //            resultsLabel.text = "Empty Tank"
        //
        //            resultsLabel.textColor = UIColor.yellow
        //
        //            descriptionLabel.text = "Looks like the tank is"
        //
        //            descriptionLabel.textColor = UIColor.gray
        //
        //            print("Tank D was selected")
        //
        //            print(self.ventSegmento2.selectedSegmentIndex)
        //
        //
        //        }
        
    }
    
    func minutesToHours(minutes: Int) -> (hours: Int, leftMinites: Int) {
        return (minutes / 60 , (minutes % 60))
    }
    
    func validation() {
        if !tankPSITextField.isEmpty && !literMinTextField.isEmpty {
            CalCulation()
            isHidden = true
            showingPopup = false
        } else {
            isHidden = false
            showingPopup = true
        }
    }
}


//MARK: - Segment 0 free flow
extension FreeFlowTabView {
    
    func freeFlowCal() {
        
        //        if selectedDropDown == dropDown[0] {
        //
        //        }
    }
    
}


