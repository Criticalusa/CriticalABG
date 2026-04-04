import SwiftUI
//import SwiftUITrackableScrollView

/// Placeholder weight used for settings dose preview (always 1 kg)
private var settingsWeight: Double = 1.0

class PedsSettingValue: ObservableObject {

    @Published var etoMidateText: String = ""
    @Published var etoMidateMLstext: String = ""
    @Published var succinylcholineMinText: String = ""
    @Published var succinylcholineMixText: String = ""
    @Published var succinylcholineMLsText: String = ""
    @Published var vecurinium: String = ""
    @Published var vecuroniumMLs: String = ""
    @Published var rocuroniumTextMin: String = ""
    @Published var rocuroniumTextMax: String = ""
    @Published var rocuroniumTextMLs: String = ""
    @Published var ketamineText: String = ""
    @Published var ketamineTextMLs: String = ""
    @Published var ketamineRSIText: String = ""
    @Published var ketamineRSITextMLs: String = ""
    @Published var versedivText: String = ""
    @Published var versedIVTextMLs: String = ""
    @Published var versedIMText: String = ""
    @Published var versedIMMLs: String = ""
    @Published var propofolMin: String = ""
    @Published var propofolMax: String = ""
    @Published var propofolTextMLs: String = ""
    @Published var fentanylText: String = ""
    @Published var fentanyMLs: String = ""
    @Published var ativanTextMin: String = ""
    @Published var ativanTextMax: String = ""
    @Published var ativanTextMLs: String = ""
    @Published var mgSulfateInitText: String = ""
    @Published var mgSulfateFinalText: String = ""
    @Published var mgSulfateMLs: String = ""
    @Published var mgSulfateLabel: String = ""
    
    @Published var adenosineInit: String = ""
    @Published var adenosineInitMLs: String = ""
    @Published var adebisineReoeatText: String = ""
    @Published var adenosineRepeatMLsText: String = ""
    @Published var amiodaroneText: String = ""
    @Published var amiodaroneTextMLs: String = ""
    @Published var atropineText: String = ""
    @Published var atropineTextMLs: String = ""
    @Published var naHC03Text: String = ""
    @Published var naHC03TextMLs: String = ""
    @Published var naHC03_84Text: String = ""
    @Published var naHC03_84TextMLs: String = ""
    @Published var calcuMinText: String = ""
    @Published var calcuMaxText: String = ""
    @Published var calcuMLs: String = ""
    @Published var caGluconateText: String = ""
    @Published var caGluconateTextMLs: String = ""
    @Published var epiText: String = ""
    @Published var epiTextMLs: String = ""
    @Published var lidocaineText: String = ""
    @Published var lidocaineTextMLs: String = ""
    
    @Published var albuterolText: String = ""
    @Published var albuterolTextMLs: String = ""
    @Published var albuminMinText: String = ""
    @Published var albuminMaxText: String = ""
    @Published var albuminMLsText: String = ""
    @Published var albuminMLsMax: String = ""
    @Published var benadrylText: String = ""
    @Published var benadrylTextMLs: String = ""
    @Published var decadronText: String = ""
    @Published var decadronTextMLs: String = ""
    @Published var diazepamText: String = ""
    @Published var diazepamTextMLs: String = ""
    @Published var epi1and1Text: String = ""
    @Published var epi1and1TextMLs: String = ""
    @Published var fentanylINText: String = ""
    @Published var fentanylINTextMLs: String = ""
    @Published var kentamineINText: String = ""
    @Published var ketamineINMLsText: String = ""
    @Published var morphineText: String = ""
    @Published var morphineMLsText: String = ""
    @Published var mannitolText: String = ""
    @Published var mannitolTextMLs: String = ""
    @Published var fluidBolusText: String = ""
    @Published var fluidBolusTextMLs: String = ""
    @Published var glucagonText: String = ""
    @Published var glucagonTextMLs: String = ""
    @Published var solumedrolText: String = ""
    @Published var solumedrolTextMLs: String = ""
    @Published var zofranText: String = ""
    @Published var zofranTextMLs: String = ""
}

struct PedsSettingsView: View {
    
    @ObservedObject var settings: PedsSettingValue = PedsSettingValue()
    @State private var medicineParametter : NSMutableDictionary!
    @State private var medicineParametterML : NSMutableDictionary!
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var showingPopup: Bool
    @State var showingResetPopup = false

    
    @State private var scrollViewContentOffset = CGFloat(0)

