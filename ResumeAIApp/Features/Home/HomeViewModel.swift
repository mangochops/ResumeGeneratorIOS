//
//  HomeViewModel.swift
//  ResumeAIApp
//
//  Created by mac on 5/19/26.
//

import Foundation
import Combine
import Supabase
import UniformTypeIdentifiers

struct UserProfile {
    let firstName: String
}

@MainActor
class HomeViewModel: ObservableObject {
    private let supabaseClient: SupabaseClient
    
    // UI Reactive States matching Kotlin StateFlows
    @Published var recentResumes: [Resume] = []
    @Published var recentCoverLetters: [CoverLetter] = []
    @Published var isLoading: Bool = false
    @Published var isUploading: Bool = false
    @Published var selectedResumeFullText: String = ""
    @Published var userProfile: UserProfile? = nil
    @Published var userCredits: Int = 0
    @Published var showPaywall: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    // Custom JSONDecoder configuration to handle database dates if needed
    private let decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        jsonDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = formatter.date(from: dateString) { return date }
            // Fallback for standard ISO formats
            let isoDecoder = ISO8601DateFormatter()
            isoDecoder.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = isoDecoder.date(from: dateString) { return date }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format: \(dateString)")
        }
        return jsonDecoder
    }()
    
    init(supabaseClient: SupabaseClient) {
        self.supabaseClient = supabaseClient
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
            
            for await (_, session) in  supabaseClient.auth.authStateChanges {
                if let session = session {
                    let user = session.user
                    
                    let metaName = user.userMetadata["full_name"]?.stringValue
                        ?? user.userMetadata["name"]?.stringValue
                        ?? "User"
                    
                    let initialFirstName = metaName.components(separatedBy: " ").first ?? "User"
                    let cleanFirstName = initialFirstName.replacingOccurrences(of: "\"", with: "")
                    self.userProfile = UserProfile(firstName: cleanFirstName)
                    
                    do {
                        let userIdString = user.id.uuidString
                        
                        // FIXED: Executing inline for 2.3.0
                        let response = try await supabaseClient.from("profiles")
                            .select()
                            .eq("id", value: userIdString)
                            .single()
                            .execute()
                        
                        // FIXED: Decode explicitly using JSONDecoder from response.data payload
                        let profile = try decoder.decode(Profile.self, from: response.data)
                        
                        if let dbName = profile.fullName, !dbName.isEmpty {
                            let dbFirstName = dbName.replacingOccurrences(of: "\"", with: "").components(separatedBy: " ").first ?? "User"
                            self.userProfile = UserProfile(firstName: dbFirstName)
                        }
                        
                        self.userCredits = profile.credits ?? 0
                        
                    } catch {
                        print("HOME_VM: Database Profile fetch failed: \(error.localizedDescription)")
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
                // FIXED: Direct chain execution returning a PostgrestResponse structure
                let resumesResponse = try await supabaseClient
                    .from("resumes")
                    .select()
                    .order("created_at", ascending: false)
                    .limit(5)
                    .execute()
                
                // FIXED: Read data payload directly via standard JSONDecoder instance parsing
                self.recentResumes = try decoder.decode([Resume].self, from: resumesResponse.data)
                
                // FIXED: Direct chain execution returning a PostgrestResponse structure
                let coverLettersResponse = try await supabaseClient
                    .from("cover_letters")
                    .select()
                    .order("created_at", ascending: false)
                    .limit(5)
                    .execute()
                
                // FIXED: Read data payload directly via standard JSONDecoder instance parsing
                let decodableLetters = try decoder.decode([CoverLetterDBPayload].self, from: coverLettersResponse.data)
                self.recentCoverLetters = decodableLetters.map { payload in
                    CoverLetter(
                        id: payload.id,
                        userId: payload.user_id,
                        title: payload.title,
                        companyName: payload.company_name,
                        jobTitle: payload.job_title,
                        content: payload.content,
                        createdAt: payload.created_at
                    )
                }
                    
            } catch {
                print("HOME_VM: Fetch Error: \(error.localizedDescription)")
            }
        }
    }
    
    func uploadResumeToSupabase(fileURL: URL) {
        Task {
            isUploading = true
            defer { isUploading = false }
            
            do {
                guard fileURL.startAccessingSecurityScopedResource() else { return }
                defer { fileURL.stopAccessingSecurityScopedResource() }
                
                let rawPdfText = try readPdfContent(from: fileURL)
                
                let activeSession = try? await supabaseClient.auth.session
                guard let user = activeSession?.user else { return }
                let currentUserId = user.id.uuidString
                
                let fallbackName = self.userProfile?.firstName ?? "User"
                let fileName = "resume_\(Int(Date().timeIntervalSince1970)).pdf"
                let filePath = "\(currentUserId)/\(fileName)"
                
                let fileData = try Data(contentsOf: fileURL)
                try await supabaseClient.storage
                    .from("resumes")
                    .upload(filePath, data: fileData, options: FileOptions())
                
                let publicURL = try supabaseClient.storage
                    .from("resumes")
                    .getPublicURL(path: filePath)
                
                let newResume = UserResumeInsertPayload(
                    user_id: currentUserId,
                    title: "Primary Resume",
                    name: fallbackName,
                    file_url: publicURL.absoluteString,
                    content: ["text": rawPdfText]
                )
                
                try await supabaseClient.from("resumes")
                    .insert(newResume)
                    .execute()
                
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

struct CoverLetterDBPayload: Decodable {
    let id: String
    let user_id: String
    let title: String
    let company_name: String
    let job_title: String
    let content: String
    let created_at: Date
}
