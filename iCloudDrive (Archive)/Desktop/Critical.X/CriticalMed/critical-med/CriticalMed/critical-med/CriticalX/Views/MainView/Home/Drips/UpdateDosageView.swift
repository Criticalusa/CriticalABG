//
//  UpdateDosageView.swift
//  CriticalX
//
//  Created by Macbook 4 on 16/12/2021.
//

import SwiftUI
import CoreMedia

struct UpdateDosageView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var titleTextField = ""
    @State private var totalDoseTextField = ""
    @State private var ivBagTextField = ""
    @State private var minDoseTextField = ""
    @State private var maxDoseTextField = ""
    @State private var startingTextField = ""
    @State private var unitTextField = ""
    @State private var arrowSelection = false
    @State private var isHidden = true
    @State private var showDropDown = false
//    var dripsDetail: Any
//    @State var Drip : NSMutableDictionary!
    @ObservedObject var dripsModel: DripValue

    @State var Dripslist : [Any]!
    var dropDownList = ["mcg/min", "mg/min", "mcg/hr","mg/hr", "g/hr", "units/hr", "units/min", "mUnits/min", "mcg/kg/min", "mcg/kg/hr", "mg/kg/hr", "units/kg/hr"]
    var body: some View {
        
        ZStack{
            Color.mainBackgroundColor.edgesIgnoringSafeArea(.all)
            
            
            ScrollView( .vertical, showsIndicators: false) {
                
                
                VStack(alignment: .leading) {
                    
                    HStack{
                        Spacer()
                        Text(titleTextField)
                            .font(.system(size: 22).bold())
                            .foregroundColor(Color.midnightBlue)
                        Spacer()
                    }                     
                    
                    VStack(spacing: 0){
                        Group{
                            HStack{
                                
                                Text("Total Dose")
                                    .font(.system(size: 18).bold())
                                    .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                    .padding(.leading, 20)
                                
                                Spacer()
                                Text("MG")
                                    .font(.SFProRegular(ofSize: 14))
                                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                                    .padding(.top, 5)
                                
                                TextField("", text: $totalDoseTextField)
                                // MARK: Placeholder for textField
                                    .placeholder(when: totalDoseTextField.isEmpty) {
                                            Text("80").foregroundColor(.gray)
                                            .opacity(0.3)
                                    }
                                    .frame(width: 70)
                                    .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                                    .font(.SFProRoundedSemibold(ofSize: 22).bold())
                                    .padding(.trailing, 10)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            
                            
                            Rectangle()
                                .fill(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                .frame(width: 16, height: 40)
                            
                            HStack{
                                
                                Text("IV Bag")
                                    .font(.system(size: 18).bold())
                                    .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                    .padding(.leading, 20)
                                
                                Spacer()
                                Text("mL")
                                    .font(.SFProRegular(ofSize: 14))
                                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                                    .padding(.top, 5)
                                
                                TextField("", text: $ivBagTextField)
                                // MARK: Placeholder for textField
                                    .placeholder(when: ivBagTextField.isEmpty) {
                                            Text("80").foregroundColor(.gray)
                                            .opacity(0.3)
                                    }
                                    .frame(width: 70)
                                    .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                                    .font(.SFProRoundedSemibold(ofSize: 24).bold())
                                    .padding(.trailing, 10)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            
                            
                            Rectangle()
                                .fill(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                .frame(width: 16, height: 40)
                            
                            HStack{
                                
                                Text("Minimum Dosage")
                                    .font(.system(size: 18).bold())
                                    .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                    .padding(.leading, 20)
                                
                                Spacer()
                                Text(unitTextField)
                                    .font(.SFProRegular(ofSize: 14))
                                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                                    .padding(.top, 5)
                                
                                TextField("", text: $minDoseTextField)
                                // MARK: Placeholder for textField
                                    .placeholder(when: minDoseTextField.isEmpty) {
                                            Text("80").foregroundColor(.gray)
                                            .opacity(0.3)
                                    }
                                    .frame(width: 60)
                                    .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                                    .font(.SFProRoundedSemibold(ofSize: 22).bold())
                                    .padding(.trailing, 10)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            
                            
                            Rectangle()
                                .fill(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                .frame(width: 16, height: 40)
                            
                            HStack{
                                
                                Text("Maximum Dosage")
                                    .font(.system(size: 18).bold())
                                    .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                    .padding(.leading, 20)
                                
                                Spacer()
                                Text(unitTextField)
                                    .font(.SFProRegular(ofSize: 14))
                                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                                    .padding(.top, 5)
                                
                                TextField("", text: $maxDoseTextField)
                                // MARK: Placeholder for textField
                                    .placeholder(when: maxDoseTextField.isEmpty) {
                                            Text("80").foregroundColor(.gray)
                                            .opacity(0.3)
                                    }
                                    .frame(width: 70)
                                    .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                                    .font(.SFProRoundedSemibold(ofSize: 22).bold())
                                    .padding(.trailing, 10)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            
                            
                            Rectangle()
                                .fill(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                .frame(width: 16, height: 40)
                        } // Group 1
                        
                        Group{
                            HStack{
                                
                                Text("Starting dose")
                                    .font(.system(size: 18).bold())
                                    .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                    .padding(.leading, 20)
                                
                                Spacer()
                                Text(unitTextField)
                                    .font(.SFProRegular(ofSize: 14))
                                    .foregroundColor(Color(UIColor.component(red: 146, green: 147, blue: 149, opacity: 1)))
                                    .padding(.top, 5)
                                
                                TextField("", text: $startingTextField)
                                // MARK: Placeholder for textField
                                    .placeholder(when: startingTextField.isEmpty) {
                                            Text("80").foregroundColor(.gray)
                                            .opacity(0.3)
                                    }
                                    .frame(width: 70)
                                    .foregroundColor(Color(UIColor.component(red: 204, green: 91, blue: 87, opacity: 1)))
                                    .font(.SFProRoundedSemibold(ofSize: 24).bold())
                                    .padding(.trailing, 10)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            
                            
                            Rectangle()
                                .fill(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                .frame(width: 16, height: 40)
                            
                            HStack{
                                
                                Text("Units")
                                    .font(.system(size: 18).bold())
                                    .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                    .padding(.leading, 20)
                                
                                Spacer()
                                Text(unitTextField)
                                    .font(.SFProRoundedSemibold(ofSize: 20).bold())
                                    .foregroundColor(Color.red)
                                    .padding(.trailing, 24)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 60)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            
                            
                            Rectangle()
                                .fill(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                .frame(width: 16, height: 40)
                            
                            ZStack{
                                
                                Button(action: {
                                    arrowSelection.toggle()
                                    isHidden.toggle()
                                    showDropDown.toggle()
                                }) {
                                    HStack{
                                        Spacer()
                                        Text("Units")
                                            .font(.system(size: 18).bold())
                                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                            .padding(.leading, 20)
                                        Spacer()
                                        Image(systemName: self.arrowSelection ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                                            .resizable()
                                            .frame(width: 9, height: 5)
                                            .font(Font.system(size: 9, weight: .medium))
                                            .foregroundColor(Color.black)
                                            .padding(.top, 2)
                                    }
                                }
                                .padding(.trailing, 10)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.8, height: 38)
                            .background(Color.white)
                            .cornerRadius(8)
                            .border(Color(UIColor.component(red: 214, green: 228, blue: 236, opacity: 1)), width: 0.68)
                            .shadow(color: Color(UIColor.component(red: 117, green: 131, blue: 142, opacity: 0.04)), radius: 2, x: 0, y: 2.71)
                            .shadow(color: Color(UIColor.component(red: 52, green: 60, blue: 68, opacity: 0.16)), radius: 2, x: 0, y: 2.71)
                            
                            
                            if showDropDown {
                                    VStack {
                                        ScrollView(.vertical, showsIndicators: true) {
                                        ForEach(0..<dropDownList.count) { item in
                                            VStack{
                                                Text(dropDownList[item])
                                                    .font(.SFProRoundedSemibold(ofSize: 18).bold())
                                                    .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                                                    .padding(.all)
                                                
                                                Rectangle()
                                                    .fill(Color(UIColor.component(red: 216, green: 228, blue: 236, opacity: 1)))
                                                    .frame(height: 1)
                                            }.onTapGesture {
                                                unitTextField = dropDownList[item]
                                                isHidden.toggle()
                                                showDropDown.toggle()
                                            }
                                        }
                                    }
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(color: Color(UIColor.component(red: 52, green: 60, blue: 68, opacity: 0.16)), radius: 5.43, x: 0, y: 2.71)
                                    .shadow(color: Color(UIColor.component(red: 117, green: 131, blue: 142, opacity: 0.04)), radius: 1.36, x: 0, y: 0)
                                    .opacity(isHidden ? 0 : 1)
                                    .padding(.top, 15)
                            }
                            Button(action: {
                                save()
                            }) {
                                HStack{
                                    Text("SAVE")
                                        .foregroundColor(Color.white)
                                        .font(.SFProRoundedSemibold(ofSize: 18))
                                        .frame(width: UIScreen.main.bounds.width * 0.65, height: 50)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.65, height: 50)
                            .background(Color(UIColor.component(red: 208, green: 65, blue: 65, opacity: 1)))
                            .cornerRadius(6)
                            .padding(.top, 20)
                        } // group 2
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .padding(.top, 15)
                .padding(.bottom, 30)
                
            }
        }.onAppear {
           
            unitTextField = dripsModel.value.unit
            totalDoseTextField = dripsModel.value.totalDose
            ivBagTextField = dripsModel.value.bagVolume
            minDoseTextField = dripsModel.value.minDose
            maxDoseTextField = dripsModel.value.maxDose
            startingTextField = dripsModel.value.dose
            titleTextField = dripsModel.value.title

        }
         
    }
}

struct UpdateDosageView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateDosageView(dripsModel: DripValue())
    }
}

extension UpdateDosageView {
    
    func save(){
               
        
        Dripslist = UserDefaults.standard.object(forKey:"drip_list") as? [Any]
        
        var dripList = Dripslist!
        
//        if ndripslist == nil {
//            return
//        }
        
//        Dripslist = (ndripslist!.mutableCopy() as! NSMutableArray)
                
        for (index,item) in dripList.enumerated() {
            if ((item as AnyObject).object(forKey: "maintitle") as! String) == dripsModel.value.title {
                
                var Drip : [String : Any] = [String : Any]()
                
                Drip["totaldose"] = totalDoseTextField
                Drip["bag"] = ivBagTextField
                Drip["min"] = minDoseTextField
                Drip["max"] = maxDoseTextField
                Drip["dose"] = startingTextField
                Drip["unit"] = unitTextField
                Drip["maintitle"] = dripsModel.value.title
                Drip["BrandName"] = dripsModel.value.brandName
                Drip["WhatToKnow"] = dripsModel.value.criticalInfo
                Drip["Indications"] = dripsModel.value.indications
                Drip["increment"] = dripsModel.value.increment
                Drip["DrugClass"] = dripsModel.value.drugClass

//                Drip.setValue(totalDoseTextField, forKey: "totaldose")
//                Drip.setValue(ivBagTextField, forKey: "bag")
//                Drip.setValue(minDoseTextField, forKey: "min")
//                Drip.setValue(maxDoseTextField, forKey: "max")
//                Drip.setValue(startingTextField, forKey: "dose")
//                Drip.setValue(unitTextField, forKey: "unit")
//                Drip.setValue(dripsModel.maintitle, forKey: "maintitle")
//                Drip.setValue(dripsModel.brandName, forKey: "BrandName")
//                Drip.setValue(dripsModel.whatToKnow, forKey: "WhatToKnow")
//                Drip.setValue(dripsModel.indications, forKey: "Indications")
//                Drip.setValue(dripsModel.increment, forKey: "increment")
//                Drip.setValue(dripsModel.drugClass, forKey: "DrugClass")
                

                
//                dripList![index] = dripsModel
                
                dripList[index] = Drip
                
                
                break
            }
        }
        
        UserDefaults.standard.set(dripList, forKey: "drip_list")
        UserDefaults.standard.synchronize()
        
        self.mode.wrappedValue.dismiss()
    }
}
