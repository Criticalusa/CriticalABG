//
//  OnboardingViewPure.swift
//  Onboarding
//
//  Created by Augustinas Malinauskas on 06/07/2020.
//  Copyright © 2020 Augustinas Malinauskas. All rights reserved.
//

import SwiftUI

struct OnboardingViewPure: View {
    var data: [OnboardingDataModel]
    var doneFunction: () -> ()

    @State var slideGesture: CGSize = CGSize.zero
    @State var curSlideIndex = 0
    var distance: CGFloat = UIScreen.main.bounds.size.width

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    func nextButton() {
        if self.curSlideIndex == self.data.count - 1 {
            doneFunction()
            return
        }
        
        if self.curSlideIndex < self.data.count - 1 {
            withAnimation {
                self.curSlideIndex += 1
            }
        }
    }
    
    var body: some View {
        ZStack {
            CriticalDesign.Adaptive.canvas(for: colorScheme).edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .center) {
                ForEach(0..<data.count, id: \.self) { i in
                    OnboardingStepView(data: self.data[i])
                        .offset(x: CGFloat(i) * self.distance)
                        .offset(x: self.slideGesture.width - CGFloat(self.curSlideIndex) * self.distance)
                        .animation(.spring(), value: curSlideIndex)
                        .gesture(DragGesture().onChanged{ value in
                            self.slideGesture = value.translation
                        }
                        .onEnded{ value in
                            if self.slideGesture.width < -50 {
                                if self.curSlideIndex < self.data.count - 1 {
                                    withAnimation {
                                        self.curSlideIndex += 1
                                    }
                                }
                            }
                            if self.slideGesture.width > 50 {
                                if self.curSlideIndex > 0 {
                                    withAnimation {
                                        self.curSlideIndex -= 1
                                    }
                                }
                            }
                            self.slideGesture = .zero
                            
                            if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                                           presentationMode.wrappedValue.dismiss()
                                       }

                        })
                }
            }
            
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        doneFunction()
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.top, 50)
                
                Spacer()
                VStack {
                    Button(action: nextButton) {
                        self.arrowView()
                    }
                    self.progressView()
                }
            }
            .padding(10)
        }
    }
    
    func arrowView() -> some View {
        Group {
            if self.curSlideIndex == self.data.count - 1 {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                    }
            } else {
                    Text("Next")
            }
        }
    }
    
    func progressView() -> some View {
        HStack {
            ForEach(0..<data.count, id: \.self) { i in
                Circle()
                    .scaledToFit()
                    .frame(width: 8)
                    .foregroundColor(self.curSlideIndex == i ? CriticalDesign.Colors.accentBlue : CriticalDesign.Colors.accentBlue.opacity(0.3))
            }
        }
    }
    
}

struct OnboardingViewPure_Previews: PreviewProvider {
    static let sample = OnboardingDataModel.data
    static var previews: some View {
        OnboardingViewPure(data: sample, doneFunction: { print("done") })
    }
}
