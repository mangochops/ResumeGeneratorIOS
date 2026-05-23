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
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVvY2xkbXdoZ292Z2RodXR0d2dzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM0NjcwMDQsImV4cCI6MjA4OTA0MzAwNH0.IoX56kW8xSPoxw4pvyfvpZBr7mJCVdl6g47bahFh2YY"
    
    static let revenueCatAPIKey = "test_fQmhDabrxyXbYqUbgnOZjERQgVe"
}
