//
//  SettingsView.swift
//  ResumeAIApp
//
//  Created by mac on 3/11/26.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
                Section {
                    
                    Button("Upgrade to Premium") {
                        print("Upgrade tapped")
                    }
                }
                
                Section("Support") {
                    
                    Button("Contact Support") {
                        print("Support tapped")
                    }
                    
                    Button("Privacy Policy") {
                        print("Privacy tapped")
                    }
                }
            }
            
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
