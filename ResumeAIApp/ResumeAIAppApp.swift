import SwiftUI
import SwiftData
import RevenueCat

@main
struct ResumeAIAppApp: App {
    
    @StateObject private var authManager = AuthManager()
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    init() {
            // You MUST do this before the UI loads
            Purchases.logLevel = .debug
            Purchases.configure(withAPIKey: "test_fQmhDabrxyXbYqUbgnOZjERQgVe")
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
                    
                    ContentView()
                    
                }
            }
            .environmentObject(authManager)
            
        }
        .modelContainer(sharedModelContainer)
    }
}
