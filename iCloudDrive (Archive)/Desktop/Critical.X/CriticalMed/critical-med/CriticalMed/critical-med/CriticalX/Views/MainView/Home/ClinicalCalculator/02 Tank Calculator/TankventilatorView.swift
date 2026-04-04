//
//  TankventilatorView.swift
//  CriticalX
//
//  Created by Macbook 4 on 02/12/2021.
//

import SwiftUI

struct TankventilatorView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var tankPSITextField: String = ""
    @State private var literMinTextField: String = ""
    @State private var tidalVolumeTexField: String = ""
    @State private var respRateTexField: String = ""
    @State private var fiTexField: String = ""
    @State private var ventilatorSegmentSelection: Int = 0
    @State private var showingPopup = false
    @State private var isClear = false
    @State private var biasFlowLabel: String = ""
    @State private var usablePsi : String = "Enter total PSI Available"

    @Binding var isHidden: Bool
    
    @Binding var resultsLabel: String
    @Binding var minutesLabel: String
    @Binding var descriptionLabel: String
    
    var dropDown: [String] = ["D","E","G","H/K","M","EC 135 1 Tank","EC 135 2 Tank","Bell 407"]
    
    static var uniqueKey: String {
        UUID().uuidString
    }
    
    let options: [DropdownOption] = [
        DropdownOption(key: uniqueKey, value: "D"),
        DropdownOption(key: uniqueKey, value: "E"),
        DropdownOption(key: uniqueKey, value: "G"),
        DropdownOption(key: uniqueKey, value: "H/K"),
        DropdownOption(key: uniqueKey, value: "M"),
        DropdownOption(key: uniqueKey, value: "MEC 135 1 Tank"),
        DropdownOption(key: uniqueKey, value: "EC 135 2 Tank"),
        DropdownOption(key: uniqueKey, value: "Bell 407")
    ]
    @State private var selectedDropDown = DropdownOption(key: "", value: "")
    @State private var biasFlow: Int = 5
    
    var body: some View {
        
        VStack(spacing: 0){
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color.orange)
                VStack(alignment: .leading, spacing: 10){
                    Text("Tank PSI")
                        .foregroundColor(Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 1)))
                        .font(.system(size: 18, weight: .medium, design: .default))
                        .padding(.leading, 5)
                    
                    Text(usablePsi)
                        .foregroundColor(Color.gray)
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .padding(.leading, 5)
                }
                Spacer()
                Text("PSI")
                    .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 16))
                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                    .padding(.top, 10)
                
                
                TextField("", text: $tankPSITextField, onEditingChanged: { changed in
                    
                    let newPsi = Double(tankPSITextField)
                    
                    // If we delete text values it changes the usable psi text and doesnt calculate.
                    guard newPsi != nil else {
                        #if DEBUG
                        print("new PSI is empty")
                        #endif
                        
                        // Set the label to be empty and not to calculate
                        usablePsi = "Usable PSI:"

                        return
                    }
                    usablePsi = "Usable PSI: \(Int(newPsi! - 200))"
                })
                // MARK: Placeholder for textField
                    .placeholder(when: tankPSITextField.isEmpty) {
                            Text("1000").foregroundColor(.gray)
                            .opacity(0.3)
                    }
                    .padding(.trailing)
                    .font(.system(size: 35, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
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
            .background(Color.royal_blue)
            
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color(UIColor.component(red: 161, green: 210, blue: 216, opacity: 1)))
                VStack(alignment: .leading, spacing: 10){
                    Text("Liters/ min")
                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                        .font(.custom(AssetConstants.fontSFProDisplayBold, size: 16))
                        .padding(.leading, 5)
                    
                    Text("")
                        .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .padding(.leading, 5)
                }
                Spacer()
                Text("L/Min")
                    .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 16))
                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                    .padding(.top, 10)
                
                TextField("", text: $literMinTextField)
                // MARK: Placeholder for textField
                    .placeholder(when: literMinTextField.isEmpty) {
                            Text("14").foregroundColor(.gray)
                            .opacity(0.3)
                    }
                    .padding(.trailing)
                    .accentColor(Color.red)
                    .font(.system(size: 35, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .fixedSize()
                    .keyboardType(.decimalPad)
                
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
            .shadow(radius: 8
            
            
            )
            HStack{
                Spacer()
                Rectangle()
                    .fill(Color.royal_blue)
                    .frame(width: 16, height: 35)
                    .padding(.trailing, 50)
                Spacer()
                Rectangle()
                    .fill(Color.royal_blue)
                    .frame(width: 16, height: 35)
                    .padding(.leading, 50)
                Spacer()
            }
            ventilatoregmentControllerView(selectedIndex: $ventilatorSegmentSelection)
                  .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
                  .shadow(radius: 8)
                  .padding(.bottom, 10)
            
            Text(ventilatorSegmentSelection == 0 ? "Adult/Peds Circuit: A bias flow of 5 lpm is added to the flow rate" : ventilatorSegmentSelection == 1 ? "NEONATAL CIRCUT: A BIAS FLOW OF 4 L/MIN IS ADDED TO THE FLOW RATE." : "NO BIAS FLOW ADDED TO THE FLOW RATE.")
                .foregroundColor(Color.orange_TerraCotta)
                .font(.system(size: 13, weight: .semibold, design: .default))
                .padding(.top, 10)
            
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color.purple_Independence)
                VStack(alignment: .leading, spacing: 10){
                    Text("Tidal Volume")
                        .foregroundColor(Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 1)))
                        .font(.system(size: 18, weight: .medium, design: .default))

                }
                Spacer()
                Text("mL's")
                    .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 16))
                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                    .padding(.top, 10)
                    
                
                TextField("", text: $tidalVolumeTexField)
                // MARK: Placeholder for textField
                    .placeholder(when: tidalVolumeTexField.isEmpty) {
                            Text("500").foregroundColor(.gray)
                            .opacity(0.3)
                    }
                    .font(.system(size: 35, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .frame(width: 90, height: 25)
                    
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .padding(.top, 15)
            .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
            .shadow(radius: 8)
            
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color.rollTide_red)
                VStack(alignment: .leading, spacing: 10){
                    Text("Resp Rate")
                        .foregroundColor(Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 1)))
                        .font(.system(size: 18, weight: .medium, design: .default))

                    
                    Text("Breaths/min")
                        .foregroundColor(Color.mint_darkGreen)
                        .font(.system(size: 14, weight: .medium, design: .default))
                }
                Spacer()
              
                TextField("", text: $respRateTexField)
                // MARK: Placeholder for textField
                    .placeholder(when: respRateTexField.isEmpty) {
                            Text("16").foregroundColor(.gray)
                            .opacity(0.3)
                    }
                    .font(.system(size: 35, weight: .medium, design: .default))
                    .foregroundColor(Color.charcol_gray)
                    .frame(width: 90, height: 25)
                    
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .padding(.top, 10)
            .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
            .shadow(radius: 8)
            
            HStack{
                VStack{
                    
                }
                .frame(width: 15, height: 77, alignment: .leading)
                .background(Color.mint_darkGreen)
                VStack(alignment: .leading, spacing: 10){
                    Text("FI02")
                        .foregroundColor(Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 1)))
                        .font(.system(size: 18, weight: .medium, design: .default))

                    
                    Text("%")
                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                        .font(.custom(AssetConstants.fontSFProRoundedSemiBold, size: 12))
                }
                Spacer()
                Text("%")
                    .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 16))
                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                    .padding(.top, 10)
                    
                
                TextField("", text: $fiTexField)
                // MARK: Placeholder for textField
                    .placeholder(when: fiTexField.isEmpty) {
                            Text("60").foregroundColor(.gray)
                            .opacity(0.3)
                    }
                    .font(.system(size: 35, weight: .medium, design: .default))
                    .foregroundColor(Color.mint_darkGreen)
                    .frame(width: 90, height: 25)
                    
            }
            .background(RoundedCornersShape(corners: [.bottomRight, .topRight], radius: 15).fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white))
            .frame(width: UIScreen.main.bounds.width * 0.95)
            .padding(.top, 10)
            .padding(.bottom, 13)
            .shadow(color: Color(UIColor.component(red: 0, green: 0, blue: 0, opacity: 0.05)), radius: 2, x: 0, y: 4)
            .shadow(radius: 8)
            
