//
//  NIHDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 29/12/2021.
//

import SwiftUI
// import SwiftUITrackableScrollView

struct NIHDetailView: View {
    
    @State private var scrollViewContentOffset = CGFloat(0)
    
    @State private var isSelected1_1 = false
    @State private var isSelected1_2 = false
    @State private var isSelected1_3 = false
    @State private var isSelected1_4 = false
    
    @State private var isSelected2_1 = false
    @State private var isSelected2_2 = false
    @State private var isSelected2_3 = false
    
    @State private var isSelected3_1 = false
    @State private var isSelected3_2 = false
    @State private var isSelected3_3 = false
    
    @State private var isSelected4_1 = false
    @State private var isSelected4_2 = false
    @State private var isSelected4_3 = false
    
    @State private var isSelected5_1 = false
    @State private var isSelected5_2 = false
    @State private var isSelected5_3 = false
    @State private var isSelected5_4 = false
    
    @State private var isSelected6_1 = false
    @State private var isSelected6_2 = false
    @State private var isSelected6_3 = false
    @State private var isSelected6_4 = false
    
    @State private var isSelected7_1 = false
    @State private var isSelected7_2 = false
    @State private var isSelected7_3 = false
    @State private var isSelected7_4 = false
    @State private var isSelected7_5 = false
    @State private var isSelected7_6 = false
    
    @State private var isSelected8_1 = false
    @State private var isSelected8_2 = false
    @State private var isSelected8_3 = false
    @State private var isSelected8_4 = false
    @State private var isSelected8_5 = false
    @State private var isSelected8_6 = false
    
    @State private var isSelected9_1 = false
    @State private var isSelected9_2 = false
    @State private var isSelected9_3 = false
    @State private var isSelected9_4 = false
    @State private var isSelected9_5 = false
    @State private var isSelected9_6 = false
    
    @State private var isSelected10_1 = false
    @State private var isSelected10_2 = false
    @State private var isSelected10_3 = false
    @State private var isSelected10_4 = false
    @State private var isSelected10_5 = false
    @State private var isSelected10_6 = false
    
    @State private var isSelected11_1 = false
    @State private var isSelected11_2 = false
    @State private var isSelected11_3 = false
    
    @State private var isSelected12_1 = false
    @State private var isSelected12_2 = false
    @State private var isSelected12_3 = false
    
    @State private var isSelected13_1 = false
    @State private var isSelected13_2 = false
    @State private var isSelected13_3 = false
    @State private var isSelected13_4 = false
    
    @State private var isSelected14_1 = false
    @State private var isSelected14_2 = false
    @State private var isSelected14_3 = false
    @State private var isSelected14_4 = false
    
    @State private var isSelected15_1 = false
    @State private var isSelected15_2 = false
    @State private var isSelected15_3 = false
    
    @State private var totalCount = 0
    @State private var count1 = 0
    @State private var count2 = 0
    @State private var count3 = 0
    @State private var count4 = 0
    @State private var count5 = 0
    @State private var count6 = 0
    @State private var count7 = 0
    @State private var count8 = 0
    @State private var count9 = 0
    @State private var count10 = 0
    @State private var count11 = 0
    @State private var count12 = 0
    @State private var count13 = 0
    @State private var count14 = 0
    @State private var count15 = 0
    
