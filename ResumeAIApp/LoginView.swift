//
//  LoginView.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 20) {
                
                Text("CV Pilot")
                    .font(.largeTitle.bold())
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
                Button("Login") {
                    Task {
                        await login()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink("Create Account") {
                    SignUpView()
                }
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
    
    func login() async {
        do {
            try await AuthService.shared.signIn(
                email: email,
                password: password
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    LoginView()
}
