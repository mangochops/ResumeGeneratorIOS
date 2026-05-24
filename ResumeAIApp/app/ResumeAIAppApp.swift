import SwiftUI
import SwiftData
import RevenueCat
import Supabase

@main
struct ResumeAIAppApp: App {
    
    @StateObject private var authManager = AuthManager()
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    
    let supabase: SupabaseClient
    
    let sharedModelContainer: ModelContainer
        
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
        
            do {
                self.sharedModelContainer = try ModelContainer(for: Resume.self, CoverLetter.self, Application.self)
            } catch {
                fatalError("🚨 SwiftData Error: Failed to build local storage container: \(error.localizedDescription)")
            }
        }
    
    
    
    
    var body: some Scene {
        
        WindowGroup {
            
            Group {
                
                if !authManager.isAuthenticated {
                    
                    LoginView()
                    
                } else if !hasSeenOnboarding {
                    
                    OnboardingView()
                    
                } else {
                    
                    ContentView(
                        supabaseClient: supabase,
                        modelContext: sharedModelContainer.mainContext
                    )
                    
                }
            }
            .modelContainer(sharedModelContainer)
            .environmentObject(authManager)
            
        }
        
    }
}
