//
//  ProfileView.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
                // PROFILE HEADER
                Section {
                    
                    HStack(spacing: 16) {
                        
                        Circle()
                            .fill(Color.accentColor.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title2)
                                    .foregroundColor(.accentColor)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("John Doe")
                                .font(.headline)
                            
                            Text("john@email.com")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // ACCOUNT
                Section("Account") {
                    
                    NavigationLink {
                        Text("Edit Profile Page")
                    } label: {
                        Label("Edit Profile", systemImage: "person.crop.circle")
                    }
                    
                    NavigationLink {
                        Text("Subscription Page")
                    } label: {
                        Label("Upgrade to Premium", systemImage: "crown.fill")
                    }
                }
                
                // APP FEATURES
                Section("Resume Tools") {
                    
                    NavigationLink {
                        Text("Saved Resumes")
                    } label: {
                        Label("My Resumes", systemImage: "doc.text")
                    }
                    
                    NavigationLink {
                        Text("ATS Analytics")
                    } label: {
                        Label("ATS Analytics", systemImage: "chart.bar")
                    }
                }
                
                // SETTINGS
                Section("Settings") {
                    
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("App Settings", systemImage: "gearshape")
                    }
                }
                
                // SUPPORT
                Section("Support") {
                    
                    Button {
                        print("Contact support")
                    } label: {
                        Label("Contact Support", systemImage: "message")
                    }
                    
                    Button {
                        print("Privacy")
                    } label: {
                        Label("Privacy Policy", systemImage: "lock")
                    }
                }
                
                // LOGOUT
                Section {
                    
                    Button(role: .destructive) {
                        Task {
                            try? await AuthService.shared.signOut()
                        }
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            
            .navigationTitle("Profile")
        }
    }
}
#Preview {
    ProfileView()
}