    var body: some View {
        ZStack{
            CriticalDesign.Adaptive.canvas(for: colorScheme).edgesIgnoringSafeArea(.all)
            
            TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset) {
                ZStack {
                    VStack(spacing: 15){
                        SedationSettingsView(settings: settings)
                        CardiacSettingsView(settings: settings)
                        MiscMedicationsSettingsView(settings: settings)
                    
                     
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 125)
                .keyboardType(.decimalPad)
                }
//                .introspectNavigationController { nc in
//                    nc.hidesBarsOnSwipe = true
//                }
                
            }

            // MARK: ScrollView med name Pop Up
            if scrollViewContentOffset > 10 {
                VStack{

                    Spacer()
                    HStack {
                        Button(action: {
                            updateParams()
                        }) {
                            HStack{
                                Text("UPDATE PARAMETERS")
                                    .font(.custom(AssetConstants.fontSFProRoundedSemiBold, size: 20))
                                    .foregroundColor(Color.white)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                            .background(Color.red)
                        }
                        .cornerRadius(8)
                        .padding(.bottom, 10)
                    }
                        .fixedSize(horizontal: false, vertical: true)
                        //No need to set frame. It dynamically adjusts
                        //.frame(width: Text.width, height: 40)
                        .padding(.horizontal, 30)
                        //.padding(.trailing)
                        .padding(.bottom)
                        .multilineTextAlignment(.center)
                        .animation(.easeInOut(duration: 0.5), value: scrollViewContentOffset)
                }
               // .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .leading)
                .shadow(radius: 8)
//                .padding(.top, 30)
            }
        }
        .toolbar {
            Button("Reset") {
                reset()
            }.fullScreenCover(isPresented: $showingResetPopup, content: {
                ThanksPopupView(title: "Got it!", message: "Please press update below to save the default values!")
                    .background(BackgroundClearView())
            })
        }.onAppear {
            settingsWeight = 1
            setMedicineData()
            setMedicine()
        }
    } // View
} // Struct

struct PedsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PedsSettingsView(showingPopup: .constant(false))
    }
}

extension PedsSettingsView {

    
    func reset(){
        
        settings.etoMidateText = "0.3"
        settings.succinylcholineMinText = "1.0"
        settings.succinylcholineMixText = "2.0"
        settings.vecurinium = "0.1"
        settings.rocuroniumTextMin = "0.6"
        settings.rocuroniumTextMax = "1.2"
        settings.ketamineText = "0.5"
        settings.ketamineRSIText = "1.5"
        settings.versedivText = "0.1"
        settings.versedIMText = "0.2"
        settings.propofolMin = "10.0"
        settings.propofolMax = "75.0"
        settings.fentanylText = "1.0"
        settings.ativanTextMin = "0.05"
        settings.ativanTextMax = "0.1"
        settings.mgSulfateInitText = "25.0"
        settings.mgSulfateFinalText = "50.0"
        settings.adenosineInit = "0.1"
        settings.adebisineReoeatText = "0.2"
        settings.amiodaroneText = "5.0"
        settings.atropineText = "0.02"
        settings.naHC03Text = "1.0"
        settings.naHC03_84Text = "1.0"
        settings.calcuMinText = "10.0"
        settings.calcuMaxText = "20.0"
        settings.caGluconateText = "60.0"
        settings.epiText = "0.01"
        settings.lidocaineText = "1.0"
        settings.albuterolText = "2.5"
        settings.benadrylText = "1.0"
        settings.decadronText = "0.6"
        settings.diazepamText = "0.1"
        settings.epi1and1Text = "0.01"
        settings.fentanylINText = "1.5"
        settings.kentamineINText = "1.0"
        settings.morphineText = "0.1"
        settings.mannitolText = "500.0"
        settings.fluidBolusText = "20.0"
        settings.glucagonText = "0.1"
        settings.solumedrolText = "2.0"
        settings.zofranText = "0.15"
        settings.albuminMinText = "0.5"
        settings.albuminMaxText = "1.0"
        
        
        
        //MLS Data Rest
        settings.etoMidateMLstext = "2.0"
        settings.succinylcholineMLsText = "20.0"
        settings.vecuroniumMLs = "1.0"
        settings.rocuroniumTextMLs = "10.0"
        settings.ketamineTextMLs = "100.0"
        settings.ketamineRSITextMLs = "100.0"
        settings.versedIVTextMLs = "5.0"
        settings.versedIMMLs = "5.0"
        settings.propofolTextMLs = "10.0"
        settings.fentanyMLs = "50.0"
        settings.ativanTextMLs = "2.0"
        settings.mgSulfateMLs = "500.0"
        settings.adenosineInitMLs = "3.0"
        settings.adenosineRepeatMLsText = "3.0"
        settings.amiodaroneTextMLs = "50.0"
        settings.atropineTextMLs = "0.1"
        settings.naHC03TextMLs = "0.5"
        settings.naHC03_84Text = "1.0"
        settings.calcuMLs = "100.0"
        settings.caGluconateTextMLs = "100.0"
        settings.epiTextMLs = "0.1"
        settings.lidocaineTextMLs = "20.0"
        settings.albuminMLsText = "10.0"
        settings.albuminMLsMax = "20.0"
        settings.benadrylTextMLs = "50.0"
        settings.decadronTextMLs = "10.0"
        settings.diazepamTextMLs = "5.0"
        settings.epi1and1TextMLs = "1.0"
        settings.fentanylINTextMLs = "50.0"
        settings.ketamineINMLsText = "50.0"
        settings.morphineMLsText = "5.0"
        settings.mannitolTextMLs = "250.0"
        settings.fluidBolusTextMLs = "20.0"
        settings.glucagonTextMLs = "1.0"
        settings.solumedrolTextMLs = "62.5"
        settings.zofranTextMLs = "2.0"
        settings.albuterolTextMLs = "3.0"
        
        showingResetPopup = true
        
    }
    
