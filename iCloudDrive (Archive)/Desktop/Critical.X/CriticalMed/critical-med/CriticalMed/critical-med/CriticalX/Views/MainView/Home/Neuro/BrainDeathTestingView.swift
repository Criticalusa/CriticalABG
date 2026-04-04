//
//  BrainDeathTestingView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 12/21/23.
//

import SwiftUI
// import SwiftUITrackableScrollView


struct BrainDeathTestingView: View {
    @State var DrugDetails = "Drug Class"
    @State var textHeight: CGFloat = 0 // <-- this
    @State var textHeight1: CGFloat = 0 // <-- this
    @State private var scrollViewContentOffset = CGFloat(0)
    
    @State private var arrFavorites : [FavoriteModel] = []
    @State private var isFavorite = false
    
    
 
    
    var body: some View {
        
        ZStack{
            // Color.homeBackgroundColor.edgesIgnoringSafeArea(.all).opacity(1)
            // Background gradient
//            LinearGradient(gradient: Gradient (colors: [.white,.royal_blue,.red_matte]), startPoint: .top, endPoint: .bottomTrailing)
//                .opacity(0.6)
//                .ignoresSafeArea(.all)
            //BlurView(style: .systemThickMaterial).ignoresSafeArea(.all)
            
           
            TrackableScrollView(.vertical, showIndicators: false, contentOffset: $scrollViewContentOffset){
                
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 15){
                        Text("Brain Death Testing")
                            .font(.system(size: 28, weight: .medium, design: .default))
                            .foregroundColor(Color.criticalBlue2)
                        
                        HStack{
                           
                            
                            Text("Comatose, Areflexic, and Apneic")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(Color.black_Chocolate)
                                .padding(.leading, 0)
                        } // HSatck
                    }  // Vstack
                    .padding(.leading, 20)
                    Spacer()
                    VStack(alignment: .trailing, spacing: 7){
                        Image("icon-neuro")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .padding(.top, 7)
                            .shadow(radius: 8)
                        
                        Text("BDT")
                            .font(.system(size: 14, weight: .medium, design: .default))                            .foregroundColor(Color.black_Chocolate)
                            .padding(.trailing, 14)
                     
                        
                        // FavoriteButton(isFavorited: $isFavorite) {
                        //  togleFavorites(title: data.title, type: "Med", isFavorite: isFavorite)
                        
                    }.padding(.top, 5)
                        .padding(.trailing, 5)
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 15))
               
