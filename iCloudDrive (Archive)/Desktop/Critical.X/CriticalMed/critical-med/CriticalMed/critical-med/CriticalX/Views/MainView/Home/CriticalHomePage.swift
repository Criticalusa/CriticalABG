//
//  CriticalHomePage.swift
//  CriticalX
//
//  Main home page view with user welcome card, medical categories, news ticker, and emoji generation.
//  Organized with MARK comments for easy navigation.
//

import SwiftUI
import Foundation
import UIKit
import PhotosUI

// MARK: - Pop-to-Root Notification
/// Posted when user taps the Home tab while already on the Home tab
extension Notification.Name {
    static let popHomeToRoot = Notification.Name("popHomeToRoot")
}

// Note: ScrollOffsetPreferenceKey is defined in TrackableScrollView.swift
// Reusing existing implementation for consistency

// MARK: - News Cache (Singleton)
/// Caches news articles to persist across view recreation
final class NewsCache {
    static let shared = NewsCache()
    private init() {}
    
    var articles: [NewsArticle]?
    var lastFetch: Date?
    
    /// Returns true if cache is stale (older than 15 minutes)
    var isStale: Bool {
        guard let lastFetch = lastFetch else { return true }
        return Date().timeIntervalSince(lastFetch) > 15 * 60
    }
    
    func clear() {
        articles = nil
        lastFetch = nil
    }
}

// MARK: - Premium Card Animation Modifier
/// Adds stagger fade-in animation to cards on scroll
struct StaggeredCardModifier: ViewModifier {
    let index: Int
    let isVisible: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.9)
            .animation(
                .spring(response: 0.4, dampingFraction: 0.8)
                    .delay(Double(index) * 0.05),
                value: isVisible
            )
    }
}

// MARK: - Premium Card Style Modifier
/// Applies squircle shape, shadows, and haptic feedback
struct PremiumCardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    private var cardBackground: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.cardBlue
            : Color.white
    }

    private var cardStroke: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.goldMid.opacity(0.3)
            : CriticalDesign.Colors.navyAccent.opacity(0.10)
    }

    private func cardShadow(opacity: Double = 0.10) -> Color {
        colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(opacity * 3) : Color.black.opacity(opacity)
    }

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(cardStroke, lineWidth: 1)
            )
            .shadow(
                color: cardShadow(opacity: 0.08),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

// MARK: - Gradient Section Divider
/// Subtle gradient divider between sections
struct GradientSectionDivider: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.clear,
                Color(.systemGray4).opacity(0.3),
                Color(.systemGray4).opacity(0.5),
                Color(.systemGray4).opacity(0.3),
                Color.clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(height: 1)
        .padding(.horizontal, 40)
        .padding(.vertical, 8)
    }
}

extension View {
    func staggeredAnimation(index: Int, isVisible: Bool) -> some View {
        modifier(StaggeredCardModifier(index: index, isVisible: isVisible))
    }

    func premiumCard() -> some View {
        modifier(PremiumCardModifier())
    }
    
    /// Applies a gold gradient navigation bar title
    /// Navigation bar title in dark navy for visibility when scrolling (was gold gradient).
    func goldNavigationTitle(_ title: String) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(CriticalDesign.Colors.cardBlue)
                }
            }
    }

    /// Applies a navigation bar title with a NanoBanana icon beside it
    func goldNavigationTitle(_ title: String, image: String) -> some View {
        self
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(CriticalDesign.Colors.cardBlue)
                    }
                }
            }
    }
}

// MARK: - Haptic Button Style
/// Button style that provides haptic feedback and subtle press animation
struct HapticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    let haptic = UIImpactFeedbackGenerator(style: .light)
                    haptic.impactOccurred()
                }
            }
    }
}