    func updateParams(){
        // Etomidate
        medicineParametter.setValue(Double(settings.etoMidateText), forKey: "etomidate")
       
        medicineParametterML.setValue(Double(settings.etoMidateMLstext), forKey: "etomidateMLs")
        
        
        // Succs
        medicineParametter.setValue(Double(settings.succinylcholineMinText), forKey: "succinycholineMin")
        
        medicineParametter.setValue(Double(settings.succinylcholineMixText), forKey: "succinycholineMax")
        
        medicineParametterML.setValue(Double(settings.succinylcholineMLsText), forKey: "succsMLs2")
        
        
        //Vecuronium
        medicineParametter.setValue(Double(settings.vecurinium), forKey: "vecuronium")
        
        medicineParametterML.setValue(Double(settings.vecuroniumMLs), forKey: "vecMLs")
        
        
        //Rocuronium
        medicineParametter.setValue(Double(settings.rocuroniumTextMin), forKey: "rocuroniumMin")
        medicineParametter.setValue(Double(settings.rocuroniumTextMax), forKey: "rocuroniumMax")
        medicineParametterML.setValue(Double(settings.rocuroniumTextMLs), forKey: "rocuroniumMls")
        
        
        //Ketamine
        medicineParametter.setValue(Double(settings.ketamineText), forKey: "ketamine")
        medicineParametterML.setValue(Double(settings.ketamineTextMLs), forKey: "ketamineML")
        
        
        //Ketamine (RSI)
        medicineParametter.setValue(Double(settings.ketamineRSIText), forKey: "ketamineRSI")
        medicineParametterML.setValue(Double(settings.ketamineRSITextMLs), forKey: "ketamine_RSI_ML")
        
        
        //Versed IV
        medicineParametter.setValue(Double(settings.versedivText), forKey: "versed")
        medicineParametterML.setValue(Double(settings.versedIVTextMLs), forKey: "versedMLs")
        
        //Versed IM/IN
        medicineParametter.setValue(Double(settings.versedIMText), forKey: "versedIM")
        medicineParametterML.setValue(Double(settings.versedIMMLs), forKey: "versed_IMMLs")
        
        
        //Propofol
        medicineParametter.setValue(Double(settings.propofolMin), forKey: "propofolMin")
        medicineParametter.setValue(Double(settings.propofolMax), forKey: "propofolMax")
        medicineParametterML.setValue(Double(settings.propofolTextMLs), forKey: "propofolML")
        
        
        //Fentanyl
        medicineParametter.setValue(Double(settings.fentanylText), forKey: "fentanyl")
        medicineParametterML.setValue(Double(settings.fentanyMLs), forKey: "fentanylML")
        
        //  Ativan
        medicineParametter.setValue(Double(settings.ativanTextMin), forKey: "ativanMin")
        medicineParametter.setValue(Double(settings.ativanTextMax), forKey: "ativanMax")
        medicineParametterML.setValue(Double(settings.ativanTextMLs), forKey: "ativanML")
        
        
        //Mg Sulfate
        medicineParametter.setValue(Double(settings.mgSulfateInitText), forKey: "mgSulfateInitial")
        medicineParametter.setValue(Double(settings.mgSulfateFinalText), forKey: "mgSulfateFinal")
        medicineParametterML.setValue(Double(settings.mgSulfateMLs), forKey: "mgSulfateML")
        
        
        //  2nd Adenosine _Initial
        medicineParametter.setValue(Double(settings.adenosineInit), forKey: "adenosine_Initial")
        medicineParametterML.setValue(Double(settings.adenosineInitMLs), forKey: "adenosineInitialMls")
        
        
        // Adenosine _Repeat
        medicineParametter.setValue(Double(settings.adebisineReoeatText), forKey: "adenosine_Repeat")
        medicineParametterML.setValue(Double(settings.adenosineRepeatMLsText), forKey: "adenosineRepeat_mLs")
        
        // Amiodarone
        medicineParametter.setValue(Double(settings.amiodaroneText), forKey: "amio")
        medicineParametterML.setValue(Double(settings.amiodaroneTextMLs), forKey: "amio_mLs")
        
        //  Atropine
        medicineParametter.setValue(Double(settings.atropineText), forKey: "atropineSulfate")
        medicineParametterML.setValue(Double(settings.atropineTextMLs), forKey: "atropineSulfate_mLs")
        
        //NaHC03 (bicarb)
        medicineParametter.setValue(Double(settings.naHC03Text), forKey: "bicarb")
        medicineParametterML.setValue(Double(settings.naHC03TextMLs), forKey: "bicarb42MLs")
        
        medicineParametter.setValue(Double(settings.naHC03_84Text), forKey: "bicarb84")
        medicineParametterML.setValue(Double(settings.naHC03_84TextMLs), forKey: "bicarb84MLs")
        
        //  CaCL 20%
        medicineParametter.setValue(Double(settings.calcuMinText), forKey: "caChlorideDoseMin")
        medicineParametter.setValue(Double(settings.calcuMaxText), forKey: "caChlorideDoseMax")
        medicineParametterML.setValue(Double(settings.calcuMLs), forKey: "caChloride")
        
        // Ca Gluconate
        medicineParametter.setValue(Double(settings.caGluconateText), forKey: "caGluconateDose")
        medicineParametterML.setValue(Double(settings.caGluconateTextMLs), forKey: "caGluconatemL")
        
        //  Epi 1:10,000 IV
        medicineParametter.setValue(Double(settings.epiText), forKey: "epi")
        medicineParametterML.setValue(Double(settings.epiTextMLs), forKey: "epiMLs")
        
        //  Lidocaine
        medicineParametter.setValue(Double(settings.lidocaineText), forKey: "lidocaine")
        medicineParametterML.setValue(Double(settings.lidocaineTextMLs), forKey: "lidocaineMLs")
        
        //  3rd part
        //  Albuterol
        medicineParametter.setValue(Double(settings.albuterolText), forKey: "albuterol")
        medicineParametter.setValue(Double(settings.albuterolTextMLs), forKey: "albuterolML")
        
        //  Albumin
        medicineParametter.setValue(Double(settings.albuminMinText), forKey: "AlbuminMin")
        medicineParametter.setValue(Double(settings.albuminMaxText), forKey: "AlbuminMax")
        
        medicineParametterML.setValue(Double(settings.albuminMLsText), forKey: "AlbuminMLMin")
        medicineParametterML.setValue(Double(settings.albuminMLsMax), forKey: "AlbuminMLMax")
        
        
        //  Benadryl
        medicineParametter.setValue(Double(settings.benadrylText), forKey: "benadryl")
        medicineParametterML.setValue(Double(settings.benadrylTextMLs), forKey: "benadryl")
        
        
        //  Decadron
        medicineParametter.setValue(Double(settings.decadronText), forKey: "decadron")
        medicineParametterML.setValue(Double(settings.decadronTextMLs), forKey: "decadronML")
        
        //  Diazepam
        medicineParametter.setValue(Double(settings.diazepamText), forKey: "valium")
        medicineParametterML.setValue(Double(settings.diazepamTextMLs), forKey: "valiumML")
        
        
        //  Epi 1:1,000 IM
        medicineParametter.setValue(Double(settings.epi1and1Text), forKey: "epiIM")
        medicineParametterML.setValue(Double(settings.epi1and1TextMLs), forKey: "epi_IM_ML")
        
        
        //  Fentanyl IN
        medicineParametter.setValue(Double(settings.fentanylINText), forKey: "fentanyl_Intranasal")
        medicineParametterML.setValue(Double(settings.fentanylINTextMLs), forKey: "fentanylML_Intranasal")
        
        
        //  Ketamine IN
        medicineParametter.setValue(Double(settings.kentamineINText), forKey: "ketamine_Intranasal")
        medicineParametterML.setValue(Double(settings.ketamineINMLsText), forKey: "ketamine_Intranasal_Mls")
        
        
        //  Morphine
        medicineParametter.setValue(Double(settings.morphineText), forKey: "morphineDosage")
        medicineParametterML.setValue(Double(settings.morphineMLsText), forKey: "morphineML")
        
        
        //  Mannitol
        medicineParametter.setValue(Double(settings.mannitolText), forKey: "mannitol")
        medicineParametterML.setValue(Double(settings.mannitolTextMLs), forKey: "mannitolML")
        
        //  Fluid Bolus
        medicineParametter.setValue(Double(settings.fluidBolusText), forKey: "fluidCalc")
        medicineParametterML.setValue(Double(settings.fluidBolusTextMLs), forKey: "fluidCalcML")
        
        
        //  Glucagon
        medicineParametter.setValue(Double(settings.glucagonText), forKey: "glucagon")
        medicineParametterML.setValue(Double(settings.glucagonTextMLs), forKey: "glucagonML")
        
        //  Solumedrol
        medicineParametter.setValue(Double(settings.solumedrolText), forKey: "solumedrol")
        medicineParametterML.setValue(Double(settings.solumedrolTextMLs), forKey: "solumedrol_MLs")
        
        //   Zofran
        medicineParametter.setValue(Double(settings.zofranText), forKey: "zofran")
        medicineParametterML.setValue(Double(settings.zofranTextMLs), forKey: "zofran_MLs")
        
        
        UserDefaults.standard.set(medicineParametterML, forKey: "medicineParametterML")
        UserDefaults.standard.set(medicineParametter, forKey: "medicineParametter")
        UserDefaults.standard.synchronize()
        
        
        setMedicineData()
        setMedicine()
        showingPopup = true
        self.mode.wrappedValue.dismiss()
    }
    
