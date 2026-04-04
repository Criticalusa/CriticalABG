//
//  KeychainHelper.swift
//  CriticalX
//
//  Simple Keychain wrapper for storing sensitive data
//

import Foundation
import Security

enum KeychainKey: String {
    case claudeAPIKey = "com.criticalmed.claude-api-key"
    case openAIAPIKey = "com.criticalmed.openai-api-key"
    case patientContext = "com.criticalmed.patient-context"
}

struct KeychainHelper {

    static func save(_ value: String, for key: KeychainKey) {
        guard let data = value.data(using: .utf8) else { return }
        // Delete old value first
        delete(key)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    static func get(_ key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func exists(_ key: KeychainKey) -> Bool {
        return get(key) != nil
    }

    static func delete(_ key: KeychainKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }
}