//            DropdownSelector(placeholder: "Select Tank Size", options: options,tankPSI: $tankPSITextField, literMin: $literMinTextField)
//                .zIndex(3)
//                .padding(.top, 10)
            
            DropdownSelector(placeholder: "Select Tank Size", options: options, onOptionSelected: { option in
                self.selectedDropDown = option
                CalCulation()
            }, onTapPicker: {
                isHidden = false
                showingPopup = true
            },tankPSI: $tankPSITextField, literMin: $literMinTextField, isClear: $isClear)
                .zIndex(3)
                .padding(.vertical, 10)
                .fullScreenCover(isPresented: $showingPopup, content: {
                    HoldOnPopupView(title: "Hold On!!", message: "Check all of the fields before calculating.")
                        .background(BackgroundClearView())
                })
            
        } //main Vstack
        
    } // body
//

}

struct TankventilatorView_Previews: PreviewProvider {
    static var previews: some View {
        TankventilatorView(isHidden: .constant(false),resultsLabel: .constant(""), minutesLabel: .constant(""), descriptionLabel: .constant(""))
    }
}

//MARK: - Calculation
extension TankventilatorView {
    func CalCulation() {
        
        switch ventilatorSegmentSelection {
        case 0:
            biasFlow = 5
        case 1:
            biasFlow = 4
        case 2:
            biasFlow = 0
        default:
            break
        }
        
        let name = selectedDropDown.value
        
        if name == "D" {
        
            self.calculateVent_D()
        }
        if name == "E" {
            
            self.calculateVent_E()
        }
        
        if name == "G" {
            self.calculateVent_G()
        }
        
        if name == "M" {
            self.calculateVent_M()
        }
        if name == "H/K" {
            self.calculateVent_HK()
        }
        
        if name == "EC 135 1 Tank" {
            self.calculateVent_EC135_1()
        }
        
        if name == "EC 135 2 Tanks" {
            self.calculateVent_EC135_2()

        }
        
        if name == "Bell 407" {
            self.calculateVent_bell()
        }
        
//        isHidden = true
    }
    
