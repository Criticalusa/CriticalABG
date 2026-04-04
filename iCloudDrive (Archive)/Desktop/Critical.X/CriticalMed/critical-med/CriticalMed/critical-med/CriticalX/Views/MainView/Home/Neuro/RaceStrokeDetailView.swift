//
//  RaceStrokeDetailView.swift
//  CriticalX
//
//  Created by Macbook 7 on 28/12/2021.
//

import SwiftUI

struct RaceStrokeDetailView: View {
    
    @State private var isSelectedFacial1 = false
    @State private var isSelectedFacial2 = false
    @State private var isSelectedFacial3 = false
    
    @State private var isSelectedArm1 = false
    @State private var isSelectedArm2 = false
    @State private var isSelectedArm3 = false

    @State private var isSelectedLeg1 = false
    @State private var isSelectedLeg2 = false
    @State private var isSelectedLeg3 = false
    
    @State private var isHeadSelcet1 = false
    @State private var isHeadSelcet2 = false
    
    @State private var isHemiSelect1 = false
    @State private var isHemiSelect2 = false
    
    @State private var isHemiLeft1 = false
    @State private var isHemiLeft2 = false
    @State private var isHemiLeft3 = false
    
    @State private var isHemiRight1 = false
    @State private var isHemiRight2 = false
    @State private var isHemiRight3 = false
    
    @State private var totalCount = 0
    @State private var facialCount = 0
    @State private var armCount = 0
    @State private var legCount = 0
    @State private var headCount = 0
    @State private var hemiCount = 0

    @State private var sensitivityResultLabel = " "
    @State private var specificityResultLabel = " "

