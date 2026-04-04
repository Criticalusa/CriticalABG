//
//  SettingView.swift
//  CriticalX
//
//  Premium Redesign with CriticalDesign System
//

import SwiftUI

// MARK: - Settings Observable
class SettingValue: ObservableObject {
    @Published var lidocineTxtFieldmgmL: String = ""
    @Published var lidocineTxtFieldmgkG: String = ""
    @Published var atrophineTxtFieldmgmL: String = ""
    @Published var atrophineTxtFieldmgkG: String = ""
    @Published var fentanylTxtFieldmgmL: String = ""
    @Published var fentaylTxtFieldmgkG1: String = ""
    @Published var fentaylTxtFieldmgkG2: String = ""
    @Published var vecuroniumTxtFieldmgmL: String = ""
    @Published var vecuroniumTxtFieldmgkG: String = ""
    @Published var glycopyrrolateTxtFieldmgmL: String = ""
    @Published var glycopyrrolateTxtFieldmgkG1: String = ""
    @Published var glycopyrrolateTxtFieldmgkG2: String = ""
    @Published var rocuroniumTxtFieldmgmL: String = ""
    @Published var rocuroniumTxtFieldmgkG1: String = ""
    @Published var rocuroniumTxtFieldmgkG2: String = ""
    
    @Published var etomidateTxtFieldmgmL: String = ""
    @Published var etomidateTxtFieldmgkG: String = ""
    @Published var ketamineTxtFieldmgmL: String = ""
    @Published var ketamineTxtFieldmgkG1: String = ""
    @Published var ketamineTxtFieldmgkG2: String = ""
    @Published var versedTxtFieldmgmL: String = ""
    @Published var versedTxtFieldmgkG1: String = ""
    @Published var versedTxtFieldmgkG2: String = ""
    @Published var propofolTxtFieldmgmL: String = ""
    @Published var propofolTxtFieldmgkG1: String = ""
    @Published var propofolTxtFieldmgkG2: String = ""
    
    @Published var succinylcholineTxtFieldmgmL: String = ""
    @Published var succinylcholineTxtFieldmgkG1: String = ""
    @Published var succinylcholineTxtFieldmgkG2: String = ""
    @Published var vecuroniumTxtFieldmgmL1: String = ""
    @Published var vecuroniumTxtFieldmgkG1: String = ""
    @Published var cisatracuriumTxtFieldmgmL: String = ""
    @Published var cisatracuriumTxtFieldmgkG: String = ""
    @Published var rocuroniumTxtFieldmgmL1: String = ""
    @Published var rocuroniumTxtFieldmgkG1_1: String = ""
    @Published var rocuroniumTxtFieldmgkG2_2: String = ""
}

