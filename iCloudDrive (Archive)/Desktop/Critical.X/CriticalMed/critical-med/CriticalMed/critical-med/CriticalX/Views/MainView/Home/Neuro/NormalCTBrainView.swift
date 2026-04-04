//
//  NormalCTBrainView.swift
//  CriticalX
//
//  Created by Macbook 7 on 12/01/2022.
//

import SwiftUI

struct NormalCTBrainView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var sliderValue: Double = 1.0
    @State var stepperValue: Float = 0.5
    
    var body: some View {
        
        let stepperVal = Text("\(stepperValue, specifier: "%.1f")")
        let sliderVal = Text("\(sliderValue, specifier: "%.1f")")
        ZStack{
            CriticalDesign.Adaptive.canvas(for: colorScheme).ignoresSafeArea()
            
            VStack{
                ScrollView(.vertical, showsIndicators: false) {
                    VStack{
                        ZStack{
                            VStack{
                                switch sliderValue.rounded() {
                                case 1:
                                    Image("CT1")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                    
                                case 2:
                                    Image("CT2")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 3:
                                    Image("CT3")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 4:
                                    Image("CT4")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 5:
                                    Image("CT5")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 6:
                                    Image("CT6")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 7:
                                    Image("CT7")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 8:
                                    Image("CT8")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 9:
                                    Image("CT9")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 10:
                                    Image("CT10")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 11:
                                    Image("CT11")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 12:
                                    Image("CT12")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 13:
                                    Image("CT13")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 14:
                                    Image("CT14")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 15:
                                    Image("CT15")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 16:
                                    Image("CT16")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 17:
                                    Image("CT17")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 18:
                                    Image("CT18")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 19:
                                    Image("CT19")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 20:
                                    Image("CT20")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 21:
                                    Image("CT21")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 22:
                                    Image("CT22")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 23:
                                    Image("CT23")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 24:
                                    Image("CT24")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 25:
                                    Image("CT25")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 26:
                                    Image("CT26")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 27:
                                    Image("CT27")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 28:
                                    Image("CT28")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 29:
                                    Image("CT29")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 30:
                                    Image("CT30")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 31:
                                    Image("CT31")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 32:
                                    Image("CT32")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 33:
                                    Image("CT33")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                case 34:
                                    Image("CT34")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                default:
                                    Image("CT1")
                                }
                                Slider(value: $sliderValue, in: 1...34, step: Double.Stride(stepperValue.rounded()))
                                    .tint(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                                    .padding()
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                        }
                        
                        HStack{
                            
                            Text("CT Slice \(sliderVal)")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.orange_TerraCotta)
                            Spacer()
                            Text("Slide to view slices")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.BlueYonder)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95)
                        
                        VStack(spacing: 5){
                            Text("Speed \(stepperVal)")
                                .font(.system(size: 16).weight(.bold))
                                .foregroundColor(Color.criticalBlue)
                            
                            Stepper("", value: $stepperValue, in: 0...5,step: 0.5)
                                .labelsHidden()
                            
                            Text("▲ scrolling speed")
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.gunMetal_Gray)
                                .padding()
                            Button(action: {
                                sliderValue = 1
                            }) {
                                Text("Reset")
                                    .font(.system(size: 16, weight: .medium, design: .default))
                                    .foregroundColor(.paoloVeronese_green)
                            }
                        } //stepper vstack
                        .padding(.top, 10)
                        
                        HStack{
                            
                            Text("Minimum")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.vitalRed)
                                .onTapGesture {
                                    sliderValue = 1.0
                                }
                            Spacer()
                            Text("Maximum")
                                .font(.system(size: 15, weight: .medium, design: .default))
                                .foregroundColor(Color.BlueYonder)
                                .onTapGesture {
                                    sliderValue = 34.0
                                }
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                    }
                }
            }
            
        }
         
    }
    init() {
        UIScrollView.appearance().bounces = true
    }
}

struct NormalCTBrainView_Previews: PreviewProvider {
    static var previews: some View {
        NormalCTBrainView()
    }
}
