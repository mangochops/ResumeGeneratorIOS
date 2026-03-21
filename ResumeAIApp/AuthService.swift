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
    func getProfile() async throws -> UserAttributes? {
        guard (currentUser?.id) != nil else { return nil }
        
        // Example: Fetching from a custom profiles table
        // return try await client.database.from("profiles").select().eq("id", value: userId).single().execute().value
        return nil
    }
    
    func updateUserProfile(fullName: String? = nil, password: String? = nil) async throws {
        var attributes = UserAttributes()
        
        // Update Full Name in metadata
        if let fullName = fullName {
            attributes.data = ["full_name": .string(fullName)]
        }
        
        // Update Password if provided
        if let password = password {
            attributes.password = password
        }
        
        try await client.auth.update(user: attributes)
    }
    func fetchUserResumes() async throws -> [UserResume] {
        // 1. Get the user ID from currentUser (which is optional)
        guard let userId = client.auth.currentUser?.id else {
            return [] // Return empty if no user is logged in
        }
        
        // 2. Fetch from Supabase using the renamed UserResume model
        return try await client
            .from("resumes")
            .select()
            // We add a filter to ensure we only get the current user's resumes
            .eq("user_id", value: userId)
            .execute()
            .value
    }
}
