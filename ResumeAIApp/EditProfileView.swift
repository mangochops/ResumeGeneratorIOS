//
//  EditProfileView.swift
//  ResumeAIApp
//
//  Created by mac on 3/18/26.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var newPassword = ""
    
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var showSuccessAlert = false

    var body: some View {
        Form {
            Section("Public Profile") {
                TextField("Full Name", text: $fullName)
                    .textContentType(.name)
                
                // Email is usually read-only in a simple profile edit
                // unless you implement a full email-change flow.
                HStack {
                    Text("Email")
                    Spacer()
                    Text(email)
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Security") {
                SecureField("New Password (Optional)", text: $newPassword)
            }
            
            Section {
                Button {
                    Task { await updateProfile() }
                } label: {
                    if isSaving {
                        ProgressView().scaleEffect(0.8)
                    } else {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.bold)
                    }
                }
                .disabled(isSaving)
            }
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Edit Profile")
        .alert("Success", isPresented: $showSuccessAlert) {
                    Button("OK") { dismiss() } // Dismiss only after they see the alert
                } message: {
                    Text("Your profile has been updated successfully.")
                }
        .onAppear {
            // Load current data
            let user = AuthService.shared.currentUser
            self.email = user?.email ?? ""
            self.fullName = user?.userMetadata["full_name"] as? String ?? ""
        }
    }
    
    func updateProfile() async {
        isSaving = true
        errorMessage = nil
        
        do {
            try await AuthService.shared.updateUserProfile(
                fullName: fullName,
                password: newPassword.isEmpty ? nil : newPassword
            )
            showSuccessAlert = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isSaving = false
    }
}

#Preview {
    EditProfileView()
}
