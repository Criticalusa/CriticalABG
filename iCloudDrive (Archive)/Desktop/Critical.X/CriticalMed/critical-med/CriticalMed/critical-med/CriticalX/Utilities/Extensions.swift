//
//  Extensions.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 04/11/2021.
//

import Foundation
import SwiftUI

extension View {
    func background(with color: Color) -> some View {
        background(GeometryReader { geometry in
            Rectangle().path(in: geometry.frame(in: .local)).foregroundColor(color)
        })
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension Color {
    // MARK: - Adaptive Colors (Auto-adjust for Dark Mode)

    /// Primary text color - dark in light mode, light in dark mode
    static let tintBlue = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor("E8ECEF")  // Light gray for dark mode
            : UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)  // Original dark blue
    })

    /// Main page background - light gray in light mode, dark navy in dark mode
    static let mainBackgroundColor = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor("0D1520")  // Dark navy background
            : UIColor("ECECEC")  // Original light gray
    })

    /// Critical blue - primary brand color, adapts for readability
    static let criticalBlue = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor("7EB8E7")  // Lighter blue for dark mode readability
            : UIColor("1D3557")  // Original dark blue
    })

    /// Dark gray text - adapts for dark mode
    static let critical_darkGray = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor("D5DBDC")  // Light gray for dark mode
            : UIColor("39343C")  // Original dark gray
    })

    /// Adaptive card background - white in light mode, cardBlue in dark mode
    static let adaptiveCardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor("17263C")  // Card blue for dark mode
            : UIColor.systemBackground  // White for light mode
    })

    /// Adaptive secondary background - light gray in light mode, darker navy in dark mode
    static let adaptiveSecondaryBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor("0D1520")  // Darker navy
            : UIColor.secondarySystemBackground
    })

    // MARK: - Standard Colors (Non-adaptive)

    static let homeBackgroundColor = Color(UIColor.tertiarySystemGroupedBackground)
    static let homeLightBackgroundColor = Color(UIColor("F2F2F7"))
    static let yellowColor = Color(UIColor("F3AF22"))
    static let redColor = Color(UIColor("D04141"))

    //static let logoBlue = Color(UIColor("#17348C")) This is the lighter royal blue
    //New critial bradnd colors for the new logo
    static let logoBlue = Color(UIColor("#18293D"))
    static let newCriticalBlue = Color(UIColor("074aac"))
    static let newCriticalYellow = Color(UIColor("F7BA00"))
    static let newred = Color(UIColor("ce4141"))
    static let newCriticalNavyBlue = Color(UIColor("113d5a"))
    // New card blue color - reusable throughout app (#17263C)
    static let cardBlue = Color(UIColor("17263C"))

    static let criticalBlue2 = Color(UIColor("005493"))
    static let midnightBlue = Color(UIColor("0D1A36"))
    static let red_matte = Color(UIColor("CC5B57"))
    static let red = Color(UIColor("D04141"))
    static let criticalBabyBlue = Color(UIColor("3DB2FF")).opacity(0.5)
    /// Secondary text color - adapts for dark mode
    static let darkGray = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor("A8B4C0")  // Lighter gray for dark mode
            : UIColor("929395")  // Original gray
    })

    /// Light background areas - adapts for dark mode
    static let critical_gray = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor("17263C")  // Card blue for dark mode
            : UIColor("FAFAFA")  // Original light gray
    })

    static let gunMetal_Gray = Color(UIColor("232C33"))
    static let babyPowderWhite = Color(UIColor("F5F7F3"))
    static let purple_Independence = Color(UIColor("5D576B"))

    /// Accent orange - slightly brighter in dark mode for visibility
    static let orange_TerraCotta = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor("F07B6C")  // Brighter coral for dark mode
            : UIColor("ED6A5A")  // Original terra cotta
    })
    static let yellow_PaleSpringBud = Color(UIColor("F4F1BB"))
    static let opal = Color(UIColor("9BC1BC"))
    static let lavendar = Color(UIColor("B5B2C2"))
    static let sap_Green = Color(UIColor("81b29a"))
    static let OD_Green = Color(UIColor("718355"))
    static let Gainsboro_green = Color(UIColor("D3E0E0"))
    static let BlueYonder = Color(UIColor("5C82AD")) 
    static let rich_Black = Color(UIColor("01161E"))
    static let beige_white = Color(UIColor("EFF6E0")) 
    static let cambridge_green = Color(UIColor("9CBFA8"))
    static let paoloVeronese_green = Color(UIColor("419D78"))
    static let critical_lightBlue = Color(UIColor("D2E4EF"))
    static let FBI_Blue = Color(UIColor("2268A5"))
    //235EBE Old FBI Blue
    static let jonquil_Gold = Color(UIColor("E6C229"))
    static let black_Chocolate = Color(UIColor("131200"))
    static let englishViolet_Purple = Color(UIColor("564256"))
    static let charcol_gray = Color(UIColor("324A5F"))
    static let sunray_Gold = Color(UIColor("EDAE49"))
    static let brick_red = Color(UIColor("D1495B"))
    static let quickSilver_gray = Color(UIColor("9DA7AA"))
    static let mint_darkGreen = Color(UIColor("319E8E"))
    // Old Mint dark green 4DA29F
    static let rollTide_red = Color(UIColor("B01C31"))
    static let royal_blue = Color(UIColor("025493"))
    static let skyBlue = Color(UIColor("e0fbfc"))

    static let butter_gold = Color(UIColor("FF9501"))
    static let critical_grey = Color(UIColor("AFAFAF"))

    // New Color Pallate Medical Colors
    
    static let soothingSilver = Color(UIColor("d5dbdc"))
    static let warmCoral = Color(UIColor( "e16b5f"))
    static let tranquilBlue = Color(UIColor( "3e6a98"))
    static let mistyMorning = Color(UIColor("b8c7cb"))
    static let gentleMauve = Color(UIColor( "9d8f99"))
    static let vitalRed = Color(UIColor( "d33528"))
    static let heartyWine = Color(UIColor("6d3342"))
    static let skyReflection = Color(UIColor("6eabc9"))
    static let blushTint = Color(UIColor("eaa696"))
    static let etherealWhite = Color(UIColor("e9eced"))
    
    static let healingGreen = Color(UIColor("2ECC71"))
    static let pulseBlue = Color(UIColor("3498DB"))
    static let alertOrange = Color(UIColor("E67E22"))
    static let nightMode = Color(UIColor("2C3E50"))
    static let softLavender = Color(UIColor("9B59B6"))
    static let oceanTeal = Color(UIColor("16A085"))
    static let warmBeige = Color(UIColor("F5F0E1"))
    static let dustyRose = Color(UIColor("E8B4B8"))
    
    // static let color = Color(UIColor(""))
    
    // MARK: - Neumorphic Colors
    static let neumorphicBackground = Color(UIColor("E8ECEF"))
    static let neumorphicDarkShadow = Color(UIColor("A3B1C6"))
    static let neumorphicIncreasedBlue = Color(UIColor("3B82F6"))
    static let neumorphicDecreasedRed = Color(UIColor("EF4444"))
    static let neumorphicCriticalOrange = Color(UIColor("F97316"))
    static let neumorphicNormalGreen = Color(UIColor("10B981"))
}

