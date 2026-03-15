//
//  AuthService.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//


import Foundation
import Supabase

final class AuthService {
    
    static let shared = AuthService()
    
    private let client = SupabaseManager.shared.client
    
    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(
            email: email,
            password: password
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
}
