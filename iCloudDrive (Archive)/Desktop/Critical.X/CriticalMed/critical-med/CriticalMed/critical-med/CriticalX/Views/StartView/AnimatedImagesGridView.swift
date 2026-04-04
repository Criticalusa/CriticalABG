
//Created by Jadie Barringer 2/18/24


import SwiftUI

struct AnimatedImagesGridView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4) // 4 columns grid
    
    @State private var gridSymbols: [String] = []
    
    @State private var currentSymbols: [String] = []
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
//    init() {
//        let initialSymbols = (0..<12).map { _ in symbols.randomElement() ?? "circle" }
//        _gridSymbols = State(initialValue: initialSymbols)
//        _currentSymbols = State(initialValue: initialSymbols)
//    }
    init() {
           // Initialize with 12 unique symbols
           _displayedSymbols = State(initialValue: Array(symbols.prefix(12)))
       }
    @State private var displayedSymbols: [String]

    let symbols = [
        "icon-vad", "icon-aorta", "icon-pancreas", "icon-sodium", "icon-pacemaker",
        "icon-modes", "welcomeLogo", "icon-ekgMonitor", "icon-iabp", "icon-burns", "icon-hola",
        "immunology", "icon-ekg", "icons-heart", "icon-airway", "icon-blood",
        "icon-breathing", "icon-calculator", "icon-dialysis", "icon-ETT",
        "icon-hemodynamics", "icon-bp"].shuffled()
    
    
   
    
    var body: some View {
        VStack {
            Text("Welcome to Critical Med")
                .padding(.bottom, 30)
                .font(.title)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(displayedSymbols.indices, id: \.self) { index in
                    Image(displayedSymbols[index])
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .transition(.opacity)
                        .animation(Animation.easeInOut, value: displayedSymbols[index])
                }
            }
            .padding()
            .onReceive(timer) { _ in
                updateRandomSymbol()
            }
            
            Button("Dismiss") {
                // Action to dismiss the view
                self.presentationMode.wrappedValue.dismiss()
                
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding()
        }
    }
    
//    func updateSymbols() {
//        // Shuffle the symbols to get a random order
//        let shuffledSymbols = symbols.shuffled()
//        
//        // Assign the first N unique symbols from the shuffled array to the gridSymbols
//        // Ensure we only take as many symbols as we have grid cells to display
//        let uniqueSymbols = Array(shuffledSymbols.prefix(currentSymbols.count))
//        
//        withAnimation {
//            // Update gridSymbols with the selected unique symbols
//            gridSymbols = uniqueSymbols
//            
//            // Update the currentSymbols to reflect these changes with animation
//            for index in uniqueSymbols.indices {
//                withAnimation(Animation.easeInOut.delay(Double.random(in: 0...2))) {
//                    currentSymbols[index] = uniqueSymbols[index]
//                }
//            }
//        }
//    }
    func updateRandomSymbol() {
          let availableSymbols = symbols.filter { !displayedSymbols.contains($0) }
          guard !availableSymbols.isEmpty else { return }
          
          let randomIndexToUpdate = Int.random(in: displayedSymbols.indices)
          let randomNewSymbolIndex = Int.random(in: availableSymbols.indices)
          
          withAnimation(.easeInOut(duration: 0.5)) {
              displayedSymbols[randomIndexToUpdate] = availableSymbols[randomNewSymbolIndex]
          }
      }
  }


struct AnimatedImagesGridView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedImagesGridView()
    }
}