    @State private var hemiTitle = "Hemiparesis?"
    @State private var resultDescriptionLabel = "Check for left or right sided hemiparesis?"

    
    // MARK: BodyView
    var body: some View {
        
        let stroke = Text("STROKE")
            .foregroundColor(Color.criticalBlue)
        
        let senstivity = Text("Sensitivity")
            .foregroundColor(Color.red)
        
        let specific = Text("Specificity")
            .foregroundColor(Color.red)
        
        
        // MARK: Title placed outside of the scrollView
        ZStack {
            Color.mainBackgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0){
                
                // MARK: Title and Subtitle
                VStack(spacing: 10){
                    
                    HStack (spacing: 10) {
                        
                        Text("RACE \(stroke)")
                            .font(.system(size: 30).weight(.bold))
                            .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                            .padding(.leading, 0)
                        
                        Image("Neuro")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding(.leading, 25)
                            .shadow(radius: 8)
                    }
                    
                    Text("Rapid Arterial Occlusion Evaluation")
                        .font(.system(size: 14).weight(.regular))
                        .foregroundColor(Color(UIColor.component(red: 95, green: 94, blue: 95, opacity: 1)))
                }
                .padding()
                
                
                // MARK: ScrollView and its contents
                ScrollView(.vertical, showsIndicators: false){
                    
                    ZStack {
                        
                        VStack (spacing: 0){
                            
                            VStack(spacing: 0){
                                
                                // MARK: Facial Palsy Button
                                HStack{
                                    Text("Facial Palsy")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .padding(.leading, 15)
                                    
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                .background(Color.red_matte)
                                
                                
                                Button(action: {
                                    initFacialView(index: 1)
                                    facialCount = 0
                                    calculation()
                                }) {
                                    Text("Normal to Mild - 0")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelectedFacial1 ? Color.red : Color.darkGray)
                                        .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                        .padding(.all, 5)
                                }
                                .padding(.top, 10)
                                
                                Button(action: {
                                    initFacialView(index: 2)
                                    facialCount = isSelectedFacial2 ? 1 : 0
                                    calculation()
                                }) {
                                    Text("Mild -  1")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelectedFacial2 ? Color.red : Color.darkGray)
                                        .padding(.all, 5)
                                }
                                
                                Button(action: {
                                    initFacialView(index: 3)
                                    facialCount = isSelectedFacial3 ? 2 : 0
                                    calculation()
                                }) {
                                    Text("Moderate to Severe -  2")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelectedFacial3 ? Color.red : Color.darkGray)
                                        .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                        .padding(.all, 5)
                                }
                                .padding(.bottom, 20)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                            .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.babyPowderWhite))
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            .shadow(radius: 2)
                            
                            
                            //MARK: Blue Line
                            VStack{}
                            .frame(width: 16, height: 22, alignment: .leading)
                            .background(Color.criticalBlue)
                            
                            
                            
                            
                            //   MARK: Motor impairment stack
                            VStack(spacing: 0){
                                
                                HStack{
                                    
                                    Text("Arm Motor Impairment")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .padding(.leading, 15)
                                    
                                    Spacer()
                                    
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                .background(Color(UIColor.component(red: 77, green: 153, blue: 94, opacity: 1)))
                                
                                Button(action: {
                                    initArmView(index: 1)
                                    armCount = isSelectedArm1 ? 0 : 0
                                    calculation()
                                }) {
                                    Text("Normal to Mild -  0")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelectedArm1 ? Color.red : Color.darkGray)
                                        .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                        .padding(.all, 5)
                                }
                                .padding(.top, 10)
                                
                                Button(action: {
                                    initArmView(index: 2)
                                    armCount = isSelectedArm2 ? 1 : 0
                                    calculation()
                                }) {
                                    Text("Mild -  1")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelectedArm2 ? Color.red : Color.darkGray)
                                        .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                        .padding(.all, 5)
                                }
                                
                                Button(action: {
                                    initArmView(index: 3)
                                    armCount = isSelectedArm3 ? 2 : 0
                                    calculation()
                                }) {
                                    Text("Moderate to Severe -  2")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelectedArm3 ? Color.red : Color.darkGray)
                                        .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                        .padding(.all, 5)
                                }
                                .padding(.bottom, 20)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                            .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.babyPowderWhite))
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            .shadow(radius: 2)
                            // .padding(.top, 10)
                            
                            //   MARK: Blue Line 2
                            VStack{}
                            .frame(width: 16, height: 22, alignment: .leading)
                            //.background(Color(UIColor.component(red: 216, green: 216, blue: 216, opacity: 1)))
                            .background(Color.criticalBlue)
                            
                            
                            //   MARK: Leg Impairment
                            VStack(spacing: 0){
                                
                                HStack{
                                    Text("Leg Motor Impairment")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .padding(.leading, 15)
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                .background(Color.criticalBlue)
                                
                                Button(action: {
                                    initLegView(index: 1)
                                    legCount = isSelectedLeg1 ? 0 : 0
                                    calculation()
                                }) {
                                    Text("Normal to Mild - 0")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelectedLeg1 ? Color.red : Color.darkGray)
                                        .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                        .padding(.all, 5)
                                }
                                .padding(.top, 10)
                                
                                Button(action: {
                                    initLegView(index: 2)
                                    legCount = isSelectedLeg2 ? 1 : 0
                                    calculation()
                                }) {
                                    Text("Mild - 1")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelectedLeg2 ? Color.red : Color.darkGray)
                                        .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                        .padding(.all, 5)
                                }
                                
                                Button(action: {
                                    initLegView(index: 3)
                                    legCount = isSelectedLeg3 ? 2 : 0
                                    calculation()
                                }) {
                                    Text("Moderate to Severe - 2")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelectedLeg3 ? Color.red : Color.darkGray)
                                        .frame(width: UIScreen.main.bounds.width * 0.90, height: 30)
                                        .padding(.all, 5)
                                }
                                .padding(.bottom, 20)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                            .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.babyPowderWhite))
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            .shadow(radius: 2)
                            //.padding(.top, 10)
                            
                            //   MARK: Blue line 3
                            //Joining Bar in the center
                                                      
                              
                            
                            //MARK: Gaze and Deviation
                            HStack(spacing: 10){
                                
                                VStack(spacing: 5){
                                    HStack{
                                        Text("Head & Gaze deviation")
                                            .fontWeight(.bold)
                                            .frame(width: UIScreen.main.bounds.width * 0.46, alignment: .center)
                                            .font(.subheadline)
                                            .foregroundColor(Color.white)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.45, height: 37, alignment: .center)
                                    .background(Color(UIColor.component(red: 84, green: 150, blue: 219, opacity: 1)))
                                    
                                    Button(action: {
                                        initHeadView(index: 1)
                                        headCount = isHeadSelcet1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Absent - 0")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(isHeadSelcet1 ? Color.red : Color.darkGray)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    
                                    Button(action: {
                                        initHeadView(index: 2)
                                        headCount = isHeadSelcet2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Present - 1")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(isHeadSelcet2 ? Color.red : Color.darkGray)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.45)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .padding(.top, 10)
                                .shadow(radius: 2)
                                
                                //MARK: Hemiparesis
                                VStack(spacing:5){
                                    HStack{
                                        Text(hemiTitle)
                                            .frame(width: UIScreen.main.bounds.width * 0.46, alignment: .center)
                                            .font(.custom(AssetConstants.fontSFProHeavy, size: 14))
                                            .foregroundColor(Color.white)
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.46, height: 37)
                                    .background(Color(UIColor.component(red: 84, green: 150, blue: 219, opacity: 1)))
                                    
                                    Button(action: {
                                        initHemiView(index: 1)
                                    }) {
                                        Text("Left")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(isHemiSelect1 ? Color.red : Color.darkGray)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 10)
                                    Button(action: {
                                        initHemiView(index: 2)
                                    }) {
                                        Text("Right")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(isHemiSelect2 ? Color.red : Color.darkGray)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.46)
                                .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                                .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                                .padding(.top, 10)
                                .shadow(radius: 2)
                                
                                
                            } // HStack
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                            .padding(.top, 10)
                            
                            VStack(spacing: 5){
                                HStack{
                                    Text(hemiTitle)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .padding(.leading, 15)
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                .background(Color.rich_Black)
                                
                                Text(resultDescriptionLabel)
                                    .foregroundColor(Color.darkGray)
                                    .font(.body)
                                    .padding(.top, 5)
                                    .padding(.bottom, 20)
                                    .padding(.horizontal, 10)
                                
                                if isHemiSelect1 {
                                    Button(action: {
                                        initHemiLeft(index: 1)
                                        hemiCount = isHemiLeft1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Pt. recognizes their arm & the impairment - 0")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .lineLimit(2)
                                            .foregroundColor(isHemiLeft1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 5)
                                    
                                    Button(action: {
                                        initHemiLeft(index: 2)
                                        hemiCount = isHemiLeft2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Pt. recognizes their arm or the impairment - 1")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .lineLimit(2)
                                            .foregroundColor(isHemiLeft2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initHemiLeft(index: 3)
                                        hemiCount = isHemiLeft3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Doesn't recognizes their arm or the impairment - 2")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .lineLimit(2)
                                            .foregroundColor(isHemiLeft3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                
                                if isHemiSelect2 {
                                    Button(action: {
                                        initHemiRight(index: 1)
                                        hemiCount = isHemiRight1 ? 0 : 0
                                        calculation()
                                    }) {
                                        Text("Peforms both tasks correctly - 0")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .lineLimit(2)
                                            .foregroundColor(isHemiRight1 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90)
                                            .padding(.all, 5)
                                    }
                                    .padding(.top, 5)
                                    
                                    Button(action: {
                                        initHemiRight(index: 2)
                                        hemiCount = isHemiRight2 ? 1 : 0
                                        calculation()
                                    }) {
                                        Text("Peforms one tasks correctly - 1")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .lineLimit(2)
                                            .foregroundColor(isHemiRight2 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90)
                                            .padding(.all, 5)
                                    }
                                    
                                    Button(action: {
                                        initHemiRight(index: 3)
                                        hemiCount = isHemiRight3 ? 2 : 0
                                        calculation()
                                    }) {
                                        Text("Peforms neither - 2")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .lineLimit(2)
                                            .foregroundColor(isHemiRight3 ? Color.red : Color.darkGray)
                                            .frame(width: UIScreen.main.bounds.width * 0.90)
                                            .padding(.all, 5)
                                    }
                                    .padding(.bottom, 20)
                                }
                                
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                            .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            .padding(.top, 10)
                            
                            
                            //MARK: Result
                            VStack(spacing: 0){
                                HStack{
                                    Text("Result")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .padding(.leading, 15)
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: 37)
                                .background(Color.green)
                                
                                
                                Text("\(totalCount)")
                                    .foregroundColor(Color(UIColor.component(red: 95, green: 134, blue: 161, opacity: 1)))
                                    .font(.custom(AssetConstants.fontSFProDisplayBold, size: 40))
                                    .padding(.top, 15)
                                
                                Text("POINTS")
                                    .foregroundColor(Color(UIColor.component(red: 152, green: 164, blue: 166, opacity: 1)))
                                    .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 12))
                                
                                HStack{
                                    
                                    VStack(spacing: 5){
                                        
                                        HStack{
                                            Spacer()
                                            Text(sensitivityResultLabel)
                                                .foregroundColor(Color.red)
                                                .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 25))
                                            Spacer()
                                        }
 
                                        HStack{
                                            Spacer()
                                            Text("\(senstivity) for large\n vessel occlusion.")
                                                .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 15))
                                                .foregroundColor(Color(UIColor.component(red: 152, green: 164, blue: 166, opacity: 1)))
                                        }

                                    }
                                    .padding(.bottom, 20)
                                    
                                    Spacer()
                                    
                                    //MARK: Final Result Stack with numbers
                                    VStack(spacing: 5){
                                        
                                        HStack{
                                            Spacer()
                                            Text(specificityResultLabel)
                                                .foregroundColor(Color.red)
                                                .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 25))
                                            Spacer()
                                        }
                                        
                                        HStack{
                                            Spacer()
                                            Text("\(specific) for large\n vessel occlusion.")
                                                .font(.custom(AssetConstants.fontSFProDisplayRegular, size: 14))
                                                .foregroundColor(Color(UIColor.component(red: 152, green: 164, blue: 166, opacity: 1)))
                                            Spacer()
                                        }
                                        

                                    }
                                    .padding(.bottom, 20)
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.8)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.95)
                            .background(RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 8).fill(Color.white))
                            .shadow(color: Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 0.05)), radius: 2, x: 0, y: 1)
                            .padding(.top, 10)
                            
                        }
                        .padding(.bottom, 25)
                    }
                    
                    
                }
                .padding(.top, 15)
            }
        }
         
    }
    
    init() {
        UIScrollView.appearance().bounces = true
    }
    
}

