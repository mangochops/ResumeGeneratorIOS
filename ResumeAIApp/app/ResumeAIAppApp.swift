import SwiftUI
import SwiftData
import RevenueCat
import Supabase

@main
struct ResumeAIAppApp: App {
    
    @StateObject private var authManager = AuthManager()
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
//    private static var supabaseURLString: String {
//        Bundle.main.object(forInfoDictionaryKey: "SupabaseURL") as? String ?? ""
//    }
//    
//    private static var supabaseAnonKeyString: String {
//        Bundle.main.object(forInfoDictionaryKey: "SupabaseAnonKey") as? String ?? ""
//    }
//    
//    private static var revenueCatAPIKey: String {
//        Bundle.main.object(forInfoDictionaryKey: "RevenueCatAPIKey") as? String ?? ""
//    }
    
    let supabase: SupabaseClient
        
    init() {
            // 1. Initialize Supabase directly using the hardcoded config enum layer
            guard let url = URL(string: SupabaseConfig.url) else {
                fatalError("🚨 Configuration Error: Centralized Supabase URL string sequence is invalid.")
            }
            
            self.supabase = SupabaseClient(
                supabaseURL: url,
                supabaseKey: SupabaseConfig.anonKey
            )
            print("🚀 CONFIG: Successfully initialized SupabaseClient via hardcoded Config boundaries.")
            
            // 2. Initialize RevenueCat safely via the centralized configuration
            Purchases.logLevel = .debug
            Purchases.configure(withAPIKey: SupabaseConfig.revenueCatAPIKey)
            print("🚀 CONFIG: Successfully initialized RevenueCat via hardcoded Config boundaries.")
        }
    
    
    
    
    var body: some Scene {
        
        WindowGroup {
            
            Group {
                
                if !authManager.isAuthenticated {
                    
                    LoginView()
                    
                } else if !hasSeenOnboarding {
                    
                    OnboardingView()
                    
                } else {
                    
                    ContentView(supabaseClient: supabase)
                    
                }
            }
            .modelContainer(for: [Resume.self, CoverLetter.self, Application.self])
            .environmentObject(authManager)
            
        }
        
    }
}
