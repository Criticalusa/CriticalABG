//
//  AIManager.swift
//  CriticalX
//
//  Created by Jadie Barringer III on 1/21/25.
//  Updated: Secure API key storage via Keychain, context injection
//

import Foundation

// MARK: - AI Manager for API Calls
struct AIManager {
    
    /// Get API key from secure Keychain storage
    private var apiKey: String? {
        APIKeyManager.openAIKey
    }
    
    /// Check if AI is available (API key configured)
    var isAvailable: Bool {
        APIKeyManager.isConfigured
    }
    
    // MARK: - Context Building
    
    /// Build patient context string from GlobalPatientContext
    private var patientContextString: String {
        let patient = GlobalPatientContext.shared
        var parts: [String] = []
        
        if let weight = patient.weightKg {
            parts.append("Patient weight: \(String(format: "%.1f", weight)) kg")
        }
        if let ibw = patient.idealBodyWeightKg {
            parts.append("IBW: \(String(format: "%.1f", ibw)) kg")
        }
        if let gender = patient.gender {
            parts.append("Gender: \(gender.rawValue)")
        }
        
        return parts.isEmpty ? "" : parts.joined(separator: ", ")
    }
    
    /// Get clinical role description for prompt adaptation
    private var roleContextString: String {
        let role = GlobalRoleManager.shared.currentRole
        switch role {
        case .stabilize:
            return "User's practice focus: STABILIZE (prehospital/ED - needs brief, action-oriented responses focused on immediate interventions)"
        case .monitor:
            return "User's practice focus: MONITOR (ICU/floor nursing - needs balanced detail about trending, what to watch for, nursing considerations)"
        case .manage:
            return "User's practice focus: MANAGE (physician/APP - needs deeper pathophysiology, differential considerations, treatment rationale)"
        }
    }
    
    /// Build the context section for the system prompt
    private func buildContextSection() -> String {
        var contextParts: [String] = []
        
        // Add role context
        contextParts.append(roleContextString)
        
        // Add patient context if available
        if !patientContextString.isEmpty {
            contextParts.append("Current patient: \(patientContextString)")
        }
        
        return contextParts.isEmpty ? "" : "CURRENT CONTEXT:\n" + contextParts.joined(separator: "\n")
    }

    /// Fetch AI response for a given question and context.
    /// - Parameters:
    ///   - question: The user's question.
    ///   - context: Contextual information to provide to the AI.
    ///   - completion: Completion handler with `Result` containing a success (String) or failure (Error).
    func fetchAIResponse(for question: String, context: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Check network connectivity first
        if !NetworkMonitor.shared.isConnected {
            completion(.failure(NSError(domain: "AIManager", code: -3, userInfo: [NSLocalizedDescriptionKey: "Luca requires an internet connection. All clinical tools, calculators, and medications work offline."])))
            return
        }

        // Verify API key is available
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            completion(.failure(NSError(domain: "AIManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "API key not configured. Please set up your API key in Settings."])))
            return
        }
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion(.failure(NSError(domain: "AIManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Build context-aware system prompt
        let contextSection = buildContextSection()

        let systemPrompt = """
        You are Luca, a clinical education assistant in CriticalMed, a critical care reference app. You help healthcare professionals understand clinical concepts, not replace their judgment.

        \(contextSection)

        CRITICAL REQUIREMENTS:
        1. Cite specific guidelines (ACLS, ATLS, SCCM, AHA, etc.) when giving clinical information
        2. Format citations as: "Per [GUIDELINE] guidelines: [info]"
        3. Include "Source: [guideline name]" for clinical claims
        4. Never generate specific drug doses - refer users to the app's verified medication data
        5. Explain the WHY behind clinical decisions
        6. Adapt explanation depth to user's practice focus (shown above)

        RESPONSE FORMAT:
        • Keep responses under 200 words unless complex topic requires more
        • Use ### for section headers
        • Use bullet points (•) for lists
        • Bold **key terms**
        • End with: "Source: [guidelines cited]" and "Verify with your institution's protocols."

        PRACTICE FOCUS ADAPTATION:
        • Stabilize → Brief, action-oriented, immediate interventions
        • Monitor → Balanced detail, trending, what to watch for
        • Manage → Deeper pathophysiology, differential considerations

        Be calm, professional, and supportive. You're a knowledgeable colleague, not a lecturer.
        """

        let payload: [String: Any] = [
            "model": "gpt-4o",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": question]
            ],
            "max_tokens": 400,
            "temperature": 0.5
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            // Log the raw response for debugging
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw API Response: \(rawResponse)")
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                // Handle errors in the API response
                if let error = jsonResponse?["error"] as? [String: Any],
                   let errorMessage = error["message"] as? String {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                    return
                }

                // Parse the valid response
                if let choices = jsonResponse?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