// MARK: - See All Button Style
/// Button style for "See All" buttons with gold gradient in dark mode
struct SeeAllButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                colorScheme == .dark
                    ? CriticalDesign.Colors.cardBlue
                    : Color.logoBlue
            )
            .background(
                Capsule()
                    .fill(
                        colorScheme == .dark
                            ? LinearGradient(
                                colors: [
                                    CriticalDesign.Colors.goldLight,
                                    CriticalDesign.Colors.goldMid,
                                    CriticalDesign.Colors.goldDeep
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            : LinearGradient(
                                colors: [
                                    Color.white,
                                    Color.white
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
            )
            .overlay(
                Capsule()
                    .stroke(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.goldLight.opacity(0.6)
                            : Color.clear,
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark
                    ? CriticalDesign.Colors.gold.opacity(0.3)
                    : CriticalDesign.Colors.cardBlue.opacity(0.08),
                radius: 6,
                x: 0,
                y: 3
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Image Blending Modifier
/// Reusable modifier to seamlessly blend images with backgrounds, removing square outlines
/// Supports multiple blend modes for experimentation
@available(iOS 13.0, *)
struct SeamlessImageModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let accentColor: Color
    let shadowRadius: CGFloat
    let blendMode: BlendMode
    
    /// Blend mode options and their effects:
    /// - `.multiply`: Darkens background, removes white backgrounds (best for white/square backgrounds)
    /// - `.darken`: Shows darker of image or background (good for light backgrounds)
    /// - `.overlay`: Combines multiply and screen (subtle, balanced)
    /// - `.softLight`: Soft blending, preserves highlights
    /// - `.hardLight`: Stronger contrast than softLight
    /// - `.colorBurn`: Intense darkening, dramatic effect
    /// - `.screen`: Lightens background (inverse of multiply)
    /// - `.normal`: No blending (default)
    init(accentColor: Color = .blue, shadowRadius: CGFloat = 12, blendMode: BlendMode = .multiply) {
        self.accentColor = accentColor
        self.shadowRadius = shadowRadius
        self.blendMode = blendMode
    }
    
    func body(content: Content) -> some View {
        content
            // Apply selected blend mode to remove backgrounds and integrate with card
            .blendMode(blendMode)
            // Soft shadows for depth without hard edges (adaptive)
            .shadow(color: accentColor.opacity(0.25), radius: shadowRadius, x: 0, y: shadowRadius * 0.4)
            .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.black.opacity(0.08)), radius: shadowRadius * 0.6, x: 0, y: shadowRadius * 0.2)
            // Soft edge fade for seamless blending
            .mask(
                ZStack {
                    Rectangle()
                    // Fade edges - using white for masks (masks are opacity-based)
                    VStack {
                        LinearGradient(
                            colors: [.clear, .white, .white, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 15)
                        Spacer()
                        LinearGradient(
                            colors: [.clear, .white, .white, .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 15)
                    }
                    HStack {
                        LinearGradient(
                            colors: [.clear, .white, .white, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 15)
                        Spacer()
                        LinearGradient(
                            colors: [.clear, .white, .white, .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 15)
                    }
                }
            )
    }
}

extension View {
    /// Applies seamless blending to images, removing square outlines
    /// - Parameters:
    ///   - accentColor: Color for shadow effects
    ///   - shadowRadius: Radius of shadow blur
    ///   - blendMode: Blend mode to use (default: .multiply)
    ///     - `.multiply`: Best for removing white backgrounds
    ///     - `.darken`: Good for light backgrounds
    ///     - `.overlay`: Subtle, balanced blending
    ///     - `.softLight`: Soft blending with preserved highlights
    ///     - `.hardLight`: Stronger contrast
    ///     - `.colorBurn`: Dramatic darkening effect
    ///     - `.screen`: Lightens (inverse of multiply)
    @available(iOS 13.0, *)
    func seamlessBlend(accentColor: Color = .blue, shadowRadius: CGFloat = 12, blendMode: BlendMode = .multiply) -> some View {
        modifier(SeamlessImageModifier(accentColor: accentColor, shadowRadius: shadowRadius, blendMode: blendMode))
    }
}

// MARK: - Emoji Generation View (Extracted)
// EmojiGenerationView, UniformOptionCard, UniformType, and ImageCropView
// have been moved to Views/MainView/Home/EmojiGenerationView.swift
// Add that file to the Xcode target.

// MARK: - GlassKit Style Modifier
/// Glassmorphic cell style modifier for list items
@available(iOS 13.0, *)
struct GlassKitCellStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.8)
            )
            .shadow(color: Color.gray.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Neumorphic Cell Style Modifier
/// Neumorphic cell style modifier for list items - soft, extruded look
@available(iOS 13.0, *)
struct NeumorphicCellStyle: ViewModifier {
    var accentColor: Color = .clear
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.neumorphicBackground)
                        .shadow(color: Color.white.opacity(0.7), radius: 8, x: -4, y: -4)
                        .shadow(color: Color.neumorphicDarkShadow.opacity(0.25), radius: 8, x: 4, y: 4)
                    
                    // Optional accent border on left
                    if accentColor != .clear {
                        HStack {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(accentColor)
                                .frame(width: 4)
                                .padding(.vertical, 8)
                            Spacer()
                        }
                        .padding(.leading, 6)
                    }
                }
            )
    }
}

// MARK: - View Extension
/// Convenience extension to apply glassmorphic style to any view
extension View {
    @available(iOS 13.0, *)
    func glassKitCellStyle() -> some View {
        modifier(GlassKitCellStyle())
    }
    
    /// Apply neumorphic cell style - soft, extruded appearance
    @available(iOS 13.0, *)
    func neumorphicCellStyle(accentColor: Color = .clear) -> some View {
        modifier(NeumorphicCellStyle(accentColor: accentColor))
    }
}

// MARK: - Tab Model (Retained for reference — inner tab bar removed from Home)
struct TabItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: AnyView
    var color: Color
}

// MARK: - Main View
struct CriticalHomePage: View {
    
    // MARK: - Helper Functions
    /// Returns a time-based greeting (Good morning/afternoon/evening)
    /// Cached to avoid recalculating on every render
    private var timeGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12:
            return "Good morning,"
        case 12..<17:
            return "Good afternoon,"
        default:
            return "Good evening,"
        }
    }
    
    /// Fetches health news from NewsAPI with caching
    func fetchHealthNews(forceRefresh: Bool = false) {
        // Load from cache immediately for instant display
        if newsArticles.isEmpty, let cached = NewsCache.shared.articles, !cached.isEmpty {
            newsArticles = cached
        }
        
        // Skip network fetch if we have cached data and not forcing refresh
        // Also skip if already loading
        if !forceRefresh && !newsArticles.isEmpty {
            return
        }
        
        guard !isLoadingNews else { return }
        isLoadingNews = true
        newsError = nil

        let newsService = NewsService()

        Task { @MainActor in
            do {
                let articles = try await newsService.fetchHealthNews()
                self.newsArticles = articles
                NewsCache.shared.articles = articles // Cache for next time
                NewsCache.shared.lastFetch = Date()
                self.isLoadingNews = false
            } catch {
                self.isLoadingNews = false
                self.newsError = error.localizedDescription
                #if DEBUG
                print("Failed to fetch news: \(error.localizedDescription)")
                #endif
            }
        }
    }
    
    // MARK: - Medical Categories Data (Workflow-Based)
    /// Medical categories organized by clinical workflow: Assess → Calculate → Treat → Monitor → Reference
    let medicalCategories: [CategoryData] = [
        CategoryData(
            title: "Assess",
            icon: "stethoscope",
            color: .clear,
            items: [
                FeaturedMedItem(id: 1, title: "Airway", description: "Airway assessment & management", icon: "lungs.fill"),
                FeaturedMedItem(id: 2, title: "Cardiac", description: "EKG interpretation & workup", icon: "waveform.path.ecg"),
                FeaturedMedItem(id: 21, title: "ACLS Test Prep", description: "ACLS certification practice", icon: "list.clipboard.fill"),
                FeaturedMedItem(id: 9, title: "Neuro", description: "Neurological assessment", icon: "brain"),
                FeaturedMedItem(id: 7, title: "Lab Values", description: "Interpret lab results", icon: "chart.bar"),
                FeaturedMedItem(id: 20, title: "Lab Interpretation", description: "Analyze CBC, CMP, LFT patterns", icon: "microscope"),
                FeaturedMedItem(id: 12, title: "Hemodynamics", description: "Hemodynamic assessment", icon: "heart.circle")
            ]
        ),
        CategoryData(
            title: "Nursing",
            icon: "stethoscope",
            color: .clear,
            items: [
                FeaturedMedItem(id: 24, title: "Nursing Tools", description: "SBAR, Scales, Assessments, ICU", icon: "stethoscope"),
                FeaturedMedItem(id: 25, title: "SBAR Tool", description: "Structured communication", icon: "text.bubble.fill"),
                FeaturedMedItem(id: 26, title: "Clinical Scales", description: "RASS, CAM-ICU, Braden, Morse", icon: "chart.bar.fill"),
                FeaturedMedItem(id: 27, title: "Assessments", description: "Head-to-Toe & Focused", icon: "clipboard.fill"),
                FeaturedMedItem(id: 28, title: "ICU Tools", description: "Labs, Vent Weaning, ABCDEF", icon: "waveform.path.ecg.rectangle")
            ]
        ),
        CategoryData(
            title: "Calculate",
            icon: "function",
            color: .clear,
            items: [
                FeaturedMedItem(id: 3, title: "Med Calculators", description: "Dosing & clinical calculators", icon: "function"),
                FeaturedMedItem(id: 23, title: "Unit Converter", description: "Medical unit conversions", icon: "arrow.left.arrow.right"),
                FeaturedMedItem(id: 6, title: "Fluids & Blood", description: "Fluid & transfusion calculations", icon: "drop.triangle"),
                FeaturedMedItem(id: 17, title: "IV Compatibility", description: "Y-site drug compatibility checker", icon: "cross.fill")
            ]
        ),
        CategoryData(
            title: "Treat",
            icon: "cross.vial.fill",
            color: .clear,
            items: [
                FeaturedMedItem(id: 4, title: "Clinical Pharmacy", description: "Drug information & protocols", icon: "cross.case.fill"),
                FeaturedMedItem(id: 5, title: "Critical Drips", description: "IV infusion management", icon: "drop.fill"),
                FeaturedMedItem(id: 18, title: "Antibiotics", description: "Antibiotic selection & dosing", icon: "pills.fill"),
                FeaturedMedItem(id: 29, title: "Ultrasound", description: "E-FAST, RUSH, POCUS", icon: "icon-ultrasound 1"),
                FeaturedMedItem(id: 30, title: "REBOA", description: "Resuscitative endovascular balloon occlusion", icon: "icon-aorta"),
                FeaturedMedItem(id: 13, title: "Procedures", description: "CXR, central line & imaging", icon: "xray")
            ]
        ),
        CategoryData(
            title: "Monitor",
            icon: "waveform.path.ecg.rectangle",
            color: .clear,
            items: [
                FeaturedMedItem(id: 14, title: "Vent Management", description: "Ventilator optimization", icon: "waveform.path"),
                FeaturedMedItem(id: 8, title: "Balloon Pump", description: "IABP timing & management", icon: "waveform.path.ecg.rectangle")
            ]
        ),
        CategoryData(
            title: "Specialty",
            icon: "person.2.fill",
            color: .clear,
            items: [
                FeaturedMedItem(id: 10, title: "Pediatrics", description: "Pediatric-specific care", icon: "figure.child"),
                FeaturedMedItem(id: 11, title: "Obstetrics", description: "OB emergencies & care", icon: "figure.pregnant"),
                FeaturedMedItem(id: 19, title: "Organ Donation", description: "Brain death & donor management", icon: "heart.circle.fill"),
                FeaturedMedItem(id: 22, title: "GI / GU", description: "Renal, GI & electrolyte management", icon: "cross.vial.fill")
            ]
        ),
        CategoryData(
            title: "Reference",
            icon: "book.fill",
            color: .clear,
            items: [
                FeaturedMedItem(id: 15, title: "Critical References", description: "Quick reference guides", icon: "book.fill"),
                FeaturedMedItem(id: 16, title: "Abbreviations", description: "Medical abbreviations", icon: "textformat")
            ]
        )
    ]
    
    // MARK: - State Properties
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Dark Mode Helper Properties
    private var cardBackground: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.cardBlue
            : Color.white
    }

    private var cardStroke: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.goldMid.opacity(0.3)
            : CriticalDesign.Colors.navyAccent.opacity(0.10)
    }

    private func cardShadow(opacity: Double = 0.10) -> Color {
        colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(opacity * 3) : Color.black.opacity(opacity)
    }

    private var textPrimary: Color {
        CriticalDesign.Adaptive.textPrimary(for: colorScheme)
    }

    private var textSecondary: Color {
        CriticalDesign.Adaptive.textSecondary(for: colorScheme)
    }

    private var textTertiary: Color {
        CriticalDesign.Adaptive.textTertiary(for: colorScheme)
    }

    private var textMuted: Color {
        colorScheme == .dark
            ? .white.opacity(0.3)
            : Color(red: 0.42, green: 0.49, blue: 0.54)
    }

    // Inner tab bar removed — all destinations accessible via bottom tabs or home screen cards
    // private let tabItems: [TabItem]
    // @State private var selectedTab: TabItem
    @State private var isAnimating = false
    @State private var showProfile = false
    @Namespace private var animation

    /// Changing this ID resets the NavigationView, popping to root
    @State private var navigationID = UUID()
    
    /// UI State
    @State private var showMomentSearch = false
    @StateObject private var userSettings = UserSettings()
    @StateObject private var subscriptionManager = SubscriptionManager()
    @ObservedObject private var patientContext = GlobalPatientContext.shared
    @State private var showWeightEditor = false
    @State private var showSettings = false
    @State private var isFavorite = false
    @State private var selectedCategory: CategoryData?
    @State private var searchText = ""
    @State private var searchModeActivated = false
    // MARK: Moment Integration
    @State private var detectedMoment: MomentType? = nil
    @State private var showMomentView = false
    @AppStorage("enableMoments") private var enableMoments: Bool = true
    
    /// User Preferences (AppStorage)
    @AppStorage("medicalInstitution") private var medicalInstitution: String = ""
    @AppStorage("tags") private var tags: String = ""
    @AppStorage("showProfileCard") private var showProfileCard: Bool = true
    @AppStorage("showNewsTicker") private var showNewsTicker: Bool = true

    /// News API State
    @State private var newsArticles: [NewsArticle] = []
    @State private var isLoadingNews = false
    @State private var newsError: String?

    /// Premium UI State - Scroll-driven animation
    @State private var scrollOffset: CGFloat = 0
    @State private var initialScrollY: CGFloat? = nil  // Captures initial position for calibration
    @State private var cardsHaveAppeared = false
    @State private var collapseEnabled = false  // Prevents collapse on initial load

    // Animation thresholds for smooth collapse
    private let animationStartOffset: CGFloat = 40   // Start animating
    private let animationEndOffset: CGFloat = 140    // Fully collapsed

    /// Progress from 0 (card visible) to 1 (fully collapsed)
    /// Drives smooth scroll-based animation
    private var collapseProgress: CGFloat {
        guard collapseEnabled else { return 0 }
        guard scrollOffset > animationStartOffset else { return 0 }
        guard scrollOffset < animationEndOffset else { return 1 }
        return (scrollOffset - animationStartOffset) / (animationEndOffset - animationStartOffset)
    }

    /// Card visibility (inverse of collapse progress)
    private var cardVisibility: CGFloat {
        1 - collapseProgress
    }

    /// Legacy computed property for binary checks
    private var isProfileCollapsed: Bool {
        collapseProgress > 0.5
    }

    // MARK: - Initialization
    // Inner tab bar removed — Co-Pilot is now the search bar, Nursing is a category card,
    // Med/Drips/Peds/Favorites already exist in the bottom tab bar.
    // Original init preserved in ModernTabBarView.swift for reference.
    
    
    // MARK: Main Body View
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
            ZStack {
                // MARK: - Navigation Bar Background (CardBlue)
                VStack(spacing: 0) {
                    CriticalDesign.Colors.cardBlue
                        .frame(height: geometry.safeAreaInsets.top)
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                }
                .zIndex(0)

                // MARK: - Full-height background (tinted blue-gray in light, dark canvas in dark)
                (colorScheme == .dark ? CriticalDesign.Adaptive.canvas(for: colorScheme) : Color(red: 0.94, green: 0.95, blue: 0.97))
                    .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    ScrollView {
                        // MARK: - Main Content Container (Refactored Layout)
                        VStack(spacing: 0) {

                            // MARK: - 1. News Ticker — now inside welcome card (see showNewsTicker: true below)

                            // MARK: - 2. Trial / Free-Tier Banners
                            if !searchModeActivated {
                                TrialReminderBanner()
                                    .padding(.horizontal, 4)
                                FreeUserFOMOBanner()
                                    .padding(.horizontal, 4)
                            }

                            // MARK: - 3. User Welcome Card (with integrated news ticker)
                            // Scroll-driven animation: card morphs into nav bar (PRESERVED)
                            if !searchModeActivated && showProfileCard {
                                UserWelcomeCard(
                                    greeting: timeGreeting,
                                    userName: userSettings.name.isEmpty ? "Clinician" : userSettings.name,
                                    institution: medicalInstitution,
                                    tags: tags,
                                    isCollapsed: false,
                                    showNewsTicker: showNewsTicker, // News ticker now inside the card
                                    onSetupProfileTapped: { showSettings = true },
                                    isLoadingNews: $isLoadingNews,
                                    newsError: $newsError,
                                    newsArticles: $newsArticles,
                                    subscriptionManager: subscriptionManager
                                )
                                .padding(.horizontal, 20)
                                .padding(.bottom, 16)
                                .padding(.top, 12)
                                // Scroll-driven transforms (UNCHANGED)
                                .opacity(cardVisibility)
                                .scaleEffect(1 - (collapseProgress * 0.12), anchor: .top)
                                .offset(y: -collapseProgress * 30)
                                .allowsHitTesting(cardVisibility > 0.3)
                                .animation(.easeOut(duration: 0.15), value: collapseProgress)
                            }

                            // MARK: - 4. Co-Pilot Search Bar (tap to open NLMomentSearchView)
                            Button {
                                let haptic = UIImpactFeedbackGenerator(style: .light)
                                haptic.impactOccurred()
                                showMomentSearch = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)

                                    Text("Search or ask Co-Pilot...")
                                        .font(.system(size: 15))
                                        .foregroundColor(.secondary)

                                    Spacer()

                                    // AI badge
                                    Text("AI")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(
                                                    LinearGradient(
                                                        colors: [CriticalDesign.Colors.accentPurple, CriticalDesign.Colors.accentBlue],
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                        )
                                }
                                .padding(.horizontal, 18)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .fill(cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                                .stroke(cardStroke, lineWidth: 1)
                                        )
                                )
                                .shadow(
                                    color: cardShadow(opacity: 0.08),
                                    radius: 10,
                                    x: 0,
                                    y: 4
                                )
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)

                            // MARK: - 5. Emergency Quick Actions (NanoBanana icons, mockup style)
                            homeEmergencySection
                                .padding(.bottom, 16)

                            // MARK: - 6. Recent Calculations
                            homeRecentCalculations
                                .padding(.top, 8)
                                .padding(.bottom, 16)

                            // MARK: - 7. Category Grid
                            homeCategoryGrid

                            // Bottom padding to clear tab bar
                            Spacer()
                                .frame(height: 100)
                        }
                        // Scroll offset tracker - using overlay for reliable tracking
                        .overlay(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        // Capture initial position when view first appears
                                        if initialScrollY == nil {
                                            initialScrollY = geo.frame(in: .global).minY
                                        }
                                    }
                                    .onChange(of: geo.frame(in: .global).minY) { newValue in
                                        // Capture initial position if not set
                                        if initialScrollY == nil {
                                            initialScrollY = newValue
                                        }
                                        // Calculate offset relative to initial position
                                        // When content moves up, offset increases
                                        let offset = (initialScrollY ?? newValue) - newValue
                                        scrollOffset = max(0, offset)
                                    }
                            }
                        )
                        // So rounded corners of welcome card match page tint in light mode
                        .background(
                            (colorScheme == .dark ? CriticalDesign.Colors.darkCanvas : Color(red: 0.94, green: 0.95, blue: 0.97))
                                .ignoresSafeArea()
                        )
                    }
                }
                .scrollContentBackground(.hidden)
                // MARK: - Content Background (tinted in light mode, dark canvas in dark — no sheet curve)
                .background(
                    (colorScheme == .dark ? CriticalDesign.Colors.darkCanvas : Color(red: 0.94, green: 0.95, blue: 0.97))
                        .ignoresSafeArea()
                )
                // MARK: - Lifecycle
                .onAppear {
                    withAnimation {
                        isAnimating = true
                    }
                    fetchHealthNews()

                    // Enable collapse after initial render to prevent collapsed state on load
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        collapseEnabled = true
                    }
                }
                .padding(.top, 20)

            }
            }
            // Note: Floating AI button is provided by TabBarView globally
            // MARK: - Navigation Bar (Navy Blue in Both Modes)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                CriticalDesign.Colors.cardBlue,
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // Crossfade between settings button and collapsed profile
                    HStack(spacing: 10) {
                        ZStack {
                            Button {
                                showSettings = true
                            } label: {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .opacity(1 - collapseProgress)

                            collapsedNavBarProfile
                                .opacity(collapseProgress)
                                .scaleEffect(0.7 + (collapseProgress * 0.3))
                        }

                        // Weight indicator pill (leading side, balances wand on trailing)
                        if patientContext.hasWeight {
                            Button {
                                let haptic = UIImpactFeedbackGenerator(style: .light)
                                haptic.impactOccurred()
                                showWeightEditor = true
                            } label: {
                                HStack(spacing: 3) {
                                    Image(systemName: "scalemass")
                                        .font(.system(size: 10, weight: .semibold))
                                    Text(patientContext.weightDisplayString ?? "")
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(Color.white.opacity(0.15))
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                        )
                                )
                            }
                            .opacity(1 - collapseProgress)
                        }
                    }
                    .animation(.easeOut(duration: 0.15), value: collapseProgress)
                }

                ToolbarItem(placement: .principal) {
                    // Crossfade between app title and user name
                    ZStack {
                        Text("Critical Med")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .opacity(1 - collapseProgress)

                        Text(userSettings.name.isEmpty ? "Clinician" : userSettings.name)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .opacity(collapseProgress)
                    }
                    .animation(.easeOut(duration: 0.15), value: collapseProgress)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    // Moment Search Button (wand) — only item on trailing side
                    Button {
                        showMomentSearch = true
                    } label: {
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            CriticalDesign.Colors.goldLight,
                                            CriticalDesign.Colors.goldDeep
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 32, height: 28)
                                .background(
                                    Capsule()
                                        .fill(CriticalDesign.Colors.cardBlue)
                                )
                    }
                }
            }
            // MARK: - Sheet Modifiers
            .sheet(isPresented: $showWeightEditor) {
                PatientContextEditor()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(userSettings: userSettings)
            }
            // MARK: Moment Search (wand → Ask a Question)
            .sheet(isPresented: $showMomentSearch) {
                NLMomentSearchView()
            }
            // MARK: Moment Sheet
            .sheet(isPresented: $showMomentView) {
                if let moment = detectedMoment {
                    NavigationView {
                        getMomentView(for: moment)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Done") {
                                        showMomentView = false
                                    }
                                }
                            }
                    }
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isProfileCollapsed)
        }
        .id(navigationID) // Reset NavigationView (pop to root) when this changes
        .onReceive(NotificationCenter.default.publisher(for: .popHomeToRoot)) { _ in
            navigationID = UUID() // New ID → NavigationView recreates → pops to root
        }
        // Floating weight button is shown from TabBarView (on top of tab bar) so it receives touches on Home tab
    }

    // MARK: - Emergency Quick Actions (Inline — matches mockup)

    private struct HomeEmergencyItem: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let image: String        // NanoBanana asset
        let destination: AnyView // Direct navigation destination
    }

    private var homeEmergencyItems: [HomeEmergencyItem] {
        [
            HomeEmergencyItem(title: "RSI", subtitle: "Rapid Sequence Intubation", image: "NanoBanana/calc/calc_rsi_rapid_sequence_intubation",
                              destination: AnyView(RSIIMainView().navigationBarBackground { Color.logoBlue.shadow(radius: 1) })),
            HomeEmergencyItem(title: "Cardiac", subtitle: "EKG, ACLS & Hemodynamics", image: "icons-heart",
                              destination: AnyView(CriticalEKGView().goldNavigationTitle("Cardiac"))),
            HomeEmergencyItem(title: "Drips", subtitle: "Critical Infusions", image: "NanoBanana/home/home_drips",
                              destination: AnyView(DripsTableView().navigationBarHidden(false).goldNavigationTitle("Drips"))),
            HomeEmergencyItem(title: "Airway", subtitle: "Assessment & Management", image: "NanoBanana/home/home_airway",
                              destination: AnyView(AirWayView().goldNavigationTitle("Airway"))),
        ]
    }

    @State private var emergencyPulse = false
    @State private var emergencyNavId: Int? = nil
    @State private var emergencyNavActive = false
    @State private var selectedEmergencyDestination: AnyView? = nil

    // Programmatic navigation for category grid (avoids NavigationLink-in-ScrollView tap bug)
    @State private var categoryNavActive = false
    @State private var selectedCategoryNavId: Int = 0

    private var homeEmergencySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header with pulsing red light
            HStack(spacing: 8) {
                // Flashing red dot
                ZStack {
                    Circle()
                        .fill(CriticalDesign.Colors.accentRed.opacity(0.3))
                        .frame(width: 20, height: 20)
                        .scaleEffect(emergencyPulse ? 1.4 : 0.8)
                        .opacity(emergencyPulse ? 0.0 : 0.6)

                    Circle()
                        .fill(CriticalDesign.Colors.accentRed)
                        .frame(width: 8, height: 8)
                        .shadow(color: CriticalDesign.Colors.accentRed.opacity(emergencyPulse ? 0.8 : 0.3), radius: emergencyPulse ? 6 : 2)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                        emergencyPulse = true
                    }
                }

                Text("Emergency")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(textPrimary)

                Spacer()

                NavigationLink(destination: CriticalHomePage.EmergencyToolsListView()) {
                    Text("See All")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? CriticalDesign.Colors.gold : CriticalDesign.Colors.navyAccent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.12) : CriticalDesign.Colors.navyAccent.opacity(0.08))
                        )
                }
            }
            .padding(.horizontal, 20)

            // Horizontal scroll of cards
            // Using Button + programmatic NavigationLink to avoid
            // NavigationLink tap-detection issues inside ScrollView(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(homeEmergencyItems) { item in
                        Button {
                            selectedEmergencyDestination = item.destination
                            emergencyNavActive = true
                        } label: {
                            homeEmergencyCard(item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationDestination(isPresented: $emergencyNavActive) {
                if let dest = selectedEmergencyDestination {
                    dest
                }
            }
        }
    }

    private func homeEmergencyCard(_ item: HomeEmergencyItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            CatalogThumbnailImage(name: item.image, size: 62, cornerRadius: 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 72)
                .padding(.top, 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(textPrimary)
                Text(item.subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(textSecondary)
                    .lineLimit(2)
            }
            .padding(.top, 10)

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(width: 170, height: 165)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(cardStroke, lineWidth: 1)
                )
        )
        .shadow(color: cardShadow(opacity: 0.10), radius: 8, x: 0, y: 4)
    }

    // MARK: - Recent Calculations (Inline — matches mockup)

    @ObservedObject private var calculationHistoryTracker = RecentlyUsedTracker.shared

    private var homeRecentCalculations: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(textSecondary)
                Text("Recent")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(textPrimary)
                Spacer()
                Button {
                    // TODO: Navigate to full history view
                } label: {
                    Text("History")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? CriticalDesign.Colors.gold : CriticalDesign.Colors.navyAccent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.12) : CriticalDesign.Colors.navyAccent.opacity(0.08))
                        )
                }
            }
            .padding(.horizontal, 20)

            // Recent rows
            VStack(spacing: 8) {
                ForEach(calculationHistoryTracker.items.prefix(3)) { item in
                    NavigationLink(destination: NavigationFactory.getDestinationView(for: item.itemId)) {
                        homeRecentRow(item)
                    }
                    .buttonStyle(.plain)
                }

                // Empty state
                if calculationHistoryTracker.items.isEmpty {
                    HStack(spacing: 12) {
                        Image(systemName: "clock")
                            .font(.system(size: 20))
                            .foregroundColor(textTertiary)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("No recent activity")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(textSecondary)
                            Text("Your recent calculations will appear here")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(textTertiary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func homeRecentRow(_ item: RecentItem) -> some View {
        HStack(spacing: 12) {
            // Icon circle — brand accent, stronger contrast in light mode
            Image(systemName: item.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(colorScheme == .dark ? CriticalDesign.Colors.gold : CriticalDesign.Colors.navyAccent)
                .frame(width: 32, height: 32)
                .background(
                    Circle().fill(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.gold.opacity(0.15)
                            : CriticalDesign.Colors.navyAccent.opacity(0.12)
                    )
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(textPrimary)
                if !item.detail.isEmpty {
                    Text(item.detail)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundColor(textTertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(timeAgo(from: item.lastUsed))
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(textTertiary)

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(textTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(cardStroke, lineWidth: 1)
                )
        )
        .shadow(color: cardShadow(opacity: 0.08), radius: 8, x: 0, y: 4)
    }

    /// Relative time string
    private func timeAgo(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 { return "Just now" }
        if seconds < 3600 { return "\(seconds / 60)m ago" }
        if seconds < 86400 { return "\(seconds / 3600)h ago" }
        return "\(seconds / 86400)d ago"
    }

    // MARK: - Home Category Grid
    /// Clean 2-column grid with NanoBanana 3D icons — each card navigates via NavigationFactory
    private var homeCategoryGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(textSecondary)
                Text("Categories")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(textPrimary)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(homeCategoryItems) { item in
                    Button {
                        selectedCategoryNavId = item.navId
                        categoryNavActive = true
                    } label: {
                        homeCategoryCard(item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $categoryNavActive) {
                NavigationFactory.getDestinationView(for: selectedCategoryNavId)
            }
        }
    }

    /// Data for the home category grid
    private struct HomeCategoryGridItem: Identifiable {
        let id = UUID()
        let title: String
        let image: String   // NanoBanana asset
        let navId: Int       // Maps to NavigationFactory ID
        let toolCount: Int   // Number of sub-views/tools inside
    }

    private var homeCategoryItems: [HomeCategoryGridItem] {
        [
            // Drips & Meds/Pharmacology removed — accessible via bottom tab bar
            // Tool counts based on actual Swift files in each category folder
            HomeCategoryGridItem(title: "Airway",          image: "NanoBanana/home/home_airway",                 navId: 1,  toolCount: 14),
            HomeCategoryGridItem(title: "Cardiac",         image: "NanoBanana/home/home_cardiac",                navId: 2,  toolCount: 52),
            HomeCategoryGridItem(title: "Calculators",     image: "NanoBanana/home/home_calculators",            navId: 3,  toolCount: 103),
            HomeCategoryGridItem(title: "Blood & Fluids",  image: "NanoBanana/home/home_blood_and_fluids",       navId: 6,  toolCount: 8),
            HomeCategoryGridItem(title: "Neuro",           image: "NanoBanana/home/home_neuro",                  navId: 9,  toolCount: 16),
            HomeCategoryGridItem(title: "Vent Management", image: "NanoBanana/home/home_ventilator_management",  navId: 14, toolCount: 22),
            HomeCategoryGridItem(title: "Procedures",      image: "NanoBanana/home/home_procedures_and_imaging", navId: 13, toolCount: 29),
            HomeCategoryGridItem(title: "Nursing",         image: "NanoBanana/home/home_nursing",                navId: 24, toolCount: 15),
            HomeCategoryGridItem(title: "Hemodynamics",    image: "NanoBanana/home/home_hemodynamics",           navId: 12, toolCount: 3),
            HomeCategoryGridItem(title: "Organ Donation", image: "NanoBanana/home/home_organ_donation",         navId: 19, toolCount: 8),
            HomeCategoryGridItem(title: "Antibiotics",     image: "NanoBanana/home/home_antibiotics_masterclass",navId: 18, toolCount: 6),
        ]
    }

    /// Individual category card — vent page style (white→canvas gradient, soft shadow, light stroke)
    private func homeCategoryCard(_ item: HomeCategoryGridItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            CatalogThumbnailImage(name: item.image, size: 46, cornerRadius: 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 54)
                .padding(.top, 2)

            Text(item.title)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(textPrimary)
                .lineLimit(2)
                .padding(.top, 8)

            Text("\(item.toolCount) tools")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(textTertiary)
                .padding(.top, 2)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(cardStroke, lineWidth: 1)
                )
        )
        .shadow(color: cardShadow(opacity: 0.08), radius: 8, x: 0, y: 4)
    }

    // MARK: - Collapsed Nav Bar Components

    /// Gold gradient for nav bar text
    private var navBarGoldGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "F5E6A3"),
                Color(hex: "C9A227")
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    /// Mini profile for collapsed nav bar - uses shared NavBarProfileView component (white text on dark bar)
    private var collapsedNavBarProfile: some View {
        NavBarProfileView(
            showName: true,
            showTierBadge: true,
            size: 32,
            forceLightText: true
        ) {
            showSettings = true
        }
    }

}

// MARK: - Data Models
// Note: NewsArticle is now defined in NewsService.swift

// MARK: - Modern Tab Bar View (ARCHIVED — not used in new Home layout)
// Kept for reference. The horizontal inner tab bar duplicated bottom tabs.
// Co-Pilot → now the AI search bar on Home. Nursing → now a category card.
// Med, Drips, Peds, Favorites → accessible via bottom tab bar.
struct ModernTabBarView: View {
    let tabItems: [TabItem]
    @Binding var selectedTab: TabItem
    let namespace: Namespace.ID
    
    // Gold gradient colors matching profile card
    private let goldGradient = LinearGradient(
        colors: [
            Color(hex: "F5E6A3"), // Light gold / champagne
            Color(hex: "DEBD68"), // Mid gold
            Color(hex: "C9A227")  // Deep gold / antique
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Subtle gold background for active tab
    private let goldBackgroundGradient = LinearGradient(
        colors: [
            Color(hex: "F5E6A3").opacity(0.25),
            Color(hex: "C9A227").opacity(0.15)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(tabItems) { tab in
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: tab.icon)
                                .font(.system(size: 16, weight: .semibold))
                            Text(tab.title)
                                .font(.system(size: 16, weight: selectedTab.id == tab.id ? .semibold : .regular))
                        }
                        .foregroundStyle(selectedTab.id == tab.id ? AnyShapeStyle(Color.white) : AnyShapeStyle(Color.secondary))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            ZStack {
                                if selectedTab.id == tab.id {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    CriticalDesign.Colors.goldLight,
                                                    CriticalDesign.Colors.goldMid,
                                                    CriticalDesign.Colors.goldDeep
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .matchedGeometryEffect(id: "tab_background", in: namespace)
                                }
                            }
                        )
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.leading, 5)
        }
        .padding(.horizontal, -20)
    }
}

// MARK: - Recently Used Tracker

struct RecentItem: Identifiable, Codable, Equatable {
    var id: String { "\(itemId)_\(Int(lastUsed.timeIntervalSince1970))" }
    let itemId: Int
    let title: String
    let icon: String
    let detail: String  // Calculation result summary, e.g. "2.4 L deficit · 70kg · Na 152"
    let lastUsed: Date

    // Backwards compatibility — items without detail
    init(itemId: Int, title: String, icon: String, detail: String = "", lastUsed: Date = Date()) {
        self.itemId = itemId
        self.title = title
        self.icon = icon
        self.detail = detail
        self.lastUsed = lastUsed
    }
}

@MainActor
final class RecentlyUsedTracker: ObservableObject {
    static let shared = RecentlyUsedTracker()

    private let storageKey = "recentlyUsedItems"
    private let maxItems = 8

    @Published private(set) var items: [RecentItem] = []

    private init() { load() }

    /// Track a section visit (no calculation detail)
    func track(id: Int, title: String, icon: String) {
        trackWithDetail(id: id, title: title, icon: icon, detail: "")
    }

    /// Track a calculation with result detail (e.g. "2.4 L deficit · 70kg · Na 152")
    func trackCalculation(title: String, icon: String, detail: String) {
        // Use negative IDs for calculations so they don't conflict with section IDs
        // Each calculation gets a unique ID based on timestamp
        let calcId = -(Int(Date().timeIntervalSince1970) % 100000)
        trackWithDetail(id: calcId, title: title, icon: icon, detail: detail)
    }

    private func trackWithDetail(id: Int, title: String, icon: String, detail: String) {
        var list = items
        // For section visits (positive IDs), remove duplicates
        if id >= 0 {
            list.removeAll { $0.itemId == id }
        }
        let entry = RecentItem(itemId: id, title: title, icon: icon, detail: detail, lastUsed: Date())
        list.insert(entry, at: 0)
        if list.count > maxItems { list = Array(list.prefix(maxItems)) }
        items = list
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([RecentItem].self, from: data) else { return }
        items = decoded
    }
}

// MARK: - Recently Used Section
/// Horizontal scrollable row of recently accessed tools for fast re-access
struct RecentlyUsedSection: View {
    @ObservedObject private var tracker = RecentlyUsedTracker.shared
    @Environment(\.colorScheme) var colorScheme

    private var cardBg: Color {
        colorScheme == .dark ? CriticalDesign.Colors.cardBlue : .white
    }
    private var strokeColor: Color {
        colorScheme == .dark
            ? CriticalDesign.Colors.goldMid.opacity(0.25)
            : CriticalDesign.Colors.navyAccent.opacity(0.08)
    }
    private var textPrimary: Color {
        CriticalDesign.Adaptive.textPrimary(for: colorScheme)
    }
    private var textSecondary: Color {
        CriticalDesign.Adaptive.textSecondary(for: colorScheme)
    }

    var body: some View {
        if !tracker.items.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(textSecondary)
                    Text("Recently Used")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tracker.items) { item in
                            RecentItemChip(item: item, cardBg: cardBg, strokeColor: strokeColor, textPrimary: textPrimary)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

/// Individual chip for a recently used item
private struct RecentItemChip: View {
    let item: RecentItem
    let cardBg: Color
    let strokeColor: Color
    let textPrimary: Color
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: item.icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(colorScheme == .dark ? CriticalDesign.Colors.gold : .logoBlue)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(colorScheme == .dark ? CriticalDesign.Colors.gold.opacity(0.15) : Color.logoBlue.opacity(0.1))
                )

            Text(item.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(textPrimary)
                .lineLimit(1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(cardBg)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(strokeColor, lineWidth: 1)
        )
        .shadow(
            color: colorScheme == .dark ? Color.black.opacity(0.2) : Color.black.opacity(0.04),
            radius: 6, x: 0, y: 3
        )
    }
}

/// Represents any searchable item (top-level or nested)
struct SearchableItem {
    let id: Int
    let title: String
    let description: String
    let categoryTitle: String
    let parentId: Int // ID of parent item if nested
    let isNested: Bool // True if this is embedded/nested content
}

// MARK: - Home Page Content View
/// Main content view that displays medical categories and handles filtering
struct HomePageContentView: View {
    let medicalCategories: [CriticalHomePage.CategoryData]
    let selectedCategory: CriticalHomePage.CategoryData?
    let searchText: String
    
    // MARK: - Comprehensive Searchable Items
    /// All nested/embedded items that should be searchable (ECMO, medications, calculators, etc.)
    private var allSearchableItems: [SearchableItem] {
        var items: [SearchableItem] = []
        
        // Add all top-level category items
        for category in medicalCategories {
            for item in category.items {
                items.append(SearchableItem(
                    id: item.id,
                    title: item.title,
                    description: item.description,
                    categoryTitle: category.title,
                    parentId: item.id,
                    isNested: false
                ))
            }
        }
        
        // Add nested EKG items (embedded in Critical EKG - id: 2)
        items.append(contentsOf: [
            SearchableItem(id: 201, title: "ECMO", description: "Extracorporeal Membrane Oxygenation", categoryTitle: "Emergency & Critical Care", parentId: 2, isNested: true),
            SearchableItem(id: 202, title: "VADs", description: "Ventricular Assist Devices", categoryTitle: "Emergency & Critical Care", parentId: 2, isNested: true),
            SearchableItem(id: 203, title: "Pacemakers", description: "Cardiac pacemaker information", categoryTitle: "Emergency & Critical Care", parentId: 2, isNested: true),
            SearchableItem(id: 204, title: "ACLS", description: "Advanced Cardiac Life Support", categoryTitle: "Emergency & Critical Care", parentId: 2, isNested: true),
            SearchableItem(id: 205, title: "TTM", description: "Targeted Temperature Management", categoryTitle: "Emergency & Critical Care", parentId: 2, isNested: true),
            SearchableItem(id: 206, title: "Leads", description: "EKG lead placement and interpretation", categoryTitle: "Emergency & Critical Care", parentId: 2, isNested: true)
        ])
        
        // Add nested Calculator items (embedded in Med Calculators - id: 3)
        items.append(contentsOf: [
            SearchableItem(id: 301, title: "ABG Calculator", description: "Arterial Blood Gas calculator", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 302, title: "Anion Gap", description: "Anion gap calculator", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 303, title: "Bicarbonate", description: "Bicarbonate deficit calculator", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 304, title: "BMI Calculator", description: "Body Mass Index calculator", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 305, title: "Check My Drip", description: "IV drip rate calculator", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 306, title: "Consensus", description: "Consensus calculator", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 307, title: "CRRT Dosing", description: "Continuous Renal Replacement Therapy dosing", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 308, title: "FeNa", description: "Fractional Excretion of Sodium", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 309, title: "Free Water Deficit", description: "Free water deficit calculator", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 310, title: "Ideal Body Weight", description: "Ideal body weight calculator", categoryTitle: "Medication Management", parentId: 3, isNested: true),
            SearchableItem(id: 311, title: "IV Drip Rate", description: "Intravenous drip rate calculator", categoryTitle: "Medication Management", parentId: 3, isNested: true)
        ])
        
        // Add Unit Converter as a top-level searchable item
        items.append(SearchableItem(id: 23, title: "Unit Converter", description: "Medical unit conversions", categoryTitle: "Calculate", parentId: 0, isNested: false))
        
        // Add nested Nursing items (embedded in Nursing Tools - id: 24)
        items.append(contentsOf: [
            SearchableItem(id: 2401, title: "SBAR", description: "SBAR communication tool", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2402, title: "Shift Handoff", description: "Shift report handoff tool", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2403, title: "RASS", description: "Richmond Agitation-Sedation Scale", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2404, title: "CAM-ICU", description: "Confusion Assessment Method for ICU delirium", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2405, title: "Braden Scale", description: "Pressure injury risk assessment", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2406, title: "Morse Fall Scale", description: "Fall risk assessment", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2407, title: "Pain Scales", description: "NRS, CPOT, Wong-Baker pain assessment", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2408, title: "Head-to-Toe Assessment", description: "Systematic body systems assessment", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2409, title: "Focused Assessments", description: "Chest pain, SOB, AMS, trauma focused assessments", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2410, title: "Critical Lab Values", description: "Panic values and critical lab alerts", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2411, title: "Ventilator Weaning", description: "SBT readiness and extubation criteria", categoryTitle: "Nursing", parentId: 24, isNested: true),
            SearchableItem(id: 2412, title: "ABCDEF Bundle", description: "ICU liberation protocol", categoryTitle: "Nursing", parentId: 24, isNested: true)
        ])
        
        return items
    }
    
    // MARK: - Filtering Logic
    /// Filters categories based on selected category and search text
    /// Now includes nested/embedded items in search results
    /// Cached computation to avoid recalculating on every render
    private var filteredCategories: [CriticalHomePage.CategoryData] {
        var categories = medicalCategories
        
        // Filter by selected category first
        if let selected = selectedCategory {
            categories = [selected]
        }
        
        // Then filter by search text if present
        if !searchText.isEmpty {
            let searchableItems = allSearchableItems.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.description.localizedCaseInsensitiveContains(searchText) ||
                item.categoryTitle.localizedCaseInsensitiveContains(searchText)
            }
            
            // Group searchable items by category
            var categoryMap: [String: [CriticalHomePage.FeaturedMedItem]] = [:]
            
            for searchableItem in searchableItems {
                if !searchableItem.isNested {
                    // Top-level item - find its original category
                    if let category = categories.first(where: { $0.title == searchableItem.categoryTitle }),
                       let originalItem = category.items.first(where: { $0.id == searchableItem.id }) {
                        if categoryMap[category.title] == nil {
                            categoryMap[category.title] = []
                        }
                        categoryMap[category.title]?.append(originalItem)
                    }
                } else {
                    // Nested item - add parent item to results
                    if let category = categories.first(where: { $0.title == searchableItem.categoryTitle }),
                       let parentItem = category.items.first(where: { $0.id == searchableItem.parentId }) {
                        if categoryMap[category.title] == nil {
                            categoryMap[category.title] = []
                        }
                        // Only add parent if not already in list
                        if !categoryMap[category.title]!.contains(where: { $0.id == parentItem.id }) {
                            categoryMap[category.title]?.append(parentItem)
                        }
                    }
                }
            }
            
            // Convert map back to CategoryData array
            return categoryMap.compactMap { (categoryTitle, items) in
                guard let originalCategory = categories.first(where: { $0.title == categoryTitle }) else {
                    return nil
                }
                return CriticalHomePage.CategoryData(
                    title: originalCategory.title,
                    icon: originalCategory.icon,
                    color: originalCategory.color,
                    items: items
                )
            }
        }
        
        return categories
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                // MARK: - Medication Quick Reference (Priority in Search)
                // Shows medication matches at top of search results
                if !searchText.isEmpty {
                    MedicationSearchResultsSection(searchText: searchText)
                        .padding(.top, 8)
                        .id("medication-search")
                }

                if filteredCategories.isEmpty && !searchText.isEmpty {
                    // Check if we have medication results before showing "no results"
                    let hasMedicationResults = !MedicationLookupService.findMedications(searchText).isEmpty

                    if !hasMedicationResults {
                        // Show no results message only if no medications found either
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No results found")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text("Try adjusting your search")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                        .id("no-results")
                    }
                } else {
                    // MARK: - Recently Viewed Section (Only when not searching/filtering)
                    if selectedCategory == nil && searchText.isEmpty {
                        CriticalHomePage.RecentlyViewedSection()
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .id("recently-viewed")

                        // MARK: - Smart Suggestions (Time-based)
                        CriticalHomePage.SmartSuggestionsSection()
                            .padding(.horizontal, 20)
                            .id("smart-suggestions")
                    }

                    // MARK: - Category Sections
                    ForEach(Array(filteredCategories.enumerated()), id: \.element.id) { index, category in
                        // Gradient divider between sections (not before first)
                        if index > 0 {
                            GradientSectionDivider()
                        }

                        CriticalHomePage.MedicalCategorySection(category: category)
                            .id(category.id)
                    }
                }
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Featured Emergency Section
/// Displays trending emergency tools in a horizontal scroll
extension CriticalHomePage {
    struct FeaturedEmergencySection: View {
        // Create a CategoryData-like structure for emergency items
        let emergencyCategory = CategoryData(
            title: "Emergency",
            icon: "cross.circle.fill",
            color: .clear, // Previously: .red
            items: [
                FeaturedMedItem(id: 1, title: "Airway", description: "Critical airway management protocols", icon: HomeTabDataModel.homeTabData[1].image),
                FeaturedMedItem(id: 2, title: "EKG", description: "Emergency cardiac assessment", icon: HomeTabDataModel.homeTabData[2].image)
            ]
        )
        
        @State private var showingFullList = false
        
        var body: some View {
            VStack(alignment: .leading) {
                // Header section matches MedicalCategorySection
                Text("Trending")
                    .font(.custom(AssetConstants.fontSFProDisplayBold, size: 18))
                    .foregroundColor(Color(UIColor.component(red: 29, green: 53, blue: 87, opacity: 1)))
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // Scrollable content section matches MedicalCategorySection
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(emergencyCategory.items) { item in
                            NavigationLink(destination: NavigationFactory.getDestinationView(for: item.id)) {
                                FeaturedItemView(
                                    icon: HomeTabDataModel.getImage(for: item.id),
                                    title: item.title,
                                    description: item.description,
                                    color: emergencyCategory.color,
                                    useCustomImage: true
                                )
                            }
                        }
                    }
                    .padding(.bottom, 5)
                    .padding(.leading, 16)
                }
            }
              .sheet(isPresented: $showingFullList) {
                CategoryListView(category: emergencyCategory)
            }
        }
    }
}

// MARK: - Featured Item Card View (Premium Squircle Style)
/// Individual card view for featured medical items with premium squircle design
extension CriticalHomePage {
    struct FeaturedItemView: View {
        let icon: String
        let title: String
        let description: String
        let color: Color
        var useCustomImage: Bool = false
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
            VStack(alignment: .center, spacing: 10) {
                // Floating 3D icon (larger for icon-only design)
                ZStack {
                    if useCustomImage {
                        CatalogThumbnailImage(name: icon, size: 54, cornerRadius: 12)
                            .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.4) : Color.black.opacity(0.2)), radius: 8, x: 0, y: 5)
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: 48, weight: .medium))
                            .foregroundColor(Color.logoBlue)
                            .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.black.opacity(0.15)), radius: 6, x: 0, y: 4)
                    }
                }
                .frame(height: 75)

                VStack(alignment: .center, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(colorScheme == .dark ? .white : Color(UIColor.darkGray))
                    Text(description)
                        .font(.system(size: 9, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 4)
            }
            .frame(width: 110, height: 120)
        }
    }
}

