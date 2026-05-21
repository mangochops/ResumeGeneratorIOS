import SwiftUI
import SwiftData
import RevenueCat
import Supabase

@main
struct ResumeAIAppApp: App {
    
    @StateObject private var authManager = AuthManager()
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    private static var supabaseURLString: String {
        Bundle.main.object(forInfoDictionaryKey: "SupabaseURL") as? String ?? ""
    }
    
    private static var supabaseAnonKeyString: String {
        Bundle.main.object(forInfoDictionaryKey: "SupabaseAnonKey") as? String ?? ""
    }
    
    private static var revenueCatAPIKey: String {
        Bundle.main.object(forInfoDictionaryKey: "RevenueCatAPIKey") as? String ?? ""
    }
    
    let supabase: SupabaseClient
        
    init() {
            let cleanURLString = Self.supabaseURLString.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanAnonKey = Self.supabaseAnonKeyString.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanRevenueCatKey = Self.revenueCatAPIKey.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // 1. Initialize Supabase safely
            if let url = URL(string: cleanURLString), !cleanURLString.isEmpty, !cleanAnonKey.isEmpty {
                print("🚀 CONFIG: Successfully reading configuration keys from Bundle Info.plist")
                self.supabase = SupabaseClient(supabaseURL: url, supabaseKey: cleanAnonKey)
            } else {
                print("⚠️ CONFIG ERROR: Bundle.main could not read valid Supabase credentials.")
                print("Read URL: '\(cleanURLString)'")
                print("Read Key Length: \(cleanAnonKey.count) characters")
                
                // Hardcoded safe development fallback to allow the application to boot
                let fallbackURL = URL(string: "https://eocldmwhgovgdhuttwgs.supabase.co")!
                let fallbackKey = "sb_publishable_25DHcb2BpSRJWVNtNWWETg_LzHFVppL"
                self.supabase = SupabaseClient(supabaseURL: fallbackURL, supabaseKey: fallbackKey)
            }
            
            // 2. Initialize RevenueCat safely
            Purchases.logLevel = .debug
            if !cleanRevenueCatKey.isEmpty {
                Purchases.configure(withAPIKey: cleanRevenueCatKey)
            } else {
                print("⚠️ CONFIG ERROR: Bundle.main could not read 'RevenueCatAPIKey'. Using development fallback.")
                let fallbackRCKey = "test_fQmhDabrxyXbYqUbgnOZjERQgVe"
                Purchases.configure(withAPIKey: fallbackRCKey)
            }
        }
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Resume.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Log the actual error to the console before crashing
            print("Detailed SwiftData Error: \(error)")
            
            // Optional: In development, you can handle migration errors by
            // destroying the store, though deleting the app is safer.
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
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
            .environmentObject(authManager)
            
        }
        .modelContainer(sharedModelContainer)
    }
}