// MARK: - Neumorphic View Modifiers
extension View {
    /// Neumorphic extruded (raised) card style
    func neumorphicExtruded(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.neumorphicBackground)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    .shadow(color: Color.neumorphicDarkShadow.opacity(0.3), radius: 10, x: 5, y: 5)
            )
    }
    
    /// Neumorphic inset (pressed) card style
    func neumorphicInset(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.neumorphicBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.neumorphicDarkShadow.opacity(0.1), lineWidth: 1)
                            .shadow(color: Color.neumorphicDarkShadow.opacity(0.3), radius: 3, x: 2, y: 2)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            .shadow(color: Color.white.opacity(0.7), radius: 3, x: -2, y: -2)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                    )
            )
    }
    
    /// Neumorphic card with colored left border
    func neumorphicCard(accentColor: Color, cornerRadius: CGFloat = 12) -> some View {
        self
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.neumorphicBackground)
                        .shadow(color: Color.white.opacity(0.7), radius: 8, x: -4, y: -4)
                        .shadow(color: Color.neumorphicDarkShadow.opacity(0.25), radius: 8, x: 4, y: 4)
                    
                    // Colored left border
                    HStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(accentColor)
                            .frame(width: 4)
                            .padding(.vertical, 8)
                        Spacer()
                    }
                    .padding(.leading, 8)
                }
            )
    }
    
    /// Neumorphic pill/badge style
    func neumorphicPill() -> some View {
        self
            .background(
                Capsule()
                    .fill(Color.neumorphicBackground)
                    .shadow(color: Color.white.opacity(0.6), radius: 4, x: -2, y: -2)
                    .shadow(color: Color.neumorphicDarkShadow.opacity(0.2), radius: 4, x: 2, y: 2)
            )
    }
    
    /// Neumorphic button with press state
    func neumorphicButton(isPressed: Bool, cornerRadius: CGFloat = 12) -> some View {
        self
            .background(
                Group {
                    if isPressed {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.neumorphicBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(Color.neumorphicDarkShadow.opacity(0.15), lineWidth: 1)
                                    .blur(radius: 1)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color.neumorphicBackground)
                            .shadow(color: Color.white.opacity(0.7), radius: 6, x: -3, y: -3)
                            .shadow(color: Color.neumorphicDarkShadow.opacity(0.25), radius: 6, x: 3, y: 3)
                    }
                }
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

// Hide the keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
       
}