struct RaceStrokeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RaceStrokeDetailView()
    }
}

extension RaceStrokeDetailView {
    
    func initFacialView(index: Int){
        
        switch index {
        case 1:
            isSelectedFacial1 = !isSelectedFacial1
            isSelectedFacial2 = false
            isSelectedFacial3 = false
        case 2:
            isSelectedFacial2 = !isSelectedFacial2
            isSelectedFacial1 = false
            isSelectedFacial3 = false
        case 3:
            isSelectedFacial3 = !isSelectedFacial3
            isSelectedFacial2 = false
            isSelectedFacial1 = false
        default:
            break
        }

    }
    
    func initArmView(index: Int){
        
        
        switch index {
        case 1:
            isSelectedArm1 = !isSelectedArm1
            isSelectedArm2 = false
            isSelectedArm3 = false
        case 2:
            isSelectedArm2 = !isSelectedArm2
            isSelectedArm1 = false
            isSelectedArm3 = false
        case 3:
            isSelectedArm3 = !isSelectedArm3
            isSelectedArm2 = false
            isSelectedArm1 = false
        default:
            break
        }
      
    }
    
    func initLegView(index: Int){
        
        switch index {
        case 1:
            isSelectedLeg1 = !isSelectedLeg1
            isSelectedLeg2 = false
            isSelectedLeg3 = false
        case 2:
            isSelectedLeg2 = !isSelectedLeg2
            isSelectedLeg1 = false
            isSelectedLeg3 = false
        case 3:
            isSelectedLeg3 = !isSelectedLeg3
            isSelectedLeg2 = false
            isSelectedLeg1 = false
        default:
            break
        }

    }
    
