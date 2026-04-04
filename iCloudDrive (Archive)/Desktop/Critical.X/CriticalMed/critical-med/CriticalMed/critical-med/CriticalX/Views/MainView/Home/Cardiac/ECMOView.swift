//
//  ECMOView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 2/22/24.
//

import SwiftUI

struct ECMOView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var  isPresentedECMO = false
    
    var body: some View {
        
        
    
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(alignment: .bottom, spacing: 20){
                    //Create a blank text space to push the button to the right
                    Text("Everything ECMO")
                        .font(.largeTitle)
                        .padding(.leading, 40)
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("X").bold()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.white)
                            .background(Color.vitalRed)
                            .clipShape(Circle())
                            
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                List {
                    VStack{
                        Image("ECMOPump")
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 30)
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 350)
                    }
                
                    Section(header: Text("Extracorporeal Membrane Oxygenation (ECMO)").bold().foregroundColor(.black_Chocolate)) {
                        
                        Text("ECMO serves as a form of extracorporeal life support where blood is pumped outside of the body to a heart-lung machine that oxygenates the blood and removes carbon dioxide, essentially taking over the function of the heart and lungs. This allows the patient's heart and lungs to rest and heal during critical illness.")
                    }
                    Section(header: Text("Indications for ECMO").bold().foregroundColor(.black_Chocolate)) {
                        Text("ECMO is indicated for life-threatening cardiac or pulmonary dysfunction that is potentially reversible but unresponsive to standard treatment. We'll dissect the conditions more below, but overall, conditions that may require ECMO include severe respiratory distress syndrome (ARDS), cardiogenic shock, refractory cardiac arrest, severe pneumonia (including COVID-19 related pneumonia), and as a bridge to lung or heart transplant.")
                    }
                    Section(header: Text(" 🔑 Key Terms to Know").bold().foregroundColor(.black_Chocolate)) {
                        HStack {
                            Image(systemName: "1.square.fill")
                            Text("RPM: ").bold().foregroundColor(.red) +
                            Text("Pumping speed of the ECMO circuit directly impacts the blood flow rates in VA ECMO as well as CO/CI and MAP.")
                        }
                        
                        HStack {
                            Image(systemName: "2.square.fill").foregroundColor(.blue)
                            Text("Sweep ( Gas Flow: )").bold().foregroundColor(.red) +
                            Text("Setting that controls how much C02 is removed from the blood.") +
                            Text("To Decrease C02: Increase the sweep.To Increase C02; Decrease the sweep.").bold()
                        }
                        
                        HStack {
                            Image(systemName: "3.square.fill").foregroundColor(.green)
                            Text("Oxygenation: ").bold().foregroundColor(.red) +
                            Text("Determined by the FD02 (Fraction Delivered 02) and blood flow rates.")
                        }
                        
                        HStack {
                            Image(systemName: "4.square.fill").foregroundColor(.purple)
                            Text("Ventilation").bold().foregroundColor(.red) +
                            Text("This is determined by the PC02 ( sweep/gas flow) and pH levels.")
                        }
                    }
                    
                
                    
                    Section(header: Text("Two primary forms of ECMO:").bold().foregroundColor(.black_Chocolate)) {
                        //VA ECMO Image
                        Image("VA-ECMO")
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 30)
                            .onTapGesture {
                                isPresentedECMO = true
                            }.fullScreenCover(isPresented: $isPresentedECMO, content: {
                                PhotoView(image:"VA-ECMO")
                            })
                       
                        Text("Veno-Arterial (VA) ECMO: ").bold() +
                        Text("This type provides respiratory and hemodynamic support to both the heart and lungs. It is used in cases of cardiac failure, cardiac arrest, cardiogenic shock, PE, post-transplant graft failure where the heart is unable to pump blood effectively. Blood is withdrawn from a vein (i.e. femoral vein) and returned to an artery (i.e.femoral artery), bypassing the heart and lungs.")
                        
                        //VA ECMO Image
                        Image("VV-ECMO")
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 30)
                            .onTapGesture {
                                isPresentedECMO = true
                            }.fullScreenCover(isPresented: $isPresentedECMO, content: {
                                PhotoView(image:"VA-ECMO")
                            })
                        Text("Veno-Venous (VV) ECMO: ").bold() +
                        Text("This form is used for patients whose heart function is typically adequate but whose lungs are failing, providing respiratory support only. VV-ECMO is typically used in those with PNA, ARDS, aspiration, drownings, lung trauma, post-lung transplant. Blood is withdrawn from a vein and returned to a vein.")
                    }
                    
                    
                    Section(header: Text("Key Circuit Pressures").bold().foregroundColor(.black_Chocolate)){
                        Text("1. Drainage Pressure (PVein or Venous Pressure):").bold().foregroundColor(.red) +
                        Text("This measures the pressure in the admission cannula and is a negative pressure. Simply put this is a negative suction thats pulling blood into the circuit. It should not exceed -100 mmHg. A significant rise in venous pressure indicates difficulty in draining blood from the patient, which could be due to hypovolemia , excess blood flow for the cannula size, kinks or clots on the drainage side of the circuit, external pressures around the drainage vessel(tamponade, PT, intrathoracic pressure). ")
                      
                        
                        Text("2. The \"P-Internal\" or \"PPre Oxygenator Membrane pressure: ").bold().foregroundColor(.red) +
                        Text("specifically refers to the pressure before the membrane (pre-membrane), which is critical for ensuring that the ECMO circuit is functioning properly and that there is no obstruction or excessive resistance that could impede blood flow or damage the blood due to high pressure. Monitoring this pressure helps in identifying issues such as clot formation in the oxygenator, which can increase resistance and pressure, indicating a need for intervention. Simply put, this is a positive pressure pushing the blood through the oxygenator.")
                        
                        
                        Text("3. Δp (Pressure Difference through the Oxygenator or Transmembrane Pressure): ").bold().foregroundColor(.red) +
                        
                        
                        Text("PPOST-PPRE = TMP. This is the pressure difference across the oxygenator and changes during the ECMO run. It is an indicator of the level of saturation of the membrane of the oxygenator. Any significant rise in Δp (e.g., +20 mmHg/h) must be reported immediately as it can be a sign of clotting inside the oxygenator.")
                        
                        
                        Text("4. Post-oxygenator Return Pressure (Arterial Pressure): ").bold().foregroundColor(.red) +
                        Text("This measures the pressure in the reinfusion cannula and is a positive pressure. It should normally exceed 200-250 mmHg. A quick and significant rise in pressure may be caused by an increase in the patient’s preload or a sign of a kinked cannula. Extreme positive pressures can cause hemolysis, circuit disruption, jetting of blood, and the \"fireman's hose\" effect. ")
                        
                        //VA ECMO Image
                        Image("ECMOMembrane")
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 30)
                            .onTapGesture {
                                isPresentedECMO = true
                            }.fullScreenCover(isPresented: $isPresentedECMO, content: {
                                PhotoView(image:"ECMOMembrane")
                            })
                    }
                    
                    Section(header: Text("Risks and Complications").bold()
                        .foregroundColor(.red)) {
                        Text("Despite its potential to save lives, ECMO is associated with significant risks and complications, including:")
                        Text("Bleeding: ").bold().foregroundColor(.red) +
                        Text("Due to the need for anticoagulation to prevent clot formation in the ECMO circuit.")
                        Text("Infection: ").bold().foregroundColor(.red) +
                        Text("Given the invasive nature of the procedure and the potential for microbial colonization of catheters and the oxygenator.")
                        Text("Neurological complications: ").bold().foregroundColor(.red) +
                        Text("Such as strokes or seizures, possibly due to clots or bleeding.")
                        Text("Organ failure: ").bold().foregroundColor(.red) +
                        Text("Prolonged use of ECMO can lead to multi-organ dysfunction.")
                        Text("Limb ischemia: ").bold().foregroundColor(.red) +
                        Text("Poor blood flow to the limb where the cannula is inserted, potentially requiring surgical intervention.")
                    }
                    
                    
                    
                    Section(header: Text("ECMO Team and Management").bold().foregroundColor(.black_Chocolate)) {
                        Text("The management of an ECMO patient requires a multidisciplinary team including cardiothoracic surgeons for cannula insertion, critical care physicians, ECMO specialists (which may include specially trained nurses, respiratory therapists, or perfusionists), and other healthcare professionals. This team is responsible for the continuous monitoring and adjustment of ECMO settings, management of anticoagulation, and addressing any complications that arise.")
                    }
                    
                    Section(header: Text("Wrapping it up.").bold().foregroundColor(.green)) {
                        Text("ECMO is a complex, high-risk procedure that can offer a lifeline to patients with severe heart and lung failure when other treatments have failed. Its successful application depends on careful patient selection, meticulous management by a specialized multidisciplinary team, and prompt recognition and treatment of associated complications.")
                    }
                    Section(header: Text("⭐️ Critical Summary: ECMO monitoring demands consistent management.").foregroundColor(.blue).bold())  {
                                   Text("Patient vital signs, physical state, and neurological function are monitored.")
                                   Text("The position, power supply, fluid connectors, and cannulas of the ECMO device must be monitored.")
                                   Text("Record pump circulation parameters including flow rate and gas blender settings.")
                                   Text("ECMO dysfunctions can be detected by monitoring venous, arterial, and oxygenator pressures.")
                                   Text("ECMO patients' pain and sedation treatment should be changed due to medication pharmacokinetics and pharmacodynamics.")
                                   Text("Daily cannula dressing and insertion point checks are essential for infection control.")
                                   Text("Pressure sores can be prevented with proper skin care and cannula-protective coverings.")
                               }
                               
                    Section(header: Text("Monitoring and controlling problems.").foregroundColor(.blue).bold() ) {
                                   Text("Blood loss is common, so hemostasis must be maintained.")
                                   Text("Blood can appear in the ENT, dressings, neurological state, lung secretions, urine, and digestive tract.")
                                   Text("Preventing clots and thrombosis requires effective anticoagulation.")
                                   Text("Hemolysis from blood cell injuries can be treated symptomatically or by altering the ECMO circuit.")
                                   Text("Although rare, decannulation is a feared complication that can be averted by following stringent protocols.")
                               }
                               
                    Section(header: Text("Considerations for different ECMO modes." ).foregroundColor(.blue)) {
                                   Text("VA ECMO patients need hemodynamic monitoring and limb ischemia prevention.")
                                   Text("Monitoring peripheral VA ECMO patients entails treating ischemia with axillary cannulation and differential hypoxia.")
                                   Text("VA ECMO patients must balance hypovolemia and fluid overload, making fluid management difficult.")
                                   Text("Recirculation with VV ECMO reduces organ oxygenation. Many variables can trigger it, so watch out.")
                                   Text("VAV ECMO combines VA and VV ECMO and requires careful flow control based on lung or cardiac recovery.")
                                   Text("Stabilizing ECMO flow can prevent clots and hemodynamic abnormalities.")
                                   Text("To avoid difficulties during decannulation, clamp the lines, ask for help, and compress the insertion location.")
                                   Text("Installing backup pumps or treating clotting disorders is necessary in life-threatening pump and oxygenator failures.")
                                   Text("When an ECMO oxygenator fails, the circuit or the oxygenator can be replaced.")
                               }
                               
                               Section(header: Text("ECMO as a last-resort therapy.").foregroundColor(.logoBlue))  {
                                   Text("ECMO is a last-resort therapy with dangers, thus patients and family need psychological support.")
                                   Text("To keep everyone informed about the patient's medical status and reduce staff stress, effective communication and regular meetings are essential.")
                                   Text("ECMO therapies like bridge to recovery, bridge to bridge, bridge to transplant, and destination therapy have various aims and should be conveyed to patients and families.")
                                   Text("Refer to ECMO studies and papers for further reading and study.")
                               }
                }.navigationTitle("ECMO")
                // This is the only difference.
                .listStyle(.insetGrouped)
            .padding()
            }
            
        }
        
    }
    
    //        ScrollView{
    //            VStack(spacing: 0){
    //                HStack{
    //                    Text("")
    //
    //                    Spacer()
    //
    //                    Button(action: {
    //                        presentationMode.wrappedValue.dismiss()
    //                    }) {
    //                        Text("X").bold()
    //                            .frame(width: 30, height: 30)
    //                            .foregroundColor(Color.white)
    //                            .background(Color.vitalRed)
    //                            .clipShape(Circle())
    //                    }
    //                    .padding(.top, 20)
    //                    .padding(.trailing, 20)
    //                }
    //                //                Text("ECMO")
    //                //                    .foregroundColor(Color.black_Chocolate)
    //                //                    .frame(width: UIScreen.main.bounds.width * 0.9)
    //                //                    .customTitleFont()
    //                //                Text("Extracorporeal Membrane Oxygenation")
    //                //                    .foregroundColor(Color.orange_TerraCotta)
    //
    //
    //                Image("ECMOPump")
    //                    .resizable()
    //                    .scaledToFit()
    //                    .padding(.all, 30)
    //
    //                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 350)
    //
    //                    .padding(.leading,15)
    //                    .onTapGesture {
    //                        isPresentedECMO = true
    //                    }.fullScreenCover(isPresented: $isPresentedECMO, content: {
    //                        PhotoView(image:"ECMOPump")
    //                    })
    //
    //                    VStack (alignment: .leading, spacing: 15) {
    //
    //                        Text("What is ECMO")
    //                            .font(.headline)
    //                            .foregroundColor(.vitalRed)
    //                            .padding(.bottom, 10)
    //                            .padding(.horizontal)
    //                        Text("When traditional treatment strategies are unsuccessful for patients with severe heart and lung failure, extracorporeal membrane oxygenation (ECMO) is a life-saving procedure utilized in critical care settings. With (ECMO), the heart and lungs are basically replaced by a heart-lung system that pumps blood outside the body, eliminates carbon dioxide, and re-oxygenates the blood. This allows the patient's heart and lungs to rest and heal during critical illness.")
    //                            .font(.body)
    //                            .padding(.horizontal)
    //                            .padding(.trailing, 15)
    //                            .padding(.bottom, 25)
    //
    //                        Text("Extracorporeal Membrane Oxygenation (ECMO)").bold() +
    //                        Text(" is a life-saving procedure used in critical care settings for patients with severe heart and lung dysfunction that is unresponsive to conventional management techniques. ECMO serves as a form of extracorporeal life support where blood is pumped outside of the body to a heart-lung machine that oxygenates the blood and removes carbon dioxide, essentially taking over the function of the heart and lungs. This allows the patient's heart and lungs to rest and heal during critical illness.")
    //                            .font(.body)
    //
    //
    //                        Text("Types of ECMO").bold()
    //                            .bold()
    //                            .font(.body)
    //                            .padding(.horizontal)
    //                            .padding(.trailing, 15)
    //                            .padding(.bottom, 25)
    //                        Text("There are two primary forms of ECMO:")
    //                            .bold()
    //                            .font(.body)
    //                            .padding(.horizontal)
    //                            .padding(.trailing, 15)
    //                            .padding(.bottom, 25)
    //
    //                        Text("1. Veno-Arterial (VA) ECMO:").bold() +
    //                        Text("This type provides support to both the heart and lungs. It is used in cases of cardiac failure or cardiac arrest where the heart is unable to pump blood effectively. Blood is withdrawn from a vein and returned to an artery, bypassing the heart and lungs.")
    //
    //
    //
    //                        //VA ECMO Image
    //                        Image("VA-ECMO")
    //                            .resizable()
    //                            .scaledToFit()
    //                            .padding(.all, 30)
    //                            .onTapGesture {
    //                                isPresentedECMO = true
    //                            }.fullScreenCover(isPresented: $isPresentedECMO, content: {
    //                                PhotoView(image:"VA-ECMO")
    //                            })
    //
    //                        Text("2. Veno-Venous (VV) ECMO: This form is used for patients whose heart function is adequate but whose lungs are failing, providing respiratory support only. Blood is withdrawn from a vein and returned to a vein.")
    //                            .bold()
    //                            .font(.body)
    //                            .padding(.horizontal)
    //                            .padding(.trailing, 15)
    //                            .padding(.bottom, 25)
    //                        // VV ECMO Image
    //                        Image("VV-ECMO")
    //                            .resizable()
    //                            .scaledToFit()
    //                            .padding(.all, 30)
    //                            .onTapGesture {
    //                                isPresentedECMO = true
    //                            }.fullScreenCover(isPresented: $isPresentedECMO, content: {
    //                                PhotoView(image:"VV-ECMO")
    //                            })
    //
    //
    //                        Text("Indications for ECMO")
    //                            .bold()
    //                        Text("ECMO is indicated for life-threatening cardiac or pulmonary dysfunction that is potentially reversible but unresponsive to standard treatment. Conditions that may require ECMO include severe respiratory distress syndrome (ARDS), cardiogenic shock, refractory cardiac arrest, severe pneumonia (including COVID-19 related pneumonia), and as a bridge to lung or heart transplant.")
    //                            .font(.body)
    //                            .padding(.horizontal)
    //                            .padding(.trailing, 15)
    //                            .padding(.bottom, 25)
    //
    //
    //                        Text("Risks and Complications")
    //                            .bold()
    //                        Text("Despite its potential to save lives, ECMO is associated with significant risks and complications, including:")
    //                            .font(.body)
    //                            .padding(.horizontal)
    //                            .padding(.trailing, 15)
    //                            .padding(.bottom, 25)
    //
    //
    //                        Text("Bleeding: Due to the need for anticoagulation to prevent clot formation in the ECMO circuit.")
    //                            .bold()
    //                        Text("- **Infection**: Given the invasive nature of the procedure and the potential for microbial colonization of catheters and the oxygenator.")
    //                            .font(.body)
    //                            .padding(.horizontal)
    //                            .padding(.trailing, 15)
    //                            .padding(.bottom, 25)
    //
    //
    //                            .bold()
    //                        Text("Neurological complications**: Such as strokes or seizures, possibly due to clots or bleeding.")
    //                            .bold()
    //                            .font(.body)
    //                        Text("Organ failure**: Prolonged use of ECMO can lead to multi-organ dysfunction.")
    //                            .bold()
    //                            .padding(.horizontal)
    //                        Text("-Limb ischemia**: Poor blood flow to the limb where the cannula is inserted, potentially requiring surgical intervention.")
    //                            .bold()
    //                            .padding(.trailing, 15)
    //
    //                        Text("ECMO Team and Management")
    //                            .bold()
    //                            .padding(.bottom, 25)
    //                        Text("The management of an ECMO patient requires a multidisciplinary team including cardiothoracic surgeons for cannula insertion, critical care physicians, ECMO specialists (which may include specially trained nurses, respiratory therapists, or perfusionists), and other healthcare professionals. This team is responsible for the continuous monitoring and adjustment of ECMO settings, management of anticoagulation, and addressing any complications that arise.")
    //
    //                            .font(.body)
    //                        Text("Conclusion")
    //                            .bold()
    //                            .padding(.horizontal)
    //                        Text("ECMO is a complex, high-risk procedure that can offer a lifeline to patients with severe heart and lung failure when other treatments have failed. Its successful application depends on careful patient selection, meticulous management by a specialized multidisciplinary team, and prompt recognition and treatment of associated complications.")
    //                            .padding(.trailing, 15)
    //
    //                }
    //
    //                .padding(.trailing, 15)
    //
    //                //Cardiovascular
    //                StatCardView(
    //                    imageName: "icons-heart",
    //                    title: "Cardiovascular",
    //                    stats: [
    //                        ("down", "Cardiac output"),
    //                        ("down", "Heart rate"),
    //                        ("up", "Risk of arrhythmias"),
    //                        ("up", "Vasoconstriction") ])
    //                .padding(.bottom, 20)
    //                .padding(.horizontal)
    //
    //                //Renal
    //                StatCardView(
    //                    imageName: "Kidneys",
    //                    title: "Renal & Electrolytes",
    //                    stats: [
    //                        ("up", "Urine output"),
    //                        ("up", "Electrolyte wasting, Intracellular shifts"),
    //                        ("down", "Mg+2, Phos, K+") ])
    //                .padding(.bottom, 20)
    //                .padding(.horizontal)
    //
    //                //Endocrine
    //                EcmoCardView(
    //                    imageName: "icon-pancreas",
    //                    title: "Endocrine",
    //                    stats: [
    //                        ("down", "Insulin secretion"),
    //                        ("up", "Insulin resistance"),
    //                        ("up", "Hyperglycemia") ])
    //                .padding(.bottom, 20)
    //                .padding(.horizontal)
    //
    //                //Pulm
    //                EcmoCardView(
    //                    imageName: "Lungs",
    //                    title: "Pulmonary",
    //                    stats: [
    //                        ("down", "Chemosensitivity to C02"),
    //                        ("up", "Hgb affinity to 02"),
    //                        ("up", "Anatomic dead space") ])
    //                .padding(.bottom, 20)
    //                .padding(.horizontal)
    //
    //                //Hepatic
    //                EcmoCardView(
    //                    imageName: "Liver",
    //                    title: "Hepatic",
    //                    stats: [
    //                        ("down", "Drug metabolism via CYP450 enzymes")])
    //                .padding(.bottom, 20)
    //                .padding(.horizontal)
    //
    //                //Coags
    //                EcmoCardView(
    //                    imageName: "Coags",
    //                    title: "Coagulation",
    //                    stats: [
    //                        ("down", "Platelet aggregation"),
    //                        ("down", "Fibrinolysis")])
    //                .padding(.bottom, 20)
    //                .padding(.horizontal)
    //
    //                //Hepatic
    //                EcmoCardView(
    //                    imageName: "immunology",
    //                    title: "Immune System",
    //                    stats: [
    //                        ("up", "Infections"),
    //                        ("down", "Immune function")])
    //                .padding(.bottom, 20)
    //                .padding(.horizontal)
    //
    //            }
    //        }






struct EcmoCardView: View {
    let imageName: String
    let title: String
    let stats: [(trend: String, description: String)]
    
    var body: some View {
        HStack {
            Image(imageName) // Use your actual image name here
                .resizable()
                .frame(width: 70, height: 70)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                
                ForEach(stats, id: \.description) { stat in
                    HStack {
                        Image(systemName: stat.trend == "up" ? "arrow.up" : "arrow.down")
                            .foregroundColor(stat.trend == "up" ? .green : .red) // Adjust colors if needed
                        Text(stat.description)
                    }
                }
            }
        }
    }
}

#Preview {
    ECMOView()
}
