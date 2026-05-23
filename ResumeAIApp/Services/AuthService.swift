import Foundation
import Supabase

final class AuthService {
    
    static let shared = AuthService()
    
    private let client = SupabaseManager.shared.client
    
    // MARK: - Current User
    /// Computed property to access the current authenticated user
    var currentUser: User? {
        return client.auth.currentUser
    }
    
    /// Checks if a session currently exists
    var isAuthenticated: Bool {
        return client.auth.currentSession != nil
    }
    
    // MARK: - Auth Methods
    
    func signUp(email: String, password: String, fullName:String) async throws {
        try await client.auth.signUp(
            email: email,
            password: password,
            data: ["full_name": .string(fullName)]
        )
    }
    
    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(
            email: email,
            password: password
        )
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    // MARK: - User Details Fetching
    /// If you need to fetch extra profile data from a 'profiles' table in Supabase
    func getProfile() async throws -> Profile? {
        guard let userId = currentUser?.id else { return nil }
        
        // Fetch the single profile row matching the current User ID
        let profile: Profile = try await client
                .from("profiles")
                .select()
                .eq("id", value: userId)
                .single()
                .execute()
                .value
        
        return profile
    }
    
    func updateUserProfile(fullName: String? = nil, password: String? = nil) async throws {
        let currentUser = client.auth.currentUser
        guard let userId = currentUser?.id else { return }

        // 1. Update Supabase Auth (Metadata & Password)
        var attributes = UserAttributes()
        if let fullName = fullName {
            attributes.data = ["full_name": .string(fullName)]
        }
        if let password = password {
            attributes.password = password
        }
        
        try await client.auth.update(user: attributes)
        
        // 2. Update the 'profiles' table so the ProfileView stays in sync
        if let fullName = fullName {
            try await client
                .from("profiles")
                .update(["full_name": fullName])
                .eq("id", value: userId)
                .execute()
        }
    }
    
    func fetchUserResumes() async throws -> [Resume] {
        // 1. Get the user ID from currentUser (which is optional)
        guard let userId = currentUser?.id else {
            return [] // Return empty if no user is logged in
        }
        
        // 2. Fetch from Supabase using the renamed UserResume model
        let dtos: [Resume.ResumeDTO] = try await client
                    .from("resumes")
                    .select()
                    .eq("user_id", value: userId)
                    .execute()
                    .value
                
                // 3. FIXED: Safely unpack and map the network DTOs back into native SwiftData entities
        return dtos.map { $0.toModel() }
    }
}
