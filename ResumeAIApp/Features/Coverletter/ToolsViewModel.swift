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
    
    // Core Processing states
    var isProcessingAI = false
    var aiResultOutput = ""
    
    // Core Workspace Text Field Buffers
    var textInputBuffer = ""
    var jobAdBuffer = ""
    var companyName = ""
    var jobTitle = ""
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
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
    
    struct CoverLetterResponse: Codable {
        let coverLetter: String
        
        enum CodingKeys: String, CodingKey {
            case coverLetter = "cover_letter" // Maps "cover_letter" from JSON to camelCase
        }
    }
    
    func generateCoverLetterWithAI() {
        isProcessingAI = true
        aiResultOutput = ""
        
        Task {
            do {
                let payload: [String: Any] = [
                    "company_name": companyName,
                    "job_title": jobTitle,
                    "job_description": jobAdBuffer
                ]
                
                let jsonData = try JSONSerialization.data(withJSONObject: payload)
                
                // Invoke the function normally
                let responseData: Data = try await supabaseClient.functions.invoke(
                    "generate-cover-letter",
                    options: FunctionInvokeOptions(
                        method: .post,
                        body: jsonData
                    )
                )
                
                // Convert the response buffer into lines to parse the stream
                guard let responseString = String(data: responseData, encoding: .utf8) else {
                    throw NSError(domain: "DecodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to parse stream raw data"])
                }
                
                // Clean up the text-event-stream format lines
                // Server-sent events look like: "data: { ... }" or raw text lines depending on your Deno setup
                let lines = responseString.components(separatedBy: .newlines)
                
                for line in lines {
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
                self.aiResultOutput = "Failed to draft statement: \(error.localizedDescription)"
                self.isProcessingAI = false
            }
        }
    }
    
    func executeResumeTailoringEngine() {
        isProcessingAI = true
        aiResultOutput = ""
        
        Task {
            do {
                let payload: [String: Any] = [
                    "job_description": jobAdBuffer
                ]
                
                let jsonData = try JSONSerialization.data(withJSONObject: payload)
                
                let responseData: Data = try await supabaseClient.functions.invoke(
                    "tailor-resume",
                    options: FunctionInvokeOptions(
                        method: .post,
                        body: jsonData
                    )
                )
                
                // Extract response.data directly into a UTF8 cleartext format output
                self.aiResultOutput = String(data: responseData, encoding: .utf8) ?? "Optimization engine completed layout changes successfully."
                self.isProcessingAI = false
            } catch {
                self.aiResultOutput = "Tailoring pipeline aborted: \(error.localizedDescription)"
                self.isProcessingAI = false
            }
        }
    }
}
