import Foundation
import Supabase

final class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // Development
        let urlString = "http://127.0.0.1:54321"
        let anonKey = "sb_publishable_ACJWlzQH1ZjBrEguHvfOxg_3BJgxAaH"
        
        
        
        // Production
//        let urlString = "https://eocldmwhgovgdhuttwgs.supabase.co"
//        let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvY2xkbXdoZ292Z2RodXR0d2dzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0NjcwMDQsImV4cCI6MjA4OTA0MzAwNH0.IoX56kW8xSPoxw4pvyfvpZBr7mJCVdl6g47bahFh2YY"
        
        guard let url = URL(string: urlString), !anonKey.isEmpty else {
            fatalError("Check your hardcoded Supabase URL or Key.")
        }
        
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: anonKey
        )
        
        print("✅ SupabaseClient initialized successfully via hardcoded values.")
    }
}

extension SupabaseManager {
    /// Syncs a local SwiftData Resume to Supabase
    func syncResume(_ resume: Resume) async throws {
        // 1. Get current user ID
        guard let userId = client.auth.currentSession?.user.id else {
            print("❌ No logged-in user found")
            return
        }
        
        // 2. Map local Resume to UserResume (Supabase model)
        let cloudResume = UserResume(
            id: resume.id,
            userId: userId,
            title: resume.title,
            content: resume.content,
            templateId: resume.templateID,
            fileUrl: nil, // Add if you have a PDF link
            createdAt: resume.createdAt
        )
        
        // 3. Perform the Upsert
        try await client
            .from("resumes")
            .upsert(cloudResume)
            .execute()
            
        print("✅ Successfully synced resume: \(resume.title)")
    }
}