// MARK: - Medical Category Section (Floating 3D Style)
/// Displays a category with its items in a horizontal scroll with floating 3D design
extension CriticalHomePage {
    struct MedicalCategorySection: View {
        let category: CategoryData
        @State private var showingFullList = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    // Category title with floating icon badge
                    HStack(spacing: 12) {
                        // Floating icon container
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.white, Color(.systemGray6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 36, height: 36)
                                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                            
                            if category.icon == "ivfluid.bag" {
                                Image(systemName: category.icon)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.red, Color.logoBlue)
                                    .font(.system(size: 14, weight: .medium))
                            } else {
                                Image(systemName: category.icon)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.logoBlue)
                            }
                        }
                        
                        Text(category.title)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color(UIColor.darkGray))
                    }
                    
                    Spacer()
                    
                    // Floating "See All" button (Gold gradient in dark mode)
                    Button(action: { showingFullList = true }) {
                        HStack(spacing: 4) {
                            Text("See All")
                                .font(.system(size: 12, weight: .semibold))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(SeeAllButtonStyle())
                }
                .padding(.horizontal, 25)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(category.items.enumerated()), id: \.element.id) { index, item in
                            NavigationLink(destination: NavigationFactory.getDestinationView(for: item.id)) {
                                FeaturedItemView(
                                    icon: HomeTabDataModel.getImage(for: item.id),
                                    title: item.title,
                                    description: item.description,
                                    color: category.color,
                                    useCustomImage: true
                                )
                            }
                            .buttonStyle(HapticButtonStyle())
                            .staggeredAnimation(index: index, isVisible: true)
                        }
                    }
                    .padding(.bottom, 8)
                    .padding(.leading, 25)
                    .padding(.trailing, 10)
                }
            }
            .sheet(isPresented: $showingFullList) {
                CategoryListView(category: category)
            }
        }
    }
}