    func setMedicine() {
       
        settings.etoMidateText = "\(medicineParametter.object(forKey: "etomidate") as? Double ?? 0)"
        
        settings.etoMidateMLstext = "\(medicineParametterML.object(forKey: "etomidateMLs") as? Double ?? 0)"
        
        //MARK: Succinylcholine
        settings.succinylcholineMinText = "\((medicineParametter.object(forKey: "succinycholineMin") as? Double) ?? 0)"
        settings.succinylcholineMixText = "\(medicineParametter.object(forKey: "succinycholineMax") as? Double ?? 0)"
        settings.succinylcholineMLsText = "\(medicineParametterML.object(forKey: "succsMLs2") as? Double ?? 0)"
        
        //MARK:Vecuronium
        settings.vecurinium = "\(medicineParametter.object(forKey: "vecuronium") as? Double ?? 0)"
        settings.vecuroniumMLs = "\(medicineParametterML.object(forKey: "vecMLs") as? Double ?? 0)"
        
        //  MARK:  Rocuronium
        settings.rocuroniumTextMin = "\(medicineParametter.object(forKey: "rocuroniumMin") as? Double ?? 0)"
        settings.rocuroniumTextMax = "\(medicineParametter.object(forKey: "rocuroniumMax") as? Double ?? 0)"
        settings.rocuroniumTextMLs = "\(medicineParametterML.object(forKey: "rocuroniumMls") as? Double ?? 0)"
        
        //MARK:    Ketamine
        settings.ketamineText =  "\(medicineParametter.object(forKey: "ketamine") as? Double ?? 0)"
        settings.ketamineTextMLs = "\(medicineParametterML.object(forKey: "ketamineML") as? Double ?? 0)"
        
        //MARK:    Ketamine (RSI)
        settings.ketamineRSIText = "\(medicineParametter.object(forKey: "ketamineRSI") as? Double ?? 0)"
        settings.ketamineRSITextMLs = "\(medicineParametterML.object(forKey: "ketamine_RSI_ML") as? Double ?? 0)"
        
        //MARK:    Versed IV
        settings.versedivText = "\(medicineParametter.object(forKey: "versed") as? Double ?? 0)"
        settings.versedIVTextMLs = "\(medicineParametterML.object(forKey: "versedMLs") as? Double ?? 0)"
        
        //MARK:    Versed IM/IN
        settings.versedIMText = "\(medicineParametter.object(forKey: "versedIM") as? Double ?? 0)"
        settings.versedIMMLs = "\(medicineParametterML.object(forKey: "versed_IMMLs") as? Double ?? 0)"
        
        //MARK:   Propofol
        settings.propofolMin = "\(medicineParametter.object(forKey: "propofolMin") as? Double ?? 0)"
        settings.propofolMax = "\(medicineParametter.object(forKey: "propofolMax") as? Double ?? 0)"
        settings.propofolTextMLs = "\(medicineParametterML.object(forKey: "propofolML") as? Double ?? 0)"
        
        //MARK:  Fentanyl
        settings.fentanylText = "\(medicineParametter.object(forKey: "fentanyl") as? Double ?? 0)"
        settings.fentanyMLs = "\(medicineParametterML.object(forKey: "fentanylML") as? Double ?? 0)"
        
        
        //MARK:  Ativan
        settings.ativanTextMin = "\(medicineParametter.object(forKey: "ativanMin") as? Double ?? 0)"
        settings.ativanTextMax = "\(medicineParametter.object(forKey: "ativanMax") as? Double ?? 0)"
        settings.ativanTextMLs = "\(medicineParametterML.object(forKey: "ativanML") as? Double ?? 0)"
        
        //   Mg Sulfate
        settings.mgSulfateInitText = "\(medicineParametter.object(forKey: "mgSulfateInitial") as? Double ?? 0)"
        settings.mgSulfateFinalText = "\(medicineParametter.object(forKey: "mgSulfateFinal") as? Double ?? 0)"
        
        // Condition to solve if the mg amount is over 1000, then convert to grams.
        if (medicineParametter.object(forKey: "mgSulfateInitial") as? Double ?? 0 >= 1000.0) || (medicineParametter.object(forKey: "mgSulfateFinal") as? Double ?? 0 >= 1000.0) {
            
            // Changing the units label
            settings.mgSulfateInitText = "\((medicineParametter.object(forKey: "mgSulfateInitial") as? Double ?? 0)/1000)"
            settings.mgSulfateFinalText = "\((medicineParametter.object(forKey: "mgSulfateFinal") as? Double ?? 0)/1000)"
            settings.mgSulfateLabel = "g"
        }
            
        else {
            // Changing the units label
            settings.mgSulfateInitText = "\(medicineParametter.object(forKey: "mgSulfateInitial") as? Double ?? 0)"
            settings.mgSulfateFinalText = "\(medicineParametter.object(forKey: "mgSulfateFinal") as? Double ?? 0)"
            settings.mgSulfateLabel = "mg's"
            
        }
        
        //        let mgSulfateML = pediatric_DetailVC.convertMLfromCalculatedDose(patientDosePerKG: (medicineParametter.object(forKey: "mgSulfateInitial") as? Double ?? 0), doseIn_Mg_G: 500, mL: 1)
        //        let mgSulfateSecondML = pediatric_DetailVC.convertMLfromCalculatedDose(patientDosePerKG: (medicineParametter.object(forKey: "mgSulfateFinal") as? Double ?? 0), doseIn_Mg_G: 500, mL: 1)
        settings.mgSulfateMLs = "\(medicineParametterML.object(forKey: "mgSulfateML") as? Double ?? 0)"
        
        
        //MARK:  2nd Adenosine _Initial
        settings.adenosineInit = "\(medicineParametter.object(forKey: "adenosine_Initial") as? Double ?? 0)"
        settings.adenosineInitMLs = "\(medicineParametterML.object(forKey: "adenosineInitialMls") as? Double ?? 0)"

        //MARK: Adenosine _Repeat
        settings.adebisineReoeatText = "\(medicineParametter.object(forKey: "adenosine_Repeat") as? Double ?? 0)"
        settings.adenosineRepeatMLsText = "\(medicineParametterML.object(forKey: "adenosineRepeat_mLs") as? Double ?? 0)"

        //MARK: Amiodarone
        settings.amiodaroneText = "\(medicineParametter.object(forKey: "amio") as? Double ?? 0)"
        settings.amiodaroneTextMLs = "\(medicineParametterML.object(forKey: "amio_mLs") as? Double ?? 0)"

        //MARK:  Atropine
        settings.atropineText = "\(medicineParametter.object(forKey: "atropineSulfate") as? Double ?? 0)"
        settings.atropineTextMLs = "\(medicineParametterML.object(forKey: "atropineSulfate_mLs") as? Double ?? 0)"

        //MARK:NaHC03 (bicarb)
        settings.naHC03Text = "\(medicineParametter.object(forKey: "bicarb") as? Double ?? 0)"
        settings.naHC03TextMLs = "\(medicineParametterML.object(forKey: "bicarb42MLs") as? Double ?? 0)"

        settings.naHC03_84Text = "\(medicineParametter.object(forKey: "bicarb84") as? Double ?? 0)"
        settings.naHC03_84TextMLs = "\(medicineParametterML.object(forKey: "bicarb84MLs") as? Double ?? 0)"

        //MARK:  CaCL 20%
        settings.calcuMinText = "\(medicineParametter.object(forKey: "caChlorideDoseMin") as? Double ?? 0)"
        settings.calcuMaxText = "\(medicineParametter.object(forKey: "caChlorideDoseMax") as? Double ?? 0)"
        settings.calcuMLs = "\(medicineParametterML.object(forKey: "caChloride") as? Double ?? 0)"

        //MARK: Ca Gluconate
        settings.caGluconateText = "\(medicineParametter.object(forKey: "caGluconateDose") as? Double ?? 0)"
        settings.caGluconateTextMLs = "\(medicineParametterML.object(forKey: "caGluconatemL") as? Double ?? 0)"





        //Guard function from the closure.
        //        let D12_5 = 50/12.5 // Since the mL is 0.5 g/kg convert into miligrams
        //
        //        let D25   = 50/25 // Since the mL is 0.5 g/kg convert into miligrams
        //
        //        let D10   = 50 / 10 // Since the mL is 0.5 g/kg convert into miligrams
        //
        //        let D5    = 50 / 5
        //
        //        //Child (D25): 50/25 = 2 ml/kg
        //        let D_25MLs   = ruleOf(DetrosePercentage: 25, weightInKg: 1)
        //
        //        // Child (D12.5): 50/12.5 = 4 ml/kg
        //        let D_12_5MLs = ruleOf(DetrosePercentage: 12.5, weightInKg: 1)
        //
        //        // Infant (D10): 50/10 = 5 ml/kg
        //        let D_10MLs = ruleOf(DetrosePercentage : 10, weightInKg : 1)
        //
        //        let D_5MLs  = ruleOf(DetrosePercentage  : 5, weightInKg  : 1)

        //print(D_25MLs)

        // Sets the detail label with the dose and mL amount
        //        d12dot5Text = "0.5 g/kg - \(1 * 0.5)g | Dosing at \(String(describing : D12_5)) mL/kg"
        //
        //        d25Text   = "0.5 g/kg - \(1 * 0.5)g | Dosing at \(String(describing   : D25)) mL/kg"
        //
        //        d10Text   = "0.5 g/kg - \(1 * 0.5)g | Dosing at \(String(describing   : D10)) mL/kg"
        //
        //        d5Text    = "0.5 g/kg - \(1 * 0.5)g | Dosing at  \(String(describing   : D5)) mL/kg"
        //
        //        // Sets both the dose and ML amount
        //        d25TextMLs   = "\(D_25MLs)"
        //        d12dot5TextMLs =  "\(D_12_5MLs)"
        //        d10TextMLs   =  "\(D_10MLs)"
        //        d5TextMLs    = "\(D_5MLs)"

        //MARK: Epi 1:10,000 IV
        settings.epiText = "\(medicineParametter.object(forKey: "epi") as? Double ?? 0)"

        settings.epiTextMLs = "\(medicineParametterML.object(forKey: "epiMLs") as? Double ?? 0)"


        //MARK: Lidocaine
        settings.lidocaineText = "\(medicineParametter.object(forKey: "lidocaine") as? Double ?? 0)"

        settings.lidocaineTextMLs = "\(medicineParametterML.object(forKey: "lidocaineMLs") as? Double ?? 0)"

        //MARK: 3rd Part

        //MARK: Albuterol
        settings.albuterolText = "\(medicineParametter.object(forKey: "albuterol") as? Double ?? 0)"

        settings.albuterolTextMLs = "\(medicineParametterML.object(forKey: "albuterolML") as? Double ?? 0)"

        //MARK: Albumin

        settings.albuminMinText = "\(medicineParametter.object(forKey: "AlbuminMin") as? Double ?? 0)"

        settings.albuminMaxText = "\(medicineParametter.object(forKey: "AlbuminMax") as? Double ?? 0)"

        settings.albuminMLsText = "\(medicineParametterML.object(forKey: "AlbuminMLMin") as? Double ?? 0)"

        settings.albuminMLsMax = "\(medicineParametterML.object(forKey: "AlbuminMLMax") as? Double ?? 0)"


        //MARK: Benadryl
        settings.benadrylText = "\(medicineParametter.object(forKey: "benadryl") as? Double ?? 0)"
        settings.benadrylTextMLs = "\(medicineParametterML.object(forKey: "benadrylML") as? Double ?? 0)"

//        //MARK: DuoNeb
//        duoNedText = "0.5 / 2.5"
//
//        duoNedTextMLs = "3"

        //MARK: Decadron
        settings.decadronText = "\(medicineParametter.object(forKey: "decadron") as? Double ?? 0)"

        settings.decadronTextMLs = "\(medicineParametterML.object(forKey: "decadronML") as? Double ?? 0)"

        //MARK: Diazepam
        settings.diazepamText = "\(medicineParametter.object(forKey: "valium") as? Double ?? 0)"

        settings.diazepamTextMLs = "\(medicineParametterML.object(forKey: "valiumML") as? Double ?? 0)"

        //MARK: Epi 1:1,000 IM
        settings.epi1and1Text = "\(medicineParametter.object(forKey: "epiIM") as? Double ?? 0)"

        settings.epi1and1TextMLs = "\(medicineParametterML.object(forKey: "epi_IM_ML") as? Double ?? 0)"

        //MARK: Fentanyl IN
        settings.fentanylINText = "\(medicineParametter.object(forKey: "fentanyl_Intranasal") as? Double ?? 0)"

        settings.fentanylINTextMLs = "\(medicineParametterML.object(forKey: "fentanylML_Intranasal") as? Double ?? 0)"

        //MARK: Ketamine IN
        settings.kentamineINText = "\(medicineParametter.object(forKey: "ketamine_Intranasal") as? Double ?? 0)"

        settings.ketamineINMLsText = "\(medicineParametterML.object(forKey: "ketamine_Intranasal_Mls") as? Double ?? 0)"

        //MARK: Morphine
        settings.morphineText = "\(medicineParametter.object(forKey: "morphineDosage") as? Double ?? 0)"

        settings.morphineMLsText = "\(medicineParametterML.object(forKey: "morphineML") as? Double ?? 0)"



        //MARK:  Mannitol
        settings.mannitolText = "\(medicineParametter.object(forKey: "mannitol") as? Double ?? 0)"

        settings.mannitolTextMLs = "\(medicineParametterML.object(forKey: "mannitolML") as? Double ?? 0)"


        //MARK: Fluid Intake (Daily)
//        let maintenanceFluids = pediatric_DetailVC.calculateMaintenance_Fluids(weight: 1)
//
//        let mLperDay = maintenanceFluids / 24
//
//        fluidIntakeDailyText = "\(maintenanceFluids)"
//
//        fluidIntakeDailyTextMls = "\(mLperDay)"

        //MARK: Fluid Bolus
        settings.fluidBolusText = "\(calculateDoseOne(Dose: (medicineParametter.object(forKey: "fluidCalc") as? Double ?? 0)))"

        settings.fluidBolusTextMLs = "\(medicineParametterML.object(forKey: "fluidCalcML") as? Double ?? 0)"

        //MARK: Glucagon
        settings.glucagonText = "\(medicineParametter.object(forKey: "glucagon") as? Double ?? 0)"

        settings.glucagonTextMLs = "\(medicineParametterML.object(forKey: "glucagonML") as? Double ?? 0)"

        //MARK: Solumedrol
        settings.solumedrolText = "\(medicineParametter.object(forKey: "solumedrol") as? Double ?? 0)"

        settings.solumedrolTextMLs = "\(medicineParametterML.object(forKey: "solumedrol_MLs") as? Double ?? 0)"

        //MARK:  Zofran
        settings.zofranText = "\(medicineParametter.object(forKey: "zofran") as? Double ?? 0)"
        settings.zofranTextMLs = "\(medicineParametterML.object(forKey: "zofran_MLs") as? Double ?? 0)"
        
        
        
    }
    