    @State private var interpretationLabel = "No stroke symptoms"
    @State private var labelColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    var body: some View {
        
       
        ZStack {
            Color.mainBackgroundColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0){
                VStack{
                    Text("NIH Stroke Score")
                        .font(.system(size: 50).weight(.regular))
                        .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                }.padding()
                
                ZStack{
                    // Scrollreader gets position so you can scoll to certain segments using a button.
                    ScrollViewReader { scrollproxy in
                      
                    TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset){
                       
                        Text("\(totalCount)")
                            .font(.system(size: 55).weight(.regular))
                            .foregroundColor(Color.royal_blue)
                            .padding(.all, 5)
                       
                        Text(interpretationLabel)
                            .foregroundColor(Color(labelColor))
                            .font(.system(size: 20).weight(.medium))

                       
                        VStack{
                            Group {
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("1A: Level of Consciousness")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color.red)
                                    
                                    Button(action: {
                                        initView1(index: 1)
                                        count1 = isSelected1_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Alert - 0")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected1_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView1(index: 2)
                                        count1 = isSelected1_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Drowsy - 1")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected1_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView1(index: 3)
                                        count1 = isSelected1_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Obtunded - 2")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected1_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView1(index: 4)
                                        count1 = isSelected1_4 ? 3 : 0
                                        calculation()
                                    }) {
                                        Text("Comatose - 3")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected1_4 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                
                                VStack(spacing: 15){
                                    
                                    HStack{
                                        Text("1B: Asks Month & Age")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color.red)
                                    
                                    
                                    
                                    Button(action: {
                                        initView2(index: 1)
                                        count2 = isSelected2_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Both answered correctly - 0")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected2_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    
                                    
                                    Button(action: {
                                        initView2(index: 2)
                                        count2 = isSelected2_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("One answered correctly - 1")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected2_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    
                                    
                                    Button(action: {
                                        initView2(index: 3)
                                        count2 = isSelected2_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Neither answered correctly - 2")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected2_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("1C: Blinks Eyes & Squeezes Hands")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color.red)
                                    
                                    
                                    Button(action: {
                                        initView3(index: 1)
                                        count3 = isSelected3_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Both performed correctly - 0")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected3_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView3(index: 2)
                                        count3 = isSelected3_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("One performed correctly - 1")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected3_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView3(index: 3)
                                        count3 = isSelected3_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Neither performed correctly - 2")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected3_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("2: Horizontal Eye Movement")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color(UIColor.component(red: 78, green: 78, blue: 78, opacity: 1)))
                                    
                                    Button(action: {
                                        initView4(index: 1)
                                        count4 = isSelected4_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal - 0")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected4_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView4(index: 2)
                                        count4 = isSelected4_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Mild Gaze - 1")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected4_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView4(index: 3)
                                        count4 = isSelected4_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Complete Gaze - 2")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected4_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("3: Visual Fields: See objects in 4 quadrants")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 16))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color.criticalBabyBlue)
                                    
                                    Button(action: {
                                        initView5(index: 1)
                                        count5 = isSelected5_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected5_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView5(index: 2)
                                        count5 = isSelected5_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Partial hemianopia - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected5_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView5(index: 3)
                                        count5 = isSelected5_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Complete hemianopia - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected5_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView5(index: 4)
                                        count5 = isSelected5_4 ? 3 : 0
                                        calculation()
                                    }) {
                                        Text("Bilateral hemianopia - 3")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected5_4 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                            }// group 1
                            
                            Group {
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("4: Facial palsy")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 18))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color(UIColor.component(red: 191, green: 134, blue: 178, opacity: 1)))
                                    
                                    Button(action: {
                                        initView6(index: 1)
                                        count6 = isSelected6_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected6_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView6(index: 2)
                                        count6 = isSelected6_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Minor Paralysis - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected6_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView6(index: 3)
                                        count6 = isSelected6_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Partial Paralysis - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected6_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView6(index: 4)
                                        count6 = isSelected6_4 ? 3 : 0
                                        calculation()
                                    }) {
                                        Text("Complete Paralysis - 3")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected6_4 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("5A: Left Arm: Hold arm straight out")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 18))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color(UIColor.component(red: 95, green: 140, blue: 216, opacity: 1)))
                                    
                                    Button(action: {
                                        initView7(index: 1)
                                        count7 = isSelected7_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal: No drifts - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected7_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView7(index: 2)
                                        count7 = isSelected7_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Drifts downward but in < 10 sec - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected7_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView7(index: 3)
                                        count7 = isSelected3_1 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Drifts to bed within 10 sec - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected7_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView7(index: 4)
                                        count7 = isSelected7_4 ? 3 : 0
                                        calculation()
                                    }) {
                                        Text("Movement not against gravity - 3")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected7_4 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView7(index: 5)
                                        count7 = isSelected7_5 ? 4 : 0
                                        calculation()
                                    }) {
                                        Text("Complete Paralysis - 4")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected7_5 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView7(index: 6)
                                        count7 = isSelected7_6 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Amputation or fusion - N/A")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected7_6 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("5B: Right Arm: Hold arm straight out")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 18))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color(UIColor.component(red: 78, green: 78, blue: 78, opacity: 1)))
                                    
                                    Button(action: {
                                        initView8(index: 1)
                                        count8 = isSelected8_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal: No drifts - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected8_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView8(index: 2)
                                        count8 = isSelected8_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Drifts downward but in < 10 sec - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected8_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView8(index: 3)
                                        count8 = isSelected8_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Drifts to bed within 10 sec - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected8_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView8(index: 4)
                                        count8 = isSelected8_4 ? 3 : 0
                                        calculation()
                                    }) {
                                        Text("Movement not against gravity - 3")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected8_4 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView8(index: 5)
                                        count8 = isSelected8_5 ? 4 : 0
                                        calculation()
                                    }) {
                                        Text("Complete Paralysis - 4")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected8_5 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView8(index: 6)
                                        count8 = isSelected8_6 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Amputation or fusion - N/A")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected8_6 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("6A: Left Leg: Keep leg off the bed")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 18))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color(UIColor.component(red: 95, green: 140, blue: 216, opacity: 1)))
                                    
                                    Button(action: {
                                        initView9(index: 1)
                                        count9 = isSelected9_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal: No drifts - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected9_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView9(index: 2)
                                        count9 = isSelected9_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Drifts downward but in < 5 sec - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected9_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView9(index: 3)
                                        count9 = isSelected9_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Drifts to bed within 5 sec - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected9_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView9(index: 4)
                                        count9 = isSelected9_4 ? 3 : 0
                                        calculation()
                                    }) {
                                        Text("Movement not against gravity - 3")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected9_4 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView9(index: 5)
                                        count9 = isSelected9_5 ? 4 : 0
                                        calculation()
                                    }) {
                                        Text("Complete Paralysis - 4")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected9_5 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView9(index: 6)
                                        count9 = isSelected9_6 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Amputation or fusion - N/A")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected9_6 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("6B: Right Leg: Keep leg off the bed")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 18))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color(UIColor.component(red: 78, green: 78, blue: 78, opacity: 1)))
                                    
                                    Button(action: {
                                        initView10(index: 1)
                                        count10 = isSelected10_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal: No drifts - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected10_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView10(index: 2)
                                        count10 = isSelected10_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Drifts downward but in < 5 sec - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected10_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView10(index: 3)
                                        count10 = isSelected10_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Drifts to bed within 5 sec - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected10_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView10(index: 4)
                                        count10 = isSelected10_4 ? 3 : 0
                                        calculation()
                                    }) {
                                        Text("Movement not against gravity - 3")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected10_4 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView10(index: 5)
                                        count10 = isSelected10_5 ? 4 : 0
                                        calculation()
                                    }) {
                                        Text("Complete Paralysis - 4")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected10_5 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView10(index: 6)
                                        count10 = isSelected10_6 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Amputation or Fusion - N/A")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected10_6 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                                
                            }// group 2
                            
                            Group {
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("7: Limb Ataxia - Finger to nose, Heel-knee-shin")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 15))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color(UIColor.component(red: 85, green: 170, blue: 104, opacity: 1)))
                                    
                                    Button(action: {
                                        initView11(index: 1)
                                        count11 = isSelected11_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Absent - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected11_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView11(index: 2)
                                        count11 = isSelected11_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Present in one limb - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected11_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView11(index: 3)
                                        count11 = isSelected11_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Present in two or more limbs - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected11_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("8: Sensation")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 18))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color(UIColor.component(red: 217, green: 130, blue: 59, opacity: 1)))
                                    
                                    Button(action: {
                                        initView12(index: 1)
                                        count12 = isSelected12_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal, no sensory loss - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected12_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView12(index: 2)
                                        count12 = isSelected12_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Mild to Moderate - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected12_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView12(index: 3)
                                        count12 = isSelected12_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Severe, complete loss of sensation - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected12_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("9: Language / Aphasia")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 18))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color(UIColor.component(red: 46, green: 46, blue: 46, opacity:  1)))
                                    
                                    Button(action: {
                                        initView13(index: 1)
                                        count13 = isSelected13_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected13_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView13(index: 2)
                                        count13 = isSelected13_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Mild to Moderate Aphasia - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected13_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView13(index: 3)
                                        count13 = isSelected13_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Severe Aphasia - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected13_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView13(index: 4)
                                        count13 = isSelected13_4 ? 3 : 0
                                        calculation()
                                    }) {
                                        Text("Mute - 3")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected13_4 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("10: Dysarthria")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 18))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color.yellowColor)
                                    
                                    Button(action: {
                                        initView14(index: 1)
                                        count14 = isSelected14_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Normal - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected14_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView14(index: 2)
                                        count14 = isSelected14_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Mild to Moderate Slurred Speech - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected14_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView14(index: 3)
                                        count14 = isSelected14_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Severe Aphasia - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected14_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView14(index: 4)
                                        count14 = isSelected14_4 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Intubated or other physical barrier - N/A")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected14_4 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                
                                
                                VStack(spacing: 5){
                                    
                                    HStack{
                                        Text("11: Neglect")
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 18))
                                            .foregroundColor(Color.white)
                                            .padding(.leading, 15)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                    .background(Color.red)
                                    
                                    Button(action: {
                                        initView15(index: 1)
                                        count15 = isSelected15_1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("No Abnormality - 0")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected15_1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initView15(index: 2)
                                        count15 = isSelected15_2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Partial Neglect - 1")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected15_2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initView15(index: 3)
                                        count15 = isSelected15_3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Complete / Profound Neglect - 2")
                                           .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(isSelected15_3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .shadow(radius: 8)
                                .padding(.top, 10)
                                .padding(.bottom, 30)
                                
                            }// group 3
                            Button(action: { withAnimation { scrollproxy.scrollTo(.top)
                            }}) {
                                HStack {
                                    Image (systemName: "arrow.up.to.line.circle.fill")
                                        .font(.largeTitle)
                                }
                            }
                            .padding()
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(Color.white).background(RoundedRectangle(cornerRadius: 8).fill(Color.royal_blue))
                        }
                        .padding(.bottom, 25)
                    }
                    .padding(.top, 15)
                }
                    if scrollViewContentOffset > 30 {
                        VStack{
                            ZStack{
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 50, height: 50, alignment: .leading)
                                Text("\(totalCount)")
                                    .font(.system(size: 25).weight(.regular))
                                    .foregroundColor(Color.white)
                            }
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.95, alignment: .leading)
                        .shadow(radius: 8)
                        .padding(.top, 30)
                        
                    }
                }
            }
        }
         
    }
}

struct NIHDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NIHDetailView()
    }
}