    func calculateVent_D() -> Void {
        

        
        let tankPSI = Double(tankPSITextField) ?? 0
        _ = Double(respRateTexField)

        guard let TV = Double(tidalVolumeTexField) else {
            #if DEBUG
            print("TV not entered")
            #endif
            isHidden = false
            showingPopup = true
            isClear = true

            return
        }
        

        let fio2 = Double(fiTexField)

        guard let rr = Double(respRateTexField) else {

            isHidden = false
            showingPopup = true
            isClear = true
            #if DEBUG
            print("RR not entered")
            #endif
            return
        }

        if tankPSITextField.isEmpty || fiTexField.isEmpty || tidalVolumeTexField.isEmpty || respRateTexField.isEmpty {
            isHidden = false
            showingPopup = true
            isClear = true
            #if DEBUG
            print("RR not entered")
            #endif
            return
        }

        let D: Double = ((tankPSI - 200) * 0.19)

//        // calcualte the minite vlm
        let MV = (rr * TV) / 1000
        #if DEBUG
        print("MV calculated  is \(MV)")
        #endif

        let o2Draw = (((fio2!/100) - 0.21) * 1.265) * 100
        let correctedFlow = ((MV + (Double(biasFlow))))
//
//        // We get the total LPM off the bias flow and corrected fi02
        let totalLPM_O2_Draw = (correctedFlow * o2Draw) / 100

        let ventCalculation_D = ((D / totalLPM_O2_Draw))

        #if DEBUG
        print("corrected flow is \(correctedFlow)")
        print("\(D) divided by \(totalLPM_O2_Draw) is \(ventCalculation_D) final")
        #endif


        let DVent: Double = ventCalculation_D

        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(DVent))

        isHidden = true

        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"


        minutesLabel = "Hours : Minutes"
        descriptionLabel = "A \"D\" cylinder with \(tankPSI) PSI at a total LPM of \(correctedFlow ) L/min"