    func initHemiLeft(index: Int){
        
        switch index {
        case 1:
            isHemiLeft1 = !isHemiLeft1
            isHemiLeft2 = false
            isHemiLeft3 = false
        case 2:
            isHemiLeft2 = !isHemiLeft2
            isHemiLeft1 = false
            isHemiLeft3 = false
        case 3:
            isHemiLeft3 = !isHemiLeft3
            isHemiLeft2 = false
            isHemiLeft1 = false
        default:
            break
        }
        isHemiRight3 = false
        isHemiRight2 = false
        isHemiRight1 = false

    }
    
    func initHemiRight(index: Int){
        
        switch index {
        case 1:
            isHemiRight1 = !isHemiRight1
            isHemiRight2 = false
            isHemiRight3 = false
        case 2:
            isHemiRight2 = !isHemiRight2
            isHemiRight1 = false
            isHemiRight3 = false
        case 3:
            isHemiRight3 = !isHemiRight3
            isHemiRight2 = false
            isHemiRight1 = false
        default:
            break
        }
        
        isHemiLeft2 = false
        isHemiLeft1 = false
        isHemiLeft3 = false

    }
    
    func initHeadView(index: Int){
        
        switch index {
        case 1:
            isHeadSelcet1 = !isHeadSelcet1
            isHeadSelcet2 = false
        case 2:
            isHeadSelcet2 = !isHeadSelcet1
            isHeadSelcet1 = false
        default:
            break
        }

    }
    