extension NIHDetailView {
    
    func initView1(index: Int){
        
        switch index {
        case 1:
            isSelected1_1 = !isSelected1_1
            isSelected1_2 = false
            isSelected1_3 = false
            isSelected1_4 = false
        case 2:
            isSelected1_2 = !isSelected1_2
            isSelected1_1 = false
            isSelected1_3 = false
            isSelected1_4 = false
        case 3:
            isSelected1_3 = !isSelected1_3
            isSelected1_2 = false
            isSelected1_1 = false
            isSelected1_4 = false
        case 4:
            isSelected1_4 = !isSelected1_4
            isSelected1_2 = false
            isSelected1_3 = false
            isSelected1_1 = false
        default:
            break
        }
    }
    
    func initView2(index: Int){
        
        switch index {
        case 1:
            isSelected2_1 = !isSelected2_1
            isSelected2_2 = false
            isSelected2_3 = false
        case 2:
            isSelected2_2 = !isSelected2_2
            isSelected2_1 = false
            isSelected2_3 = false
        case 3:
            isSelected2_3 = !isSelected2_3
            isSelected2_2 = false
            isSelected2_1 = false
        default:
            break
        }
    }
    
    func initView3(index: Int){
        
        switch index {
        case 1:
            isSelected3_1 = !isSelected3_1
            isSelected3_2 = false
            isSelected3_3 = false
        case 2:
            isSelected3_2 = !isSelected3_2
            isSelected3_1 = false
            isSelected3_3 = false
        case 3:
            isSelected3_3 = !isSelected3_3
            isSelected3_2 = false
            isSelected3_1 = false
        default:
            break
        }
    }
    
