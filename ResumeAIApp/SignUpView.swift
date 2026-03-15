//
//  SignUpView.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Create Account")
                .font(.largeTitle.bold())
            
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button("Sign Up") {
                Task {
                    await signUp()
                }
            }
            .buttonStyle(.borderedProminent)
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
    
    func signUp() async {
        do {
            try await AuthService.shared.signUp(
                email: email,
                password: password
            )
            
            dismiss()
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    SignUpView()
}
