//
//   CoverLetterSheetContent.swift
//   ResumeAIApp
//
//   Created by mac on 5/19/26.
//

import SwiftUI
import RevenueCat
import RevenueCatUI

// MARK: - State Framework Structures
struct CoverLetterUiState {
    var isLoading: Bool = false
    var generatedLetter: String = ""
}

// MARK: - Core View Sheet Layout Component
struct CoverLetterSheetContent: View {
    var onDismiss: () -> Void
    
    // UI state states matching Kotlin collectAsState flows
    @State private var uiState = CoverLetterUiState()
    @State private var jobDescription = ""
    @State private var companyName = ""
    @State private var jobTitle = ""
    @State private var showPaywall = false
    
    // Dark Premium Aesthetics Theme Colors
    private let backgroundColor = Color(red: 0.05, green: 0.05, blue: 0.06)
    private let surfaceColor = Color(red: 0.11, green: 0.11, blue: 0.13)
    private let purpleAccent = Color(red: 0.48, green: 0.12, blue: 0.64) // #7B1FA2
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // --- 1. INPUT FORM STATE ---
                        if !uiState.isLoading && uiState.generatedLetter.isEmpty {
                            JobDescriptionCard(
                                text: $jobDescription,
                                companyName: $companyName,
                                jobTitle: $jobTitle
                            )
                            
                            Button {
                                executeGenerationActionWorkflow()
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                    Text("Generate with AI")
                                }
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(isFormValid ? purpleAccent : Color.gray.opacity(0.2))
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                            }
                            .disabled(!isFormValid)
                        }
                        
                        // --- 2. LOADING ANIMATION STATE ---
                        if uiState.isLoading {
                            VStack(spacing: 16) {
                                ProgressView()
                                    .scaleEffect(1.8)
                                    .progressViewStyle(CircularProgressViewStyle(tint: purpleAccent))
                                    .padding(.top, 40)
                                    .padding(.bottom, 8)
                                  
                                Text("AI is crafting your letter...")
                                    .font(.headline)
                                    .foregroundColor(purpleAccent)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        // --- 3. SELECTION RESULT CONTENT STATE ---
                        if !uiState.generatedLetter.isEmpty {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Generated Cover Letter")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    // Enables native copy-paste selector behavior matching SelectionContainer
                                    TextEditor(text: .constant(uiState.generatedLetter))
                                        .font(.body)
                                        .foregroundColor(.white.opacity(0.9))
                                        .frame(minHeight: 300)
                                        .scrollContentBackground(.hidden)
                                }
                                .padding(16)
                                .background(surfaceColor)
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                                )
                                
                                Button {
                                    resetFormFields()
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "arrow.clockwise")
                                        Text("Start Over")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                    }
                    .padding(16)
                }
            }
            .navigationTitle("AI Cover Letter Engine")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
            
            .sheet(isPresented: $showPaywall) {
                            // FIXED: Replaced raw PaywallView with your custom configuration wrapper
                            RevenueCatPaywallView(onDismiss: {
                                showPaywall = false
                            }, onSuccess: {
                                showPaywall = false
                                // Success closure handler block triggered on safe entitlement authorization verification
                            })
                        }
        }
    }
    
    private var isFormValid: Bool {
        !jobDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !companyName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !jobTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func executeGenerationActionWorkflow() {
        uiState.isLoading = true
        
        Task {
            do {
                // Simulating network edge function generation latency delay
                try await Task.sleep(nanoseconds: 2_000_000_000)
                
                uiState.generatedLetter = """
                Dear Hiring Team at \(companyName),
                
                I am writing to express my enthusiastic interest in the \(jobTitle) position. With my background matched against your specific requirements details, I am excited about delivering high-impact value to your pipeline workflows...
                """
                uiState.isLoading = false
            } catch {
                uiState.isLoading = false
                showPaywall = true
            }
        }
    }
    
    private func resetFormFields() {
        jobDescription = ""
        companyName = ""
        jobTitle = ""
        uiState.generatedLetter = ""
    }
}

// MARK: - Sub-Component Layout Block Frame: JobDescriptionCard
struct JobDescriptionCard: View {
    @Binding var text: String
    @Binding var companyName: String
    @Binding var jobTitle: String
    
    private let surfaceColor = Color(red: 0.11, green: 0.11, blue: 0.13)
    private let purpleAccent = Color(red: 0.48, green: 0.12, blue: 0.64)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            RowHeaderElement(title: "Application Details", icon: "doc.plaintext")
            
            // Company Name Textbox Field
            VStack(alignment: .leading, spacing: 6) {
                Text("Company Name")
                    .font(.caption.bold())
                    .foregroundColor(.gray)
                TextField("e.g. Google, Safaricom", text: $companyName)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
            }
            
            // Job Position Title Field Row
            VStack(alignment: .leading, spacing: 6) {
                Text("Job Position / Title")
                    .font(.caption.bold())
                    .foregroundColor(.gray)
                TextField("e.g. Junior Android Developer", text: $jobTitle)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
            }
            
            // Job Requirements Details Editor Node
            VStack(alignment: .leading, spacing: 6) {
                Text("Job Description")
                    .font(.caption.bold())
                    .foregroundColor(.gray)
                
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Paste the requirements or description details here...")
                            .foregroundColor(.white.opacity(0.25))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                    }
                    
                    // FIXED: Replaced standard TextEditor with standard configuration modifiers to clear background
                    TextEditor(text: $text)
                        .padding(8)
                        .frame(height: 140)
                        .scrollContentBackground(.hidden)
                        .background(Color.black.opacity(0.3))
                        .foregroundColor(.white)
                }
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
            }
        }
        .padding(16)
        .background(surfaceColor)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }
}

// MARK: - Minimal Internal Section Helper Elements
struct RowHeaderElement: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.gray)
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