    func initView4(index: Int){
        
        switch index {
        case 1:
            isSelected4_1 = !isSelected4_1
            isSelected4_2 = false
            isSelected4_3 = false
        case 2:
            isSelected4_2 = !isSelected4_2
            isSelected4_1 = false
            isSelected4_3 = false
        case 3:
            isSelected4_3 = !isSelected4_3
            isSelected4_2 = false
            isSelected4_1 = false
        default:
            break
        }
    }
    
    func initView6(index: Int){
        
        switch index {
        case 1:
            isSelected6_1 = !isSelected6_1
            isSelected6_2 = false
            isSelected6_3 = false
            isSelected6_4 = false
        case 2:
            isSelected6_2 = !isSelected6_2
            isSelected6_1 = false
            isSelected6_3 = false
            isSelected6_4 = false
        case 3:
            isSelected6_3 = !isSelected6_3
            isSelected6_2 = false
            isSelected6_1 = false
            isSelected6_4 = false
        case 4:
            isSelected6_4 = !isSelected6_4
            isSelected6_2 = false
            isSelected6_3 = false
            isSelected6_1 = false
        default:
            break
        }
    }
    
    func initView5(index: Int){
        
        switch index {
        case 1:
            isSelected5_1 = !isSelected5_1
            isSelected5_2 = false
            isSelected5_3 = false
            isSelected5_4 = false
        case 2:
            isSelected5_2 = !isSelected5_2
            isSelected5_1 = false
            isSelected5_3 = false
            isSelected5_4 = false
        case 3:
            isSelected5_3 = !isSelected5_3
            isSelected5_2 = false
            isSelected5_1 = false
            isSelected5_4 = false
        case 4:
            isSelected5_4 = !isSelected5_4
            isSelected5_2 = false
            isSelected5_3 = false
            isSelected5_1 = false
        default:
            break
        }
    }
    
