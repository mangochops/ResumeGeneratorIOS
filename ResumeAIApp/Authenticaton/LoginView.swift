//
//  LoginView.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import SwiftUI
import Supabase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var passwordVisible = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        
                        Spacer().frame(height: 60)
                        
                        // Premium Brand Gradient Header
                        Text("CV Pilot")
                            .font(.system(size: 44, weight: .black))
                            .tracking(-1)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Optimize your career track with AI guidance")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                            .padding(.bottom, 40)
                        
                        // Email Field
                        CustomTextField(
                            value: $email,
                            placeholder: "Email Address",
                            systemIcon: "envelope.fill"
                        )
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                        
                        Spacer().frame(height: 16)
                        
                        // Password Field with Visibility Toggle
                        CustomPasswordField(
                            password: $password,
                            isVisible: $passwordVisible,
                            placeholder: "Password"
                        )
                        .textContentType(.password)
                        
                        if let errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 8)
                        }
                        
                        Spacer().frame(height: 32)
                        
                        // Main Login / Progress Button
                        Button(action: {
                            Task {
                                await login()
                            }
                        }) {
                            Group {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Log In")
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(email.isEmpty || password.isEmpty || isLoading)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Spacer().frame(height: 24)
                        
                        // Premium Divider Row
                        RowDivider(text: "OR")
                        
                        Spacer().frame(height: 24)
                        
                        // OAuth SSO Buttons Row
                        HStack(spacing: 12) {
                            SSOButton(title: "Google", iconName: "google_logo_asset") {
                                // Trigger Google Identity SSO Flow
                            }
                            
                            SSOButton(title: "Apple", iconName: "apple.logo", isSystemIcon: true) {
                                // Trigger ASAuthorizationController Flow
                            }
                        }
                        
                        Spacer().frame(height: 32)
                        
                        // Navigation Link to SignUpView matching style guide
                        NavigationLink {
                            SignUpView()
                                .navigationBarBackButtonHidden(true) // Keeps look clean; controlled by dismiss
                        } label: {
                            Text("Don't have an account? Sign Up")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                    .padding(.horizontal, 28)
                }
            }
        }
    }
    
    func login() async {
        isLoading = true
        errorMessage = nil
        do {
            try await AuthService.shared.signIn(
                email: email,
                password: password
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - SHARED SYSTEM UI COMPONENTS

// Note: Kept local here for previewing sanity. If these cause duplicate symbols with SignUpView,
// move them to a distinct global shared file like `CommonUIComponents.swift`!






#Preview {
    LoginView()
}
