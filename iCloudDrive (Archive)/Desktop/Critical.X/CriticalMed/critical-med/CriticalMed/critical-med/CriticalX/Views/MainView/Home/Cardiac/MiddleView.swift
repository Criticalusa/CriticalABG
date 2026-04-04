//
//  MiddleView.swift
//  CriticalX
//
//  Created by Macbook 4 on 25/11/2021.
//

import SwiftUI

struct MiddleView: View {
    
   @Binding var count: Int
    @Binding var row: Int

    var body: some View {
        ZStack {
            // Guard against invalid indices
            if count >= 0 && row >= 0 {
                switch count {
                case 0:
                    if row == 0 {
                        VadsView(indcx: 0, otherModel: VadsOtherDataModel(title: "", overViewDescription: "", whatToKnowDescription: "", image: ""), url: "")
                    } else if row == 1 {
                        NavigationView {
                            Pacemakers()
                        }
                        .navigationViewStyle(.stack)
                    } else if row == 2 {
                        ECMOView()
                    } else if row == 3 {
                        NavigationView {
                            BalloonPumpMainView()
                        }
                        .navigationViewStyle(.stack)
                    }
                case 1:
                    if row == 0 {
                        AclsUpdateView()
                    } else if row == 1 {
                        TTMView()
                    } else if row == 2 {
                        ACLSQuizMainView()
                    }
                case 2:
                    LeadView()
                default:
                    EmptyView()
                }
            } else {
                EmptyView()
            }
        }
        .environment(
            \.cardiacListRowImage,
            CardiacHeader.listRowImage(section: count, row: row)
        )
        .onAppear() {
            #if DEBUG
            print("MiddleView count: \(count)")
            #endif
        }
    }
}

struct MiddleView_Previews: PreviewProvider {
    static var previews: some View {
        MiddleView(count: .constant(0), row: .constant(0))
    }
}