    func initView7(index: Int){
        
        switch index {
        case 1:
            isSelected7_1 = !isSelected7_1
            isSelected7_2 = false
            isSelected7_3 = false
            isSelected7_4 = false
            isSelected7_5 = false
            isSelected7_6 = false
        case 2:
            isSelected7_2 = !isSelected7_2
            isSelected7_1 = false
            isSelected7_3 = false
            isSelected7_4 = false
            isSelected7_5 = false
            isSelected7_6 = false
        case 3:
            isSelected7_3 = !isSelected7_3
            isSelected7_2 = false
            isSelected7_1 = false
            isSelected7_4 = false
            isSelected7_5 = false
            isSelected7_6 = false
        case 4:
            isSelected7_4 = !isSelected7_4
            isSelected7_2 = false
            isSelected7_3 = false
            isSelected7_1 = false
            isSelected7_5 = false
            isSelected7_6 = false
        case 5:
            isSelected7_5 = !isSelected7_5
            isSelected7_2 = false
            isSelected7_3 = false
            isSelected7_4 = false
            isSelected7_1 = false
            isSelected7_6 = false
        case 6:
            isSelected7_6 = !isSelected7_6
            isSelected7_2 = false
            isSelected7_3 = false
            isSelected7_4 = false
            isSelected7_5 = false
            isSelected7_1 = false
        default:
            break
        }
    }
    