// MARK: - List Views
/// Full-screen list views for categories
extension CriticalHomePage {
    // MARK: - Emergency Tools List View
    struct EmergencyToolsListView: View {
        @Environment(\.presentationMode) var presentationMode
        
        var emergencyTools: [FeaturedMedItem] = [
            FeaturedMedItem(id: 1, title: "Airway", description: "Airway management protocols", icon: HomeTabDataModel.homeTabData[1].image),
            FeaturedMedItem(id: 2, title: "EKG", description: "Emergency cardiac assessment", icon: HomeTabDataModel.homeTabData[2].image)
        ]
        
        var body: some View {
            NavigationView {
                List(emergencyTools) { tool in
                    NavigationLink(destination: NavigationFactory.getDestinationView(for: tool.id)) {
                        HStack {
                            CatalogThumbnailImage(name: tool.icon, size: 26, cornerRadius: 6)
                            VStack(alignment: .leading) {
                                Text(tool.title)
                                    .font(.headline)
                                Text(tool.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .navigationTitle("Emergency Tools")
                .navigationBarItems(trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
    
    // MARK: - Category List View (Floating 3D Style)
    /// Full-screen list view for a specific category with floating 3D design
    struct CategoryListView: View {
        @Environment(\.colorScheme) var colorScheme
        @Environment(\.presentationMode) var presentationMode
        let category: CategoryData
        
        var body: some View {
            NavigationView {
                GeometryReader { geometry in
                ZStack {
                    // Clean white/light background
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(category.items) { item in
                                    NavigationLink(destination: NavigationFactory.getDestinationView(for: item.id)) {
                                        CategoryListItemView(item: item, categoryColor: category.color)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 24)
                        }
                    }
                    }
                }
                .navigationTitle(category.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            // Floating close button
                            ZStack {
                                Circle()
                                    .fill(Color(.systemBackground))
                                    .frame(width: 34, height: 34)
                                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.black.opacity(0.1)), radius: 4, x: 0, y: 2)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(UIColor.darkGray))
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text(category.title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Category List Item View (Assess-style cards)
    /// Rounded light grey cards: icon left, bold title + description, chevron in circular button right
    struct CategoryListItemView: View {
        @Environment(\.colorScheme) var colorScheme
        let item: FeaturedMedItem
        let categoryColor: Color
        
        var body: some View {
            HStack(spacing: 15) {
                // Icon (left)
                CatalogThumbnailImage(name: HomeTabDataModel.getImage(for: item.id), size: 36, cornerRadius: 8)
                
                // Title and description (center)
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(UIColor.darkGray))
                    Text(item.description)
                        .font(.system(size: 13))
                        .foregroundColor(Color(UIColor.gray))
                        .lineLimit(2)
                }
                
                Spacer(minLength: 8)
                
                // Chevron in light grey circular button (right)
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 30, height: 30)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(UIColor.darkGray))
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.2) : Color.black.opacity(0.06)), radius: 4, x: 0, y: 2)
            )
        }
    }
}

// MARK: - Most Used Section (Floating 3D Style)
/// Displays frequently accessed medical tools with floating 3D design
extension CriticalHomePage {
    struct MostUsedSection: View {
        @State private var showingFullList = false
        
        let mostUsedItems = [
            MostUsedItem(
                title: "Lab Interpretation",
                description: "Analyze CMP, LFT, CBC patterns",
                color: .clear,
                icon: "microscope3d",
                destination: AnyView(LabInterpreterCoordinatorView())
            )
        ]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    // Section title with floating icon
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.white, Color(.systemGray6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 36, height: 36)
                                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.logoBlue)
                        }
                        
                    Text("Quick Access")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color(UIColor.darkGray))
                    }
                        .padding(.leading, 26)
                    
