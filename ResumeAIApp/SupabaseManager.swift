//
//  SupabaseManager.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import Foundation
import Supabase

final class SupabaseManager {
    
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        
        guard
            let urlString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
            let anonKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"],
            let url = URL(string: urlString)
        else {
            fatalError("Supabase environment variables missing")
        }
        
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: anonKey
        )
    }
}
