//
//  TroubleshootingView.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 2/8/24.
//  Redesigned: Premium Light Theme with malfunction troubleshooting
//

import SwiftUI

// MARK: - Data Handler
class PacemakerDataHandler: ObservableObject {
    @Published var malfunctions: [PacemakerMalfunction] = []

    init() {
        loadInitialData()
    }

    func addMalfunction(_ malfunction: PacemakerMalfunction) {
        malfunctions.append(malfunction)
    }

    func getMalfunctions(for category: String) -> [PacemakerMalfunction] {
        return malfunctions.filter { $0.category == category }
    }

    private func loadInitialData() {
        malfunctions.append(sensingProblems)
        malfunctions.append(failureToCapture)
        malfunctions.append(failureToPace)
        malfunctions.append(Pseudomalfunctions)
        malfunctions.append(TroubleshootingandManagement)
    }
}

// MARK: - Malfunction Card
struct MalfunctionCard: View {
    @Environment(\.colorScheme) var colorScheme
    let malfunction: PacemakerMalfunction
    let brandAccent: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 14) {
            // Vertical accent line
            RoundedRectangle(cornerRadius: 2)
                .fill(brandAccent)
                .frame(width: 4, height: 50)
            
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(brandAccent.opacity(0.12))
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(brandAccent)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(malfunction.category)
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                
                Text("\(malfunction.issues.count) issue\(malfunction.issues.count == 1 ? "" : "s")")
                    .font(.custom("Poppins-Regular", size: 13))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(CriticalDesign.Adaptive.textTertiary(for: colorScheme))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white.opacity(0.7))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
        .shadow(color: brandAccent.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Malfunction List View
struct MalfunctionListView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var dataHandler = PacemakerDataHandler()
    @State private var isAppearing = false
    
    // Colors for each category
    private let categoryColors: [String: Color] = [
        "Sensing Problems": Color(red: 0.96, green: 0.55, blue: 0.22),
        "Failure to Capture": Color(red: 0.90, green: 0.22, blue: 0.27),
        "Failure To Pace": Color(red: 0.58, green: 0.44, blue: 0.86),
        "Pseudomalfunctions": Color(red: 0.0, green: 0.71, blue: 0.85),
        "Troubleshooting and Management": Color(red: 0.16, green: 0.62, blue: 0.56)
    ]
    
    private let categoryIcons: [String: String] = [
        "Sensing Problems": "eye.slash.fill",
        "Failure to Capture": "bolt.slash.fill",
        "Failure To Pace": "waveform.path.ecg",
        "Pseudomalfunctions": "questionmark.circle.fill",
        "Troubleshooting and Management": "wrench.and.screwdriver.fill"
    ]
    
    var body: some View {
        ZStack {
            PacemakerLightBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    headerSection
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 20)
                    
                    // MARK: - Context Card
                    contextCard
                        .opacity(isAppearing ? 1 : 0)
                        .offset(y: isAppearing ? 0 : 25)
                    
                    // MARK: - Malfunction Cards
                    PacemakerSectionDivider(title: "Common Issues")
                    
                    VStack(spacing: 12) {
                        ForEach(dataHandler.malfunctions, id: \.id) { malfunction in
                            NavigationLink(destination: MalfunctionDetailView(malfunction: malfunction)) {
                                MalfunctionCard(
                                    malfunction: malfunction,
                                    brandAccent: categoryColors[malfunction.category] ?? .blue,
                                    icon: categoryIcons[malfunction.category] ?? "exclamationmark.triangle.fill"
                                )
                            }
                        }
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 30)
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        let accentRed = Color(red: 0.90, green: 0.22, blue: 0.27)
        
        return VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(accentRed.opacity(0.15))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                ZStack {
                    if colorScheme == .dark {
                        Circle()
                            .fill(CriticalDesign.Colors.cardBlue)
                            .frame(width: 80, height: 80)
                    } else {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 80, height: 80)
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 80, height: 80)
                    }

                    Circle()
                        .stroke(colorScheme == .dark ? Color.white.opacity(0.15) : Color.white, lineWidth: 1.5)
                        .frame(width: 80, height: 80)

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accentRed, accentRed.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            }
            .padding(.top, 20)
            
            Text("Troubleshooting")
                .font(.custom("Poppins-Bold", size: 30))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("Recognizing & managing pacemaker malfunctions")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.5))
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 8)
    }
    
    // MARK: - Context Card
    private var contextCard: some View {
        let accentBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(accentBlue)
                    .frame(width: 4, height: 20)
                
                Text("Why This Matters")
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            }
            
            Text("Pacemaker malfunctions can be life-threatening in pacer-dependent patients. The EKG tells the story—you need to recognize the patterns to intervene quickly. Most issues fall into three categories: sensing problems, capture failure, or output failure.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.35))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.8))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(accentBlue.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Malfunction Detail View
struct MalfunctionDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    var malfunction: PacemakerMalfunction
    @State private var showImageFullscreen = false
    @State private var isAppearing = false
    
    // NOTE: Do NOT name this "accentColor" — it shadows SwiftUI's built-in
    // accentColor and causes NavigationLink to push then immediately pop.
    private let brandAccent = Color(red: 0.2, green: 0.5, blue: 0.9)
    
    var body: some View {
        ZStack {
            PacemakerLightBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    // MARK: - Header
                    VStack(spacing: 16) {
                        Text(malfunction.category)
                            .font(.custom("Poppins-Bold", size: 26))
                            .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                            .multilineTextAlignment(.center)
                        
                        // EKG Image (if available)
                        if !malfunction.imageEkg.isEmpty {
                            Button(action: { showImageFullscreen = true }) {
                                VStack(spacing: 10) {
                                    Image(malfunction.imageEkg)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    HStack(spacing: 6) {
                                        Image(systemName: "hand.tap.fill")
                                            .font(.system(size: 11))
                                        Text("Tap to enlarge")
                                            .font(.custom("Poppins-Medium", size: 11))
                                    }
                                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white.opacity(0.8))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.15), lineWidth: 1)
                                )
                                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 20)
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 20)
                    
                    // MARK: - Issues
                    PacemakerSectionDivider(title: "Details")
                    
                    VStack(spacing: 16) {
                        ForEach(malfunction.issues, id: \.title) { issue in
                            IssueCard(issue: issue)
                        }
                    }
                    .opacity(isAppearing ? 1 : 0)
                    .offset(y: isAppearing ? 0 : 30)
                    
                    Spacer(minLength: 60)
                }
                .padding(.horizontal, 20)
            }
        }
        .fullScreenCover(isPresented: $showImageFullscreen) {
            PhotoView(image: malfunction.imageEkg)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAppearing = true
            }
        }
    }
}

// MARK: - Issue Card
struct IssueCard: View {
    @Environment(\.colorScheme) var colorScheme
    let issue: PacemakerIssue
    @State private var isExpanded = true
    
    private let accentBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(accentBlue)
                        .frame(width: 4, height: 24)
                    
                    Text(issue.title)
                        .font(.custom("Poppins-SemiBold", size: 17))
                        .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                        .padding(.horizontal, 20)
                    
                    Text(issue.description)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(20)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Group {
                if colorScheme == .dark {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(CriticalDesign.Colors.cardBlue)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(.ultraThinMaterial)
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(Color.white.opacity(0.7))
                    }
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(isExpanded ? accentBlue.opacity(0.2) : (colorScheme == .dark ? Color.white.opacity(0.1) : Color.white.opacity(0.8)), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Preview
struct MalfunctionListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MalfunctionListView()
        }
    }
}