                    Spacer()
                    
                    // Floating "See All" button
                    Button(action: { showingFullList = true }) {
                        HStack(spacing: 4) {
                            Text("See All")
                                .font(.system(size: 12, weight: .semibold))
                        Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(Color.logoBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.06), radius: 1, x: 0, y: 1)
                                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        )
                    }
                }
                .padding(.trailing, 25)
                
                ForEach(mostUsedItems) { item in
                    NavigationLink(destination: item.destination) {
                        QuickAccessItemView(item: item)
                    }
                    .padding(.horizontal, 26)
                }
            }
            .padding(.bottom, 108)
            .sheet(isPresented: $showingFullList) {
                QuickAccessListView(items: mostUsedItems)
            }
        }
    }
    
    struct QuickAccessItemView: View {
        @Environment(\.colorScheme) var colorScheme
        let item: MostUsedItem

        var body: some View {
            HStack(spacing: 15) {
                // 3D Icon Container
                ZStack {
                    // Shadow on surface
                    Circle()
                        .fill((colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.15) : Color.black.opacity(0.05)))
                        .frame(width: 45, height: 45)
                        .blur(radius: 6)
                        .offset(y: 4)

                    Circle()
                        .fill(
                            colorScheme == .dark
                                ? LinearGradient(colors: [Color("17263C"), Color("0D1520")], startPoint: .topLeading, endPoint: .bottomTrailing)
                                : LinearGradient(colors: [.white, Color(.systemGray6)], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 48, height: 48)
                        .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.black.opacity(0.1)), radius: 4, x: 0, y: 3)

                    CatalogThumbnailImage(name: item.icon, size: 26, cornerRadius: 13, clipCircular: true)
                        .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.4) : Color.black.opacity(0.15)), radius: 2, x: 0, y: 2)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(colorScheme == .dark ? Color("E8ECEF") : Color(UIColor.darkGray))
                    Text(item.description)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }

                Spacer()

                // Floating chevron
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark ? Color("17263C") : Color(.systemGray6))
                        .frame(width: 30, height: 30)
                        .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.black.opacity(0.1)), radius: 3, x: 0, y: 2)

                Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? Color("D4AF37") : Color.logoBlue)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.adaptiveCardBackground)
                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.15) : Color.black.opacity(0.04)), radius: 1, x: 0, y: 1)
                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.2) : Color.black.opacity(0.08)), radius: 8, x: 0, y: 4)
                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.15) : Color.black.opacity(0.04)), radius: 16, x: 0, y: 10)
            )
        }
    }

    struct QuickAccessListView: View {
        @Environment(\.colorScheme) var colorScheme
        @Environment(\.presentationMode) var presentationMode
        let items: [MostUsedItem]
        
        var body: some View {
            NavigationView {
                GeometryReader { geometry in
                ZStack {
                    // Clean white/light background
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(items) { item in
                                    NavigationLink(destination: item.destination) {
                                        QuickAccessListItemView(item: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 24)
                        }
                    }
                    }
                }
                .navigationTitle("Quick Access")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            // Floating close button
                            ZStack {
                                Circle()
                                    .fill(Color(.systemBackground))
                                    .frame(width: 34, height: 34)
                                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.black.opacity(0.1)), radius: 4, x: 0, y: 2)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(UIColor.darkGray))
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("Quick Access")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Quick Access List Item View (Floating 3D)
    struct QuickAccessListItemView: View {
        @Environment(\.colorScheme) var colorScheme
        let item: MostUsedItem

        var body: some View {
            HStack(spacing: 15) {
                // Floating 3D Icon (no circle background)
                CatalogThumbnailImage(name: item.icon, size: 40, cornerRadius: 10)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(UIColor.darkGray))
                    Text(item.description)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Floating chevron
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 30, height: 30)
                        .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.black.opacity(0.1)), radius: 3, x: 0, y: 2)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color.logoBlue)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.15) : Color.black.opacity(0.04)), radius: 1, x: 0, y: 1)
                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.2) : Color.black.opacity(0.08)), radius: 8, x: 0, y: 4)
                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.15) : Color.black.opacity(0.04)), radius: 16, x: 0, y: 10)
            )
        }
    }
    
    // HemodynamicsMainView is now in its own file at:
    // Views/MainView/Home/Hemodynamics/HemodynamicsMainView.swift
    // NeuroMainPageView is now in its own file at:
    // Views/MainView/Home/Neuro/NeuroMainPageView.swift
    // LabValueMainView is now in its own file at:
    // Views/MainView/Home/LabValue/LabValueMainView.swift
    
    struct MostUsedItem: Identifiable {
        let id = UUID()
        let title: String
        let description: String
        let color: Color
        let icon: String
        let destination: AnyView
    }
}

// MARK: - Recently Viewed Section
/// Horizontal scroll of recently viewed sections with floating 3D icons
extension CriticalHomePage {
    struct RecentlyViewedSection: View {
        @ObservedObject private var analytics = TabAnalytics.shared
        @Environment(\.colorScheme) var colorScheme

        // Map section IDs to display titles
        private func getTitle(for id: Int) -> String {
            if let item = HomeTabDataModel.homeTabData.first(where: { $0.index == id }) {
                return item.title
            }
            return "Section"
        }

        var body: some View {
            let recentItems = analytics.getRecentlyViewed(limit: 6)

            if !recentItems.isEmpty {
                VStack(alignment: .leading, spacing: 14) {
                    // Section header
                    HStack {
                        Text("RECENTLY VIEWED")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.6) : .secondary)
                            .tracking(1.0)

                        Spacer()

                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 12))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.4) : .secondary.opacity(0.6))
                    }

                    // Horizontal scroll of recent items
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(recentItems, id: \.self) { id in
                                NavigationLink(destination: NavigationFactory.getDestinationView(for: id)) {
                                    RecentItemCard(
                                        id: id,
                                        title: getTitle(for: id)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
        }
    }

    struct RecentItemCard: View {
        @Environment(\.colorScheme) var colorScheme
        let id: Int
        let title: String

        var body: some View {
            VStack(spacing: 10) {
                // Floating 3D icon from HomeTabDataModel
                CatalogThumbnailImage(name: HomeTabDataModel.getImage(for: id), size: 36, cornerRadius: 8)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)

                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(colorScheme == .dark ? .white.opacity(0.85) : Color(red: 29/255, green: 53/255, blue: 87/255))
                    .lineLimit(1)
            }
            .frame(width: 90)
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.cardBlue
                            : Color.white.opacity(0.8)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(
                        colorScheme == .dark
                            ? CriticalDesign.Colors.goldMid.opacity(0.3)
                            : CriticalDesign.Colors.navyAccent.opacity(0.08),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.12) : Color.black.opacity(0.04)),
                radius: colorScheme == .dark ? 10 : 12,
                x: 0,
                y: colorScheme == .dark ? 5 : 6
            )
            .contentShape(Rectangle())
        }
    }
}

