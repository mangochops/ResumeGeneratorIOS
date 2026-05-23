//
//  Supabase.swift
//  ResumeAIApp
//
//  Created by mac on 3/21/26.
//

import Foundation

enum SupabaseConfig {
    /// Dynamically extracts the Supabase Endpoint URL out of the compiled application package bundle.
    static let url = "https://eocldmwhgovgdhuttwgs.supabase.co"
        
    /// Static hardcoded anonymous client gateway token validation credentials
    static let anonKey = "sb_publishable_25DHcb2BpSRJWVnNWWETg_LzHFvppL"
    
    static let revenueCatAPIKey = "test_fQmhDabrxyXbYqUbgnOZjERQgVe"
}
