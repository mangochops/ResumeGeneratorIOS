import Foundation
import Supabase

final class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // We are bypassing the Info.plist because the build settings are out of sync.
        // Hardcoding these allows you to actually run and test your app logic.
        
        let urlString = "https://eocldmwhgovgdhuttwgs.supabase.co"
        
        // PASTE YOUR FULL ANON KEY BELOW
        let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvY2xkbXdoZ292Z2RodXR0d2dzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0NjcwMDQsImV4cCI6MjA4OTA0MzAwNH0.IoX56kW8xSPoxw4pvyfvpZBr7mJCVdl6g47bahFh2YY"
        
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