// MARK: - Smart Suggestions Section
/// Time-based intelligent suggestions
extension CriticalHomePage {
    struct SmartSuggestionsSection: View {
        @State private var currentHour = Calendar.current.component(.hour, from: Date())

        // Returns (title, subtitle, id) - icon comes from HomeTabDataModel
        private var suggestion: (title: String, subtitle: String, id: Int) {
            switch currentHour {
            case 6..<10:
                // Morning rounds - labs and assessment
                return ("Morning Labs", "Review overnight results", 7)
            case 10..<14:
                // Mid-day - procedures and interventions
                return ("Procedures", "Common ICU procedures", 13)
            case 14..<18:
                // Afternoon - medication management
                return ("Med Review", "Antibiotic stewardship", 18)
            case 18..<22:
                // Evening - vent checks and sedation
                return ("Vent Check", "Optimize ventilator settings", 14)
            default:
                // Night shift - emergency protocols
                return ("Night Protocols", "Critical care essentials", 5)
            }
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Suggested for You")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(0.5)

                    Spacer()

                    Image(systemName: "sparkles")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary.opacity(0.6))
                }

                NavigationLink(destination: NavigationFactory.getDestinationView(for: suggestion.id)) {
                    HStack(spacing: 16) {
                        // Floating 3D icon from HomeTabDataModel
                        CatalogThumbnailImage(name: HomeTabDataModel.getImage(for: suggestion.id), size: 44, cornerRadius: 10)
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(suggestion.title)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.primary)

                            Text(suggestion.subtitle)
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary.opacity(0.5))
                    }
                    .padding(16)
                    .background(
                        ZStack {
                            // Volumetric glass material with rounded rectangle
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.adaptiveCardBackground.opacity(0.88),
                                            Color.adaptiveCardBackground.opacity(0.72)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(
                                            Color.white.opacity(0.2),
                                            lineWidth: 1
                                        )
                                )
                                .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                                .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Data Models
/// Category and featured item data structures
extension CriticalHomePage {
    // MARK: - Category Data Model
    struct CategoryData: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let color: Color
        let items: [FeaturedMedItem]
    }
    
    // MARK: - Featured Medical Item Model
    struct FeaturedMedItem: Identifiable {
        let id: Int
        let title: String
        let description: String
        let icon: String
    }
}

// MARK: - Navigation Factory
/// Factory for routing to destination views based on item ID
extension CriticalHomePage {
    struct NavigationFactory {
        // MARK: - Navigation Routing
        /// Returns the appropriate destination view for a given medical item ID
        /// - Parameters:
        ///   - id: The medical item ID
        ///   - enableMoments: Whether to enable moment-based routing (default: true)
        /// - Returns: The appropriate view (moment view if detected, otherwise traditional view)
        @available(iOS 13.0, *)
        static func getDestinationView(for id: Int, enableMoments: Bool = true) -> some View {
            // Note: Moment detection commented out until moment files are added to Xcode target
            /*
            if enableMoments {
                if let moment = MomentContext.detectFromNavigation(itemId: id) {
                    return AnyView(getMomentView(for: moment, itemId: id))
                }
            }
            */

            // Wrap in TrackedView to track when actually navigated to
            return TrackedDestinationView(id: id)
        }
    }

    /// Wrapper view that tracks navigation on appear
    /// Feeds both TabAnalytics AND RecentlyUsedTracker (populates home screen recents)
    struct TrackedDestinationView: View {
        let id: Int

        private var sectionTitle: String {
            if let item = HomeTabDataModel.homeTabData.first(where: { $0.index == id }) {
                return item.title
            }
            return "Section"
        }

        private var sectionIcon: String {
            switch id {
            case 1: return "lungs.fill"
            case 2: return "waveform.path.ecg"
            case 3: return "function"
            case 4: return "cross.case.fill"
            case 5: return "drop.fill"
            case 6: return "drop.triangle"
            case 7: return "chart.bar"
            case 8: return "waveform.path.ecg.rectangle"
            case 9: return "brain"
            case 10: return "figure.child"
            case 11: return "figure.pregnant"
            case 12: return "heart.circle"
            case 13: return "xray"
            case 14: return "waveform.path"
            case 15: return "book.fill"
            case 16: return "textformat"
            case 17: return "cross.fill"
            case 18: return "pills.fill"
            case 19: return "heart.circle.fill"
            case 20: return "microscope"
            case 21: return "list.clipboard.fill"
            case 22: return "cross.vial.fill"
            case 23: return "arrow.left.arrow.right"
            case 24: return "stethoscope"
            case 29: return "waveform.path.ecg"
            case 30: return "cross.circle.fill"
            default: return "square.grid.2x2"
            }
        }

        // Hub views where user drills deeper — don't track these as recents
        // (individual sub-items track themselves with detail via trackCalculation)
        private var isHubView: Bool {
            [3, 6, 24].contains(id) // Calculators, Fluids hub, Nursing hub
        }

        var body: some View {
            destinationContent
                .onAppear {
                    TabAnalytics.shared.trackSectionView(id: id)
                    // Only track leaf destinations in recents, not hub views
                    if !isHubView {
                        RecentlyUsedTracker.shared.track(id: id, title: sectionTitle, icon: sectionIcon)
                    }
                }
        }

        @ViewBuilder
        private var destinationContent: some View {
            switch id {
            case 1: AirWayView().goldNavigationTitle("Airway")
            case 2: CriticalEKGView().goldNavigationTitle("EKG's")
            case 3: MedsCalculatorsView().goldNavigationTitle("Calculators")
            case 4: ClinicalPharmacologyView(isCardView: .constant(true)).goldNavigationTitle("Medications")
            case 5: DripsTableView().navigationBarHidden(false).goldNavigationTitle("Drips")
            case 6: FluidsMainView().goldNavigationTitle("Fluids / Blood")
            case 7: LabValueMainView().goldNavigationTitle("Lab Values")
            case 8: BalloonPumpMainView().goldNavigationTitle("Balloon Pump")
            case 9: NeuroMainPageView().goldNavigationTitle("Neuro")
            case 10: PediatricsDashboardView().goldNavigationTitle("Peds")
            case 11: ObstetricsMainView().goldNavigationTitle("OB")
            case 12: HemodynamicsMainView(isPushed: true).goldNavigationTitle("Hemodynamics")
            case 13: Procedure_ImagingMainView().goldNavigationTitle("Procedures")
            case 14: VentManagemnetTableView().goldNavigationTitle("Vent Management")
            case 15: CriticalRefrencesView().goldNavigationTitle("References")
            case 16: AbbreviateionMain().goldNavigationTitle("Abbreviations")
            case 17: IVCompatibilityView().goldNavigationTitle("IV Compatibility")
            case 18: AntibioticsMasterclassView().goldNavigationTitle("Antibiotics")
            case 19: OrganDonationMainView().goldNavigationTitle("Organ Donation")
            case 20: LabInterpreterCoordinatorView().goldNavigationTitle("Lab Interpretation")
            case 21: ACLSQuizMainView().goldNavigationTitle("ACLS Test Prep")
            case 22: GIGUMainView().goldNavigationTitle("GI / GU")
            case 23: ConversionCalculatorHubView().goldNavigationTitle("Unit Converter")
            case 24: NursingDashboardView().goldNavigationTitle("Nursing")
            case 25: SBARToolView().goldNavigationTitle("SBAR Tool")
            case 26: NursingScalesDashboardView().goldNavigationTitle("Clinical Scales")
            case 27: NursingAssessmentsDashboardView().goldNavigationTitle("Assessments")
            case 28: CriticalLabValuesView().goldNavigationTitle("ICU Tools")
            case 29: UltrasonographyMainView().goldNavigationTitle("Ultrasound")
            case 30: REBOA().goldNavigationTitle("REBOA")
            default:
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("Content Not Available")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("This section is currently unavailable.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            }
        }
    }
    
    // MARK: - Moment View Helper
    // Note: Moment view helpers commented out until moment files are added to Xcode target
    /*
    private static func getMomentView(for moment: MomentType, itemId: Int) -> some View {
        switch moment {
        case .medicationDecision:
            return AnyView(MedicationDecisionMoment(context: moment)
                .navigationBarTitle("Medication Decision", displayMode: .inline))
        case .calculatorNeed:
            return AnyView(CalculatorMoment(context: moment)
                .navigationBarTitle("Calculator", displayMode: .inline))
        case .labInterpretation:
            return AnyView(LabInterpretationMoment(context: moment)
                .navigationBarTitle("Lab Interpretation", displayMode: .inline))
        case .protocolVerification:
            return getDestinationView(for: itemId, enableMoments: false)
        }
    }
    */
    
    // MARK: - Moment View Helper (Instance Method)
    @available(iOS 13.0, *)
    @ViewBuilder
    private func getMomentView(for moment: MomentType) -> some View {
        switch moment {
        case .medicationDecision:
            MedicationDecisionMoment(context: moment)
        case .calculatorNeed:
            CalculatorMoment(context: moment)
        case .labInterpretation:
            LabInterpretationMoment(context: moment)
        case .protocolVerification:
            CriticalRefrencesView()
                .goldNavigationTitle("Protocol Verification")
        }
    }
}

// MARK: - User Tier Badge
/// Displays subscription tier badge (Free, Pro)
extension CriticalHomePage {
    enum UserTier: String {
        case basic = "Basic"
        case pro = "Pro"

        var displayName: String { rawValue.uppercased() }

        var shortName: String {
            switch self {
            case .basic: return "FREE"
            case .pro: return "PRO"
            }
        }

        var colors: [Color] {
            switch self {
            case .basic:
                return [Color.gray.opacity(0.6), Color.gray.opacity(0.4)]
            case .pro:
                return [Color(hex: "F5E6A3"), Color(hex: "C9A227")]
            }
        }

        var badgeAsset: String {
            switch self {
            case .basic: return "basic_badge"
            case .pro: return "pro_badge"
            }
        }
    }

    struct UserTierBadge: View {
        let tier: UserTier
        let size: CGFloat

        init(tier: UserTier, size: CGFloat = 44) {
            self.tier = tier
            self.size = size
        }