    func initView8(index: Int){
        
        switch index {
        case 1:
            isSelected8_1 = !isSelected8_1
            isSelected8_2 = false
            isSelected8_3 = false
            isSelected8_4 = false
            isSelected8_5 = false
            isSelected8_6 = false
        case 2:
            isSelected8_2 = !isSelected8_2
            isSelected8_1 = false
            isSelected8_3 = false
            isSelected8_4 = false
            isSelected8_5 = false
            isSelected8_6 = false
        case 3:
            isSelected8_3 = !isSelected8_3
            isSelected8_2 = false
            isSelected8_1 = false
            isSelected8_4 = false
            isSelected8_5 = false
            isSelected8_6 = false
        case 4:
            isSelected8_4 = !isSelected8_4
            isSelected8_2 = false
            isSelected8_3 = false
            isSelected8_1 = false
            isSelected8_5 = false
            isSelected8_6 = false
        case 5:
            isSelected8_5 = !isSelected8_5
            isSelected8_2 = false
            isSelected8_3 = false
            isSelected8_4 = false
            isSelected8_1 = false
            isSelected8_6 = false
        case 6:
            isSelected8_6 = !isSelected8_6
            isSelected8_2 = false
            isSelected8_3 = false
            isSelected8_4 = false
            isSelected8_5 = false
            isSelected8_1 = false
        default:
            break
        }
    }
    
    func initView9(index: Int){
        
        switch index {
        case 1:
            isSelected9_1 = !isSelected9_1
            isSelected9_2 = false
            isSelected9_3 = false
            isSelected9_4 = false
            isSelected9_5 = false
            isSelected9_6 = false
        case 2:
            isSelected9_2 = !isSelected9_2
            isSelected9_1 = false
            isSelected9_3 = false
            isSelected9_4 = false
            isSelected9_5 = false
            isSelected9_6 = false
        case 3:
            isSelected9_3 = !isSelected9_3
            isSelected9_2 = false
            isSelected9_1 = false
            isSelected9_4 = false
            isSelected9_5 = false
            isSelected9_6 = false
        case 4:
            isSelected9_4 = !isSelected9_4
            isSelected9_2 = false
            isSelected9_3 = false
            isSelected9_1 = false
            isSelected9_5 = false
            isSelected9_6 = false
        case 5:
            isSelected9_5 = !isSelected9_5
            isSelected9_2 = false
            isSelected9_3 = false
            isSelected9_4 = false
            isSelected9_1 = false
            isSelected9_6 = false
        case 6:
            isSelected9_6 = !isSelected9_6
            isSelected9_2 = false
            isSelected9_3 = false
            isSelected9_4 = false
            isSelected9_5 = false
            isSelected9_1 = false
        default:
            break
        }
    }
    
    func initView10(index: Int){
        
        switch index {
        case 1:
            isSelected10_1 = !isSelected10_1
            isSelected10_2 = false
            isSelected10_3 = false
            isSelected10_4 = false
            isSelected10_5 = false
            isSelected10_6 = false
        case 2:
            isSelected10_2 = !isSelected10_2
            isSelected10_1 = false
            isSelected10_3 = false
            isSelected10_4 = false
            isSelected10_5 = false
            isSelected10_6 = false
        case 3:
            isSelected10_3 = !isSelected10_3
            isSelected10_2 = false
            isSelected10_1 = false
            isSelected10_4 = false
            isSelected10_5 = false
            isSelected10_6 = false
        case 4:
            isSelected10_4 = !isSelected10_4
            isSelected10_2 = false
            isSelected10_3 = false
            isSelected10_1 = false
            isSelected10_5 = false
            isSelected10_6 = false
        case 5:
            isSelected10_5 = !isSelected10_5
            isSelected10_2 = false
            isSelected10_3 = false
            isSelected10_4 = false
            isSelected10_1 = false
            isSelected10_6 = false
        case 6:
            isSelected10_6 = !isSelected10_6
            isSelected10_2 = false
            isSelected10_3 = false
            isSelected10_4 = false
            isSelected10_5 = false
            isSelected10_1 = false
        default:
            break
        }
    }
    