//Floating Button



extension View {
  func floatingActionButton<ImageView: View>(
    color: Color,
    image: ImageView,
    action: @escaping () -> Void) -> some View {
    self.modifier(FloatingActionButton(color: color,
                                       image: image,
                                       action: action))
  }
}
    

// Create Custom Title
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 34, weight: .regular, design: .default))
            .foregroundColor(Color.criticalBlue)
           // .padding()
        //This is if we want a blue border wrapped in it
        //.background(.blue)
            //.clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// Custom Title modifier
extension View {
    func customTitleFont() -> some View {
        modifier(Title())
        
        // Implement title in code:
        
        //Text("Hello World")
          //  .titleStyle()
    }
    
    func togleFavorites(title: String, type: String, isFavorite: Bool){
        
        guard var favoritelist = UserDefaults.standard.object(forKey:"favorites_list") as? [Any] else {
            // No favorites list exists yet - create one if adding
            if isFavorite {
                let favorite: [String: Any] = ["title": title, "type": type]
                UserDefaults.standard.set([favorite], forKey: "favorites_list")
                NotificationCenter.default.post(name: NSNotification.Name("FavoritesChanged"), object: nil)
            }
            return
        }
        
        if favoritelist.count == 0 {
            // Empty list - add if favoriting
            if isFavorite {
                let favorite: [String: Any] = ["title": title, "type": type]
                favoritelist.append(favorite)
            }
        } else {
            // Check if item already exists
            var existingIndex: Int? = nil
            for (index, item) in favoritelist.enumerated() {
                guard let itemDict = item as? [String: Any],
                      let itemTitle = itemDict["title"] as? String,
                      let itemType = itemDict["type"] as? String else {
                    continue
                }
                
                if itemTitle == title && itemType == type {
                    existingIndex = index
                    break
                }
            }
            
            if isFavorite {
                // Adding to favorites - only add if not already present
                if existingIndex == nil {
                    let favorite: [String: Any] = ["title": title, "type": type]
                    favoritelist.append(favorite)
                }
            } else {
                // Removing from favorites - remove if present
                if let index = existingIndex {
                    favoritelist.remove(at: index)
                }
            }
        }
        
        UserDefaults.standard.set(favoritelist, forKey: "favorites_list")
        NotificationCenter.default.post(name: NSNotification.Name("FavoritesChanged"), object: nil)
    }

    func getIsFavorite(title: String, type: String) -> Bool {
        guard let favoritelist = UserDefaults.standard.object(forKey:"favorites_list") as? [Any] else {
            return false
        }
        
        for item in favoritelist {
            let favorite = FavoriteModel(favorite: item as AnyObject)
            if favorite.title == title && favorite.type == type {
                return true
            }
        }
        
        return false
    }
    