        // If its empty then let us know.
        if (resultsLabel < "0.0") {

            minutesLabel = "Refill the tank"
            resultsLabel = "Empty Tank"
            descriptionLabel = "Looks like the tank is"
            #if DEBUG
            print("Tank D was selected")
            #endif

        }
    }

    func calculateVent_E() -> Void {
        let psi = Double(tankPSITextField)
        
        let TV = Double(tidalVolumeTexField)
        
        let fio2 = Double(fiTexField)
        
        let rr = Double(respRateTexField)
        
        
        if tankPSITextField.isEmpty || fiTexField.isEmpty || tidalVolumeTexField.isEmpty || respRateTexField.isEmpty {
            isHidden = false
            showingPopup = true
            isClear = true
            #if DEBUG
            print("RR not entered")
            #endif
            return
        }

        let E: Double = ((psi! - 200) * 0.28 )
       
        
        // calcualte the minite vlm
        let MV = (rr! * TV!) / 1000
        #if DEBUG
        print("MV calculated  is \(MV)")
        #endif

        let o2Draw = (((fio2!/100) - 0.21) * 1.265) * 100

        let correctedFlow = ((MV + (Double(biasFlow))))

        // We get the total LPM off the bias flow and corrected fi02
        let totalLPM_O2_Draw = (correctedFlow * o2Draw) / 100

        let finalCalculation = ((E / totalLPM_O2_Draw))

        #if DEBUG
        print("corrected flow is \(correctedFlow)")
        print("\(E) divided by \(totalLPM_O2_Draw) is \(finalCalculation) final")
        #endif
        
        
        let DVent: Double = finalCalculation
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(DVent))
              
        
        isHidden = true
        
        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        
        minutesLabel = "Hr:Min"
        
        descriptionLabel = "An \"E\" cylinder with \(psi!) PSI at a total LPM of \(correctedFlow ) L/min"
                
        // If its empty then let us know.
        if (resultsLabel < "0.0") {
            
            minutesLabel = "Refill the tank"
            resultsLabel = "Empty Tank"
            descriptionLabel = "Looks like the tank is"
            
        }
        
    }
    
    func calculateVent_G() -> Void {
        let psi = Double(tankPSITextField)
        
        _ = Double(respRateTexField)
        
        let TV = Double(tidalVolumeTexField)
        
        let fio2 = Double(fiTexField)
        
        let rr = Double(respRateTexField)
        
        
        if tankPSITextField.isEmpty || fiTexField.isEmpty || tidalVolumeTexField.isEmpty || respRateTexField.isEmpty {
            isHidden = false
            showingPopup = true
            isClear = true
            #if DEBUG
            print("RR not entered")
            #endif
            return
        }

        // Formula
        let G: Double = ((psi! - 200) * 2.41 )
        
        
        
        // calcualte the minite vlm
        let MV = (rr! * TV!) / 1000
        #if DEBUG
        print("MV calculated  is \(MV)")
        #endif

        let o2Draw = (((fio2!/100) - 0.21) * 1.265) * 100

        let correctedFlow = ((MV + (Double(biasFlow))))

        // We get the total LPM off the bias flow and corrected fi02
        let totalLPM_O2_Draw = (correctedFlow * o2Draw) / 100

        let finalCalculation = ((G / totalLPM_O2_Draw))

        
        let DVent: Double = finalCalculation
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(DVent))
        
        // Unhide the view
        isHidden = true
        
        // Display Result
        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Min label
        minutesLabel = "Hr:Min"
        
        //Set description
        descriptionLabel = "An \"E\" cylinder with \(psi!) PSI at a total LPM of \(correctedFlow ) L/min"
                       
        // If its empty then let us know.
        if (resultsLabel < "0.0") {
            
            minutesLabel = "Refill the tank"
            resultsLabel = "Empty Tank"
            descriptionLabel = "Looks like the tank is"
                        
        }
        
        // Print some data
        #if DEBUG
        print("corrected flow is \(correctedFlow)")
        print("\(G) divided by \(totalLPM_O2_Draw) is \(finalCalculation) final")
        #endif

    }

    func calculateVent_M() -> Void {
        let psi = Double(tankPSITextField)
        
        _ = Double(respRateTexField)
        
        let TV = Double(tidalVolumeTexField)
        
        let fio2 = Double(fiTexField)
        
        let rr = Double(respRateTexField)
        
        
        if tankPSITextField.isEmpty || fiTexField.isEmpty || tidalVolumeTexField.isEmpty || respRateTexField.isEmpty {
            isHidden = false
            showingPopup = true
            isClear = true
            #if DEBUG
            print("RR not entered")
            #endif
            return
        }



        // Formula
        let M: Double = ((psi! - 200) * 2.41 )
        
        
        
        // calcualte the minite vlm
        let MV = (rr! * TV!) / 1000
        #if DEBUG
        print("MV calculated  is \(MV)")
        #endif

        let o2Draw = (((fio2!/100) - 0.21) * 1.265) * 100

        let correctedFlow = ((MV + (Double(biasFlow))))

        // We get the total LPM off the bias flow and corrected fi02
        let totalLPM_O2_Draw = (correctedFlow * o2Draw) / 100

        let finalCalculation = ((M / totalLPM_O2_Draw))
        
        
        let DVent: Double = finalCalculation
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(DVent))
        
        // Unhide the view
        isHidden = true
     
        // Display Result
        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Min label
        minutesLabel = "Hr:Min"
        
        //Set description
        descriptionLabel = "An \"M\" cylinder with \(psi!) PSI at a total LPM of \(correctedFlow ) L/min"

        
        // If its empty then let us know.
        if (resultsLabel < "0.0") {
            
            minutesLabel = "Refill the tank"
            resultsLabel = "Empty Tank"
            descriptionLabel = "Looks like the tank is"
            
        }
        
        // Print some data
        #if DEBUG
        print("corrected flow is \(correctedFlow)")
        print("\(M) divided by \(totalLPM_O2_Draw) is \(finalCalculation) final")
        #endif

    }

    func calculateVent_HK() -> Void {
        let psi = Double(tankPSITextField)
        
        _ = Double(respRateTexField)
        
        let TV = Double(tidalVolumeTexField)
        
        let fio2 = Double(fiTexField)
        
        let rr = Double(respRateTexField)
        
        
        if tankPSITextField.isEmpty || fiTexField.isEmpty || tidalVolumeTexField.isEmpty || respRateTexField.isEmpty {
            isHidden = false
            showingPopup = true
            isClear = true
            #if DEBUG
            print("RR not entered")
            #endif
            return
        }

        // Formula
        let HK: Double = ((psi! - 200) * 2.41 )
        
        
        
        // calcualte the minite vlm
        let MV = (rr! * TV!) / 1000
        #if DEBUG
        print("MV calculated  is \(MV)")
        #endif

        let o2Draw = (((fio2!/100) - 0.21) * 1.265) * 100

        let correctedFlow = ((MV + (Double(biasFlow))))

        // We get the total LPM off the bias flow and corrected fi02
        let totalLPM_O2_Draw = (correctedFlow * o2Draw) / 100

        let finalCalculation = ((HK / totalLPM_O2_Draw))
        
        
        let DVent: Double = finalCalculation
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(DVent))
        
        // Unhide the view
        isHidden = true
   
        // Display Result
        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Min label
        minutesLabel = "Hr:Min"
        
        //Set description
        descriptionLabel = "An \"HK\" cylinder with \(psi!) PSI at a total LPM of \(correctedFlow ) L/min"
    
        
        // If its empty then let us know.
        if (resultsLabel < "0.0") {
            
            minutesLabel = "Refill the tank"
            resultsLabel = "Empty Tank"
            descriptionLabel = "Looks like the tank is"
        }
        
    }
    
    func calculateVent_EC135_1() -> Void {
        
        
        let psi = Double(tankPSITextField)
        
        _ = Double(respRateTexField)
        
        let TV = Double(tidalVolumeTexField)
        
        let fio2 = Double(fiTexField)
        
        let rr = Double(respRateTexField)
        
        
        if tankPSITextField.isEmpty || fiTexField.isEmpty || tidalVolumeTexField.isEmpty || respRateTexField.isEmpty {
            isHidden = false
            showingPopup = true
            isClear = true
            #if DEBUG
            print("RR not entered")
            #endif
            return
        }



        // Formula
        let EC135_1: Double = ((psi! - 200) * 0.96 )
        
        
        
        // calcualte the minite vlm
        let MV = (rr! * TV!) / 1000
        #if DEBUG
        print("MV calculated  is \(MV)")
        #endif

        let o2Draw = (((fio2!/100) - 0.21) * 1.265) * 100

        let correctedFlow = ((MV + (Double(biasFlow))))

        // We get the total LPM off the bias flow and corrected fi02
        let totalLPM_O2_Draw = (correctedFlow * o2Draw) / 100

        let finalCalculation = ((EC135_1 / totalLPM_O2_Draw))
        
        
        let DVent: Double = finalCalculation
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(DVent))
        
        // Unhide the view
        isHidden = true
        
        // Display Result
        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Min label
        minutesLabel = "Hr:Min"
        
        //Set description
        descriptionLabel = "An \"EC 135\", one cylinder with \(psi!) PSI at a total LPM of \(correctedFlow ) L/min"
        
  
        
        // If its empty then let us know.
        if (resultsLabel < "0.0") {
            
            minutesLabel = "Refill the tank"
            resultsLabel = "Empty Tank"
            descriptionLabel = "Looks like the tank is"
        }
    }
    
    
    func calculateVent_EC135_2() -> Void {
        let psi = Double(tankPSITextField)
        
        _ = Double(respRateTexField)
        
        let TV = Double(tidalVolumeTexField)
        
        let fio2 = Double(fiTexField)
        
        let rr = Double(respRateTexField)
        
        if tankPSITextField.isEmpty || fiTexField.isEmpty || tidalVolumeTexField.isEmpty || respRateTexField.isEmpty {
            isHidden = false
            showingPopup = true
            isClear = true
            #if DEBUG
            print("RR not entered")
            #endif
            return
        }

        // Formula
        let EC135_2: Double = ((psi! - 400) * 1.93 )
        
        
        // calcualte the minite vlm
        let MV = (rr! * TV!) / 1000
        #if DEBUG
        print("MV calculated  is \(MV)")
        #endif

        let o2Draw = (((fio2!/100) - 0.21) * 1.265) * 100

        let correctedFlow = ((MV + (Double(biasFlow))))

        // We get the total LPM off the bias flow and corrected fi02
        let totalLPM_O2_Draw = (correctedFlow * o2Draw) / 100

        let finalCalculation = ((EC135_2 / totalLPM_O2_Draw))
        
        
        let DVent: Double = finalCalculation
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(DVent))
        
        // Unhide the view
        isHidden = true
        
        usablePsi = "Usable PSI: \(Int(psi! - 400))"
      
        
        // Display Result
        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Min label
        minutesLabel = "Hr:Min"
        
        //Set description
        descriptionLabel = "An \"EC 135\", two cylinder with \(psi!) PSI at a total LPM of \(correctedFlow ) L/min"
        

        
        // If its empty then let us know.
        if (resultsLabel < "0.0") {
            
            minutesLabel = "Refill the tank"
            resultsLabel = "Empty Tank"
            descriptionLabel = "Looks like the tank is"
        }
        
        
        
    }
    
    func calculateVent_bell() -> Void {
        let psi = Double(tankPSITextField)
        
        _ = Double(respRateTexField)
        
        let TV = Double(tidalVolumeTexField)
        
        let fio2 = Double(fiTexField)
        
        let rr = Double(respRateTexField)
        
        if tankPSITextField.isEmpty || fiTexField.isEmpty || tidalVolumeTexField.isEmpty || respRateTexField.isEmpty {
            isHidden = false
            showingPopup = true
            isClear = true
            #if DEBUG
            print("RR not entered")
            #endif
            return
        }


        // Formula
        let bell407: Double = ((psi! - 400) * 1.45 )
        
        
        
        // calcualte the minite vlm
        let MV = (rr! * TV!) / 1000
        #if DEBUG
        print("MV calculated  is \(MV)")
        #endif

        let o2Draw = (((fio2!/100) - 0.21) * 1.265) * 100

        let correctedFlow = ((MV + (Double(biasFlow))))

        // We get the total LPM off the bias flow and corrected fi02
        let totalLPM_O2_Draw = (correctedFlow * o2Draw) / 100

        let finalCalculation = ((bell407 / totalLPM_O2_Draw))
        
        
        let DVent: Double = finalCalculation
        
        // Convert the calculation to hours and minutes
        let timeLeftOver = minutesToHours(minutes: Int(DVent))
        
        // Unhide the view
        isHidden = true
        // Display Result
        resultsLabel = "\(timeLeftOver.hours):\(timeLeftOver.leftMinites)"
        
        // Min label
        minutesLabel = "Hr:Min"
        
        //Set description
        descriptionLabel = "A \"Bell 407\", tank with \(psi!) PSI at a total LPM of \(correctedFlow ) L/min"

        
        // If its empty then let us know.
        if (resultsLabel < "0.0") {
            
            minutesLabel = "Refill the tank"
            resultsLabel = "Empty Tank"
            descriptionLabel = "Looks like the tank is"
        }
        
        
    }
    
    func minutesToHours(minutes: Int) -> (hours: Int, leftMinites: Int) {
        return (minutes / 60 , (minutes % 60))
    }
}