    func initHemiView(index: Int){
        
        switch index {
        case 1:
            isHemiSelect1 = true
            isHemiSelect2 = false
            hemiTitle = "Agnosia"
            resultDescriptionLabel = "Ask the patient to:\n1) While showing them your arm, \"Whose arm is this?\"\n2) \"Can you lift both hands and clap?\""
        case 2:
            isHemiSelect2 = true
            isHemiSelect1 = false
            hemiTitle = "Aphasia"
            resultDescriptionLabel = "Instruct the patient to:\n1) \"Close your eyes.\"\n2) \"Make a fist.\""

        default:
            break
        }

    }
    
    func calculation(){
        totalCount = facialCount + armCount + legCount + headCount + hemiCount
        
        switch totalCount {
        
        case 1:
            sensitivityResultLabel = "100 %"
            specificityResultLabel = "13 %"
        case 2:
            sensitivityResultLabel = "97 %"
            specificityResultLabel = "27 %"
        case 3:
            sensitivityResultLabel = "93 %"
            specificityResultLabel = "40 %"
        case 4:
            sensitivityResultLabel = "89 %"
            specificityResultLabel = "55 %"
        case 5:
            sensitivityResultLabel = "85 %"
            specificityResultLabel = "68 %"
        case 6:
            sensitivityResultLabel = "72 %"
            specificityResultLabel = "77 %"
        case 7:
            sensitivityResultLabel = "53 %"
            specificityResultLabel = "89 %"
        case 8:
            sensitivityResultLabel = "32 %"
            specificityResultLabel = "95 %"
        case 9:
            sensitivityResultLabel = "7 %"
            specificityResultLabel = "99 %"

        default:
            sensitivityResultLabel = " "
            specificityResultLabel = " "
            break
        }
    }
}
