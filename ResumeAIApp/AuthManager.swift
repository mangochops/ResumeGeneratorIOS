//
//  AuthManager.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import Foundation
import Supabase
import SwiftUI

@MainActor
class AuthManager: ObservableObject {
    
    @Published var session: Session?
    @Published var isAuthenticated: Bool = false
    
    private let client = SupabaseManager.shared.client
    
    init() {
        Task {
            await loadSession()
            await listenForAuthChanges()
        }
    }
    
    func loadSession() async {
        session = try? await client.auth.session
        isAuthenticated = session != nil
    }
    
    func listenForAuthChanges() async {
        
        for await state in client.auth.authStateChanges {
            
            switch state.event {
                
            case .signedIn:
                session = state.session
                isAuthenticated = true
                
            case .signedOut:
                session = nil
                isAuthenticated = false
                
            default:
                break
            }
        }
    }
}