    func initView11(index: Int){
        
        switch index {
        case 1:
            isSelected11_1 = !isSelected11_1
            isSelected11_2 = false
            isSelected11_3 = false
        case 2:
            isSelected11_2 = !isSelected11_2
            isSelected11_1 = false
            isSelected11_3 = false
        case 3:
            isSelected11_3 = !isSelected11_3
            isSelected11_2 = false
            isSelected11_1 = false
        default:
            break
        }
    }
    
    func initView12(index: Int){
        
        switch index {
        case 1:
            isSelected12_1 = !isSelected12_1
            isSelected12_2 = false
            isSelected12_3 = false
        case 2:
            isSelected12_2 = !isSelected12_2
            isSelected12_1 = false
            isSelected12_3 = false
        case 3:
            isSelected12_3 = !isSelected12_3
            isSelected12_2 = false
            isSelected12_1 = false
        default:
            break
        }
    }
    
    func initView13(index: Int){
        
        switch index {
        case 1:
            isSelected13_1 = !isSelected13_1
            isSelected13_2 = false
            isSelected13_3 = false
            isSelected13_4 = false
        case 2:
            isSelected13_2 = !isSelected13_2
            isSelected13_1 = false
            isSelected13_3 = false
            isSelected13_4 = false
        case 3:
            isSelected13_3 = !isSelected13_3
            isSelected13_2 = false
            isSelected13_1 = false
            isSelected13_4 = false
        case 4:
            isSelected13_4 = !isSelected13_4
            isSelected13_2 = false
            isSelected13_3 = false
            isSelected13_1 = false
        default:
            break
        }
    }
    
    func initView14(index: Int){
        
        switch index {
        case 1:
            isSelected14_1 = !isSelected14_1
            isSelected14_2 = false
            isSelected14_3 = false
            isSelected14_4 = false
        case 2:
            isSelected14_2 = !isSelected14_2
            isSelected14_1 = false
            isSelected14_3 = false
            isSelected14_4 = false
        case 3:
            isSelected14_3 = !isSelected14_3
            isSelected14_2 = false
            isSelected14_1 = false
            isSelected14_4 = false
        case 4:
            isSelected14_4 = !isSelected14_4
            isSelected14_2 = false
            isSelected14_3 = false
            isSelected14_1 = false
        default:
            break
        }
    }
    
    func initView15(index: Int){
        
        switch index {
        case 1:
            isSelected15_1 = !isSelected15_1
            isSelected15_2 = false
            isSelected15_3 = false
        case 2:
            isSelected15_2 = !isSelected15_2
            isSelected15_1 = false
            isSelected15_3 = false
        case 3:
            isSelected15_3 = !isSelected15_3
            isSelected15_2 = false
            isSelected15_1 = false
        default:
            break
        }
    }
    
    func calculation(){
        
        totalCount = count1 + count2 + count3 + count4 + count5 + count6 + count7 + count8 + count9 + count10 + count11 + count12 + count13 + count14 + count15
        
        switch totalCount {
        
        case 0 :
            
            interpretationLabel = "No stroke symptoms"
            labelColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        case 1...4 :
            
            interpretationLabel = "Minor stroke"
            labelColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        
        case 5...15 :
            
            interpretationLabel = "Moderate stroke"
            labelColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        case 16...20:
            
            interpretationLabel = "Moderate to severe stroke"
            labelColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        case 21...42 :
           
            interpretationLabel = "Severe stroke"
            labelColor = #colorLiteral(red: 0.8156862745, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
            
        default:
            break
        }
    }
}
