//
//  APIKeySetupView.swift
//  CriticalX
//
//  Secure API key setup for AI-enhanced search
//  Keys are stored in iOS Keychain, never in code
//

import SwiftUI

struct APIKeySetupView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var apiKey: String = ""
    @State private var isKeyVisible: Bool = false
    @State private var showSaveConfirmation: Bool = false
    @State private var saveError: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                CriticalDesign.Colors.canvas.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: CriticalDesign.Spacing.xl) {
                        // Header
                        headerSection
                        
                        // API Key Input
                        apiKeyInput
                        
                        // Status
                        statusSection
                        
                        // Instructions
                        instructionsSection
                        
                        Spacer(minLength: 50)
                    }
                    .padding(CriticalDesign.Spacing.lg)
                }
            }
            .navigationTitle("AI Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveKey() }
                        .fontWeight(.semibold)
                        .disabled(apiKey.isEmpty)
                }
            }
            .alert("Key Saved", isPresented: $showSaveConfirmation) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your API key has been securely stored in the iOS Keychain.")
            }
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: CriticalDesign.Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [CriticalDesign.Colors.cardBlue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            
            Text("Enable AI-Enhanced Search")
                .font(.custom("Poppins-Bold", size: 22))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Text("Add your OpenAI API key to enable intelligent query understanding when offline search doesn't find a match.")
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - API Key Input
    
    private var apiKeyInput: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
            Text("API KEY")
                .font(.custom("Poppins-Bold", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .tracking(1)
            
            HStack {
                if isKeyVisible {
                    TextField("sk-proj-...", text: $apiKey)
                        .font(.custom("Poppins-Regular", size: 14))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } else {
                    SecureField("sk-proj-...", text: $apiKey)
                        .font(.custom("Poppins-Regular", size: 14))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                Button(action: { isKeyVisible.toggle() }) {
                    Image(systemName: isKeyVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                }
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(colorScheme == .dark ? CriticalDesign.Colors.cardBlue : Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 2, y: 2)
            )
            
            if let error = saveError {
                Text(error)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(.red)
            }
        }
    }
    
    // MARK: - Status
    
    private var statusSection: some View {
        HStack(spacing: CriticalDesign.Spacing.md) {
            Image(systemName: APIKeyManager.isConfigured ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(APIKeyManager.isConfigured ? CriticalDesign.Colors.accentGreen : CriticalDesign.Colors.tertiary)
            
            Text(APIKeyManager.isConfigured ? "API key is configured" : "No API key configured")
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
            
            Spacer()
            
            if APIKeyManager.isConfigured {
                Button(action: clearKey) {
                    Text("Clear")
                        .font(.custom("Poppins-Medium", size: 12))
                        .foregroundColor(.red)
                }
            }
        }
        .padding(CriticalDesign.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                .fill(APIKeyManager.isConfigured 
                      ? CriticalDesign.Colors.accentGreen.opacity(0.1) 
                      : Color.gray.opacity(0.1))
        )
    }
    
    // MARK: - Instructions
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: CriticalDesign.Spacing.md) {
            Text("HOW TO GET AN API KEY")
                .font(.custom("Poppins-Bold", size: 10))
                .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
                .tracking(1)
            
            VStack(alignment: .leading, spacing: CriticalDesign.Spacing.sm) {
                instructionRow(number: 1, text: "Go to platform.openai.com")
                instructionRow(number: 2, text: "Sign in or create an account")
                instructionRow(number: 3, text: "Navigate to API Keys section")
                instructionRow(number: 4, text: "Click 'Create new secret key'")
                instructionRow(number: 5, text: "Copy and paste the key here")
            }
            
            // Security note
            HStack(alignment: .top, spacing: CriticalDesign.Spacing.sm) {
                Image(systemName: "lock.shield.fill")
                    .foregroundColor(CriticalDesign.Colors.accentGreen)
                
                Text("Your API key is stored securely in the iOS Keychain and never leaves your device or appears in logs.")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(CriticalDesign.Adaptive.textSecondary(for: colorScheme))
            }
            .padding(CriticalDesign.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: CriticalDesign.Radius.md)
                    .fill(CriticalDesign.Colors.accentGreen.opacity(0.08))
            )
        }
    }
    
    private func instructionRow(number: Int, text: String) -> some View {
        HStack(spacing: CriticalDesign.Spacing.sm) {
            Text("\(number)")
                .font(.custom("Poppins-Bold", size: 12))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(CriticalDesign.Colors.cardBlue))
            
            Text(text)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(CriticalDesign.Adaptive.textPrimary(for: colorScheme))
        }
    }
    
    // MARK: - Actions
    
    private func saveKey() {
        guard !apiKey.isEmpty else { return }
        
        // Validate key format
        guard apiKey.hasPrefix("sk-") else {
            saveError = "Invalid key format. Should start with 'sk-'"
            return
        }
        
        // Save to Keychain
        if APIKeyManager.saveOpenAIKey(apiKey) {
            saveError = nil
            showSaveConfirmation = true
        } else {
            saveError = "Failed to save key. Please try again."
        }
    }
    
    private func clearKey() {
        APIKeyManager.clearOpenAIKey()
        apiKey = ""
    }
}

#Preview {
    APIKeySetupView()
}