        private var goldGradient: LinearGradient {
            LinearGradient(
                colors: [Color(hex: "F5E6A3"), Color(hex: "DEBD68"), Color(hex: "C9A227")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        var body: some View {
            Text(tier.shortName)
                .font(.system(size: tier == .pro ? 9 : 8, weight: .black, design: .rounded))
                .foregroundColor(tier == .pro ? Color(red: 18/255, green: 24/255, blue: 38/255) : .white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(
                            tier == .pro
                                ? AnyShapeStyle(goldGradient)
                                : AnyShapeStyle(
                                    LinearGradient(
                                        colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.4)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                )
        }
    }
}

// MARK: - User Welcome Card
/// Main user card displaying greeting, profile picture, time, and news ticker
/// Supports collapsed state for scroll-to-collapse behavior
extension CriticalHomePage {
    struct UserWelcomeCard: View {
        // MARK: - Properties
        @Environment(\.colorScheme) var colorScheme
        let greeting: String
        let userName: String
        let institution: String
        let tags: String
        let isCollapsed: Bool
        var showNewsTicker: Bool = true
        var onSetupProfileTapped: (() -> Void)? = nil
        @Binding var isLoadingNews: Bool
        @Binding var newsError: String?
        @Binding var newsArticles: [NewsArticle]
        @ObservedObject var subscriptionManager: SubscriptionManager

        // Computed tier based on subscription status
        private var userTier: UserTier {
            subscriptionManager.isProSubscribed ? .pro : .basic
        }
        @State private var currentTime = Date()
        @AppStorage("userProfileImageData") private var profileImageData: Data?
        @State private var profileImage: UIImage?
        @State private var showImagePicker = false
        @State private var showEmojiGenerator = false
        @State private var selectedPhoto: PhotosPickerItem?
        @State private var showImageCropper = false
        @State private var imageToCrop: UIImage?
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        // MARK: - Computed Properties
        private var timeFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }
        
        private var tagArray: [String] {
            tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }
        
        // MARK: - Body View
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                if isCollapsed {
                    // MARK: - Collapsed Mini Header
                    collapsedHeader
                } else {
                    // MARK: - Full Header Section (Profile & Time)
                    fullHeader
                }
            }
            .background(cardBackground)
            .onReceive(timer) { _ in
                currentTime = Date()
            }
            .onAppear {
                loadProfileImage()
            }
            .onChange(of: selectedPhoto) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await MainActor.run {
                            imageToCrop = image
                            showImageCropper = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showImageCropper) {
                if let imageToCrop = imageToCrop {
                    ProfileImageCropperView(image: imageToCrop) { croppedImage in
                        if let data = croppedImage.jpegData(compressionQuality: 0.8) {
                            profileImageData = data
                            profileImage = croppedImage
                        }
                    }
                }
            }
            .sheet(isPresented: $showEmojiGenerator) {
                EmojiGenerationView { emoji in
                    if let data = emoji.jpegData(compressionQuality: 0.8) {
                        profileImageData = data
                        profileImage = emoji
                    }
                }
            }
        }

        // MARK: - Collapsed Header View
        private var collapsedHeader: some View {
            HStack(spacing: 12) {
                // Small profile picture
                profilePicture(size: 40)

                // Name only
                Text(userName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(goldGradient)
                    .lineLimit(1)

                Spacer()

                // Tags (compact)
                if !tags.isEmpty && !tagArray.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(tagArray.prefix(2), id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(goldGradient)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill((colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color.black.opacity(0.3)))
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }

        // MARK: - Full Header View
        private var fullHeader: some View {
            VStack(alignment: .leading, spacing: 0) {
                // MARK: Top Row - Profile, Name, Institution, Time & Badge
                HStack(alignment: .top) {
                    // Profile Picture
                    profilePicture(size: 60)
                        .onTapGesture {
                            showEmojiGenerator = true
                        }
                        .contextMenu {
                            Button(action: { showImagePicker = true }) {
                                Label("Upload Photo", systemImage: "photo")
                            }
                            Button(action: { showEmojiGenerator = true }) {
                                Label("Create Emoji", systemImage: "sparkles")
                            }
                        }
                        .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto, matching: .images)

                    // Name, Greeting & Institution
                    VStack(alignment: .leading, spacing: 3) {
                        Text(greeting)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))

                        Text(userName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(goldGradient)
                            .lineLimit(1)

                        // Institution (above divider)
                        if !institution.isEmpty {
                            Text(institution)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.leading, 12)

                    Spacer()

                    // Time Capsule & Tier Badge (stacked)
                    VStack(alignment: .center, spacing: 6) {
                        Text(timeFormatter.string(from: currentTime))
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.95))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(timeCapsuleBackground)

                        UserTierBadge(tier: userTier, size: 38)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 16)

                // MARK: Divider
                Divider()
                    .background(Color.white.opacity(0.15))
                    .padding(.horizontal, 18)
                    .padding(.top, 14)

                // MARK: Bottom Row - Tags (or Setup Prompt if nothing set)
                if tags.isEmpty && institution.isEmpty {
                    // Encouragement to set up profile (tappable → Settings)
                    Button(action: { onSetupProfileTapped?() }) {
                        setupPromptView
                    }
                    .buttonStyle(.plain)
                } else if !tags.isEmpty && !tagArray.isEmpty {
                    // Show Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(tagArray, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(goldGradient)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(tagBackground)
                            }
                        }
                        .padding(.horizontal, 18)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 16)
                } else {
                    // Just institution set, no tags - add bottom padding
                    Spacer()
                        .frame(height: 16)
                }

                // MARK: - News Ticker (bottom of card; scroll area has distinct color)
                if showNewsTicker {
                    Divider()
                        .background(Color.white.opacity(0.15))
                        .padding(.horizontal, 18)
                        .padding(.top, 8)
                    NewsTickerView(
                        isLoadingNews: isLoadingNews,
                        newsError: newsError,
                        newsArticles: newsArticles,
                        useLightText: true
                    )
                    .padding(.horizontal, 12)
                    .padding(.top, 6)
                    .padding(.bottom, 14)
                    .background(Color.black.opacity(0.2))
                }
            }
        }

        // MARK: - Setup Prompt View
        /// Encourages user to add their institution and specialty
        private var setupPromptView: some View {
            HStack(spacing: 10) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(goldGradient)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Complete Your Profile")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                    Text("Add your institution & specialty in Settings")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.white.opacity(0.5))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 16)
        }

        // MARK: - Reusable Components
        private var goldGradient: LinearGradient {
            LinearGradient(
                colors: [
                    Color(hex: "F5E6A3"),
                    Color(hex: "DEBD68"),
                    Color(hex: "C9A227")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }

        @ViewBuilder
        private func profilePicture(size: CGFloat) -> some View {
            let innerSize = size * 0.91
            let imageSize = size * 0.82
            let logoSize = size * 0.56

            ZStack {
                Circle()
                    .fill(Color.cardBlue)
                    .frame(width: size, height: size)
                    .shadow(color: Color.white.opacity(colorScheme == .dark ? 0.05 : 0.1), radius: 4, x: -2, y: -2)
                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.6) : Color.black.opacity(0.4)), radius: 4, x: 2, y: 2)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.cardBlue.opacity(0.8), (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color.black.opacity(0.3))],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: innerSize, height: innerSize)
                    .overlay(Circle().stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.15), lineWidth: 1))

                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(Circle())
                        .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color.black.opacity(0.3)), radius: 4, x: 0, y: 2)
                } else {
                    Image("welcomeLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: logoSize, height: logoSize)
                }

                Circle()
                    .stroke(goldGradient.opacity(0.5), lineWidth: 1.5)
                    .frame(width: innerSize + 2, height: innerSize + 2)
            }
        }

        private var timeCapsuleBackground: some View {
            ZStack {
                Capsule()
                    .fill(Color.cardBlue)
                    .overlay(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [(colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.3) : Color.black.opacity(0.2)), Color.clear, Color.white.opacity(colorScheme == .dark ? 0.02 : 0.05)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                Capsule().stroke((colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color.black.opacity(0.3)), lineWidth: 1).blur(radius: 1)
                Capsule().stroke(
                    LinearGradient(colors: [Color.white.opacity(colorScheme == .dark ? 0.1 : 0.15), Color.clear], startPoint: .top, endPoint: .bottom),
                    lineWidth: 1
                )
            }
        }

        private var tagBackground: some View {
            Capsule()
                .fill((colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color.black.opacity(0.35)))
                .overlay(
                    Capsule()
                        .stroke(goldGradient.opacity(0.4), lineWidth: 1)
                )
        }

        private var cardBackground: some View {
            ZStack {
                // Fill corner areas so they match page tint (light) or dark canvas (dark)
                Rectangle()
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.darkCanvas : Color(red: 0.94, green: 0.95, blue: 0.97))
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(CriticalDesign.Colors.cardBlue)
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(goldGradient, lineWidth: 2)
            }
            // No shadow on card — it was drawing into the rounded corners and showing as gray
        }

        private func loadProfileImage() {
            if let data = profileImageData, let image = UIImage(data: data) {
                profileImage = image
            }
        }
    }
}

// MARK: - User Welcome Card Legacy Body (Removed - kept for reference)
/*
    Original full body view that was replaced with collapsed/expanded states.
    The news ticker has been moved outside the card.
*/
extension CriticalHomePage {
    // Keeping the old profile structure placeholder for backwards compatibility
    private struct _LegacyProfilePlaceholder: View {
        var body: some View {
            EmptyView()
        }
    }
}

// MARK: - User Welcome Card Original Extension (keeping modifiers)
extension CriticalHomePage.UserWelcomeCard {
    // Profile image helper kept here for backwards compatibility
    private struct _ProfileHelper {
        // Original helper code placeholder
        static func loadImage(from data: Data?) -> UIImage? {
            guard let data = data else { return nil }
            return UIImage(data: data)
        }
    }
}

// MARK: - Temporary placeholder to keep compiler happy
private struct _UserWelcomeCardOldBody {
    // This was the original body
    // Kept as a reference comment block above
    static let _placeholder = """
                HStack(alignment: .center) {
                    // MARK: - Profile Picture Section (Neumorphic Ring)

                    HStack(alignment: .center, spacing: 16) {
                        ZStack {
                            // Outer neumorphic ring - raised effect on dark background
                        Circle()
                                .fill(Color.cardBlue)
                                .frame(width: 68, height: 68)
                                .shadow(color: Color.white.opacity(colorScheme == .dark ? 0.05 : 0.1), radius: 4, x: -2, y: -2)
                                .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.6) : Color.black.opacity(0.4)), radius: 4, x: 2, y: 2)

                            // Inner inset circle
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.cardBlue.opacity(0.8), (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color.black.opacity(0.3))],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 62, height: 62)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.15), lineWidth: 1)
                                )

                            // Profile image or default logo
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 56, height: 56)
                                    .clipShape(Circle())
                                    .shadow(color: (colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.5) : Color.black.opacity(0.3)), radius: 4, x: 0, y: 2)
                            } else {
                                // Default to welcomeLogo instead of person icon
                                Image("welcomeLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 38, height: 38)
                            }

                            // Gold gradient accent ring matching logo
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "F5E6A3").opacity(0.6), // Light gold
                                            Color(hex: "DEBD68").opacity(0.4), // Mid gold
                                            Color(hex: "C9A227").opacity(0.5)  // Deep gold
                                        ],
    """
}

// MARK: - Navigation Button Component (Subtle Style)
extension CriticalHomePage {
    struct NavigationButton: View {
        @Environment(\.colorScheme) var colorScheme
        let title: String
        let icon: String
        let isSelected: Bool

        var body: some View {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .lineLimit(1)
            }
            .padding(.horizontal, 14)
            .frame(height: 34)
            .foregroundColor(
                isSelected
                    ? .white
                    : (colorScheme == .dark ? .white.opacity(0.6) : .secondary)
            )
            .background(
                Group {
                    if isSelected {
                        Capsule()
                            .fill(
                                colorScheme == .dark
                                    ? CriticalDesign.Colors.gold.opacity(0.85)
                                    : CriticalDesign.Colors.cardBlue
                            )
                    } else {
                        Capsule()
                            .fill(
                                colorScheme == .dark
                                    ? Color.white.opacity(0.08)
                                    : Color.white.opacity(0.5)
                            )
                    }
                }
            )
            .overlay(
                Group {
                    if isSelected {
                        Capsule()
                            .stroke(
                                colorScheme == .dark
                                    ? CriticalDesign.Colors.gold.opacity(0.5)
                                    : CriticalDesign.Colors.navyAccent.opacity(0.2),
                                lineWidth: 1
                            )
                    } else {
                        Capsule()
                            .stroke(
                                colorScheme == .dark
                                    ? Color.white.opacity(0.12)
                                    : CriticalDesign.Colors.navyAccent.opacity(0.08),
                                lineWidth: 1
                            )
                    }
                }
            )
            .animation(.easeInOut(duration: 0.2), value: isSelected)
            .padding(.bottom, 12)
            .padding(.top, 2)
        }
    }
}

// MARK: - Preview Provider
struct ModernMedicalView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CriticalHomePage()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            CriticalHomePage()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
    }
}



/// MARK: - News Ticker View (Standalone)
/// Standalone news ticker moved outside the profile card
extension CriticalHomePage {
    struct NewsTickerView: View {
        let isLoadingNews: Bool
        let newsError: String?
        let newsArticles: [NewsArticle]
        /// When true, use white/light text for use on navy card background
        var useLightText: Bool = false
        @Environment(\.colorScheme) var colorScheme

