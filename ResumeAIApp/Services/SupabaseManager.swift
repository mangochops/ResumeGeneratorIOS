import Foundation
import Supabase

final class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        if let infoDict = Bundle.main.infoDictionary {
                print("--- Available Info.plist Keys ---")
                for key in infoDict.keys {
                    print(key)
                }
                print("---------------------------------")
            }
        
        

        
        guard let url = URL(string: SupabaseConfig.url), !SupabaseConfig.anonKey.isEmpty else {
                fatalError("🚨 Supabase configuration values are invalid.")
            }
        
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: SupabaseConfig.anonKey
        )
        
        print("✅ SupabaseClient initialized successfully via Info.plist configurations.")
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
        let cloudDTO = Resume.ResumeDTO(from: resume)
        
        // 3. Perform the Upsert
        try await client
            .from("resumes")
            .upsert(cloudDTO)
            .execute()
            
        print("✅ Successfully synced resume: \(resume.title)")
    }
}
