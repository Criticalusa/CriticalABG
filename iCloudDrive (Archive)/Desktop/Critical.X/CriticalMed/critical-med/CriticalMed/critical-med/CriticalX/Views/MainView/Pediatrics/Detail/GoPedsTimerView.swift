//
//  GoPedsTimerView.swift
//  CriticalX
//
//  Created by Dev Expert on 2022/3/16.
//

import SwiftUI
import Combine
import AVFoundation


struct GoPedsTimerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var segmentSelectedIndex: Int = 0
    @State private var compression: Int = 15
    @State private var cycleCount: Int = 0
    @State private var totalCount: Int = 0
    @State private var cycle: Int = 1
    @State private var cycleTime: String = "00:00"
    @State private var isLatest10Sec: Bool = false
    @State private var isLatest5Compression: Bool = false
    @State private var isVentilate: Bool = false
    @State private var isContinuos: Bool = false
    
    @State private var totalMin: Int = 0
    @State private var compressionCount: Int = 0


    @Binding var isCPRStarted: Bool
    @Binding var defBottomSheetShown: Bool
    @Binding var epiBottomSheetShown : Bool

    @State private var scale: CGFloat = 1
    @State var audioPlayer: AVAudioPlayer?

    @State var timer = Timer.publish(
        every: 1, // second
        on: .main,
        in: .common
    )
    
    @State var compressionTimer = Timer.publish(
        every: 60.0 / 110.0, // second
        on: .main,
        in: .common
    )
    
    @State var connectedCycleTimer: Cancellable? = nil
    @State var connectedTimer: Cancellable? = nil

    var body: some View {
        
        VStack(spacing: 10){
            
            HStack(alignment: .center){
                
                VStack(spacing: 10.0){
                    HStack(alignment: .center){
                        
                        Picker("", selection: $compression) {
                                        Text("15:2").tag(15)
                                        Text("30:2").tag(30)
                                    }
                                    .pickerStyle(.segmented)
                                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 4)
                                    .frame(width: 140)
                                    .padding(.leading, 10)
                                    .onChange(of: compression) { newValue in
                                        if compression == 15 || compression == 30 {
                                            restartTimer()
                                        }
                                    }
                                    
                       
                        Spacer()
                        HStack(alignment: .bottom, spacing: 25.0){
                            
                           
                            if isVentilate {
                                
                                Text("Ventilate !!")
                                    .font(.system(size: 15, weight: .semibold, design: .default))
                                    .foregroundColor(Color.paoloVeronese_green)
                                    .scaleEffect(scale)
                                    .animation(.linear(duration: 1), value: scale)
                                    .padding(.trailing, 20)
                                
                                Image(systemName: "lungs")
                                    .font(.system(size: 20, weight: .regular, design: .default))
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.green, .black)
                                    .padding(.trailing, 26)

//
                            }
                            
                            
                            
                        }.padding(.trailing, 10)
                         .frame(height: 30)
                         .animation(.easeInOut(duration: 0.3), value: isVentilate)

                    }.padding(.top, 10.0)
                    
                    HStack(alignment: .bottom, spacing: 20){
                                                        
                        VStack(spacing: 3.0){
                            Text("Total Min")
                                .font(.system(size: 12, weight: .semibold, design: .default))
                                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                            Text("\(totalMin)")
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .foregroundColor(CriticalDesign.Colors.accentBlue)
                        }
                        VStack(spacing: 3.0){
                            Text("Cycle Time")
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                            Text(cycleTime)
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .foregroundColor(isLatest10Sec ? CriticalDesign.Colors.accentRed : CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                                .onReceive(timer) { (_) in
                                    cycleCount += 1
                                    totalCount += 1
                                    isLatest10Sec = cycleCount > 109
                                    
                                    let min = "0\(cycleCount / 60)"
                                    var sec = ""
                                    if cycleCount % 60 > 9 {
                                        sec = "\(cycleCount % 60)"
                                    }else{
                                        sec = "0\(cycleCount % 60)"
                                    }
                                    cycleTime = "\(min):\(sec)"
                                    
                                    if cycleCount == 120 {
                                        cycleCount = 0
                                        cycle += 1
                                    }
                                    
                                    totalMin = totalCount / 60
                                   
                                }
                        }
                        VStack(spacing: 3.0){
                            Text("Compression")
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                            HStack{
                                Image(systemName: "speaker.wave.3")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(CriticalDesign.Colors.accentBlue, CriticalDesign.Colors.accentRed)
                                    .frame(width: 20, height: 20)
                                    .scaledToFill()
                                
                                
                                Text("\(compressionCount)")
                                    .font(.system(size: 18, weight: .medium, design: .default))
                                    .foregroundColor(isLatest5Compression ? CriticalDesign.Colors.accentRed : CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                                    .onReceive(compressionTimer) { (_) in
                                        
                                        compressionCount += 1
                                        
                                        if isContinuos {
                                            
                                            if compressionCount > 5 {
                                                isVentilate = true
                                                scale += 0.5
                                                cancelTimer()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                    isVentilate = false
                                                    scale = 1
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        isVentilate = true
                                                        scale += 0.5
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                            isVentilate = false
                                                            scale = 1
                                                            compressionCount = 0
                                                            restartTimer()
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                            }
                                            
                                        }else{
                                            if compressionCount > compression - 1 {
                                                isVentilate = true
                                                scale += 0.5
                                                cancelTimer()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                    isVentilate = false
                                                    scale = 1
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        isVentilate = true
                                                        scale += 0.5
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                                            isVentilate = false
                                                            scale = 1
                                                            compressionCount = 0
                                                            isLatest5Compression = false
                                                            restartTimer()
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                            }else{
                                                isLatest5Compression = compressionCount > compression - 5
                                            }
                                        }
                                        playSound(sound: "beep", type: "mp3")
                                        audioPlayer?.numberOfLoops = 1
                                        
                                    }.onAppear {
                                        if compression == 15 || compression == 30 {
                                            restartTimer()
                                        }
                                    }
                            }
                        }
                        
                        VStack(spacing: 3.0){
                            Text("Cycle")
                                .font(.system(size: 12, weight: .medium, design: .default))
                                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
                            Text("\(cycle)")
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                        }
                    }.padding(.top, 10)
                    
                    
                    HStack{
                        Button(action: {
                            cycleCount = 0
                            totalCount = 0
                            isLatest10Sec = false
                            totalMin = 0
                            cycle = 1
                            cycleTime = "00:00"
                            compressionCount = 0
                            compression = 15
                            isVentilate = false
                            isLatest5Compression = false
                            isContinuos = false
                            cancelCycleTimer()
                            restartCycleTimer()
                            cancelTimer()
                            restartTimer()
                        }){
                            HStack{
                                Text("Reset 🔂")
                                    .font(.system(size: 12, weight: .semibold, design: .default))
                                    .foregroundColor(Color.white)
                            }
                            .frame(width: 70, height: 32)
                            .background(Color.FBI_Blue)
                        }
                        .cornerRadius(6)
                        
                        Button(action: {
                            compressionCount = 0
                            isLatest5Compression = true
                            isContinuos = true
                        }){
                            HStack{
                                Text("Continuous 🧭")
                                    .font(.system(size: 12, weight: .semibold, design: .default))                                    .foregroundColor(Color.white)
                            }
                            .frame(width: 75, height: 32)
                            .background(Color.paoloVeronese_green)
                        }
                        .cornerRadius(6)
                        
                        Button(action: {
                            epiBottomSheetShown = true
                            
                        }){
                            HStack{
                                Text("EPI 💉")
                                    .font(.system(size: 12, weight: .semibold, design: .default))                                    .foregroundColor(Color.white)
                            }
                            .frame(width: 70, height: 32)
                            .background(Color((UIColor.component(red: 255, green: 183, blue: 43, opacity: 1))))
                        }
                        .cornerRadius(6)
                        
                        Button(action: {
                            defBottomSheetShown = true
                        }){
                            HStack{
                                Text("Defib ⚡️ ")
                                    .font(.system(size: 12, weight: .semibold, design: .default))                                    .foregroundColor(Color.white)
                            }
                            .frame(width: 70, height: 32)
                            .background(Color.red)
                        }
                        .cornerRadius(6)
                    }.padding(.bottom, 10)
                    
                }
            }
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.95)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(
                    colorScheme == .dark 
                        ? CriticalDesign.Colors.cardBlue 
                        : Color.white.opacity(0.8)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    colorScheme == .dark 
                        ? CriticalDesign.Colors.goldMid.opacity(0.3) 
                        : CriticalDesign.Colors.navyAccent.opacity(0.08),
                    lineWidth: 1
                )
        )
        .shadow(
            color: Color.black.opacity(colorScheme == .dark ? 0.12 : 0.04),
            radius: colorScheme == .dark ? 10 : 12,
            x: 0,
            y: colorScheme == .dark ? 5 : 6
        )
        .onAppear {
            if colorScheme == .dark {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(CriticalDesign.Colors.goldMid)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(CriticalDesign.Colors.cardBlue)], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white.withAlphaComponent(0.7)], for: .normal)
            } else {
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(CriticalDesign.Colors.accentTeal)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
            }
            instantiateCycleTimer()
            instantiateTimer()
        }

    }
    
    func instantiateCycleTimer() {
        self.timer = Timer.publish(
            every: 1,
            on: .main,
            in: .common
        )
        self.connectedCycleTimer = self.timer.connect()
        return
    }
    
    func cancelCycleTimer() {
        self.connectedCycleTimer?.cancel()
        return
    }
    
    func restartCycleTimer() {
        cycleCount = 0
        totalCount = 0
        isLatest10Sec = false
        totalMin = 0
        cycle = 1
        cycleTime = "00:00"
        self.cancelCycleTimer()
        self.instantiateCycleTimer()
        return
    }
    
    func instantiateTimer() {
        self.compressionTimer = Timer.publish(
            every: 60.0 / 110.0, // second
            on: .main,
            in: .common
        )
        self.connectedTimer = self.compressionTimer.connect()
        return
    }
    
    func cancelTimer() {
        self.connectedTimer?.cancel()
        return
    }
    
    func restartTimer() {
        self.compressionCount = 0
        self.cancelTimer()
        self.instantiateTimer()
        return
    }
    
    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                AppLogger.error("Failed to play audio sound")
            }
        }
    }
    
}

struct GoPedsTimerView_Previews: PreviewProvider {
    static var previews: some View {
        GoPedsTimerView(isCPRStarted: .constant(false), defBottomSheetShown: .constant(false), epiBottomSheetShown: .constant(false))
    }
}