// MARK: - RSI Category Pill
struct RSICategoryPill: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(title)
                    .font(.custom("Poppins-SemiBold", size: 13))
            }
            .foregroundColor(isSelected ? .white : color)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(isSelected ? color : color.opacity(0.1))
            )
            .overlay(
                Capsule()
                    .stroke(color.opacity(0.3), lineWidth: isSelected ? 0 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Premium Success Toast
struct SuccessToast: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(CriticalDesign.Colors.accentGreen)
            
            Text("Settings Saved")
                .font(.custom("Poppins-SemiBold", size: 16))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
        )
        .scaleEffect(isAnimating ? 1 : 0.8)
        .opacity(isAnimating ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Main Settings View
struct SettingView: View {
    @ObservedObject var settings: SettingValue = SettingValue()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Binding var showingPopup: Bool
    
    @State private var selectedCategory: Int = 0
    @State private var showResetAlert = false
    @State private var showSuccessToast = false
    
    let categories = [
        ("Pre-Tx", "pills.fill", CriticalDesign.Colors.accentBlue),
        ("Induction", "syringe.fill", CriticalDesign.Colors.accentGreen),
        ("Paralytic", "bolt.fill", CriticalDesign.Colors.accentRed)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                CriticalDesign.Colors.canvas
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Category Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<categories.count, id: \.self) { index in
                                RSICategoryPill(
                                    title: categories[index].0,
                                    icon: categories[index].1,
                                    color: categories[index].2,
                                    isSelected: selectedCategory == index,
                                    action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            selectedCategory = index
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                    // Content
                    TabView(selection: $selectedCategory) {
                        PretreatmentSettingView(settings: settings)
                            .tag(0)
                        
                        InductionAgentSettingView(settings: settings)
                            .tag(1)
                        
                        NeuromuscularSettingView(settings: settings)
                            .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                
                // Floating Save Button
                VStack {
                    Spacer()
                    
                    Button(action: updateParams) {
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                            
                            Text("Save Changes")
                                .font(.custom("Poppins-SemiBold", size: 15))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [CriticalDesign.Colors.accentBlue, CriticalDesign.Colors.accentBlue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: CriticalDesign.Colors.accentBlue.opacity(0.4), radius: 16, x: 0, y: 8)
                        )
                    }
                    .padding(.bottom, 24)
                }
                
                // Success Toast
                if showSuccessToast {
                    VStack {
                        SuccessToast()
                            .padding(.top, 60)
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .navigationBarTitle("RSI Settings", displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: { showResetAlert = true }) {
                    Text("Reset")
                        .font(.custom("Poppins-Medium", size: 14))
                        .foregroundColor(CriticalDesign.Colors.accentRed)
                }
            )
        }
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text("Reset All Settings"),
                message: Text("This will restore all medication dosages to their default values."),
                primaryButton: .destructive(Text("Reset")) {
                    reset()
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            initValue()
        }
    }
    
    // MARK: - Helper Functions
    func initValue() {
        var Parameters: NSMutableDictionary
        if ((UserDefaults.standard.object(forKey:"parameters")) != nil) {
            Parameters = NSMutableDictionary.init(dictionary: (UserDefaults.standard.object(forKey:"parameters") as? NSDictionary)!)
        } else {
            Parameters = ["atropine": 0.02, "lidocaine": 1, "fentanyl_min": 1, "fentanyl_max": 2, "vecDefasiculating": 0.01, "rocDefasiculating_min": 0.06, "rocDefasiculating_max": 0.12, "glycopyrrolate_min": 0.1, "glycopyrrolate_max": 0.2, "etomidate": 0.3, "ketamine": 1.0, "ketamineMax": 2.0, "propofol_min": 1, "propofol_max": 2, "versed_min": 0.1, "versed_max": 0.2, "cisatricurium": 0.2, "vecuronium": 0.1, "rocuronium_min": 0.6, "rocuronium_max": 1.2, "succs_min": 1, "succs_max": 1.5, "lidocaine_mgMl": 20, "mgPerML_atropine": 0.1, "mgPerML_fentanyl": 50.0, "mgPerML_vecDefasc": 1.0, "mgPerML_rocDefasc": 10.0, "hello": 0.2, "ml_etomidate": 2.0, "ml_ketamine": 100.0, "ml_versed": 5.0, "ml_propofol": 10.0, "ml_succs": 10.0, "ml_vec": 1.0, "ml_roc": 10.0, "ml_cis": 10.0]
            
            UserDefaults.standard.set(Parameters, forKey: "parameters")
            UserDefaults.standard.synchronize()
        }
        
        settings.lidocineTxtFieldmgkG = "\(Parameters.object(forKey: "lidocaine") as? Double ?? 0)"
        settings.atrophineTxtFieldmgkG = "\(Parameters.object(forKey: "atropine") as? Double ?? 0)"
        settings.fentaylTxtFieldmgkG1 = "\(Parameters.object(forKey: "fentanyl_min") as? Double ?? 0)"
        settings.fentaylTxtFieldmgkG2 = "\(Parameters.object(forKey: "fentanyl_max") as? Double ?? 0)"
        settings.vecuroniumTxtFieldmgkG = "\(Parameters.object(forKey: "vecDefasiculating") as? Double ?? 0)"
        settings.glycopyrrolateTxtFieldmgkG1 = "\(Parameters.object(forKey: "glycopyrolate_min") as? Double ?? 0)"
        settings.glycopyrrolateTxtFieldmgkG2 = "\(Parameters.object(forKey: "glycopyrolate_max") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgkG1 = "\(Parameters.object(forKey: "rocDefasiculating_min") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgkG2 = "\(Parameters.object(forKey: "rocDefasiculating_max") as? Double ?? 0)"
        settings.lidocineTxtFieldmgmL = "\(Parameters.object(forKey: "lidocaine_mgMl") as? Double ?? 0)"
        settings.atrophineTxtFieldmgmL = "\(Parameters.object(forKey: "mgPerML_atropine") as? Double ?? 0)"
        settings.fentanylTxtFieldmgmL = "\(Parameters.object(forKey: "mgPerML_fentanyl") as? Double ?? 0)"
        settings.vecuroniumTxtFieldmgmL = "\(Parameters.object(forKey: "mgPerML_vecDefasc") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgmL = "\(Parameters.object(forKey: "mgPerML_rocDefasc") as? Double ?? 0)"
        settings.glycopyrrolateTxtFieldmgmL = "\(Parameters.object(forKey: "hello") as? Double ?? 0)"
        settings.etomidateTxtFieldmgmL = "\(Parameters.object(forKey: "ml_etomidate") as? Double ?? 0)"
        settings.ketamineTxtFieldmgmL = "\(Parameters.object(forKey: "ml_ketamine") as? Double ?? 0)"
        settings.versedTxtFieldmgmL = "\(Parameters.object(forKey: "ml_versed") as? Double ?? 0)"
        settings.propofolTxtFieldmgmL = "\(Parameters.object(forKey: "ml_propofol") as? Double ?? 0)"
        settings.etomidateTxtFieldmgkG = "\(Parameters.object(forKey: "etomidate") as? Double ?? 0)"
        settings.ketamineTxtFieldmgkG1 = "\(Parameters.object(forKey: "ketamine") as? Double ?? 0)"
        settings.ketamineTxtFieldmgkG2 = "\(Parameters.object(forKey: "ketamineMax") as? Double ?? 0)"
        settings.versedTxtFieldmgkG1 = "\(Parameters.object(forKey: "versed_min") as? Double ?? 0)"
        settings.versedTxtFieldmgkG2 = "\(Parameters.object(forKey: "versed_max") as? Double ?? 0)"
        settings.propofolTxtFieldmgkG1 = "\(Parameters.object(forKey: "propofol_min") as? Double ?? 0)"
        settings.propofolTxtFieldmgkG2 = "\(Parameters.object(forKey: "propofol_max") as? Double ?? 0)"
        settings.succinylcholineTxtFieldmgmL = "\(Parameters.object(forKey: "ml_succs") as? Double ?? 0)"
        settings.cisatracuriumTxtFieldmgmL = "\(Parameters.object(forKey: "ml_cis") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgmL1 = "\(Parameters.object(forKey: "ml_roc") as? Double ?? 0)"
        settings.vecuroniumTxtFieldmgmL1 = "\(Parameters.object(forKey: "ml_vec") as? Double ?? 0)"
        settings.succinylcholineTxtFieldmgkG1 = "\(Parameters.object(forKey: "succs_min") as? Double ?? 0)"
        settings.succinylcholineTxtFieldmgkG2 = "\(Parameters.object(forKey: "succs_max") as? Double ?? 0)"
        settings.vecuroniumTxtFieldmgkG1 = "\(Parameters.object(forKey: "vecuronium") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgkG1_1 = "\(Parameters.object(forKey: "rocuronium_min") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgkG2_2 = "\(Parameters.object(forKey: "rocuronium_max") as? Double ?? 0)"
        settings.cisatracuriumTxtFieldmgkG = "\(Parameters.object(forKey: "cisatricurium") as? Double ?? 0)"
    }
    
    func updateParams() {
        let Parameters: NSMutableDictionary! = NSMutableDictionary()
        
        Parameters.setValue(Double(settings.lidocineTxtFieldmgkG) ?? 0.0, forKey: "lidocaine")
        Parameters.setValue(Double(settings.atrophineTxtFieldmgkG) ?? 0.0, forKey: "atropine")
        Parameters.setValue(Double(settings.fentaylTxtFieldmgkG1) ?? 0.0, forKey: "fentanyl_min")
        Parameters.setValue(Double(settings.fentaylTxtFieldmgkG2) ?? 0.0, forKey: "fentanyl_max")
        Parameters.setValue(Double(settings.vecuroniumTxtFieldmgkG) ?? 0.0, forKey: "vecDefasiculating")
        Parameters.setValue(Double(settings.glycopyrrolateTxtFieldmgkG1) ?? 0.0, forKey: "glycopyrolate_min")
        Parameters.setValue(Double(settings.glycopyrrolateTxtFieldmgkG2) ?? 0.0, forKey: "glycopyrolate_max")
        Parameters.setValue(Double(settings.rocuroniumTxtFieldmgkG1) ?? 0.0, forKey: "rocDefasiculating_min")
        Parameters.setValue(Double(settings.rocuroniumTxtFieldmgkG2) ?? 0.0, forKey: "rocDefasiculating_max")
        Parameters.setValue(Double(settings.etomidateTxtFieldmgkG) ?? 0.0, forKey: "etomidate")
        Parameters.setValue(Double(settings.ketamineTxtFieldmgkG1) ?? 0.0, forKey: "ketamine")
        Parameters.setValue(Double(settings.ketamineTxtFieldmgkG2) ?? 0.0, forKey: "ketamineMax")
        Parameters.setValue(Double(settings.versedTxtFieldmgkG1) ?? 0.0, forKey: "versed_min")
        Parameters.setValue(Double(settings.versedTxtFieldmgkG2) ?? 0.0, forKey: "versed_max")
        Parameters.setValue(Double(settings.propofolTxtFieldmgkG1) ?? 0.0, forKey: "propofol_min")
        Parameters.setValue(Double(settings.propofolTxtFieldmgkG2) ?? 0.0, forKey: "propofol_max")
        Parameters.setValue(Double(settings.succinylcholineTxtFieldmgkG1) ?? 0.0, forKey: "succs_min")
        Parameters.setValue(Double(settings.succinylcholineTxtFieldmgkG2) ?? 0.0, forKey: "succs_max")
        Parameters.setValue(Double(settings.vecuroniumTxtFieldmgkG1) ?? 0.0, forKey: "vecuronium")
        Parameters.setValue(Double(settings.rocuroniumTxtFieldmgkG1_1) ?? 0.0, forKey: "rocuronium_min")
        Parameters.setValue(Double(settings.rocuroniumTxtFieldmgkG2_2) ?? 0.0, forKey: "rocuronium_max")
        Parameters.setValue(Double(settings.cisatracuriumTxtFieldmgkG) ?? 0.0, forKey: "cisatricurium")
        Parameters.setValue(Double(settings.lidocineTxtFieldmgmL) ?? 0.0, forKey: "lidocaine_mgMl")
        Parameters.setValue(Double(settings.atrophineTxtFieldmgmL) ?? 0.0, forKey: "mgPerML_atropine")
        Parameters.setValue(Double(settings.fentanylTxtFieldmgmL) ?? 0.0, forKey: "mgPerML_fentanyl")
        Parameters.setValue(Double(settings.vecuroniumTxtFieldmgmL) ?? 0.0, forKey: "mgPerML_vecDefasc")
        Parameters.setValue(Double(settings.rocuroniumTxtFieldmgmL) ?? 0.0, forKey: "mgPerML_rocDefasc")
        Parameters.setValue(Double(settings.glycopyrrolateTxtFieldmgmL) ?? 0.0, forKey: "hello")
        Parameters.setValue(Double(settings.etomidateTxtFieldmgmL) ?? 0.0, forKey: "ml_etomidate")
        Parameters.setValue(Double(settings.ketamineTxtFieldmgmL) ?? 0.0, forKey: "ml_ketamine")
        Parameters.setValue(Double(settings.versedTxtFieldmgmL) ?? 0.0, forKey: "ml_versed")
        Parameters.setValue(Double(settings.succinylcholineTxtFieldmgmL) ?? 0.0, forKey: "ml_succs")
        Parameters.setValue(Double(settings.vecuroniumTxtFieldmgmL1) ?? 0.0, forKey: "ml_vec")
        Parameters.setValue(Double(settings.rocuroniumTxtFieldmgmL1) ?? 0.0, forKey: "ml_roc")
        Parameters.setValue(Double(settings.cisatracuriumTxtFieldmgmL) ?? 0.0, forKey: "ml_cis")
        Parameters.setValue(Double(settings.propofolTxtFieldmgmL) ?? 0.0, forKey: "ml_propofol")
        
        UserDefaults.standard.set(Parameters, forKey: "parameters")
        UserDefaults.standard.synchronize()
        
        // Show toast
        withAnimation(.spring()) {
            showSuccessToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut) {
                showSuccessToast = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showingPopup = true
                self.mode.wrappedValue.dismiss()
            }
        }
    }
    
    func reset() {
        var Parameters: NSMutableDictionary
        Parameters = ["atropine": 0.02, "lidocaine": 1, "fentanyl_min": 1, "fentanyl_max": 2, "vecDefasiculating": 0.01, "rocDefasiculating_min": 0.06, "rocDefasiculating_max": 0.12, "glycopyrrolate_min": 0.1, "glycopyrrolate_max": 0.2, "etomidate": 0.3, "ketamine": 1.0, "ketamineMax": 2.0, "propofol_min": 1, "propofol_max": 2, "versed_min": 0.1, "versed_max": 0.2, "cisatricurium": 0.2, "vecuronium": 0.01, "rocuronium_min": 0.6, "rocuronium_max": 1.2, "succs_min": 1, "succs_max": 1.5, "lidocaine_mgMl": 20, "mgPerML_atropine": 0.1, "mgPerML_fentanyl": 50.0, "mgPerML_vecDefasc": 1.0, "mgPerML_rocDefasc": 10.0, "hello": 0.2, "ml_etomidate": 2.0, "ml_ketamine": 100.0, "ml_versed": 5.0, "ml_propofol": 10.0, "ml_succs": 10.0, "ml_vec": 1.0, "ml_roc": 10.0, "ml_cis": 10.0]
        
        settings.lidocineTxtFieldmgkG = "\(Parameters.object(forKey: "lidocaine") as? Double ?? 0)"
        settings.atrophineTxtFieldmgkG = "\(Parameters.object(forKey: "atropine") as? Double ?? 0)"
        settings.fentaylTxtFieldmgkG1 = "\(Parameters.object(forKey: "fentanyl_min") as? Double ?? 0)"
        settings.fentaylTxtFieldmgkG2 = "\(Parameters.object(forKey: "fentanyl_max") as? Double ?? 0)"
        settings.vecuroniumTxtFieldmgkG = "\(Parameters.object(forKey: "vecDefasiculating") as? Double ?? 0)"
        settings.glycopyrrolateTxtFieldmgkG1 = "\(Parameters.object(forKey: "glycopyrolate_min") as? Double ?? 0)"
        settings.glycopyrrolateTxtFieldmgkG2 = "\(Parameters.object(forKey: "glycopyrolate_max") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgkG1 = "\(Parameters.object(forKey: "rocDefasiculating_min") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgkG2 = "\(Parameters.object(forKey: "rocDefasiculating_max") as? Double ?? 0)"
        settings.lidocineTxtFieldmgmL = "\(Parameters.object(forKey: "lidocaine_mgMl") as? Double ?? 0)"
        settings.atrophineTxtFieldmgmL = "\(Parameters.object(forKey: "mgPerML_atropine") as? Double ?? 0)"
        settings.fentanylTxtFieldmgmL = "\(Parameters.object(forKey: "mgPerML_fentanyl") as? Double ?? 0)"
        settings.vecuroniumTxtFieldmgmL = "\(Parameters.object(forKey: "mgPerML_vecDefasc") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgmL = "\(Parameters.object(forKey: "mgPerML_rocDefasc") as? Double ?? 0)"
        settings.glycopyrrolateTxtFieldmgmL = "\(Parameters.object(forKey: "hello") as? Double ?? 0)"
        settings.etomidateTxtFieldmgmL = "\(Parameters.object(forKey: "ml_etomidate") as? Double ?? 0)"
        settings.ketamineTxtFieldmgmL = "\(Parameters.object(forKey: "ml_ketamine") as? Double ?? 0)"
        settings.versedTxtFieldmgmL = "\(Parameters.object(forKey: "ml_versed") as? Double ?? 0)"
        settings.propofolTxtFieldmgmL = "\(Parameters.object(forKey: "ml_propofol") as? Double ?? 0)"
        settings.etomidateTxtFieldmgkG = "\(Parameters.object(forKey: "etomidate") as? Double ?? 0)"
        settings.ketamineTxtFieldmgkG1 = "\(Parameters.object(forKey: "ketamine") as? Double ?? 0)"
        settings.ketamineTxtFieldmgkG2 = "\(Parameters.object(forKey: "ketamineMax") as? Double ?? 0)"
        settings.versedTxtFieldmgkG1 = "\(Parameters.object(forKey: "versed_min") as? Double ?? 0)"
        settings.versedTxtFieldmgkG2 = "\(Parameters.object(forKey: "versed_max") as? Double ?? 0)"
        settings.propofolTxtFieldmgkG1 = "\(Parameters.object(forKey: "propofol_min") as? Double ?? 0)"
        settings.propofolTxtFieldmgkG2 = "\(Parameters.object(forKey: "propofol_max") as? Double ?? 0)"
        settings.succinylcholineTxtFieldmgmL = "\(Parameters.object(forKey: "ml_succs") as? Double ?? 0)"
        settings.cisatracuriumTxtFieldmgmL = "\(Parameters.object(forKey: "ml_cis") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgmL1 = "\(Parameters.object(forKey: "ml_roc") as? Double ?? 0)"
        settings.vecuroniumTxtFieldmgmL1 = "\(Parameters.object(forKey: "ml_vec") as? Double ?? 0)"
        settings.succinylcholineTxtFieldmgkG1 = "\(Parameters.object(forKey: "succs_min") as? Double ?? 0)"
        settings.succinylcholineTxtFieldmgkG2 = "\(Parameters.object(forKey: "succs_max") as? Double ?? 0)"
        settings.vecuroniumTxtFieldmgkG1 = "\(Parameters.object(forKey: "vecuronium") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgkG1_1 = "\(Parameters.object(forKey: "rocuronium_min") as? Double ?? 0)"
        settings.rocuroniumTxtFieldmgkG2_2 = "\(Parameters.object(forKey: "rocuronium_max") as? Double ?? 0)"
        settings.cisatracuriumTxtFieldmgkG = "\(Parameters.object(forKey: "cisatricurium") as? Double ?? 0)"
    }
}

// MARK: - Preview
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showingPopup: .constant(false))
    }
}