    func setMedicineData() {
        
        if ((UserDefaults.standard.object(forKey:"medicineParametter")) != nil && (UserDefaults.standard.object(forKey:"medicineParametterML")) != nil) {
            
            medicineParametter = NSMutableDictionary.init(dictionary: (UserDefaults.standard.object(forKey:"medicineParametter") as? NSDictionary)!)
            
            medicineParametterML = NSMutableDictionary.init(dictionary: (UserDefaults.standard.object(forKey:"medicineParametterML") as? NSDictionary)!)
            
        }
        else {
            //
            UserDefaults.standard.set(medicineParametter, forKey: "medicineParametter")
            UserDefaults.standard.set(medicineParametterML, forKey: "medicineParametterML")
            #if CALSTAR
            
           medicineParametter =
                ["adenosine_Initial": 0.1,
                 "adenosine_Repeat": 0.2,
                 "amio": 5.0,
                 "atropine": 0.02,
                 "ativanMin": 0.05,
                 "ativanMax": 0.1,
                 "bicarb": 1.0,
                 "bicarb84": 1.0,
                 "caChlorideDoseMin": 10,
                 "caChlorideDoseMax": 20,
                 "caGluconateDose": 60,
                 "etomidate": 0.3,
                 "epi": 0.01,
                 "atropineSulfate": 0.02,
                 "fentanyl": 1.0,
                 "fentanyl_Intranasal": 1.5,
                 "ketamineRSI": 1.5,
                 "ketamine": 0.5,
                 "ketamine_Intranasal": 1,
                 "lidocaine": 1,
                 "propofolMin": 10,
                 "propofolMax": 75,
                 "succinycholineMin": 1,
                 "succinycholineMax": 2,
                 "vecuronium": 0.1,
                 "mgSulfateInitial": 25,
                 "mgSulfateFinal": 50,
                 "morphineDosage": 0.1,
                 "mannitol":500,
                 "rocuroniumMin": 0.6,
                 "rocuroniumMax": 1.2,
                 "versed": 0.1,
                 "versedIM": 0.2,
                 "decadron": 0.6,
                 "valium": 0.1,
                 "glucagon": 0.1,
                 "fluidCalc": 20.0,
                 "AlbuminMin": 0.5,
                 "AlbuminMax": 1.0,
                 
                 "epiIM": 0.01,
                 "benadryl": 1.0,
                 "solumedrol":2.0,
                 "albuterol": 2.5,
                 "zofran":0.15]
            
            medicineParametterML = [
                "AlbuminMLMin":10,
                "AlbuminMLMax":20,
                "adenosineInitialMls":3.0,
                "adenosineRepeat_mLs":3.0,
                "amio_mLs":50.0,
                "atropineSulfate_mLs":0.1,
                "ativanML":2.0,
                "bicarb42MLs": 0.5,
                "bicarb84MLs": 1.0,
                "caChloride": 100.0,
                "caGluconatemL": 100.0,
                "decadronML": 10.0,
                "etomidateMLs": 2.0,
                "epiMLs": 0.1,
                "epiMLs1000": 1.0,
                "fentanylML": 50.0,
                "fentanylML_Intranasal":50.0,
                "ketamine_RSI_ML": 100.0,
                "ketamineML": 100.0,
                "ketamine_Intranasal_Mls":50.0,
                "lidocaineMLs": 20.0,
                "propofolML":10.0,
                "succsMLs2":20.0,
                "vecMLs":1.0,
                "mgSulfateML": 500.0,
                "mgSulfateSecondML" : 1.0,
                "morphineML":5.0,
                "mannitolML":250.0,
                "rocuroniumMls":10.0,
                "versedMLs": 5.0,
                "versed_IMMLs":5.0,
                "decadronML":1.0,
                "valiumML": 1.0,
                "glucagonML": 1.0,
                "fluidCalcML": 20.0,
                "benadrylML": 50.0,
                "epi_IM_ML": 1.0,
                "solumedrol_MLs":62.5,
                "albuterolML": 3.0,
                "zofran_MLs":2.0]
            
            #else
            
            medicineParametter =
                ["adenosine_Initial": 0.1,
                 "adenosine_Repeat": 0.2,
                 "amio": 5.0,
                 "atropine": 0.02,
                 "ativanMin": 0.05,
                 "ativanMax": 0.1,
                 "bicarb": 1.0,
                 "bicarb84": 1.0,
                 "caChlorideDoseMin": 10,
                 "caChlorideDoseMax": 20,
                 "caGluconateDose": 60,
                 "etomidate": 0.3,
                 "epi": 0.01,
                 "atropineSulfate": 0.02,
                 "fentanyl": 1.0,
                 "fentanyl_Intranasal": 1.5,
                 "ketamineRSI": 1.5,
                 "ketamine": 0.5,
                 "ketamine_Intranasal": 1,
                 "lidocaine": 1,
                 "propofolMin": 25,
                 "propofolMax": 100,
                 "succinycholineMin": 1,
                 "succinycholineMax": 2,
                 "vecuronium": 0.1,
                 "mgSulfateInitial": 25,
                 "mgSulfateFinal": 50,
                 "morphineDosage": 0.1,
                 "mannitol":500,
                 "rocuroniumMin": 0.6,
                 "rocuroniumMax": 1.2,
                 "versed": 0.1,
                 "versedIM": 0.2,
                 "decadron": 0.6,
                 "valium": 0.1,
                 "glucagon": 0.1,
                 "fluidCalc": 20.0,
                 "AlbuminMin": 0.5,
                 "AlbuminMax": 1.0,
                 "epiIM": 0.01,
                 "benadryl": 1.0,
                 "solumedrol":2.0,
                 "albuterol": 2.5,
                 "zofran":0.15]
            
            medicineParametterML = [
                "AlbuminMLMin":10,
                "AlbuminMLMax":20,
                "adenosineInitialMls":3.0,
                "adenosineRepeat_mLs":3.0,
                "amio_mLs":50.0,
                "atropineSulfate_mLs":0.1,
                "ativanML":2.0,
                "bicarb42MLs": 0.5,
                "bicarb84MLs": 1.0,
                "caChloride": 100.0,
                "caGluconatemL": 100.0,
                "decadronML": 10.0,
                "etomidateMLs": 2.0,
                "epiMLs": 0.1,
                "epiMLs1000": 1.0,
                "fentanylML": 50.0,
                "fentanylML_Intranasal":50.0,
                "ketamine_RSI_ML": 100.0,
                "ketamineML": 100.0,
                "ketamine_Intranasal_Mls":50.0,
                "lidocaineMLs": 20.0,
                "propofolML":10.0,
                "succsMLs2":20.0,
                "vecMLs":1.0,
                "mgSulfateML": 500.0,
                "mgSulfateSecondML" : 1.0,
                "morphineML":5.0,
                "mannitolML":250.0,
                "rocuroniumMls":10.0,
                "versedMLs": 5.0,
                "versed_IMMLs":5.0,
                "decadronML":1.0,
                "valiumML": 1.0,
                "glucagonML": 1.0,
                "fluidCalcML": 20.0,
                "benadrylML": 50.0,
                "epi_IM_ML": 1.0,
                "solumedrol_MLs":62.5,
                "albuterolML": 3.0,
                "zofran_MLs":2.0]
            
            #if DEBUG
            for (key,value) in medicineParametter {
                print("Pediatric Dose Values: \(key) : \(value)")
            }
            for (key,value) in medicineParametterML {
                print("Pediatric mmg/mL Values: \(key) : \(value)")
            }
            #endif
            
            
            
            #endif
            
            UserDefaults.standard.synchronize()
        }
    }
    
    func calculateDoseOne (Dose: Double)-> Double {
        
        // Takes the settingsWeight entered in the textField and uses it in the function
        
        let result = settingsWeight * Dose
        
        return result
        //return String(format: "%.0f", result) as String
    }
}
