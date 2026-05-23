//
//  HomeViewModel.swift
//  ResumeAIApp
//

import Foundation
import Combine
import Supabase
import UniformTypeIdentifiers

struct UserProfile {
    let firstName: String
}

// MARK: - Request/Response Structs
struct CoverLetterRequest: Encodable {
    let jobDescription: String
    let companyName: String
    let jobTitle: String
}

struct CoverLetterResponse: Decodable {
    let coverLetter: String
}

@Observable
@MainActor
class HomeViewModel {
    private let supabaseClient: SupabaseClient
    private let SupabaseURL: String
    private let SupabaseAnonKey: String
    
    var recentResumes: [Resume] = []
    var recentCoverLetters: [CoverLetter] = []
    var isLoading: Bool = false
    var isUploading: Bool = false
    var selectedResumeFullText: String = ""
    var userProfile: UserProfile? = nil
    var userCredits: Int = 0
    var showPaywall: Bool = false
    var liveGeneratedCoverLetter: String = ""
    var isGeneratingCoverLetter: Bool = false
    
    
    private let supabaseDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                if let date = formatter.date(from: dateString) { return date }
                
                let standardFormatter = ISO8601DateFormatter()
                standardFormatter.formatOptions = [.withInternetDateTime]
                if let date = standardFormatter.date(from: dateString) { return date }
                
