//
//  SignUpView.swift
//  ResumeAIApp
//
//  Created by mac on 3/14/26.
//

import SwiftUI
import Supabase
import Lottie

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordVisible = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isSuccess = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            if isSuccess {
                // MARK: - SUCCESS STATE
                VStack(spacing: 0) {
                    Spacer()
                    
                    // FIXED: Fallback declaration compatible with standard modern Lottie parameters
                    LottieView(name: "pilot", loopMode: .loop)
                        
                    
                        .frame(width: 220, height: 220)
                    
                    Spacer().frame(height: 16)
                    
                    Text("Check your email")
                        .font(.system(size: 32, weight: .black))
                        .tracking(-0.5)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 8)
                    
                    Text("We've sent a magic confirmation link to\n\(email)")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 24)
                    
                    Spacer().frame(height: 32)
                    
                    Button(action: { dismiss() }) {
                        Text("Back to Login")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                    .buttonStyle(.bordered)
                    .tint(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 16)) // FIXED: Removed duplicate shape struct call
                    
                    Spacer()
                }
                .padding(.horizontal, 28)
                .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
                
            } else {
                // MARK: - INPUT FORM STATE
                ScrollView {
                    VStack(alignment: .center, spacing: 0) {
                        
                        Spacer().frame(height: 40)
                        
                        Text("Create Account")
                            .font(.system(size: 44, weight: .black))
                            .tracking(-1)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple, .pink],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Join CV Pilot and unlock AI-guided optimization")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                            .padding(.bottom, 32)
                        
                        // Full Name Field
                        CustomTextField(
                            value: $fullName,
                            placeholder: "Full Name",
                            systemIcon: "person.fill"
                        )
                        .textContentType(.name)
                        
                        Spacer().frame(height: 16)
                        
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
                        
                        if let errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 8)
                        }
                        
                        Spacer().frame(height: 32)
                        
                        // Main Action Button / Spinner
                        Button(action: {
                            Task {
                                await signUp()
                            }
                        }) {
                            Group {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Sign Up")
                                        .font(.system(size: 16, weight: .bold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(fullName.isEmpty || email.isEmpty || password.isEmpty || isLoading)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        Spacer().frame(height: 24)
                        
                        // Premium Custom Separator Row
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
                        
                        Spacer().frame(height: 24)
                        
                        Button(action: { dismiss() }) {
                            Text("Already have an account? Log In")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        
                        Spacer().frame(height: 20)
                    }
                    .padding(.horizontal, 28)
                }
            }
        }
        .animation(.easeInOut(duration: 0.35), value: isSuccess)
    }
    
    func signUp() async {
        isLoading = true
        errorMessage = nil
        do {
            try await AuthService.shared.signUp(
                email: email,
                password: password,
                fullName: fullName
            )
            isSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - FIXED UI SUB-COMPONENTS

struct CustomTextField: View {
    @Binding var value: String
    let placeholder: String
    let systemIcon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemIcon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            TextField(placeholder, text: $value)
        }
        .padding()
        // FIXED: Using standard native background mapping assets
        .background(Color(.secondarySystemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

struct CustomPasswordField: View {
    // FIXED: Cleaned up token sequence signature
    @Binding var password: String
    @Binding var isVisible: Bool
    let placeholder: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundColor(.blue)
                .frame(width: 24)
            
            if isVisible {
                TextField(placeholder, text: $password)
            } else {
                SecureField(placeholder, text: $password)
            }
            
            Button(action: { isVisible.toggle() }) {
                Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        // FIXED: Normalizing native style overlay properties
        .background(Color(.secondarySystemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

struct RowDivider: View {
    let text: String
    
    var body: some View {
        HStack {
            VStack { Divider().background(Color(.separator)) }
            Text(text)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .tracking(1)
            VStack { Divider().background(Color(.separator)) }
        }
    }
}

struct SSOButton: View {
    let title: String
    let iconName: String
    var isSystemIcon: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isSystemIcon {
                    Image(systemName: iconName)
                        .font(.system(size: 18))
                        .foregroundColor(.primary)
                } else {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .buttonStyle(.plain)
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
}

// NOTE: If you experience compilation problems with this block, delete lines 294-302 completely since it is likely defined in your utility dependencies.


#Preview {
    SignUpView()
}