    func glassMorphism(opacity: Double = 0.2) -> some View {
        self.background(
            Color.white.opacity(0.2)
                .blur(radius: 10)
                .overlay(
                    Color.white.opacity(opacity)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    func modernCard(color: Color = .white) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 15)
                .fill(color.opacity(0.8))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    func smoothTransition() -> some View {
        self.transition(.asymmetric(
            insertion: .scale.combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        ))
    }
    
    func navigationBarColor(backgroundColor: UIColor, tintColor: UIColor) -> some View {
        self.modifier(NavigationBarColor(backgroundColor: backgroundColor, tintColor: tintColor))
    }
}


//Create a textStyle
extension Text {
    
    func textStyle(_font: Font = .body, weight_Font: Font.Weight = .heavy, color_text: Color = .critical_darkGray) -> Text {
        return self
            .font(_font)
           
            .fontWeight(weight_Font)
            .foregroundColor(color_text)
        
    }
    
    init(_ astring: NSAttributedString) {
        self.init("")
        
        astring.enumerateAttributes(in: NSRange(location: 0, length: astring.length), options: []) { (attrs, range, _) in
            
            var t = Text(astring.attributedSubstring(from: range).string)

            if let color = attrs[NSAttributedString.Key.foregroundColor] as? UIColor {
                t  = t.foregroundColor(Color(color))
            }

            if let font = attrs[NSAttributedString.Key.font] as? UIFont {
                t  = t.font(.init(font))
            }

            if let kern = attrs[NSAttributedString.Key.kern] as? CGFloat {
                t  = t.kerning(kern)
            }
            
            
            if let striked = attrs[NSAttributedString.Key.strikethroughStyle] as? NSNumber, striked != 0 {
                if let strikeColor = (attrs[NSAttributedString.Key.strikethroughColor] as? UIColor) {
                    t = t.strikethrough(true, color: Color(strikeColor))
                } else {
                    t = t.strikethrough(true)
                }
            }
            
            if let baseline = attrs[NSAttributedString.Key.baselineOffset] as? NSNumber {
                t = t.baselineOffset(CGFloat(baseline.floatValue))
            }
            
            if let underline = attrs[NSAttributedString.Key.underlineStyle] as? NSNumber, underline != 0 {
                if let underlineColor = (attrs[NSAttributedString.Key.underlineColor] as? UIColor) {
                    t = t.underline(true, color: Color(underlineColor))
                } else {
                    t = t.underline(true)
                }
            }
            
            self = self + t
            
        }
    }
}


//MARK: Rounding Extension: Double
//If the answer is a double change the decimal places
extension Double {
    var oneDecimalPlace: String {
        return String(format: "%.1f", self)
    }
    var twoDecimalPlace: String {
        return String(format: "%.2f", self)
    }
   
}

//MARK: Rounding Extension INT
//If the answer is an Int, change to decimal places
extension Int {
    var oneDecimalPlace: String {
        return String(format: "%.1f", self)
    }
    var twoDecimalPlace: String {
        return String(format: "%.2f", self)
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                    .clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}

struct SizeAwareViewModifier: ViewModifier {

    @Binding private var viewSize: CGSize

    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }

    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}



struct CustomToolbarHeaderView: View {
    var title: String
    var imageName: String
    var subtitle: String

    var body: some View {
        VStack {
           
            HStack {
                
                Spacer() // Pushes content towards the center

                Text(title).bold()
                    .font(.title2)
                    .foregroundColor(Color.white) // Ensure you have this color defined
                    
                Spacer() // Ensures the text stays centered

                Image(imageName) // Dynamic image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .shadow(radius: 5)
                    .padding(.leading, -15) // Adjust padding to ensure image is right-aligned if there's excess space
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
           
            // Subtitle
            Text(subtitle)
                .foregroundColor(.warmCoral) // Ensure you have this color defined
        }
        .padding(.bottom, 15)
        .padding(.top, 15)
    }
}

extension View {
    func customToolbarHeaderView(title: String, imageName: String, subtitle: String) -> some View {
        self.toolbar {
            ToolbarItem(placement: .principal) {
                CustomToolbarHeaderView(title: title, imageName: imageName, subtitle: subtitle)
            }
        }
    }
}




extension UIColor {
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}

extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE, MMM, YY d")
        return dateFormatter.string(from: self)
    }
    
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMMM dd, YYYY"
        return dateFormatter.string(from: self)
    }
    
    func formatTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm")
        return dateFormatter.string(from: self)
    }

}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// MARK: - Safe Array Subscript
extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}
