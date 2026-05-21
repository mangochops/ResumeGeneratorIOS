import SwiftUI

struct UploadJobAdView: View {
    // Structural parameters matching Kotlin function signature inputs
    let selectedResumeContent: String
    var onDismiss: () -> Void
    var onSelectResume: () -> Void
    var onShowPaywall: () -> Void
    
    @State private var jobDetails = ""
    @State private var isDownloading = false
    
    // Toast state matching Android Snackbar notifications
    @State private var showToast = false
    @State private var toastMessage = ""
    
    // Luxury Accent Theme
    private let purplePrimary = Color(red: 0.48, green: 0.12, blue: 0.64) // #7B1FA2
    private let backgroundColor = Color(red: 0.05, green: 0.05, blue: 0.06)
    private let surfaceColor = Color(red: 0.11, green: 0.11, blue: 0.13)
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                if isDownloading {
                    // --- STATE A: LOADING MATRIX LOTTIE SUB-HOLDER ---
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(2.0)
                            .progressViewStyle(CircularProgressViewStyle(tint: purplePrimary))
                            .padding(.bottom, 8)
                        
                        Text("Tailoring your experience...")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text("This may take a moment")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // --- STATE B: MAIN INPUT LAYOUT ---
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            // 1. Interactive Resume Selection Status Badge Card
                            ResumeStatusCard(content: selectedResumeContent) {
                                onSelectResume()
                            }
                            
                            // 2. Main Job Details Input Box
                            ZStack(alignment: .topLeading) {
                                if jobDetails.isEmpty {
                                    Text("Paste job details or requirements...")
                                        .foregroundColor(.gray.opacity(0.7))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $jobDetails)
                                    .padding(12)
                                    .frame(height: 250)
                                    .scrollContentBackground(.hidden) // Allows pure color background blending
                                    .background(surfaceColor)
                                    .foregroundColor(.white)
                            }
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(jobDetails.isEmpty ? Color.white.opacity(0.1) : purplePrimary, lineWidth: 1)
                            )
                            
                            // 3. Form Submission Trigger Node Button
                            Button {
                                runTailoringGenerationEngine()
                            } label: {
                                Text("Generate & Download PDF")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        (jobDetails.isEmpty || selectedResumeContent.isEmpty)
                                        ? Color.gray.opacity(0.3)
                                        : purplePrimary
                                    )
                                    .cornerRadius(16)
                            }
                            .disabled(jobDetails.isEmpty || selectedResumeContent.isEmpty)
                        }
                        .padding(24)
                    }
                }
                
                // Overlay Custom Toast Hub Layer matching Snackbar
                if showToast {
                    VStack {
                        Spacer()
                        Text(toastMessage)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color.black.opacity(0.85))
                            .clipShape(Capsule())
                            .shadow(radius: 6)
                            .padding(.bottom, 30)
                    }
                    .animation(.spring(), value: showToast)
                }
            }
            .navigationTitle("AI CV Tailor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // --- API Edge Function Execution & Error Handler Block ---
    private func runTailoringGenerationEngine() {
        isDownloading = true
        
        Task {
            do {
                // Mimicking downloadTailoredResume edge workflow
                try await mockDownloadEndpoint(jobDetails: jobDetails, baseText: selectedResumeContent)
                
                triggerToast(message: "Saved to Downloads!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    onDismiss()
                }
            } catch let error as NSError {
                // 🔐 PAYWALL CHECK: Catches payment required alerts matching Kotlin exceptions
                if error.code == 402 || error.domain.contains("PAYWALL") {
                    isDownloading = false
                    onShowPaywall()
                } else {
                    triggerToast(message: "Error: \(error.localizedDescription)")
                    isDownloading = false
                }
            }
        }
    }
    
    private func triggerToast(message: String) {
        toastMessage = message
        withAnimation { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation { showToast = false }
        }
    }
    
    private func mockDownloadEndpoint(jobDetails: String, baseText: String) async throws {
        try await Task.sleep(nanoseconds: 1_500_000_000) // Simulated delay
        // Set up error code to 402 when testing paywall triggering logic:
        // throw NSError(domain: "PAYWALL", code: 402, userInfo: [NSLocalizedDescriptionKey: "Payment Required"])
    }
}

// MARK: - Sub-Component: Status Badge Card Card Layout

struct ResumeStatusCard: View {
    let content: String
    var onClick: () -> Void
    
    private var isReady: Bool { !content.isEmpty }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isReady ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                .foregroundColor(isReady ? .green : .red)
                .font(.system(size: 22))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(isReady ? "Resume Ready" : "No Resume Selected")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(isReady ? Color(hex: 0x2E7D32) : Color.red)
                
                Text(isReady ? "Targeting your primary CV" : "Tap to choose a resume first")
                    .font(.system(size: 13))
                    .foregroundColor(isReady ? Color(hex: 0x2E7D32).opacity(0.8) : Color.red.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(16)
        .background(isReady ? Color(hex: 0xF3E5F5).opacity(0.15) : Color(hex: 0xFFF1F0).opacity(0.15))
        .cornerRadius(16)
        .onTapGesture { onClick() }
    }
}
