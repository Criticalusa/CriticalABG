//
//  APIKeyManager.swift
//  CriticalX
//
//  Manages API keys via Keychain for AI services
//

import Foundation

struct APIKeyManager {

    // MARK: - OpenAI

    static var openAIKey: String? {
        KeychainHelper.get(.openAIAPIKey)
    }

    static var isConfigured: Bool {
        openAIKey != nil && !(openAIKey?.isEmpty ?? true)
    }

    @discardableResult
    static func saveOpenAIKey(_ key: String) -> Bool {
        KeychainHelper.save(key, for: .openAIAPIKey)
        return true
    }

    static func clearOpenAIKey() {
        KeychainHelper.delete(.openAIAPIKey)
    }

    // MARK: - Claude

    static var claudeKey: String? {
        KeychainHelper.get(.claudeAPIKey)
    }

    static var isClaudeConfigured: Bool {
        claudeKey != nil && !(claudeKey?.isEmpty ?? true)
    }

    @discardableResult
    static func saveClaudeKey(_ key: String) -> Bool {
        KeychainHelper.save(key, for: .claudeAPIKey)
        return true
    }

    // MARK: - Any Provider

    static var hasAnyProvider: Bool {
        isConfigured || isClaudeConfigured
    }

    // MARK: - Other Keys (stored in UserDefaults for non-sensitive keys)

    static var mailchimpKey: String? {
        UserDefaults.standard.string(forKey: "mailchimp_api_key")
    }

    static var newsAPIKey: String? {
        UserDefaults.standard.string(forKey: "news_api_key")
    }

    // MARK: - Debug

    static func debugPrintStatus() {
        #if DEBUG
        print("[APIKeyManager] OpenAI configured: \(isConfigured)")
        print("[APIKeyManager] Claude configured: \(isClaudeConfigured)")
        print("[APIKeyManager] Any provider: \(hasAnyProvider)")
        #endif
    }
}