                let customFormatter = DateFormatter()
                customFormatter.locale = Locale(identifier: "en_US_POSIX")
                customFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                let formats = [
                    "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ",
                    "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
                    "yyyy-MM-dd HH:mm:ss"
                ]
                for format in formats {
                    customFormatter.dateFormat = format
                    if let date = customFormatter.date(from: dateString) { return date }
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported date formatting strategy for value: \(dateString)")
            }
            return decoder
        }()
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
        self.SupabaseURL = SupabaseConfig.url
        self.SupabaseAnonKey = SupabaseConfig.anonKey
        refreshAll()
    }
    
    func refreshAll() {
        fetchUserData()
        fetchRecentGenerations()
    }
    
    func triggerPaywall() { self.showPaywall = true }
    func dismissPaywall() { self.showPaywall = false }
    
    private func fetchUserData() {
        Task {
            print("HOME_VM: Starting active session monitoring...")
            
            for await (_, session) in supabaseClient.auth.authStateChanges {
                if let session = session {
                    let user = session.user
                    
                    let metaName = user.userMetadata["full_name"]?.stringValue
                        ?? user.userMetadata["name"]?.stringValue
                        ?? "User"
                    
                    let initialFirstName = metaName.components(separatedBy: " ").first ?? "User"
                    let cleanFirstName = initialFirstName.replacingOccurrences(of: "\"", with: "")
                    self.userProfile = UserProfile(firstName: cleanFirstName)
                    
                    do {
                        let response = try await supabaseClient.from("profiles")
                            .select()
                            .eq("id", value: user.id.uuidString)
                            .single()
                            .execute()
                        
                        let profile = try supabaseDecoder.decode(Profile.self, from: response.data)
                        
                        if let dbName = profile.fullName, !dbName.isEmpty {
                            let dbFirstName = dbName.replacingOccurrences(of: "\"", with: "").components(separatedBy: " ").first ?? "User"
                            self.userProfile = UserProfile(firstName: dbFirstName)
                        }
                        
                        self.userCredits = profile.credits ?? 0
                        
                    } catch {
                        print("HOME_VM: Database Profile fetch failed: \(error)")
                    }
                } else {
                    print("HOME_VM: User is not logged in.")
                    self.userProfile = UserProfile(firstName: "User")
                    self.userCredits = 0
                }
            }
        }
    }
    
    func fetchRecentGenerations() {
        Task {
            isLoading = true
            defer { isLoading = false }
            
            do {
                let resumesResponse = try await supabaseClient
                    .from("resumes")
                    .select()
                    .order("created_at", ascending: false)
                    .limit(5)
                    .execute()
                
                let decodedResumes = try supabaseDecoder.decode([ResumeDTO].self, from: resumesResponse.data)
                
                let coverLettersResponse = try await supabaseClient
                    .from("cover_letters")
                    .select()
                    .order("created_at", ascending: false)
                    .limit(5)
                    .execute()
                
                let decodedLetters = try supabaseDecoder.decode([CoverLetterDTO].self, from: coverLettersResponse.data)
                
                self.recentResumes = decodedResumes.map { dto in
                    Resume(
                        id: dto.id,
                        userId: dto.user_id,
                        title: dto.title,
                        name: dto.name,
                        content: dto.content?.text, // Unwraps the text subfield to clean up String requirements
                        fileUrl: dto.file_url,
                        createdAt: dto.created_at
                    )
                }
                
                self.recentCoverLetters = decodedLetters.map { dto in
                    CoverLetter(
                        id: dto.id,
                        userId: dto.user_id,
                        companyName: dto.company_name,
                        jobTitle: dto.job_title,
                        content: dto.content,
                        createdAt: dto.created_at
                    )
                }
            } catch {
                print("HOME_VM: Fetch Error: \(error)")
            }
        }
    }
    
    func generateCoverLetter(jobDescription: String, companyName: String, jobTitle: String) {
        Task {
            isGeneratingCoverLetter = true
            liveGeneratedCoverLetter = ""
            
            do {
                let requestPayload = CoverLetterRequest(
                    jobDescription: jobDescription,
                    companyName: companyName,
                    jobTitle: jobTitle
                )
                
                let requestData = try JSONEncoder().encode(requestPayload)
                
                guard let url = URL(string: "\(SupabaseURL)/functions/v1/generate-cover-letter") else {
                    throw URLError(.badURL)
                }
                
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("Bearer \(SupabaseAnonKey)", forHTTPHeaderField: "Authorization")
                urlRequest.httpBody = requestData
                
                // Connect directly to the async byte data engine lines stream
                let (asyncBytes, response) = try await URLSession.shared.bytes(for: urlRequest)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                for try await line in asyncBytes.lines {
                    if line.hasPrefix("data: ") && line != "data: [DONE]" {
                        let jsonString = line.replacingOccurrences(of: "data: ", with: "")
                        
                        if let jsonData = jsonString.data(using: .utf8),
                           let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
                           let choices = jsonObject["choices"] as? [[String: Any]],
                           let delta = choices.first?["delta"] as? [String: Any],
                           let content = delta["content"] as? String {
                            
                            self.liveGeneratedCoverLetter += content
                        }
                    }
                }
                
                fetchRecentGenerations()
                
            } catch {
                print("HOME_VM: Cover Letter generation failed: \(error.localizedDescription)")
            }
            
            isGeneratingCoverLetter = false
        }
    }
    
    func uploadResumeToSupabase(fileURL: URL) {
            Task {
                isUploading = true
                defer { isUploading = false }
                
                do {
                    guard fileURL.startAccessingSecurityScopedResource() else { return }
                    defer { fileURL.stopAccessingSecurityScopedResource() }
                    
                    let fileData = try Data(contentsOf: fileURL)
                    let actualFileName = fileURL.lastPathComponent
                    
                    let activeSession = try await supabaseClient.auth.session
                    let currentUserId = activeSession.user.id.uuidString
                    
                    let storagePath = "\(currentUserId)/\(actualFileName)"
                    
                    _ = try await supabaseClient.storage
                        .from("resumes")
                        .upload(
                            path: storagePath,
                            file: fileData,
                            options: FileOptions(contentType: "application/pdf")
                        )
                    
                    let publicURL = try supabaseClient.storage
                        .from("resumes")
                        .getPublicURL(path: storagePath)
                    
                    let metadata = UserResumeInsertPayload(
                        user_id: currentUserId,
                        title: "Primary Resume",
                        name: userProfile?.firstName ?? "User",
                        file_url: publicURL.absoluteString,
                        content: ["text": ""]
                    )
                    
                    _ = try await supabaseClient.functions.invoke(
                        "upload-resume",
                        options: FunctionInvokeOptions(
                            method: .post,
                            headers: ["Content-Type": "application/json"],
                            body: metadata
                        )
                    )
                    
                    fetchRecentGenerations()
                    
                } catch {
                    print("HOME_VM: Upload failed: \(error.localizedDescription)")
                }
            }
        }
    
    private func readPdfContent(from url: URL) throws -> String {
        return "Extracted clean structural text data from PDF content"
    }
}

// MARK: - API DB Payload Helpers
struct UserResumeInsertPayload: Encodable {
    let user_id: String
    let title: String
    let name: String
    let file_url: String
    let content: [String: String]
}

struct ResumeDTO: Decodable {
    let id: UUID
    let user_id: UUID
    let title: String
    let name: String
    let content: ResumeContentDTO?
    let file_url: String?
    let created_at: Date
}

struct ResumeContentDTO: Decodable {
    let text: String?
}

struct CoverLetterDTO: Decodable {
    let id: UUID
    let user_id: UUID
    let company_name: String
    let job_title: String
    let content: String
    let created_at: Date
}
