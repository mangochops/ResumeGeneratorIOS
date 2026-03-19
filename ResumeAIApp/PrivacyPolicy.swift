//
//  PrivacyPolicy.swift
//  ResumeAIApp
//
//  Created by mac on 3/19/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        List {
            Section("Data Collection") {
                Text("We collect your email and name to provide personalized resume services. Your data is stored securely using Supabase.")
            }
            
            Section("Resume Data") {
                Text("Resumes generated are your property. We use AI to process data but do not sell your personal information to third parties.")
            }
            
            Section("Security") {
                Text("All communication is encrypted via SSL. We follow industry best practices for data protection.")
            }
            
            Section {
                Link("Full Privacy Policy Online", destination: URL(string: "https://cvpilot.app/privacy")!)
                    .foregroundStyle(.blue)
            }
        }
        .navigationTitle("Privacy Policy")
    }
}

#Preview {
    PrivacyPolicyView()
}