                VStack {
                    HStack {
                        Text("BDT PRE-REQUISITES")
                            .font(.system(size: 25, weight: .bold, design: .default))                            .foregroundColor(Color.black_Chocolate)
                            .padding(.trailing, 20)
                            .padding(.leading, 20)
                            .padding(.bottom, 10)
                        
                        
                    }
                    
                    Text("Always consult your local and state protocols first. Before brain death testing commences,several factors should exist before the examination begins- which include the following:")
                        .font(.system(size: 14, weight: .medium, design: .default))                   .foregroundColor(Color.black_Chocolate)
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                        .lineLimit(.max)
                    Spacer()
                    ZStack{
                        HStack{
                            Image("icon-neuro")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Irreversible Coma")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.mistyMorning)
                                
                                Text("Unknown Cause")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                    
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    ZStack{
                        HStack{
                            Image("icon-lungs")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Absent Sponteanous")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.cambridge_green)
                                
                                Text("Respirations")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                    
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    ZStack{
                        HStack{
                            Image("icon-hemodynamics")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Normotensive and ")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.orange_TerraCotta)
                                
                                Text("Euvolemic")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                    
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    ZStack{
                        HStack{
                            Image("icon-IV")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("No Residual Effects")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.royal_blue)
                                
                                Text("Sedatives and Paralytics")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                    
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    ZStack{
                        HStack{
//                            DotView(animationName: "animateDots")
//                                .padding(.top, 10.0)
//                                .frame(width: 40.0, height: 40.0)
//                                .scaleEffect(0.5)
                            Image("icon-temp")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Normothermic")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.redColor)
                                
                                Text("Or Near Normal Temp")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                    
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    
                    ZStack{
                        HStack{
//                            DotView(animationName: "animateDots")
//                                .padding(.top, 10.0)
//                                .frame(width: 40.0, height: 40.0)
//                                .scaleEffect(0.5)
                            Image("icon-periodicTable")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Absence of Any ")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.black_Chocolate)
                                
                                Text("Acid-Base, Electrolyte or Endocrine abnomalities")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                    
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    
                    Spacer()
                    Spacer()
                    
                    
                    HStack {
                        Text("BRAIN DEATH EXAMINATION")
                            .font(.system(size: 25, weight: .bold, design: .default))                            .foregroundColor(Color.black_Chocolate)
                            .padding(.trailing, 10)
                            .padding(.leading, 10)
                            .padding(.bottom, 5)
                    }
                    Text("Should be independently completed by two different attending physicians")
                        .font(.system(size: 14, weight: .medium, design: .default)) 
                        .foregroundColor(Color.royal_blue)
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
                        .padding(.bottom, 30)
                }
                    
                VStack(alignment: .leading, spacing: 15){
                    
                    ZStack{
                        HStack{
                            
                            Image("PupilsFlashlight")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Pupillary and Corneal Reflex")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.black_Chocolate)
                                
                                Text("Absent, No Reaction")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    ZStack{
                        HStack{
                            
                            Image("icon-coughGag")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Absent Cough & Gag Reflex ")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.purple_Independence)
                                
                                Text("Endotracheal Tube Suctioning")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    ZStack{
                        HStack{
                            
                            Image("Positive Occulovestibular")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Positive Cold Caloric Test")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.paoloVeronese_green)
                                    .lineLimit(2, reservesSpace: true)

                                Text("If the eyes move towards the side of the cold flush - positive reflex, not good.")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                                    .lineLimit(2, reservesSpace: true)

                            }
                            Spacer()
                        }
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)  
                    
                    ZStack{
                        HStack{
                            
                            Image("icon-body")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Absent Motor Response")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.brown)
                                
                                Text("In all four extremities")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    ZStack{
                        HStack{
                            
                            Image("icon-normalEyes1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            Image("icon-presentReflex")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Oculocephalic: Doll's Eyes- Present Reflex")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.royal_blue)
                                    .multilineTextAlignment(.leading)

                                    .lineLimit(2, reservesSpace: true)

                                Text("Despite the head turn to the right, the eyes stay immobile.")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                                    .lineLimit(2, reservesSpace: true)

                            }
                            
                            
                        }
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    ZStack{
                        HStack{
                            
                            Image("icon-normaleyes2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            Image("icon-absentReflex")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading){
                                Text("Oculocephalic: Doll's Eyes- Absent Reflex")
                                    .font(.system(size: 18, weight: .bold, design: .default))
                                    .foregroundColor(Color.royal_blue)
                                    .lineLimit(2, reservesSpace: true)

                                //icon-absentReflex
                                Text("The eyes move in the same direction of the head turn.")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(Color.gray)
                                    .lineLimit(2, reservesSpace: true)

                            }
                            Spacer()
                        }
                    }
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                    .padding(.trailing, 20)
                    .padding(.leading, 30)
                    .padding(.bottom, 20)
                    
                    Spacer()
                    
                    
                    HStack {
                        Text("APNEA TEST")
                            .font(.system(size: 25, weight: .bold, design: .default))                            .foregroundColor(Color.black_Chocolate)
                            .padding(.trailing, 20)
                            .padding(.leading, 20)
                            .padding(.bottom, 0)
                    }
                    Text("If brain dead, expect the CO2 should rise more than 20 mmHg.If at anytime the patient becomes unstable, the test should be aborted and ancillary testing utilized.")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(Color.gray)
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    
                    ScrollView(.horizontal){
                        
                        ZStack{
                            HStack{
                                
                                Image("icon-1solidRed")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                Image("icon-syringe1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading){
                                    Text("Normal Pre-Apnea Test")
                                        .font(.system(size: 18, weight: .bold, design: .default))
                                        .foregroundColor(Color.black_Chocolate)
                                    
                                }
                                Spacer()
                                Image("icon-rightarrow")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing,20)
                                
                                
                                HStack{
                                    
                                    Image("icon-2solid")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                    Image("apnea-bvm")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading){
                                        Text("Pre-Oxygenate")
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                            .foregroundColor(Color.black_Chocolate)
                                        
                                    }
                                    Spacer()
                                    Image("icon-rightarrow")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing,20)
                                }
                                
                                HStack{
                                    
                                    Image("icon-3solidOrange")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                    Image("icon-vent")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading){
                                        Text("Disconnect the Vent")
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                            .foregroundColor(Color.black_Chocolate)
                                        
                                    }
                                    Spacer()
                                    Image("icon-rightarrow")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing,20)
                                }
                                
                                HStack{
                                    
                                    Image("icon-4SolidPurple")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                    Image("apnea-sponBreaths")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading){
                                        Text("No Spontaneous Respirations")
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                            .foregroundColor(Color.black_Chocolate)
                                        
                                    }
                                    Spacer()
                                    Image("icon-rightarrow")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing,20)
                                }
                                HStack{
                                    
                                    Image("icon-5solidGreen")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                    Image("icon-syringe1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading){
                                        Text("Post-Apnea ABG")
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                            .foregroundColor(Color.black_Chocolate)
                                        
                                    }
                                    Spacer()
                                    Image("icon-rightarrow")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing,20)
                                }
                                HStack{
                                    
                                    Image("icon-6solid 1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                    Image("icon-vent")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading){
                                        Text("Re-Connect the Vent")
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                            .foregroundColor(Color.black_Chocolate)
                                        
                                    }
                                    Spacer()
                                  
                                }
                                
                            }
                            //put frame size
                        }
                        //.shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                        .padding(.trailing, 20)
                        .padding(.leading, 30)
                        .padding(.bottom, 20)
                        
                  }// End ScrollView Horizontal
                    
                    
                    HStack {
                        Text("ANCILLARY TESTING")
                            .font(.system(size: 25, weight: .bold, design: .default))                            .foregroundColor(Color.black_Chocolate)
                            .padding(.trailing, 20)
                            .padding(.leading, 20)
                            .padding(.bottom, 0)
                    }
                    Text("An auxiliary blood flow test, such as a cerebral flow scan, is recommended for intoxication issues or unable to perform an apnea test.Intoxication may confound brain electrical activity testing like EEG. Blood flow-based ancillary testing works regardless of intoxication. Thus, this method works for all intoxicants.")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(Color.gray)
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                  // ScrollView Ancillary Testing
                    ScrollView(.horizontal){
                        
                        ZStack{
                            HStack{
                                
                                Image("icon-1solidRed")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                            
                                
                                VStack(alignment: .leading){
                                    Text("EEG")
                                        .font(.system(size: 18, weight: .bold, design: .default))
                                        .foregroundColor(Color.black_Chocolate)
                                        .padding(.trailing, 20)
                                }
                                Spacer()
                             
                                
                                
                                HStack{
                                    
                                    Image("icon-2solid")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                
                                    
                                    VStack(alignment: .leading){
                                        Text("CBF/ Cerebral Blood Flow / Nuclear Med Scan ")
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                            .foregroundColor(Color.black_Chocolate)
                                            .padding(.trailing, 20)
                                    }
                                    Spacer()
                                  
                                }
                                
                                HStack{
                                    
                                    Image("icon-3solidOrange")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 20)
                                   
                                    
                                    VStack(alignment: .leading){
                                        Text("Transcranial Doppler (TCD) Cerebral Angiography")
                                            .font(.system(size: 18, weight: .bold, design: .default))
                                            .foregroundColor(Color.black_Chocolate)
                                            .padding(.trailing, 20)
                                    }
                                  
                                }
                                
                            }
                            //put frame size
                        }
                        //.shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
                        .padding(.trailing, 20)
                        .padding(.leading, 30)
                        .padding(.bottom, 20)
                        
                       
                        
                        
                        
                        
                        
                    }// End ScrollView Horizontal
                    .padding(.bottom, 60)
                    
                    
                    
                }
                   
                    
                }
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.95)
           // .background(Color.babyPowderWhite)
            .cornerRadius(8)
            //.shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
            .padding(.top, 13)
            // .shadow(radius: 4)
            
            
           
            
            
            //                .introspectNavigationController { nc in
            //                    nc.hidesBarsOnSwipe = true
            //                }
        } // ScrollView
        // .frame(width: UIScreen.main.bounds.width)
        

    
            }
        
        
    
    


#Preview {
    BrainDeathTestingView()
}
