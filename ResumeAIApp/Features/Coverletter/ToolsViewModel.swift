//
//  CoverLetterViewModel.swift
//  ResumeAIApp
//
//  Created by mac on 2026.
//

import SwiftUI
import Supabase

@Observable
@MainActor
class CoverLetterViewModel {
    
    let supabaseClient: SupabaseClient
    private let anonKey: String
    
    // Core Processing states
    var isProcessingAI = false
    var aiResultOutput = ""
    
    // Core Workspace Text Field Buffers
    var textInputBuffer = ""
    var jobAdBuffer = ""
    var companyName = ""
    var jobTitle = ""
    var customTitle = ""
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
        self.anonKey = SupabaseConfig.anonKey
    }
    
    /// Helper to safely retrieve the active session token for authorization headers
    private func getAuthHeader() async -> String? {
        if let session = try? await supabaseClient.auth.session {
            return "Bearer \(session.accessToken)"
        }
        return nil
    }
    
    func clearWorkspaceBuffers() {
        textInputBuffer = ""
        jobAdBuffer = ""
        companyName = ""
        jobTitle = ""
        aiResultOutput = ""
        isProcessingAI = false
    }
    
    struct CoverLetterStreamRequest: Encodable {
            let jobDescription: String
            let companyName: String
            let jobTitle: String
        }
        
    struct ResumeTailorRequest: Encodable {
            let jobDescription: String
            
            let title: String
        }
    
    // --- WORKSPACE CORE SUPABASE EDGE FUNCTION PIPELINE ---
    
    func runAIUtilityProcessing(type: CoverLetterView.OptimizationType) {
        isProcessingAI = true
        aiResultOutput = ""
        
        Task {
            do {
                let actionType: String
                switch type {
                case .bulletRewrite: actionType = "bullet_rewrite"
                case .summaryImprove: actionType = "summary_improve"
                case .matchAnalysis: actionType = "match_analysis"
                case .atsCheck: actionType = "ats_check"
                }
                
                let jsonPayload: [String: Any] = [
                    "action": actionType,
                    "text": textInputBuffer
                ]
                
                let jsonData = try JSONSerialization.data(withJSONObject: jsonPayload)
                
                // response is retrieved as a FunctionResponse struct instance
                let responseData: Data = try await supabaseClient.functions.invoke(
                    "optimize-resume",
                    options: FunctionInvokeOptions(
                        method: .post,
                        body: jsonData
                    )
                )
                
                // Extract the underlying raw .data buffer for JSON parsing
                if let jsonResult = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
                   let outputText = jsonResult["output"] as? String {
                    self.aiResultOutput = outputText
                } else {
                    self.aiResultOutput = String(data: responseData, encoding: .utf8) ?? "Parsing execution failure matrix."
                }
                self.isProcessingAI = false
                
            } catch {
                self.aiResultOutput = "Execution Error: \(error.localizedDescription)"
                self.isProcessingAI = false
            }
        }
    }
    
   
    
    func generateCoverLetterWithAI() {
            isProcessingAI = true
            aiResultOutput = ""
                
            Task {
                do {
                    // 1. Get the current active authorization token
                    guard let authHeader = await getAuthHeader() else {
                        throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Missing Auth Session Token"])
                    }
                        
                    // 2. Set up the explicit endpoint URL
                    let urlString = "https://eocldmwhgovgdhuttwgs.supabase.co/functions/v1/generate-cover-letter"
                    guard let url = URL(string: urlString) else { return }
                        
                    // 3. Build the payload matching your Edge Function's expected properties
                    let payload = CoverLetterStreamRequest(
                        jobDescription: jobAdBuffer,
                        companyName: companyName,
                        jobTitle: jobTitle
                    )
                        
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue(authHeader, forHTTPHeaderField: "Authorization")
                    
                    // FIXED: Pulling key from configuration options block
                    let anonKey = self.anonKey
                    request.setValue(anonKey, forHTTPHeaderField: "apikey")
                    request.httpBody = try JSONEncoder().encode(payload)
                        
                    // Set a generous timeout window for the initial handshake connection
                    request.timeoutInterval = 60.0
                        
                    // 4. Use Apple's streaming bytes method to keep the connection active
                    let (bytes, response) = try await URLSession.shared.bytes(for: request)
                        
                    // FIXED: Cleaned up character syntax types on cast assignment
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw NSError(domain: "ServerError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Server returned non-200 status code"])
                    }
                        
                    // 5. Read lines asynchronously as they drop down from the edge container
                    for try await line in bytes.lines {
                        if line.hasPrefix("data: ") && line != "data: [DONE]" {
                            let jsonString = line.replacingOccurrences(of: "data: ", with: "")
                                
                            if let jsonData = jsonString.data(using: .utf8),
                               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                               let choices = jsonObject["choices"] as? [[String: Any]],
                               let delta = choices.first?["delta"] as? [String: Any],
                               let content = delta["content"] as? String {
                                    
                                self.aiResultOutput += content
                            }
                        }
                    }
                        
                    self.isProcessingAI = false
                } catch {
                    self.aiResultOutput = "Streaming broken or timed out: \(error.localizedDescription)"
                    self.isProcessingAI = false
                }
            }
        }
    
    func executeResumeTailoringEngine() {
            isProcessingAI = true
            aiResultOutput = ""
            
            Task {
                do {
                    // 1. Fetch user authentication token string
                    guard let authHeader = await getAuthHeader() else {
                        throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Log in session expired."])
                    }
                    

                    // 3. Match keys with your edge engine payload expectations (`jobDescription` and `resumeText`)
                    let payload = ResumeTailorRequest(
                        jobDescription: jobAdBuffer,
                        title: customTitle.isEmpty ? "Tailored Resume" : customTitle
                    )
                    // 4. Hit direct URL endpoint to prevent routing context 404 drops on function execution
                    let urlString = "https://eocldmwhgovgdhuttwgs.supabase.co/functions/v1/tweak-resume"
                    guard let url = URL(string: urlString) else { return }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue(authHeader, forHTTPHeaderField: "Authorization")
                    request.setValue(self.anonKey, forHTTPHeaderField: "apikey")
                    request.httpBody = try JSONEncoder().encode(payload)
                    
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    
                    // Handle different response scenarios (Paywall limits vs Success layout)
                    if httpResponse.statusCode == 402 {
                        self.aiResultOutput = "Premium Upgrade Required: You are out of tailoring optimization credits."
                    } else if httpResponse.statusCode == 200 {
                        self.aiResultOutput = "✅ Resume optimized and generated! Your PDF has been saved automatically to your profile documents workspace."
                    } else {
                        let serverErrorMsg = String(data: data, encoding: .utf8) ?? "Status Code \(httpResponse.statusCode)"
                        self.aiResultOutput = "Tailoring pipeline failed: \(serverErrorMsg)"
                    }
                    
                    self.isProcessingAI = false
                } catch {
                    self.aiResultOutput = "Tailoring pipeline aborted: \(error.localizedDescription)"
                    self.isProcessingAI = false
                }
            }
        }
    
}
