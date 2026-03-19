import SwiftUI

struct UploadJobAdView: View {
    @Environment(\.dismiss) var dismiss
    @State private var jobLink = ""
    @State private var jobDescription = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    VStack(spacing: 8) {
                        Image(systemName: "sparkles.rectangle.stack.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.purple.gradient)
                        
                        Text("Target Your Resume")
                            .font(.title2.bold())
                        
                        Text("Provide the job details so our AI can tailor your experience to this specific role.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)

                    // Input Card
                    VStack(spacing: 20) {
                        // Link Input
                        VStack(alignment: .leading, spacing: 8) {
                            // Replaced Label with HStack to fix the initializer error
                            HStack(spacing: 6) {
                                Image(systemName: "link")
                                Text("Job Advert Link")
                            }
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                            
                            TextField("https://company.com/job-post", text: $jobLink)
                                .padding()
                                .background(Color(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.quaternary, lineWidth: 1))
                        }

                        // Modern Divider
                        HStack {
                            Rectangle().frame(height: 1).foregroundStyle(.quaternary)
                            Text("OR").font(.caption2.bold()).foregroundStyle(.tertiary).padding(.horizontal, 8)
                            Rectangle().frame(height: 1).foregroundStyle(.quaternary)
                        }

                        // Text Input
                        VStack(alignment: .leading, spacing: 8) {
                            // Replaced Label here as well for consistency
                            HStack(spacing: 6) {
                                Image(systemName: "doc.text.below.ecg")
                                Text("Paste Job Description")
                            }
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                            
                            TextEditor(text: $jobDescription)
                                .frame(minHeight: 180)
                                .padding(8)
                                .background(Color(UIColor.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(.quaternary, lineWidth: 1))
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(.quaternary, lineWidth: 1))
                    
                    // Action Button
                    Button {
                        print("Start AI analysis")
                    } label: {
                        HStack {
                            Text("Analyze & Tailor CV")
                            Image(systemName: "wand.and.stars")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple) // Use a distinct color for AI actions
                    .controlSize(.large)
                    .disabled(jobLink.isEmpty && jobDescription.isEmpty)
                    
                    Spacer(minLength: 40)
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Job Advert")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    UploadJobAdView()
}