        var body: some View {
            VStack(spacing: 0) {
                if isLoadingNews {
                    HStack(spacing: 8) {
                        ProgressView()
                            .scaleEffect(0.7)
                            .tint(useLightText ? .white : nil)
                        Text("Loading news...")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(useLightText ? .white.opacity(0.8) : .secondary)
                    }
                    .frame(height: 32)
                } else if newsError != nil {
                    EmptyView()
                } else if !newsArticles.isEmpty {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "newspaper.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(useLightText ? .white.opacity(0.8) : (colorScheme == .dark ? .secondary : Color.logoBlue.opacity(0.7)))
                        AutoScrollingNewsView(articles: Array(newsArticles.prefix(10)), useLightText: useLightText)
                            .padding(.top, 4)
                    }
                    .frame(height: 28)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

// MARK: - Auto Scrolling News View
/// Horizontally scrolling news ticker that loops continuously with touch interaction
extension CriticalHomePage {
    struct AutoScrollingNewsView: View {
        // MARK: - Properties
        let articles: [NewsArticle]
        var useLightText: Bool = false
        @Environment(\.scenePhase) private var scenePhase
        @State private var offset: CGFloat = 0
        @State private var isPaused: Bool = false
        @State private var dragOffset: CGFloat = 0
        @State private var lastOffset: CGFloat = 0
        @State private var totalWidth: CGFloat = 0
        @State private var screenWidth: CGFloat = 0
        
        /// Minimum drag distance (pt) before pausing — avoids pausing on tap when opening a link
        private let minDragToPause: CGFloat = 12.0
        
        // Speed multiplier - higher = slower/smoother
        private let speedMultiplier: Double = 35.0
        
        // Minimum 10 headlines - pad with fallback if needed
        private var displayArticles: [NewsArticle] {
            var result = articles
            let minimumCount = 10
            
            // If we don't have enough articles, pad with fallback headlines
            if result.count < minimumCount {
                let fallbackNews = [
                    NewsArticle(title: "ACLS Guidelines: Latest Updates", description: "Advanced Cardiac Life Support protocol changes", source: "AHA"),
                    NewsArticle(title: "Sepsis Hour-1 Bundle Compliance", description: "Early recognition improving patient outcomes", source: "Critical Care"),
                    NewsArticle(title: "ED Overcrowding Solutions", description: "Innovative approaches to emergency department flow", source: "ACEP"),
                    NewsArticle(title: "RSI Best Practices Update", description: "Rapid sequence intubation technique refinements", source: "EM News"),
                    NewsArticle(title: "Trauma Activation Criteria Revised", description: "New field triage guidelines for trauma centers", source: "ACS"),
                    NewsArticle(title: "Point-of-Care Ultrasound Expands", description: "POCUS becoming standard in emergency medicine", source: "ACEP"),
                    NewsArticle(title: "Stroke Alert: New Thrombolytics", description: "Tenecteplase showing promise in acute stroke", source: "Neurology"),
                    NewsArticle(title: "Ketamine for ED Agitation", description: "IM ketamine protocols gaining wider adoption", source: "Ann Emerg Med"),
                    NewsArticle(title: "Pediatric Resuscitation Updates", description: "PALS algorithm modifications for 2024", source: "AAP"),
                    NewsArticle(title: "Airway Management Innovations", description: "Video laryngoscopy becoming first-line approach", source: "EM Critical")
                ]
                
                var fallbackIndex = 0
                while result.count < minimumCount && fallbackIndex < fallbackNews.count {
                    result.append(fallbackNews[fallbackIndex])
                    fallbackIndex += 1
                }
            }
            return result
        }
        
        // MARK: - Body
        var body: some View {
            GeometryReader { geometry in
                let calculatedTotalWidth = calculateTotalWidth()
                let calculatedScreenWidth = geometry.size.width
                
                ScrollViewReader { proxy in
                    HStack(spacing: 12) {
                    // First set of articles
                        ForEach(Array(displayArticles.enumerated()), id: \.offset) { index, article in
                        NewsItemView(article: article, useLightText: useLightText)
                                .id("article_\(index)")
                    }
                    
                    // Duplicate set for seamless loop
                        ForEach(Array(displayArticles.enumerated()), id: \.offset) { index, article in
                        NewsItemView(article: article, useLightText: useLightText)
                                .id("article_dup_\(index)")
                        }
                    }
                    .offset(x: isPaused ? lastOffset + dragOffset : offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let dx = value.translation.width
                                if !isPaused, abs(dx) > minDragToPause {
                                    isPaused = true
                                    lastOffset = offset
                                }
                                dragOffset = dx
                            }
                            .onEnded { value in
                                lastOffset = lastOffset + dragOffset
                                dragOffset = 0
                                
                                // Bounds checking
                                if lastOffset > calculatedScreenWidth {
                                    lastOffset = calculatedScreenWidth
                                }
                                if lastOffset < -calculatedTotalWidth {
                                    lastOffset = -calculatedTotalWidth / 2
                                }
                                
                                // Auto-resume after 3 seconds if paused by drag
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    if isPaused {
                                        offset = lastOffset
                                        isPaused = false
                                        startAnimation(totalWidth: calculatedTotalWidth, screenWidth: calculatedScreenWidth, fromOffset: lastOffset)
                                    }
                                }
                            }
                    )
                    // Double-tap to pause/resume (single tap goes to news items)
                    .onTapGesture(count: 2) {
                        if isPaused {
                            // Resume animation from current position
                            offset = lastOffset
                            isPaused = false
                            startAnimation(totalWidth: calculatedTotalWidth, screenWidth: calculatedScreenWidth, fromOffset: lastOffset)
                        } else {
                            // Pause animation
                            isPaused = true
                            lastOffset = offset
                        }
                    }
                .onAppear {
                        totalWidth = calculatedTotalWidth
                        screenWidth = calculatedScreenWidth
                        // Small delay for smoother initial animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            startAnimation(totalWidth: calculatedTotalWidth, screenWidth: calculatedScreenWidth, fromOffset: calculatedScreenWidth)
                        }
                    }
                    .onChange(of: displayArticles.count) { _ in
                        if !isPaused {
                            startAnimation(totalWidth: calculatedTotalWidth, screenWidth: calculatedScreenWidth, fromOffset: calculatedScreenWidth)
                        }
                    }
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                            let from = isPaused ? lastOffset : offset
                            offset = from
                            isPaused = false
                            lastOffset = from
                            dragOffset = 0
                            startAnimation(totalWidth: calculatedTotalWidth, screenWidth: calculatedScreenWidth, fromOffset: from)
                        }
                    }
                }
            }
            .clipped()
            // Visual indicator when paused
            .overlay(
                Group {
                    if isPaused {
                        HStack {
                            Spacer()
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 10))
                                .foregroundColor(useLightText ? .white.opacity(0.6) : .white.opacity(0.5))
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
        }
        
        // MARK: - Animation Helper Functions
        private func calculateTotalWidth() -> CGFloat {
            // Estimate average card width: ~300pt (varies by headline length)
            let avgCardWidth: CGFloat = 300
            let spacing: CGFloat = 12
            let totalCards = displayArticles.count * 2 // Duplicated for seamless loop
            return CGFloat(totalCards) * avgCardWidth + CGFloat(totalCards - 1) * spacing
        }
        
        private func startAnimation(totalWidth: CGFloat, screenWidth: CGFloat, fromOffset: CGFloat) {
            // Reset offset without animation first
            offset = fromOffset
            
            // Calculate duration for smooth, fluid scrolling
            let totalDistance = fromOffset + totalWidth
            let pixelsPerSecond: Double = 60.0 // Moderate scroll speed — readable at a comfortable pace
            let duration = totalDistance / pixelsPerSecond
            
            // Use easeInOut for smoother feel at boundaries
            withAnimation(
                Animation
                    .linear(duration: max(duration, 10))
                    .repeatForever(autoreverses: false)
            ) {
                offset = -totalWidth
            }
        }
    }
    
    // MARK: - News Item View
    /// Single-line news item in scrolling ticker (adaptive colors; useLightText for navy card)
    struct NewsItemView: View {
        let article: NewsArticle
        var useLightText: Bool = false
        @Environment(\.openURL) private var openURL
        @Environment(\.colorScheme) private var colorScheme
        @State private var isPressed = false

        private var titleFontSize: CGFloat { useLightText ? 9 : 11 }
        private var iconSize: CGFloat { useLightText ? 8 : 10 }
        private var pillFontSize: CGFloat { useLightText ? 6 : 7 }

        var body: some View {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "cross.case.fill")
                    .font(.system(size: iconSize, weight: .medium))
                    .foregroundColor(Color.red.opacity(0.8))

                if let source = article.source, !source.isEmpty {
                    Text(source.uppercased())
                        .font(.system(size: pillFontSize, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1.5)
                        .background(
                            Capsule()
                                .fill(Color.logoBlue.opacity(0.8))
                        )
                        .fixedSize()
                }

                Text(article.title)
                    .font(.system(size: titleFontSize, weight: .medium))
                    .foregroundColor(useLightText ? .white : (colorScheme == .dark ? .white.opacity(0.85) : Color(UIColor.darkGray)))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)

                if article.url != nil {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: pillFontSize, weight: .medium))
                        .foregroundColor(useLightText ? .white.opacity(0.75) : Color.logoBlue.opacity(0.7))
                }
            }
            .padding(.vertical, useLightText ? 3 : 4)
            .padding(.horizontal, useLightText ? 6 : 8)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(useLightText ? Color.white.opacity(isPressed ? 0.12 : 0.06) : (colorScheme == .dark ? Color.white.opacity(isPressed ? 0.10 : 0.03) : Color.black.opacity(isPressed ? 0.06 : 0.02)))
            )
            .contentShape(Rectangle())
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
            .onTapGesture {
                if let url = article.url {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    openURL(url)
                }
            }
            .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
        }
    }
}

// MARK: - Profile Image Cropper View
/// Allows pinch-to-zoom and drag to crop profile image
struct ProfileImageCropperView: View {
    @Environment(\.colorScheme) var colorScheme
    let image: UIImage
    let onCrop: (UIImage) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    private let cropSize: CGFloat = 250
    
    var body: some View {
        ZStack {
            // Dark background (dark navy in dark mode)
            (colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.black).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(colorScheme == .dark ? .white : .white)
                    
                    Spacer()
                    
                    Text("Crop Photo")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(colorScheme == .dark ? .white : .white)
                    
                    Spacer()
                    
                    Button("Done") {
                        cropImage()
                    }
                    .foregroundColor(Color(hex: "D4AF37"))
                    .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background((colorScheme == .dark ? CriticalDesign.Colors.cardBlue.opacity(0.9) : Color.black.opacity(0.8)))
                
                Spacer()
                
                // Crop area
                ZStack {
                    // Image with gestures
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(scale)
                        .offset(offset)
                        .frame(width: cropSize, height: cropSize)
                        .clipped()
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        let newScale = lastScale * value
                                        scale = max(1.0, min(newScale, 5.0))
                                    }
                                    .onEnded { _ in
                                        lastScale = scale
                                    },
                                DragGesture()
                                    .onChanged { value in
                                        offset = CGSize(
                                            width: lastOffset.width + value.translation.width,
                                            height: lastOffset.height + value.translation.height
                                        )
                                    }
                                    .onEnded { _ in
                                        lastOffset = offset
                                    }
                            )
                        )
                    
                    // Circular crop overlay
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(hex: "D4AF37"),
                                    Color(hex: "F5E6A3"),
                                    Color(hex: "C9A227")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: cropSize, height: cropSize)
                }
                .clipShape(Circle())
                
                Spacer()
                
                // Instructions
                Text("Pinch to zoom • Drag to reposition")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.bottom, 40)
            }
        }
    }
    
    private func cropImage() {
        // Calculate the crop rect based on scale and offset
        let imageSize = image.size
        let viewSize = cropSize
        
        // Calculate the visible portion of the image
        let scaledImageWidth = imageSize.width * scale
        let scaledImageHeight = imageSize.height * scale
        
        // Calculate crop center
        let centerX = (scaledImageWidth / 2) - offset.width
        let centerY = (scaledImageHeight / 2) - offset.height
        
        // Calculate crop rect in image coordinates
        let cropRadius = (viewSize / 2) / scale
        let cropX = (centerX / scale) - cropRadius
        let cropY = (centerY / scale) - cropRadius
        let cropWidth = viewSize / scale
        let cropHeight = viewSize / scale
        
        // Clamp to image bounds
        let clampedX = max(0, min(cropX, imageSize.width - cropWidth))
        let clampedY = max(0, min(cropY, imageSize.height - cropHeight))
        let clampedWidth = min(cropWidth, imageSize.width - clampedX)
        let clampedHeight = min(cropHeight, imageSize.height - clampedY)
        
        let cropRect = CGRect(x: clampedX, y: clampedY, width: clampedWidth, height: clampedHeight)
        
        // Perform the crop
        if let cgImage = image.cgImage?.cropping(to: cropRect) {
            let croppedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
            onCrop(croppedImage)
        } else {
            // Fallback: return original image
            onCrop(image)
        }
    }
}

// MARK: - User Welcome Card Preview
#Preview("User Welcome Card - With News (Pro User)") {
    ZStack {
        Image("Back")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()

        VStack {
            CriticalHomePage.UserWelcomeCard(
                greeting: "Good morning,",
                userName: "Dr. Tony Clifton, MD",
                institution: "General Hospital",
                tags: "Cardiology, ICU, Research",
                isCollapsed: false,
                isLoadingNews: .constant(false),
                newsError: .constant(nil),
                newsArticles: .constant([
                    NewsArticle(
                        title: "New ICU sedation strategies updated",
                        description: "Updated guidelines for managing sedation in intensive care units",
                        url: nil
                    ),
                    NewsArticle(
                        title: "Sepsis bundle recommendations released",
                        description: "New protocols for early detection and treatment of sepsis",
                        url: nil
                    )
                ]),
                subscriptionManager: SubscriptionManager()
            )
            .padding()
        }
    }
}

#Preview("User Welcome Card - Loading (Basic User)") {
    ZStack {
        Image("Back")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()

        VStack {
            CriticalHomePage.UserWelcomeCard(
                greeting: "Good afternoon,",
                userName: "Dr. Sarah Johnson, MD",
                institution: "Memorial Medical Center",
                tags: "Emergency Medicine, Trauma",
                isCollapsed: false,
                isLoadingNews: .constant(true),
                newsError: .constant(nil),
                newsArticles: .constant([]),
                subscriptionManager: SubscriptionManager()
            )
            .padding()
        }
    }
}

#Preview("User Welcome Card - Error State") {
    ZStack {
        Image("Back")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()

        VStack {
            CriticalHomePage.UserWelcomeCard(
                greeting: "Good evening,",
                userName: "Dr. Michael Chen, MD",
                institution: "City Hospital",
                tags: "Cardiology, Interventional",
                isCollapsed: false,
                isLoadingNews: .constant(false),
                newsError: .constant("Unable to load news"),
                newsArticles: .constant([]),
                subscriptionManager: SubscriptionManager()
            )
            .padding()
        }
    }
}

#Preview("User Welcome Card - Empty State") {
    ZStack {
        Image("Back")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()

        VStack {
            CriticalHomePage.UserWelcomeCard(
                greeting: "Good morning,",
                userName: "Dr. Emily Rodriguez, MD",
                institution: "Regional Medical Center",
                tags: "Pediatrics, Critical Care",
                isCollapsed: false,
                isLoadingNews: .constant(false),
                newsError: .constant(nil),
                newsArticles: .constant([]),
                subscriptionManager: SubscriptionManager()
            )
            .padding()
        }
    }
}

// MARK: - News Service
// Note: NewsService is now defined in Logic/NewsService.swift
// This duplicate has been removed to avoid redeclaration errors

