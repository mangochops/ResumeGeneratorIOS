//
//  SignUpView.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isSuccess = false // New state to track success
    
    var body: some View {
        VStack(spacing: 20) {
            if isSuccess {
                // SUCCESS STATE
                VStack(spacing: 20) {
                    Image(systemName: "envelope.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                    
                    Text("Check your email")
                        .font(.largeTitle.bold())
                    
                    Text("We've sent a confirmation link to \n**\(email)**")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    
                    Button("Back to Login") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .padding(.top)
                }
                .transition(.opacity.combined(with: .scale)) // Nice fade-in effect
                
            } else {
                // INPUT STATE (Your original form)
                Text("Create Account")
                    .font(.largeTitle.bold())
                
                TextField("Full Name", text: $fullName)
                                    .textFieldStyle(.roundedBorder)
                                    .textContentType(.name)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Sign Up") {
                    Task {
                        await signUp()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(fullName.isEmpty || email.isEmpty || password.isEmpty)
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
        .padding()
        .animation(.default, value: isSuccess) // Smooth transition between views
    }
    
    func signUp() async {
        do {
            try await AuthService.shared.signUp(
                email: email,
                password: password,
                fullName: fullName
            )
            // Instead of dismissing, show the success state
            isSuccess = true
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    SignUpView()
}
